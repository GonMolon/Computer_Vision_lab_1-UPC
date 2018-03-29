function [diff] = comp_hist_bhattacharyya(hist1, hist2)
    diff = sum(sqrt(hist1) .* sqrt(hist2));
end