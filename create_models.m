function [models] = create_models()
    global VERBOSE
    global FIG_SUBIMAGE
    global FIG_HIST
    
    images = [struct('im', {}, 'name', {})];

    im = imread('data/acmilan/22.jpg');
    images(end + 1).im = im(75:170, 50:110, :);
    images(end).name = '22.jpg';

    im = imread('data/barcelona/05.jpg');
    images(end + 1).im = im(250:end, 50:210, :);
    images(end).name = '05.jpg'; 

    im = imread('data/chelsea/18.jpg');
    images(end + 1).im = im(60:160, 37:100, :);
    images(end).name = '26.jpg';

    im = imread('data/juventus/15.jpg');
    images(end + 1).im = im(130:end, :, :);
    images(end).name = '15.jpg';

    im = imread('data/liverpool/31.jpg');
    images(end + 1).im = im(75:end, 60:165, :);
    images(end).name = '31.jpg';

    im = imread('data/madrid/01.jpg');
    images(end + 1).im = im(150:end, 10:140, :);
    images(end).name = '01.jpg';

    im = imread('data/psv/17.jpg');
    images(end + 1).im = im(100:end, 35:end, :);
    images(end).name = '17.jpg';

    models = [struct('team_id', {}, 'name', {}, 'im', {}, 'im_norm', {}, 'histogram', {}, 'regions', {}, 'weight', {})];

    for k = 1 : length(images)
        if VERBOSE
            figure(FIG_SUBIMAGE), subplot(2, 1, 1), imshow(images(k).im);
            figure(FIG_HIST);
        end
        disp("Creating model:");
        disp(k);
        models(k).team_id = k;
        models(k).name = images(k).name;
        models(k).im = images(k).im;
        models(k).im_norm = hsv2rgb(normalizer_hsv(models(k).im));
        models(k).histogram = get_hsl_histogram(models(k).im);
        regions_lib = hsl_regions();
        [models(k).regions, models(k).weight] = regions_lib.extract_regions(models(k).histogram);
    end
end