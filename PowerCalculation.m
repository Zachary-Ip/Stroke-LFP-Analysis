%% This file calculates the power of each animal
%most recently edited by Zachary Ip 6/19
clear all;
tic
disp('Initializing Files')
filepath = 'C:\Users\ipzach\Documents\MATLAB';
cd(filepath)
load('SpkInfo.mat')
Fs = 1250;
% Normalized or not?
norm = true;
split =true;

%% Load right and left side signals
for group = 3 % [1:4 6]
    switch group
        case 1
            files = 5:length(SpkInfo{group,2});
        case 2
            files = 1:length(SpkInfo{group,2});
        case 3
            files = [1:4, 6, 8:length(SpkInfo{group,2})];
        case 4
            files = 4:length(SpkInfo{group,2});
        case 6
            files = [1:4, 6:length(SpkInfo{group,2})];
    end
    for animal = files
        activefilepath = ['C:\Users\ipzach\Documents\Converted' filesep SpkInfo{group,1} '_' num2str(animal) filesep 'concatenatedLFP.mat'];
        load(activefilepath);
        disp([SpkInfo{group,1} ' ' num2str(animal)])
        REMPath = ['C:\Users\ipzach\Documents\Converted' filesep SpkInfo{group,1} '_' num2str(animal) filesep 'cREM'];
        load(REMPath);
        
        if isempty(cREM.L.start) || isempty(cREM.L.end)
            disp('Missing REM Start or End Times for Left Side')
            continue
        end
        if isempty(cREM.R.start) || isempty(cREM.R.end)
            disp('Missing REM Start or End Times for Right Side')
            continue
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for layer = 1:4
            switch layer
                case 1
                    layertitle = 'Cortical';
                case 2
                    layertitle = 'SLM';
                case 3
                    layertitle = 'Pyramidal';
                case 4
                    layertitle = 'Oriens';
            end
            LFP_R = cLFP(:, SpkInfo{group,2}(animal).R_chn{layer}(1));
            LFP_L = cLFP(:, SpkInfo{group,2}(animal).L_chn{layer}(1));
            
            disp(layertitle)
            
            %% Normalizing
            if norm == true
                R_Mean = mean(LFP_R);
                L_Mean = mean(LFP_L);
                
                R_Std = std(LFP_R);
                L_Std = std(LFP_L);
                
                R = ((LFP_R - R_Mean)/R_Std);
                L = ((LFP_L - L_Mean)/L_Std);
            else
                R = LFP_R;
                L = LFP_L;
            end
            
            %% Band Filtering
            DeltaFilter_R = BPfilter(R, Fs, 0.1, 3);
            ThetaFilter_R = BPfilter(R, Fs, 4, 7);
            AlphaFilter_R = BPfilter(R, Fs, 7, 13);
            BetaFilter_R = BPfilter(R, Fs, 13, 30);
            GammaFilter_R = BPfilter(R, Fs, 30, 58);
            HGammaFilter_R = BPfilter(R, Fs, 62, 200);
            R_Filter = [DeltaFilter_R, ThetaFilter_R, AlphaFilter_R, BetaFilter_R, GammaFilter_R, HGammaFilter_R];
            
            DeltaFilter_L = BPfilter(L, Fs, 0.1, 3);
            ThetaFilter_L = BPfilter(L, Fs, 4, 7);
            AlphaFilter_L = BPfilter(L, Fs, 7, 13);
            BetaFilter_L = BPfilter(L, Fs, 13, 30);
            GammaFilter_L = BPfilter(L, Fs, 30, 58);
            HGammaFilter_L = BPfilter(L, Fs, 62, 200);
            L_Filter = [DeltaFilter_L, ThetaFilter_L, AlphaFilter_L, BetaFilter_L, GammaFilter_L, HGammaFilter_L];
            
            %% Smoothing the Envelope
            % define a smoothing kernel
            smoothing_width = 1; %300ms
            kernel = gaussian(smoothing_width*Fs, ceil(8*smoothing_width*Fs));
            for band = 1:6
                R_envelope = abs(hilbert(R_Filter(:,band)));
                R_Smoothed = smoothvect(R_envelope, kernel);
                
                L_envelope = abs(hilbert(L_Filter(:,band)));
                L_Smoothed = smoothvect(L_envelope, kernel);
                
                
                %% Calculate Power
                % Pull specific T-D frames if splitting
                if split == true
                    HighPower_R = [];
                    HighPower_L = [];
                    LowPower_R = [];
                    LowPower_L = [];
                    
                    for TD = 1:2
                        TDIdx = [];
                        switch TD
                            case 1
                                %Right
                                % Get indices of High Theta/Delta
                                for iRem = 1:length(cREM.R.start)
                                    TDIdx = [TDIdx (round(cREM.R.start(iRem)*Fs)):(round(cREM.R.end(iRem)*Fs))];
                                end
                                REMtitle = 'High T-D ';
                                RTDHigh = [];
                                Band_R = R_Smoothed;
                                RTDHigh(:,band) = Band_R(TDIdx);
                                HighPower_R = SignalPower(RTDHigh(:,band), Fs);
                                % Save Power calculation
                                if norm == 1
                                    NormPower{group,2}.R(animal,band,layer) = HighPower_R;
                                else
                                    RawPower{group,2}.R(animal,band,layer) = HighPower_R;
                                end
                                
                                %Left
                                %Get indices of High Theta/Delta
                                for iRem = 1:length(cREM.L.start)
                                    TDIdx = [TDIdx (round(cREM.L.start(iRem)*Fs)):(round(cREM.L.end(iRem)*Fs))];
                                end
                                LTDHigh = [];
                                Band_L = L_Smoothed;
                                LTDHigh(:,band) = Band_L(TDIdx);
                                HighPower_L = SignalPower(LTDHigh(:,band), Fs);
                                % Save Power calculation
                                if norm == 1
                                    NormPower{group,2}.L(animal,band,layer) = HighPower_L;
                                else
                                    RawPower{group,2}.L(animal,band,layer) = HighPower_L;
                                end
                                
                            case 2
                                %Right
                                % Get indices of Low Theta/Delta
                                LTDrightREMStartTimes = cREM.R.end(1:end-1);
                                LTDrightREMEndTimes = cREM.R.start(2:end);
                                for iRem = 1:length(LTDrightREMStartTimes)
                                    TDIdx = [TDIdx (round(LTDrightREMStartTimes(iRem)*Fs)+1):(round(LTDrightREMEndTimes(iRem)*Fs))+1];
                                end
                                REMtitle = 'Low T-D ';
                                Band_R = R_Smoothed;
                                RTDLow = [];
                                RTDLow(:,band) = Band_R(TDIdx);
                                LowPower_R = SignalPower(RTDLow(:,band), Fs);
                                % Save Power calculation
                                if norm == 1
                                    NormPower{group,3}.R(animal,band,layer) = LowPower_R;
                                else
                                    RawPower{group,3}.R(animal,band,layer) = LowPower_R;
                                end
                                %Left
                                % Get indices of Low Theta/Delta
                                LTDleftREMStartTimes = cREM.L.end(1:end-1);
                                LTDleftREMEndTimes = cREM.L.start(2:end);
                                for iRem = 1:length(LTDleftREMStartTimes)
                                    TDIdx = [TDIdx (round(LTDleftREMStartTimes(iRem)*Fs)+1):(round(LTDleftREMEndTimes(iRem)*Fs)+1)];
                                end
                                Band_L = L_Smoothed;
                                LTDLow = [];
                                LTDLow(:,band) = Band_L(TDIdx);
                                LowPower_L = SignalPower(LTDLow(:,band), Fs);
                                % Save Power calculation
                                if norm == 1
                                    NormPower{group,3}.L(animal,band,layer,TD) = LowPower_L;
                                else
                                    RawPower{group,3}.L(animal,band,layer,TD) = LowPower_L;
                                end
                        end
                        
                    end
                    
                    
                    
                    
                else
                    Power_R = [];
                    Power_L = [];
                    %Right
                    Band_R = R_Smoothed;
                    
                    Power_R = SignalPower(Band_R, Fs);
                    % Save Power calculation
                    if norm == true
                        NormalizedPower{group,2}.R(animal,band,layer) = Power_R;
                    else
                        RawPower{group,2}.R(animal,band,layer) = Power_R;
                    end
                    %Left
                    Band_L = L_Smoothed;
                    Power_L = SignalPower(Band_L, Fs);
                    % Save Power calculation
                    if norm == true
                        NormalizedPower{group,2}.L(animal,band,layer) = Power_L;
                    else
                        RawPower{group,2}.L(animal,band,layer) = Power_L;
                    end
                    
                end
            end
            % Each band Combo
        end
        % Layer combo
    end
    % Each animal
    
    toc
    clearvars 'R_Smoothed' 'L_Smoothed' % 'RTDHigh' 'RTDLow' 'LTDHigh' 'LTDLow'
end
if norm == true
    if split == true
        save('C:\Users\ipzach\Documents\MATLAB\Stats\Power\NormalizedSplitPower.mat', 'NormPower')
    else
        save('C:\Users\ipzach\Documents\MATLAB\Stats\Power\NormalizedPower.mat', 'NormalizedPower')
    end
else
    if split == true
        save('C:\Users\ipzach\Documents\MATLAB\Stats\Power\RawSplitPower.mat', 'RawPower')
    else
        save('C:\Users\ipzach\Documents\MATLAB\Stats\Power\RawPower.mat', 'RawPower')
    end
end

disp('done')