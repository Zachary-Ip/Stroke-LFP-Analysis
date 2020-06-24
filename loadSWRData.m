% Shivalika Chavan
% July 31, 2019
% individual - format of name from LFP (e.g. 'Control_10')
% returns SWR structure 
% get start and end indices from structure using the two line below
% SWR_starts = SWR.SWRevents(:, 1);
% SWR_ends = SWR.SWRevents(:, 2);
function SWR = loadSWRData(individualName)

u = (strfind(individualName,'_'));
individual = [individualName(1:u) 'L' individualName(u+1:end)];

computerType = computer;
switch computerType
    case 'PCWIN64'
        try SWR = load(['C:\Users\schavan\Documents\data_analysis_summer\Sharp Wave Ripple Events\3SD\' individual]);
        catch
            disp(['No SWR file found for ' individual '.']);
            SWR = [];
        end
    case 'MACI64'
        try SWR = load(['/Users/shivalikachavan/Documents/Lab/data_analysis_summer/SWR Data/3SD/' individual]);
            catch
            disp(['No SWR file found for ' individual '.']);
            SWR = [];
        end
end

end