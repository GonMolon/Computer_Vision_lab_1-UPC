function [result, features] = histogram_classifier(im, model, normalizer)
    global SUBIMAGE_SIZE
    
    im_norm = normalizer(im);
    features.matching_subimages = 0;
    
    figure(2), imshow(im_norm), title('Current image (normalized)'), figure(1);
    
    total_blocks = 0;
    for i_from = 1 : SUBIMAGE_SIZE : size(im, 1) - SUBIMAGE_SIZE
        i_to = i_from + SUBIMAGE_SIZE;
        for j_from = 1 : SUBIMAGE_SIZE : size(im, 2) - SUBIMAGE_SIZE
            j_to = j_from + SUBIMAGE_SIZE;
            
            total_blocks = total_blocks + 1;
            
            sub_im = im_norm(i_from : i_to, j_from : j_to, :);
            subplot(2, 3, 6), imshow(sub_im), title('Current subimage');
            
            [red_hist, blue_hist] = get_histograms(sub_im);
            
            subplot(2, 3, 4), bar(red_hist), title('Current subimage - RED histogram');
            subplot(2, 3, 5), bar(blue_hist), title('Current subimage - BLUE histogram');
            
            red_diff = compare_histograms(red_hist, model(1, :));
            blue_diff = compare_histograms(blue_hist, model(2, :));
            diff = red_diff^2 + blue_diff^2;

            disp('---------------------------------');
            disp('Red diff:');
            disp(red_diff);
            disp('Blue diff:');
            disp(blue_diff);
            disp('Total diff:');
            disp(diff);
            
            if diff < 0.002
                features.matching_subimages = features.matching_subimages + 1;
                disp('Classified as Barcelona');
            end
            
            waitforbuttonpress
        end
    end
    
    features.score = features.matching_subimages/total_blocks;
    disp('Total matching subimages');
    disp(features.matching_subimages);
    disp('Score:');
    disp(features.score);
    
    %waitforbuttonpress
    
    result = 1;
    
end

