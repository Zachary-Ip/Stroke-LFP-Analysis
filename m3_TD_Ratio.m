% Calculate and save average length of state, number of state changes, and
% ratio of HTD to LTD. Run 1-way and 2-way ANOVAs

% Load relevant reference data
load('SpkInfo.mat')

% Initialize labels for ANOVA testing
nStroke = cell(1,40);
nEE = cell(1,40);

lltdStroke = cell(1,239);
lltdEE = cell(1,239);

rltdStroke = cell(1,263);
rltdEE = cell(1,263);

rltdStroke = cell(1,263);
rltdEE = cell(1,263);

lhtdStroke = cell(1,279);
lhtdEE = cell(1,279);

rhtdStroke = cell(1,303);
rhtdEE = cell(1,303);

[nStroke,nEE] = labelMaker(9,0,nStroke,nEE,'Control','Std');
[nStroke,nEE] = labelMaker(10,9,nStroke,nEE,'Control','EE');
[nStroke,nEE] = labelMaker(11,19,nStroke,nEE,'Stroke','Std');
[nStroke,nEE] = labelMaker(10,30,nStroke,nEE,'Stroke','EE');

[lltdStroke,lltdEE] = labelMaker(28,0,lltdStroke,lltdEE,'Control','Std');
[lltdStroke,lltdEE] = labelMaker(53,28,lltdStroke,lltdEE,'Control','EE');
[lltdStroke,lltdEE] = labelMaker(76,81,lltdStroke,lltdEE,'Stroke','Std');
[lltdStroke,lltdEE] = labelMaker(82,157,lltdStroke,lltdEE,'Stroke','EE');

[lhtdStroke,lhtdEE] = labelMaker(37,0,lhtdStroke,lhtdEE,'Control','Std');
[lhtdStroke,lhtdEE] = labelMaker(63,37,lhtdStroke,lhtdEE,'Control','EE');
[lhtdStroke,lhtdEE] = labelMaker(87,100,lhtdStroke,lhtdEE,'Stroke','Std');
[lhtdStroke,lhtdEE] = labelMaker(92,187,lhtdStroke,lhtdEE,'Stroke','EE');

[rhtdStroke,rhtdEE] = labelMaker(42,0,rhtdStroke,rhtdEE,'Control','Std');
[rhtdStroke,rhtdEE] = labelMaker(60,42,rhtdStroke,rhtdEE,'Control','EE');
[rhtdStroke,rhtdEE] = labelMaker(111,102,rhtdStroke,rhtdEE,'Stroke','Std');
[rhtdStroke,rhtdEE] = labelMaker(90,213,rhtdStroke,rhtdEE,'Stroke','EE');

[rltdStroke,rltdEE] = labelMaker(33,0,rltdStroke,rltdEE,'Control','Std');
[rltdStroke,rltdEE] = labelMaker(50,33,rltdStroke,rltdEE,'Control','EE');
[rltdStroke,rltdEE] = labelMaker(100,83,rltdStroke,rltdEE,'Stroke','Std');
[rltdStroke,rltdEE] = labelMaker(80,183,rltdStroke,rltdEE,'Stroke','EE');

% Initialize counter for inserting data correctly for anova testing
counter = 0;

for i = 1:4
    results1way(i).lNum = [];
    results1way(i).lHtd = [];
    results1way(i).lLtd = [];
    results1way(i).lR   = [];
    
    results1way(i).rNum = [];
    results1way(i).rHtd = [];
    results1way(i).rLtd = [];
    results1way(i).rR = [];
end

results2way.lNum = [];
results2way.lHtd = [];
results2way.lLtd = [];
results2way.lR   = [];

results2way.rNum = [];
results2way.rHtd = [];
results2way.rLtd = [];
results2way.rR   = [];

% Pull and process data
for group = [1:4 6]
    % 1.Load the right and left side signals
    %     load H/L TD indexes
    for animal = 1: length(SpkInfo{group,2})
        % Define filepath to pull from
        REM = ['C:\Users\user\Documents\MATLAB\Data' filesep SpkInfo{group,1} '_' num2str(animal) filesep 'cREM.mat'];
        
        % Error checking and exceptions for missing files
        try
            load(REM);
        catch
            disp('Missing REM File')
            continue
        end
        if isempty(cREM.R.start) || isempty(cREM.R.end)
            disp('Missing REM Start or End Times for Right Side')
            cd ..
            continue
        end
        if isempty(cREM.L.start) || isempty(cREM.L.end)
            disp('Missing REM Start or End Times for Left Side')
            cd ..
            continue
        end
        % REM loaded correctly, process
        % 2way ANOVA
        % only handle controls and 1MS groups
        if group == 1 || group == 2 || group == 3 || group == 6
            results2way = analyze(cREM.R, results2way, 'R');
            results2way = analyze(cREM.L, results2way, 'L');
        end
        
        % 1way ANOVA
        % only handle non EE groups
        if group == 1 || group == 3 || group == 4
            results1way(group) = analyze(cREM.R, results1way(group), 'R');
            results1way(group) = analyze(cREM.L, results1way(group), 'L');
        end
    end % animal
