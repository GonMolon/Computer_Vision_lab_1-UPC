function [diff] = comp_hist_bhattacharyya(hist1, hist2)
    hist1 = reshape(hist1, 1, []);
    hist2 = reshape(hist2, 1, []);
    diff = sum(sqrt(hist1) .* sqrt(hist2));
end