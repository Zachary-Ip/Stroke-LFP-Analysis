% This code will make comodulogram movie for an entire animals recording.
% Things needed: Specify layer/pair combination.
% cut recording into 30s windows.
% Display Whether state is in high or low T/D
% Make it parfor compatible
% Zachary Ip 10.28.2019
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
tic
disp('Setting up')
load('SpkInfo.mat')
% [Cortex][Pyramidal][SLM][Oriens]
dataPath = 'C:\Users\user\Documents\MATLAB\Data';
cd(dataPath)
Fs = 1250;

PhaseFreqVector = 0:0.5:12;
AmpFreqVector = 0:2.5:160;
PhaseFreq_BandWidth = 0.5;
AmpFreq_BandWidth = 2.5;
% For comodulation calculation (only has to be calculated once)
nbin = 0:17; % defines how many fractions to divide phase into
winsize = 2*pi/18;
position = nbin*winsize-pi;

voltConvert = 0.000000015624999960550667;
%%%%
group = 3;
animal = 9;
name = '1M Strk_9';
phase = 'cortex '; % 'cortex' or 'hippocampus'
cd(name)
load('cREM.mat') % values are in seconds
load('concatenatedLFP.mat')
%%
LFP = cLFP .* voltConvert;
lCortex = LFP(:,SpkInfo{group,2}(animal).L_chn{1,1}(1));
rCortex = LFP(:,SpkInfo{group,2}(animal).R_chn{1,1}(1));
lPyramidal = LFP(:,SpkInfo{group,2}(animal).L_chn{1,2}(1));
rPyramidal = LFP(:,SpkInfo{group,2}(animal).R_chn{1,2}(1));
lSlm = LFP(:,SpkInfo{group,2}(animal).L_chn{1,3}(1));
rSlm = LFP(:,SpkInfo{group,2}(animal).R_chn{1,3}(1));
lOriens = LFP(:,SpkInfo{group,2}(animal).L_chn{1,4}(1));
rOriens = LFP(:,SpkInfo{group,2}(animal).R_chn{1,4}(1));
rTdIdx = [];
lTdIdx = [];
for iRem = 1:length(cREM.R.start)
    rTdIdx = [rTdIdx (round(cREM.R.start(iRem)*Fs)):(round(cREM.R.end(iRem)*Fs))];
end
for iRem = 1:length(cREM.L.start)
    lTdIdx = [lTdIdx (round(cREM.L.start(iRem)*Fs)):(round(cREM.L.end(iRem)*Fs))];
