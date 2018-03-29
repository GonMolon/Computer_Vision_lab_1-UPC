function [red_hist, green_hist, blue_hist] = get_rgb_histograms(im)
    global N_BINS
    red_hist = histcounts(im(:, :, 1), N_BINS, 'Normalization', 'probability');
    green_hist = histcounts(im(:, :, 2), N_BINS, 'Normalization', 'probability');
    blue_hist = histcounts(im(:, :, 3), N_BINS, 'Normalization', 'probability');
end
