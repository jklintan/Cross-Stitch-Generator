function [imageVector, labVals] = loadToastLevels()
%CREATEDATABASE Reads in images and puts them in a vector
% Loads images and process them, from files into a database
% T = Image vectors from the database. 

%% Read in images 

DirPath = 'stitchBase'; % File Path
% 
S = dir(fullfile(DirPath, 'color*.png')); % Pattern to match filenames.

for k = 1:numel(S)
%     
    % Read one image from database folder.
     F = fullfile(DirPath,S(k).name);
     I = imread(F);
     if(I ~= -1)
        %imshow(I)
        % Calculate the CIELab values from image and store in vector
        labVals{k} = rgb2lab(I);
        imageVector{k} = I; 
     end
end

end
