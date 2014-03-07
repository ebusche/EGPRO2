%
% blendImage.m  
%
% blends two images together using basic blending
%
% Arguments:
%
% imagea the left image
% imageb the right image
% trans vector of translation [column translation, row translation]
%
% Returns:
%
% imageOut the image after the two images are blended together
%

function imageout = blendImage(imagea, imageb, trans)
    %gets current size of images
    [rowa, cola, channel] = size(imagea);
    [rowb, colb, channel] = size(imageb);
    
    imagea = im2double(imagea);
    imageb = im2double(imageb);
    
    %determines the size of the new image
    imageout = zeros(rowa+abs(trans(2)), cola+abs(trans(1)), channel);
    
    %how far across to do the blending
    blendWidth = colb + trans(1);
    % r1 & r2 are alpha layers.
    
    %make some masks
    maska = ones(1, cola);
    maskb = ones(1, colb);
    maska(1, (end-blendWidth):end) = [1:(-1/blendWidth):0];
    maskb(1, 1:(blendWidth+1)) = [0:(1/blendWidth):1];

    % apply the masks
    for c = 1:channel
        for y = 1:rowa
            imagea(y,:,c) = imagea(y,:,c) .* maska;
        end
        for y = 1:rowb
            imageb(y,:,c) = imageb(y,:,c) .* maskb;
        end
    end

    % combine image a and image b
    for y = 1:rowa
        for x = 1:cola
           imageout(y+ abs(trans(2)), x, :) = imagea(y, x, :);
        end
    end
    for y = 1:rowb
        for x = 1:colb 
            x1 = x + size(imageout, 2) - colb;
            imageout(y,x1,:) = imageout(y,x1,:) + imageb(y,x,:);
        end
    end

    %make sure all of the colors are in range
    imageout(find(imageout>255)) = 255;
end


