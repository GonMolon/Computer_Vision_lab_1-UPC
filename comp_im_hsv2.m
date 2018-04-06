function [diff] = comp_im_hsv2(im, model)
    global VERBOSE
    global fig_hist
    global fig_subimage;
    global histogram_comparator
    
    conv_matrix = ones(5, 5);
    conv_matrix = conv_matrix ./ sum(conv_matrix);
        
    global model_hist
    global model_hist_shifted
    figure(fig_hist);
    if isempty(model_hist)
        model = rgb2hsv(model);
        model_hist = get_hsv_histogram(model);
        model_hist = imfilter(model_hist, conv_matrix, 'circular', 'replicate');
        subplot(2, 1, 1), bar3(model_hist);
        model_hist_shifted = cell(1, 0);
        for k = -10 : 5 : 10
            model_hist_shifted{end + 1} = circshift(model_hist, k, 2);
        end
    end
        
    im = rgb2hsv(im);
    im_hist = get_hsv_histogram(im);
    im_hist = imfilter(im_hist, conv_matrix, 'circular', 'replicate');
    subplot(2, 1, 2), bar3(im_hist);
    
    diff = -1;
    for i = 1 : length(model_hist_shifted)
        m_hist = model_hist_shifted{i};
        figure(fig_hist), subplot(2, 1, 1), bar3(m_hist);
        act_diff = histogram_comparator(m_hist, im_hist);
        if VERBOSE
            disp('Act_diff:');
            disp(act_diff);
            figure(fig_subimage);
            waitforbuttonpress
        end
        if diff == -1 || act_diff < diff
            diff = act_diff;
        end
    end
end