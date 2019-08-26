% This program will take in signal power files and compare across
% groups
% clear all
cd('C:\Users\ipzac\Documents\MATLAB')
load('SpkInfo.mat')

% Load normalized or raw data
norm = true;
%% Initializing 4D Group plots
switch norm
    case false
        cd('C:\Users\ipzac\Documents\MATLAB\Stats\Power')
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
    case true
        cd('C:\Users\ipzac\Documents\MATLAB\Stats\Power')
        load('NormalizedPower.mat')
        normState = 'Normalized';
        Control.R = [NormalizedPower{1,2}.R];
        Control.L = [NormalizedPower{1,2}.L];
        EESham.R = [NormalizedPower{2,2}.R];
        EESham.L = [NormalizedPower{2,2}.L];
        MStrk.R = [NormalizedPower{3,2}.R ];
        MStrk.L = [NormalizedPower{3,2}.L];
        WStrk.R = [NormalizedPower{4,2}.R ];
        WStrk.L = [NormalizedPower{4,2}.L];
        EEStrk.R = [NormalizedPower{6,2}.R];
        EEStrk.L = [NormalizedPower{6,2}.L];
end

%% stuff
for i = 1:5
    for layer = 1:4
        for band = 1:6
            switch i
                case 1
                    Cdata.R = Control.R(5:end,band, layer);
                    Cdata.L = Control.L(5:end,band, layer);
                    Sdata.R = [WStrk.R(4:end,band,layer); MStrk.R([1:4 6 8:end],band,layer)];
                    Sdata.L = [WStrk.L(4:end,band,layer); MStrk.L([1:4 6 8:end],band,layer)];
                    name = 'CvS ';
                case 2
                    Cdata.R = EESham.R(:,band, layer);
                    Cdata.L = EESham.L(:,band, layer);
                    Sdata.R = EEStrk.R([1:4 6:end],band, layer);
                    Sdata.L = EEStrk.L([1:4 6:end],band, layer);
                    name = 'ECvES ';
                case 3
                    Cdata.R = [Control.R(5:end,band, layer); EESham.R(:,band, layer)];
                    Cdata.L = [Control.L(5:end,band, layer); EESham.L(:,band, layer)];
                    Sdata.R = [WStrk.R(4:end,band,layer); MStrk.R([1:4 6 8:end],band,layer); EEStrk.R([1:4 6:end],band, layer)];
                    Sdata.L = [WStrk.L(4:end,band,layer); MStrk.L([1:4 6 8:end],band,layer); EEStrk.L([1:4 6:end],band, layer)];
                    name = 'TCvTS ';
                case 4
                    Cdata.R = Control.R(5:end,band, layer);
                    Cdata.L = Control.L(5:end,band, layer);
                    Sdata.R = EESham.R(:,band, layer);
                    Sdata.L = EESham.L(:,band, layer);
                    name = 'CvE ';
                case 5
                    Cdata.R = MStrk.R([1:4 6 8:end],band,layer);
                    Cdata.L = MStrk.L([1:4 6 8:end],band,layer);
                    Sdata.R = EEStrk.R([1:4 6:end],band, layer);
                    Sdata.L = EEStrk.L([1:4 6:end],band, layer);
                    name = 'MvE ';
            end
            
            [~,RP] = ttest2(Cdata.R,Sdata.R);
            [~,LP] = ttest2(Cdata.L,Sdata.L);
            
            stats.RP(layer, band) = RP;
            stats.LP(layer, band) = LP;
            
            stats.RCmean(layer, band) = mean(Cdata.R);
            stats.LCmean(layer,band) = mean(Cdata.L);
            stats.RSmean(layer,band) = mean(Sdata.R);
            stats.LSmean(layer,band) = mean(Sdata.L);
            
            stats.RCstd(layer, band) = std(Cdata.R)/sqrt(length(Cdata.R));
            stats.LCstd(layer,band) = std(Cdata.L)/sqrt(length(Cdata.L));
            stats.RSstd(layer,band) = std(Sdata.R)/sqrt(length(Sdata.R));
            stats.LSstd(layer,band) = std(Sdata.L)/sqrt(length(Sdata.L));
            
        end
    end
    save(['C:\Users\ipzac\Documents\MATLAB\Stats\Power\' normState '_' name 'Split Stats'],'stats')
 end
disp('Finished and saved')