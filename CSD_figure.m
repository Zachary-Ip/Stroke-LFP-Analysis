% CSD figure
load('CSD Stats.mat')
load('Colors.mat')
% || +--+--+--+
% || +--+--+--+
% || +--+--+--+

% Scale bars and indices
time = linspace(-1,1,2501);
ySize = linspace(-6e+03, 2e+03,10);
electrodes = 1:10;
hotcold = redblue();
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
set(gcf,'Position',[0 0 1500 1000])
% top left box, Control CSD
subplot('Position',[0.18 0.55 0.2 0.35])

pcolor(time,ySize,flipud(bar_block(1).R_CSD'))
shading interp, colormap(flipud(hotcold))
caxis([-0.10 0.10])
set(gca,'xtick',[],'yticklabel',electrodes)
ylabel('Electrode')
hold on
plot(time,bar_block(1).R_wave,'color',RGB.c200)
ylim([-5000 2000])


title('Control')


% top middle box, EE Control CSD
subplot('Position',[0.43 0.55 0.2 0.35])
colororder({'k','k'})
yyaxis left
pcolor(time,ySize,flipud(bar_block(2).R_CSD'))
set(gca, 'xtick',[],'ytick', [])
shading interp, colormap(flipud(hotcold))
caxis([-0.05 0.05])
yyaxis right
plot(time,bar_block(2).R_wave,'color',RGB.c200)
ylim([-6e+03 2e+03])
ylabel('Voltage (\muV)')
title('EE Control')

% top right box, bar multiple comparison
error = [bar_block(1).R_SE bar_block(2).R_SE bar_block(3).R_SE bar_block(4).R_SE bar_block(6).R_SE];
data = [bar_block(1).R_mean bar_block(2).R_mean bar_block(3).R_mean bar_block(4).R_mean bar_block(6).R_mean];
labels = {'Ctrl','EE', '1M','2W','EE'};
comp_group = {};
stats = [];
counter = 0;
for compares = 1:size(Rc,2)
    if Rc(compares,6)*10 <= 0.05
        counter = counter +1;
        comp_group{counter} = [Rc(compares,1) Rc(compares,2)];
        stats(counter) = Rc(compares,6);
    end
end

subplot('Position',[0.75 0.55 0.2 0.35])
[hbar, hErrorbar] = barwitherr(error,data,'FaceColor','flat');
set(gca, 'ytick',[0 0.05 0.1],'xticklabels',labels)
box off
sigs = sigstar2(comp_group, stats);
title('Source-Sink Amplitude')
hbar.CData(1,:) = RGB.c200;
hbar.CData(2,:) = RGB.c200;
hbar.CData(3,:) = RGB.c200;
hbar.CData(4,:) = RGB.c200;
hbar.CData(5,:) = RGB.c200;

% Bottom left box, 1M Strk CSD
subplot('Position',[0.18 0.1 0.2 0.35])
pcolor(time,ySize,flipud(bar_block(3).R_CSD'))
shading interp, colormap(flipud(jet))
caxis([-0.12 0.12])
hold on
plot(time,bar_block(3).R_wave,'color', RGB.c200)
set(gca,'yticklabel',electrodes)
title('1 Month Stroke')
ylabel('Electrode')
xlabel('Time (s)')

% Bottom middle box, 2W Strk CSD
subplot('Position',[0.43 0.1 0.2 0.35])
pcolor(time,ySize,flipud(bar_block(4).R_CSD'))
shading interp, colormap(flipud(parula))
caxis([-0.12 0.12])
hold on
plot(time,bar_block(4).R_wave,'color',RGB.c200)
set(gca,'ytick',[])
title('2 Week Stroke')
xlabel('Time (s)')

% Bottom right box, EE Strk CSD
subplot('Position',[0.68 0.1 0.2 0.35])
colororder({'k','k'})
yyaxis left
pcolor(time,ySize,flipud(bar_block(6).R_CSD'))
set(gca,'ytick',[])
shading interp, colormap(flipud(hotcold))
caxis([-0.12 0.12])
yyaxis right
plot(time,bar_block(6).R_wave,'color',RGB.c200)
ylim([-6e+03 2e+03])
ylabel('                 Voltage (\muV)')

title('EE Month Stroke')
xlabel('Time (s)')

% Left side colorbar
cbar = colorbar('Position',[0.08 0.3 0.03 0.4]);
cbar.Label.String = 'Current (\muA / mm^3)';
cbar.TickDirection = 'in';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
set(gcf,'Position',[1000 0 1500 1000])
% top left box, Control CSD
subplot('Position',[0.25 0.55 0.2 0.35])
pcolor(time,ySize,flipud(bar_block(1).L_CSD'))
shading interp, colormap(flipud(hotcold))
caxis([-0.12 0.12])
hold on
plot(time,bar_block(1).L_wave,'color',RGB.c200)
set(gca,'xtick',[],'yticklabel',electrodes)
ylabel('Electrode')
title('Control')


% top middle box, EE Control CSD
subplot('Position',[0.5 0.55 0.2 0.35])
pcolor(time,ySize,flipud(bar_block(2).L_CSD'))
shading interp, colormap(flipud(hotcold))
caxis([-0.12 0.12])
hold on
plot(time,bar_block(2).L_wave,'color',RGB.c200)
set(gca,'ytick',electrodes)
axis off
title('EE Control')

% top right box, bar multiple comparison
error = [bar_block(1).L_SE bar_block(2).L_SE bar_block(3).L_SE bar_block(4).L_SE bar_block(6).L_SE];
data = [bar_block(1).L_mean bar_block(2).L_mean bar_block(3).L_mean bar_block(4).L_mean bar_block(6).L_mean];
labels = {'Ctrl','EE', '1M','2W','EE'};
comp_group = {};
stats = [];
counter = 0;
for compares = 1:size(Lc,2)
    if Lc(compares,6)*10 <= 0.05
        counter = counter +1;
        comp_group{counter} = [Lc(compares,1) Lc(compares,2)];
        stats(counter) = Lc(compares,6);
    end
end

subplot('Position',[0.75 0.55 0.2 0.35])
[hbar, hErrorbar] = barwitherr(error,data,'FaceColor','flat');
set(gca, 'ytick',[0 0.05 0.1],'xticklabels',labels)
box off
sigs = sigstar2(comp_group, stats);
title('Source-Sink Amplitude')
hbar.CData(1,:) = RGB.mSky; % [0.8 0.8 0.8];
hbar.CData(2,:) = RGB.mSky; % [0.8 0.8 0.8];
hbar.CData(3,:) = RGB.mYellowOrange;
hbar.CData(4,:) = RGB.mYellowOrange;
hbar.CData(5,:) = RGB.mYellowOrange;

% Bottom left box, 1M Strk CSD
subplot('Position',[0.25 0.1 0.2 0.35])
pcolor(time,ySize,flipud(bar_block(3).L_CSD'))
shading interp, colormap(flipud(jet))
caxis([-0.12 0.12])
hold on
plot(time,bar_block(3).L_wave,'color',RGB.dYellowOrange)
set(gca,'yticklabel',electrodes)
title('1 Month Stroke')
ylabel('Electrode')
xlabel('Time (s)')

% Bottom middle box, 2W Strk CSD
subplot('Position',[0.5 0.1 0.2 0.35])
pcolor(time,ySize,flipud(bar_block(4).L_CSD'))
shading interp, colormap(flipud(parula))
caxis([-0.12 0.12])
hold on
plot(time,bar_block(4).L_wave,'color',RGB.dYellowOrange)
set(gca,'ytick',[])
title('2 Week Stroke')
xlabel('Time (s)')

% Bottom right box, EE Strk CSD
subplot('Position',[0.75 0.1 0.2 0.35])
pcolor(time,ySize,flipud(bar_block(6).L_CSD'))
shading interp, colormap(flipud(hotcold))
caxis([-0.12 0.12])
hold on
plot(time,bar_block(6).L_wave,'color',RGB.dYellowOrange)
set(gca,'ytick',[])
title('EE Month Stroke')
xlabel('Time (s)')

% Left side colorbar
cbar = colorbar('Position',[0.12 0.3 0.03 0.4]);
cbar.Label.String = 'Current (\muA / mm^3)';
cbar.TickDirection = 'in';









