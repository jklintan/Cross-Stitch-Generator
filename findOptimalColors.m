function colors50optimized = findOptimalColors(meanIntensity,LAB, RGB)
%FINDOPTIMALCOLORS Finds the most occuring colors in an image from the mean
%intensity values

colors = [];

for i = 1:size(meanIntensity)
    curr = [rgb2lab(meanIntensity(i, 1:3))];
    
    % Find closest euclidian distance
     minimum = 10000000;
     save = 1;
        for n = 1:size(RGB)
            index =n;
            diss = sqrt((LAB(index, 1)-curr(1)).^2 + (LAB(index, 2)-curr(2)).^2 + (LAB(index, 3)-curr(3)).^2);
       
            if(diss < minimum)
                minimum = diss;
                save = index;
            end
        end
       
      minimum = 100000;
      colors(i) = save;

end

j = sort(colors, 2);
histo = histcounts(j, 453);

colorOccurences = histo';
colorOccurences(1:453,2) = 1:453;
colorOccurences = sortrows(colorOccurences, 1, 'descend');

amount = 50;
if(size(colorOccurences) < 50)
    amount = size(colorOccurences);
end

arr50 = colorOccurences(1:amount, 2);
colors50optimized = arr50;

end

