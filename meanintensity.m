function meanintensity = meanIntensity(inputIm,area)
%Calculate the mean intensity of an input image for each subarea of
% the image according to area input.

k = 1;
H = size(inputIm, 1);
W = size(inputIm, 2);
for i = 1:area:H
    for j = 1:area:W
        
        meanintensity(k,1) =  mean2(inputIm(i:i+area-1,j:j+area-1,1));
        meanintensity(k,2) =  mean2(inputIm(i:i+area-1,j:j+area-1,2));
        meanintensity(k,3) =  mean2(inputIm(i:i+area-1,j:j+area-1,3));
        
        k = k+1;
    end
end

end

