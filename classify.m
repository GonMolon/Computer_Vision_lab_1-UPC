function [result, features] = classify(im_norm, models)
    global SUBIMAGE_SIZE
    global VERBOSE
    global THRESHOLD
    global FIG_SUBIMAGE
    
    features = [struct('min_diff', {}, 'matching_subimages', {})];
    for k = 1 : length(models)
        features(k).min_diff = -1;
        features(k).matching_subimages = 0;
    end
    
    total_blocks = 0;
    for i_from = 1 : SUBIMAGE_SIZE : size (im_norm, 1) - SUBIMAGE_SIZE
        i_to = i_from + SUBIMAGE_SIZE;
        for j_from = 1 : SUBIMAGE_SIZE : size(im_norm, 2) - SUBIMAGE_SIZE
            j_to = j_from + SUBIMAGE_SIZE;
            
            total_blocks = total_blocks + 1;
            
            sub_im = im_norm(i_from : i_to, j_from : j_to, :);
            figure(FIG_SUBIMAGE), subplot(2, 1, 2), imshow(hsv2rgb(sub_im)), title('Current subimage');
            
            histogram = get_hsv_histogram(sub_im);
            for k = 1 : length(models)
                model = models(k);
                figure(FIG_SUBIMAGE), subplot(2, 1, 1), imshow(hsv2rgb(model.im_norm)), title('Model');

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
                    if VERBOSE
                        disp('Subimage classified as Barcelona');
                    end
                end
                
                if VERBOSE
                    figure(FIG_SUBIMAGE);
                    waitforbuttonpress
                    disp('---------------------------------');
                end
                
                % result = features.matching_subimages > 0;
                % if VERBOSE || true
                %     disp('===================================================');
                %     disp('Total matching subimages');
                %     disp(features.matching_subimages);
                %     disp('Out of:');
                %     disp(total_blocks);
                %     disp('Min_diff:');
                %     disp(features.min_diff);
                %     if result
                %         disp('Image classified as Barcelona');
                %     else
                %         disp('Image not classified as Barcelona');
                %     end
                %     disp('===================================================');
                % end
            end     
        end
    end
end

