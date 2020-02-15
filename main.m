%% Main
% Function that generates a cross stitch pattern from an 
% input image. Gives the correct colors to buy for yarn.

%% Read in from database, save to .mat and load

%importfile('./Resources/DMCtoRGB.csv');
%save('DMCtoRGB.mat', 'DMCtoRGB');
load('DMCtoRGB.mat');

%% Store information

DMC = DMCtoRGB.Floss(1:453);
NAME = DMCtoRGB.Description(1:453);
RGB = DMCtoRGB(1:453,3:5);

[n ~] = size(DMCtoRGB);
LAB = zeros(n-1);
for i = 1:numel(RGB)
    LAB = rgb2lab([RGB.Red, RGB.Green, RGB.Blue]);
end

%% Load input image

im = imread('me.jpg');
[w, h] = size(im);
im = im2double(im);

% 20x20px

H = 1000;
W = 640;

typeIm = 0;% 1 = portrait, 2 = landscape, 3 = square

if(h > w) %Portrait
    im_resize = imresize(im, [1000, 640]);
    if(640 > h)
        disp("Image too small, resizing");
    else
        disp("Image too large, resizing");
    end
end

imshow(im_resize);

%if(w > h) %Landscape
%end


%%
        k = 1;
        for i = 1:20:H
            for j = 1:20:W
                
                   vectY = i:i+20-1;
                   vectX = j:j+20-1;
                   
                 meanIntensity(k,1) =  floor(mean2(im_resize(vectY,vectX,1))*255);
                 meanIntensity(k,2) =  floor(mean2(im_resize(vectY,vectX,2))*255);
                 meanIntensity(k,3) =  floor(mean2(im_resize(vectY,vectX,3))*255);

                 k = k+1;
            end
              
        end

%% Generate cross stitch

pixelsumR = 0;
pixelsumG = 0;
pixelsumB = 0;
n = 1;
for i = 1:19:H-19
    for j = 1:19:W-19  
        pixelsumR(n) = sum(sum(im_resize(i:i+19,j:j+19,1)))./(20*20);
        pixelsumG(n) = sum(sum(im_resize(i:i+19,j:j+19,2)))./(20*20);
        pixelsumB(n) = sum(sum(im_resize(i:i+19,j:j+19,3)))./(20*20);
        n = n + 1;
    end
end


%% 

finalimage = zeros(1000, 640);

stitches = {};
for i = 1:20
    ind = randi(sort([1 453]),1,1);
    stitch = generateSingleStitch(DMCtoRGB.Red(ind), DMCtoRGB.Green(ind), DMCtoRGB.Blue(ind), 20, 3);
    stitches{i} = stitch;
    
    %imshow(stitch);
    rgbs(i, 1:3) = [DMCtoRGB.Red(ind), DMCtoRGB.Green(ind), DMCtoRGB.Blue(ind)];
    comp(i, 1:3) = [pixelsumR(ind), pixelsumG(ind), pixelsumB(ind)];
    %labs(i) = rgb2lab(DMCtoRGB.Red(ind), DMCtoRGB.Green(ind), DMCtoRGB.Blue(ind));
end

%%

%generateSingleStitch(RGB.Red(index), RGB.Green(index), RGB.Blue(index), 20, 2);
k = 1;
distancesArr = zeros(numel(LAB));
threads = 1;
labscomp = rgb2lab(meanIntensity(:, 1:3));
buyFloss = 0;
buythis = "";
for i = 1:20:1000
    for j = 1:20:640
        in = floor(j/20 + 32*i/20);
        curr = rgb2lab(meanIntensity(in, 1:3));
        
        minimum = 10000000;
        save = 1;
        for n = 1:400
            diss = sqrt((LAB(n, 1)-curr(1)).^2 + (LAB(n, 2)-curr(2)).^2 + (LAB(n, 3)-curr(3)).^2);
            if(diss < minimum)
                minimum = diss;
                save = n;
            end
            %distancesArr(n) = sqrt((LAB(n, 1)-curr(1)).^2 + (LAB(n, 2)-curr(2)).^2 + (LAB(n, 3)-curr(3)).^2);
        end
        
        %[a, b] = min(distancesArr);
        chooseThiscol = save;
        finalimage(i:i+19, j:j+19, 1:3) = generateSingleStitch(DMCtoRGB.Red(chooseThiscol), DMCtoRGB.Green(chooseThiscol), DMCtoRGB.Blue(chooseThiscol), 20, 3);

        if(ismember(DMCtoRGB.Floss(chooseThiscol), buyFloss))
            %disp("Exist");
        else
            buythis(threads) = DMCtoRGB.Description(chooseThiscol);
            buyFloss(threads) = DMCtoRGB.Floss(chooseThiscol);
            threads = threads + 1;
        end
       
    end
end

imshow(finalimage);


%% Output to user

disp("Buy the following " + numel(buythis) + " colors with DMC accordingly");

ColorName = buythis(:);
DMC = buyFloss(:);
T = table(ColorName, DMC);
disp(T);

finalim = ones(1120, 760, 3);
finalim(61:1060, 61:700, 1:3) = finalimage;
imshow(finalim);


%image = generateSingleStitch(55, 204, 78, 50, 8);
%imshow(image);

%Minst 200-300px på originalbild
%Generera en array innan med LAB värdena