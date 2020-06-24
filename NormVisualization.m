load('SpkInfo.mat')
limit = 0;

%%
cd('C:\Users\ipzach\Documents\Converted\Control_7')
load('concatenatedLFP.mat')

lowImp = cLFP(:, SpkInfo{1,2}(7).R_chn{2}(1));

highImp = cLFP(:, SpkInfo{1,2}(7).R_chn{3}(1));

n = @(data) ((data - mean(data))/std(data));
lowImp_N = n(lowImp);
highImp_N = n(highImp);

%%
figure
range = 1:10000;
%%
% X_
% __
subplot('Position',[0.1 0.5 0.38 0.4])
plot(lowImp(range),'k')
box off
ylim([-17000 17000])
title('High Impedance')
set(gca, 'xtick',[])
ylabel('nV')
set(gca,'FontSize',15)

% _X
% __
subplot('Position',[0.5 0.5 0.38 0.4])
plot(highImp(range),'k')
box off, axis off
ylim([-17000 17000])
title('Low Impedance')
set(gca,'FontSize',15)

% __
% X_
subplot('Position',[0.1 0.1 0.38 0.4])
plot(lowImp_N(range),'k')
set(gca, 'xtick',[])
box off
ylim([-2.7000 2.7000])
ylabel('SD')
xlabel('Time (8 seconds)')
set(gca,'FontSize',15)
% __
% _X
subplot('Position',[0.5 0.1 0.38 0.4])
plot(highImp_N(range),'k')
box off
ylim([-2.7 2.7])
set(gca, 'xtick',[],'ytick',[])
xlabel('Time (8 seconds)')
xlabel('Time (8 seconds)')
set(gca,'FontSize',15)
%%
        subplot('Position',[0.1 (0.1+counter*0.133) 0.37 0.133])
        plot(rat(2).NR(j,range),'k')
        set(gca, 'xtick',[])
        ylim([-2.7 2.7])
        if counter == 0, box off,xlabel('time (8 seconds)')
        else, box off, axis off
        end
        
        if counter == 5, title('Normalized Signal'), set(gca,'FontSize',13)
        end
        
        subplot('Position',[0.5 (0.1+counter*0.133) 0.37 0.133])
        plot(rat(i).R(j,range),'k')
        set(gca, 'xtick',[])
        ylim([-17000 17000])
        
        if counter == 0, box off,xlabel('time (8 seconds)')
        else, box off, axis off
        end
        if counter == 5, title('Raw Signal'), set(gca,'FontSize',13)
        end
        counter = counter + 1;

% subplot('Position',[0.1 0.98 0 0])
% text(-0.2,0.2, 'A','FontSize',20)