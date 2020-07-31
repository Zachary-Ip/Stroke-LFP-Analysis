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
a2nums.lPre = [];
a2nums.lRip = [];
a2nums.lPost = [];

a2nums.rPre = [];
a2nums.rRip = [];
a2nums.rPost = [];

labels2 = [];

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
    switch iGroup
        case 1
            state = 'Ctrl';
            treat = 'Std';
        case 2
            state = 'Ctrl';
            treat = 'EE';
        case 3
            state = 'Strk';
            treat = 'Std';
        case 4
            state = 'Strk';
            treat = 'EE';
    end
    
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
  
    if iGroup == 1 || iGroup == 3 || iGroup == 4
        StatBlock.lPre(1:length(lPre),iGroup) = lPre;
        StatBlock.lRip(1:length(lRip),iGroup) = lRip;
        StatBlock.lPost(1:length(lPost),iGroup) = lPost;
        
        StatBlock.rPre(1:length(rPre),iGroup) = rPre;
        StatBlock.rRip(1:length(rRip),iGroup) = rRip;
        StatBlock.rPost(1:length(rPost),iGroup) = rPost;
    end
    
    if iGroup == 1 || iGroup == 2 || iGroup == 3 || iGroup == 6
        a2nums.lPre = [a2nums.lPre lPre];
        a2nums.lRip = [a2nums.lRip lRip];
        a2nums.lPost = [a2nums.lPost lPost];
        
        a2nums.rPre = [a2nums.rPre lPre];
        a2nums.rRip = [a2nums.rRip lRip];
        a2nums.rPost = [a2nums.rPost lPost];
        
        labels2 = [labels2; repmat({treat,state},length(lPre),1)];
    end
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

labels = {'Control','null','2WS','1MS'};
[~,~,lPreStats1] = anova1(StatBlock.lPre,labels, 'off');
[~,~,lRipStats1] = anova1(StatBlock.lRip,labels, 'off');
[~,~,lPostStats1] = anova1(StatBlock.lPost,labels, 'off');

[~,~,rPreStats1] = anova1(StatBlock.rPre,labels,'off');
[~,~,rRipStats1] = anova1(StatBlock.rRip,labels,'off');
[~,~,rPostStats1] = anova1(StatBlock.rPost,labels,'off');

[~,~,lPreStats2] = anovan(a2nums.lPre,{labels2(:,1),labels2(:,2)}, 'Display','off');
[~,~,lRipStats2] = anovan(a2nums.lRip,{labels2(:,1),labels2(:,2)}, 'Display','off');
[~,~,lPostStats2] = anovan(a2nums.lPost,{labels2(:,1),labels2(:,2)}, 'Display','off');

[~,~,rPreStats2] = anovan(a2nums.rPre,{labels2(:,1),labels2(:,2)},'Display','off');
[~,~,rRipStats2] = anovan(a2nums.rRip,{labels2(:,1),labels2(:,2)},'Display','off');
[~,~,rPostStats2] = anovan(a2nums.rPost,{labels2(:,1),labels2(:,2)},'Display','off');

[lPreC1,lPreM1] = multcompare(lPreStats1,'CType','bonferroni');
[lRipC1,lRipM1] = multcompare(lRipStats1,'CType','bonferroni');
[lPostC1,lPostM1] = multcompare(lPostStats1,'CType','bonferroni');

[rPreC1,  rPreM1] = multcompare(rPreStats1,'CType','bonferroni');
[rRipC1,  rRipM1] = multcompare(rRipStats1,'CType','bonferroni');
[rPostC1,rPostM1,~,names1] = multcompare(rPostStats1,'CType','bonferroni');

[lPreC2,  lPreM2] = multcompare(lPreStats2,'CType','bonferroni','Dimension', [1 2]);
[lRipC2,  lRipM2] = multcompare(lRipStats2,'CType','bonferroni','Dimension', [1 2]);
[lPostC2,lPostM2] = multcompare(lPostStats2,'CType','bonferroni','Dimension', [1 2]);

[rPreC2,  rPreM2] = multcompare(rPreStats2,'CType','bonferroni','Dimension', [1 2]);
[rRipC2,  rRipM2] = multcompare(rRipStats2,'CType','bonferroni','Dimension', [1 2]);
[rPostC2,rPostM2,~,names2] = multcompare(rPostStats2,'CType','bonferroni','Dimension', [1 2]);

save('C:\Users\user\Documents\MATLAB\Data\CSD Stats.mat','BarInfo',...
    'lPreC1','lPreM1','lRipC1','lRipM1','lPostC1','lPostM1','rPreC1','rPreM1','rRipC1','rRipM1','rPostC1','rPostM1',...
    'lPreC2','lPreM2','lRipC2','lRipM2','lPostC2','lPostM2','rPreC2','rPreM2','rRipC2','rRipM2','rPostC2','rPostM2',...
    'names1','names2');
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
