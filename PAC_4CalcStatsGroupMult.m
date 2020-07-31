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
    
    filepath = 'C:\Users\user\Documents\MATLAB';
    cd(filepath)
    load('SpkInfo.mat')
    cd('Comodulograms')
    % Load PAC values into a data structure
    rData = [];
    lData = [];
    files = dir;
    files = extractfield(files,'name');
    files = files(3:end)';
    for animal = 1:length(files)
        und = strfind(files{animal},'_');
        fullName = char(files{animal});
        fullName = fullName(1:und-1);
        switch fullName
            case '1M Strk'
                group = 'Stroke';
                treat = 'Std';
            case 'Control'
                group = 'Control';
                treat = 'Std';
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
        rData(animal) = mean(mean(Comodulogram.R(phaseRange,ampRange))); % Store all the working Comodulograms in a struct
        lData(animal) = mean(mean(Comodulogram.L(phaseRange,ampRange)));
        cd ..
    end
    
    % 2 WAY ANOVA
    treatLabel = treatLabel([1:10 18:end]);
    groupLabel = groupLabel([1:10 18:end]);
    rData2 = rData([1:10 18:end]);
    lData2 = lData([1:10 18:end]);
    % Run anova and multcompare
    [~,rT2,rS2] = anovan(rData2,{treatLabel,groupLabel},'display','off');
    [~,lT2,lS2] = anovan(lData2,{treatLabel,groupLabel},'display','off');
    
    %C structure: 1&2: Which groups were compared, 4: Difference between
    %estimated group means, 3&5: lower and upper 95% confidence interval. 6:
    %pVal
    [rC2,rM2,~,rNames2] = multcompare(rS2,'Dimension',[1 2],'CType','bonferroni','Display','off');
    
    [lC2,lM2,~,lNames2] = multcompare(lS2,'Dimension',[1 2],'CType','bonferroni','Display','off');
  
    % 1 WAY ANOVA
    labels = {'Ctrl','1MS','2WS'};
    rData1 = NaN(10,3);
    lData1 = NaN(10,3);
    
    rData1(1:8,1)  = rData(18:25);
    rData1(1:7,2)  = rData(11:17);
    rData1(1:10,3) = rData(1:10);
    
       
    lData1(1:8,1)  = lData(18:25);
    lData1(1:7,2)  = lData(11:17);
    lData1(1:10,3) = lData(1:10);

    
    [~,rT1,rS1] = anova1(rData1,labels,'off');
    [~,lT1,lS1] = anova1(lData1,labels,'off');
    
    [rC1,rM1,~,rNames1] = multcompare(rS1,'CType','bonferroni','Display','off');
    
    
    [lC1,lM1,~,lNames1] = multcompare(lS1,'CType','bonferroni','Display','off');
    
    save(['C:\Users\user\Documents\MATLAB\Stats\PAC\H_' file '_P' num2str(phaseLow) '-' num2str(phaseHigh) '_A' num2str(ampLow) '-' num2str(ampHigh) '_G'],...
        'rC1','rM1','rNames1','lC1','lM1','rC2','rM2','rNames2','lC2','lM2');
    disp(['Saved ' 'C:\Users\user\Documents\MATLAB\Stats\PAC\H_' file '_P' num2str(phaseLow) '-' num2str(phaseHigh) '_A' num2str(ampLow) '-' num2str(ampHigh) '_G'])
end
cd ..


