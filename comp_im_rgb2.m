function [diff] = comp_im_rgb(im, model)
    global VERBOSE
    global fig_hist
    global histogram_comparator
    
    global model_red_hist
    global model_green_hist
    global model_blue_hist

    figure(fig_hist);
    if isempty(model_red_hist)
        [model_red_hist, model_green_hist, model_blue_hist] = get_rgb_histograms(model);
        subplot(2, 3, 1), bar(model_red_hist), title('Model - RED histogram');
        subplot(2, 3, 2), bar(model_green_hist), title('Model - GREEN histogram');
        subplot(2, 3, 3), bar(model_blue_hist), title('Model - BLUE histogram');
    end
    [im_red_hist, im_green_hist, im_blue_hist] = get_rgb_histograms(im);  
    subplot(2, 3, 4), bar(im_red_hist), title('Current subimage - RED histogram');
    subplot(2, 3, 5), bar(im_green_hist), title('Current subimage - GREEN histogram');
    subplot(2, 3, 6), bar(im_blue_hist), title('Current subimage - BLUE histogram');

    red_diff = histogram_comparator(im_red_hist, model_red_hist);
    green_diff = histogram_comparator(im_green_hist, model_green_hist);
    blue_diff = histogram_comparator(im_blue_hist, model_blue_hist);
    diff = red_diff^2 + green_diff^2 + blue_diff^2;
    
    if VERBOSE
        disp('Red diff:');
        disp(red_diff);
        disp('Green diff:');
        disp(green_diff);
        disp('Blue diff:');
        disp(blue_diff);
    end
end

