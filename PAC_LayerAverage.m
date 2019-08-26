% This code averages all the comodulograms of a particular Phase/amplitude
% layer combination for each group and saves them to Average Comodulograms
% folder.
% Last edited by Zachary Ip - 4/4/19
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
filepath = 'C:\Users\ipzach\Documents\MATLAB';
cd(filepath)
load('SpkInfo.mat')
cd('Comodulograms')
% for group = [2:4 6]
    for file = 1:7
        % This will cycle through all phase/amp layer combinations
        switch file
            case 1
                filename = 'H_PC_AC_HD.mat';
            case 2
                filename = 'H_PC_AO_HD.mat';
            case 3
                filename = 'H_PC_AP_HD.mat';
            case 4
                filename = 'H_PC_AS_HD.mat';
            case 5
                filename = 'H_PO_AC_HD.mat';
            case 6
                filename = 'H_PP_AC_HD.mat';
            case 7
                filename = 'H_PS_AC_HD.mat';
        end
        Sum_Comodulogram.R = zeros(25,65);
        Sum_Comodulogram.L = zeros(25,65);
        % This will run through only folders that have actual comodulograms
        for animal = 1:(length(dir([SpkInfo{3,1} '*']))+length(dir([SpkInfo{4,1} '*'])))
            list = [dir([SpkInfo{3,1} '*']); dir([SpkInfo{4,1} '*'])];
            cd(list(animal).name)
            load(filename)
            Sum_Comodulogram.R = Sum_Comodulogram.R + Comodulogram.R;
            Sum_Comodulogram.L = Sum_Comodulogram.L + Comodulogram.L;
            cd ..
        end
        Avg_Comodulogram.R = Sum_Comodulogram.R./length(list);
        Avg_Comodulogram.L = Sum_Comodulogram.L./length(list);
        save(['C:\Users\ipzach\Documents\MATLAB\Average Comodulograms\Stroke' filesep 'Avg_' filename],'Avg_Comodulogram');
        disp(['Saved ' filename])
        %% Graph Average Comodulogram
        PhaseFreqVector = 0:0.5:12;
        AmpFreqVector = 0:2.5:160;
        PhaseFreq_BandWidth = 0.5;
        AmpFreq_BandWidth = 2.5;
        
        figure
        contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,Avg_Comodulogram.R',30,'lines','none')
%         title(['Average' SpkInfo{group,1} ' ' filename 'Right']), colormap('jet')
        colorbar
        figure
        contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,Avg_Comodulogram.L',30,'lines','none')
       %  title(['Average' SpkInfo{group,1} ' ' filename 'Left']), colormap('jet')
        colorbar
    end
% end
disp('Done')
