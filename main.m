clear all
close all

%normalizer = @rgb_normalizer;
normalizer = @hsv_normalizer; 

global THRESHOLD
%comp_hist = @comp_hist_euclidean;
%THRESHOLD = 0.005;
comp_hist = @comp_hist_chi_square;
THRESHOLD = 0.003;
%comp_hist = @comp_hist_bhattacharyya;
%THRESHOLD = 0.005; %Greater than
global BIN_SIZE
BIN_SIZE = 5;
global SUBIMAGE_SIZE
SUBIMAGE_SIZE = 100;
global VERBOSE
VERBOSE = true;

f = figure(1);
set(f, 'Position', [0 0 1500 700])

model_images = ["05.jpg"];

model = create_model(normalizer);


results = [struct('name', {}, 'result', {}, 'real', {}, 'features', {})];
images = dir('data/*/*.jpg');

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
        figure(3), imshow(im), title('Original');
        
        [result, features] = histogram_classifier(im, model, normalizer, comp_hist);
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

disp('Accuracy:');
disp(correct_predictions / size(images, 1));
disp('False negatives:');
disp(false_negatives);
disp('False positives:');
disp(false_positives);
disp('Out of');
disp(size(images, 1));

struct2csv(results, 'results.csv');
correct_predictions
