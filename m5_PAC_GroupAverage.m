% This code averages all the comodulograms of a particular Phase/amplitude
% layer combination for each group and saves them to Average Comodulograms
% folder. 
% Last edited by Zachary Ip - 4/19
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
filepath = 'C:\Users\ipzach\Documents\MATLAB';
cd(filepath)
load('SpkInfo.mat')
cd('Comodulograms')
for group = [2]
    for file = 7
        % This will cycle through all layers
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
                filename = 'H_PS_AC_HD.mat';
            case 7
                filename = 'H_PP_AC_HD.mat';
            case 8
                filename = 'L_PP_AO_HD.mat';
            case 9
                filename = 'L_PP_AS_HD.mat';
            case 10
                filename = 'L_PP_AP_HD.mat';   
        end
        Sum_Comodulogram.R = zeros(25,65);
        Sum_Comodulogram.L = zeros(25,65);
        % This will run through only folders that have actual comodulograms
        for animal = 1:length(dir(join([SpkInfo{group,1} '*'])))
            list = dir(join([SpkInfo{group,1} '*']));
            cd(list(animal).name)
            try 
            load(filename)
            %figure
%             PhaseFreqVector = 0:0.5:12 ;
%         AmpFreqVector = 0:2.5:160;
%         PhaseFreq_BandWidth = 1;
%         AmpFreq_BandWidth = 10;
%             contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,Comodulogram.L',30,'lines','none')
%             title(['Average' SpkInfo{group,1} ' ' filename 'Right']), colormap(cubehelix(800,2.5,0.8,1.4,0.55))
%             colorbar
%             rectangle('Position', [2.5 25 4 30], 'Edgecolor', 'w', 'LineWidth', 2)
%             title(list(animal).name)
%             drawnow
%             pause(0.1)
            if sum(sum(isnan(Comodulogram.R))) < 1 
            Sum_Comodulogram.R = Sum_Comodulogram.R + Comodulogram.R;
            Sum_Comodulogram.L = Sum_Comodulogram.L + Comodulogram.L;
            end
            catch
            end
            cd ..
        end
        Avg_Comodulogram.R = Sum_Comodulogram.R./length(dir(join([SpkInfo{group,1} '*'])));
        Avg_Comodulogram.L = Sum_Comodulogram.L./length(dir(join([SpkInfo{group,1} '*'])));
        save(['C:\Users\ipzach\Documents\MATLAB\Average Comodulograms\' SpkInfo{group,1} filesep 'Avg_' filename],'Avg_Comodulogram');
        disp(['Saved ' SpkInfo{group,1} ' ' filename])
        %% Graph Average Comodulogram
        PhaseFreqVector = 0:0.5:12 ;
        AmpFreqVector = 0:2.5:160;
        
        PhaseFreq_BandWidth = 1;
        AmpFreq_BandWidth = 10;
        
        figure
        contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,Avg_Comodulogram.R',30,'lines','none')
        title(['Average' SpkInfo{group,1} ' ' filename 'Right']), colormap(cubehelix(800,2.5,0.8,1.4,0.55))
        colorbar
        
        figure
        contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,Avg_Comodulogram.L',30,'lines','none')
        title(['Average' SpkInfo{group,1} ' ' filename 'Left']), colormap(cubehelix(800,2.5,0.8,1.4,0.55))
        colorbar
        drawnow
    end
end
disp("All done!")
