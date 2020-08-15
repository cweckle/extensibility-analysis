function main()
    clc;
    clearvars;
    figure;
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    hold on;
    
    heightBefore = redDyeTest('reddyetestbefore.png');
    heightAfter = redDyeTest('reddyetestafter.png');
end

function height = redDyeTest(fullImageFileName)
[rgbImage, storedColorMap] = imread(fullImageFileName);
[~, ~, numberOfColorBands] = size(rgbImage);

if strcmpi(class(rgbImage), 'uint8')
	% Flag for 256 gray levels.
	eightBit = true;
else
	eightBit = false;
end
if numberOfColorBands == 1
	if isempty(storedColorMap)
		% Just a simple gray level image, not indexed with a stored color map.
		% Create a 3D true color image where we copy the monochrome image into all 3 (R, G, & B) color planes.
		rgbImage = cat(3, rgbImage, rgbImage, rgbImage);
	else
		% It's an indexed image.
		rgbImage = ind2rgb(rgbImage, storedColorMap);
		% ind2rgb() will convert it to double and normalize it to the range 0-1.
		% Convert back to uint8 in the range 0-255, if needed.
		if eightBit
			rgbImage = uint8(255 * rgbImage);
		end
    end
end

redBand = rgbImage(:, :, 1);
greenBand = rgbImage(:, :, 2);
blueBand = rgbImage(:, :, 3);

% Take a guess at the values that might work for the user's image.
redThresholdLow = graythresh(redBand);
redThresholdHigh = 255;
greenThresholdLow = 0;
greenThresholdHigh = graythresh(greenBand);
blueThresholdLow = 0;
blueThresholdHigh = graythresh(blueBand);
if eightBit
    redThresholdLow = uint8(redThresholdLow * 255);
    greenThresholdHigh = uint8(greenThresholdHigh * 255);
    blueThresholdHigh = uint8(blueThresholdHigh * 255);
end

redMask = (redBand >= redThresholdLow) & (redBand <= redThresholdHigh);
greenMask = (greenBand >= greenThresholdLow) & (greenBand <= greenThresholdHigh);
blueMask = (blueBand >= blueThresholdLow) & (blueBand <= blueThresholdHigh);

% Get rid of small objects.  Note: bwareaopen returns a logical.
redObjectsMask = uint8(redMask & greenMask & blueMask);
smallestAcceptableArea = 4000;
redObjectsMask = uint8(bwareaopen(redObjectsMask, smallestAcceptableArea));

% Smooth the border using a morphological closing operation, imclose().
structuringElement = strel('disk', 40);
redObjectsMask = imclose(redObjectsMask, structuringElement);

% Fill in any holes in the regions, since they are most likely red also.
redObjectsMask = uint8(imfill(redObjectsMask, 'holes'));

% We need to convert the type of redObjectsMask to the same data type as redBand.
redObjectsMask = cast(redObjectsMask, class(redBand));

% Use the red object mask to mask out the red-only portions of the rgb image.
maskedImageR = redObjectsMask .* redBand; 
maskedImageG = redObjectsMask .* greenBand;
maskedImageB = redObjectsMask .* blueBand;

% Layers the image by adding them in the 3rd dimension.
maskedRGBImage = cat(3, maskedImageR, maskedImageG, maskedImageB);

[labeledImage, numberOfBlobs] = bwlabel(redObjectsMask, 8);
fontSize = 13;
if numberOfBlobs == 1
    subplot(2,2,1);
    imshow(rgbImage);
    title('Original Before Image','FontSize',fontSize);
    subplot(2,2,2);
    imshow(maskedRGBImage);
    title('Processed Before Image', 'FontSize', fontSize);
elseif numberOfBlobs >= 2
    subplot(2,2,3);
    imshow(rgbImage);
    title('Original After Image','FontSize',fontSize);
    subplot(2,2,4);
    imshow(maskedRGBImage);
    title('Processed After Image','FontSize',fontSize);
end

% Get all the blob properties.  Can only pass in originalImage in version R2008a and later.
blobMeasurements = regionprops(labeledImage, redBand, 'BoundingBox');
if numberOfBlobs == 1
    box1 = blobMeasurements.BoundingBox;
    rectangle('Position',box1,'EdgeColor','y','LineWidth',1);
    height = box1(4);
    fprintf(1, 'BEFORE:\n');
    fprintf(1, '\tBefore height: %5d pixels\n', height);
elseif numberOfBlobs == 2
    if blobMeasurements(1).BoundingBox(2) > blobMeasurements(2).BoundingBox(2)
        box1 = blobMeasurements(2);
        box2 = blobMeasurements(1);
    else
        box1 = blobMeasurements(1);
        box2 = blobMeasurements(2);
    end
    fprintf(1,'AFTER:\n');
    rectangle('Position',box1.BoundingBox,'EdgeColor','y','LineWidth',1);
    fprintf(1, '\tUpper BoundingBox height: %5d pixels\n', box1.BoundingBox(4));
    rectangle('Position',box2.BoundingBox,'EdgeColor','y','LineWidth',1);
    fprintf(1, '\tLower BoundingBox height: %5d pixels\n', box2.BoundingBox(4));
    height = box2.BoundingBox(2)+box2.BoundingBox(4)-box1.BoundingBox(2);
    fprintf(1, '\tAfter Height: %5d pixels \n', height);
    linkaxes;
elseif numberOfBlobs == 0
    uiwait(msgbox('No blobs found.'));
else
    drawnow;
    uiwait(msgbox('Too many blobs found. Please play around with minimum object size.'));
end

return;
end

