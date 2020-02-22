function colors50optimized = findOptimalColors(meanIntensity,LAB, RGB)
%FINDOPTIMALCOLORS Finds the most occuring colors in an image from the mean
%intensity values

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
mostOccuring = occuring(1:size(occuring), 1:2);
mostOccuring(:,2);

minimum = 100000;
save = 1;
chooseThiscol = zeros(100, 1);
breakit = 0;
for n =1:100
    curr = rgb2lab(meanIntensity(occuring(n, 2), 1:3));
    for i = 1:453
        diss = sqrt((LAB(i, 1)-curr(1)).^2 + (LAB(i, 2)-curr(2)).^2 + (LAB(i, 3)-curr(3)).^2);
        if(diss < minimum & ismember(chooseThiscol, i) == 0)
            minimum = diss;
            save = i;
            chooseThiscol(n) = save;
            breakit = 1;
            break;
        end
    end
    minimum = 4000;
    
end

chooseThiscol = sort(chooseThiscol, 'ascend');
k = 1;
for i = 2:100
    if(chooseThiscol(i) ~= 0)
        colors50optimized(k) = chooseThiscol(i);
        k = k +1;
    end
end

s = size(colors50optimized, 2);
if(s > 50) % Ev. add user input to determine # cols
    s = 50;
end

if(s < 30)
    disp("Could not distinguish enough colors for optimization, try another image");
    return;
end

colors50optimized = sort(colors50optimized(1:s))';
end

