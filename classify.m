function [result, features] = classify(im_norm, model, image_comparator)
    global SUBIMAGE_SIZE
    global VERBOSE
    global THRESHOLD
    global fig_subimage
    
    features.matching_subimages = 0;
    features.min_diff = -1;
    
    total_blocks = 0;
    
    for i_from = 1 : SUBIMAGE_SIZE : size (im_norm, 1) - SUBIMAGE_SIZE
        i_to = i_from + SUBIMAGE_SIZE;
        for j_from = 1 : SUBIMAGE_SIZE : size(im_norm, 2) - SUBIMAGE_SIZE
            j_to = j_from + SUBIMAGE_SIZE;
            
            total_blocks = total_blocks + 1;
            
            sub_im = im_norm(i_from : i_to, j_from : j_to, :);
            figure(fig_subimage), subplot(2, 1, 2), imshow(sub_im), title('Current subimage');
            
            diff = image_comparator(sub_im, model);

            if VERBOSE
                disp('Total diff:');
                disp(diff);
            end
            
            if features.min_diff == -1 || diff < features.min_diff
                features.min_diff = diff;
            end
            
            if diff < THRESHOLD
                features.matching_subimages = features.matching_subimages + 1;
                if VERBOSE
                    disp('Subimage classified as Barcelona');
                end
            end
            
            if VERBOSE
                figure(fig_subimage);
                waitforbuttonpress
                disp('---------------------------------');
            end
        end
    end
        
    result = features.matching_subimages > 0;
    if VERBOSE || true
        disp('===================================================');
        disp('Total matching subimages');
        disp(features.matching_subimages);
        disp('Out of:');
        disp(total_blocks);
        disp('Min_diff:');
        disp(features.min_diff);
        if result
            disp('Image classified as Barcelona');
        else
            disp('Image not classified as Barcelona');
        end
        disp('===================================================');
    end
            
end

