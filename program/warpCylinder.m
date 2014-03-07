%
% warpCylinder.m  
%
% takes an image an warps it onto the cylinder
%
% Arguments:
%
% image the image to warp
% focalLength the focalLength from the camera
%
% Returns:
%
% imageout the image warped onto a cylinder
%

function imageout = warpCylinder(image, focalLength)
    [row, col, c] = size(image);
    imageout = zeros(size(image), 'uint8');
    
    %determine the midpoint of the image
    midy = round(row/2);
    midx = round(col/2);

    %create the warped image
    for x = 1:size(image, 2)
        for y = 1:size(image, 1)
            xp = x - midx;
            yp = y - midy;
            theta = atan(xp/focalLength);
            h = yp / sqrt(xp*xp + focalLength*focalLength);

            x_new = round(focalLength*theta) + midx;
            y_new = round(focalLength*h) + midy;

            imageout(y_new, x_new, :) = image(y, x, :);
        end
    end
end