end % group
% ONE WAY ANOVA
lHtd = NaN(87,3);
lHtd(1:length(results1way(1).lHtd),1) = results1way(1).lHtd;
lHtd(1:length(results1way(4).lHtd),2) = results1way(4).lHtd;
lHtd(1:length(results1way(3).lHtd),3) = results1way(3).lHtd;

rHtd = NaN(111,3);
rHtd(1:length(results1way(1).rHtd),1) = results1way(1).rHtd;
rHtd(1:length(results1way(4).rHtd),2) = results1way(4).rHtd;
rHtd(1:length(results1way(3).rHtd),3) = results1way(3).rHtd;

rLtd = NaN(100,3);
rLtd(1:length(results1way(1).rLtd),1) = results1way(1).rLtd;
rLtd(1:length(results1way(4).rLtd),2) = results1way(4).rLtd;
rLtd(1:length(results1way(3).rLtd),3) = results1way(3).rLtd;

lLtd = NaN(76,3);
lLtd(1:length(results1way(1).lLtd),1) = results1way(1).lLtd;
lLtd(1:length(results1way(4).lLtd),2) = results1way(4).lLtd;
lLtd(1:length(results1way(3).lLtd),3) = results1way(3).lLtd;

lNum = NaN(11,3);
lNum(1:length(results1way(1).lNum),1) = results1way(1).lNum;
lNum(1:length(results1way(4).lNum),2) = results1way(4).lNum;
lNum(1:length(results1way(3).lNum),3) = results1way(3).lNum;

rNum = NaN(11,3);
rNum(1:length(results1way(1).rNum),1) = results1way(1).rNum;
rNum(1:length(results1way(4).rNum),2) = results1way(4).rNum;
rNum(1:length(results1way(3).rNum),3) = results1way(3).rNum;

lR = NaN(11,3);
lR(1:length(results1way(1).lR),1) = results1way(1).lR;
lR(1:length(results1way(4).lR),2) = results1way(4).lR;
lR(1:length(results1way(3).lR),3) = results1way(3).lR;

rR = NaN(11,3);
rR(1:length(results1way(1).rR),1) = results1way(1).rR;
rR(1:length(results1way(4).rR),2) = results1way(4).rR;
rR(1:length(results1way(3).rR),3) = results1way(3).rR;

labels = {'Ctrl','2WS','1MS'};

[~,~,lHtdS1] = anova1(lHtd, labels,'off');
[~,~,lLtdS1] = anova1(lLtd, labels,'off');
[~,~,rHtdS1] = anova1(rHtd, labels,'off');
[~,~,rLtdS1] = anova1(rLtd,labels,'off');
[~,~,lNumS1] = anova1(lNum, labels,'off');
[~,~,rNumS1] = anova1(rNum, labels,'off');
[~,~,lRS1]   = anova1(lR, labels,'off');
[~,~,rRS1]   = anova1(rR, labels,'off');

[lHtdC1,lHtdM1,~,lHtdN1]   = multcompare(lHtdS1,'CType','bonferroni','Display','off');
[lLtdC1,lLtdM1,~,lLtdN1]   = multcompare(lLtdS1,'CType','bonferroni','Display','off');
[rHtdC1,rHtdM1,~,rHtdN1]   = multcompare(rHtdS1,'CType','bonferroni','Display','off');
[rLtdC1,rLtdM1,~,rLtdN1]   = multcompare(rLtdS1,'CType','bonferroni','Display','off');
[lNumC1,lNumM1,~,lNumN1]   = multcompare(lNumS1,'CType','bonferroni','Display','off');
[rNumC1,rNumM1,~,rNumN1]   = multcompare(rNumS1,'CType','bonferroni','Display','off'); 
[lRC1,lRM1,~,lRN1]         = multcompare(lRS1,'CType','bonferroni','Display','off')  ;
[rRC1,rRM1,~,rRN1]         = multcompare(rRS1,'CType','bonferroni','Display','off')  ;



