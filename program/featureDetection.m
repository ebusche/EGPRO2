function [featureX, featureY, pos, orient, desc, im, R] = featureDetection(im_name, focal_length, warp, debug_)

    if ~exist('focal_length')
        focal_length = 800;
    end
    if ~exist('warp')
        warp = 1;
    end
    if ~exist('debug_')
        debug_ = 0;
    end

    im = imRead(im_name);
    %figure;
    %imshow(im);
    if warp
        im = warpCylinder(im, focal_length);
    end
    %figure;
    %imshow(uint8(im));

    %[featureX, featureY] = featureMoravec(im);
    % featureHarris(im, w, sigma, threshold, radius, k)
    [featureX, featureY, R] = featureHarris(im, 7, 1, 5);  
    if debug_
        disp(sprintf('feature number: %d.', numel(featureX)));
    end

    [featureX, featureY] = rejectBoundary(im, featureX, featureY, R);
    if debug_
        disp(sprintf('feature number after rejection of boundary: %d.', numel(featureX)));
    end
    [featureX, featureY, R] = rejectLowContrast(im, featureX, featureY, R);
    if debug_
        disp(sprintf('feature number after rejection of low-contrast: %d.', numel(featureX)));
    end
    [featureX, featureY, R] = rejectEdge(im, featureX, featureY, R);
    if debug_
        disp(sprintf('feature number after rejection of edge: %d.', numel(featureX)));
    end
    [pos, orient, desc] = descriptorSIFT(im, featureX, featureY);
    if debug_
        disp(sprintf('number of SIFT descriptors: %d.', size(pos, 1)));
    end
end


