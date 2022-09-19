clear all
tic
disp('Initializing Files')
filepath = 'C:\Users\user\Documents\MATLAB';
cd(filepath)
load('SpkInfo.mat')
Fs = 1250; % Sampling Frequency; needed for filtering and plotting
% Theta/Delta state to analyze
TD = 2; %High 1, Low 2, Full 3
%%%%%%%%%%%%%%%%%%%%%%%%%
% Group, Band, LR, Animal, Layer/layer
Co = zeros(6,4,2,12,4,4);
%% Stroke group to analyze
% 1:4 6 ref Spk Info
for group = [1:4 6]
    %% 1.Load the right and left side signals
    %load H/L TD indexes
    count = 0;
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
        activefilepath = ['C:\Users\user\Documents\MATLAB\Data' filesep SpkInfo{group,1} '_' num2str(animal) filesep 'concatenatedLFP.mat'];
        load(activefilepath);
        disp(['Loaded ' SpkInfo{group,1} '_' num2str(animal)])
        % mkdir(['C:\Users\ipzach\Documents\MATLAB\Comodulograms' filesep SpkInfo{group,1} '_' num2str(animal)])
        % % % % % % % % % % % % %
        count = count +1;
        for layer = 1:6
            switch layer
                case 1
                    A = 1;
                    B = 2;
                    compare = 'Cortex-SLM';
                case 2
                    A = 1;
                    B = 3;
                    compare = 'Cortex-Pyr';
                case 3
                    A = 1;
                    B = 4;
                    compare = 'Cortex-Oriens';
                case 4
                    A = 2;
                    B = 3;
                    compare = 'SLM-Pyr';
                case 5
                    A = 2;
                    B = 4;
                    compare = 'SLM-Oriens';
                case 6
                    A = 3;
                    B = 4;
                    compare = 'Pyr-Oriens';
            end
            disp(compare)
            AL_LFP = cLFP(:, SpkInfo{group,2}(animal).L_chn{A}(1));
            AR_LFP = cLFP(:, SpkInfo{group,2}(animal).R_chn{A}(1));
            
            BL_LFP = cLFP(:, SpkInfo{group,2}(animal).L_chn{B}(1));
            BR_LFP = cLFP(:, SpkInfo{group,2}(animal).R_chn{B}(1));
            
            for iBand = 1:4
                switch iBand
                    case 1
                        range = [0.1 3];
                    case 2
                        range = [4 7];
                    case 3
                        range = [30 58];
                    case 4
                        range = [62 200];
                end
                AL_LFP = BPfilter(AL_LFP, Fs, range(1), range(2));
                AR_LFP = BPfilter(AR_LFP, Fs, range(1), range(2));
                BL_LFP = BPfilter(BL_LFP, Fs, range(1), range(2));
                BR_LFP = BPfilter(BR_LFP, Fs, range(1), range(2));
                
                % Loading Right Side LFPs
                TDIdx = []; % Array for relevant data points indices
                % disp('grabbing indices')
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
                        TDIdx = 1 : length(cLFP);
                        REMtitle = 'F';
                end
                
                ARH_LFP = AR_LFP(TDIdx);
                BRH_LFP = BR_LFP(TDIdx);
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
                
                ALH_LFP = AL_LFP(TDIdx);
                BLH_LFP = BL_LFP(TDIdx);
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                try
                    Co(group,iBand,1,count,A,B) = mean(mscohere(ALH_LFP,BLH_LFP));
                catch
                    disp(['Coherence for ' SpkInfo{group,1} num2str(animal) ' Left not calculated'])
                end
                try
                    Co(group,iBand,2,count,A,B) = mean(mscohere(ARH_LFP,BRH_LFP));
                catch
                    disp(['Coherence for ' SpkInfo{group,1} num2str(animal) ' Right not calculated'])
                    
                end
                
                
            end % band
            
        end % layer
        for iB = 1:4
            for iH = 1:2
                % Group, Band, LR, Animal, Layer/layer
                heatmap(squeeze(Co(group,iB,iH,animal,:,:)));
                pause(1)
            end
        end
    end % animal
    
end % group

switch TD
    case 1
        name = 'HTD';
    case 2
        name = 'LTD';
    case 3
        name = 'Full';
end
save(['C:\Users\user\Documents\MATLAB\Coherence Data\' name],'Co')