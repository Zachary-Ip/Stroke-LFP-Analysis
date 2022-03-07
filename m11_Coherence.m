clear all
tic
disp('Initializing Files')
filepath = 'C:\Users\ipzach\Documents\MATLAB';
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
        REM = ['C:\Users\ipzach\Documents\MATLAB\Data' filesep SpkInfo{group,1} '_' num2str(animal) filesep 'cREM.mat'];
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
        activefilepath = ['C:\Users\ipzach\Documents\MATLAB\Data' filesep SpkInfo{group,1} '_' num2str(animal) filesep 'concatenatedLFP.mat'];
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
            
            for iBand = 1:5
                switch iBand
                    case 1
                        range = linspace(0.1,3,20);
                    case 2
                        range = linspace(4,7,20);
                    case 3
                        range = linspace(30,58,20);
                    case 4
                        range = linspace(62,200,20);
                    case 5
                        range = linspace(0,200,50);
                end % switch iBand
                
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
                    Co(group,iBand,1,count,A,B) = mean(mscohere(ALH_LFP,BLH_LFP,hamming(12500),[],range,1250));
                catch
                    disp(['Coherence for ' SpkInfo{group,1} num2str(animal) ' Left not calculated'])
                end
                try
                    Co(group,iBand,2,count,A,B) = mean(mscohere(ARH_LFP,BRH_LFP,hamming(12500),[],range,1250));
                catch
                    disp(['Coherence for ' SpkInfo{group,1} num2str(animal) ' Right not calculated'])
                    
                end
                
                
            end % band
            
        end % layer
        
    end % animal
    
end % group
%
%% Coherence
Co(Co == 0) = NaN;
count = 0;
lab1 = {'Ctx','SLM','Pyr'};
lab2 = {'SLM','Pyr','Oriens'};
for i = [1:4 6]
    switch i
        case 1
            treatName = 'Control';
        case 2
            treatName = 'EES';
        case 3
            treatName = '1MS';
        case 4
            treatName = '2WS';
        case 6
            treatName = 'EES';
    end
    
    for j = 1:5
        switch j
            case 1
                groupName = 'Delta';
            case 2
                groupName = 'Theta';
            case 3
                groupName = 'Gamma';
            case 4
                groupName = 'HGamma';
            case 5
                groupName = 'Full';
        end
        count = count +1;
        combineRec = squeeze(nanmean(Co,3));
        % Group, Band, Animal, Layer, layer
        combineAnimal = squeeze(nanmean(combineRec,3));
        % group, band, layer, layer
        subplot(5,5,count)
        h = heatmap(squeeze(combineAnimal(i,j,1:3,2:4)));
        h.ColorbarVisible = 'off';
        set(gca,'xData',lab2,'yData',lab1);
        caxis([0 1]);
        if i ==1
            title(groupName)
        end
        if j ==1
            ylabel(treatName)
        end
        
    end
end

%% stats
for band = 1:5
    for layComb = 1:6
        % First we want to grab individual values, create 2-way labels for
        % them, then concatenate everything together
        switch layComb
            case 1
                ctr = squeeze(combineRec(1, band, :, 1, 2));
                EEC = squeeze(combineRec(2, band, :, 1, 2));
                MS1 = squeeze(combineRec(3, band, :, 1, 2));
                WS2 = squeeze(combineRec(4, band, :, 1, 2));
                EES = squeeze(combineRec(6, band, :, 1, 2));
            case 2
                ctr = squeeze(combineRec(1, band, :, 1, 3));
                EEC = squeeze(combineRec(2, band, :, 1, 3));
                MS1 = squeeze(combineRec(3, band, :, 1, 3));
                WS2 = squeeze(combineRec(4, band, :, 1, 3));
                EES = squeeze(combineRec(6, band, :, 1, 3));
            case 3
                ctr = squeeze(combineRec(1, band, :, 1, 4));
                EEC = squeeze(combineRec(2, band, :, 1, 4));
                MS1 = squeeze(combineRec(3, band, :, 1, 4));
                WS2 = squeeze(combineRec(4, band, :, 1, 4));
                EES = squeeze(combineRec(6, band, :, 1, 4));
            case 4
                ctr = squeeze(combineRec(1, band, :, 2, 3));
                EEC = squeeze(combineRec(2, band, :, 2, 3));
                MS1 = squeeze(combineRec(3, band, :, 2, 3));
                WS2 = squeeze(combineRec(4, band, :, 2, 3));
                EES = squeeze(combineRec(6, band, :, 2, 3));
            case 5
                ctr = squeeze(combineRec(1, band, :, 2, 4));
                EEC = squeeze(combineRec(2, band, :, 2, 4));
                MS1 = squeeze(combineRec(3, band, :, 2, 4));
                WS2 = squeeze(combineRec(4, band, :, 2, 4));
                EES = squeeze(combineRec(6, band, :, 2, 4));
            case 5
                ctr = squeeze(combineRec(1, band, :, 3, 4));
                EEC = squeeze(combineRec(2, band, :, 3, 4));
                MS1 = squeeze(combineRec(3, band, :, 3, 4));
                WS2 = squeeze(combineRec(4, band, :, 3, 4));
                EES = squeeze(combineRec(6, band, :, 3, 4));
        end % switch layComb
        
        ctr(isnan(ctr)) = [];
        EEC(isnan(EEC)) = [];
        MS1(isnan(MS1)) = [];
        WS2(isnan(WS2)) = [];
        
        CtrAgeLab = cell(length(ctr),1);
        CtrAgeLab(:) = {'Ctr'};
        CtrtreatLab = cell(length(ctr),1);
        CtrtreatLab(:) = {'Std'};
        
        EECAgeLab = cell(length(EEC),1);
        EECAgeLab(:) = {'Ctr'};
        EECtreatLab = cell(length(EEC),1);
        EECtreatLab(:) = {'EE'};
        
        MS1AgeLab = cell(length(MS1),1);
        MS1AgeLab(:) = {'1MS'};
        MS1treatLab = cell(length(MS1),1);
        MS1treatLab(:) = {'Std'};
        
        WS2AgeLab = cell(length(WS2),1);
        WS2AgeLab(:) = {'2WS'};
        WS2treatLab = cell(length(WS2),1);
        WS2treatLab(:) = {'Std'};
        
        EESAgeLab = cell(length(WS2),1);
        EESAgeLab(:) = {'1MS'};
        EEStreatLab = cell(length(WS2),1);
        EEStreatLab(:) = {'EE'};
        
        vals = [ctr; EEC; MS1; EES];
        ageLabs = [CtrAgeLab; EECAgeLab; MS1AgeLab; EESAgeLab];
        dbLabs = [CtrtreatLab; EECtreatLab; MS1treatLab; EEStreatLab];
        
        [~,~,stats] = anovan(vals,{ageLabs,dbLabs},'model','interaction');
        drawnnow
        pause(0.1)
        % [C,M] = multcompare(stats,'Dimension',[1 2],'CType','bonferroni');
    end % for layComb
end% for band