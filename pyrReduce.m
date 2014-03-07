%
% pyrReduce.m  reduces the image by pyramid reduction
%
% An m x n image is inputted and m/2 x n/2 image is returned using pyramid
% reduction
%
% Arguments:
%
% image the image to be reduce, values in image are doubles
%
% Returns:
%
% imageOut the image after reduction
%

function [ imageOut ] = pyrReduce( image )

cw = .375; % weight to give a Gaussian shape
ker = [.25-cw/2 .25 cw .25 .25-cw/2];
kernel = kron(ker,ker');% the matrix version of ker

%image = im2double(image);
sz = size(image);
imageOut = [];

%for all color channels filter the image using kernel and reduce size
for p = 1:3 
	img1 = image(:,:,p);
	imgFiltered = imfilter(img1,kernel,'replicate','same');
	imageOut(:,:,p) = imgFiltered(1:2:sz(1),1:2:sz(2));
end

end