% % TWO WAY ANOVA
[~,alHtdT2,lHtdS2] = anovan(results2way.lHtd, {lhtdStroke,lhtdEE},'model','interaction','display','off');
[~,alLtdT2,lLtdS2] = anovan(results2way.lLtd, {lltdStroke,lltdEE},'model','interaction','display','off');
[~,arHtdT2,rHtdS2] = anovan(results2way.rHtd, {rhtdStroke,rhtdEE},'model','interaction','display','off');
[~,arLtdT2,rLtdS2] = anovan(results2way.rLtd, {rltdStroke,rltdEE},'model','interaction','display','off');
[~,alNumT2,lNumS2] = anovan(results2way.lNum, {nStroke,nEE},'model','interaction','display','off');
[~,arNumT2,rNumS2] = anovan(results2way.rNum, {nStroke,nEE},'model','interaction','display','off');
[~,alRT2,lRS2] = anovan(results2way.lR,   {nStroke,nEE},'model','interaction','display','off');
[~,arRTs,rRS2] = anovan(results2way.rR,   {nStroke,nEE},'model','interaction','display','off');

[lHtdC2,lHtdM2,~,lHtdN2] = multcompare(lHtdS2,'dimension',[1 2],'CType','bonferroni','Display','off');
[lLtdC2,lLtdM2,~,lLtdN2] = multcompare(lLtdS2,'dimension',[1 2],'CType','bonferroni','Display','off');
[rHtdC2,rHtdM2,~,rHtdN2] = multcompare(rHtdS2,'dimension',[1 2],'CType','bonferroni','Display','off');
[rLtdC2,rLtdM2,~,rLtdN2] = multcompare(rLtdS2,'dimension',[1 2],'CType','bonferroni','Display','off');
[lNumC2,lNumM2,~,lNumN2] = multcompare(lNumS2,'dimension',[1 2],'CType','bonferroni','Display','off');
[rNumC2,rNumM2,~,rNumN2] = multcompare(rNumS2,'dimension',[1 2],'CType','bonferroni','Display','off');
[lRC2,lRM2,~,lRN2] = multcompare(lRS2,'dimension',[1 2],'CType','bonferroni','Display','off');
[rRC2,rRM2,~,rRN2] = multcompare(rRS2,'dimension',[1 2],'CType','bonferroni','Display','off');

disp('Saving...')
save('C:\Users\user\Documents\MATLAB\Stats\State\FullStats.mat',...
     'lHtdC2','lHtdM2','lHtdN2','lLtdC2','lLtdM2','lLtdN2','rHtdC2','rHtdM2','rHtdN2',...
     'rLtdC2','rLtdM2','rLtdN2','lNumC2','lNumM2','lNumN2','rNumC2','rNumM2','rNumN2',...
     'lRC2','lRM2','lRN2','rRC2','rRM2','rRN2','lHtdC1','lHtdM1','lHtdN1',...
     'lLtdC1','lLtdM1','lLtdN1','rHtdC1','rHtdM1','rHtdN1','rLtdC1','rLtdM1','rLtdN1',...
     'lNumC1','lNumM1','lNumN1','rNumC1','rNumM1','rNumN1','lRC1','lRM1','lRN1',...
     'rRC1','rRM1','rRN1');
disp('HAH! GOTEEEM')




function [d] = analyze(times,d,side)
% This function takes in a struct with two fields, start and end
% and calculates length of state (HTD), ratio of HTD to LTD, and
% number of states

% initialize state length storage variables
htd = [];
ltd = [];

% Calculate state length
for iT = 1:length(times.start)
    % subtract end time (i) from start time (i) to find each length
    % of on state
    htd = [htd (times.end(iT)-times.start(iT))];
    
    % subtract start time (i) from end time (i-1) to find each length
    % of off state. At i = 1, start at 0.
    if iT == 1
        ltd = ltd + times.start(iT);
    else
        ltd = [ltd (times.start(iT) - times.end(iT-1))];
    end
end

perc = sum(htd)/(sum(htd)+sum(ltd));
if length(times.start) == length(times.end)
    s = length(times.start);
else
    disp('Start and end lengths differ');
end
switch side
    case 'L'
        d.lNum = [d.lNum s];
        d.lHtd = [d.lHtd htd];
        d.lLtd = [d.lLtd ltd];
        d.lR   = [d.lR   perc];
    case 'R'
        d.rNum = [d.rNum s];
        d.rHtd = [d.rHtd htd];
        d.rLtd = [d.rLtd ltd];
        d.rR   = [d.rR   perc];
end
end

function [stroke,EE] = labelMaker(lim,prev,stroke,EE,label,treatment)
for i = 1:lim
    stroke{prev+i} = label;
    EE{prev+i} = treatment;
end
end