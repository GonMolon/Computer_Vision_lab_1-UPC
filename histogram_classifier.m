function [result, features] = histogram_classifier(im, model, normalizer)
    global SUBIMAGE_SIZE
    
    im_norm = normalizer(im);
    features.matching_subimages = 0;
    
    figure, imshow(im_norm);
    
    for i_from = 1 : SUBIMAGE_SIZE : size(im, 1) - SUBIMAGE_SIZE
        i_to = i_from + SUBIMAGE_SIZE;
        for j_from = 1 : SUBIMAGE_SIZE : size(im, 2) - SUBIMAGE_SIZE
            j_to = j_from + SUBIMAGE_SIZE;
            
            sub_im = im_norm(i_from : i_to, j_from : j_to, :);
            imshow(sub_im);
            
            [red_hist, blue_hist] = get_histograms(sub_im);
            red_diff = compare_histograms(red_hist, model(1, :));
            blue_diff = compare_histograms(blue_hist, model(2, :));
            
            if red_diff < 0.02 && blue_diff < 0.02
                features.matching_subimages = features.matching_subimages + 1;
            end
        end
    end
    
    features.matching_subimages
    waitforbuttonpress
    
    result = 1;
    
end

