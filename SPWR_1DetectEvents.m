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
SpwrStats.L = [];
SpwrStats.R = [];
for group = [1:4 6]
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
        DetectEvents(cLFP,cREM,group,animal,'R');
%         SpwrStats.R(group,animal,1) = a;
%         SpwrStats.R(group,animal,2) =  b;
%         SpwrStats.R(group,animal,3) = c;
%         SpwrStats.R(group,animal,4) = d;
%         SpwrStats.R(group,animal,5) = e;
%         SpwrStats.R(group,animal,6) = f;
        % Left side
        DetectEvents(cLFP,cREM,group,animal,'L');
%         SpwrStats.L(group,animal,1) = a;
%         SpwrStats.L(group,animal,2) =  b;
%         SpwrStats.L(group,animal,3) = c;
%         SpwrStats.L(group,animal,4) = d;
%         SpwrStats.L(group,animal,5) = e;
%         SpwrStats.L(group,animal,6) = f;
    end % animal
end % group
% [SwrLS SwrRS SwrLC SwrRC] = BundleResults(SpwrStats,1);
% [SpwLS SpwRS SpwLC SpwRC] = BundleResults(SpwrStats,2);
% [OvLS OvRS OvLC OvRC] = BundleResults(SpwrStats,3);
% [SwrLLS SwrLRS SwrLLC SwrLRC] = BundleResults(SpwrStats,4);
% [SpwLLS SpwLRS SpwLLC SpwLRC] = BundleResults(SpwrStats,5);
% [OvLLS OvLRS OvLLC OvLRC] = BundleResults(SpwrStats,6);
% SpwrStats
% SWR Occurance
% SPW Occurance
% Overlap Pct
% SWR During LTD
% SPW During LTD
% Overlap during LTD
% disp(['SW Count ' num2str([SwrLS SwrRS SwrLC SwrRC])])
% disp(['PR Count ' num2str([SpwLS SpwRS SpwLC SpwRC])])
% disp(['Overlap Perc ' num2str([OvLS OvRS OvLC OvRC])])
% disp(['SW LTDR ' num2str([SwrLLS SwrLRS SwrLLC SwrLRC])])
% disp(['PR LTDR ' num2str([SpwLLS SpwLRS SpwLLC SpwLRC])])
% disp(['Overlap LTDR ' num2str([OvLLS OvLRS OvLLC OvLRC])])
% 
% 
% 
% function [lStroke, rStroke, lControl, rControl] = BundleResults(stats,result)
% lControl = mean([mean(nonzeros(stats.L(1,:,result))) mean(nonzeros(stats.L(2,:,result)))]);
% lStroke = mean([mean(nonzeros(stats.L(3,:,result))) nonzeros(mean(stats.L(4,:,result))) mean(nonzeros(stats.L(6,:,result)))]);
% rControl = mean([mean(nonzeros(stats.R(1,:,result))) mean(nonzeros(stats.R(2,:,result)))]);
% rStroke = mean([mean(nonzeros(stats.R(3,:,result))) mean(nonzeros(stats.R(4,:,result))) mean(nonzeros(stats.L(6,:,result)))]);
% end



function DetectEvents(LFP,REM,g,a,side)
load('SpkInfo.mat')
Fs = 1250;
smoothing_width = 0.01; % 300 ms
kernel = gaussian(smoothing_width*Fs, ceil(8*smoothing_width*Fs));
% disp([SpkInfo{g,1} '_' num2str(a) ' ' side])
switch side
    case 'R'
        Pyramidal_Layer = LFP(:,SpkInfo{g,2}(a).R_chn{3}(1));
        Radiatum = LFP(:,SpkInfo{g,2}(a).R_chn{3}(1) -3);
    case 'L'
        Pyramidal_Layer = LFP(:,SpkInfo{g,2}(a).L_chn{3}(1));
        Radiatum = LFP(:,SpkInfo{g,2}(a).L_chn{3}(1) -3);
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

LTDevents = 0;
for i = 1: length(SpwEvents)
    if ismember(SpwEvents(i,1),ThetaDeltaIdx)
        LTDevents = LTDevents +1;
    end
end
SpwLTDRatio = LTDevents/length(SpwEvents);

LTDevents = 0;
for i = 1: length(SwrEvents)
    if ismember(SwrEvents(i,1),ThetaDeltaIdx)
        LTDevents = LTDevents +1;
    end
end
SwrLTDRatio = LTDevents/length(SwrEvents);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find SPW-Rs
counter = 0;
for i = 1: length(SpwEvents)
    association = ismember(SwrEvents(:,1), SpwEvents(i,1):SpwEvents(i,2));
    for j = 1:length(association)
        if association(j)
            counter = counter +1;
            SPWRevents(counter,:) = SwrEvents(j,:);
        end
    end
end
overlap = length(SPWRevents)/numSwr;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find SPW-Rs in LTD
LTDevents = 0;
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