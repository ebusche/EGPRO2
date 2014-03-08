function [ imageout ] = pyrBlend( imA, imB)

imageA = im2double(imread(imA));
imageB = im2double(imread(imB)); % size(imga) = size(imgb)
imageA = imresize(imageA,[size(imageB,1) size(imageB,2)]);
[M N ~] = size(imageA);

v = N/2;
level = 5;
limga = genPyr(imageA, level); % the Laplacian pyramid
limgb = genPyr(imageB, level);

maska = zeros(size(imageA));
maska(:,1:v,:) = 1;
maskb = 1-maska;
blurh = fspecial('gauss',30,15); % feather the border
maska = imfilter(maska,blurh,'replicate');
maskb = imfilter(maskb,blurh,'replicate');

limgo = cell(1,level); % the blended pyramid
for p = 1:level
	[Mp Np ~] = size(limga{p});
	maskap = imresize(maska,[Mp Np]);
	maskbp = imresize(maskb,[Mp Np]);
	limgo{p} = limga{p}.*maskap + limgb{p}.*maskbp;
end
imgo = pyrReconstruct(limgo);
figure,imshow(imgo) % blend by pyramid
imageout = im2uint8(imgo);