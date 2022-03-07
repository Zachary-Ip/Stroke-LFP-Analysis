%% General - Loading Info, Colors, etc
clearvars;
cd('C:\Users\ipzach\Documents\Shivalika')
load allPowers.mat allPowers
load labelPower.mat labelPower
load allDurations.mat allDurations
load labelDuration.mat labelDuration


% Parse out data
duration1L = allDurations( [1:777    2231:2961 4876:5244]);
durLabel1L = labelDuration([1:777    2231:2961 4876:5244]);

duration1R = allDurations( [778:1295 2962:3650 5245:end]);
durLabel1R = labelDuration([778:1295 2962:3650 5245:end]);

duration2L = allDurations( [1:777    1296:1770 2231:2961 3651:4201]);
durLabel2L = labelDuration([1:777    1296:1770 2231:2961 3651:4201]);

duration2R = allDurations( [778:1295 1771:2230 2962:3650 4202:4875]);
durLabel2R = labelDuration([778:1295 1771:2230 2962:3650 4202:4875]);


power1L    = allPowers( [1:559    2013:2743 4659:5026]);
powLabel1L = labelPower([1:559    2013:2743 4659:5026]);

power1R    = allPowers([1035:1552 3295:3983 5027:end]);
powLabel1R = labelPower([1035:1552 3295:3983 5027:end]);
%                       (Ctrl:EE Sham 1MS:EE1MS)
power2L    = allPowers( [1:1034 2013:3294]);
powLabel2L = labelPower([1:1034 2013:3294]);


power2R    = allPowers( [1035:2012 3295:4657]);
powLabel2R = labelPower([1035:2012 3295:4657]);
%% split labels for 2way
disp('lpow')
newpowL2 = split(powLabel2L);
disp('rpow')
newpowR2 = split(powLabel2R);
disp('rdur')
newdurR2 = split(durLabel2R);
disp('ldur')
newdurL2 = split(durLabel2L);
%% Stats
[~,~,dur1Lstats] = anova1(duration1L, durLabel1L);
[~,~,dur1Rstats] = anova1(duration1R, durLabel1R);

[~,~,pow1Lstats] = anova1(power1L, powLabel1L);
[~,~,pow1Rstats] = anova1(power1R, powLabel1R);

[rDC1,rDM1,~,dNames1] = multcompare(dur1Rstats,'CType','bonferroni');
[lDC1,lDM1,~] = multcompare(dur1Lstats,'CType','bonferroni');

[rPC1,rPM1,~,pNames1] = multcompare(pow1Rstats,'CType','bonferroni');
[lPC1,lPM1,~] = multcompare(pow1Lstats,'CType','bonferroni');

%%
[~,aDurLT,dur2Lstats] = anovan(duration2L, newdurL2,'model','interaction');
[~,aDurRT,dur2Rstats] = anovan(duration2R, newdurR2,'model','interaction');

[~,aPowLT,pow2Lstats] = anovan(power2L, newpowL2,'model','interaction');
[~,aPowRT,pow2Rstats] = anovan(power2R, newpowR2,'model','interaction');
%%

[rDC2,rDM2,~,dNames2] = multcompare(dur2Rstats,'Dimension',[1 2],'CType','bonferroni');
[lDC2,lDM2,~]         = multcompare(dur2Lstats,'Dimension',[1 2],'CType','bonferroni');

[rPC2,rPM2,~,pNames2] = multcompare(pow2Rstats,'Dimension',[1 2],'CType','bonferroni');
[lPC2,lPM2,~]         = multcompare(pow2Lstats,'Dimension',[1 2],'CType','bonferroni');
%%


save('C:\Users\ipzach\Documents\MATLAB\Stats\SPWR\anovas.mat',...
    'rDC1','rDM1','lDC1','lDM1','rPC1','rPM1','lPC1','lPM1','dNames1','pNames1',...
    'rDC2','rDM2','lDC2','lDM2','rPC2','rPM2','lPC2','lPM2','dNames2','pNames2');
function [newLabel] = split(labels)

treatL = {};
stateL = {};
for i = 1:length(labels)
    if strfind(labels{i},'Control')
        treat = 'Std';
        state = 'Ctrl';
    elseif strfind(labels{i},'EE 1M Stroke')
        treat = 'EE';
        state = 'Strk';
    elseif strfind(labels{i},'EE Sham')
        treat = 'EE';
        state = 'Ctrl';
    elseif strfind(labels{i},'1M Stroke')
        treat = 'Std';
        state = 'Strk';
    
    else
        treat = 'null';
        state = 'null';
        disp('Lol that didnt work')
    end
    treatL = [treatL treat];
    stateL = [stateL state];
end
newLabel = {stateL,treatL};
end
        
