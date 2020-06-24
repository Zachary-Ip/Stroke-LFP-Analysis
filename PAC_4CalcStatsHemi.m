% Compares phase amplitude coupling between groups
% This code takes in freq ranges and compares distributions of one group to
% the others
% Last edited by Zachary Ip, 4/19
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
% Which phase and amplitude layer to run stats on
% P- C,P,O,S - which phase variable, cortex, pyramidal, oriens, SLM
% A_ C,P,O,S - which amplitude variable, same abbreviations

filepath = 'C:\Users\user\Documents\MATLAB';
cd(filepath)
load('SpkInfo.mat')
cd('Comodulograms')

for layerCombo = 7% 1:7
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
                phaseLow  = 0; % Phase values must be multiples of 0.5
                phaseHigh = 3; % max 12
                ampLow    = 30; % Amp values must be in multiples of 2.5
                ampHigh   = 60; % max 160
            case 2
                phaseLow  = 0; % Phase values must be multiples of 0.5
                phaseHigh = 3; % max 12
                ampLow    = 80; % Amp values must be in multiples of 2.5
                ampHigh   = 150; % max 160
            case 3
                phaseLow  = 3; % Phase values must be multiples of 0.5
                phaseHigh = 7; % max 12
                ampLow    = 30; % Amp values must be in multiples of 2.5
                ampHigh   = 60; % max 160
            case 4
                phaseLow  = 3; % Phase values must be multiples of 0.5
                phaseHigh = 7; % max 12
                ampLow    = 80; % Amp values must be in multiples of 2.5
                ampHigh   = 150; % max 160
        end % switch
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        phaseRange = phaseLow * 2 +1 : phaseHigh * 2;
        ampRange = ampLow/2.5 +1 : ampHigh/2.5;
        window = length(ampRange)*length(phaseRange);
        names = {};
        values = [];
        count = 0;
        %% Load PAC values into a data structure
        
        % Grab a list of all files in a selected group
        for group = [1:4 6]
            files = dir([SpkInfo{group,1} '*']);
            
            right = zeros(1,length(files));
            left = zeros(1,length(files));
            
            for animal = 1:length(files)
                count = count + 1;
                cd(files(animal).name)
                load (['H_' file '_HD.mat'])
                % Condense the data from each range of the comodulogram into a
                % single mean value, store it in the data structure
                right(animal) = mean(reshape(Comodulogram.R(phaseRange,ampRange),1,window));
                left(animal) = mean(reshape(Comodulogram.L(phaseRange,ampRange),1,window));
                names{count} = files(animal).name;
                values(count,2) = mean(reshape(Comodulogram.R(phaseRange,ampRange),1,window));
                values(count,1) = mean(reshape(Comodulogram.L(phaseRange,ampRange),1,window));
                cd ..
            end % animal
            [~,P] = ttest(right, left);
            
            stats(group).P(frame) = P;
            
            stats(group).Rmean(frame) = mean(right);
            stats(group).Lmean(frame) = mean(left);
            
            stats(group).Rstd(frame) = std(right)/sqrt(length(right));
            stats(group).Lstd(frame) = std(left)/sqrt(length(left));
        end % group
        
    end % frame
    %save(['C:\Users\ipzac\Documents\MATLAB\Stats\PAC\' file ' Stats'],'stats')
    % save here for each layer combo
    disp(['C '   num2str(stats(1).P)])
    disp(['EEC ' num2str(stats(2).P)])
    disp(['1MS ' num2str(stats(3).P)])
    disp(['2WS ' num2str(stats(4).P)])
    disp(['EES ' num2str(stats(6).P)])
end % Layer combo
cd ..
disp('All Done!')
toc

% thetaHighGammaCouple = table(names', values(:,1),values(:,2),'VariableNames',{'Animal','Ipsilateral(Left)','Contralateral(Right)'});











