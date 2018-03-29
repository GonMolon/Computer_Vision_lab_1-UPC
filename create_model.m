function [model] = create_model(normalizer)
    im = imread('data/barcelona/05.jpg');
    im = im(250:end, 50:210, :);
    
    im_norm = normalizer(im);
    subplot(2, 4, 4), imshow(im_norm), title('Model image (normalized)');

    imshow(im_norm);
        
    [red_hist, green_hist, blue_hist] = get_rgb_histograms(im_norm);
    
    subplot(2, 4, 1), bar(red_hist), title('MODEL - red histogram')
    subplot(2, 4, 2), bar(green_hist), title('MODEL - green histogram')
    subplot(2, 4, 3), bar(blue_hist), title('MODEL - blue histogram')
        
    model = [red_hist; green_hist; blue_hist];
end

