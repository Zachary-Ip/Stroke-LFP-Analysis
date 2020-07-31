% This file detects ripples in LFP files from the pyramidal layer
% Azadeh Yazdan 06/17/16
% Zach Ip 5/21/19
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
load('SpkInfo.mat')
Fs = 1250;
voltScaler = 0.000000015624999960550667;
filePath = 'C:\Users\user\Documents\MATLAB\Data';
ripplePath = 'C:\Users\user\Documents\MATLAB\SPWR\Rip6_Wave3SD';

% define a smoothing kernel
smoothing_width = 0.01; % 300 ms
kernel = gaussian(smoothing_width*Fs, ceil(8*smoothing_width*Fs));
% data = [RipplePower][WavePower][Duration]
R_data = []; R_rippleCount = 0;
L_data = []; L_rippleCount = 0;

% labels = {group}{hemisphere}{animal}
R_labels = {}; R_animalCount = 0;
L_labels = {}; L_animalCount = 0;

for iGroup = [1:4 6]
    for iAnimal = 1:length(SpkInfo{iGroup,2})
        try
            miss = 'R SPWR';
            load([ripplePath filesep SpkInfo{iGroup,1} '_R' num2str(iAnimal) '.mat'])
            rightEvents = SpwrLtdEvents;
            
            miss = 'L SPWR';
            load([ripplePath filesep SpkInfo{iGroup,1} '_L' num2str(iAnimal) '.mat'])
            leftEvents = SpwrLtdEvents;
            
            miss = 'LFP';
            load([filePath filesep SpkInfo{iGroup,1} '_' num2str(iAnimal) '\concatenatedLFP' ]);
        catch
            disp(['Missing ' miss])
            continue
        end
        LFP = cLFP .* voltScaler;
        R_animalCount = R_animalCount +1;
        % Right side
        pyr = LFP(:,SpkInfo{iGroup,2}(iAnimal).R_chn{1,2}(1));
        rad = LFP(:,SpkInfo{iGroup,2}(iAnimal).R_chn{1,2}(1)-3);
        
        [R_data,R_labels,R_rippleCount] = ProcessRipples(R_data,R_labels,R_rippleCount,rightEvents,pyr,rad,'R',SpkInfo,iGroup,R_animalCount);
        
        % Left side
        pyr =  BPfilter(LFP(:,SpkInfo{iGroup,2}(iAnimal).L_chn{1,2}(1)),1250,150,250);
        rad = BPfilter(LFP(:,SpkInfo{iGroup,2}(iAnimal).L_chn{1,2}(1)-3),1250,8,40);
        
        
        [L_data,L_labels,L_rippleCount] = ProcessRipples(L_data,L_labels,L_rippleCount,leftEvents,pyr,rad,'L',SpkInfo,iGroup,L_animalCount);
        
        disp([SpkInfo{iGroup,1} ' ' num2str(iAnimal)])
    end % animal
end % group
%% ONE WAY ANOVA
% Ipsi
L_labels1 = L_labels([1:113 572:1089],:);
L_data1   = L_data([1:113 572:1089],:);

figure
[~,~,PyrPowStats1] = anova1(L_data1(:,1),L_labels1(:,1),'off');
[LPC1,LPM1] = multcompare(PyrPowStats1,'CType','bonferroni');
title('Pyramidal Power')

figure
[~,~,lDurStats1] = anova1(L_data1(:,3),L_labels1(:,1),'off');
[LDC1,LDM1] = multcompare(lDurStats1,'CType','bonferroni');
title('Duration')

%% Contra
R_labels1 = R_labels([1:141 538:1008],:);
R_data1 = R_data([1:141 538:1008],:);

figure
[~,~,PyrPowStats] = anova1(R_data1(:,1),R_labels1(:,1),'off');
[RPC1,RPM1] = multcompare(PyrPowStats,'CType','bonferroni');
title('Pyramidal Power')

figure
[~,~,DurStats1] = anova1(R_data1(:,3),R_labels1(:,1),'off');
[RDC1,RDM1,~,names1] = multcompare(DurStats1,'CType','bonferroni');
title('Duration')
%% 2way ANOVA
% ipsi
L_labels2 = L_labels([1:931 1090:end],4:5);
L_data2 = L_data([1:931 1090:end],:);

[~,~,PyrPowStats2] = anovan(L_data2(:,1),{L_labels2(:,1),L_labels2(:,2)},'Display','off');
[LPC2,LPM2,~,names2] = multcompare(PyrPowStats2,'CType','bonferroni','Dimension',[1 2]);
title('Pyramidal Power')

figure
[~,~,DurStats2] = anovan(L_data2(:,3),{L_labels2(:,1),L_labels2(:,2)},'Display','off');
[LDC2,LDM2] = multcompare(DurStats2,'CType','bonferroni','Dimension',[1 2]);
title('Duration')

%contra 
R_labels2 = R_labels([1:821 1009:end],4:5);
R_data2 = R_data([1:821 1009:end],:);

[~,~,PyrPowStats2] = anovan(R_data2(:,1),{R_labels2(:,1),R_labels2(:,2)},'Display','off');
[RPC2,RPM2] = multcompare(PyrPowStats2,'CType','bonferroni','Dimension',[1 2]);
title('Pyramidal Power')

figure
[~,~,DurStats2] = anovan(R_data2(:,3),{R_labels2(:,1),R_labels2(:,2)},'Display','off');
[RDC2,RDM2] = multcompare(DurStats2,'CType','bonferroni','Dimension',[1 2]);
title('Duration')

save('C:\Users\user\Documents\MATLAB\SPWR\SPWRstats',...
    'LPC1','LPC2','LPM1','LPM2','LDC1','LDC2','LDM1','LDM2',...
    'RPC1','RPC2','RPM1','RPM2','RDC1','RDC2','RDM1','RDM2',...
    'names1','names2')
disp('Done')

function [d,l,ripC] = ProcessRipples(d,l,ripC,SPWRE,p,r,side,Spk,g,a)
for iRipple = 1:size(SPWRE,1)
    
    p1 = p(SPWRE(iRipple,1):SPWRE(iRipple,2));
    r1 = r(SPWRE(iRipple,1):SPWRE(iRipple,2));

    ripC = ripC +1;
    % Pyramidal signal power
    d(ripC,1) = SignalPower(p1,1250);
    % Radiatum signal power 
    d(ripC,2) = SignalPower(r1,1250);
    % Duration
    d(ripC,3) = SPWRE(iRipple,2) - SPWRE(iRipple,1);
    % Inter ripple timing
    if iRipple ~= size(SPWRE,1)
        d(ripC,4) = SPWRE(iRipple+1,1) - SPWRE(iRipple,1);
    else
        d(ripC,4) = NaN;
    end
    % labels
    l{ripC,1} = Spk{g,1};
    l{ripC,2} = side;
    l{ripC,3} = num2str(a);
    switch Spk{g,1}
        case 'Control'
            l{ripC,4} = 'Std';
            l{ripC,5} = 'Ctrl';
        case 'EE Sham'
            l{ripC,4} = 'EE';
            l{ripC,5} = 'Ctrl';
        case '1M Strk'
            l{ripC,4} = 'Std';
            l{ripC,5} = 'Strk';
        case 'EE Strk'
            l{ripC,4} = 'EE';
            l{ripC,5} = 'Strk';
    end
end % iRipple
end