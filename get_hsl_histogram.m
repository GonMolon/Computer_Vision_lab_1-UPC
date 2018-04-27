function [h] = get_hsl_histogram(im)
    global N_BINS
    im_hsl = colorspace(['HSL', '<-RGB'], im);
    im_hsl(:, :, 1) = im_hsl(:, :, 1)/360;
    for i = 1 : size(im_hsl, 1)
        for j = 1 : size(im_hsl, 2)
            if im_hsl(i, j, 3) < 0.2
                im_hsl(i, j, 1) = 0.7 + im_hsl(i, j, 1)*0.1;
                im_hsl(i, j, 2) = -0.5;
            elseif im_hsl(i, j, 3) > 0.7
                im_hsl(i, j, 1) = 0.2 + im_hsl(i, j, 1)*0.1;
                im_hsl(i, j, 2) = -0.5;
            end
        end
    end
    h = histcounts2(im_hsl(:, :, 1), im_hsl(:, :, 2), N_BINS, 'Normalization', 'probability', 'XBinLimits', [0, 1], 'YBinLimits', [-0.5, 1]);
end
