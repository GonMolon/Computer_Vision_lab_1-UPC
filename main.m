clear all
close all

%normalizer = @normalizer_rgb;
normalizer = @normalizer_hsv;

%image_comparator = @comp_im_rgb;
image_comparator = @comp_im_hsv;

global histogram_comparator
global THRESHOLD

histogram_comparator = @comp_hist_euclidean;
THRESHOLD = 7.6;

%histogram_comparator = @comp_hist_chi_square;
%THRESHOLD = 0.0187;

%histogram_comparator = @comp_hist_bhattacharyya;
%THRESHOLD = 0.005; %Greater than

global N_BINS
N_BINS = 60;

global SUBIMAGE_SIZE
SUBIMAGE_SIZE = 89;

global VERBOSE
VERBOSE = true;

global fig_image
global fig_subimage
global fig_hist
fig_image = figure(1);
fig_subimage = figure(2);
fig_hist = figure(3);

set(fig_image, 'Position', [0 450 300 350])
set(fig_subimage, 'Position', [0 0 300 400])
set(fig_hist, 'Position', [300 0 1100 800])

model_images = ["05.jpg"];

model = create_model(normalizer);
figure(fig_subimage), subplot(2, 1, 1), imshow(model), title('Model');

results = [struct('name', {}, 'result', {}, 'real', {}, 'features', {})];
images = dir('data/barcelona/40.jpg');

correct_predictions = 0;
false_negatives = 0;
false_positives = 0;

for image = images'
    
    aux = regexp(image.folder,'/','split');
    aux = aux(end);
    team = aux{1};
    
    if ~ismember(image.name, model_images) || ~strcmp(team, 'barcelona')
        
        disp(strcat(team, image.name));
        im = imread(strcat(image.folder, '/', image.name));
        im_norm = normalizer(im);

        figure(fig_image), subplot(2, 1, 1), imshow(im), title('Original');
        figure(fig_image), subplot(2, 1, 2), imshow(im_norm), title('Light normalized');        
        
        [result, features] = classify(im_norm, model, image_comparator);
        real = int8(strcmp(team, 'barcelona'));
        
        if real == result
            correct_predictions = correct_predictions + 1;
            disp('Correct classification');
        else
            disp('Incorrect classification!!!!!!');
            if strcmp(team, 'barcelona')
                false_negatives = false_negatives + 1;
            else
                false_positives = false_positives + 1;
            end
        end
        
        results(end + 1) = struct('name', strcat(team, image.name), 'result', result, 'real', real, 'features', features);
        
    end      
    
end

disp('===================================================');
disp('Accuracy:');
disp(correct_predictions / size(images, 1));
disp('False negatives:');
disp(false_negatives);
disp('False positives:');
disp(false_positives);
disp('Out of');
disp(size(images, 1));

struct2csv(results, 'results.csv');
