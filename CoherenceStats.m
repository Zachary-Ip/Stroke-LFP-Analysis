% Choose state to analyze
% High 1, Low 2, Full 3
TD = 3;
%%%%%%%%%%%%%%%%%%%%%%%%%
switch TD
    case 1
        name = 'HTD';
    case 2
        name = 'LTD';
    case 3
        name = 'Full';
end
load(['C:\Users\user\Documents\MATLAB\Coherence Data\' name])

Co(Co == 0) = NaN;

quick = nanmean(Co, 4);
quick = squeeze(quick);
test = heatmap(squeeze(quick(2,1,1,:,:)));
for iHem = 1:2
    for iBand = 1:4
        for iCompare = 1:6
            switch iCompare
                case 1
                    A = 1;
                    B = 2;
                    compare = 'Cortex-SLM';
                case 2
                    A = 1;
                    B = 3;
                    compare = 'Cortex-Pyr';
                case 3
                    A = 1;
                    B = 4;
                    compare = 'Cortex-Oriens';
                case 4
                    A = 2;
                    B = 3;
                    compare = 'SLM-Pyr';
                case 5
                    A = 2;
                    B = 4;
                    compare = 'SLM-Oriens';
                case 6
                    A = 3;
                    B = 4;
                    compare = 'Pyr-Oriens';
            end
            
            compareVector = [squeeze(Co(1, iBand, iHem, :, A, B))...
                             squeeze(Co(2, iBand, iHem, :, A, B))...
                             squeeze(Co(3, iBand, iHem, :, A, B))...
                             squeeze(Co(4, iBand, iHem, :, A, B))...
                             squeeze(Co(6, iBand, iHem, :, A, B))];
            compareNames = {'Control','EEC','1MS','2WS','EES'};
            
            [p,tbl,stats] = anova1(compareVector, compareNames,'off');
            mTbl = multcompare(stats,'CType','bonferroni');
            disp([num2str(iBand) ' ' num2str(iHem) ' ' compare]);
            disp(num2str(min(mTbl(:,6))))
            input('','s')
        end % iCompare
    end % iBand
end % iHem






