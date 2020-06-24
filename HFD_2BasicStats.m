j% This file detects ripples in LFP files from the pyramidal layer
% Azadeh Yazdan 06/17/16
% Zach Ip 5/21/19
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
load('SpkInfo.mat')
Fs = 1250;
voltScaler = 0.000000015624999960550667;
filePath = 'C:\Users\user\Documents\MATLAB\Data';
hfdPath = 'C:\Users\user\Documents\MATLAB\SPWR\HFD';
% define a smoothing kernel
smoothing_width = 0.01; % 300 ms
kernel = gaussian(smoothing_width*Fs, ceil(8*smoothing_width*Fs));
% data = [RipplePower][WavePower][Duration]
R_data = []; R_hfdCount = 0;
L_data = []; L_hfdCount = 0;

% labels = {group}{hemisphere}{animal}
R_labels = {}; R_animalCount = 0;
L_labels = {}; L_animalCount = 0;

for iGroup = [1:4 6]
    for iAnimal = 1:length(SpkInfo{iGroup,2})
        try
            miss = 'R HFD';
            load([hfdPath filesep SpkInfo{iGroup,1} '_R' num2str(iAnimal) '.mat'])
            rightEvents = hfdEvents;
            
            miss = 'L HFD';
            load([hfdPath filesep SpkInfo{iGroup,1} '_L' num2str(iAnimal) '.mat'])
            leftEvents = hfdEvents;
            
            miss = 'LFP';
            load([filePath filesep SpkInfo{iGroup,1} '_' num2str(iAnimal) '\concatenatedLFP' ]);
        catch
            disp(['Missing ' miss])
            continue
        end
        LFP = cLFP .* voltScaler;
        R_animalCount = R_animalCount +1;
        L_animalCount = L_animalCount +1;
        
        % Right side
        pyr = LFP(:,SpkInfo{iGroup,2}(iAnimal).R_chn{1,2}(1));
        
        [R_data,R_labels,R_hfdCount] = ProcessRipples(R_data,R_labels,R_hfdCount,rightEvents,pyr,'R',SpkInfo,iGroup,R_animalCount);
        
        % Left side
        pyr = LFP(:,SpkInfo{iGroup,2}(iAnimal).L_chn{1,2}(1));
        
        [L_data,L_labels,L_hfdCount] = ProcessRipples(L_data,L_labels,L_hfdCount,leftEvents,pyr,'L',SpkInfo,iGroup,L_animalCount);
        
        
        disp([SpkInfo{iGroup,1} ' ' num2str(iAnimal)])
    end % animal
end % group


%% Ipsi
figure
[~,~,PyrPowStats] = anova1(L_data(:,1),L_labels(:,1),'off');
[lPyrPowMult,lpm] = multcompare(PyrPowStats,'CType','bonferroni');
title('Ipsi Pyramidal Power')

figure
[~,~,DurStats] = anova1(L_data(:,3),L_labels(:,1),'off');
[lDurMult,ldm] = multcompare(DurStats,'CType','bonferroni');
title('Ipsi Duration')

figure
[~,~,TimStats] = anova1(L_data(:,4),L_labels(:,1),'off');
[TimMult,tm] = multcompare(TimStats,'CType','bonferroni');
title('Ipsi Inter-SPWR timing')
%% Contra
figure
[~,~,PyrPowStats] = anova1(R_data(:,1),R_labels(:,1),'off');
[rPyrPowMult,rpm] = multcompare(PyrPowStats,'CType','bonferroni');
title('Contra Pyramidal Power')

figure
[~,~,DurStats] = anova1(R_data(:,3),R_labels(:,1),'off');
[rDurMult,rdm] = multcompare(DurStats,'CType','bonferroni');
title('Contra Duration')

figure
[~,~,TimStats] = anova1(R_data(:,4),R_labels(:,1),'off');
[TimMult,tm] = multcompare(TimStats,'CType','bonferroni');
title('Contra Inter-SPWR timing')

%% 
HfdDataTbl = table(R_data(:,1),R_data(:,2),R_data(:,3),R_data(:,4),R_labels(:,1),R_labels(:,2),R_labels(:,3),...
              'VariableNames',{'PyrPower','RadPower','Dur','TrialTime','Group','Hem','Animal'});
save('C:\Users\user\Documents\MATLAB\SPWR\HFDstats','HfdDataTbl','rDurMult','lDurMult','rdm','ldm','lpm','rpm','lPyrPowMult','rPyrPowMult')
disp('Done')
%% Look at counts

HFD_R = countRipples(R_labels);
%%
HFD_L = countRipples(L_labels);
disp('Complete')
%%
function [d,l,ripC] = ProcessRipples(d,l,ripC,hfd,p,side,Spk,g,a)
for iRipple = 1:size(hfd,1)
    p1 = BPfilter(p(hfd(iRipple,1):hfd(iRipple,2)),1250,250,400);
    ripC = ripC +1;
    % Pyramidal signal power
    
    d(ripC,1) = SignalPower(p1,1250);
    % Duration
    d(ripC,3) = hfd(iRipple,2) - hfd(iRipple,1);
    % Inter ripple timing
    if iRipple ~= size(hfd,1)
        d(ripC,4) = hfd(iRipple+1,1) - hfd(iRipple,1);
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

function [multi] = countRipples(data)
animalIdx = 1;
groupIdx = 1;
animalCache = data{1,3};
groupCache = data{1,1};
matrix = zeros(12,5);
for i = 1:size(data,1)
    if ~strcmp(data{i,1},groupCache)
        groupIdx = groupIdx +1;
        groupCache = data{i,1};
        animalIdx = 1;
        animalCache = data{i,3};
    elseif ~strcmp(data{i,3},animalCache)
        animalIdx = animalIdx +1;
        animalCache = data{i,3};
    end
    matrix(animalIdx,groupIdx) = matrix(animalIdx,groupIdx) +1;
end
groups = {'Control','EEC','1MS','2WS','EES'};
matrix(matrix == 0) = NaN;
[~,~,Stats] = anova1(matrix, groups,'off');
multi = multcompare(Stats, 'CType', 'bonferroni');

end
