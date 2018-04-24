function [diff] = comp_im_hsv(histogram, model)
    global VERBOSE
    global FIG_HIST

    regions_lib = hsv_regions();
    if VERBOSE
        figure(FIG_HIST);
        subplot(2, 1, 1), regions_lib.show_regions(model.regions, model.histogram);
        subplot(2, 1, 2), bar3(histogram);
    end
    
    diff = 0;
    for region = model.regions
        hist_sum = regions_lib.get_region_sum(region, histogram);
        model_sum = region.sum;
        diff = diff + (model_sum - hist_sum)^2;
    end
end

