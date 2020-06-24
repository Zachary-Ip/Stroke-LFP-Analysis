filepath = 'C:\Users\ipzac\Documents\Shivalika\';
cd(filepath)
load('SpkInfo.mat')

filepath = [filepath 'Data'];

source = 'C:\Users\ipzac\Documents\Converted';
cd(source)
filelist = dir;

for group = [1:4 6]
    cd(source)
    list = dir([SpkInfo{group,1} '*']);
    for animal = 1:length(list)
        cd(source)
        cd(list(animal).name)
        if exist('cREM.mat') == 2
            load('cREM.mat');
            cd(filepath)
            mkdir(list(animal).name)
            cd(list(animal).name)
            save('cREM.mat','cREM')
            
        end
    end
end


%%
cd(source)
same = 0;
different = 0;
l = [];
difference = [];
for i = 5:length(filelist)
    cd(filelist(i).name)
    if exist('cREM.mat') == 2
        load('cREM.mat');
        disp(filelist(i).name)
        if(length(cREM.R.start) == length(cREM.L.start))
            same = same +1;
            disp(['Same # REMs ' num2str(same)])
            l = [l length(cREM.R.start)];
        else
            difference = [difference abs(length(cREM.R.start) - length(cREM.L.start))];
            different = different +1;
            disp(['Difference = ' num2str(difference(length(difference))) ' Total: ' num2str(different)])
            l = [l mean([length(cREM.R.start) length(cREM.L.start)])];
            
        end
    end
    cd ..
end
disp(['Avg changes = ' num2str(mean(l))])
disp(['Avg difference = ' num2str(mean(difference))])
disp(['Biggest difference = ' num2str(max(difference))])