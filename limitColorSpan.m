function [colors100, colors50] = limitColorSpan(LAB)
%LIMITCOLORSPAN100 Limits the 453 DMC colors to 100

colors100 = zeros(100, 1);
k = 1;
reds = randi(50, 10, 1);

for i = 1:size(LAB)
    col1 = LAB(i, 1:4);
    if(k == reds(1) || k == reds(2) || k == reds(3) || k == reds(4) || k == reds(5) || k == reds(6) || k == reds(7) || k == reds(8) || k == reds(9) || k == reds(10)) % Make sure to get some red values
        colors100(k) = LAB(k, 4);
        k = k + 1;
        continue;
    end
    for j = i+1:size(LAB)
        dist = euclidianDistance(col1(1:3), LAB(j, 1:3));
        if(dist > 10*10^3)
            if(ismember(colors100, LAB(j, 4)) == 0)
                colors100(k) = LAB(j, 4);
                k = k + 1;
                break;
            end
        end
    end
    if(k == 101)
        break;
    end
end

colors50 = [];
k = 1;
for i = 1:2:100
    colors50(k, 1) = colors100(i, 1);
    k = k + 1;
end

end

