% Create a linear ANOVA model to compare different groups
% All groups separately.
load('SpkInfo.mat')
load('C:\Users\user\Documents\MATLAB\Stats\Power\NormalizedPower.mat')
% [Power][Group][Hemisphere]
% Control 8:8
% -- EESham  10:10
% 1MStrk  9:9
% 2WStrk  6:6
% -- EEStrk  9:9

% 2-way anova labels
stroke = cell(1,36);
EE = cell(1,36);
[stroke,EE] = labelMaker(8,0,stroke,EE,'Control','Std');
[stroke,EE] = labelMaker(10,8,stroke,EE,'Control','EE');
[stroke,EE] = labelMaker(9,18,stroke,EE,'Stroke','Std');
[stroke,EE] = labelMaker(9,27,stroke,EE,'Stroke','EE');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ONE WAY ANOVA MULTIPLE COMPARISON
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[cDelta.R1,cDelta.L1] = runAnova1(NormalizedPower,1,1);
[pDelta.R1,pDelta.L1] = runAnova1(NormalizedPower,1,2);
[sDelta.R1,sDelta.L1] = runAnova1(NormalizedPower,1,3);
[oDelta.R1,oDelta.L1] = runAnova1(NormalizedPower,1,4);

[cTheta.R1,cTheta.L1] = runAnova1(NormalizedPower,2,1);
[pTheta.R1,pTheta.L1] = runAnova1(NormalizedPower,2,2);
[sTheta.R1,sTheta.L1] = runAnova1(NormalizedPower,2,3);
[oTheta.R1,oTheta.L1] = runAnova1(NormalizedPower,2,4);


%%
[cGamma.R1,cGamma.L1] = runAnova1(NormalizedPower,3,1);
[pGamma.R1,pGamma.L1] = runAnova1(NormalizedPower,3,2);
[sGamma.R1,sGamma.L1] = runAnova1(NormalizedPower,3,3);
[oGamma.R1,oGamma.L1] = runAnova1(NormalizedPower,3,4);

[cHGamma.R1,cHGamma.L1] = runAnova1(NormalizedPower,4,1);
[pHGamma.R1,pHGamma.L1] = runAnova1(NormalizedPower,4,2);
[sHGamma.R1,sHGamma.L1] = runAnova1(NormalizedPower,4,3);
[oHGamma.R1,oHGamma.L1] = runAnova1(NormalizedPower,4,4);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TWO WAY ANOVA MULTIPLE COMPARISON
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[cDelta.R2,cDelta.L2] = runAnova2(1,NormalizedPower,stroke,EE,1);
[pDelta.R2,pDelta.L2] = runAnova2(1,NormalizedPower,stroke,EE,2);
[sDelta.R2,sDelta.L2] = runAnova2(1,NormalizedPower,stroke,EE,3);
[oDelta.R2,oDelta.L2] = runAnova2(1,NormalizedPower,stroke,EE,4);

[cTheta.R2,cTheta.L2] = runAnova2(2,NormalizedPower,stroke,EE,1);
[pTheta.R2,pTheta.L2] = runAnova2(2,NormalizedPower,stroke,EE,2);
[sTheta.R2,sTheta.L2] = runAnova2(2,NormalizedPower,stroke,EE,3);
[oTheta.R2,oTheta.L2] = runAnova2(2,NormalizedPower,stroke,EE,4);

%%
[cGamma.R2,cGamma.L2] = runAnova2(5,NormalizedPower,stroke,EE,1);
[pGamma.R2,pGamma.L2] = runAnova2(5,NormalizedPower,stroke,EE,2);
[sGamma.R2,sGamma.L2] = runAnova2(5,NormalizedPower,stroke,EE,3);
[oGamma.R2,oGamma.L2] = runAnova2(5,NormalizedPower,stroke,EE,4);

[cHGamma.R2,cHGamma.L2] = runAnova2(6,NormalizedPower,stroke,EE,1);
[pHGamma.R2,pHGamma.L2] = runAnova2(6,NormalizedPower,stroke,EE,2);
[sHGamma.R2,sHGamma.L2] = runAnova2(6,NormalizedPower,stroke,EE,3);
[oHGamma.R2,oHGamma.L2] = runAnova2(6,NormalizedPower,stroke,EE,4);
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

function [R,L] = runAnova1(source,group,layer)
rData = NaN(9,3);
rData(1:8,1) = source{1}.R(5:end,group,layer);
rData(1:9,2) = source{4}.R([1:4 6 8:end],group,layer);
rData(1:6,3) = source{3}.R(4:end,group,layer);

lData = NaN(9,3);
lData(1:8,1) = source{1}.L(5:end,group,layer);
lData(1:9,2) = source{4}.L([1:4 6 8:end],group,layer);
lData(1:6,3) = source{3}.L(4:end,group,layer);

labels = {'Ctrl','1MS','2WS'};
[~,R.tbl,R.Stats] = anova1(rData,labels,'off');
[~,L.tbl,L.Stats] = anova1(lData,labels,'off');
[R.Comp,R.M,~,R.names] = multcompare(R.Stats,'CType','bonferroni','Dimension',[1 2],'Display','off');
[L.Comp,L.M,~,L.names] = multcompare(L.Stats,'CType','bonferroni','Dimension',[1 2],'Display','off');
end

function [R,L] = runAnova2(group,source,stroke,EE,layer)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rData = [source{1}.R(5:end,group,layer);
    source{2}.R(:,group,layer);
    source{3}.R([1:4 6 8:end],group,layer);
    source{6}.R([1:4 6:end],group,layer)];

lData = [source{1}.L(5:end,group,layer);
    source{2}.L(:,group,layer);
    source{3}.L([1:4 6 8:end],group,layer);
    % source{4,2}.L(4:end,group,layer);
    source{6}.L([1:4 6:end],group,layer)];

[~,R.tbl,R.Stats] = anovan(rData,{stroke,EE},'model','interaction','display','off');
[~,L.tbl,L.Stats] = anovan(lData, {stroke,EE},'model','interaction','display','off');
[R.Comp,R.M,~,R.names] = multcompare(R.Stats,'CType','bonferroni','Dimension',[1 2],'Display','off');
[L.Comp,L.M,~,L.names] = multcompare(L.Stats,'CType','bonferroni','Dimension',[1 2],'Display','off');
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