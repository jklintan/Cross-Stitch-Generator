function [im_resize, newH, newW] = resizeImage(im, H, W)
%RESIZEIMAGE Summary of this function goes here
%   Detailed explanation goes here

h = size(im, 1);
w = size(im, 2);

% Check if image is large enough
if(h < 200 || w < 200)
    disp("Input image is too small, choose a larger image");
    return;
end

% Resize image
if(h > w) %Portrait image
    disp("Portrait image");
    if(h < H - 100 || w < W - 100)
        disp("Input image is being enlarged, may suffer from pixelrelated distortions");
    end
    
    if(h > H + 100 || w > W + 100)
        disp("Input image is being shrunk");
    end
    
    portrait = 1;
    im_resize = imresize(im, [H, W], 'bicubic');
    
elseif(h < w) % Landscape image
    temp = H;
    H = W;
    W = temp;
    
    disp("Landscape image");
    if(h < H - 100 || w < W - 100)
        disp("Input image is being enlarged, may suffer from pixelrelated distortions");
    end
    
    if(h > H + 100 || w > W + 100)
        disp("Input image is being shrunk");
    end
    
    im_resize = imresize(im, [H, W], 'bicubic');
else %Square image
    H = W;
    
    disp("Square image");
    if(h < H - 100 || w < W - 100)
        disp("Input image is being enlarged, may suffer from pixelrelated distortions");
    end
    
    if(h > H + 100 || w > W + 100)
        disp("Input image is being shrunk");
    end
    
    im_resize = imresize(im, [H, W], 'bicubic');
end

% Check if image is large enough
if(h < 200 || w < 200)
    disp("Input image is too small, choose a larger image");
    return;
end

newH = H;
newW = W;
end

