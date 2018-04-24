clear all
close all

global N_BINS
N_BINS = 60;

global THRESHOLD
THRESHOLD = 0.04;

global TIGHTNESS
TIGHTNESS = 0.02;

global SUBIMAGE_SIZE
SUBIMAGE_SIZE = 26;

global SEED
SEED = 17;

global VERBOSE
VERBOSE = false;

if VERBOSE
    global FIG_IMAGE
    global FIG_SUBIMAGE
    global FIG_HIST
    FIG_IMAGE = figure(1);
    FIG_SUBIMAGE = figure(2);
    FIG_HIST = figure(3);

    set(FIG_IMAGE, 'Position', [0 450 300 350])
    set(FIG_SUBIMAGE, 'Position', [0 0 300 400])
    set(FIG_HIST, 'Position', [300 0 1100 800])
end

models = create_models();

folders = dir('data/*');
teams = [];
for folder = folders'
    if sum(ismember(folder.name, '.')) == 0
        if length(teams) == 0
            teams = folder;
        else
            teams(end + 1) = folder;
        end
    end
end

results = [struct('name', {}, 'result', {}, 'real', {}, 'features', {})];
correct_predictions = 0;

confussion_matrix = [];
k = 1;
for team = teams
    
    confussion_row = zeros(1, length(teams));
    
    images = dir(strcat('data/', team.name, '/*.jpg'));
    for image = images'
        if ~strcmp(image.name, models(k).name)
            
            disp(strcat(team.name, image.name));
            im = imread(strcat(image.folder, '/', image.name));

            if VERBOSE
                figure(FIG_IMAGE), subplot(2, 1, 1), imshow(im), title('Original');
                figure(FIG_IMAGE), subplot(2, 1, 2), imshow(hsv2rgb(normalizer_hsv(im))), title('Light normalized');     
            end   
            
            [result, features] = classify(im, models);
            
            if k == result
                correct_predictions = correct_predictions + 1;
                disp('Good');
            elseif result == 0
                disp('?????????????')
            else
                disp('!!!!!!!!!!!!!');
                disp(result);
            end
            
            if result ~= 0
                confussion_row(result) = confussion_row(result) + 1;
            end
            
            results(end + 1) = struct('name', strcat(team.name, '-', image.name), 'result', result, 'real', k, 'features', features);
        end        
    end
    confussion_row = confussion_row ./ length(images);
    confussion_matrix = [confussion_matrix; confussion_row];

    k = k + 1;
end

disp('Confussion matrix:');
disp(confussion_matrix);


disp('===================================================');
disp('Accuracy:');
disp(correct_predictions / length(results));
disp('Correct predictions');
disp(correct_predictions);
disp('Out of');
disp(length(results));
