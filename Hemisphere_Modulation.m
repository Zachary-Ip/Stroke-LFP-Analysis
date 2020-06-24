% This code creates Comodulograms between left and right hemisphere
%This does not take into consideration Theta/Delta states at the moment
% created by Zachary ip 3/27/19
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% READ ME %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Commodulograms will save into
% C:\Users\ipzac\Documents\MATLAB\Comodulograms
% under the appropriate animal file. Each layer and left right phase amplitude
% assignement will save into the same folder. The formate for
% reading the save file will be layer_Phase hemisphere. For
% example, Comodulograms\EE Strk_1\O_PR.mat would be the comodulogram
% for EE Strk 1, Oriens, with the Right hemisphere as phase.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
disp('Initializing Files')
filepath = 'C:\Users\ipzac\Documents\MATLAB';
cd(filepath)
load('SpkInfo.mat')
Fs = 1250; % Sampling Frequency; needed for filtering and plotting
% Define the Amplitude- and Phase- Frequencies, Lower this range to have faster computing
PhaseFreqVector = 0:1:20; 
AmpFreqVector = 0:5:200;
PhaseFreq_BandWidth = 1;
AmpFreq_BandWidth = 10;

% For comodulation calculation (only has to be calculated once)
nbin = 0:17; % defines how many fractions to divide phase into
% this variable will get the beginning (not the center) of each phase bin (in rads)
winsize = 2*pi/18;
position = nbin*winsize -pi;

for group = [2:4 6]
    for animal = 1:length(SpkInfo{group,2})
        activefilepath = ['C:\Users\ipzac\Documents\Converted' filesep SpkInfo{group,1} '_' num2str(animal) filesep 'concatenatedLFP.mat'];
        load(activefilepath);
        disp(activefilepath);
        
        phaseHem = [];
        ampHem = [];
        if isempty(SpkInfo{group,2}(animal).L_chn{3}) || isempty(SpkInfo{group,2}(animal).R_chn{3})
            disp('Missing SpkInfo')
            continue
        end
        for layer = 1:4
            disp('Loading LFP Data')
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
            for side = 1:2 %1 Right is phase, 2 Left is phase
                switch side
                    case 1
                        phaseHem = cLFP(:,SpkInfo{group,2}(animal).R_chn{layer}(1));
                        ampHem = cLFP(:,SpkInfo{group,2}(animal).L_chn{layer}(1));
                    case 2
                        phaseHem = cLFP(:,SpkInfo{group,2}(animal).L_chn{layer}(1));
                        ampHem = cLFP(:,SpkInfo{group,2}(animal).R_chn{layer}(1));
                end
                % Filter and hilbert transform on CPU
                disp('Filtering')
                Comodulogram = single(zeros(length(PhaseFreqVector),length(AmpFreqVector)));
                AmpFreqTransformed = zeros(length(AmpFreqVector), length(ampHem));
                PhaseFreqTransformed = zeros(length(PhaseFreqVector), length(phaseHem));
                
                for i = 1:length(AmpFreqVector)
                    Af1 = AmpFreqVector(i);
                    Af2 = Af1 + AmpFreq_BandWidth;
                    AmpFreq = eegfilt(ampHem',Fs,Af1,Af2);
                    AmpFreqfTransformed(i,:) = abs(hilbert(AmpFreq));
                end
                for j = 1:length(PhaseFreqVector)
                    Pf1 = PhaseFreqVector(j);
                    Pf2 = Pf1 + PhaseFreq_BandWidth;
                    PhaseFreq = eegfilt(phaseHem',Fs,Pf1,Pf2);
                    PhaseFreqTransformed(j,:) = angle(hilbert(PhaseFreq));
                end
                toc
                disp('Comodulation') %Doing Comodulation now
                counter1 = 0;
                for ii = 1:length(PhaseFreqVector)
                    counter1 = counter1+1;
                    Pf1 = PhaseFreqVector(ii);
                    Pf2 = Pf1+PhaseFreq_BandWidth;
                    counter2 = 0;
                    for jj = 1:length(AmpFreqVector)
                        counter2 = counter2+1;
                        Af1 = AmpFreqVector(jj);
                        Af2 = Af1+AmpFreq_BandWidth;
                        [MI,MeanAmp] = ModIndex_v2(PhaseFreqTransformed(ii,:),AmpFreqTransformed(jj,:),position);
                        Comodulogram(counter1,counter2) = MI;
                    end
                end
                switch side
                    case 1
                        save(['C:\Users\ipzac\Documents\MATLAB\Comodulograms' filesep SpkInfo{group,1} '_' num2str(animal) filesep layertitle '_PR'], 'Comodulogram','phaseHem','ampHem');
                    case 2
                        save(['C:\Users\ipzac\Documents\MATLAB\Comodulograms' filesep SpkInfo{group,1} '_' num2str(animal) filesep layertitle '_PL'], 'Comodulogram','phaseHem','ampHem');
                end
                disp('Comodulation saved')
                %%
                figure
                contourf(PhaseFreqVector+PhaseFreq_BandWidth/2,AmpFreqVector+AmpFreq_BandWidth/2,Comodulogram',30,'lines','none')
                title([SpkInfo{group,1} ' ' num2str(animal) ' ' layertitle ]), colormap('jet')
                colorbar
            end
        end
    end
end
beep
disp('All Done!')