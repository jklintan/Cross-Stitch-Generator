function colors50 = limitColorSpan50(LAB,colors100)
%LIMITCOLORSPAN50 Limits an array of 100 colors into one with 50 that best
%covers the color space

colors50 = zeros(50, 1);
k = 1;
for i = 1:100
    col1 = LAB(colors100(i), 1:3);
    if(k <= 10)
        colors50(k) = LAB(colors100(i), 4);
        k = k + 1;
        continue;
    end
    for j = i+1:100
        distan = euclidianDistance(col1, LAB(colors100(j), 1:3));
        if(distan > 9*10^3)
            if(ismember(colors50, LAB(colors100(j), 4)) == 0)
                colors50(k) = LAB(colors100(j), 4);
                k = k + 1;
                break;
            end
        end
    end
    if(k == 51)
        break;
    end
end

end

