clear all
close all

global N_BINS
N_BINS = 60;

global THRESHOLD
THRESHOLD = 0.5;

global SUBIMAGE_SIZE
SUBIMAGE_SIZE = 50;

global VERBOSE
VERBOSE = false;

global FIG_IMAGE FIG_SUBIMAGE FIG_HIST
FIG_IMAGE = figure(1);
FIG_SUBIMAGE = figure(2);
FIG_HIST = figure(3);

set(FIG_IMAGE, 'Position', [0 450 300 350])
set(FIG_SUBIMAGE, 'Position', [0 0 300 400])
set(FIG_HIST, 'Position', [300 0 1100 800])

models = create_models(@normalizer_hsv);

results = [struct('name', {}, 'result', {}, 'real', {}, 'features', {})];
teams = dir('data/*');

correct_predictions = 0;

k = 1;
for team = teams'
    if sum(ismember(team.name, '.'))
        continue
    end
    
    images = dir(strcat('data/', team.name, '/*.jpg'));
    for image = images'
        if ~strcmp(image.name, models(k).name)
            
            disp(strcat(team.name, image.name));
            im = imread(strcat(image.folder, '/', image.name));
            im_norm = normalizer_hsv(im);

            figure(FIG_IMAGE), subplot(2, 1, 1), imshow(im), title('Original');
            figure(FIG_IMAGE), subplot(2, 1, 2), imshow(hsv2rgb(im_norm)), title('Light normalized');        
            
            [result, features] = classify(im_norm, models);
            
            if k == result
                correct_predictions = correct_predictions + 1;
                disp('Correct classification');
            else
                disp('Incorrect classification!!!!!!');
            end
            
            results(end + 1) = struct('name', strcat(team.name + '-' + image.name), 'result', result, 'real', k, 'features', features);
        end        
    end

    k = k + 1
end



disp('===================================================');
disp('Accuracy:');
disp(correct_predictions / size(results, 1));
disp('Correct predictions');
disp(correct_predictions);
disp('Out of');
disp(size(results, 1));

struct2csv(results, 'results.csv');
