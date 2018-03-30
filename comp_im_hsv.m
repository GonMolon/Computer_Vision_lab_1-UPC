function [diff] = comp_im_hsv(im, model)
    global THRESHOLD
    global VERBOSE
    global fig_hist
    global fig_subimage;
    global histogram_comparator
        
    global model_hist
    figure(fig_hist);
    if isempty(model_hist)
        model = rgb2hsv(model);
        model_hist = get_hsv_histogram(model);
        subplot(2, 1, 1), bar3(model_hist);
    end
    
    THRESHOLD = 0.5;
    
    im = rgb2hsv(im);
    im_hist = get_hsv_histogram(im);
    subplot(2, 1, 2), bar3(im_hist);
    
    red_count = sum(sum(im_hist(25:35, 20:60)));
    blue_count = sum(sum(im_hist(45:52, 20:60)));
    
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

