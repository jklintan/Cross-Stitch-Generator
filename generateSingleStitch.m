function stitchIm = generateSingleStitch(r, g, b, dim, t)
%GENERATESINGLESTITCH Generates an image of a cross stitch
% with color rgb and dimensions dim. Thickness factor t.

width = 2;

im = zeros(dim, dim, 3);
numbCol = width;
i = 1;
for row = 1:dim
    for col = 1:dim
        if(col <= numbCol && col >= i)
            im(row, col, 1) = r;
            im(row, col, 2) = g;
            im(row, col, 3) = b;
        else
            im(row, col, 1) = 250;
            im(row, col, 2) = 250;
            im(row, col, 3) = 250;
        end
    end
    numbCol = numbCol + 1;
    i = i + 1;
end


numbCol = dim;
i = dim - width;
for row = 1:dim
    for col = 1:dim
        if(col <= numbCol && col > i)
            im(row, col, 1) = r;
            im(row, col, 2) = g;
            im(row, col, 3) = b;
        end
    end
    numbCol = numbCol - 1;
    i = i - 1;
end

% Erode the image for thicker cross
im = im./255;
se = strel('sphere',t);
im(:,:,1) = imerode(im(:,:,1), se); 
im(:,:,2) = imerode(im(:,:,2), se); 
im(:,:,3) = imerode(im(:,:,3), se); 

% Set border
im(1,:, 1) = 0.8; im(1,:, 2) = 0.8; im(1,:, 3) = 0.8;
im(dim,:, 1) = 0.8; im(dim,:, 2) = 0.8; im(dim,:, 3) = 0.8;
im(:,1, 1) = 0.8; im(:,1, 2) = 0.8; im(:,1, 3) = 0.8;
im(:,dim, 1) = 0.8; im(:,dim, 2) = 0.8; im(:,dim, 3) = 0.8;

stitchIm = im;
%figure;imshow(stitchIm);
end

