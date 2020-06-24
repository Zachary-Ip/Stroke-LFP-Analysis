% Create a linear ANOVA model to compare different groups
% All groups separately.
load('SpkInfo.mat')
cd('C:\Users\user\Documents\MATLAB\Stats\Power')
load('NormalizedPower.mat')
% [Power][Group][Hemisphere]
% Control 8:8
% -- EESham  10:10
% 1MStrk  9:9
% 2WStrk  6:6
% -- EEStrk  9:9

% Group/hemisphere labels
% labels = cell(46,2);
% labels = labelMaker(16,0,labels,'Control');
% labels = labelMaker(18,16,labels,'1MStrk');
% labels = labelMaker(12,34,labels,'2WStrk');

stroke = cell(1,36);
EE = cell(1,36);
[stroke,EE] = labelMaker(8,0,stroke,EE,'Control','No');
[stroke,EE] = labelMaker(10,8,stroke,EE,'Control','EE');
[stroke,EE] = labelMaker(9,18,stroke,EE,'Stroke','No');
% labels = labelMaker(6,27,labels,'2WStrk');
[stroke,EE] = labelMaker(9,27,stroke,EE,'Stroke','EE');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TWO WAY ANOVA MULTIPLE COMPARISON
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[cDelta.R,cDelta.L] = DoTheStats(1,NormalizedPower,stroke,EE,1);
[pDelta.R,pDelta.L] = DoTheStats(1,NormalizedPower,stroke,EE,2);
[sDelta.R,sDelta.L] = DoTheStats(1,NormalizedPower,stroke,EE,3);
[oDelta.R,oDelta.L] = DoTheStats(1,NormalizedPower,stroke,EE,4);

[cTheta.R,cTheta.L] = DoTheStats(2,NormalizedPower,stroke,EE,1);
[pTheta.R,pTheta.L] = DoTheStats(2,NormalizedPower,stroke,EE,2);
[sTheta.R,sTheta.L] = DoTheStats(2,NormalizedPower,stroke,EE,3);
[oTheta.R,oTheta.L] = DoTheStats(2,NormalizedPower,stroke,EE,4);

% [cAlpha.R,cAlpha.L] = DoTheStats(3,NormalizedPower,labels,1);
% [pAlpha.R,pAlpha.L] = DoTheStats(3,NormalizedPower,labels,2);
% [sAlpha.R,sAlpha.L] = DoTheStats(3,NormalizedPower,labels,3);
% [oAlpha.R,oAlpha.L] = DoTheStats(3,NormalizedPower,labels,4);
%
% [cBeta.R,cBeta.L] = DoTheStats(4,NormalizedPower,labels,1);
% [pBeta.R,pBeta.L] = DoTheStats(4,NormalizedPower,labels,2);
% [sBeta.R,sBeta.L] = DoTheStats(4,NormalizedPower,labels,3);
% [oBeta.R,oBeta.L] = DoTheStats(4,NormalizedPower,labels,4);
%%
[cGamma.R,cGamma.L] = DoTheStats(5,NormalizedPower,stroke,EE,1);
[pGamma.R,pGamma.L] = DoTheStats(5,NormalizedPower,stroke,EE,2);
[sGamma.R,sGamma.L] = DoTheStats(5,NormalizedPower,stroke,EE,3);
[oGamma.R,oGamma.L] = DoTheStats(5,NormalizedPower,stroke,EE,4);

