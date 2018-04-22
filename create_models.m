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


function [regions] = extract_regions(histogram)
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
    regions = best_regions;

    if VERBOSE
        show_regions(histogram, regions)
    end
end

function show_regions(histogram, regions)
    global FIG_HIST
    figure(FIG_HIST), subplot(2, 1, 2);
    bar3(histogram)
    hold on
    for region = regions
        
    end
    hold off
end

function [regions, weight] = get_regions(histogram, centroids)
    regions = [struct('from_x', {}, 'to_x', {}, 'from_y', {}, 'to_y', {}, 'sum', {})];
    bitmap = zeros(size(histogram));
    for k = 1 : length(centroids)
        if bitmap(centroids(k).x) == 0 && bitmap(centroids(k).y) == 0
            sum = histogram(centroids(k).x, centroids(k).y);
            region = struct('from_x', centroids(k).x, 'to_x', centroids(k).x, 'from_y', centroids(k).y, 'to_y', centroids(k).y, 'sum', sum);
            
            DIRS = [[0, 1]; [0, -1]; [1, 0]; [-1, 0]];
            for i = 1 : length(DIRS)
                dir = DIRS(i);
                [region, bitmap] = expand_region(region, histogram, bitmap, dir);
            end
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

function [region_expanded, bitmap_updated] = expand_region(region, histogram, bitmap, dir)
    region_expanded = region;
    bitmap_updated = bitmap;
end