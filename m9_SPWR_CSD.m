% This code will load all the LFPs and SWR files and create average CSD's
% using all ripples in all animals
clear all
load('SpkInfo.mat')
spwrPath = 'C:\Users\ipzach\Documents\MATLAB\output\SPWR\Rip6_Wave3SD'; % SWR path
lfpPath = 'C:\Users\ipzach\Documents\MATLAB\Data\Chronic Stroke\'; % data path
Fs = 1250;
voltScaler  = 0.000000015624999960550667;% convert units to volts
hotcold = redblue(); % Create custom red-white-blue colormap

% Params.tapers = dpss(1250/5,4); % These tapers may be uneccesary
% Params.Fs = Fs;
% Params.fpass = [10 250];
time = linspace(-1,1,2501);
% Run through all groups
for iGroup = [3 6 7 8 10]
    disp(SpkInfo{iGroup,1}) %Readout
    % figure
    counter = 0;
%     xSize = 1:2501;
%     ySize = linspace(-3e+03, 3e+03,16);
%     hold on
    % Run through all animals
    for jAnimal = 1:length(SpkInfo{iGroup,2})
        % Navigate to animals folder
        % Load neccesary data and reference files, skip animal if any are
        % missing
        cd(spwrPath)
        % Load Left Side
        try
            load([SpkInfo{iGroup,1} '_L' num2str(jAnimal) '.mat'])
            disp([SpkInfo{iGroup,1} '_L' num2str(jAnimal)])
            LeftEvents = SpwrLtdEvents;
        catch
            disp(['Missing ' SpkInfo{iGroup,1} '_L' num2str(jAnimal)])
            continue
        end
        % Load Right Side
        try
            load([SpkInfo{iGroup,1} '_R' num2str(jAnimal) '.mat'])
            disp([SpkInfo{iGroup,1} '_R' num2str(jAnimal)])
            RightEvents = SpwrLtdEvents;
        catch
            disp(['Missing ' SpkInfo{iGroup,1} '_R' num2str(jAnimal)])
            continue
        end
        % Load LFP
        cd(lfpPath)
        cd([SpkInfo{iGroup,1} '_' num2str(jAnimal)])
        load('concatenatedLFP.mat')
        cLFP = cLFP .* voltScaler;
%         cLFP = norm(cLFP);
        leftCsd = RunCsd(LeftEvents,cLFP, 'L');
%         leftCsd = norm(leftCsd);
        rightCsd = RunCsd(RightEvents,cLFP, 'R');
%         rightCsd = norm(rightCsd);
        
            counter = counter +1;
            
%             subplot(3,8,counter*2-1)
%             pcolor(xSize,ySize,flipud(mean(leftCsd,3)')), shading interp, colormap(flipud(hotcold))
%             title('Left')
%             
%             subplot(3,8,counter*2)
%             pcolor(xSize,ySize,flipud(mean(rightCsd,3)')), shading interp, colormap(flipud(hotcold))
%             % pLayer = 34-SpkInfo{iGroup,2}(str2double(files(jAnimal).name(strfind(files(jAnimal).name,'_')+1:end))).R_chn{3}(1);
%             title('Right')
%             
%             drawnow
            % Save animal file in Data folder
            save('LTD SPWR CSD R','leftCsd','-v7.3')
            save('LTD SPWR CSD L','rightCsd','-v7.3')
        cd ..
        disp(['Saved ' SpkInfo{iGroup,1} num2str(jAnimal)])
    end % animal
    %suplabel(SpkInfo{iGroup,1},'t');
end  % group
disp('It worked! I think..')

function [FullCsd] = RunCsd(events,LFP, side)
FullCsd = [];
counter = 0;
Fs = 1250;

for i = 1:size(events,1)
    if events(i,1) >= 1250
        startVal = events(i,1);
        counter = counter +1;
        switch side
            case 'R'
                ripple = LFP(startVal-Fs:startVal+Fs,1:16);
            case 'L'
                ripple = LFP(startVal-Fs:startVal+Fs,17:32);
        end % Switch
        FullCsd(:,:,counter) = CSDlite(ripple, Fs, 1e-4);
        drawnow
    end % if after 1 second
end % for num events
end