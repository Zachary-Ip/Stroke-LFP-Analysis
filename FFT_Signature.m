clear all
Fs = 1250;
load('SpkInfo.mat');
cd('C:\Users\ipzac\Documents\Converted')
window = 80000;
W = 0.5;
figure
for group = [1 3 4]% [1:4 6]
    for layer = 1 % :4
        for i = 1: length(dir([SpkInfo{group,1} '*']))
            if exist(['C:\Users\ipzac\Documents\Converted\' SpkInfo{group,1} '_' num2str(i) '\concatenatedLFP.mat'],'file') == 2 && ...
                    exist(['C:\Users\ipzac\Documents\Converted\' SpkInfo{group,1} '_' num2str(i) '\cREM.mat'],'file') == 2
                load(['C:\Users\ipzac\Documents\Converted\' SpkInfo{group,1} '_' num2str(i) '\concatenatedLFP.mat']);
                load(['C:\Users\ipzac\Documents\Converted\' SpkInfo{group,1} '_' num2str(i) '\cREM.mat']);
            else
                disp('Missing LFP or REM file')
                continue
            end
            if isempty(cREM.R.start) || isempty(cREM.R.end)
                disp('Missing REM Start or End Times for Right Side')
                continue
            end
            if isempty(cREM.L.start) || isempty(cREM.L.end)
                disp('Missing REM Start or End Times for Left Side')
                continue
            end
            if isempty(SpkInfo{group,2}(i).L_chn{3}) || isempty(SpkInfo{group,2}(i).R_chn{3})
                disp('Missing SpkInfo')
                continue
            end
            
            Pright = cLFP(:, SpkInfo{1,2}(6).R_chn{layer}(1));
            Pleft = cLFP(:, SpkInfo{1,2}(6).L_chn{layer}(1));
            
            right = (Pright - mean(Pright) /sqrt(length(Pright)));
            left = (Pleft - mean(Pleft) / sqrt(length(Pleft)));
            
            HTD_RIdx = [];
            LTD_RIdx = [];
            HTD_LIdx = [];
            LTD_LIdx = [];
            % LEFT
            for iRem = 1:length(cREM.L.start)
                HTD_LIdx = [HTD_LIdx (round(cREM.L.start(iRem)*Fs)):(round(cREM.L.end(iRem)*Fs))];
            end
            LowLeftStart = cREM.L.end(1:end-1);
            LowLeftEnd = cREM.L.start(2:end);
            
            for iRem = 1:length(LowLeftStart)
                LTD_LIdx = [LTD_LIdx (round(LowLeftStart(iRem)*Fs)):(round(LowLeftEnd(iRem)*Fs))];
            end
            
            % RIGHT
            for iRem = 1:length(cREM.R.start)
                HTD_RIdx = [HTD_RIdx (round(cREM.R.start(iRem)*Fs)):(round(cREM.R.end(iRem)*Fs))];
            end
            LowRightStart = cREM.R.end(1:end-1);
            LowRightEnd = cREM.R.start(2:end);
            
            for iRem = 1:length(LowRightStart)
                LTD_RIdx = [LTD_RIdx (round(LowRightStart(iRem)*Fs)):(round(LowRightEnd(iRem)*Fs))];
            end
            
            
            
            
            rTheta = BPfilter(right, 1250, 0.1, 12);
            lTheta = BPfilter(left, 1250, 0.1,12);
            
            rHTD = rTheta(HTD_RIdx);
            lHTD = lTheta(HTD_LIdx);
            
            rLTD = rTheta(LTD_RIdx);
            lLTD = lTheta(LTD_LIdx);
            
            T = rHTD
            
            
            rH_Spec = fftshift(fft(rHTD));
            lH_Spec = fftshift(fft(lHTD));
            
            rL_Spec = fftshift(fft(rLTD));
            lL_Spec = fftshift(fft(lLTD));
            
            rHdF = Fs/length(rHTD);
            lHdF = Fs/length(lHTD);
            
            rLdF = Fs/length(rLTD);
            lLdF = Fs/length(lLTD);
            
            rHf = -Fs/2:rHdF:Fs/2-rHdF;
            lHf = -Fs/2:lHdF:Fs/2-lHdF;
            
            rLf = -Fs/2:rLdF:Fs/2-rLdF;
            lLf = -Fs/2:lLdF:Fs/2-lLdF;
        end
        [~,rz] = min(abs(rHf));
        [~,lz] = min(abs(lHf));
        
        hold on
        counter = 0;
        
        if group == 1
            subplot(3,2,1)
            plot(rHf(rz:rz+80000), abs(rH_Spec(rz:rz+80000)),'.','k')
            xlim([2 7])
            subplot(3,2,2)
            plot(lHf(lz:lz+80000), abs(lH_Spec(lz:lz+80000)),'.','k')
            xlim([2 7])
        elseif group == 3
            subplot(3,2,3)
            scatter(rHf(rz:rz+80000), abs(rH_Spec(rz:rz+80000)),'.','r')
            xlim([2 7])
            subplot(3,2,4)
            scatter(lHf(lz:lz+80000), abs(lH_Spec(lz:lz+80000)),'.','r')
            xlim([2 7])
        else 
            subplot(3,2,5)
            scatter(rHf(rz:rz+80000), abs(rH_Spec(rz:rz+80000)),'.','b')
            xlim([2 7])
            subplot(3,2,6)
            scatter(lHf(lz:lz+80000), abs(lH_Spec(lz:lz+80000)),'.','b')
            xlim([2 7])
        end
        clear vars
    end
end


disp('Done')