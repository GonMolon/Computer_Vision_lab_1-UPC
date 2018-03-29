function [diff] = comp_hist_euclidean(hist1, hist2)
    hist1 = reshape(hist1, 1, []);
    hist2 = reshape(hist2, 1, []);
    diff = sum((hist1 - hist2).^2);
end

