%
% perfectCrop.m  
%
% takes a panaorama image with two idetified matching points (x0, y0) and (x1, y1)
% warps image so matching y coordinates line up
% crops warpped image so there is no overlapping content
% crops warped image on top and bottom by cropAmount
%
% Arguments:
%
% image the image to be warped and cropped
% x0 the x-coordinate of the left matching point
% y0 the y-coordinate of the left matching point
% x1 the x-coordinate of the right matching point
% y1 the y-coordinate of the right matching point
% cropAmount the number of pixels to be cropped off the top and bottom of
% 
%
%

function perfectCrop( image, x0, y0, x1, y1, cropAmount )

imagetowarp =imRead(image);

%figure out how much rotation to make y0 = y1
deltax = x1 - x0;
deltay = y1 - y0;

angle = atand(deltay/deltax);

%warp image
tform = affine2d([cosd(angle) -sind(angle) 0; sind(angle) cosd(angle) 0; 0 0 1]);

imageWarp = imwarp(imagetowarp,tform);
figure, imshow(imageWarp)
[row, col, channel] = size(imageWarp);


%the new locations of the crop points
[xw0,yw0] = transformPointsForward(tform,x0,y0);
[xw1, yw1] = transformPointsForward(tform,x1,y1);

xw0 = round(xw0);
xw1 = round(xw1);
imageout = imcrop(imageWarp, [xw0 cropAmount (xw1-xw0) (row-2*cropAmount)]);


figure, imshow(imageout)

outFile = ['cropped.png'];  
imwrite(uint8(imageout), outFile);
end

