cd('C:\Users\user\Documents\MATLAB\Stats\Power')
load('NormalizedPower.mat')
normState = 'Normalized';
%% Hypothesis 1: There is a difference between Stroke and control delta power
Control = NormalizedPower{1,2}.R - NormalizedPower{1,2}.L;
EESham = NormalizedPower{2,2}.R - NormalizedPower{2,2}.L;
MStrk = NormalizedPower{3,2}.R - NormalizedPower{3,2}.L;
WStrk = NormalizedPower{4,2}.R - NormalizedPower{4,2}.L;
EEStrk = NormalizedPower{6,2}.R - NormalizedPower{6,2}.L;
test = zeros(4,6);
for layer = 1:4
    for band = 1:6
        Stroke = [nonzeros(MStrk(:,band,layer)); nonzeros(WStrk(:,band,layer))];
        [~,p] = ttest2(nonzeros(Control(:,band,layer)),Stroke);
        test(layer,band) = p;
    end % band
end % layer

%% Build a linear model for time and see if it changes 
modelAccuracy = zeros(4,6);
for layer = 1:4
    for band = 1:6
        cLen = length(nonzeros(Control(:,band,layer)));
        wLen = length(nonzeros(WStrk(:,band,layer)));
        mLen = length(nonzeros(MStrk(:,band,layer)));
        data = [nonzeros(Control(:,band,layer)); nonzeros(WStrk(:,band,layer));nonzeros(MStrk(:,band,layer))];
        data(1:cLen,2) = 0;
        data(cLen+1:cLen+wLen,2) = 14;
        data(cLen+wLen+1:cLen+wLen+mLen,2) = 31;
        tbl = table(data(:,1),data(:,2),'VariableNames',{'Power','Time'});
        h1 = fitlm(tbl,'Power ~ 1 + Time');
        modelAccuracy(layer,band) = coefTest(h1);
        figure
        plot(h1)
        title([num2str(layer) ' ' num2str(band)])
    end % band 
end % layer