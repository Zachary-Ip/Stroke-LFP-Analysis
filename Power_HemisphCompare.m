% This program will take in signal power files and compare across
% groups
clear all

cd('C:\Users\user\Documents\MATLAB')
load('SpkInfo.mat')

% Load normalized or raw data
norm = true;
%% Initializing 4D Group plots
if norm
    cd('C:\Users\user\Documents\MATLAB\Stats\Power')
    load('NormalizedPower.mat')
    normState = 'Normalized';
    Control.R = [NormalizedPower{1,2}.R];
    Control.L = [NormalizedPower{1,2}.L];
    EESham.R =  [NormalizedPower{2,2}.R];
    EESham.L =  [NormalizedPower{2,2}.L];
    MStrk.R =   [NormalizedPower{3,2}.R ];
    MStrk.L =   [NormalizedPower{3,2}.L];
    WStrk.R =   [NormalizedPower{4,2}.R ];
    WStrk.L =   [NormalizedPower{4,2}.L];
    EEStrk.R =  [NormalizedPower{6,2}.R];
    EEStrk.L =  [NormalizedPower{6,2}.L];
    
    Stroke.R = [NormalizedPower{3,2}.R; NormalizedPower{4,2}.R];
    Stroke.L = [NormalizedPower{3,2}.L; NormalizedPower{4,2}.L];
else
    cd('C:\Users\user\Documents\MATLAB\Stats\Power')
    load('RawPower.mat')
    normState = 'Raw';
    Control.R = [RawPower{1,2}.R];
    Control.L = [RawPower{1,2}.L];
    EESham.R = [RawPower{2,2}.R];
    EESham.L = [RawPower{2,2}.L];
    MStrk.R = [RawPower{3,2}.R ];
    MStrk.L = [RawPower{3,2}.L];
    WStrk.R = [RawPower{4,2}.R ];
    WStrk.L = [RawPower{4,2}.L];
    EEStrk.R = [RawPower{6,2}.R];
    EEStrk.L = [ RawPower{6,2}.L];
    
    Stroke.R = [RawPower{3,2}.R; RawPower{4,2}.R];
    Stroke.L = [RawPower{3,2}.L;RawPower{4,2}.L];
end

