function [h] = get_hsv_histogram(im)
    global N_BINS
    h = histcounts2(im(:, :, 1), im(:, :, 2), N_BINS, 'Normalization', 'probability', 'XBinLimits', [0, 1], 'YBinLimits', [0, 1]);
%     h = circshift(h, -10, 1); % Because the angle is a circular value, so we bring the red and blue values together    
end
