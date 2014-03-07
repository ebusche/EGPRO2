function main()

sequence = 'capitols';      % sequence name
rootPath = ['C:/Users/Emily/p2/' sequence];     % root path of the sequence
outFile = [sequence '_stitched.png'];       % output stitched file.
N = 3;     % number of images in the sequence
focal_length = 660.8799;     % focal length
debug_ = 1;     % output debug msg?



disp('[feature detection] begin...');
tic;
for i = 1:N
    src_img_file = sprintf('%s/%02d.jpg', rootPath, (i));
    disp(sprintf('processing... %s', src_img_file));
    
    [fx, fy, pos, orient, desc, im, R] = featureDetection(src_img_file, focal_length, 1, debug_);
    ims{i} = im;
    fxs{i} = fx;
    fys{i} = fy;
    poss{i} = pos;
    orients{i} = orient;
    descs{i} = desc;
end

toc;
disp('[feature detection] end...');
disp(' ');




disp('[feature matching] begin...');
tic;
for i = 1:(N-1)
    
    match = featureMatching(descs{i}, descs{i+1}, poss{i}, poss{i+1});
    matchCompact = ransac(match, poss{i}, orients{i}, descs{i}, poss{i+1}, orients{i+1}, descs{i+1});
    matchs{i} = match;
    matchCompacts{i} = matchCompact;
end

match = featureMatching(descs{N}, descs{1}, poss{N}, poss{1});
matchCompact = ransac(match, poss{N}, orients{N}, descs{N}, poss{1}, orients{1}, descs{1});

matchs{N} = match;
matchCompacts{N} = matchCompact;


toc;
disp('[feature matching] end...');
disp(' ');

disp('[image matching] begin...');
tic;

for i = 1:(N-1)
    tran = solverTranslation(matchCompacts{i}, poss{i}, poss{i+1});
    trans{i} = tran;
end


tran = solverTranslation(matchCompacts{N}, poss{N}, poss{1});
trans{N} = tran;


toc;
disp('[image matching] end...');
disp(' ');

disp('[image blending] begin...');
tic;
imNow = ims{1};
for i  = 2:N
    disp(sprintf('merge %d and %d with tran (%d, %d)', (i-1), i, trans{i-1}(1), trans{i-1}(2)));
    %imNow = blendImage(imNow, ims{i}, trans{i-1});
    imNow = blendPyr(imNow, ims{i}, trans{i-1});
end

imNow = blendPyr(imNow, ims{1}, trans{N});


imwrite(uint8(imNow), outFile);
disp(sprintf('save to file:%s', outFile));
toc;
disp('[image blending] end...');
disp(' ');

disp('done!');

end
