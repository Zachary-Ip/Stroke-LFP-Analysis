% This file detects ripples in LFP files from the pyramidal layer, and
% sharp waves in radiatum and only logs simultaneous events.
% Azadeh Yazdan 06/17/16
% Zach Ip 9/18/19
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all

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
spwr = cell(10,12);
for group = [3,6,7,8,10]
    disp(SpkInfo{group,1})
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
        % Check bad electrodes
        missingInfo = isempty(SpkInfo{group,2}(animal).L_chn{3}) || ...
            isempty(SpkInfo{group,2}(animal).R_chn{3}) ||...
            SpkInfo{group,2}(animal).L_chn{3}(1) >16;
        if missingInfo
            disp('Missing SpkInfo')
            cd ..
            continue
        end
        
        % Scale LFP
        cLFP = cLFP .* voltScaler;
        
        % Right side
        spwr{group,animal}.L = DetectEvents(cLFP,cREM,group,animal,'R');
        % Left side
        spwr{group,animal}.R = DetectEvents(cLFP,cREM,group,animal,'L');
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

%%

function SPWRevents = DetectEvents(LFP,REM,g,a,side)
load('SpkInfo.mat')
Fs = 1250;
smoothing_width = 0.01; % 300 ms
kernel = gaussian(smoothing_width*Fs, ceil(8*smoothing_width*Fs));
% disp([SpkInfo{g,1} '_' num2str(a) ' ' side])
switch side
    case 'R'
        Pyramidal_Layer = LFP(:,SpkInfo{g,2}(a).R_chn{3}(1));
        Radiatum = LFP(:,SpkInfo{g,2}(a).R_chn{3}(1) +1);
    case 'L'
        Pyramidal_Layer = LFP(:,SpkInfo{g,2}(a).L_chn{3}(1));
        Radiatum = LFP(:,SpkInfo{g,2}(a).L_chn{3}(1) +1);
end % switch
HP_Pyramidal_Layer = HPFilter(Pyramidal_Layer, Fs, 7,4);
SWR_PL = BPfilter( Pyramidal_Layer,Fs,150,250).^2; % filter for SWR (150-250 Hz) and square
S_SWR_PL = smoothvect(SWR_PL, kernel);

SPW = BPfilter(Radiatum,1250,8,40);
PositiveSPW = SPW.^2;
S_PositiveSPW = smoothvect(PositiveSPW, kernel);

%           extract ripples
rippleFactor = 6;
rippleBaseline = mean(S_SWR_PL);
rippleThresh = mean(S_SWR_PL) + (std(S_SWR_PL)*rippleFactor);

waveFactor = 3;
waveBaseline = mean(S_PositiveSPW);
waveThresh = mean(S_PositiveSPW) + (std(S_PositiveSPW) * waveFactor);

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
SpwEvents = extractevents([S_PositiveSPW'], waveThresh, waveBaseline, 0, 0.015, 0)';
numSwr = length(SwrEvents);
numSpw = length(SpwEvents);
figure
for aa = 1:length(SwrEvents)
   plot(HP_Pyramidal_Layer(SwrEvents(aa,1)-100:SwrEvents(aa,1)+1000)), pause(1)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find SPW-Rs
counter = 0;
spw_idx = [];
for i = 1:length(SpwEvents)
    spw_idx = [spw_idx SpwEvents(i,1):SpwEvents(i,2)];
end

for j = 1: length(SwrEvents)
    num_shared = sum(ismember(SwrEvents(j,1):SwrEvents(j,2),spw_idx));
    if num_shared ~= 0
        counter = counter +1;
        SPWRevents(counter,:) = SwrEvents(j,:);
    end
end
overlap = length(SPWRevents)/numSwr;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check which events are in LTD
ThetaDeltaIdx = [];
switch side
    case 'R'
        start = REM.R.end(1:end-1);
        stop = REM.R.start(2:end);
    case 'L'
        start = REM.L.end(1:end-1);
        stop = REM.L.start(2:end);
end
for iiRem = 1:length(start)
    ThetaDeltaIdx = [ThetaDeltaIdx (round(start(iiRem)*Fs)):(round(stop(iiRem)*Fs))];
end

for i = 1: length(SwrEvents)
    if ismember(SwrEvents(i,1),ThetaDeltaIdx)
        LTDevents = LTDevents +1;
        SwrLtdEvents(LTDevents,:) = SwrEvents(i,:);
    end
end
SpwrLTDRatio = LTDevents/length(SPWRevents);
try
    save(['C:\Users\user\Documents\MATLAB\SPWR\Rip' num2str(rippleFactor) 'SD\' SpkInfo{g,1} '_' side num2str(a) ],'SwrLtdEvents');
    disp('Saved succesfully')
catch
    disp(['Could not save ' SpkInfo{g,1} '_' side num2str(a)])
end
end % if Rchn is empty