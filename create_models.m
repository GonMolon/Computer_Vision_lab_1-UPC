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
    for iteration = 1 : 10
        centroids = k_means(10, histogram);
        SEED = SEED + 1;

        [regions, weight] = get_regions(histogram, centroids);
        if weight > max_weight
            best_regions = regions;
        end
    end
end

function [regions, weight] = get_regions(histogram, centroids)
    regions = [struct('x_from', {}, 'x_to', {}, 'y_from', {}, 'y_to', {}, 'sum', {})];
    bitmap = false(size(histogram));
    for k = 1 : length(centroids)
        if ~bitmap(centroids(k).x, centroids(k).y)
            region = struct('x_from', centroids(k).x, 'x_to', centroids(k).x, 'y_from', centroids(k).y, 'y_to', centroids(k).y, 'sum', histogram(centroids(k).x, centroids(k).y));            
            [region, bitmap] = expand_region(region, bitmap, histogram);
            regions(end + 1) = region;
        end
    end
    
    THRESHOLD = 0.3;
    regions = regions([regions.sum] >= THRESHOLD);
    [~, indexes] = sort([regions.sum], 'descend');
    regions = regions(indexes(1:min(3, length(regions))));
    weight = sum([regions.sum]);
    
    if length(regions) == 0
        disp("Not significant regions found!!!!!");
    end
end

function [region, bitmap] = expand_region(region, bitmap, histogram)
    global VERBOSE
    global FIG_HIST
    
    region.x_from = region.x_from - 5;
    region.x_to = region.x_to + 5;
    region.y_from = max(region.y_from - 10, 1);
    region.y_to = min(region.y_to + 10, size(bitmap, 2));
    
    [N, M] = size(bitmap);
    
    if region.x_from < 1
        x_from_1 = region.x_from + N;
        x_to_1 = N;
        x_from_2 = 1;
        x_to_2 = region.x_to;
    elseif region.x_to > N
        x_from_1 = region.x_from;
        x_to_1 = N;
        x_from_2 = 1;
        x_to_2 = region.x_to - N;
    else
        x_from_1 = region.x_from;
        x_to_1 = region.x_to;
        x_from_2 = 1;
        x_to_2 = 0;
    end
    
    bitmap(x_from_1 : x_to_1, region.y_from : region.y_to) = true;
    bitmap(x_from_2 : x_to_2, region.y_from : region.y_to) = true;
    region.sum = sum(sum(histogram(x_from_1 : x_to_1, region.y_from : region.y_to)));
    region.sum = sum(sum(histogram(x_from_2 : x_to_2, region.y_from : region.y_to)));
    
    if VERBOSE
        for i = 1 : N
            for j = 1 : M
                if bitmap(i, j)
                    histogram(i, j) = 0.1;
                end
            end
        end
        figure(FIG_HIST), bar3(histogram);
    end
end

function [area] = get_area(region)
    area = (region.x_to - region.x_from + 1) * (region.y_to - region.y_from + 1);
end