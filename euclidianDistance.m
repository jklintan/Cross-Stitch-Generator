function dE = euclidianDistance(LAB1,LAB2)
%Euclidian Distance, Calculates the euclidian distance between to Lab values
dE = sqrt((LAB1(1,1)-LAB2(1, 2)).^2 + (LAB1(1,2)-LAB2(1,2)).^2 + (LAB1(1,3)-LAB2(1,3)).^2);
end

