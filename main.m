%% Main
% Function that generates a cross stitch pattern from an
% input image. Gives the correct colors to buy for yarn.

%% Clear

clc; clear all; close all;

%% Read in from database, save to .mat and load

%importfile('./Resources/DMCtoRGB.csv');
%save('DMCtoRGB.mat', 'DMCtoRGB');
load('DMCtoRGB.mat');

%% Store information

RGB = DMCtoRGB(1:453,3:5);
allDMC = (1:size(RGB))';
load('LAB.mat');

%If recalculation is needed
%LAB = LabFromRGB(RGB);

%Plot the color space for all DMC colors
%plot3(LAB(:, 2), LAB(:, 3), LAB(:,1), 'r.')
%grid on
%title('All DMC colors in Lab color space')
%xlabel('a value'); ylabel('b value'); zlabel('L value')

%% Load input image

im = imread('./input/legionen.jpg');
h = size(im, 1);
w = size(im, 2);
im = im2double(im);

% 1080x720 (common aspect ratio for cameras) (long calculation time)
% 540x360 quick but less accurate

DIM = 10; % Set to 10 or 20 for user to choose
THICKNESS = 1; % Thickness 3 for DIM = 20, 1 for DIM = 10;
H = 1080;
W = 720;
COLORS = 100;

%% Resize input image

[im_resize, H, W] = resizeImage(im, H, W);
%imshow(im_resize);

%% Calculate mean intensity

%Calculate mean intensity of image and turn to RGB values
meanIntensity = floor(meanintensity(im_resize,DIM)*255);


%% Choose subset of colors to cover color space

load('colors100.mat');
load('colors50.mat');

% If recalculation is needed
%[colors100, colors50] = limitColorSpan(LAB);

% If recalculation is needed, another version of optimization
%colors50 = limitColorSpan50(LAB, colors100);

%% Choose only the most occuring colors in the image

colors50optimized = findOptimalColors(meanIntensity, LAB, RGB);

%% Create cross stitch mosaic, full choice of colors

[finalimageFull, buythis, buyFloss] = generateCrossStitchMosaic(H, W, meanIntensity, allDMC, LAB, DIM, THICKNESS);
figure; imshow(finalimageFull);
displayEmbroideryColors(buythis, buyFloss);

% Display image with 100 colors as database

[finalimage100, buythis, buyFloss] = generateCrossStitchMosaic(H, W, meanIntensity, colors100, LAB, DIM, THICKNESS);
figure; imshow(finalimage100);
displayEmbroideryColors(buythis, buyFloss);

% Display image with 50 colors as database

[finalimage50, buythis, buyFloss] = generateCrossStitchMosaic(H, W, meanIntensity, colors50, LAB, DIM, THICKNESS);
figure; imshow(finalimage50);
displayEmbroideryColors(buythis, buyFloss);

% Display image with 50 most occuring colors as database

[finalimage50opt, buythis, buyFloss] = generateCrossStitchMosaic(H, W, meanIntensity, colors50optimized, LAB, DIM, THICKNESS);
figure; imshow(finalimage50opt);
displayEmbroideryColors(buythis, buyFloss);


%% Calculate quality measurements

% Signal to noise ratio
snr_distFull = snr(im_resize, im_resize-finalimageFull)
snr_dist100 = snr(im_resize, im_resize-finalimage100)
snr_dist50 = snr(im_resize, im_resize-finalimage50)
snr_dist50opt = snr(im_resize, im_resize-finalimage50opt)

% SSIM - structural similarity 
% a perceptual metric that quantifies image quality degradation caused by processing
[SSIMvalFull, SSIM] = ssim(im_resize, finalimageFull); SSIMvalFull
[SSIMval100, SSIM] = ssim(im_resize, finalimage100); SSIMval100
[SSIMval50, SSIM] = ssim(im_resize, finalimage50); SSIMval50
[SSIMval50opt, SSIM] = ssim(im_resize, finalimage50opt); SSIMval50opt


% Euclidian distance
imLab = rgb2lab(im_resize);
crossLab = rgb2lab(finalimageFull);
dE_Full = sqrt((crossLab(:,:,1)-imLab(:,:,1)).^2 + (crossLab(:,:,2)-imLab(:,:,2)).^2 + (crossLab(:,:,3)-imLab(:,:,3)).^2);
dE_Full = (1/(W*H))*sum(sum(dE_Full))

crossLab = rgb2lab(finalimage100);
dE_100 = sqrt((crossLab(:,:,1)-imLab(:,:,1)).^2 + (crossLab(:,:,2)-imLab(:,:,2)).^2 + (crossLab(:,:,3)-imLab(:,:,3)).^2);
dE_100 = (1/(W*H))*sum(sum(dE_100))

crossLab = rgb2lab(finalimage50);
dE_50 = sqrt((crossLab(:,:,1)-imLab(:,:,1)).^2 + (crossLab(:,:,2)-imLab(:,:,2)).^2 + (crossLab(:,:,3)-imLab(:,:,3)).^2);
dE_50 = (1/(W*H))*sum(sum(dE_50))

crossLab = rgb2lab(finalimage50opt);
dE_50opt = sqrt((crossLab(:,:,1)-imLab(:,:,1)).^2 + (crossLab(:,:,2)-imLab(:,:,2)).^2 + (crossLab(:,:,3)-imLab(:,:,3)).^2);
dE_50opt = (1/(W*H))*sum(sum(dE_50opt))
