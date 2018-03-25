clear all
close all

normalizer = @rgb_normalizer;

model_images = ["05.jpg"];

model = create_model(normalizer);

images = dir('data/*/*.jpg');
correct_predictions = 0;
for image = images'
    
    aux = regexp(image.folder,'/','split');
    aux = aux(end);
    team = aux{1};
    
    if ~ismember(image.name, model_images) || ~strcmp(team, 'barcelona')
        im = imread(strcat(image.folder, '/', image.name));
    end      
    
end
