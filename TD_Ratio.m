load('SpkInfo.mat')
for group = [1:4 6]
    %% 1.Load the right and left side signals
    %load H/L TD indexes
    for animal = 1: length(SpkInfo{group,2})
        REM = ['C:\Users\user\Documents\MATLAB\Data' filesep SpkInfo{group,1} '_' num2str(animal) filesep 'cREM.mat'];
        try
            load(REM);
        catch
            disp('Missing REM File')
            continue
        end
         if isempty(cREM.R.start) || isempty(cREM.R.end)
            disp('Missing REM Start or End Times for Right Side')
            cd ..
            continue
        end
        if isempty(cREM.L.start) || isempty(cREM.L.end)
            disp('Missing REM Start or End Times for Left Side')
            cd ..
            continue
        end
        [results.r(animal,group)] = analyze(cREM.R);
        [results.l(animal,group)] = analyze(cREM.L); 
    end % animal
end % group

results.r(results.r == 0) = NaN;
results.l(results.l == 0) = NaN;

group = {'Ctrl','EEC','1MS','2WS','null','EES'};
[~,~,rs] = anova1(results.r, group,'off');
[~,~,ls] = anova1(results.l, group,'off');

[rC,rM,~,rN] = multcompare(rs,'CType','bonferroni');
[lC,lM,~,lN] = multcompare(ls,'CType','bonferroni');

rStat = [rC(:,1) rC(:,2) rC(:,6)];
figure
BarErrSig(rM(:,1),rM(:,2),rStat);
title('Contralesional')

lStat = [lC(:,1) lC(:,2) lC(:,6)];
figure
BarErrSig(lM(:,1),lM(:,2),lStat);
title('Ipsilesional')
%%
save('C:\Users\user\Documents\MATLAB\Stats\State\Ratio.mat','rM','rStat','lM','lStat');





function [perc] = analyze(times)
htd = 0;
ltd = 0;
for iT = 1:length(times.start)
    htd = htd + (times.end(iT)-times.start(iT));
    if iT == 1
        ltd = ltd + times.start(iT);
    else
        ltd = ltd + times.start(iT) - times.end(iT-1);
    end
end
perc = htd/(htd+ltd);

end

function BarErrSig(vals, ers, p)
load('Colors.mat');
[b, e] = barwitherr(ers,vals);
box off
b.FaceColor = 'flat';
b.CData(1,:) = RGB.mlBlue;
b.CData(2,:) = RGB.mlPurple;
b.CData(3,:) = RGB.mlYellow;
b.CData(4,:) = RGB.mlOrange;
b.CData(5,:) = RGB.mlRed;

for i = 1:length(p)
    if p(i,3) <= 0.05
        sigstar2([p(i,1) p(i,2)],p(i,3));
    end % if
end % for

end