%% Compare across groups each band and layer
for layer = 1:4
    for band = 1:6
        [MSVals.R] = nonzeros(MStrk.R(:,band,layer));
        [MSVals.L] = nonzeros(MStrk.L(:,band,layer));
        
        [WSVals.R] = nonzeros(WStrk.R(:,band,layer));
        [WSVals.L] = nonzeros(WStrk.L(:,band,layer));
        
        Stroke.R = [MSVals.R; WSVals.R];
        Stroke.L = [MSVals.L; WSVals.L];
        
        [~,Cp] = ttest(Control.R(5:end, band, layer), Control.L(5:end, band, layer));
        [~,EShp] = ttest(EESham.R(:, band, layer), EESham.L(:, band, layer));
        [~,MSp] = ttest(MStrk.R([1:4 6 8:end], band, layer), MStrk.L([1:4 6 8:end], band, layer));
        [~,WSp] = ttest(WStrk.R(4:end, band, layer), WStrk.L(4:end, band, layer));
        [~,EESp] = ttest(EEStrk.R([1:4 6:end], band, layer), EEStrk.L([1:4 6:end], band, layer));
        [~, Sp] = ttest(Stroke.R, Stroke.L);
        
        
        stats.Control.P(layer,band) = Cp;
        stats.Control.IpMean(layer,band)= mean(Control.L(5:end, band, layer));
        stats.Control.ConMean(layer,band) = mean(Control.R(5:end, band, layer));
        stats.Control.IpStd(layer,band) = std(Control.L(5:end, band, layer))/sqrt(length(Control.L(5:end, band, layer)));
        stats.Control.ConStd(layer,band) = std(Control.R(5:end, band, layer))/sqrt(length(Control.R(5:end, band, layer)));
        
        stats.EESham.P(layer,band) = EShp;
        stats.EESham.IpMean(layer,band) = mean(EESham.L(:, band, layer));
        stats.EESham.ConMean(layer,band) = mean(EESham.R(:, band, layer));
        stats.EESham.IpStd(layer,band) =  std(EESham.L(:, band, layer))/sqrt(length(EESham.L(:, band, layer)));
        stats.EESham.ConStd(layer,band) =  std(EESham.R(:, band, layer))/sqrt(length(EESham.R(:, band, layer)));
        
        stats.MStrk.P (layer,band)= MSp;
        stats.MStrk.IpMean(layer,band) = mean(MStrk.L([1:4 6 8:end], band, layer));
        stats.MStrk.ConMean(layer,band) = mean(MStrk.R([1:4 6 8:end], band, layer));
        stats.MStrk.IpStd(layer,band) =  std(MStrk.L([1:4 6 8:end], band, layer))/sqrt(length(MStrk.L([1:4 6 8:end], band, layer)));
        stats.MStrk.ConStd(layer,band) =  std(MStrk.R([1:4 6 8:end], band, layer))/sqrt(length(MStrk.R([1:4 6 8:end], band, layer)));
        
        stats.WStrk.P(layer,band) = WSp;
        stats.WStrk.IpMean(layer,band) = mean(WStrk.L(4:end, band, layer));
        stats.WStrk.ConMean(layer,band) = mean(WStrk.R(4:end, band, layer));
        stats.WStrk.IpStd(layer,band) =  std(WStrk.L(4:end, band, layer))/sqrt(length(WStrk.L(4:end, band, layer)));
        stats.WStrk.ConStd(layer,band) =  std(WStrk.R(4:end, band, layer))/sqrt(length(WStrk.R(4:end, band, layer)));
        
        stats.EEStrk.P(layer,band) = EESp;
        stats.EEStrk.IpMean(layer,band) = mean(EEStrk.L([1:4 6:end], band, layer));
        stats.EEStrk.ConMean(layer,band) = mean(EEStrk.R([1:4 6:end], band, layer));
        stats.EEStrk.IpStd(layer,band) =  std(EEStrk.L([1:4 6:end], band, layer))/sqrt(length(EEStrk.L([1:4 6:end], band, layer)));
        stats.EEStrk.ConStd(layer,band) =  std(EEStrk.R([1:4 6:end], band, layer))/sqrt(length(EEStrk.R([1:4 6:end], band, layer)));
        
        stats.Stroke.P(layer,band) = Sp;
        stats.Stroke.IpMean(layer,band)= mean(Stroke.L);
        stats.Stroke.ConMean(layer,band) = mean(Stroke.R);
        stats.Stroke.IpStd(layer,band) = std(Stroke.L)/sqrt(length(Stroke.L));
        stats.Stroke.ConStd(layer,band) = std(Stroke.R)/sqrt(length(Stroke.R));
    end
