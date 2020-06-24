% This code will take the CSD arrays and align them to the pyramidal layer.
% Then it will average them and show one CSD for each group. Also I'll mess
% around with some PCA stuff here I guess? I'll see if I can not crash my
% computer doing this
clear all
LFP_path = 'C:\Users\user\Documents\MATLAB\Data'; % data path
Fs = 1250;
voltScaler = 0.000000015624999960550667;
load('SpkInfo.mat')
load('Colors.mat')
hotcold = redblue; % Create a custom red-white-blue colormap
electrodes = 1:14; % create manual index of electrodes for plotting
time = linspace(-1,1,2501); % create manual index of time for plotting
ysize = linspace(-6e+03, 2e+03,10); % Create manual scale bar for plotting

% Initialize StatBlock to hold the results for all ripples

for iGroup = [1:4 6] % For each experimental setup
    cd(LFP_path)
    disp(SpkInfo{iGroup,1}) %Readout
    
    groupFiles = dir([SpkInfo{iGroup,1} '*']);
    
    lTotalCsd = zeros(2501,length(electrodes));
    lTotalWeight = 0;
    
    lPre = [];
    lRip = [];
    lPost = [];
    
    rPre = [];
    rRip = [];
    rPost = [];
    
    rTotalCsd = zeros(2501,length(electrodes));
    rTotalWeight = 0;
    for jAnimal = 1:length(groupFiles)
        cd(groupFiles(jAnimal).name)
        try
            load('LTD SPWR CSD L.mat');
            load('LTD SPWR CSD R.mat');
        catch
            disp('No CSD File')
            cd ..
            continue
        end
        if isempty(leftCsd) || isempty(rightCsd)
            disp('Empty data file')
            cd ..
            continue
        end
        try
            lPyramidalChannel = SpkInfo{iGroup,2}(jAnimal).L_chn{2}(1);
            rPyramidalChannel = SpkInfo{iGroup,2}(jAnimal).R_chn{2}(1)-16;
        catch
            disp('Bad Channel');
            cd ..
            continue
        end
        try
            iLData = leftCsd(:,lPyramidalChannel-5:lPyramidalChannel+8,:);
            iRData = rightCsd(:,rPyramidalChannel-5:rPyramidalChannel+8,:);
        catch
            disp(['Error for: L' num2str(lPyramidalChannel)])
            disp(['Error for: R' num2str(rPyramidalChannel)])
            cd ..
            continue
        end
        
        % grab and store the values from the windows
        lPre = SSA(lPre, squeeze(iLData(1:500,:,:)));
        lRip = SSA(lRip, squeeze(iLData(1250:1500,:,:)));
        lPost = SSA(lPost, squeeze(iLData(2001:end,:,:)));
        
        rPre = SSA(rPre, squeeze(iRData(1:500,:,:)));
        rRip = SSA(rRip, squeeze(iRData(1250:1500,:,:)));
        rPost = SSA(rPost, squeeze(iRData(2001:end,:,:)));
        
        lTotalWeight = lTotalWeight +size(iLData,3);
        lTotalCsd = lTotalCsd + sum(iLData,3);
        
        rTotalWeight = rTotalWeight + size(iRData,3);
        rTotalCsd = rTotalCsd + sum(iRData,3);
        
        cd ..
    end % Animals
    lTotalCsd = lTotalCsd ./ lTotalWeight;
    rTotalCsd = rTotalCsd ./ rTotalWeight;
    
    %     % calculate standard error
    SE = @(data) std(data)./sqrt(length(data));
    %
    StatBlock.lPre(1:length(lPre),iGroup) = lPre;
    StatBlock.lRip(1:length(lRip),iGroup) = lRip;
    StatBlock.lPost(1:length(lPost),iGroup) = lPost;
    
    StatBlock.rPre(1:length(rPre),iGroup) = rPre;
    StatBlock.rRip(1:length(rRip),iGroup) = rRip;
    StatBlock.rPost(1:length(rPost),iGroup) = rPost;
    
    BarInfo(iGroup).lCsd = lTotalCsd;
    BarInfo(iGroup).rCsd = rTotalCsd;
    
    BarInfo(iGroup).lPreMean = mean(lPre);
    BarInfo(iGroup).lRipMean = mean(lRip);
    BarInfo(iGroup).lPostMean = mean(lPost);
    
    BarInfo(iGroup).rPreMean = mean(rPre);
    BarInfo(iGroup).rRipMean = mean(rRip);
    BarInfo(iGroup).rPostMean = mean(rPost);
    
    BarInfo(iGroup).lPreSE = SE(lPre);
    BarInfo(iGroup).lRipSE = SE(lRip);
    BarInfo(iGroup).lPostSE = SE(lPost);
    
    BarInfo(iGroup).rPreSE = SE(rPre);
    BarInfo(iGroup).rRipSE = SE(rRip);
    BarInfo(iGroup).rPostSE = SE(rPost);
    switch iGroup
        case 1
            tempGroup = iGroup;
            plot_color = RGB.mlBlue;
        case 2
            tempGroup = iGroup;
            plot_color = RGB.mlPurple;
        case   3
            tempGroup = 4;
            plot_color = RGB.mlOrange;
        case   4
            tempGroup = 3;
            plot_color = RGB.mlYellow;
        case 6
            tempGroup = iGroup;
            plot_color = RGB.mlRed;
    end
    
end % end group

%% Set 0's in data to NaNs so they don't effect stat test
StatBlock.lPre(StatBlock.lPre == 0) = NaN;
StatBlock.lRip(StatBlock.lRip == 0) = NaN;
StatBlock.lPost(StatBlock.lPost == 0) = NaN;

StatBlock.rPre(StatBlock.rPre == 0) = NaN;
StatBlock.rRip(StatBlock.rRip == 0) = NaN;
StatBlock.rPost(StatBlock.rPost == 0) = NaN;

labels = {'Control','EEC','2WS','1MS','null','EES'};
[~,~,lPreStats] = anova1(StatBlock.lPre,labels, 'off');
[~,~,lRipStats] = anova1(StatBlock.lRip,labels, 'off');
[~,~,lPostStats] = anova1(StatBlock.lPost,labels, 'off');

[~,~,rPreStats] = anova1(StatBlock.rPre,labels,'off');
[~,~,rRipStats] = anova1(StatBlock.rRip,labels,'off');
[~,~,rPostStats] = anova1(StatBlock.rPost,labels,'off');

[lPreC,lPreM] = multcompare(lPreStats,'CType','bonferroni');
[lRipC,lRipM] = multcompare(lRipStats,'CType','bonferroni');
[lPostC,lPostM] = multcompare(lPostStats,'CType','bonferroni');

[rPreC,rPreM] = multcompare(rPreStats,'CType','bonferroni');
[rRipC,rRipM] = multcompare(rRipStats,'CType','bonferroni');
[rPostC,rPostM] = multcompare(rPostStats,'CType','bonferroni');

save('C:\Users\user\Documents\MATLAB\Data\CSD Stats.mat','BarInfo','lPreC',...
    'lPreM','lRipC','lRipM','lPostC','lPostM','rPreC','rPreM','rRipC','rRipM',...
    'rPostC','rPostM')
disp('Im really feeling it!')
function [storage] = SSA(storage, data)
% This function calculates the peak and trough of a source-sink pair
% (currently hard coded) from a CSD and concatenates results into a input
% stoarage vector which it then returns.
for i = 1:size(data,3)
    peak = max(max(data(:,:,i)));
    trough = min(min(data(:,:,i)));
    amplitude = peak - trough;
    storage = [storage amplitude];
end
end
