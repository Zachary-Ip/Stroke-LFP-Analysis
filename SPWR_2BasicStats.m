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
        pyr = LFP(:,SpkInfo{iGroup,2}(iAnimal).L_chn{1,2}(1));
        rad = LFP(:,SpkInfo{iGroup,2}(iAnimal).L_chn{1,2}(1)-3);
        
        [L_data,L_labels,L_rippleCount] = ProcessRipples(L_data,L_labels,L_rippleCount,leftEvents,pyr,rad,'L',SpkInfo,iGroup,L_animalCount);
        
        
        disp([SpkInfo{iGroup,1} ' ' num2str(iAnimal)])
    end % animal
end % group
%% Ipsi
figure
[~,~,PyrPowStats] = anova1(L_data(:,1),L_labels(:,1),'off');
[PyrPowMult,pm] = multcompare(PyrPowStats,'CType','bonferroni');
title('Pyramidal Power')

figure
[~,~,RadPowStats] = anova1(L_data(:,2),L_labels(:,1),'off');
[RadPowMult,rm] = multcompare(RadPowStats,'CType','bonferroni');
title('Radiatum Power')

figure
[~,~,DurStats] = anova1(L_data(:,3),L_labels(:,1),'off');
[DurMult,dm] = multcompare(DurStats,'CType','bonferroni');
title('Duration')

figure
[~,~,TimStats] = anova1(L_data(:,4),L_labels(:,1),'off');
[TimMult,tm] = multcompare(TimStats,'CType','bonferroni');
title('Inter-SPWR timing')
%% Contra
figure
[~,~,PyrPowStats] = anova1(R_data(:,1),R_labels(:,1),'off');
[PyrPowMult,pm] = multcompare(PyrPowStats,'CType','bonferroni');
title('Pyramidal Power')

figure
[~,~,RadPowStats] = anova1(R_data(:,2),R_labels(:,1),'off');
[RadPowMult,rm] = multcompare(RadPowStats,'CType','bonferroni');
title('Radiatum Power')

figure
[~,~,DurStats] = anova1(R_data(:,3),R_labels(:,1),'off');
[DurMult,dm] = multcompare(DurStats,'CType','bonferroni');
title('Duration')

figure
[~,~,TimStats] = anova1(R_data(:,4),R_labels(:,1),'off');
[TimMult,tm] = multcompare(TimStats,'CType','bonferroni');
title('Inter-SPWR timing')

%% 
SpwrDataTbl = table(R_data(:,1),R_data(:,2),R_data(:,3),R_data(:,4),R_labels(:,1),R_labels(:,2),R_labels(:,3),...
              'VariableNames',{'PyrPower','RadPower','Dur','TrialTime','Group','Hem','Animal'});
save('C:\Users\user\Documents\MATLAB\SPWR\SPWRstats','SpwrDataTbl','PyrPowMult','pm','RadPowMult','rm','DurMult','dm')
disp('Done')

function [d,l,ripC] = ProcessRipples(d,l,ripC,SPWRE,p,r,side,Spk,g,a)
for iRipple = 1:size(SPWRE,1)
    p1 = BPfilter(p(SPWRE(iRipple,1):SPWRE(iRipple,2)),1250,150,250);
    r1 = BPfilter(r(SPWRE(iRipple,1):SPWRE(iRipple,2)),1250,8,40);
%         subplot(2,1,1)
%         plot(p1)
%         subplot(2,1,2)
%         plot(r1)
%         pause(0.3)
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
    %%%
    % labels
    l{ripC,1} = Spk{g,1};
    l{ripC,2} = side;
    l{ripC,3} = num2str(a);
end % iRipple
end