end
save('C:\Users\user\Documents\MATLAB\Stats\Power\Normalized L-R Stats.mat','stats')
%% Create side by side comparisons of Raw & Normalized
%[NLR; RLR; NLR; RLR;
%% Control
figure
labels = {'Ipsi', 'Contra'};
counter = 0;
for layer = 1:4
    for band = 1:6
        counter = counter +1;
        subplot(4,6,counter)
        data = [stats.Control.IpMean(layer,band) stats.Control.ConMean(layer, band)];
        error = [stats.Control.IpStd(layer,band) stats.Control.ConStd(layer, band)];
        barwitherr(error,data);
        set(gca,'xticklabels',labels, 'color','w')
        if stats.Control.P(layer,band) <= 0.05
            sigstar2([1,2],stats.Control.P(layer,band));
        end
        switch counter
            case 1
                title('Delta')
                ylabel('Cortex')
            case 2
                title('Theta')
            case 3
                title('Alpha')
            case 4
                title('Beta')
            case 5
                title('Gamma')
            case 6
                title('High Gamma')
            case 7
                ylabel({'Pyramidal'})
            case 13
                ylabel('SLM')
            case 19
                ylabel('Oriens')
        end
    end
end
suplabel([' Control'],'t');

%% EE Control
figure
labels = {'Ipsi', 'Contra'};
counter = 0;
for layer = 1:4
    for band = 1:6
        counter = counter +1;
        subplot(4,6,counter)
        data = [stats.EESham.IpMean(layer,band) stats.EESham.ConMean(layer, band)];
        error = [stats.EESham.IpStd(layer,band) stats.EESham.ConStd(layer, band)];
        barwitherr(error,data);
        set(gca,'xticklabels',labels)
        if stats.EESham.P(layer,band) <= 0.05
            sigstar([1,2],stats.EESham.P(layer,band));
        end
        switch counter
            case 1
                title('Delta')
                ylabel('Cortex')
            case 2
                title('Theta')
            case 3
                title('Alpha')
            case 4
                title('Beta')
            case 5
                title('Gamma')
            case 6
                title('High Gamma')
            case 7
                ylabel({'Pyramidal'})
            case 13
                ylabel('SLM')
            case 19
                ylabel('Oriens')
        end
    end
end
suplabel([' EESham'],'t');

%% 2W Strk
figure
labels = {'Ipsi', 'Contra'};
counter = 0;
for layer = 1:4
    for band = 1:6
        counter = counter +1;
        subplot(4,6,counter)
        data = [stats.WStrk.IpMean(layer,band) stats.WStrk.ConMean(layer, band)];
        error = [stats.WStrk.IpStd(layer,band) stats.WStrk.ConStd(layer, band)];
        barwitherr(error,data);
        set(gca,'xticklabels',labels)
        if stats.WStrk.P(layer,band) <= 0.05
            sigstar([1,2],stats.WStrk.P(layer,band));
        end
        switch counter
            case 1
                title('Delta')
                ylabel('Cortex')
            case 2
                title('Theta')
            case 3
                title('Alpha')
            case 4
                title('Beta')
            case 5
                title('Gamma')
            case 6
                title('High Gamma')
            case 7
                ylabel({'Pyramidal'})
            case 13
                ylabel('SLM')
            case 19
                ylabel('Oriens')
        end
    end
end
suplabel([' 2W Strk'],'t');
%% 1M Strk
figure
labels = {'Ipsi', 'Contra'};
counter = 0;
for layer = 1:4
    for band = 1:6
        counter = counter +1;
        subplot(4,6,counter)
        data = [stats.MStrk.IpMean(layer,band) stats.MStrk.ConMean(layer, band)];
        error = [stats.MStrk.IpStd(layer,band) stats.MStrk.ConStd(layer, band)];
        barwitherr(error,data);
        set(gca,'xticklabels',labels, 'color','w')
        if stats.MStrk.P(layer,band) <= 0.05
            sigstar([1,2],stats.MStrk.P(layer,band));
        end
        switch counter
            case 1
                title('Delta')
                ylabel('Cortex')
            case 2
                title('Theta')
            case 3
                title('Alpha')
            case 4
                title('Beta')
            case 5
                title('Gamma')
            case 6
                title('High Gamma')
            case 7
                ylabel({'Pyramidal'})
            case 13
                ylabel('SLM')
            case 19
                ylabel('Oriens')
        end
    end
end
suplabel([' 1M Strk'],'t');
%% EE Strk
figure
labels = {'Ipsi', 'Contra'};
counter = 0;
for layer = 1:4
    for band = 1:6
        counter = counter +1;
        subplot(4,6,counter)
        data = [stats.EEStrk.IpMean(layer,band) stats.EEStrk.ConMean(layer, band)];
        error = [stats.EEStrk.IpStd(layer,band) stats.EEStrk.ConStd(layer, band)];
        barwitherr(error,data);
        set(gca,'xticklabels',labels, 'color','w')
        if stats.EEStrk.P(layer,band) <= 0.05
            sigstar([1,2],stats.EEStrk.P(layer,band));
        end
        switch counter
            case 1
                title('Delta')
                ylabel('Cortex')
            case 2
                title('Theta')
            case 3
                title('Alpha')
            case 4
                title('Beta')
            case 5
                title('Gamma')
            case 6
                title('High Gamma')
            case 7
                ylabel({'Pyramidal'})
            case 13
                ylabel('SLM')
            case 19
                ylabel('Oriens')
        end
    end
end
suplabel([' EE Strk'],'t');

%% 1M + 2W Stroke
figure
labels = {'Ipsi', 'Contra'};
counter = 0;
for layer = 1:4
    for band = 1:6
        counter = counter +1;
        subplot(4,6,counter)
        data = [stats.Stroke.IpMean(layer,band) stats.Stroke.ConMean(layer, band)];
        error = [stats.Stroke.IpStd(layer,band) stats.Stroke.ConStd(layer, band)];
        barwitherr(error,data);
        set(gca,'xticklabels',labels, 'color','w')
        if stats.Stroke.P(layer,band) <= 0.05
            sigstar([1,2],stats.Stroke.P(layer,band));
        end
        switch counter
            case 1
                title('Delta')
                ylabel('Cortex')
            case 2
                title('Theta')
            case 3
                title('Alpha')
            case 4
                title('Beta')
            case 5
                title('Gamma')
            case 6
                title('High Gamma')
            case 7
                ylabel({'Pyramidal'})
            case 13
                ylabel('SLM')
            case 19
                ylabel('Oriens')
        end
    end
end
suplabel([' Stroke'],'t');
