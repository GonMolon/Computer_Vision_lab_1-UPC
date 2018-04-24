function [result, features] = classify(im, models)
    global SUBIMAGE_SIZE
    global VERBOSE
    global THRESHOLD
    global FIG_SUBIMAGE
    global FIG_HIST
    
    features = [struct('min_diff', {}, 'matching_subimages', {}, 'sum_diff', {})];
    for k = 1 : length(models)
        features(k).min_diff = -1;
        features(k).matching_subimages = 0;
        features(k).sum_diff = 0;
    end
    
    total_blocks = 0;
    for i_from = 1 : SUBIMAGE_SIZE/2 : size (im, 1) - SUBIMAGE_SIZE
        i_to = i_from + SUBIMAGE_SIZE;
        for j_from = 1 : SUBIMAGE_SIZE/2 : size(im, 2) - SUBIMAGE_SIZE
            j_to = j_from + SUBIMAGE_SIZE;
            
            total_blocks = total_blocks + 1;
            
            sub_im = im(i_from : i_to, j_from : j_to, :);
            if VERBOSE
                figure(FIG_SUBIMAGE), subplot(2, 1, 2), imshow(sub_im), title('Current subimage');
            end
            
            histogram = get_hsv_histogram(sub_im);
            for k = 1 : length(models)
                model = models(k);
                if VERBOSE
                    figure(FIG_SUBIMAGE), subplot(2, 1, 1), imshow(model.im), title('Model');
                end

                diff = comp_im_hsv(histogram, model);

                if VERBOSE
                    disp('Diff:');
                    disp(diff);
                end
                
                if features(k).min_diff == -1 || diff < features(k).min_diff
                    features(k).min_diff = diff;
                end
                
                if diff < THRESHOLD
                    features(k).matching_subimages = features(k).matching_subimages + 1;
                    features(k).sum_diff = features(k).sum_diff + diff;
                    if VERBOSE
                        disp('Subimage classified as team');
                        disp(k);
                    end
                end
                
                if VERBOSE
                    figure(FIG_HIST);
                    while waitforbuttonpress == 0 end
                    disp('---------------------------------');
                end
            end   
        end
    end

    min_diff = -1;
    result = 0;
    for k = 1 : length(models)
        if features(k).matching_subimages > 0
            final_diff = features(k).sum_diff / features(k).matching_subimages^2;
            final_diff = final_diff - (THRESHOLD - features(k).min_diff);
            if min_diff == -1 || final_diff < min_diff
                result = k;
                min_diff = final_diff;
            end
        end
    end
    
    if VERBOSE
        disp('===================================================');
        disp('Result');
        disp(result);
        if result == 0
            disp('No matching subimages');
        else
            disp('Total matching subimages');
            disp(features(result).matching_subimages);
            disp('Out of:');
            disp(total_blocks);
            disp('Min_diff:');
            disp(features(result).min_diff);
            disp('Final_diff');
            disp(min_diff);
        end
        disp('===================================================');
    end
end

