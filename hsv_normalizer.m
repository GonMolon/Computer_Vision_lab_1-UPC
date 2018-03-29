function [im_norm] = hsv_normalizer(im)
    hsv = rgb2hsv(im);
%     for i = 1 : size(hsv, 1)
%         for j = 1 : size(hsv, 2)
%             if hsv(i, j, 3) < 0.1
%                 hsv(i, j, 2) = 0;
%                 hsv(i, j, 3) = 0;
%             else
%                 hsv(i, j, 3) = 0.5;
%             end
%         end
%     end
    hsv(:, :, 3) = 0.5;
    im_norm = uint8(hsv2rgb(hsv) * 255);
end

