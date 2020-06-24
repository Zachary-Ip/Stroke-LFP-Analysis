% Concatenates LFPs to make one large file (+ cREM file creation)
% ZI - 03252019
clear all, close all
Fs = 1250;
dirpath = uigetdir('./');
cd(dirpath)
folderlist = dir;

for i = [5:24 27:29 32:length(folderlist)]
    cd(folderlist(i).name)
    subfilelist = dir;
    cLFP = [];
    load LFP_1.mat
    cLFP = [cLFP; LFPs{1}(:, 2:end)];
    load LFP_2.mat
    cLFP = [cLFP; LFPs{1}(:, 2:end)];
    save('concatenatedLFP.mat','cLFP','-v7.3')
    cd('../')
end
    
%%
% %REM concatenation
for i = [5:24 27:29 32:length(folderlist)]
    cd(folderlist(i).name)
    subfilelist = dir;
    load REM.mat
    adder = length(rem(1).R.Theta_Delta)/Fs; % This will add the length of the first LFP to the time of the sedcond LFP
    % Right Side
    cREM.R.start = rem(1).R.start; % Copies the values from the first LFP
    cREM.R.start = [cREM.R.start rem(2).R.start + adder]; % Adds the adjusted second LFP values to the single array
    cREM.R.end = rem(1).R.end; % This does the same for the end values
    cREM.R.end = [cREM.R.end rem(2).R.end + adder];
    % Left Side
    cREM.L.start = rem(1).L.start; % Copies the values from the first LFP
    cREM.L.start = [cREM.L.start rem(2).L.start + adder]; % Adds the adjusted second LFP values to the single array
    cREM.L.end = rem(1).L.end; % This does the same for the end values
    cREM.L.end = [cREM.L.end rem(2).L.end + adder];
    save('cREM.mat', 'cREM')
    cd('../')
end


disp('All done!')
