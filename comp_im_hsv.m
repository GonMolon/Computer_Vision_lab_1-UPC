function [diff] = comp_im_hsv(im, model)
    global VERBOSE
    global fig_hist
    global histogram_comparator
        
    global model_hist
    figure(fig_hist);
    if isempty(model_hist)
        model = rgb2hsv(model);
        subplot(2, 1, 1), model_hist = get_hsv_histogram(model);
    end
        
    im = rgb2hsv(im);
    subplot(2, 1, 2), im_hist = get_hsv_histogram(im);
    
    diff = histogram_comparator(model_hist, im_hist);
end

