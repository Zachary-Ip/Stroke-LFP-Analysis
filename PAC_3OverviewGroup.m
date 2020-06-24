% Displays all layer and phase comparisons (14) in 1 graph.
% Plots one group at a time with common scale bar
% add functionality to view all groups with common layer or phase?
% Last edited by Zachary Ip 4/19
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filepath = 'C:\Users\user\Documents\MATLAB';
cd(filepath)
load('SpkInfo.mat')
cd 'Average Comodulograms'
% Define which group and TD you want to look at
group = 3;
cd(SpkInfo{group,1})
thetaDeltaState = 1;
switch thetaDeltaState
    case 1
        thetaDeltaTitle = '_H_';
    case 2
        thetaDeltaTitle = 'L_';
end

% Setting window and bit size for Comodulograms
phaseFreqVector = 0:0.5:12;
ampFreqVector = 0:2.5:160;

phaseFreq_BandWidth = 0.5;
ampFreq_BandWidth = 2.5;
% Load and uniquely label data
load(['Avg' thetaDeltaTitle 'PC_AO_HD.mat'])
PC_AO = Avg_Comodulogram;

load(['Avg' thetaDeltaTitle 'PC_AP_HD.mat'])
PC_AP = Avg_Comodulogram;

load(['Avg' thetaDeltaTitle 'PC_AS_HD.mat'])
PC_AS = Avg_Comodulogram;

load(['Avg' thetaDeltaTitle 'PC_AC_HD.mat'])
PC_AC = Avg_Comodulogram;

load(['Avg' thetaDeltaTitle 'PO_AC_HD.mat'])
PO_AC = Avg_Comodulogram;

load(['Avg' thetaDeltaTitle 'PP_AC_HD.mat'])
PP_AC = Avg_Comodulogram;

load(['Avg' thetaDeltaTitle 'PS_AC_HD.mat'])
PS_AC = Avg_Comodulogram;

maxVal = max([max(PC_AO.R(:)) max(PC_AP.R(:)) max(PC_AS.R(:)) max(PC_AC.R(:)) max(PO_AC.R(:)) max(PP_AC.R(:)) max(PS_AC.R(:)) max(PC_AO.L(:)) max(PC_AP.L(:)) max(PC_AS.L(:)) max(PC_AC.L(:)) max(PO_AC.L(:)) max(PP_AC.L(:)) max(PS_AC.L(:))]);
%%
figure
% First column
% Ipsilateral
subplot('Position', [0.1 0.5 0.11 0.35])
contourf(phaseFreqVector+phaseFreq_BandWidth/2,ampFreqVector+ampFreq_BandWidth/2,PC_AO.L',30,'lines','none')
set(gca, 'xtick', []), title('PC AO'), ylabel('Ipsilateral'), caxis([0 maxVal])
% Contralateral
subplot('Position', [0.1 0.1 0.11 0.35])
contourf(phaseFreqVector+phaseFreq_BandWidth/2,ampFreqVector+ampFreq_BandWidth/2,PC_AO.R',30,'lines','none')
ylabel('Contralateral'), caxis([0 maxVal])
% Second Column
% Ipsilateral
subplot('Position', [0.214 0.5 0.11 0.35])
contourf(phaseFreqVector+phaseFreq_BandWidth/2,ampFreqVector+ampFreq_BandWidth/2,PC_AP.L',30,'lines','none')
set(gca, 'xtick', [], 'ytick', []), title('PC AS'), caxis([0 maxVal])
% Contralateral
subplot('Position', [0.214 0.1 0.11 0.35])
contourf(phaseFreqVector+phaseFreq_BandWidth/2,ampFreqVector+ampFreq_BandWidth/2,PC_AP.R',30,'lines','none')
set(gca, 'ytick', []), caxis([0 maxVal])
% Third Column
% Ipsilateral
subplot('Position', [0.328 0.5 0.11 0.35])
contourf(phaseFreqVector+phaseFreq_BandWidth/2,ampFreqVector+ampFreq_BandWidth/2,PC_AS.L',30,'lines','none')
set(gca, 'xtick', [], 'ytick', []), title('PC AP'), caxis([0 maxVal])
% Contralateral
subplot('Position', [0.328 0.1 0.11 0.35])
contourf(phaseFreqVector+phaseFreq_BandWidth/2,ampFreqVector+ampFreq_BandWidth/2,PC_AS.R',30,'lines','none')
set(gca, 'ytick', []), caxis([0 maxVal])
% Fourth Column
% Ipsilateral
subplot('Position', [0.442 0.5 0.11 0.35])
contourf(phaseFreqVector+phaseFreq_BandWidth/2,ampFreqVector+ampFreq_BandWidth/2,PC_AC.L',30,'lines','none')
set(gca, 'xtick', [], 'ytick', []), title('PC AC'), caxis([0 maxVal])
% Contralateral
subplot('Position', [0.442 0.1 0.11 0.35])
contourf(phaseFreqVector+phaseFreq_BandWidth/2,ampFreqVector+ampFreq_BandWidth/2,PC_AC.R',30,'lines','none')
set(gca, 'ytick', []), caxis([0 maxVal]),
% Fifth Column
% Ipsilateral
subplot('Position', [0.556 0.5 0.11 0.35])
contourf(phaseFreqVector+phaseFreq_BandWidth/2,ampFreqVector+ampFreq_BandWidth/2,PO_AC.L',30,'lines','none')
set(gca, 'xtick', [], 'ytick', []), title('PO AC'), caxis([0 maxVal])
% Contralateral
subplot('Position', [0.556 0.1 0.11 0.35])
contourf(phaseFreqVector+phaseFreq_BandWidth/2,ampFreqVector+ampFreq_BandWidth/2,PO_AC.R',30,'lines','none')
set(gca, 'ytick', []), caxis([0 maxVal])
% Sixth Column
% Ipsilateral
subplot('Position', [0.67 0.5 0.11 0.35])
contourf(phaseFreqVector+phaseFreq_BandWidth/2,ampFreqVector+ampFreq_BandWidth/2,PP_AC.L',30,'lines','none')
set(gca, 'xtick', [], 'ytick', []), title('PS AC'), caxis([0 maxVal])
% Contralateral
subplot('Position', [0.67 0.1 0.11 0.35])
contourf(phaseFreqVector+phaseFreq_BandWidth/2,ampFreqVector+ampFreq_BandWidth/2,PP_AC.R',30,'lines','none')
set(gca, 'ytick', []), caxis([0 maxVal])
% Seventh Column
% Ipsilateral
subplot('Position', [0.78 0.5 0.11 0.35])
contourf(phaseFreqVector+phaseFreq_BandWidth/2,ampFreqVector+ampFreq_BandWidth/2,PS_AC.L',30,'lines','none')
set(gca, 'xtick', [], 'ytick', []), title('PP AC'), caxis([0 maxVal])
% Contralateral
subplot('Position', [0.78 0.1 0.11 0.35])
contourf(phaseFreqVector+phaseFreq_BandWidth/2,ampFreqVector+ampFreq_BandWidth/2,PS_AC.R',30,'lines','none')
set(gca, 'ytick', []), caxis([0 maxVal])
colormap(cubehelix(800,2.5,0.8,1.4,0.55))
% colorbar
colorbar('Position', [0.91 0.1 0.02 0.7])
suplabel(SpkInfo{group,1}  ,'t');
