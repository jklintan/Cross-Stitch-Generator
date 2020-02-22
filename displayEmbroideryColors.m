function displayEmbroideryColors(buythis, buyFloss)
%DISPLAYEMBROIDERYCOLORS Summary of this function goes here
%   Detailed explanation goes here
disp("Buy the following " + numel(buythis) + " colors with DMC accordingly");

ColorName = buythis(:);
DMC = buyFloss(:);
T = table(ColorName, DMC);
disp(T);

end

