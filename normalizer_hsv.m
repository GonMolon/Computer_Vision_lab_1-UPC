function [im_norm] = normalizer_hsv(im)
    im_norm = rgb2hsv(im);
    im_norm(:, :, 3) = 0.5;
end

