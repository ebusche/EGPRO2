function main()

imagePath = 'C:/Users/Emily/p2/capitols';     % i path of the images
outFile = 'capitols_stitched.png';       % output stitched file.
N = 19;     % number of images in the sequence
focal_length = 660.8799;     % focal length

disp('FEATURE DETECTION');
for i = 1:N
    src_img_file = sprintf('%s/%02d.jpg', imagePath, (i));
    [fx, fy, pos, orient, desc, im, R] = featureDetection(src_img_file, focal_length, 1);
    ims{i} = im;
    fxs{i} = fx;
    fys{i} = fy;
    poss{i} = pos;
    orients{i} = orient;
    descs{i} = desc;
end

disp('FEATURE MATCHING');
for i = 1:(N-1)  
    match = featureMatching(descs{i}, descs{i+1}, poss{i}, poss{i+1});
    matchCompact = RANSACMethod(match, poss{i}, orients{i}, descs{i}, poss{i+1}, orients{i+1}, descs{i+1});
    matchs{i} = match;
    matchCompacts{i} = matchCompact;
end

match = featureMatching(descs{N}, descs{1}, poss{N}, poss{1});
matchCompact = RANSACMethod(match, poss{N}, orients{N}, descs{N}, poss{1}, orients{1}, descs{1});

matchs{N} = match;
matchCompacts{N} = matchCompact;

disp('IMAGE MATCHING');

for i = 1:(N-1)
    tran = ImageMatching(matchCompacts{i}, poss{i}, poss{i+1});
    trans{i} = tran;
end

tran = ImageMatching(matchCompacts{N}, poss{N}, poss{1});
trans{N} = tran;

disp('IMAGE BLENDING');
imNow = ims{1};
for i  = 2:N
    % normal blending technique
    %imNow = blendImage(imNow, ims{i}, trans{i-1});
    
    % pyramid blending technique
    imNow = blendPyr(imNow, ims{i}, trans{i-1});
end

imNow = blendPyr(imNow, ims{1}, trans{N});


imwrite(uint8(imNow), outFile);
disp('DONE.');

end
