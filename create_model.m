function [model] = create_model(normalizer)
    im = imread('data/barcelona/05.jpg');
    im = im(250:end, 50:210, :);
    model = normalizer(im);
end

