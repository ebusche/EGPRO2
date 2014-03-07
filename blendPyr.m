%
% blendPyr.m  
%
% blends two images together using pyramid blending
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

function [ imageout ] = blendPyr( imagea, imageb, trans)
    
    %converts the images to have double values
    imagea = im2double(imagea);
    imageb = im2double(imageb);
    
    [rowa, cola, channel] = size(imagea);
    [rowb, colb, channel] = size(imageb);
    
    %create images the right size to combine both together
    imageout = zeros(rowa+trans(2), cola+abs(trans(1)), channel);
    newimagea = zeros(rowa+abs(trans(2)), cola+abs(trans(1)), channel);
    newimageb = zeros(rowa+abs(trans(2)), cola+abs(trans(1)), channel);

    %create images a b that have been translated correctly
    for i = 1 : rowa
        for j = 1 : cola
            if trans(2) < 0
                newimagea(i, j, :) = imagea(i, j, :);
            else
                newimagea(i + abs(trans(2)), j, :) = imagea(i, j, :);
            end
        end
    end


    for i = 1 : rowb
        for j = 1 : colb
            if trans(2) < 0
                newimageb(i+abs(trans(2)), end - colb + j, :) = imageb(i, j, :);
            else
                newimageb(i,end - colb + j, :) = imageb(i, j, :);
            end
        end
    end


    blendWidth = cola + trans(1)*.5;%how far across to do the blending

    % generate the pyramids
    level = 5;
    pimagea = genPyr(newimagea,level); 
    pimageb = genPyr(newimageb,level);
    
    %make some masks to determine what of each image goes into the final
    maska = zeros(rowa+abs(trans(2)), cola+abs(trans(1)), channel);
    maska(:,1:blendWidth,:) = 1;
    maskb = zeros(rowa+abs(trans(2)), cola+abs(trans(1)), channel);
    maskb= 1 -maska;
    
    % blur the border
    blurh = fspecial('gauss',30,15); 
    maska = imfilter(maska,blurh,'replicate');
    maskb = imfilter(maskb,blurh,'replicate');

    pimageout = cell(1,level); % the pyramid for the combined image
    
     [M N ~] = size(imageout);
    for p = 1:level
        [Mp Np ~] = size(pimagea{p});
        maskap = imresize(maska,[Mp Np]);
        maskbp = imresize(maskb,[Mp Np]);
        pimageout{p} = pimagea{p}.*maskap + pimageb{p}.*maskbp;
    end
    
    imgo = pyrReconstruct(pimageout);
    
    %convert the image back to integers
    imageout = im2uint8(imgo);

    end
