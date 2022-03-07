% This file detects ripples in LFP files from the pyramidal layer, and
% sharp waves in radiatum and only logs simultaneous events.
% Azadeh Yazdan 06/17/16
% Zach Ip 9/18/19
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('SpkInfo.mat')
Fs = 1250;
filepath = 'C:\Users\user\Documents\MATLAB\Data';
voltScaler  = 0.000000015624999960550667;
% define a smoothing kernel
smoothing_width = 0.01; % 300 ms
kernel = gaussian(smoothing_width*Fs, ceil(8*smoothing_width*Fs));

% SpwrStats
% SWR Occurance
% SPW Occurance
% Overlap Pct
% SWR During LTD
% SPW During LTD
% Overlap during LTD
swr = cell(10,12);
for group = [3, 6, 7, 8, 10]
    disp(SpkInfo{group,1})
    Swr{group} = [];
    for animal = 1:size(SpkInfo{group,2},2)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Make sure all proper files are here
        % Load LFP
        load([filepath '\' SpkInfo{group,1} '_' num2str(animal) '\concatenatedLFP' ]);
        % Load cREM States
        try
            load([filepath '\' SpkInfo{group,1} '_' num2str(animal) '\cREM.mat'])
        catch
            disp('Missing cREM.mat')
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
        
        % Scale LFP
        cLFP = cLFP .* voltScaler;
        
        % Right side
        swr{group,animal}.L = DetectEvents(cLFP(:,1:16),cREM.L,group,animal); % Left hemisphere
        % Left side
        swr{group,animal}.R = DetectEvents(cLFP(:,17:32),cREM.R,group,animal); % Right hemisphere
    end % animal
end % group

%% Run stats
for group = [8,10] %[3, 6, 7, 8, 10]
    switch group
        case 3
            animal_idx = 4:12;
        case 6
            animal_idx = 1:10;
        case 7
            animal_idx = 1:11;
        case 8
            animal_idx = 1:9;
        case 10
            animal_idx = 1:10;
    end % end switch
    for hemisphere = 1:2
        counter = 0;
        length_storage = NaN(length(animal_idx),16);
            power_storage = NaN(length(animal_idx),16);
        for animal = animal_idx
            
            counter = counter + 1;
            switch hemisphere
                case 1
                    file = swr{group,animal}.L;
                case 2
                    file = swr{group,animal}.R;
            end %switch hemisphere
            for electrode = 1:16
                if ~isempty(file{1,electrode})
                    length_storage(counter, electrode) = size(file{electrode},1);
                    power_storage(counter, electrode) = mean(file{electrode}(:,7));
                end % if empty
            end % for electrode
            
        end % for animal
    end % for hemisphere
    
end % for group

%% start functions
function electrodes = DetectEvents(LFP,REM,g,a,side)
load('SpkInfo.mat')
Fs = 1250;
smoothing_width = 0.01; % 300 ms
kernel = gaussian(smoothing_width*Fs, ceil(8*smoothing_width*Fs));
electrodes = struct([]);
% disp([SpkInfo{g,1} '_' num2str(a) ' ' side])
for i = 1:16
    SWR_PL = BPfilter(LFP(:,i),Fs,150,250).^2; % filter for SWR (150-250 Hz) and square
    S_SWR_PL = smoothvect(SWR_PL, kernel);
    
    %extract ripples
    rippleFactor = 6;
    rippleBaseline = mean(S_SWR_PL);
    rippleThresh = mean(S_SWR_PL) + (std(S_SWR_PL)*rippleFactor);
    
    % Frank Lab code,
    % output
    % 1: start index
    % 2: end index
    % 3: peak_value
    % 4: peak index
    % 5: total area
    % 6: mid area
    % 7: total energy
    % 8: mid energy
    % 9: max threshold
    SwrEvents = extractevents([S_SWR_PL'], rippleThresh, rippleBaseline, 0, 0.015, 0)';
    numSwr = length(SwrEvents);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Check which events are in LTD
    ThetaDeltaIdx = [];
    start = REM.end(1:end-1);
    stop = REM.start(2:end);
    
    for iiRem = 1:length(start)
        ThetaDeltaIdx = [ThetaDeltaIdx (round(start(iiRem)*Fs)):(round(stop(iiRem)*Fs))];
    end
    
    LTDevents = [];
    for j = 1: size(SwrEvents,1)
        if ismember(SwrEvents(j,1),ThetaDeltaIdx)
            LTDevents = [LTDevents; SwrEvents(j,:)];
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    electrodes{i} = LTDevents;
end % for i

end % if Rchn is empty