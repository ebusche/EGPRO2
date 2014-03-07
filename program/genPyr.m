%
% genPyr.m  creates the pyramid for an image
%
%
% Arguments:
%
% image the image to create a pyramid for, values in image are doubles
% level the number of images in the pyramid
%
% Returns:
%
% pyr the output pyramid
%
function [ pyr ] = genPyr( image, level )

pyr = cell(1,level);
pyr{1} = image;

%reduce the images in size
for p = 2:level
	pyr{p} = pyrReduce(pyr{p-1});
end

%expand the images in size
for p = level-1:-1:1
	osz = size(pyr{p+1})*2-1;
	pyr{p} = pyr{p}(1:osz(1),1:osz(2),:);
end


for p = 1:level-1
	pyr{p} = pyr{p}-pyrExpand(pyr{p+1});
end

end