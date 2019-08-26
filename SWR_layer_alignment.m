% This code will take the CSD arrays and align them to the pyramidal layer.
% Then it will average them and show one CSD for each group. Also I'll mess
% around with some PCA stuff here I guess? I'll see if I can not crash my
% computer doing this
% clear all
LFP_path = 'C:\Users\ipzach\Documents\MATLAB\Data'; % data path
Fs = 1250;

load('SpkInfo.mat')
figure
hotcold = redblue;

electrodes = 1:10;
time = linspace(-1,1,2501);
ysize = linspace(-6e+03, 2e+03,10);

stat_block.L = zeros(10573,6);
stat_block.R = zeros(8617,6);

for group = [1:4 6]
    cd(LFP_path)
    disp(SpkInfo{group,1}) %Readout
    group_files = dir([SpkInfo{group,1} '*']);
    
    L_total_CSD = zeros(2501,10);
    L_total_wave = zeros(1,2501);
    L_SSA = [];
    L_total_weight = 0;
    
    R_total_CSD = zeros(2501,10);
    R_total_wave = zeros(1,2501);
    R_SSA = [];
    R_total_weight = 0;
    % full_stack = [];
     for animal = 1:length(group_files)
        cd(group_files(animal).name)
        disp(group_files(animal).name) 
        try
            load('LTD SWR CSD L.mat');
            load('LTD SWR CSD R.mat');
        catch
            disp('No CSD File')
            cd ..
            continue
        end 
        if isempty(SWR_CSD_L) || isempty(SWR_CSD_R)
            disp('Empty data file')
            cd ..
            continue
        end
        L_pyramidal_channel = SpkInfo{group,2}(str2double(group_files(animal).name(strfind(group_files(animal).name,'_')+1:end))).L_chn{3}(1);
        R_pyramidal_channel = SpkInfo{group,2}(str2double(group_files(animal).name(strfind(group_files(animal).name,'_')+1:end))).R_chn{3}(1)-16;
        try 
            L_data = SWR_CSD_L(:,L_pyramidal_channel-8:L_pyramidal_channel+1,:);
            L_wave = mean(waveform_L,1);
            
            R_data = SWR_CSD_R(:,R_pyramidal_channel-8:R_pyramidal_channel+1,:);
            R_wave = mean(waveform_R,1);
        catch
            disp('Invalid channel')
            cd ..
            continue
        end
        % Source sink-amplitude calculation
        L_SSA = SSA(L_SSA,L_data);
        R_SSA = SSA(R_SSA, R_data);
        %
        L_weight = size(L_data,3);
        L_total_weight = L_total_weight + L_weight;
        
        L_average_CSD = mean(L_data,3).*L_weight;   
        L_total_CSD = L_total_CSD + L_average_CSD;
        
        L_total_wave = L_total_wave + (L_wave .*L_weight);
        
        
        R_weight = size(R_data,3);
        R_total_weight = R_total_weight + R_weight;
        
        R_average_CSD = mean(R_data,3).*R_weight;
        R_total_CSD = R_total_CSD + R_average_CSD;
        
        R_total_wave = R_total_wave + (R_wave .*R_weight);
        
%         full_stack = [full_stack; linear_stack];
        
        cd ..
        % end animal
     end
     L_total_CSD = L_total_CSD ./ L_total_weight;
     R_total_CSD = R_total_CSD ./ R_total_weight;
     
     L_total_wave = L_total_wave ./ L_total_weight;
     R_total_wave = R_total_wave ./ R_total_weight;
     
     SE = @(data) std(data)./sqrt(length(data));
     
     stat_block.L(1:length(L_SSA),group) = L_SSA';
     bar_block(group).L_mean = mean(L_SSA);
     bar_block(group).L_SE = SE(L_SSA);
     bar_block(group).L_wave = L_total_wave;
     bar_block(group).L_CSD = L_total_CSD;
     
     stat_block.R(1:length(R_SSA),group) = R_SSA';
     bar_block(group).R_mean = mean(R_SSA);
     bar_block(group).R_SE = SE(R_SSA);
     bar_block(group).R_wave = R_total_wave;
     bar_block(group).R_CSD = R_total_CSD;  
     
     
     subplot(2,6,group*2-1)
     pcolor(time,ysize,flipud(L_total_CSD')), shading flat,colormap(flipud(hotcold))
     title([SpkInfo{group,1} ' Left'])
     caxis([-0.05 0.05])
     hold on
     plot(time,L_total_wave,'k')
     drawnow
     
     subplot(2,6,group*2)
     pcolor(time,ysize,flipud(R_total_CSD')),shading flat, colormap(flipud(hotcold))
     title([SpkInfo{group,1} ' Right'])
     caxis([-0.05 0.05])
     hold on
     plot(time, R_total_wave,'k')
     drawnow
     % end group
end
stat_block.L(stat_block.L == 0) = NaN;
stat_block.R(stat_block.R == 0) = NaN;

colorbar('Position',[0.45 0.1 0.1 0.25])
%%
[Lp,Ltbl,Lstats] = anova1(stat_block.L);
[Rp,Rtbl,Rstats] = anova1(stat_block.R);

Lc = multcompare(Lstats);
Rc = multcompare(Rstats);
%%
save('CSD Stats','bar_block','stat_block','Lc','Rc')
%%

% disp('Here we go..')
% tic
% [U,S,V] = svd(full_stack,'econ');
% toc
% figure
% subplot(2,3,1)
% mode1 = reshape(V(:,1),2501,10); 
% pcolor(flipud(mode1')), shading interp, colormap(flipud(jet))
% title ('Mode 1')
% subplot(2,3,2)
% mode2 = reshape(V(:,2),2501,10); 
% pcolor(flipud(mode2')), shading interp, colormap(flipud(jet))
% title('Mode 2')
% 
% subplot(2,3,3)
% mode3 = reshape(V(:,3),2501,10); 
% pcolor(flipud(mode3')), shading interp, colormap(flipud(jet))
% title('Mode 3')
% subplot(2,3,4)
% mode5 = reshape(V(:,5),2501,10); 
% pcolor(flipud(mode5')), shading interp, colormap(flipud(jet))
% title('Mode 5')
% 
% subplot(2,3,5)
% mode10 = reshape(V(:,10),2501,10); 
% pcolor(flipud(mode10')), shading interp, colormap(flipud(jet))
% title('Mode 10')
% 
% subplot(2,3,6)
% mode50 = reshape(V(:,50),2501,10); 
% pcolor(flipud(mode50')), shading interp, colormap(flipud(jet))
% title('Mode 50')
%         