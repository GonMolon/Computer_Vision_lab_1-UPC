function [diff] = comp_im_hsv(histogram, model)
    global VERBOSE
    global FIG_HIST

    regions_lib = hsv_regions();
    if VERBOSE
        figure(FIG_HIST);
        subplot(2, 1, 1), regions_lib.show_regions(model.regions, model.histogram);
        subplot(2, 1, 2), bar3(histogram);
    end
    
    if model.team_id == 2
        blue_count = sum(sum(histogram(35:45, 30:60)));
        red_count = sum(sum(histogram(55:60, 30:60)));
        red_count = red_count + sum(sum(histogram(1:3, 30:60)));
        diff_penalization = 8*(red_count - blue_count)^2;
        proportion_penalization = 1 - (red_count + blue_count);

        diff = diff_penalization + proportion_penalization;
        if diff < 0.5
            diff = 0;
            return
        end
    end
    
    diff = 0;
    for region = model.regions
        hist_sum = regions_lib.get_region_sum(region, histogram);
        model_sum = region.sum;
        diff = diff + (model_sum - hist_sum)^2;
    end
end

