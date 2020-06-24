% Plots L/R hemisphere comparisons against each other
% Last edited by Zachary Ip 4/19
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd('C:\Users\ipzac\Documents\MATLAB')
load SpkInfo.mat
cd('C:\Users\ipzac\Documents\MATLAB\Stats\PAC\Hemispheres')
load('H_PC_AO_P0-3_A30-60_LR.mat')
figure(1)
count = 0;
for group = [1:4 6]
    count = count + 1;
    error = [(stats(group).ci(2)-stats.(group).ci(1))/2 stats(group).t{3,4}];
    data = [mean(stats(group).ldata) mean(stats(group).rdata)];
    names = {'Ipsilateral', 'Contralateral'};
    subplot(1, 5, count), barwitherr(error, data);
    set(gca, 'Xticklabel', names), ylim([0, max(data)*1.5])
    title(['pval = ' num2str(stats(group).t{2,6})])
    ylabel(SpkInfo{group, 1})
%     if stats(group).t{2,6} <= 0.05
%         sigstar(names);
%     end
end
suplabel('P0-3, A30-60', 't')
%%
load('H_PC_AO_P0-3_A80-150_LR.mat')
figure(2)
count = 0;
for group = [1:4 6]
    count = count + 1;
    error = [stats(group).t{2,4} stats(group).t{3,4}];
    data = stats(group).s.means;
    names = {'Ipsilateral', 'Contralateral'};
    subplot(1, 5, count), barwitherr(error, data);
    set(gca, 'Xticklabel', names), ylim([0, max(data)*1.5])
    title(['pval = ' num2str(stats(group).t{2,6})])
    ylabel(SpkInfo{group, 1})
%     if stats(group).t{2,6} <= 0.05
%         sigstar(names);
%     end
end
suplabel('P0-3, A80-150', 't')
%%
load('H_PC_AO_P3-7_A30-60_LR.mat')
figure(3)
count = 0;
for group = [1:4 6]
    count = count + 1;
    error = [stats(group).t{2,4} stats(group).t{3,4}];
    data = stats(group).s.means;
    names = {'Ipsilateral', 'Contralateral'};
    subplot(1, 5, count), barwitherr(error, data);
    set(gca, 'Xticklabel', names), ylim([0, max(data)*1.5])
    title(['pval = ' num2str(stats(group).t{2,6})])
    ylabel(SpkInfo{group, 1})
%     if stats(group).t{2,6} <= 0.05
%         sigstar(names);
%     end
end
suplabel('P3-7_A30-60', 't')
%%
load('H_PC_AO_P3-7_A80-150_LR.mat')
figure(4)
count = 0;
for group = [1:4 6]
    count = count + 1;
    error = [stats(group).t{2,4} stats(group).t{3,4}];
    data = stats(group).s.means;
    names = {'Ipsilateral', 'Contralateral'};
    subplot(1, 5, count), barwitherr(error, data);
    set(gca, 'Xticklabel', names), ylim([0, max(data)*1.5])
    title(['pval = ' num2str(stats(group).t{2,6})])
    ylabel(SpkInfo{group, 1})
%     if stats(group).t{2,6} <= 0.05
%         sigstar(names);
%     end
end
suplabel('P3-7_A80-150', 't')