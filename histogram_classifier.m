function [result, features] = histogram_classifier(im, model, normalizer, comp_hist)
    global SUBIMAGE_SIZE
    global VERBOSE
    global THRESHOLD
    
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
            subplot(2, 4, 8), imshow(sub_im), title('Current subimage');
            
            [red_hist, green_hist, blue_hist] = get_rgb_histograms(sub_im);
            
            subplot(2, 4, 5), bar(red_hist), title('Current subimage - RED histogram');
            subplot(2, 4, 6), bar(green_hist), title('Current subimage - GREEN histogram');
            subplot(2, 4, 7), bar(blue_hist), title('Current subimage - BLUE histogram');
            
            red_diff = comp_hist(red_hist, model(1, :));
            green_diff = comp_hist(green_hist, model(2, :));
            blue_diff = comp_hist(blue_hist, model(3, :));
            diff = red_diff^2 + green_diff^2 + blue_diff^2;

            if VERBOSE
                disp('---------------------------------');
                disp('Red diff:');
                disp(red_diff);
                disp('Green diff:');
                disp(green_diff);
                disp('Blue diff:');
                disp(blue_diff);
                disp('Total diff:');
                disp(diff);
            end
            
            if diff < THRESHOLD
                features.matching_subimages = features.matching_subimages + 1;
                if VERBOSE
                    disp('Subimage classified as Barcelona');
                end
            end
            
            if VERBOSE
                waitforbuttonpress
            end
        end
    end
    
    features.score = features.matching_subimages/total_blocks;
    
    %result = features.score > 0.08;
    result = features.matching_subimages > 0;
    if VERBOSE
        disp('===================================================');
        disp('Total matching subimages');
        disp(features.matching_subimages);
        disp('Out of:');
        disp(total_blocks);
        disp('Score:');
        disp(features.score);
        if result
            disp('Image classified as Barcelona');
        else
            disp('Image not classified as Barcelona');
        end
        disp('===================================================');
    end
            
end

