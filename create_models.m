function [models] = create_models()
    global FIG_SUBIMAGE

    images = [struct('im', {}, 'name', {})];

    im = imread('data/acmilan/22.jpg');
    images(end + 1).im = im(75:170, 50:110, :);
    images(end).name = '22.jpg';

    im = imread('data/barcelona/05.jpg');
    images(end + 1).im = im(250:end, 50:210, :);
    images(end).name = '05.jpg'; 

    im = imread('data/chelsea/26.jpg');
    images(end + 1).im = im(140:end, 15:150, :);
    images(end).name = '26.jpg';

    im = imread('data/juventus/15.jpg');
    images(end + 1).im = im(130:end, :, :);
    images(end).name = '15.jpg';

    im = imread('data/liverpool/31.jpg');
    images(end + 1).im = im(75:end, 60:165, :);
    images(end).name = '31.jpg';

    im = imread('data/madrid/32.jpg');
    images(end + 1).im = im(82:end, 45:140, :);
    images(end).name = '32.jpg';

    im = imread('data/psv/17.jpg');
    images(end + 1).im = im(100:end, 35:end, :);
    images(end).name = '17.jpg';

    im = imread('data/rcdespanol/11.jpg');
    images(end + 1).im = im(155:end, 245:385, :);
    images(end).name = '11.jpg';

    im = imread('data/roma/11.jpg');
    images(end + 1).im = im(120:end, 60:160, :);
    images(end).name = '11.jpg';


    models = [struct('team_id', {}, 'name', {}, 'im', {}, 'im_norm', {}, 'histogram', {}, 'regions', {})];


    for k = 1 : length(images)
        figure(FIG_SUBIMAGE), subplot(2, 1, 1), imshow(images(k).im);
        models(k).team_id = k;
        models(k).name = images(k).name;
        models(k).im = images(k).im;
        models(k).im_norm = hsv2rgb(normalizer_hsv(models(k).im));
        models(k).histogram = get_hsv_histogram(models(k).im);
        models(k).regions = extract_regions(models(k).histogram);
    end
end


function [best_regions] = extract_regions(histogram)
    global SEED
    max_weight = 0;
    for iteration = 1 : 1
        centroids = k_means(10, histogram);
        SEED = SEED + 1;

        [regions, weight] = get_regions(histogram, centroids);
        if weight > max_weight
            best_regions = regions;
        end
    end
end

function [regions, weight] = get_regions(histogram, centroids)
    global VERBOSE
    
    regions = [struct('x_from', {}, 'x_to', {}, 'y_from', {}, 'y_to', {}, 'sum', {})];
    bitmap = false(size(histogram));
    for k = 1 : length(centroids)
        if ~bitmap(centroids(k).x, centroids(k).y)
            region = struct('x_from', centroids(k).x, 'x_to', centroids(k).x, 'y_from', centroids(k).y, 'y_to', centroids(k).y, 'sum', histogram(centroids(k).x, centroids(k).y));            
            [region, bitmap] = expand_region(region, bitmap, histogram);
            if region.sum >= 0
                regions(end + 1) = region;
            end
        end
    end
    
    if VERBOSE
        show_regions(regions, histogram);
    end
    THRESHOLD = 0.2;
    regions = regions([regions.sum] >= THRESHOLD);
    [~, indexes] = sort([regions.sum], 'descend');
    regions = regions(indexes(1:min(3, length(regions))));
    weight = sum([regions.sum]);
    
    if length(regions) == 0
        disp('Not significant regions found!!!!!');
    end
    
    if VERBOSE
        show_regions(regions, histogram);
    end
end

