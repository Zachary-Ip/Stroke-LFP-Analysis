%% This file calculates the power of each animal
% Checked by Zach on 12.2019
clear all;
tic
disp('Initializing Files')
filepath = 'C:\Users\user\Documents\MATLAB';
cd(filepath)
load('SpkInfo.mat')
Fs = 1250;
voltConvert = 0.000000015624999960550667;
%% Load right and left side signals
for group = [1:4 6]
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
        activefilepath = ['C:\Users\user\Documents\MATLAB\Data' filesep SpkInfo{group,1} '_' num2str(animal) filesep 'concatenatedLFP.mat'];
        load(activefilepath);
        cLFP = cLFP .* voltConvert;
        disp([SpkInfo{group,1} ' ' num2str(animal)])
        REMPath = ['C:\Users\user\Documents\MATLAB\Data' filesep SpkInfo{group,1} '_' num2str(animal) filesep 'cREM'];
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
                    layertitle = 'Pyramidal';
                case 3
                    layertitle = 'SLM';
                case 4
                    layertitle = 'Oriens';
            end
            LFP_R = cLFP(:, SpkInfo{group,2}(animal).R_chn{layer}(1));
            LFP_L = cLFP(:, SpkInfo{group,2}(animal).L_chn{layer}(1));
            
            disp(layertitle)
            
            %% Normalizing
            R_Mean = mean(LFP_R);
            L_Mean = mean(LFP_L);
            
            R_Std = std(LFP_R);
            L_Std = std(LFP_L);
            
            R = ((LFP_R - R_Mean)/R_Std);
            L = ((LFP_L - L_Mean)/L_Std);
            
            
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
                
                Power_R = [];
                Power_L = [];
                %Right
                Band_R = R_Smoothed;
                
                Power_R = SignalPower(Band_R, Fs);
                % Save Power calculation
                
                NormalizedPower{group,2}.R(animal,band,layer) = Power_R;
                
                %Left
                Band_L = L_Smoothed;
                Power_L = SignalPower(Band_L, Fs);
                % Save Power calculation
                NormalizedPower{group,2}.L(animal,band,layer) = Power_L;
                
            end % Each band Combo
        end% Layer combo
    end% Each animal
    toc
    clearvars 'R_Smoothed' 'L_Smoothed' % 'RTDHigh' 'RTDLow' 'LTDHigh' 'LTDLow'
end

save('C:\Users\user\Documents\MATLAB\Stats\Power\NormalizedPower.mat', 'NormalizedPower')


disp('done')