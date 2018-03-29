function [red_hist, green_hist, blue_hist] = get_rgb_histograms(im)
    global BIN_SIZE
    red_hist = histcounts(im(:, :, 1), 255/BIN_SIZE, 'Normalization', 'probability');
    green_hist = histcounts(im(:, :, 2), 255/BIN_SIZE, 'Normalization', 'probability');
    blue_hist = histcounts(im(:, :, 3), 255/BIN_SIZE, 'Normalization', 'probability');
end
