% This code will load all the LFPs and SWR files and create average CSD's
% using all ripples in all animals
clear all
load('SpkInfo.mat')
SWR_path = 'C:\Users\ipzach\Documents\MATLAB\SWR\3SD'; % SWR path
LFP_path = 'C:\Users\ipzach\Documents\MATLAB\Data'; % data path
Fs = 1250;
volt_scaler = 0.000000001; % convert units to volts
hotcold = redblue();

[Fparams.tapers,~] = dpss(1250/5,4);
Fparams.Fs = Fs;
Fparams.fpass = [10 250];
time = linspace(-1,1,2501);
% Run through all groups
for group = [4 6]
    cd(LFP_path)
    disp(SpkInfo{group,1}) %Readout
    files = dir([SpkInfo{group,1} '*']);
    figure
    counter = 0;
    xsize = 1:2501;
    ysize = linspace(-3e+03, 3e+03,16);
    hold on
    % Run through all animals
    for animal = 1:length(files)
        %Navigate to animals folder
        cd(files(animal).name)
        disp(files(animal).name) %Read out
        % Load neccesary data and reference files, skip animal if any are
        % missing
        try
            load('cREM.mat')
        catch
            disp('Missing cREM file')
            cd ..
            continue
        end
        if isempty(cREM.R.start) || isempty(cREM.R.end)
            disp('Missing REM Start or End Times for Right Side')
            cd ..
            continue
        end
        if isempty(cREM.L.start) || isempty(cREM.L.end)
            disp('Missing REM Start or End Times for Left Side')
            cd ..
            continue
        end
        if isempty(SpkInfo{group,2}(str2num(files(animal).name(strfind(files(animal).name,'_')+1:end))).L_chn{3}) || ...
                isempty(SpkInfo{group,2}(str2num(files(animal).name(strfind(files(animal).name,'_')+1:end))).R_chn{3}) ||...
                SpkInfo{group,2}(str2double(files(animal).name(strfind(files(animal).name,'_')+1:end))).L_chn{3}(1) >16
            disp('Missing SpkInfo')
            cd ..
            continue
        end
        load('concatenatedLFP.mat')
        
        % Grab index of LTD periods
        TDIdxL = [];
        LowLeftStart = cREM.L.end(1:end-1);
        LowLeftEnd = cREM.L.start(2:end);
        for iRem = 1:length(LowLeftStart)
            TDIdxL = [TDIdxL (round(LowLeftStart(iRem)*Fs)):(round(LowLeftEnd(iRem)*Fs))];
        end
        TDIdxR = [];
        LowRightStart = cREM.R.end(1:end-1);
        LowRightEnd = cREM.R.start(2:end);
        for iRem = 1:length(LowRightStart)
            TDIdxR = [TDIdxR (round(LowRightStart(iRem)*Fs)):(round(LowRightEnd(iRem)*Fs))];
        end
        
        % Navigate to the SWR Files
        cd(SWR_path)
        % Left Side
        try load([SpkInfo{group,1} '_L' files(animal).name(strfind(files(animal).name,'_')+1:end)])
            disp([SpkInfo{group,1} '_L' files(animal).name(strfind(files(animal).name,'_')+1:end)])
        catch
            disp(['Missing SWR file for ' files(animal).name])
        end
        
        % Initialize an empty vector to store the CSD in
        SWR_CSD_L = []; % zeros(Fs*2+1,16,length(SWRevents)-2);
        counter1 = 0;
        for i = 1:length(SWRevents)-1 % start at two to keep window size consistent
            if SWRevents(i,1) >= 1250
                start_val = SWRevents(i,1);
                % Check if SWR event is during LTD or not
                if ismember(start_val,TDIdxL)
                    counter1 = counter1 +1;
                    ripple = cLFP(start_val-Fs:start_val+Fs,1:16).*volt_scaler;
                    extended_ripple = zeros(2501,18);
                    extended_ripple(:,1) = ripple(:,1);
                    extended_ripple(:,2:17) = ripple;
                    extended_ripple(:,18) = ripple(:,16);
                    SWR_CSD_L(:,:,counter1) = CSDlite(extended_ripple, Fs, 0.0001);
                    
                    waveform_L(counter1,:) = Signal.HP_Pyramidal_Layer(start_val-Fs:start_val+Fs);
                    Fullband = ripple(:,SpkInfo{group,2}(str2double(files(animal).name(strfind(files(animal).name,'_')+1:end))).L_chn{3}(1));
                    [S,t,f] = mtspecgramc(Fullband,[0.2  0.01],Fparams);
                    FuSpec_L(:,:,counter1) = S;
                    
                end
            end
        end
        
        % Right Side
        try load([SpkInfo{group,1} '_R' files(animal).name(strfind(files(animal).name,'_')+1:end)])
            disp(([SpkInfo{group,1} '_R' files(animal).name(strfind(files(animal).name,'_')+1:end)]))
        catch
            disp(['Missing SWR file for ' files(animal).name])
        end
        SWR_CSD_R = []; % zeros(Fs*2+1,16,length(SWRevents)-2);
        counter2 = 0;
        for i = 1:length(SWRevents)-1
            if SWRevents(i,1) >= 1250
                start_val = SWRevents(i,1);
                if ismember(start_val,TDIdxR)
                    counter2 = counter2 +1;
                    ripple = cLFP(start_val-Fs:start_val+Fs,17:32).*volt_scaler;
                    extended_ripple = zeros(2501,18);
                    extended_ripple(:,1) = ripple(:,1);
                    extended_ripple(:,2:17) = ripple;
                    extended_ripple(:,18) = ripple(:,16);
                    SWR_CSD_R(:,:,counter2) = CSDlite(extended_ripple, Fs, 0.0001);
                    
                    waveform_R(counter2,:) = Signal.HP_Pyramidal_Layer(start_val-Fs:start_val+Fs);
                    
                    Fullband = ripple(:,SpkInfo{group,2}(str2double(files(animal).name(strfind(files(animal).name,'_')+1:end))).R_chn{3}(1)-16); % waveform_R(i,:);
                    [S,t,f] = mtspecgramc(Fullband,[0.2  0.01],Fparams);
                    FuSpec_R(:,:,counter2) = S;
                end
            end
        end
        % Save animal file in Data folder
        cd(LFP_path)
        cd(files(animal).name)
        if ~isempty(SWR_CSD_L) && ~isempty(SWR_CSD_R)
            counter = counter +1;
            subplot(3,8,counter*2-1)
            pcolor(xsize,ysize,flipud(mean(SWR_CSD_L(:,2:17,:),3)')), shading interp, colormap(flipud(hotcold))
            p_layer = 18-SpkInfo{group,2}(str2double(files(animal).name(strfind(files(animal).name,'_')+1:end))).L_chn{3}(1);
            title('Left')
            hold on
            
            plot(mean(waveform_L,1),'k')
            
            subplot(3,8,counter*2)
            pcolor(xsize,ysize,flipud(mean(SWR_CSD_R(:,2:17,:),3)')), shading interp, colormap(flipud(hotcold))
            p_layer = 34-SpkInfo{group,2}(str2double(files(animal).name(strfind(files(animal).name,'_')+1:end))).R_chn{3}(1);
            title('Right')
            
            hold on
            plot(mean(waveform_R,1),'k')
            drawnow
            save('LTD SWR CSD R','SWR_CSD_R','waveform_R','-v7.3')
            save('LTD SWR CSD L','SWR_CSD_L','waveform_L','-v7.3')
        end
        cd ..
        disp(['Saved ' files(animal).name])
        % end animal
    end
    suplabel(SpkInfo{group,1},'t');
end
disp('It worked! I think..')