function [region, bitmap] = expand_region(region, bitmap, histogram)
    global VERBOSE
    global FIG_HIST
    global TIGHTNESS
    
    [N, M] = size(histogram);
    
    region.x_from = region.x_from - 4;
    region.x_to = region.x_to + 4;
    if get_area_value(region.x_from, region.x_to, region.y_from, region.y_to, bitmap, @max)
        region.sum = -1;
        return
    end
    bitmap = set_area_value(region.x_from, region.x_to, region.y_from, region.y_to, bitmap, true);
    region.sum = get_area_value(region.x_from, region.x_to, region.y_from, region.y_to, histogram, @sum);
    
    initial_density = region.sum / get_area(region);
    
    density = initial_density;
    while density > initial_density*TIGHTNESS && region.y_from > 1 && ~get_area_value(region.x_from, region.x_to, region.y_from - 1, region.y_from - 1, bitmap, @max)
        bitmap = set_area_value(region.x_from, region.x_to, region.y_from - 1, region.y_from - 1, bitmap, true);
        new_sum = get_area_value(region.x_from, region.x_to, region.y_from - 1, region.y_from - 1, histogram, @sum);
        region.sum = region.sum + new_sum;
        region.y_from = region.y_from - 1;
        density = new_sum / (region.x_to - region.x_from + 1)
    end
    
    density = initial_density;
    while density > initial_density*TIGHTNESS && region.y_to < M && ~get_area_value(region.x_from, region.x_to, region.y_to + 1, region.y_to + 1, bitmap, @max)
        bitmap = set_area_value(region.x_from, region.x_to, region.y_to + 1, region.y_to + 1, bitmap, true);
        new_sum = get_area_value(region.x_from, region.x_to, region.y_to + 1, region.y_to + 1, histogram, @sum);
        region.sum = region.sum + new_sum;
        region.y_to = region.y_to + 1;
        density = new_sum / (region.x_to - region.x_from + 1)
    end
end

function [free] = get_area_value(x_from, x_to, y_from, y_to, matrix, func)
    [N, ~] = size(matrix);
    [range_x_1, range_x_2] = get_ranges(x_from, x_to, N);
    range_y = y_from : y_to;
    free = func([reshape(matrix(range_x_1, range_y), 1, []), reshape(matrix(range_x_2, range_y), 1, [])]);
end

function [matrix] = set_area_value(x_from, x_to, y_from, y_to, matrix, value)
    [N, ~] = size(matrix);
    [range_x_1, range_x_2] = get_ranges(x_from, x_to, N);
    range_y = y_from : y_to;
    matrix(range_x_1, range_y) = value;
    matrix(range_x_2, range_y) = value;
end

function [range1, range2] = get_ranges(x_from, x_to, N)
    if x_from < 1
        x_from_1 = x_from + N;
        x_to_1 = N;
        x_from_2 = 1;
        x_to_2 = x_to;
    elseif x_to > N
        x_from_1 = x_from;
        x_to_1 = N;
        x_from_2 = 1;
        x_to_2 = x_to - N;
    else
        x_from_1 = x_from;
        x_to_1 = x_to;
        x_from_2 = 1;
        x_to_2 = 0;
    end
    range1 = x_from_1 : x_to_1;
    range2 = x_from_2 : x_to_2;
end

function [area] = get_area(region)
    area = (region.x_to - region.x_from + 1) * (region.y_to - region.y_from + 1);
end

function show_regions(regions, histogram)
    global FIG_HIST
    figure(FIG_HIST), subplot(1, 1, 1);
    bar3(histogram);
    hold on
    for region = regions
        [N, ~] = size(histogram);
        [range_x_1, range_x_2] = get_ranges(region.x_from, region.x_to, N);
        x1 = range_x_1(1); y1 = region.y_from;
        x2 = range_x_1(1); y2 = region.y_to;
        x3 = range_x_1(end); y3 = region.y_to;
        x4 = range_x_1(end); y4 = region.y_from;
        z = 0.01;
        patch([y1 y2 y3 y4 y1], [x1 x2 x3 x4 x1], [z z z z z], 'r')

        if length(range_x_2) > 0
            x1 = range_x_2(1);
            x2 = range_x_2(1);
            x3 = range_x_2(end);
            x4 = range_x_2(end);
            patch([y1 y2 y3 y4 y1], [x1 x2 x3 x4 x1], [z z z z z], 'r')
        end
    end
    hold off
    while waitforbuttonpress == 0
    end
end