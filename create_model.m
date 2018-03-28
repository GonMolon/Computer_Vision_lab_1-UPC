function [model] = create_model(normalizer)
    im = imread('data/barcelona/05.jpg');
    im = im(250:end, 50:210, :);
    
    im_norm = normalizer(im);
    subplot(2, 3, 3), imshow(im_norm), title('Model image (normalized)');

    imshow(im_norm);
        
    [red_hist, blue_hist] = get_histograms(im_norm);
    
    subplot(2, 3, 1), bar(red_hist), title('MODEL - red histogram')
    subplot(2, 3, 2), bar(blue_hist), title('MODEL - blue histogram')
        
    model = [red_hist; blue_hist];
end

