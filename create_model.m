function [model] = create_model(normalizer)
    im = imread('data/barcelona/05.jpg');
    
    im_norm = normalizer(im);
    
    figure, imshow(im);
    
    [red_hist, blue_hist] = get_histograms(im_norm);
    
    figure, bar(red_hist), title('red histogram model')
    figure, bar(blue_hist), title('blue histogram model')
        
    model = [red_hist, blue_hist];
end

