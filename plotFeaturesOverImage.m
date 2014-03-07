
function plotFeaturesOverImage(im, featureX, featureY, style, filename)

    if ~exist('style')
	style = '+';
    end

    [row, col, channel] = size(im);
    close all;
    imshow(im);
    set(gca,'Units','normalized','Position',[0 0 1 1]);  %# Modify axes size
    set(gcf,'Units','pixels','Position',[1 1 col row]);  %# Modify figure size

    hold on;
    plot(featureX, featureY, style);
    hold off;

    if exist('filename')
	try
	    f = getframe(gcf);
	    imwrite(f.cdata, filename);
	catch
	    print(filename, sprintf('-S%d,%d', size(im, 1), size(im, 2)));
	end_try_catch
    end
end
