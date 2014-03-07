%
% pyrReconstruct.m  use the pyramid to reconstruct the image
%
% Arguments:
%
% pyr the pyramid need to reconstruct the image
%
% Returns:
%
% imageOut the image after reconstruction
%

function [ imageOut ] = pyrReconstruct( pyr )

for p = length(pyr)-1:-1:1
	pyr{p} = pyr{p}+pyrExpand(pyr{p+1});
end
imageOut = pyr{1};

end

