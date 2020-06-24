% loads PAC movie file and plots movies over time.
name = '1M Strk_9';
phase = 'cortex';

cd('C:\Users\user\Documents\MATLAB\ComodulogramsLite')
cd(name)
load([phase ' phase Movie.mat'])
fullMovie = [];
%%

xlen = 0.23;
ylen = 0.37;
PhaseFreqVector = 0:0.5:12;
AmpFreqVector = 0:2.5:160;
PhaseFreq_BandWidth = 0.5;
AmpFreq_BandWidth = 2.5;
hMap = cubehelix(800,2.5,0.8,1.4,0.55);

maxVal = 0.02; % max([max(lpMovie(:)), max(rpMovie(:)),max(lsMovie(:)),max(rsMovie(:)),max(loMovie(:)),max(roMovie(:))]);
frame = figure;
set(gcf,'Position',[1200 0 900 600])

    % State label
    annotation('Textbox',[0.82, 0.85, 0.1,0.05], 'String','\theta/\delta State')
    box off
for i = 1:length(roMovie)
    % Top left (Left Pyramidal)
    subplot('Position', [0.1 0.475 xlen ylen])
    pcolor(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,lpMovie(:,:,i)')
    shading interp, colormap(hMap)
    caxis([0 maxVal])
    title('Pyramidal')
    ylabel('Ipsilateral')
    set(gca,'xtick',[])
    
    % Top Mid (left SLM)
    subplot('Position', [0.333 0.475 xlen ylen])
    pcolor(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,lsMovie(:,:,i)')
    shading interp, colormap(hMap)
    caxis([0 maxVal])
    title('SLM')
    set(gca,'xtick',[],'ytick',[])
    
    % Top right (left oriens)
    subplot('Position', [0.567 0.475 xlen ylen])
    colororder({'k','k'});
    yyaxis left
    pcolor(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,loMovie(:,:,i)')
    shading interp, colormap(hMap)
    caxis([0 maxVal])
    title('Oriens')
    set(gca,'xtick',[],'ytick',[])
    yyaxis right
     set(gca,'xtick',[],'ytick',[])
     ylabel(lState{i})
    % Bot left (right Pyramidal)
    subplot('Position', [0.1 0.1 xlen ylen])
    pcolor(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,lpMovie(:,:,i)')
    shading interp, colormap(hMap)
    caxis([0 maxVal])
    ylabel('Contralateral')
    
    % Bot Mid (right SLM)
    subplot('Position', [0.333 0.1 xlen ylen])
    pcolor(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,lsMovie(:,:,i)')
    shading interp, colormap(hMap)
    caxis([0 maxVal])
    set(gca,'ytick',[])
    
    % Bot right (right oriens)
    subplot('Position', [0.567 0.1 xlen ylen])
    colororder({'k','k'});
    yyaxis left
    pcolor(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,loMovie(:,:,i)')
    shading interp, colormap(hMap)
    caxis([0 maxVal])
    set(gca,'ytick',[])
    yyaxis right
    set(gca,'xtick',[],'ytick',[])
    ylabel(rState{i})
    
   % colorbar
   if i ==1
    cbar = colorbar('Position',[0.85 0.3 0.02 0.4]);
    cbar.YTick = [0 0.01 0.02];
   end
    % Convert to gif
    [imind, cm] = rgb2ind(frame2im(getframe(frame)),256);
    if i == 1
    imwrite(imind,cm,[phase name '.gif'],'gif','Loopcount',inf);
    else
      imwrite(imind,cm,[phase name '.gif'],'gif','WriteMode','append');  
    end
end
disp('Done')