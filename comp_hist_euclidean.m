function [diff] = comp_hist_euclidean(hist1, hist2)
    diff = 0;
    for i = [hist1; hist2]
        diff = diff + (i(1) - i(2))^2;
    end
end

