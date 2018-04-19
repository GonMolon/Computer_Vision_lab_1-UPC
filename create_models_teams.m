close all
clear all

im = imread('data/acmilan/22.jpg');
im = im(75:170, 50:110, :);
imwrite(im,'data/models/acmilan_model.jpg');

im2 = imread('data/chelsea/26.jpg');
im2 = im2(140:end, 15:150, :);
imwrite(im2,'data/models/chelsea_model.jpg');

im3 = imread('data/juventus/15.jpg');
im3 = im3(130:end, :, :);
imwrite(im3,'data/models/juventus_model.jpg');

im4 = imread('data/liverpool/31.jpg');
im4 = im4(75:end, 60:165, :);
imwrite(im4,'data/models/liverpool_model.jpg');

im5 = imread('data/madrid/32.jpg');
im5 = im5(82:end, 45:140, :);
imwrite(im5,'data/models/madrid_model.jpg');

im6 = imread('data/psv/17.jpg');
im6 = im6(100:end, 35:end, :);
imwrite(im6,'data/models/psv_model.jpg');

im7 = imread('data/rcdespanol/11.jpg');
im7 = im7(155:end, 245:385, :);
imwrite(im7,'data/models/rcdespanol_model.jpg');

im8 = imread('data/roma/11.jpg');
im8 = im8(120:end, 60:160, :);
imwrite(im8,'data/models/roma_model.jpg');
