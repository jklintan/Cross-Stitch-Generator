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

[n ~] = size(DMCtoRGB);
LAB = zeros(n-1);
for i = 1:453
    LAB(:,1:3) = rgb2lab([RGB.Red, RGB.Green, RGB.Blue]);
    LAB(i, 4) = i;
end

LAB = LAB(:,1:4);
plot3(LAB(:, 2), LAB(:, 3), LAB(:,1), 'r.')
grid on
title('All DMC colors in Lab color space')
xlabel('a value'); ylabel('b value'); zlabel('L value')

%% Load input image

im = imread('mtdoom.jpg');
h = size(im, 1);
w = size(im, 2);
im = im2double(im);

% 1080x720 (common aspect ratio for cameras)

DIM = 10; % Set to 10 or 20 for user to choose
THICKNESS = 1; % Thickness 3 for DIM = 20, 1 for DIM = 10;
H = 1080;
W = 720;
COLORS = 100;

%%
typeIm = 0;% 1 = portrait, 2 = landscape, 3 = square

% Check if image is large enough
if(h < 200 || w < 200)
    disp("Input image is too small, choose a larger image");
    return;
end

% Resize image
if(h > w) %Portrait image
    disp("Portrait image");
    if(h < H - 100 || w < W - 100)
        disp("Input image is being enlarged, may suffer from pixelrelated distortions");
    end
    
    if(h > H + 100 || w > W + 100)
        disp("Input image is being shrunk");
    end
    
    portrait = 1;
    im_resize = imresize(im, [H, W], 'bicubic');
    
elseif(h < w) % Landscape image
    temp = H;
    H = W;
    W = temp;
    
    disp("Landscape image");
    if(h < H - 100 || w < W - 100)
        disp("Input image is being enlarged, may suffer from pixelrelated distortions");
    end
    
    if(h > H + 100 || w > W + 100)
        disp("Input image is being shrunk");
    end
    
    landscape = 1;
    im_resize = imresize(im, [H, W], 'bicubic');
else %Square image
    H = W;
    
    disp("Square image");
    if(h < H - 100 || w < W - 100)
        disp("Input image is being enlarged, may suffer from pixelrelated distortions");
    end
    
    if(h > H + 100 || w > W + 100)
        disp("Input image is being shrunk");
    end
    
    im_resize = imresize(im, [H, W], 'bicubic');
end

%imshow(im_resize);

%% Calculate mean intensity

%Calculate mean intensity of image and turn to RGB values
meanIntensity = floor(meanintensity(im_resize,DIM)*255);


%% Choose 100 colors to cover color space

colors100 = zeros(100, 1);
k = 1;
for i = 1:size(RGB)
    col1 = LAB(i, 1:4);
    if(k >= 1 & k < 5) % Make sure to get some red values
        colors100(k) = LAB(k, 4);
        k = k + 1;
        continue;
    end
    for j = i+1:size(RGB)
        dist = euclidianDistance(col1(1:3), LAB(j, 1:3));
        if(dist > 10*10^3)
            if(ismember(colors100, LAB(j, 4)) == 0)
                colors100(k) = LAB(j, 4);
                k = k + 1;
                break;
            end
        end
    end
    if(k == 101)
        break;
    end
end

for i = 1:100
    disp(DMCtoRGB.Description(colors100(i)))
end

%% Choose 50 colors out of 100

colors50 = zeros(50, 1);
k = 1;
for i = 1:100
    col1 = LAB(colors100(i), 1:3);
    if(k >= 1 & k < 5) % Make sure to get some red values
        colors50(k) = LAB(colors100(k), 4);
        k = k + 1;
        continue;
    end
    for j = i+1:100
        distaaaan = euclidianDistance(col1, LAB(colors100(j), 1:3));
        if(distaaaan > 9*10^3)
            if(ismember(colors50, LAB(colors100(j), 4)) == 0)
                colors50(k) = LAB(colors100(j), 4);
                k = k + 1;
                break;
            end
        end
    end
    if(k == 51)
        break;
    end
end

for i = 1:50
    disp(DMCtoRGB.Description(colors50(i)))
end


%% Choose only the most occuring colors in the image

clear occuring;
d = zeros(size(RGB, 1));
u = 1;
for i = 1:size(meanIntensity)
    d(i, 1) = sqrt(meanIntensity(i,1).^2 + meanIntensity(i,2).^2 + meanIntensity(i,3).^2);
    if(i == 1)
        occuring(1) = d(i, 1);
    else
        existSimilar = 0;
        for j = 1:size(occuring)
            if(abs(d(i, 1) - occuring(j)) < 0.2)
                existSimilar = 1;
                existSimilar;
            end
        end
        
        if(existSimilar == 0)
            occuring(u, 1) = d(i, 1);
            occuring(u, 2) = i;
            u = u+1;
        end
    end
    
end


occuring = sort(occuring);
mostOccuring = occuring(1:800, 1:2)
mostOccuring(:,2)

minimum = 100000;
save = 1;
chooseThiscol = zeros(100, 1);
breakit = 0;
for n = 1:100
    curr = rgb2lab(meanIntensity(occuring(n, 2), 1:3));
    for i = 1:453
        diss = sqrt((LAB(i, 1)-curr(1)).^2 + (LAB(i, 2)-curr(2)).^2 + (LAB(i, 3)-curr(3)).^2);
        if(diss < minimum & ismember(chooseThiscol, i) == 0)
            minimum = diss;
            save = i
            chooseThiscol(n) = save;
            breakit = 1;
            break;
        end
    end
    minimum = 900;
            if(breakit == 1)
                breakit = 0;
            continue;
        end
    
end

chooseThiscol = sort(chooseThiscol, 'ascend');
k = 1;
for i = 1:100
    if(chooseThiscol(i) ~= 0)
        final(k) = chooseThiscol(i);
        k = k +1;
    end
end

%%

final = sort(final(1:49))';
[finalimage, buythis, buyFloss] = generateCrossStitchMosaic(H, W, meanIntensity, final, LAB, DIM, THICKNESS);
figure; imshow(finalimage);

%% Create cross stitch mosaic

allDMC = [1:size(RGB)]';

%[finalimage, buythis, buyFloss] = generateCrossStitchMosaic(H, W, meanIntensity, allDMC, LAB, DIM, THICKNESS);
%[finalimage, buythis, buyFloss] = generateCrossStitchMosaic(H, W, meanIntensity, colors100, LAB, DIM, THICKNESS);
[finalimage, buythis, buyFloss] = generateCrossStitchMosaic(H, W, meanIntensity, colors50, LAB, DIM, THICKNESS);

figure; imshow(finalimage);


%% Output to user

disp("Buy the following " + numel(buythis) + " colors with DMC accordingly");

ColorName = buythis(:);
DMC = buyFloss(:);
T = table(ColorName, DMC);
disp(T);


%% Calculate measurements

% Signal to noise ratio
snr_dist = snr(im_resize, im_resize-finalimage)

% SSIM - structural similarity
% a perceptual metric that quantifies image quality degradation caused by processing
[SSIMval, SSIM] = ssim(im_resize, finalimage);

% Euclidian distance
imLab = rgb2lab(im_resize);
crossLab = rgb2lab(finalimage);
dE = sqrt((crossLab(:,:,1)-imLab(:,:,1)).^2 + (crossLab(:,:,2)-imLab(:,:,2)).^2 + (crossLab(:,:,3)-imLab(:,:,3)).^2);
dE = (1/(W*H))*sum(sum(dE));