end
%%
winLength = Fs*30;
windows = floor(length(LFP)/winLength);
rState = {};
lState = {};
lpMovie = single(zeros(length(PhaseFreqVector),length(AmpFreqVector),windows));
rpMovie = single(zeros(length(PhaseFreqVector),length(AmpFreqVector),windows));
lsMovie = single(zeros(length(PhaseFreqVector),length(AmpFreqVector),windows));
rsMovie = single(zeros(length(PhaseFreqVector),length(AmpFreqVector),windows));
loMovie = single(zeros(length(PhaseFreqVector),length(AmpFreqVector),windows));
roMovie = single(zeros(length(PhaseFreqVector),length(AmpFreqVector),windows));
%%
toc
disp(['Begining parfor (' num2str(windows) ' total)'])
parfor i = 1:windows
    disp(i)
    winEnd = i*winLength+1;
    if ismember(winEnd-winLength,rTdIdx)
        rState{i} = 'High \theta / \delta';
    else
        rState{i} = 'Low \theta / \delta';
    end
    if ismember(winEnd-winLength,lTdIdx)
        lState{i} = 'High \theta / \delta';
    else
        lState{i} = 'Low \theta / \delta';
    end
    
    lc = lCortex(winEnd-winLength:winEnd-1);
    rc = rCortex(winEnd-winLength:winEnd-1);
    lp = lPyramidal(winEnd-winLength:winEnd-1);
    rp = rPyramidal(winEnd-winLength:winEnd-1);
    ls = lSlm(winEnd-winLength:winEnd-1);
    rs = rSlm(winEnd-winLength:winEnd-1);
    lo = lOriens(winEnd-winLength:winEnd-1);
    ro = rOriens(winEnd-winLength:winEnd-1);
    
    lpComod = single(zeros(length(PhaseFreqVector),length(AmpFreqVector)));
    rpComod = single(zeros(length(PhaseFreqVector),length(AmpFreqVector)));
    lsComod = single(zeros(length(PhaseFreqVector),length(AmpFreqVector)));
    rsComod = single(zeros(length(PhaseFreqVector),length(AmpFreqVector)));
    loComod = single(zeros(length(PhaseFreqVector),length(AmpFreqVector)));
    roComod = single(zeros(length(PhaseFreqVector),length(AmpFreqVector)));
    
    % Filtering
    % disp(['Filtering ' num2str(i)])
    switch phase
        case 'cortex'
            rpAmpFreqTransformed = zeros(length(AmpFreqVector), winLength);
            lpAmpFreqTransformed = zeros(length(AmpFreqVector), winLength);
            rsAmpFreqTransformed = zeros(length(AmpFreqVector), winLength);
            lsAmpFreqTransformed = zeros(length(AmpFreqVector), winLength);
            roAmpFreqTransformed = zeros(length(AmpFreqVector), winLength);
            loAmpFreqTransformed = zeros(length(AmpFreqVector), winLength);
            
            rcPhaseFreqTransformed = zeros(length(PhaseFreqVector), winLength);
            lcPhaseFreqTransformed = zeros(length(PhaseFreqVector), winLength);
            
            
            %'Filtering right side LFP '
            
            for ii = 1:length(AmpFreqVector)
                Af1 = AmpFreqVector(ii); % Amplitude frequency start
                Af2 = Af1 + AmpFreq_BandWidth; % amplitude frequency end
                
                rpAmpFreq = eegfilt(rp', Fs, Af1, Af2); % just filtering
                lpAmpFreq = eegfilt(lp', Fs, Af1, Af2); % just filtering
                rsAmpFreq = eegfilt(rs', Fs, Af1, Af2); % just filtering
                lsAmpFreq = eegfilt(ls', Fs, Af1, Af2); % just filtering
                roAmpFreq = eegfilt(ro', Fs, Af1, Af2); % just filtering
                loAmpFreq = eegfilt(lo', Fs, Af1, Af2); % just filtering
                
                rpAmpFreqTransformed(ii, :) = abs(hilbert(rpAmpFreq));
                lpAmpFreqTransformed(ii, :) = abs(hilbert(lpAmpFreq));
                rsAmpFreqTransformed(ii, :) = abs(hilbert(rsAmpFreq));
                lsAmpFreqTransformed(ii, :) = abs(hilbert(lsAmpFreq));
                roAmpFreqTransformed(ii, :) = abs(hilbert(roAmpFreq));
                loAmpFreqTransformed(ii, :) = abs(hilbert(loAmpFreq));
            end
            for jj = 1:length(PhaseFreqVector)
                Pf1 = PhaseFreqVector(jj);
                Pf2 = Pf1 + PhaseFreq_BandWidth;
                rcPhaseFreq = eegfilt(rc', Fs, Pf1, Pf2); % this is just filtering
                lcPhaseFreq = eegfilt(lc', Fs, Pf1, Pf2);
                
                rcPhaseFreqTransformed(jj, :) = angle(hilbert(rcPhaseFreq)); % this is getting the phase time series
                lcPhaseFreqTransformed(jj, :) = angle(hilbert(lcPhaseFreq));
            end
        case 'hippocampus' %switches Amp and Phase to change which LFP is considered phase
            rcAmpFreqTransformed = zeros(length(AmpFreqVector), winLength);
            lcAmpFreqTransformed = zeros(length(AmpFreqVector), winLength);
            
            rpPhaseFreqTransformed = zeros(length(PhaseFreqVector), winLength);
            lpPhaseFreqTransformed = zeros(length(PhaseFreqVector), winLength);
            rsPhaseFreqTransformed = zeros(length(PhaseFreqVector), winLength);
            lsPhaseFreqTransformed = zeros(length(PhaseFreqVector), winLength);
            roPhaseFreqTransformed = zeros(length(PhaseFreqVector), winLength);
            loPhaseFreqTransformed = zeros(length(PhaseFreqVector), winLength);
            
            % Right side
            for ii = 1:length(AmpFreqVector)
                Af1 = AmpFreqVector(ii);
                Af2 = Af1 + AmpFreq_BandWidth;
                
                rcAmpFreq = eegfilt(rc', Fs, Af1, Af2); % just filtering
                lcAmpFreq = eegfilt(lc', Fs, Af1, Af2); % just filtering
                
                rcAmpFreqTransformed(ii, :) = abs(hilbert(rcAmpFreq)); % getting the amplitude envelope
                lcAmpFreqTransformed(ii, :) = abs(hilbert(lcAmpFreq)); % getting the amplitude envelope
            end
            for jj = 1:length(PhaseFreqVector)
                Pf1 = PhaseFreqVector(jj);
                Pf2 = Pf1 + PhaseFreq_BandWidth;
                
                rpPhaseFreq = eegfilt(rp', Fs, Pf1, Pf2); % this is just filtering
                lpPhaseFreq = eegfilt(lp', Fs, Pf1, Pf2); % this is just filtering
                rsPhaseFreq = eegfilt(rs', Fs, Pf1, Pf2); % this is just filtering
                lsPhaseFreq = eegfilt(ls', Fs, Pf1, Pf2); % this is just filtering
                roPhaseFreq = eegfilt(ro', Fs, Pf1, Pf2); % this is just filtering
                loPhaseFreq = eegfilt(lo', Fs, Pf1, Pf2); % this is just filtering
                
                rpPhaseFreqTransformed(jj, :) = angle(hilbert(rpPhaseFreq)); % this is getting the phase time series
                lpPhaseFreqTransformed(jj, :) = angle(hilbert(lpPhaseFreq));
                rsPhaseFreqTransformed(jj, :) = angle(hilbert(rsPhaseFreq));
                lsPhaseFreqTransformed(jj, :) = angle(hilbert(lsPhaseFreq));
                roPhaseFreqTransformed(jj, :) = angle(hilbert(roPhaseFreq));
                loPhaseFreqTransformed(jj, :) = angle(hilbert(loPhaseFreq));
            end
            
    end % Ends switch phase statement
    % Comodulation
    % disp(['Comodulating ' num2str(i)])
    counter1 = 0;
    switch phase
        case 'cortex'
            for ii = 1:length(PhaseFreqVector)
                counter1 = counter1+1;
                Pf1 = PhaseFreqVector(ii);
                Pf2 = Pf1+PhaseFreq_BandWidth;
                counter2=0;
                for jj = 1:length(AmpFreqVector)
                    counter2 = counter2+1;
                    Af1 = AmpFreqVector(jj);
                    Af2 = Af1+AmpFreq_BandWidth;
                    [rpComod(counter1,counter2),~] = ModIndex_v2(rcPhaseFreqTransformed(ii, :), rpAmpFreqTransformed(jj, :), position);
                    [lpComod(counter1,counter2),~] = ModIndex_v2(lcPhaseFreqTransformed(ii, :), lpAmpFreqTransformed(jj, :), position);
                    [rsComod(counter1,counter2),~] = ModIndex_v2(rcPhaseFreqTransformed(ii, :), rsAmpFreqTransformed(jj, :), position);
                    [lsComod(counter1,counter2),~] = ModIndex_v2(lcPhaseFreqTransformed(ii, :), lsAmpFreqTransformed(jj, :), position);
                    [roComod(counter1,counter2),~] = ModIndex_v2(rcPhaseFreqTransformed(ii, :), roAmpFreqTransformed(jj, :), position);
                    [loComod(counter1,counter2),~] = ModIndex_v2(lcPhaseFreqTransformed(ii, :), loAmpFreqTransformed(jj, :), position);
                end
            end
        case 'hippocampus'
            for ii = 1:length(PhaseFreqVector)
                counter1 = counter1+1;
                Pf1 = PhaseFreqVector(ii);
                Pf2 = Pf1+PhaseFreq_BandWidth;
                counter2=0;
                for jj = 1:length(AmpFreqVector)
                    counter2 = counter2+1;
                    Af1 = AmpFreqVector(jj);
                    Af2 = Af1+AmpFreq_BandWidth;
                    [rpComod(counter1,counter2),~] = ModIndex_v2(rpPhaseFreqTransformed(ii, :), rcAmpFreqTransformed(jj, :), position);
                    [lpComod(counter1,counter2),~] = ModIndex_v2(lpPhaseFreqTransformed(ii, :), lcAmpFreqTransformed(jj, :), position);
                    [rsComod(counter1,counter2),~] = ModIndex_v2(rsPhaseFreqTransformed(ii, :), rcAmpFreqTransformed(jj, :), position);
                    [lsComod(counter1,counter2),~] = ModIndex_v2(lsPhaseFreqTransformed(ii, :), lcAmpFreqTransformed(jj, :), position);
                    [roComod(counter1,counter2),~] = ModIndex_v2(roPhaseFreqTransformed(ii, :), rcAmpFreqTransformed(jj, :), position);
                    [loComod(counter1,counter2),~] = ModIndex_v2(loPhaseFreqTransformed(ii, :), lcAmpFreqTransformed(jj, :), position);
                end
                % toc
            end
    end %ends switch statement
    rpMovie(:,:,i) = rpComod;
    lpMovie(:,:,i) = lpComod;
    rsMovie(:,:,i) = rsComod;
    lsMovie(:,:,i) = lsComod;
    roMovie(:,:,i) = roComod;
    loMovie(:,:,i) = loComod;
    disp([num2str(i) ' Completed'])
end
toc
cd('C:\Users\user\Documents\MATLAB\ComodulogramsLite')
cd(name)
disp('saving')
save([phase ' phase Movie'],'rpMovie','lpMovie','rsMovie','lsMovie','roMovie','loMovie','rState','lState')







