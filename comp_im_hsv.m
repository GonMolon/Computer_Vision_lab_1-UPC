function [diff] = comp_im_hsv(histogram, model)
    global VERBOSE
    global FIG_HIST

    if VERBOSE
        figure(FIG_HIST);
        subplot(2, 1, 1), bar3(model.histogram);
        subplot(2, 1, 2), bar3(histogram);
    end
    
    red_count = sum(sum(histogram(25:35, 20:60)));
    blue_count = sum(sum(histogram(45:52, 20:60)));
    
    diff_penalization = 8*(red_count - blue_count)^2;
    proportion_penalization = 1 - (red_count + blue_count);
    
    diff = diff_penalization + proportion_penalization;
    
    if VERBOSE
        disp('Diff penalization:');
        disp(diff_penalization / diff);
        disp('Proportion_penalization');
        disp(proportion_penalization / diff);
    end
end

