function [meanT, minT] = DE_TinletFromTempPDF(temp, n_bins)

% Figure pops-up due to "histogram"
%     % pdf
%     h = histogram(temp, n_bins);
%     binCenters = h.BinEdges; %+ (h.BinWidth/2);
%     p = histcounts(temp, n_bins, 'Normalization', 'pdf');
% 
%     % mean temperature
%     [~, idx] = max(p./trapz(p));
%     meanT = binCenters(idx);

    % pdf
    [binCounts, binEdges] = histcounts(temp, n_bins, ...
        'Normalization', 'pdf');
    
    % bin centers
    binCenters = binEdges(1:end-1); % + diff(binEdges) / 2;
    
    % mean temperature
    [~, idx] = max(binCounts ./ trapz(binCounts));
    meanT = binCenters(idx);
    
    % min temperature
    [minT, ~] = min(temp);

end
