% Grabs C matrix from PAC_Stats and creates bar plots of multcompare.
% This code needs to clearly display left and right hemispheres, error
% bars, and sig stars.
% Last edited by Zachary Ip, 4/19
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all
filePath = 'C:\Users\user\Documents\MATLAB';
cd(filePath)
nGroups = 3; % Which group comparison are you plotting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(['Stats\PAC\' num2str(nGroups) ' Group (Average Window)'])

switch nGroups
    case 3
        names = {'Control', 'Stroke', 'EE'};
        groups = {[1,2],[1,3],[2,3]};
    case 4
        names = {'Control', 'Sham', 'Stroke', 'EE'};
        groups = {[1,2],[1,3],[1,4],[2,3],[2,4],[3,4]};
    case 5
        names = {'Control', 'Sham', '1 Month', '2 Week', 'EE'};
        groups = {[1,2],[1,3],[1,4],[1,5],[2,3],[2,4],[2,5],[3,4],[3,5],[4,5]};
end

for  comparison = [1:7]
    switch comparison
        case 1
            layer = 'PC_AC';
        case 2
            layer = 'PC_AO';
        case 3
            layer = 'PC_AP';
        case 4
            layer = 'PC_AS';
        case 5
            layer = 'PO_AC';
        case 6
            layer = 'PP_AC';
        case 7
            layer = 'PS_AC';
    end
    
    list = dir(['H_' layer '*']);
    load(list(1).name)
    lowLeft.Left = lM;
    lowLeft.Right = rM;
    lowLeft.lC = lC;
    lowLeft.rC = rC;
    
    load(list(2).name)
    midLeft.Left = lM;
    midLeft.Right = rM;
    midLeft.lC = lC;
    midLeft.rC = rC;
    
    load(list(3).name)
    topLeft.Left = lM;
    topLeft.Right = rM;
    topLeft.lC = lC;
    topLeft.rC = rC;
    
    load(list(4).name)
    lowRight.Left = lM;
    lowRight.Right = rM;
    lowRight.lC = lC;
    lowRight.rC = rC;
    
    load(list(5).name)
    midRight.Left = lM;
    midRight.Right = rM;
    midRight.lC = lC;
    midRight.rC = rC;
    
    load(list(6).name)
    topRight.Left = lM;
    topRight.Right = rM;
    topRight.lC = lC;
    topRight.rC = rC;
    
    maxVal = 1.3*max([max(lowLeft.Left(:)) max(midLeft.Left(:)) max(topLeft.Left(:)) max(lowLeft.Right(:)) max(midLeft.Right(:)) max(topLeft.Right(:)) max(lowRight.Left(:)) max(midRight.Left(:)) max(topRight.Left(:)) max(lowRight.Right(:)) max(midRight.Right(:)) max(topRight.Right(:))]);
    figure(comparison)
    % Lower left
    
    subplot('Position',[0.1, 0.1,0.175,0.26]),
    barwitherr(lowLeft.Left(:,2),lowLeft.Left(:,1));
    sigstar(groups,lowLeft.lC(:,6));
    set(gca, 'XTickLabel', names), ylabel('0-15 Hz'), xlabel('0-3 Hz')
    colormap('gray')
    
    subplot('Position',[0.55, 0.1,0.175,0.26])
    barwitherr(lowLeft.Right(:,2),lowLeft.Right(:,1));
    sigstar(groups,lowLeft.rC(:,6));
    set(gca, 'XTickLabel', names), ylabel('0-15 Hz'), xlabel('0-3 Hz')
    
    % Middle Left
    subplot('Position',[0.1, 0.36,0.175,0.26])
    barwitherr(midLeft.Left(:,2),midLeft.Left(:,1));
    sigstar(groups,midLeft.lC(:,6));
    set(gca, 'Xtick', []), ylabel('30-60 Hz')
    
    subplot('Position',[0.55, 0.36,0.175,0.26])
    barwitherr(midLeft.Right(:,2),midLeft.Right(:,1));
    sigstar(groups,midLeft.rC(:,6));
    set(gca, 'Xtick', []), ylabel('30-60 Hz')
    
    % Top Left
    
    subplot('Position',[0.1, 0.62,0.175,0.26])
    barwitherr(topLeft.Left(:,2),topLeft.Left(:,1));
    sigstar(groups,topLeft.lC(:,6));
    set(gca, 'Xtick', []), ylabel('80-150 Hz')
    
    subplot('Position',[0.55, 0.62,0.175,0.26])
    barwitherr(topLeft.Right(:,2),topLeft.Right(:,1));
    sigstar(groups,topLeft.rC(:,6));
    set(gca, 'Xtick', []), ylabel('80-150 Hz')
    
    %Lower Right
    
    subplot('Position',[0.275, 0.1,0.175,0.26])
    barwitherr(lowRight.Left(:,2),lowRight.Left(:,1));
    sigstar(groups,lowRight.lC(:,6));
    set(gca, 'XTickLabel', names, 'Ytick', []), xlabel('3-7 Hz')
    
    subplot('Position',[0.725, 0.1,0.175,0.26])
    barwitherr(lowRight.Right(:,2),lowRight.Right(:,1));
    sigstar(groups,lowRight.rC(:,6));
    set(gca, 'XTickLabel', names, 'Ytick', []), xlabel('3-7 Hz')
    
    % Middle Right
    
    subplot('Position',[0.275, 0.36,0.175,0.26])
    barwitherr(midRight.Left(:,2),midRight.Left(:,1));
    sigstar(groups,midRight.lC(:,6));
    set(gca, 'Xtick', [], 'Ytick', [])
    
    subplot('Position',[0.725, 0.36,0.175,0.26])
    barwitherr(midRight.Right(:,2),midRight.Right(:,1));
    sigstar(groups,midRight.rC(:,6));
    set(gca, 'Xtick', [], 'Ytick', [])
    
    % Top Right
    subplot('Position',[0.275, 0.62,0.175,0.26])
    barwitherr(topRight.Left(:,2),topRight.Left(:,1));
    sigstar(groups,topRight.lC(:,6));
    set(gca, 'Xtick', [], 'Ytick', []), title('Ipsilateral')
    
    subplot('Position',[0.725, 0.62,0.175,0.26])
    barwitherr(topRight.Right(:,2),topRight.Right(:,1));
    sigstar(groups,topRight.rC(:,6));
    set(gca, 'Xtick', [], 'Ytick', []), title('Contralateral')
    
    suplabel(layer  ,'t');
    %, ylim([0 maxVal])
end




