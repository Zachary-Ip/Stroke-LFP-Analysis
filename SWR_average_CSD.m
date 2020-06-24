% Combine SWR CSD's for each group
% THIS WILL TAKE 1000 YEARS TO RUN. THINK CAREFULLY
tic
load('SpkInfo.mat')

path = 'C:\Users\ipzach\Documents\MATLAB\Data'; % data path
cd(path)
Fs = 1250;
voltScaler = 0.000000015624999960550667;

for iGroup = [1:4 6]
    files = dir([SpkInfo{iGroup,1} '*']);
    
    figure
    % load all files for a particular group
    for jAnimal = 1:length(files)
        cd(files(jAnimal).name)
        load('Aligned SWR CSD L.mat')
        load('Aligned SWR CSD R.mat')
        
        subplot(3,8,2*jAnimal-1)
        pcolor(flipud(mean(SWR_CSD_L,3)')), shading interp, colormap(flipud(jet))
        title('Left')
        subplot(3,8,2*jAnimal)
        pcolor(flipud(mean(SWR_CSD_R,3)')), shading interp, colormap(flipud(jet))
        title('Right')
        drawnow
        cd ..
        disp(jAnimal)
        % end animal
    end
    
    suplabel(SpkInfo{iGroup,1},'t')
    %end group
end
disp('Finito!'), toc









