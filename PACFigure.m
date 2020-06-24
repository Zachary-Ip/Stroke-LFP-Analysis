% PAC Across Groups Figures
% performs ttest on windowed stats 
clear all
filepath = 'C:\Users\user\Documents\MATLAB\Stats\PAC';
cd(filepath);

%% Across groups
for grouping = 1:5
    switch grouping
        case 1
            name = 'CvS ';
            leg = {'Control','Stroke'};
        case 2
            name = 'ECvES ';
            leg = {'EE Control','EE Stroke'};
        case 3
            name = 'TCvTS ';
            leg = {'Grouped Control',' Grouped Stroke'};
        case 4
            name = 'CvE ';
            leg = {'Control','EE Control'};
        case 5
            name = 'MvE ';
            leg = {'1M Stroke','EE Stroke'};
    end
    load([name ' Stats.mat']);
    figure
    
    counter = 0;
    for frame = 1:4
        for layerCombo = 1:7
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
            counter = counter +1;
            data = [stats(layerCombo).LCmean(frame) stats(layerCombo).LSmean(frame);
                stats(layerCombo).RCmean(frame) stats(layerCombo).RSmean(frame)];
            error = [stats(layerCombo).LCstd(frame) stats(layerCombo).LSstd(frame);
                stats(layerCombo).RCstd(frame) stats(layerCombo).RSstd(frame)];
            
            labels = {'Ipsi','Contra'};
            
            subplot(4,7,counter)
            barwitherr(error,data)
            set(gca, 'xticklabels',labels)
            range1 = {[0.7 1.3]};
            range2 = {[1.7 2.3]};
            if stats(layerCombo).LP(frame) <= 0.05
                val = double(stats(layerCombo).LP(frame));
                sigstar2(range1,val)
            end
            if stats(layerCombo).RP(frame) <= 0.05
                val = double(stats(layerCombo).RP(frame));
                sigstar2(range2,val)
            end
            if counter == 1
                title(file)
                ylabel({'Phase 4-5 Hz,','Amp 95-120Hz'})
            elseif counter > 1 && counter < 8
                title(file)
            elseif counter == 8
                ylabel({'Phase 4-6 Hz,','Amp 90-130Hz'})
            elseif counter == 15
                ylabel({'Phase 3-7 Hz,','Amp 30-60Hz'})
            elseif counter == 22
                ylabel({'Phase 3-7 Hz,','Amp 80-130Hz'})
            end
            % Each plot
        end
        % Each row
    end
    % Each figure
    legend(leg)
    suplabel(name,'t');
end

%% Across hemispheres
cd('C:\Users\ipzach\Documents\MATLAB\Stats\PAC')
for group = [1:4 6 5 7]
    switch group
        case 1
            name = 'Control';
        case 2
            name = 'EE Sham';
        case 3
            name = '1M Stroke';
        case 4
            name = '2W Stroke';
        case 5
            name = 'Group Control';
        case 6
            name = 'EE Stroke';
        case 7
            name = 'Group Stroke';
    end
    
    figure
    counter = 0;
        
    for layerCombo = 1:7
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
        
        load([file ' Stats.mat']);
        labels = {'Ipsi','Contra'};
        for frame = 1:4
            counter = counter +1;
            data = [stats(group).Lmean(frame) stats(group).Rmean(frame)];
            error = [stats(group).Lstd(frame) stats(group).Rstd(frame)];
            
            
            subplot(4,7,counter)
            barwitherr(error,data)
            set(gca, 'xticklabels',labels)
            if stats(group).P(frame) <= 0.05
                val = double(stats(group).P(frame));
                sigstar2([1 2],val)
            end
            if counter == 1
                title(file)
                ylabel({'Phase 0-3 Hz,','Amp 30-60Hz'})
            elseif counter > 1 && counter < 8
                title(file)
            elseif counter == 8
                ylabel({'Phase 0-3 Hz,','Amp 80-150Hz'})
            elseif counter == 15
                ylabel({'Phase 3-7 Hz,','Amp 30-60Hz'})
            elseif counter == 22
                ylabel({'Phase 3-7 Hz,','Amp 80-150Hz'})
            end
            % Each plot
        end
        % Each row
    end
    % Each figure
    suplabel(name,'t');
end
cd .., cd ..
