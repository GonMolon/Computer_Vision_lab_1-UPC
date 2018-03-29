function [h] = get_hsv_histogram(im)
    global N_BINS
    %H = histogram2(im(:, :, 1), im(:, :, 2), N_BINS, 'Normalization', 'probability', 'XBinLimits', [0, 1], 'YBinLimits', [0, 1]);
    h = histcounts2(im(:, :, 1), im(:, :, 2), N_BINS, 'Normalization', 'probability', 'XBinLimits', [0, 1], 'YBinLimits', [0, 1]);
    conv_matrix = ones(5) / 5 / 5;
    h = imfilter(double(h), conv_matrix);
    bar3(h);
end
