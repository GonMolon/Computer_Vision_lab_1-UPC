function [red_hist, blue_hist] = get_histograms(im)
    global BIN_SIZE
    red_hist = histcounts(im(:, :, 1), 255/BIN_SIZE, 'Normalization', 'probability');
    blue_hist = histcounts(im(:, :, 2), 255/BIN_SIZE, 'Normalization', 'probability');
end
