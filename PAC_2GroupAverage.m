% This code averages all the comodulograms of a particular Phase/amplitude
% layer combination for each group and saves them to Average Comodulograms
% folder. 
% Last edited by Zachary Ip - 4/19
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
filepath = 'C:\Users\user\Documents\MATLAB';
cd(filepath)
load('SpkInfo.mat')
cd('Comodulograms')
for group = [1:4 6]
    for file = 1:4
        % This will cycle through all layers
        switch file
            case 1
                leftFilename = 'C_PL.mat';
                rightFilename = 'C_PR.mat';
                saveName = 'C_LR.mat';
            case 2
                leftFilename = 'O_PL.mat';
                rightFilename = 'O_PR.mat';
                saveName = 'O_LR.mat';
            case 3
                leftFilename = 'P_PL.mat';
                rightFilename = 'P_PR.mat';
                saveName = 'P_LR.mat';
            case 4
                leftFilename = 'S_PL.mat';
                rightFilename = 'S_PR.mat';
                saveName = 'S_LR.mat';
            
        end
        Sum_Comodulogram.R = zeros(21,41);
        Sum_Comodulogram.L = zeros(21,41);
        % This will run through only folders that have actual comodulograms
        for animal = 1:length(dir(join([SpkInfo{group,1} '*'])))
            list = dir(join([SpkInfo{group,1} '*']));
            cd(list(animal).name)
            load(rightFilename)
            Sum_Comodulogram.R = Sum_Comodulogram.R + Comodulogram;
            load(leftFilename)
            Sum_Comodulogram.L = Sum_Comodulogram.L + Comodulogram;
            cd ..
        end
        Avg_Comodulogram.R = Sum_Comodulogram.R./length(dir(join([SpkInfo{group,1} '*'])));
        Avg_Comodulogram.L = Sum_Comodulogram.L./length(dir(join([SpkInfo{group,1} '*'])));
        save(['C:\Users\ipzac\Documents\MATLAB\Average Comodulograms\' SpkInfo{group,1} filesep 'Avg_' saveName],'Avg_Comodulogram');
        disp(['Saved ' SpkInfo{group,1} ' ' saveName])
        %% Graph Average Comodulogram
        PhaseFreqVector = 0:1:10;
        AmpFreqVector = 0:2:200;
        
        PhaseFreq_BandWidth = 1;
        AmpFreq_BandWidth = 10;
        
        figure
        contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,Avg_Comodulogram.R',30,'lines','none')
        title(['Average' SpkInfo{group,1} ' ' saveName 'Right']), colormap('jet')
        colorbar
        figure
        contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,Avg_Comodulogram.L',30,'lines','none')
        title(['Average' SpkInfo{group,1} ' ' saveName 'Left']), colormap('jet')
        colorbar
        drawnow
    end
end
disp("All done!")
