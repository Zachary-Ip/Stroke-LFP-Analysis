Fs = 1250;
load('SpkInfo.mat')
cd('C:\Users\user\Documents\MATLAB\SWR')
load('C:\Users\user\Documents\MATLAB\SWR\6SD\Control_L9.mat')
cd('C:\Users\user\Documents\MATLAB\Data\Control_9')
load('concatenatedLFP.mat')
load('Colors.mat')
%%
brainColor = [199 5 255] ./255;
figure
set(gcf,'Position',[1000 50 1200 400])
time = linspace(0,1.25,1565);
subplot('Position', [0.1 .6 0.85 .4])
pyr = BPfilter(cLFP(2899800-650:2899800+(1900),7),1250,100,300);
plot(pyr,'k')
xlim([0 2500])
set(gca,'xtick',[],'xticklabel',[],'xcolor','none','ytick',[],'yticklabel',[],'FontSize',20)
ylabel({'Pyramidal', 'Layer'})
box off
patch([1640  1778 1778 1640], [-510 -510 500 500],brainColor,'FaceAlpha',0.3,'EdgeColor','none')
patch([936  1130 1130 936], [-510 -510 500 500],brainColor,'FaceAlpha',0.3,'EdgeColor','none')

subplot('Position', [0.1 .2 0.85 .4])
rad = BPfilter(cLFP(2899800-650:2899800+1900,5),1250,3,120);
plot(rad,'k')
xlim([0 2500])
set(gca,'xtick',[],'xticklabel',[],'ytick',time,'yticklabel',[],'FontSize',20)
ylabel({'Radiatum', 'Layer'})
xlabel('Time (1s)')
box off
patch([1640  1778 1778 1640], [-5000 -5000 5000 5000],brainColor,'FaceAlpha',0.3,'EdgeColor','none')
patch([936  1130 1130 936], [-5000 -5000 5000 5000],brainColor,'FaceAlpha',0.3,'EdgeColor','none')

