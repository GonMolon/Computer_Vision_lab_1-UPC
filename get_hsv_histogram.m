function [h] = get_hsv_histogram(im)
    global N_BINS
    im_hsv = rgb2hsv(im);
    im_gray = rgb2gray(im);
    for i = 1 : size(im_hsv, 1)
        for j = 1 : size(im_hsv, 2)
            if im_hsv(i, j, 3) < 0.2
                im_hsv(i, j, 1) = 0.75;
                im_hsv(i, j, 2) = -0.5;
            elseif im_gray(i, j)/255 > 0.9
                im_hsv(i, j, 1) = 0.25;
                im_hsv(i, j, 2) = -0.5;
            end
        end
    end
    h = histcounts2(im_hsv(:, :, 1), im_hsv(:, :, 2), N_BINS, 'Normalization', 'probability', 'XBinLimits', [0, 1], 'YBinLimits', [-0.5, 1]);
end
