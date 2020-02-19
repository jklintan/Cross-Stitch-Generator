function [outputImage,threadCols, threadDescription] = generateCrossStitchMosaic(height, width, meanIntensity, colorindex, LABvector, DIM, THICKNESS)
%GENERATECROSSSTITCHMOSAIC Summary of this function goes here
%   Detailed explanation goes here

load('DMCtoRGB.mat');
H = height;
W = width;
finalimage = zeros(H, W);

numbCols = size(colorindex);

k = 1;
distancesArr = zeros(453);
threads = 1;

buyFloss = 0;
buythis = "";
for i = 1:DIM:H
    for j = 1:DIM:W
        in = floor((j-1)/DIM + (W/(DIM))*(i-1)/DIM) + 1; % Convert 2D index to 1D index

        curr = rgb2lab(meanIntensity(in, 1:3));
        
        % Find closest euclidian distance
        minimum = 10000000;
        save = 1;
        for n = 1:numbCols
            index = colorindex(n);
            diss = sqrt((LABvector(index, 1)-curr(1)).^2 + (LABvector(index, 2)-curr(2)).^2 + (LABvector(index, 3)-curr(3)).^2);
       
            if(diss < minimum)
                minimum = diss;
                save = index;
            end
        end
        
        chooseThiscol = save;
        
        % Generate the cross stitch
        finalimage(i:i+DIM-1, j:j+DIM-1, 1:3) = generateSingleStitch(DMCtoRGB.Red(chooseThiscol), DMCtoRGB.Green(chooseThiscol), DMCtoRGB.Blue(chooseThiscol), DIM, THICKNESS);
        
        if(ismember(DMCtoRGB.Floss(chooseThiscol), buyFloss))
            %disp("Exist");
        else
            buythis(threads) = DMCtoRGB.Description(chooseThiscol);
            buyFloss(threads) = DMCtoRGB.Floss(chooseThiscol);
            threads = threads + 1;
        end
        
    end
end

outputImage = finalimage;
threadCols = buyFloss;
threadDescription = buythis;

end

