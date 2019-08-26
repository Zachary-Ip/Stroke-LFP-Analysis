% Displays all layer and phase comparisons (14) in 1 graph. 
% Plots one group at a time with common scale bar
% add functionality to view all groups with common layer or phase?
% Last edited by Zachary Ip 4/19
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filepath = 'C:\Users\ipzac\Documents\MATLAB';
cd(filepath)
load('SpkInfo.mat')
cd 'Average Comodulograms'
% Define which group and TD you want to look at:
% Phase C,O,P,S
% Amplitude C,O,P,S
layer = 'PS_AC';

TD = 1;
switch TD
    case 1
        TDT = '_H_';
end

% Setting window and bit size for Comodulograms
PhaseFreqVector = 0:1:20;
AmpFreqVector = 0:5:200;

PhaseFreq_BandWidth = 1;
AmpFreq_BandWidth = 10;

for i = [1:4 6]
cd(SpkInfo{i,1})
% Load and uniquely label data
load(['Avg' TDT layer '.mat'])
C(i).R = Avg_Comodulogram.R;
C(i).L = Avg_Comodulogram.L;
cd ..
end
maxVal = max([max(C(1).R(:)) max(C(2).R(:)) max(C(3).R(:)) max(C(4).R(:)) max(C(6).R(:)) max(C(1).L(:)) max(C(2).L(:)) max(C(3).L(:)) max(C(4).L(:)) max(C(6).L(:))]);
%% 
figure
% First column
    % Ipsilateral
    subplot('Position', [0.1 0.5 0.15 0.39])
    contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,C(1).L',30,'lines','none')
    set(gca, 'xtick', []), title('Control'), ylabel('Ipsilateral'), caxis([0 maxVal]),colormap('jet')
    % Contralateral
    subplot('Position', [0.1 0.1 0.15 0.39])
    contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,C(1).R',30,'lines','none')
    ylabel('Contralateral'), caxis([0 maxVal]),colormap('jet')
% Second Column
    % Ipsilateral
    subplot('Position', [0.26 0.5 0.15 0.39])
    contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,C(2).L',30,'lines','none')
    set(gca, 'xtick', [], 'ytick', []), title('EE Sham'), caxis([0 maxVal]),colormap('jet')
    % Contralateral
    subplot('Position', [0.26 0.1 0.15 0.39])
    contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,C(2).R',30,'lines','none')
    set(gca, 'ytick', []), caxis([0 maxVal]),colormap('jet')
% Third Column
    % Ipsilateral
    subplot('Position', [0.42 0.5 0.15 0.39])
    contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,C(3).L',30,'lines','none')
    set(gca, 'xtick', [], 'ytick', []), title('1M Strk'), caxis([0 maxVal]),colormap('jet')
    % Contralateral
    subplot('Position', [0.42 0.1 0.15 0.39])
    contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,C(3).R',30,'lines','none')
    set(gca, 'ytick', []), caxis([0 maxVal]),colormap('jet')
% Fourth Column
    % Ipsilateral
    subplot('Position', [0.58 0.5 0.15 0.39])
    contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,C(4).L',30,'lines','none')
    set(gca, 'xtick', [], 'ytick', []), title('2W Strk'), caxis([0 maxVal]),colormap('jet')
    % Contralateral
    subplot('Position', [0.58 0.1 0.15 0.39])
    contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,C(4).R',30,'lines','none')
    set(gca, 'ytick', []), caxis([0 maxVal]),colormap('jet')
% Fifth Column
    % Ipsilateral
    subplot('Position', [0.74 0.5 0.15 0.39])
    contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,C(6).L',30,'lines','none')
    set(gca, 'xtick', [], 'ytick', []), title('EE Strk'), caxis([0 maxVal]),colormap('jet')
    % Contralateral
    subplot('Position', [0.74 0.1 0.15 0.39])
    contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,C(6).R',30,'lines','none')
    set(gca, 'ytick', []), caxis([0 maxVal]),colormap('jet')
suplabel(layer  ,'t')
cd ..
