function [model] = create_model(normalizer, BIN_SIZE)
    im = imread('data/barcelona/05.jpg');
    
    im_norm = normalizer(im);
    
    figure, imshow(im);
    
    red_histogram = histcounts(im_norm(:, :, 1), 255/BIN_SIZE, 'Normalization', 'probability');
    figure, bar(red_histogram), title('red histogram model')

    blue_histogram = histcounts(im_norm(:, :, 2), 255/BIN_SIZE, 'Normalization', 'probability');
    figure, bar(blue_histogram), title('blue histogram model')
    
    model = [red_histogram, blue_histogram];
end

