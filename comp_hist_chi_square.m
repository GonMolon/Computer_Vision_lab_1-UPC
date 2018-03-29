function [diff] = comp_hist_chi_square(hist1, hist2)
    diff = sum((hist1-hist2)^2 / (hist1 + hist2));
end