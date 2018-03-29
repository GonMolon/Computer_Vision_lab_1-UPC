function [im_norm] = normalizer_rgb(im)
    r = im(:, :, 1);
    g = im(:, :, 2);
    b = im(:, :, 3);
    r_norm = double(r) ./ double(r+g+b);
    r_no_light = r_norm * 255;

    g_norm = double(g) ./ double(r+g+b);
    g_no_light = g_norm * 255;
    
    b_norm = double(b) ./ double(r+g+b);
    b_no_light = b_norm * 255;

    im_norm = cat(3, r_no_light, g_no_light, b_no_light);
    im_norm = uint8(im_norm);
end

