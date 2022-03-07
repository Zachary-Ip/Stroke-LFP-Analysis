%% Based on PhaseAmp Couple1.5, this code creates a comodulogram from LFP data
% Update  to save to HD, ad increased resolution accordingly
%most recently edited by Zachary Ip 3/26/2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% READ ME %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Commodulograms will save into
% C:\Users\ipzach\Documents\MATLAB\Comodulograms
% under the appropriate animal file. Each Theta/Delta state, and phase and
% amplitude layer will all save into the same folder. The format for
% reading the save file will be T/D_Phase layer_Amplitude layer. For
% example, Comodulograms\EE Strk_1\H_PC_AS.mat would be the comodulogram
% for EE Strk 1, High T/D, Cortex as phase, SLM as amplitude.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
tic
disp('Initializing Files')
filepath = 'C:\Users\user\Documents\MATLAB';
cd(filepath)
load('SpkInfo.mat')
Fs = 1250; % Sampling Frequency; needed for filtering and plotting
% Theta/Delta state to analyze
TD = 1; %High 1, Low 2, Full 3

% Define the Amplitude- and Phase- Frequencies
% Lower this range to have faster computing
PhaseFreqVector = 0:0.5:12 ;
AmpFreqVector = 0:2.5:160;
PhaseFreq_BandWidth = 0.5;
AmpFreq_BandWidth = 2.5;
% For comodulation calculation (only has to be calculated once)
nbin = 0:17; % defines how many fractions to divide phase into
winsize = 2*pi/18;
position = nbin*winsize-pi;
%% Stroke group to analyze
% 1:4 6 ref Spk Info
for group = [1:4 6]
    %% 1.Load the right and left side signals
    %load H/L TD indexes
    for animal = 1: length(SpkInfo{group,2})
        REM = ['C:\Users\user\Documents\MATLAB\Data' filesep SpkInfo{group,1} '_' num2str(animal) filesep 'cREM.mat'];
        try
            load(REM);
        catch
            disp('Missing REM File')
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
        if isempty(SpkInfo{group,2}(animal).L_chn{3}) || isempty(SpkInfo{group,2}(animal).R_chn{3})
            disp('Missing SpkInfo')
            continue
        end
        disp('loading data')
        activefilepath = ['C:\Users\user\Documents\MATLAB\Data' filesep SpkInfo{group,1} '_' num2str(animal) filesep 'concatenatedLFP.mat'];
        load(activefilepath);
        disp('loaded')
        amp.R = [];
        amp.L = [];
        phase.R = [];
        phase.L = [];
        % Store the relevant LFP data for left and right side, cortical and hippocampal LFPs
        disp(activefilepath)
        % Skip files with missing LFP data
        
        
        % mkdir(['C:\Users\ipzach\Documents\MATLAB\Comodulograms' filesep SpkInfo{group,1} '_' num2str(animal)])
        % % % % % % % % % % % % %
        for layer = 2:4
            switch layer
                case 2
                    layertitle = 'P'; %Pyramidal
                case 3
                    layertitle = 'S'; % SLM
                case 4
                    layertitle = 'O'; %Oriens
            end
            % Loading Right Side LFPs
            TDIdx = []; % Array for relevant data points indices
            disp('grabbing indices')
            switch TD
                case 1
                    % Get indices of High Theta/Delta
                    for iRem = 1:length(cREM.R.start)
                        TDIdx = [TDIdx (round(cREM.R.start(iRem)*Fs)):(round(cREM.R.end(iRem)*Fs))];
                    end
                    REMtitle = 'H';
                    
                    % Get indices of Low Theta/Delta
                case 2
                    LowRightStart = cREM.R.end(1:end-1);
                    LowRightEnd = cREM.R.start(2:end);
                    for iRem = 1:length(LowRightStart)
                        TDIdx = [TDIdx (round(LowRightStart(iRem)*Fs)):(round(LowRightEnd(iRem)*Fs))];
                    end
                    REMtitle = 'L';
                    
                    % For entire reading
                case 3
                    TDIdx = 1 : length(LFP);
                    REMtitle = 'F';
            end
            disp('separating data')
            % First get the pyramidal LFP
            P = cLFP(:, SpkInfo{group,2}(animal).R_chn{2}(1));
            phase.R = P(TDIdx);
            
            % Now get the Hippocampal LFP
            H = cLFP(:, SpkInfo{group,2}(animal).R_chn{layer}(1));
            amp.R = H(TDIdx);
            
            % 'Loading left side LFPs'
            TDIdx = []; % Array for relevant data points indices
            switch TD
                case 1
                    %Get indices of High Theta/Delta
                    for iRem = 1:length(cREM.L.start)
                        TDIdx = [TDIdx (round(cREM.L.start(iRem)*Fs)):(round(cREM.L.end(iRem)*Fs))];
                    end
                case 2
                    % Get indices of Low Theta/Delta
                    LowLeftStart = cREM.L.end(1:end-1);
                    LowLeftEnd = cREM.L.start(2:end);
                    for iRem = 1:length(LowLeftStart)
                        TDIdx = [TDIdx (round(LowLeftStart(iRem)*Fs)+1):(round(LowLeftEnd(iRem)*Fs))];
                    end
                case 3
                    %For entire reading
                    TDIdx = 1 : length(cLFP);
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Creat an array of the relevant data points
            P = cLFP(:, SpkInfo{group,2}(animal).L_chn{2}(1));
            phase.L = P(TDIdx);
            
            H = cLFP(:, SpkInfo{group,2}(animal).L_chn{layer}(1));
            amp.L = H(TDIdx);
            %% Do filtering and Hilbert transform on CPU
            try
                disp('Filtering')
                Comodulogram.R = single(zeros(length(PhaseFreqVector),length(AmpFreqVector)));
                Comodulogram.L = single(zeros(length(PhaseFreqVector),length(AmpFreqVector)));
                
                AmpFreqTransformed.R = zeros(length(AmpFreqVector), length(amp.R));
                AmpFreqTransformed.L = zeros(length(AmpFreqVector), length(amp.L));
                PhaseFreqTransformed.R = zeros(length(PhaseFreqVector), length(phase.R));
                PhaseFreqTransformed.L = zeros(length(PhaseFreqVector), length(phase.L));
                
                % Right side
                %'Filtering right side LFP '
                
                for ii = 1:length(AmpFreqVector)
                    Af1 = AmpFreqVector(ii); % Amplitude frequency start
                    Af2 = Af1 + AmpFreq_BandWidth; % amplitude frequency end
                    AmpFreq = eegfilt(amp.R', Fs, Af1, Af2); % just filtering
                    AmpFreqTransformed.R(ii, :) = abs(hilbert(AmpFreq)); % getting the amplitude envelope
                end
                for jj = 1:length(PhaseFreqVector)
                    Pf1 = PhaseFreqVector(jj);
                    Pf2 = Pf1 + PhaseFreq_BandWidth;
                    PhaseFreq = eegfilt(phase.R', Fs, Pf1, Pf2); % this is just filtering
                    PhaseFreqTransformed.R(jj, :) = angle(hilbert(PhaseFreq)); % this is getting the phase time series
                end
                
                %        'Filtering left side LFP '
                
                for ii = 1:length(AmpFreqVector)
                    Af1 = AmpFreqVector(ii);
                    Af2 = Af1 + AmpFreq_BandWidth;
                    AmpFreq = eegfilt(amp.L', Fs, Af1, Af2);
                    AmpFreqTransformed.L(ii, :) = abs(hilbert(AmpFreq)); % getting the amplitude envelope
                end
                for jj = 1:length(PhaseFreqVector)
                    Pf1 = PhaseFreqVector(jj);
                    Pf2 = Pf1 + PhaseFreq_BandWidth;
                    PhaseFreq = eegfilt(phase.L', Fs, Pf1, Pf2); % this is just filtering
                    PhaseFreqTransformed.L(jj, :) = angle(hilbert(PhaseFreq)); % this is getting the phase time series
                end
            catch
                disp('Something broke filtering')
            end
            
            %% 7.Do comodulation calculation %: Right Side'
            counter1 = 0;
            disp('comodulating')
            for ii = 1:length(PhaseFreqVector)
                counter1 = counter1+1;
                Pf1 = PhaseFreqVector(ii);
                Pf2 = Pf1+PhaseFreq_BandWidth;
                counter2=0;
                for jj = 1:length(AmpFreqVector)
                    counter2 = counter2+1;
                    Af1 = AmpFreqVector(jj);
                    Af2 = Af1+AmpFreq_BandWidth;
                    [MI,MeanAmp] = ModIndex_v2(PhaseFreqTransformed.R(ii, :), AmpFreqTransformed.R(jj, :), position);
                    Comodulogram.R(counter1,counter2) = MI;
                end
            end
            % 'Comodulation loop: Left Side'
            
            counter1 = 0;
            for ii = 1:length(PhaseFreqVector)
                counter1 = counter1+1;
                Pf1 = PhaseFreqVector(ii);
                Pf2 = Pf1+PhaseFreq_BandWidth;
                
                counter2=0;
                for jj = 1:length(AmpFreqVector)
                    counter2 = counter2+1;
                    Af1 = AmpFreqVector(jj);
                    Af2 = Af1+AmpFreq_BandWidth;
                    [MI,MeanAmp] = ModIndex_v2(PhaseFreqTransformed.L(ii, :), AmpFreqTransformed.L(jj, :), position);
                    Comodulogram.L(counter1,counter2) = MI;
                end
            end
            disp('saving')
            save(['C:\Users\user\Documents\MATLAB\Comodulograms' filesep SpkInfo{group,1} '_' num2str(animal) filesep REMtitle '_PP_A' layertitle '_HD'], 'Comodulogram','amp','phase');
            
            toc
            disp('Comodulogram saved.')
            
%             disp('graphing')
%             %% 8.Graph comodulograms
%             figure
%             contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,Comodulogram.R',30,'lines','none')
%             title([SpkInfo{group,1} ' ' num2str(animal) ' Right']), colormap('jet')
%             colorbar
%             figure
%             contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,Comodulogram.L',30,'lines','none')
%             title([SpkInfo{group,1} ' ' num2str(animal) 'Left']), colormap('jet')
%             colorbar
%             drawnow
            disp([layertitle ' Layer Completed'])
        end
    end
end
toc
beep
disp('Complete')
