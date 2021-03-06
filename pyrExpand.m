%
% pyrExpands.m  expands the image by pyramid reduction
%
% An m x n image is inputted and 2*m-1 x 2*n-1 image is returned using pyramid
% expansion
%
% Arguments:
%
% image the image to be expanded, values in image are doubles
%
% Returns:
%
% imageOut the image after reduction
%

function [ imageout ] = pyrExpand( image )

kw = 5; % default kernel width
cw = .375; % weight to give a Gaussian shape
ker = [.25-cw/2 .25 cw .25 .25-cw/2];
kernel = kron(ker,ker')*4;% the matrix version of ker for expansion

% expand [a] to [A00 A01;A10 A11] with 4 kernels
k00 = kernel(1:2:kw,1:2:kw); % 3*3
k01 = kernel(1:2:kw,2:2:kw); % 3*2
k10 = kernel(2:2:kw,1:2:kw); % 2*3
k11 = kernel(2:2:kw,2:2:kw); % 2*2

image = im2double(image);
sz = size(image(:,:,1));
osz = sz*2-1;
imageout = zeros(osz(1),osz(2),size(image,3));

%for all color channels filter the image using kernels and expand size
for p = 1:3
	img1 = image(:,:,p);
	img1ph = padarray(img1,[0 1],'replicate','both');
	img1pv = padarray(img1,[1 0],'replicate','both'); 
	
	img00 = imfilter(img1,k00,'replicate','same');
	img01 = conv2(img1pv,k01,'valid'); 
	img10 = conv2(img1ph,k10,'valid');
	img11 = conv2(img1,k11,'valid');
	
	imageout(1:2:osz(1),1:2:osz(2),p) = img00;
	imageout(2:2:osz(1),1:2:osz(2),p) = img10;
	imageout(1:2:osz(1),2:2:osz(2),p) = img01;
	imageout(2:2:osz(1),2:2:osz(2),p) = img11;
end

end