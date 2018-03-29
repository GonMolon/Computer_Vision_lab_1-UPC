clear all
close all

%normalizer = @rgb_normalizer;
normalizer = @hsv_normalizer; 
%comp_hist = @comp_hist_euclidean;
comp_hist = @comp_hist_chi_square;
%comp_hist = @comp_hist_bhattacharyya;
global BIN_SIZE
BIN_SIZE = 5;
global SUBIMAGE_SIZE
SUBIMAGE_SIZE = 100;

f = figure(1);
set(f, 'Position', [0 0 1500 700])

model_images = ["05.jpg"];

model = create_model(normalizer);


results = [struct('result', {}, 'real', {}, 'features', {})];
images = dir('data/barcelona/*.jpg');
correct_predictions = 0;
for image = images'
    
    aux = regexp(image.folder,'/','split');
    aux = aux(end);
    team = aux{1};
    
    if ~ismember(image.name, model_images) || ~strcmp(team, 'barcelona')
        
        im = imread(strcat(image.folder, '/', image.name));
        
        [result, features] = histogram_classifier(im, model, normalizer, comp_hist);
        real = int8(strcmp(team, 'barcelona'));
        
        if real == result
            correct_predictions = correct_predictions + 1;
            disp('Correct classification');
        else
            disp('Incorrect classification');
        end
        
        results(end + 1) = struct('result', result, 'real', real, 'features', features);
        
        %waitforbuttonpress
    end      
    
end

struct2table(results)
correct_predictions
