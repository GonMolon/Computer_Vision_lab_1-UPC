function [model] = create_model(normalizer)
    im = imread('data/barcelona/05.jpg');
    
    im_norm = normalizer(im);
    
    model = hist(im_norm);
end

