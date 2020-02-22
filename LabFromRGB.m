function LAB = LabFromRGB(RGB)
%LABFROMRGB Summary of this function goes here
%   Detailed explanation goes here

[n, ~] = size(DMCtoRGB);
LAB = zeros(n-1);

for i = 1:453
    LAB(:,1:3) = rgb2lab([RGB.Red, RGB.Green, RGB.Blue]);
    LAB(i, 4) = i;
end

LAB = LAB(:,1:4);
end

