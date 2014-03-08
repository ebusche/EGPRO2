function [featureX, featureY, pos, orient, desc, im, R] = featureDetection(im_name, focal_length, warp)

    if ~exist('focal_length')
        focal_length = 600;
    end
    if ~exist('warp')
        warp = 1;
    end
    
    im = imRead(im_name);
    if warp
        im = warpCylinder(im, focal_length);
    end

    [featureX, featureY, R] = HarrisFeatureDetector(im, 7, 1, 5);  

    [featureX, featureY] = FeatureRemovalBoundary(im, featureX, featureY, R);
    [featureX, featureY, R] = FeatureRemovalLowContrast(im, featureX, featureY, R);
    [featureX, featureY, R] = FeatureRemovalEdge(im, featureX, featureY, R);
    [pos, orient, desc] = SIFTFeatureDescriptor(im, featureX, featureY);
end


