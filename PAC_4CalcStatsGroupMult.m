% Grabs all points from a specific frequency range and calc stats across
% groups
% This code should take in Frequency ranges and layer combination, and
% compare this region across groups
% Should compare Stroke, Control, EE.
% Last edited by Zachary Ip, 4/19
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Comparison groups of interest:
% Phase- Delta 0-3, Theta, 3-7
% Amlitude- Delta - alpha 0-15, gamma 30-60, high gamma 80-150
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all, close all
for i = 6
    switch i
        case 1
            file = 'PC_AC_HD'; % Which phase and amplitude layer to run stats on
        case 2
            file = 'PC_AO_HD';
        case 3
            file = 'PC_AP_HD';
        case 4
            file = 'PC_AS_HD';
        case 5
            file = 'PO_AC_HD';
        case 6
            file = 'PP_AC_HD';
        case 7
            file = 'PS_AC_HD';
    end
    disp(file)
    phaseLow  = 3; % Phase values must be whole integers
    phaseHigh = 7;
    ampLow    = 30; % Amp values must be in multiples of 5
    ampHigh   = 60;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tic
    
    phaseRange = phaseLow*2+1:phaseHigh*2;
    ampRange = ampLow/2.5 +1 : ampHigh/2.5;
    window = length(ampRange)*length(phaseRange);
    
    filepath = 'C:\Users\user\Documents\MATLAB';
    cd(filepath)
    load('SpkInfo.mat')
    cd('Comodulograms')
    % Load PAC values into a data structure
    rData = [];
    lData = [];
    files = dir;
    files = extractfield(files,'name');
    
    for i = 1:9
        files(ismember(files,['2W Strk_' num2str(i)])) = [];
    end
    
    for animal = 3:length(files)
        und = strfind(files{animal},'_');
        fullName = char(files{animal});
        fullName = fullName(1:und-1);
        switch fullName
            case '1M Strk'
                group = 'Stroke';
                treat = 'No';
            case 'Control'
                group = 'Control';
                treat = 'No';
            case 'EE Sham'
                group = 'Control';
                treat = 'EE';
            case 'EE Strk'
                group = 'Stroke';
                treat = 'EE';
        end
        groupLabel{animal} = group;
        treatLabel{animal} = treat;
        cd(files{animal})
        load (['H_' file '.mat'])
        rData = [rData mean(mean(Comodulogram.R(phaseRange,ampRange)))]; % Store all the working Comodulograms in a struct
        lData = [lData mean(mean(Comodulogram.L(phaseRange,ampRange)))];
        cd ..
    end
    treatLabel = treatLabel(3:39);
    groupLabel = groupLabel(3:39);
    % Run anova and multcompare
    [~,~,rS] = anovan(rData,{groupLabel,treatLabel},'display','off');
    [~,~,lS] = anovan(lData,{groupLabel,treatLabel},'display','off');
    
    %C structure: 1&2: Which groups were compared, 4: Difference between
    %estimated group means, 3&5: lower and upper 95% confidence interval. 6:
    %pVal
    [rC,rM,~,rNames] = multcompare(rS,'CType','bonferroni'); % ,'Display','off');
    input('Contralesional')
    [lC,lM,~,lNames] = multcompare(lS,'CType','bonferroni'); % ,'Display','off');
    input('Ipsilesional')
end
%%
R.mean = [mean(rData(11:18));
    mean(rData(1:10));
    
    mean

save(['C:\Users\user\Documents\MATLAB\Stats\PAC\H_' file '_P' num2str(phaseLow) '-' num2str(phaseHigh) '_A' num2str(ampLow) '-' num2str(ampHigh) '_G'],'rS','rC','rM','lS','lC','lM');
cd ..
rStat = [rC(:,1) rC(:,2) rC(:,6)];
figure
BarErrSig(rM(:,1),rM(:,2),rStat);
title('Right')

lStat = [lC(:,1) lC(:,2) lC(:,6)];
figure
BarErrSig(lM(:,1),lM(:,2),lStat);
title('Left')



disp('All Done!')


function BarErrSig(vals, ers, p)
load('Colors.mat');
[b, e] = barwitherr(ers,vals);
box off
b.FaceColor = 'flat';
b.CData(1,:) = RGB.plBlue;
b.CData(2,:) = RGB.pllBlue;
b.CData(3,:) = RGB.plOrange;
b.CData(4,:) = RGB.plOrange;
b.CData(5,:) = RGB.pllOrange;

for i = 1:length(p)
    if p(i,3) <= 0.05
        sigstar2([p(i,1) p(i,2)],p(i,3));
    end % if
end % for

end
