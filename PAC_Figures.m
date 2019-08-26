% Plots avg + ex, control stroke, ipsi contra and stats
% Will include sections for AY talk 6/19
% Zachary Ip
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Layout should be
%      Control      %       Stroke      %
%   Left  %  Right  %   Left  %  Right  %
% Average % Average % Average % Average %
% Example % Example % Example % Example %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all, close all
filepath = 'C:\Users\ipzac\Documents\MATLAB';
cd(filepath);
load('SpkInfo');
%Specifying Comodulogram window sizes
PhaseFreqVector = 0:0.5:12;
AmpFreqVector = 0:2.5:160;
PhaseFreq_BandWidth = 0.5;
AmpFreq_BandWidth = 2.5;

%% Fix colorbar range
cd('Average Comodulograms\EE Strk')
load('Avg_H_PO_AC_HD')
eStrkAvg = Avg_Comodulogram;
eAvgMax = max(reshape([Avg_Comodulogram.R Avg_Comodulogram.L],1,3250));
cd ..
cd('Control')
load('Avg_H_PO_AC_HD.mat')
cntrlAvg = Avg_Comodulogram;
cAvgMax = max(reshape([Avg_Comodulogram.R Avg_Comodulogram.L],1,3250));
cd .., cd .. 
cd('Comodulograms\EE Strk_10\');
load('H_PO_AC_HD.mat');
eStrkExp = Comodulogram;
eExpMax = max(reshape([Comodulogram.R Comodulogram.L],1,3250));
cd ..
cd('Control_10');
load('H_PO_AC_HD.mat');
cntrlExp = Comodulogram;
cExpMax = max(reshape([Comodulogram.R Comodulogram.L],1,3250)); 
cd ..

AvgRange = max([eAvgMax cAvgMax]);
SampleRange = max([eExpMax cExpMax]);

%% Stroke difference
figure
subplot(2,2,1)
contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,cntrlAvg.L',30,'lines','none')
set(gca,'fontsize',14,'xtick', []);
caxis([0 AvgRange])
title('Ipsilateral')
ylabel('Control')

subplot(2,2,2)
contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,cntrlAvg.R',30,'lines','none')
set(gca,'fontsize',14,'xtick', [], 'ytick', []);
colorbar
caxis([0 AvgRange])
title('Contralateral')

subplot(2,2,3)
contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,eStrkAvg.L',30,'lines','none')
set(gca,'fontsize',14);

caxis([0 AvgRange])
ylabel('Stroke')

subplot(2,2,4)
contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,eStrkAvg.R',30,'lines','none')
set(gca,'fontsize',14, 'ytick', []);
colorbar
caxis([0 AvgRange])
h1 = suplabel('Amplitude frequency','y');
h2 = suplabel('Phase frequency','x');
set(h1, 'FontSize',16);
set(h2, 'FontSize',16);
%% Plotting
% EE Stroke Right Average 
%___X
%____
subplot('Position', [0.715 0.5 0.2 0.39]) % [X start, Y start, X lengeth, Y Length 
contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,eStrkAvg.R',30,'lines','none')
set(gca,'fontsize',14,'xtick', [], 'ytick', []);
colorbar
caxis([0 AvgRange])
title('Stroke Contralateral')

% EE Stroke Left Average
%__X_
%____
subplot('Position', [0.515 0.5 0.165 0.39])
contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,eStrkAvg.L',30,'lines','none')
set(gca,'fontsize',14,'xtick', [], 'ytick', []);
%colorbar
caxis([0 AvgRange])
title('Stroke Ipsilateral')


% Control Right Average 
%_X__
%____
subplot('Position', [0.285 0.5 0.165 0.39])
contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,cntrlAvg.R',30,'lines','none')
set(gca,'fontsize',14,'xtick', [], 'ytick', []);
%colorbar
caxis([0 AvgRange])
title('Control Contralateral')

% Control Left Average
%X___
%____
subplot('Position', [0.085 0.5 0.165 0.39])
contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,cntrlAvg.L',30,'lines','none')
set(gca,'fontsize',14,'xtick', []);
caxis([0 AvgRange])
title('Control Ipsilateral')
ylabel('Average')



% Sample plots
% EE Stroke Right Sample
%____
%___X

subplot('Position', [0.715 0.08 0.2 0.39])
contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,eStrkExp.R',30,'lines','none')
set(gca,'fontsize',10, 'ytick', []);
colorbar
caxis([0 SampleRange])

% EE Stroke Left Sample
%____
%__X_
subplot('Position', [0.515 0.08 0.165 0.39])
contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,eStrkExp.L',30,'lines','none')
set(gca,'fontsize',14, 'ytick', []);
%colorbar
caxis([0 SampleRange])

% Control Right Sample
%____
%_X__
subplot('Position', [0.285 0.08 0.165 0.39])
contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,cntrlExp.R',30,'lines','none')
set(gca,'fontsize',14, 'ytick', []);
%colorbar
caxis([0 SampleRange])

% Control Left Sample
%____
%X___

subplot('Position', [0.085 0.08 0.165 0.39])
contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,cntrlExp.L',30,'lines','none')
set(gca,'fontsize',14);
%colorbar
caxis([0 SampleRange])
ylabel('Example')




%%
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
    load(['C:\Users\ipzac\Documents\MATLAB\Average Comodulograms\EE Strk\Avg_' filename]);
    figure
    subplot(1,2,1)
    contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,Avg_Comodulogram.R',30,'lines','none')
    set(gca,'fontsize',14,'xtick', [], 'ytick', []);
    title(filename);
    colorbar
    
    subplot(1,2,2)
    contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,Avg_Comodulogram.L',30,'lines','none')
    set(gca,'fontsize',14,'xtick', [], 'ytick', []);
    colorbar
end

%% Slide Comodulogram example
filename = 'H_PS_AC_HD.mat';
load(['C:\Users\ipzac\Documents\MATLAB\Average Comodulograms\EE Strk\Avg_' filename]);
    figure
    contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,Avg_Comodulogram.L',30,'lines','none')
    set(gca,'fontsize',12);
    colorbar
    ylabel('Amplitude Frequency');
    xlabel('Phase Frequency');