[cHGamma.R,cHGamma.L] = DoTheStats(6,NormalizedPower,stroke,EE,1);
[pHGamma.R,pHGamma.L] = DoTheStats(6,NormalizedPower,stroke,EE,2);
[sHGamma.R,sHGamma.L] = DoTheStats(6,NormalizedPower,stroke,EE,3);
[oHGamma.R,oHGamma.L] = DoTheStats(6,NormalizedPower,stroke,EE,4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Overview
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DisplayStats(cDelta,cTheta,cGamma,cHGamma,'Cortex');
DisplayStats(pDelta,pTheta,pGamma,pHGamma,'Pyramidal');
% DisplayStats(oDelta,oTheta,oGamma,oHGamma,'Oriens');
% DisplayStats(sDelta,sTheta,sGamma,sHGamma,'SLM');
save('C:\Users\user\Documents\MATLAB\Stats\Power\anova2stats',...
    'cDelta','cTheta','cGamma','cHGamma',...
    'pDelta','pTheta','pGamma','pHGamma',...
    'sDelta','sTheta','sGamma','sHGamma',...
    'oDelta','oTheta','oGamma','oHGamma');
cd('C:\Users\user\Documents\MATLAB\Stats\Power')

function [stroke,EE] = labelMaker(lim,prev,stroke,EE,label,treatment)
for i = 1:lim
    stroke{prev+i} = label;
    EE{prev+i} = treatment;
end
end

function [R,L] = DoTheStats(group,source,stroke,EE,layer)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rData = [source{1,2}.R(5:end,group,layer);
    source{2,2}.R(:,group,layer);
    source{3,2}.R([1:4 6 8:end],group,layer);
    % source{4,2}.R(4:end,group,1);
    source{6,2}.R([1:4 6:end],group,layer)];

lData = [source{1,2}.L(5:end,group,layer);
    source{2,2}.L(:,group,layer);
    source{3,2}.L([1:4 6 8:end],group,layer);
    % source{4,2}.L(4:end,group,layer);
    source{6,2}.L([1:4 6:end],group,layer)];
% save mean and se
R.Means = [mean(source{1,2}.R(5:end,group,layer));
    mean(source{2,2}.R(:,group,1));
    mean(source{3,2}.R([1:4 6 8:end],group,layer));
    mean(source{6,2}.R([1:4 6:end],group,layer))];

R.SE = [std(source{1,2}.R(5:end,group,layer))/sqrt(length(source{1,2}.R(5:end,group,layer)));
    std(source{2,2}.R(:,group,1))/sqrt(length(source{2,2}.R(:,group,1)));
    std(source{3,2}.R([1:4 6 8:end],group,layer))/sqrt(length(source{3,2}.R([1:4 6 8:end],group,layer)));
    std(source{6,2}.R([1:4 6:end],group,layer))/sqrt(length(source{6,2}.R([1:4 6:end],group,layer)))];

L.Means = [mean(source{1,2}.L(5:end,group,layer));
    mean(source{2,2}.L(:,group,1));
    mean(source{3,2}.L([1:4 6 8:end],group,layer));
    mean(source{6,2}.L([1:4 6:end],group,layer))];

L.SE = [std(source{1,2}.L(5:end,group,layer))/sqrt(length(source{1,2}.R(5:end,group,layer)));
    std(source{2,2}.L(:,group,1))/sqrt(length(source{2,2}.R(:,group,1)));
    std(source{3,2}.L([1:4 6 8:end],group,layer))/sqrt(length(source{3,2}.R([1:4 6 8:end],group,layer)));
    std(source{6,2}.L([1:4 6:end],group,layer))/sqrt(length(source{6,2}.R([1:4 6:end],group,layer)))];


% Create table
[~,R.tbl,R.Stats] = anovan(rData,{stroke,EE},'model','interaction','display','off');
[~,L.tbl,L.Stats] = anovan(lData, {stroke,EE},'model','interaction','display','off');
[R.Comp,R.M] = multcompare(R.Stats,'CType','bonferroni','Display','off');
[L.Comp,L.M] = multcompare(L.Stats,'CType','bonferroni','Display','off');
end

function DisplayStats(delta, theta, gamma, highG, name)
figure

for plot = 1:8
    switch plot
        case 1
            file = delta.L;
        case 2
            file = theta.L;
        case 3
            file = gamma.L;
        case 4
            file = highG.L;
        case 5
            file = delta.R;
        case 6
            file = theta.R;
        case 7
            file = gamma.L;
        case 8
            file = highG.R;
    end % Switch
    subplot(2,4,plot)
    groups = [file.Comp(:,1) file.Comp(:,2),file.Comp(:,6)];
    BarErrSig(file.M(:,1),file.M(:,2),groups);
    
end % for each plot
suplabel(name,'t');
end

function BarErrSig(vals, ers, p)
load('Colors.mat');
names = {'Ctrl', 'EECtr','1MS', '2WS', 'EES'};
[b] = barwitherr(ers,vals);
%set(gca,'xticklabels',names)
box off
b.FaceColor = 'flat';
b.CData = [RGB.mlBlue; RGB.mlOrange];


if p(3) <= 0.05
    sigstar([p(1) p(2)],p(3));
end % if

end