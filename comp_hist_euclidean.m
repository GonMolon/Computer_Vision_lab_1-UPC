function [diff] = comp_hist_euclidean(hist1, hist2)
    diff = sum((hist1 - hist2).^2);
end

