function [result, features] = classify(im_norm, model, image_comparator)
    global SUBIMAGE_SIZE
    global VERBOSE
    global THRESHOLD
    global fig_subimage
    global fig_hist
    
    features.matching_subimages = 0;
    
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

