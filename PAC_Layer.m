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
filepath = 'C:\Users\ipzach\Documents\MATLAB';
cd(filepath)
load('SpkInfo.mat')
Fs = 1250; % Sampling Frequency; needed for filtering and plotting
% Theta/Delta state to analyze
TD = 2; %High 1, Low 2, Full 3
phase = 1; %0 Cortical layer is phase, 1 is hippocampal layer
%%%%%%%%%%%%%%%%%%%%%%%%%
switch phase
    case 0
        disp('Cortex is phase variable')
        
    case 1
        disp('Hippocampus is phase variable')
end
% Define the Amplitude- and Phase- Frequencies
% Lower this range to have faster computing
PhaseFreqVector = 0:0.5:12; 
AmpFreqVector = 0:2.5:160; 
PhaseFreq_BandWidth = 0.5;
AmpFreq_BandWidth = 2.5;
% For comodulation calculation (only has to be calculated once)
nbin = 0:17; % defines how many fractions to divide phase into
winsize = 2*pi/18;
position = nbin*winsize-pi;
%% Stroke group to analyze
% 1:4 6 ref Spk Info
for group = [2:4 6]
    %% 1.Load the right and left side signals
    %load H/L TD indexes
    for animal = 1 : length(SpkInfo{group,2})
        REM = ['C:\Users\ipzach\Documents\Converted' filesep SpkInfo{group,1} '_' num2str(animal) filesep 'cREM.mat'];
        if exist(REM) == 2 
            load(REM);
        else
            disp('Missing REM File')
            continue
        end
        activefilepath = ['C:\Users\ipzach\Documents\Converted' filesep SpkInfo{group,1} '_' num2str(animal) filesep 'concatenatedLFP.mat'];
        load(activefilepath);
        
        hippo.R = [];
        hippo.L = [];
        cort.R = [];
        cort.L = [];
        % Store the relevant LFP data for left and right side, cortical and hippocampal LFPs
        disp(activefilepath)
        % Skip files with missing LFP data
        if isempty(cREM.R.start) || isempty(cREM.R.end)
            disp('Missing REM Start or End Times for Right Side')
            continue
        end
        if isempty(cREM.L.start) || isempty(cREM.L.end)
            disp('Missing REM Start or End Times for Left Side')
            continue
        end
        if isempty(SpkInfo{group,2}(animal).L_chn{3}) || isempty(SpkInfo{group,2}(animal).R_chn{3})
            disp('Missing SpkInfo')
            continue
        end
        % mkdir(['C:\Users\ipzach\Documents\MATLAB\Comodulograms' filesep SpkInfo{group,1} '_' num2str(animal)])
        % % % % % % % % % % % % %
        for layer = 1:4
            switch layer
                case 1
                    layertitle = 'C'; % Cortex
                case 2
                    layertitle = 'S'; %stratum lacunosum - molecuare
                case 3
                    layertitle = 'P'; % Pyramidal -  Old Molecular
                case 4
                    layertitle = 'O'; %Oriens -  Old Pyramidal
            end
            % Loading Right Side LFPs
            TDIdx = []; % Array for relevant data points indices
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
            
            % First get the hippocampal LFP
            H = cLFP(:, SpkInfo{group,2}(animal).R_chn{layer}(1));
            hippo.R = H(TDIdx);
            
            % Now get the cortical LFP
            C = cLFP(:, SpkInfo{group,2}(animal).R_chn{1}(1));
            cort.R = C(TDIdx);
            
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
            H = cLFP(:, SpkInfo{group,2}(animal).L_chn{layer}(1));
            hippo.L = H(TDIdx);
            
            C = cLFP(:, SpkInfo{group,2}(animal).L_chn{1}(1));
            cort.L = C(TDIdx);
            %% Do filtering and Hilbert transform on CPU
            Comodulogram.R = single(zeros(length(PhaseFreqVector),length(AmpFreqVector)));
            Comodulogram.L = single(zeros(length(PhaseFreqVector),length(AmpFreqVector)));
            switch phase
                case 0
                    AmpFreqTransformed.R = zeros(length(AmpFreqVector), length(hippo.R));
                    AmpFreqTransformed.L = zeros(length(AmpFreqVector), length(hippo.L));
                    PhaseFreqTransformed.R = zeros(length(PhaseFreqVector), length(cort.R));
                    PhaseFreqTransformed.L = zeros(length(PhaseFreqVector), length(cort.L));
                    
                    % Right side
                    %'Filtering right side LFP '
                    
                    for ii = 1:length(AmpFreqVector)
                        Af1 = AmpFreqVector(ii); % Amplitude frequency start
                        Af2 = Af1 + AmpFreq_BandWidth; % amplitude frequency end
                        AmpFreq = eegfilt(hippo.R', Fs, Af1, Af2); % just filtering
                        AmpFreqTransformed.R(ii, :) = abs(hilbert(AmpFreq)); % getting the amplitude envelope
                    end
                    for jj = 1:length(PhaseFreqVector)
                        Pf1 = PhaseFreqVector(jj);
                        Pf2 = Pf1 + PhaseFreq_BandWidth;
                        PhaseFreq = eegfilt(cort.R', Fs, Pf1, Pf2); % this is just filtering
                        PhaseFreqTransformed.R(jj, :) = angle(hilbert(PhaseFreq)); % this is getting the phase time series
                    end
                    
                    %        'Filtering left side LFP '
                    
                    for ii = 1:length(AmpFreqVector)
                        Af1 = AmpFreqVector(ii);
                        Af2 = Af1 + AmpFreq_BandWidth;
                        AmpFreq = eegfilt(hippo.L', Fs, Af1, Af2);
                        AmpFreqTransformed.L(ii, :) = abs(hilbert(AmpFreq)); % getting the amplitude envelope
                    end
                    for jj = 1:length(PhaseFreqVector)
                        Pf1 = PhaseFreqVector(jj);
                        Pf2 = Pf1 + PhaseFreq_BandWidth;
                        PhaseFreq = eegfilt(cort.L', Fs, Pf1, Pf2); % this is just filtering
                        PhaseFreqTransformed.L(jj, :) = angle(hilbert(PhaseFreq)); % this is getting the phase time series
                    end
                case 1 %switches Amp and Phase to change which LFP is considered phase
                    AmpFreqTransformed.R = zeros(length(AmpFreqVector), length(cort.R));
                    AmpFreqTransformed.L = zeros(length(AmpFreqVector), length(cort.L));
                    PhaseFreqTransformed.R = zeros(length(PhaseFreqVector), length(hippo.R));
                    PhaseFreqTransformed.L = zeros(length(PhaseFreqVector), length(hippo.L));
                    
                    % Right side
                    
                    for ii = 1:length(AmpFreqVector)
                        Af1 = AmpFreqVector(ii);
                        Af2 = Af1 + AmpFreq_BandWidth;
                        AmpFreq = eegfilt(cort.R', Fs, Af1, Af2); % just filtering
                        AmpFreqTransformed.R(ii, :) = abs(hilbert(AmpFreq)); % getting the amplitude envelope
                    end
                    for jj = 1:length(PhaseFreqVector)
                        Pf1 = PhaseFreqVector(jj);
                        Pf2 = Pf1 + PhaseFreq_BandWidth;
                        PhaseFreq = eegfilt(hippo.R', Fs, Pf1, Pf2); % this is just filtering
                        PhaseFreqTransformed.R(jj, :) = angle(hilbert(PhaseFreq)); % this is getting the phase time series
                    end
                    
                    % left side
                    
                    for ii = 1:length(AmpFreqVector)
                        Af1 = AmpFreqVector(ii);
                        Af2 = Af1 + AmpFreq_BandWidth;
                        AmpFreq = eegfilt(cort.L', Fs, Af1, Af2); % just filtering
                        AmpFreqTransformed.L(ii, :) = abs(hilbert(AmpFreq)); % getting the amplitude envelope
                    end
                    for jj = 1:length(PhaseFreqVector)
                        Pf1 = PhaseFreqVector(jj);
                        Pf2 = Pf1 + PhaseFreq_BandWidth;
                        PhaseFreq = eegfilt(hippo.L' , Fs, Pf1, Pf2); % this is just filtering
                        PhaseFreqTransformed.L(jj, :) = angle(hilbert(PhaseFreq)); % this is getting the phase time series
                    end
            end
            %% 7.Do comodulation calculation %: Right Side'
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
            switch phase
                case 0
                    save(['C:\Users\ipzach\Documents\MATLAB\Comodulograms' filesep SpkInfo{group,1} '_' num2str(animal) filesep REMtitle '_PC_A' layertitle '_HD'], 'Comodulogram','hippo','cort');
                case 1
                    save(['C:\Users\ipzach\Documents\MATLAB\Comodulograms' filesep SpkInfo{group,1} '_' num2str(animal) filesep REMtitle '_P' layertitle '_AC_HD'], 'Comodulogram','hippo','cort');
            end
            
            disp('Comodulogram saved.')
            toc
            
            %% 8.Graph comodulograms
            figure
            contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,Comodulogram.R',30,'lines','none')
            title([SpkInfo{group,1} ' ' num2str(animal) ' Right']), colormap('jet')
            colorbar
            figure
            contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,Comodulogram.L',30,'lines','none')
            title([SpkInfo{group,1} ' ' num2str(animal) 'Left']), colormap('jet')
            colorbar
            drawnow
            disp([layertitle ' Layer Completed'])
        end
    end
end
toc
beep
disp('Complete')
