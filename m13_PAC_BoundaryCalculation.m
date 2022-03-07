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

L_phase_ranges = zeros(5,15);
L_amp_ranges = zeros(5,30);

R_phase_ranges = zeros(5,15);
R_amp_ranges = zeros(5,30);
figure
set(gcf,'Position',[100 0 2000 560])
counter = 0;
for file = [7 11]
    for group = [1:4 6]
        
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
                name = 'Pyramidal Cortical';
            case 8
                filename = 'L_PP_AO_HD.mat';
            case 9
                filename = 'L_PP_AS_HD.mat';
            case 10
                filename = 'L_PP_AP_HD.mat';
            case 11
                filename = 'H_PP_AP_HD.mat';
                name = 'Pyramidal Pyramidal';
        end
        counter = counter +1;
        Sum_Comodulogram.R = zeros(25,65);
        Sum_Comodulogram.L = zeros(25,65);
        All_Comodulogram.R = zeros(25,65,length(dir([SpkInfo{group,1} '*'])));
        All_Comodulogram.L = zeros(25,65,length(dir([SpkInfo{group,1} '*'])));
        % This will run through only folders that have actual comodulograms
        for animal = 1:length(dir([SpkInfo{group,1} '*']))
            list = dir([SpkInfo{group,1} '*']);
            cd(list(animal).name)
            try
                load(filename)
                %             figure
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
                    All_Comodulogram.R(:,:,animal) = Comodulogram.R;
                    All_Comodulogram.L(:,:,animal) = Comodulogram.L;
                    Sum_Comodulogram.R = Sum_Comodulogram.R + Comodulogram.R;
                    Sum_Comodulogram.L = Sum_Comodulogram.L + Comodulogram.L;
                end
            catch
            end
            cd ..
        end
        Avg_Comodulogram.R = Sum_Comodulogram.R./length(dir([SpkInfo{group,1} '*']));
        Avg_Comodulogram.L = Sum_Comodulogram.L./length(dir([SpkInfo{group,1} '*']));
        [h.R,p.R] = test(All_Comodulogram.R);
        [h.L,p.L] = test(All_Comodulogram.R);
        
        %        save(['C:\Users\ipzach\Documents\MATLAB\Average Comodulograms\' SpkInfo{group,1} filesep 'Avg_' filename],'Avg_Comodulogram');
        %     disp(['Saved ' SpkInfo{group,1} ' ' filename])
        %% Graph Average Comodulogram
        PhaseFreqVector = 0:0.5:12 ;
        AmpFreqVector = 0:2.5:160;
        
        PhaseFreq_BandWidth = 1;
        AmpFreq_BandWidth = 10;
        
        B_L = thresher(Avg_Comodulogram.L');
        B_R = thresher(Avg_Comodulogram.R');
        
        subplot(2,5,counter)
        contourf(Avg_Comodulogram.L',30,'lines','none')
        colormap(cubehelix(800,2.5,0.8,1.4,0.55))
        if file == 7
            title(SpkInfo{group,1})
        else
            xlabel('Phase Frequency')
        end
        if group == 1
            ylabel(name)
        end
        set(gca,'xtick',[0:6.25:25],'xticklabel',[0:3:12],'ytick',[0:16.25:65],'yticklabel',[0:40:160])
        %rectangle('Position', [8 10 6 15], 'Edgecolor', 'w', 'LineWidth', 2)
        hold on
        visboundaries(B_R,'Color','w')
        
        %         disp(max(Avg_Comodulogram.R(:)))
        %         disp(max(Avg_Comodulogram.L(:)))
        
        
        phaseRange = PhaseFreqVector(range(B_L,1)==1);
        L_phase_ranges(group,1:length(phaseRange)) = phaseRange;
        ampRange = AmpFreqVector(range(B_L,2)==1);
        L_amp_ranges(group,1:length(ampRange)) = ampRange;
        
        phaseRange = PhaseFreqVector(range(B_R,1)==1);
        R_phase_ranges(group,1:length(phaseRange)) = phaseRange;
        ampRange = AmpFreqVector(range(B_R,2)==1);
        R_amp_ranges(group,1:length(ampRange)) = ampRange;
        
    end
end
colorbar('Position',[0.92 0.35 0.01 0.4])
caxis([0 0.003])
A = suplabel('Amplitude frequency','y',[0.1 0.08 0.01 0.79]);
set(A,'FontSize',10)
disp("All done!")
function [h,p] = test(C)
h = zeros(size(C,1),size(C,2));
p = zeros(size(C,1),size(C,2));
for i = 1:size(C,1)
    for j = 1:size(C,2)
        [h(i,j),p(i,j)] = ttest(squeeze(C(i,j,:)),0,'Alpha',0.001);
    end
end


end

function [B] = thresher(C)
scaler = max(C(:));
adjusted = C ./scaler;
t = graythresh(adjusted) .*scaler;
B = imbinarize(C,t);
end
