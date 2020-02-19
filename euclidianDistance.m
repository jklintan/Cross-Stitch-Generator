function dE = euclidianDistance(LAB1,LAB2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
dE = sqrt((LAB1(1,1)-LAB2(1, 2)).^2 + (LAB1(1,2)-LAB2(1,2)).^2 + (LAB1(1,3)-LAB2(1,3)).^2);
end

