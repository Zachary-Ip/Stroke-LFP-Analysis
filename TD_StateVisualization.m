%Plots out each step of the TD State pipeline
%Last updated by
%Zachary Ip 6/19
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%clearvars
%% Load Files
filepath = 'C:\Users\user\Documents\MATLAB\stroke_signal_processing';
cd(filepath)
load('SpkInfo.mat')
Fs = 1250;

%define a smoothing kernel
smoothing_width = 1; %300ms
kernel = gaussian(smoothing_width*Fs, ceil(8*smoothing_width*Fs));
kernel2 = gaussian(10*smoothing_width*Fs, ceil(80*smoothing_width*Fs));

% Control LFP

% group refrences SpkInfo.mat to get the stroke treatment group
group = 1; %[1:4 6]
% animal picks which specific animal 
animal = 7; % [1:size(SpkInfo{i,2},2)
% Load file
activefilepath = ['C:\Users\user\Documents\MATLAB\Data\' SpkInfo{group,1} '_' num2str(animal)  '\concatenatedLFP.mat'];
load(activefilepath);

Control = cLFP(:,SpkInfo{group,2}(animal).R_chn{3}(1));

% Stroke LFP
group = 3; %[1:4 6] % 3
animal = 10; % [1:size(SpkInfo{i,2},2) % 10
activefilepath = ['C:\Users\user\Documents\MATLAB\Data\' SpkInfo{group,1} '_' num2str(animal)  '\concatenatedLFP.mat'];
load(activefilepath);

Stroke = cLFP(:,SpkInfo{group,2}(animal).R_chn{3}(1));
%% Filter
disp('Filtering')
Theta_C = BPfilter(Control,Fs,4,7); % filter for Theta (4-7 Hz)
Delta_C = BPfilter(Control,Fs,0.1,3); % filter for Delta (0.1-3 Hz)

Theta_S = BPfilter(Stroke,Fs,4,7); % filter for Theta (4-7 Hz)
Delta_S = BPfilter(Stroke,Fs,0.1,3); % filter for Delta (0.1-3 Hz)

% Hilbert and envelop extraction
H_Theta_C = abs(hilbert(Theta_C));
H_Delta_C = abs(hilbert(Delta_C));

H_Theta_S = abs(hilbert(Theta_S));
H_Delta_S = abs(hilbert(Delta_S));

% Smoothing
S_Theta_C = smoothvect(H_Theta_C, kernel);
S_Delta_C = smoothvect(H_Delta_C, kernel);

S_Theta_S = smoothvect(H_Theta_S, kernel);
S_Delta_S = smoothvect(H_Delta_S, kernel);

% Theta/Delta envelope
Theta_Delta_C = S_Theta_C./S_Delta_C;
S_Theta_Delta_C = smoothvect(Theta_Delta_C, kernel2);

Theta_Delta_S = S_Theta_S./S_Delta_S;
S_Theta_Delta_S = smoothvect(Theta_Delta_S, kernel2);

%% find the Rem period
thresh = 0.5;
mindur = 10; % in sec, standard 10
disp('making index')
High_C = find(S_Theta_Delta_C > thresh);
High_S = find(S_Theta_Delta_S > thresh);

crossings_C = find(Fs*10 < diff(High_C) );
crossings_S = find(Fs*10 < diff(High_S) );
C_idx = [0 High_C(crossings_C+1); High_C(crossings_C) High_C(end)];

S_idx = [0 High_S(crossings_S+1)'; High_S(crossings_S)' High_S(end)];

%% Plot for checking
disp('Plotting')
load('Colors.mat')
%%%%%%%%%
figure('Name',[SpkInfo{group,1} '_' num2str(animal)]);
%%
%LFPs for control and Stroke will be different, need separate time values
timeC = (1:size(Control,1))/Fs;
timeS = (1:size(Stroke,1))/Fs;
hold on
% Plotting
% Raw Filters 
ax1 = subplot('Position',[0.15 0.7666 0.37 0.1333]);
plot(timeC,Theta_C,'Color',Lin.mTeal); ylabel('\theta (3-7 Hz)')
title('Control','FontSize',14);
set(gca, 'xtick',[],'ytick',[],'FontSize',13)
axis([0  inf -20000 20000])
box off

ax2 = subplot('Position',[0.55 0.7666 0.37 0.1333]);
plot(timeS,Theta_S,'Color',Lin.mPurple)
title('Stroke');
set(gca, 'xtick',[],'ytick',[],'FontSize',14)
axis([0  inf -20000 20000])
box off

ax3 = subplot('Position',[0.15 0.6333 0.37 0.1333]);
plot(timeC,Delta_C,'Color',Lin.dTeal);ylabel('\delta (0.1-3 Hz)')
set(gca, 'xtick',[],'ytick',[],'FontSize',14)
axis([0  inf -20000 20000])
box off
ax4 = subplot('Position',[0.55 0.6333 0.37 0.1333]);
plot(timeS,Delta_S,'Color',Lin.dPurple)
set(gca, 'xtick',[],'ytick',[],'FontSize',14)
axis([0  inf -20000 20000])
box off

% % Positive half (take these out?)
% ax5 = subplot('Position',[0.1 0.6 0.39 0.1]);
% plot(timeC,H_Theta_C,'k:');ylabel({'Theta', 'Envelope'})
% set(gca, 'xtick',[],'ytick',[])
% axis([0  inf -20000 20000])
% box off
% 
% ax6 = subplot('Position',[0.5 0.6 0.39 0.1]);
% plot(timeS,H_Theta_S,'k:')
% set(gca, 'xtick',[],'ytick',[])
% axis([0  inf -20000 20000])
% box off
% 
% ax7 = subplot('Position',[0.1 0.5 0.39 0.1]);
% plot(timeC,H_Delta_C,'k:');ylabel({'Delta', 'Envelope'})
% set(gca, 'xtick',[],'ytick',[])
% axis([0  inf -20000 20000])
% box off
% 
% ax8 = subplot('Position',[0.5 0.5 0.39 0.1]);
% plot(timeS,H_Delta_S,'k:')
% set(gca, 'xtick',[],'ytick',[])
% axis([0  inf -20000 20000])
% box off

% Positive envelope
ax9 = subplot('Position',[0.15 0.5 0.37 0.1333]);
plot(timeC,S_Theta_C,'Color',Lin.mTeal), ylabel({'\theta envelope'})
set(gca, 'xtick',[],'ytick',[],'FontSize',14)
axis([0  inf 0 10000])
box off

ax10 = subplot('Position',[0.55 0.5 0.37 0.1333]);
plot(timeS,S_Theta_S,'Color',Lin.mPurple)
set(gca, 'xtick',[],'ytick',[],'FontSize',14)
axis([0  inf 0 10000])
box off

ax11 = subplot('Position',[0.15 0.3666 0.37 0.1333]);
plot(timeC,S_Delta_C,'Color',Lin.dTeal);ylabel('\delta envelope')
set(gca, 'xtick',[],'ytick',[],'FontSize',14)
axis([0  inf 0 10000])
box off

ax12 = subplot('Position',[0.55 0.3666 0.37 0.1333]);
plot(timeS,S_Delta_S,'Color',Lin.dPurple)
set(gca, 'xtick',[],'ytick',[],'FontSize',14)
axis([0  inf 0 10000])
box off

% Smoothed Plots
ax13 = subplot('Position',[0.15 0.233 0.37 0.1333]);
plot(timeC,Theta_Delta_C,'Color', Lin.dTeal);ylabel({'\theta / \delta'})
set(gca, 'xtick',[],'ytick',[],'FontSize',14)
axis([0  inf 0 3])
box off

ax14 = subplot('Position',[0.55 0.2333 0.37 0.1333]);
plot(timeS,Theta_Delta_S,'Color', Lin.dPurple)
set(gca, 'xtick',[],'ytick',[],'FontSize',14)
axis([0  inf 0 3])
box off


ax15 = subplot('Position',[0.15 0.1 0.37 0.133]);
xlabel('Time (2 hours)')
set(gca,'xtick',[],'ytick',[],'FontSize',14)
axis([0  inf 0 3])
%plots boxes over High T/D periods
for i = 1:length(C_idx)
    hold on
    patch([C_idx(1,i)/Fs C_idx(1,i)/Fs C_idx(2,i)/Fs C_idx(2,i)/Fs],[0 3 3 0],'k','EdgeColor','none')
end
alpha(0.3)
plot(timeC, S_Theta_Delta_C,'Color', Lin.mTeal,'LineWidth',1.5);

box off
ylabel({'\theta/\delta Smoothed'});
%xlim([timeC(1) timeC(end)]);

ax16 = subplot('Position',[0.55 0.1 0.37 0.133]);

xlabel('Time (2 hours)')
set(gca,'xtick',[],'ytick',[],'FontSize',14)
axis([0  inf 0 3])

%plots boxes over High T/D periods
for i = 1:length(S_idx)
    hold on
    patch([S_idx(1,i)/Fs S_idx(1,i)/Fs S_idx(2,i)/Fs S_idx(2,i)/Fs],[0 3 3 0],'k','EdgeColor','none')
end
alpha(0.3)
plot(timeS, S_Theta_Delta_S,'Color', Lin.mPurple,'LineWidth',1.5);

xlim([timeS(1) timeS(end)]);


%% Legends
ax17 = subplot('Position',[0.06 0.7 0.001 0.1333]);
set(gca, 'xtick',[],'FontSize',12)
axis([0  inf -20000 20000])
ylabel('Amplitude (nV)')
box off

% plots a near 2D subplot which acts as the legend for envelope plots
ax19 = subplot('Position',[0.09 0.44 0.001 0.1333]);
set(gca, 'xtick',[],'FontSize',12)
axis([0  inf 0 10000])
ytickformat('%.0e')
% ylabel('Amplitude (uV)')
box off

% plots a near 2D subplot which acts as the legend for ratio plots
ax18 = subplot('Position',[0.08 0.2 0.001 0.1333]);
set(gca, 'xtick',[],'FontSize',12)
axis([0  inf 0 3])
ylabel('Amplitude Ratio')
box off
% plots a grey box which acts as the legend for High T/D periods
ax20 = subplot('Position',[0.06 0.08 0.03 0.03]);
patch([0 0 1 1],[0 1 1 0], 'k')
set(gca, 'xtick',[], 'ytick', [],'FontSize',12)
ylabel({'High Theta/Delta',  'Period'})
axis([0 1 0 1])
alpha(0.3)
box off
% subplot('Position',[0.08 0.92 0.0 0.0])
% axis off
% text(-0.2,0.2, 'A','FontSize',24);
% 
% subplot('Position',[0.65 0.92 0.0 0.0])
% axis off
% text(0.0,0.5, 'B','FontSize',24);
% 
% subplot('Position',[0.65 0.5 0.0 0.0])
% axis off
% text(-0.2,0.2, 'C','FontSize',24);

%% Plot bar graphs
load('C:\Users\ipzach\Documents\MATLAB\Stats\State\State.mat')
groups = {'Ipsilateral', 'Contralateral'};
sides = {'Control', 'Stroke'};
StrokeDur_R = [R_1M_dur R_2W_dur];
StrokeDur_L = [L_1M_dur L_2W_dur];

StrokeNum_R = [R_1M; R_2W];
StrokeNum_L = [L_1M; L_2W];
SE = @(data) std(data)./sqrt(length(data));

durErr = [SE(L_control_dur) SE(StrokeDur_L); SE(R_control_dur) SE(StrokeDur_R)];
numErr = [SE(L_control) SE(StrokeNum_L); SE(R_control) SE(StrokeNum_R)];

durData = [mean(L_control_dur) mean(StrokeDur_L); mean(R_control_dur) mean(StrokeDur_R)];
numData = [mean(L_control) mean(StrokeNum_L); mean(R_control) mean(StrokeNum_R)];

[~,numStats(1)] = ttest2(L_control,StrokeNum_L);
[~,numStats(2)] = ttest2(R_control,StrokeNum_R);

[~,durStats(1)] = ttest2(L_control_dur,StrokeDur_L);
[~,durStats(2)] = ttest2(R_control_dur,StrokeDur_R);
figure
%%
% # off state changes
subplot('Position', [0.15 0.15 0.3 0.8])
[numbar,numerr] = barwitherr(numErr,numData);
set(gca, 'xticklabels', groups,'FontSize',13)
box off
ylabel({'Average # of', 'state changes'})
%set(numbar(1), 'Facecolor', 'k')
numbar(1).FaceColor = 'flat';
numbar(2).FaceColor = 'flat';
numbar(1).CData(1,:) = Lin.lBlue;
numbar(2).CData(1,:) = Lin.lOrange;

numbar(1).CData(2,:) = Lin.lBlue;
numbar(2).CData(2,:) = Lin.lOrange;
% alpha(0.7)
%set(numbar(2), 'Facecolor', 'w')

sigstar2({[0.7 1.25] [1.7 2.25]}, numStats);

% Duration of state
subplot('Position', [0.6 0.15 0.3 0.8])
[durbar,durerr] = barwitherr(durErr,durData);
set(gca, 'xticklabels', groups,'ylim',[0 2100],'ytick',[0 700,1400, 2100],'FontSize',13)
box off
ylabel({'Average Duration', 'of state (s)'})
durbar(1).FaceColor = 'flat';
durbar(2).FaceColor = 'flat';
durbar(1).CData(1,:) = Lin.lBlue;
durbar(2).CData(1,:) = Lin.lOrange;

durbar(1).CData(2,:) = Lin.lBlue;
durbar(2).CData(2,:) = Lin.lOrange;
sigstar2({[0.7 1.25] [1.7 2.25]},durStats);

legend(durbar,sides,'Location','southoutside','Orientation', 'horizontal','Box', 'off')
box off
disp('done')