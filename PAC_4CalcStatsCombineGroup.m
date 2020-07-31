% Compares phase amplitude coupling between groups
% This code takes in freq ranges and compares distributions of one group to
% the others
% Last edited by Zachary Ip, 4/19
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
% Which phase and amplitude layer to run stats on
% P- C,P,O,S - which phase variable, cortex, pyramidal, oriens, SLM
% A- C,P,O,S - which amplitude variable, same abbreviations

filepath = 'C:\Users\user\Documents\MATLAB';
cd(filepath)
load('SpkInfo.mat')
cd('Comodulograms')

for grouping = 3 % 1:5
    for layerCombo = 2 % 1:7
        tic
        switch layerCombo
            case 1
                file = 'PC_AC';
            case 2
                file = 'PC_AO';
            case 3
                file = 'PC_AP';
            case 4
                file = 'PC_AS';
            case 5
                file = 'PO_AC';
            case 6
                file = 'PP_AC';
            case 7
                file = 'PS_AC';
        end
        disp(file)
        % Define window of comodulogram to view
        for frame = 3 % 1:4
            switch frame
                case 1
                    phaseLow  = 4; % Phase values must be multiples of 0.5
                    phaseHigh = 5; % max 12
                    ampLow    = 95; % Amp values must be in multiples of 2.5
                    ampHigh   = 120; % max 160
                case 2
                    phaseLow  = 4; % Phase values must be multiples of 0.5
                    phaseHigh = 6; % max 12
                    ampLow    = 90; % Amp values must be in multiples of 2.5
                    ampHigh   = 130; % max 160
                case 3
                    phaseLow  = 3; % Phase values must be multiples of 0.5
                    phaseHigh = 7; % max 12
                    ampLow    = 30; % Amp values must be in multiples of 2.5
                    ampHigh   = 60; % max 160
                case 4
                    phaseLow  = 3; % Phase values must be multiples of 0.5
                    phaseHigh = 7; % max 12
                    ampLow    = 80; % Amp values must be in multiples of 2.5
                    ampHigh   = 130; % max 160
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            phaseRange = phaseLow * 2 +1 : phaseHigh * 2;
            ampRange = ampLow/2.5 +1 : ampHigh/2.5;
            window = length(ampRange)*length(phaseRange);
            
            %% Load PAC values into a data structure
            
            % Grab a list of all files in a selected group
            switch grouping
                case 1
                    name = 'CvS '; 
                    ControlFiles = dir([SpkInfo{1,1} '*']);
                    StrokeFiles = [dir([SpkInfo{3,1} '*']); dir([SpkInfo{4,1} '*'])];
                case 2
                    name = 'ECvES ';
                    ControlFiles = dir([SpkInfo{2,1} '*']);
                    StrokeFiles = dir([SpkInfo{6,1} '*']);
                case 3
                    name = 'TCvTS ';
                    ControlFiles = [dir([SpkInfo{1,1} '*']); dir([SpkInfo{2,1} '*'])];
                    StrokeFiles = [dir([SpkInfo{3,1} '*']); dir([SpkInfo{4,1} '*']); dir([SpkInfo{6,1} '*'])];
                case 4
                    name = 'CvE ';
                    ControlFiles = dir([SpkInfo{1,1} '*']);
                    StrokeFiles = dir([SpkInfo{2,1} '*']);
                case 5
                    name = 'MvE ';
                    ControlFiles = dir([SpkInfo{4,1} '*']);
                    StrokeFiles = dir([SpkInfo{6,1} '*']);
            end
            
            % Run through each of them
            for c = 1:length(ControlFiles)
                cd(ControlFiles(c).name)
                % Load individual animals data
                load (['H_' file '_HD.mat'])
                % Condense the data from each range of the comodulogram into a
                % single mean value, store it in the data structure
                Control.R(c) = mean(reshape(Comodulogram.R(phaseRange,ampRange),1,window));
                Control.L(c) = mean(reshape(Comodulogram.L(phaseRange,ampRange),1,window));
                cd ..
            end
            
            for s = 1:length(StrokeFiles)
                cd(StrokeFiles(s).name)
                load (['H_' file '_HD.mat'])
                % Condense the data from each range of the comodulogram into a
                % single mean value, store it in the data structure
                Stroke.R(s) = mean(reshape(Comodulogram.R(phaseRange,ampRange),1,window));
                Stroke.L(s) = mean(reshape(Comodulogram.L(phaseRange,ampRange),1,window));
                cd ..
            end
            [~,RP] = ttest2(Control.R, Stroke.R);
            [~,LP] = ttest2(Control.L, Stroke.L);
            
            stats(layerCombo).RP(frame) = RP;
            stats(layerCombo).LP(frame) = LP;
            
            stats(layerCombo).RCmean(frame) = mean(Control.R);
            stats(layerCombo).LCmean(frame) = mean(Control.L);
            stats(layerCombo).RSmean(frame) = mean(Stroke.R);
            stats(layerCombo).LSmean(frame) = mean(Stroke.L);
            
            stats(layerCombo).RCstd(frame) = std(Control.R)/sqrt(length(Control.R));
            stats(layerCombo).LCstd(frame) = std(Control.L)/sqrt(length(Control.L));
            stats(layerCombo).RSstd(frame) = std(Stroke.R)/sqrt(length(Stroke.R));
            stats(layerCombo).LSstd(frame) = std(Stroke.L)/sqrt(length(Stroke.L));
            
            
        end
    end
    save(['C:\Users\user\Documents\MATLAB\Stats\PAC\' name ' Stats'],'stats')
    disp([name 'done'])
    % save here for each layer combo
end
cd ..
disp('All Done!')
toc













