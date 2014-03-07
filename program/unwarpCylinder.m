%
% unwarpCylinder.m  
%
% determine the flat coordinates based on the coordinate in cylinder
%
% Arguments:
%
% x the x coordinate in the cylinder
% y the y coordinate in the cylinder
% focalLength the focalLength from the camera
% image the warped image
%
% Returns:
%
% xOut the flattened x coordinate
% yOut the flattened y coordinate
%

function [xout, yout] = unwarpCylinder(x, y, focalLength, image)

    [row, col, c] = size(image);
    
    %determine the midpoint of the image
    midy = round(row/2);
    midx = round(col/2);
    

    theta = (x - midx)/focalLength;
    h = (y - midy)/focalLength;
    xp = tan(theta)*focalLength;
    yp = h*sqrt(xp*xp + focalLength*focalLength);
    
    
    xout = round(xp + midx);
    yout = round(yp + midy);
end

