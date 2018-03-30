function [h] = get_hsv_histogram(im)
    global N_BINS
    h = histcounts2(im(:, :, 1), im(:, :, 2), N_BINS, 'Normalization', 'probability', 'XBinLimits', [0, 1], 'YBinLimits', [0, 1]);
    h = circshift(h, -10, 1); % Because the angle is a circular value, so we bring the red and lbue values together
    h = h(20:55, 25:60); % Cutting the matrix to focus in the area we mind
    h = 10 * h;
    conv_matrix = ones(5, 5);
    conv_matrix = conv_matrix ./ sum(conv_matrix);
    h = imfilter(h, conv_matrix, 'circular', 'replicate');
end
