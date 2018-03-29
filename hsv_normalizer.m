function [im_norm] = hsv_normalizer(im)
    hsv = rgb2hsv(im);
    hsv(:, :, 3) = 0.5;
    im_norm = hsv2rgb(hsv);
end

