function num = numberOfBlobs(rgbImage)
%[rgbImage, ~] = imread(vidFrame);
[BW,maskedRGBImage] = createMask(rgbImage);

% Get rid of small objects.  Note: bwareaopen returns a logical.
smallestAcceptableArea = 100;
BW = uint8(bwareaopen(BW, smallestAcceptableArea));

% Smooth the border using a morphological closing operation, imclose().
structuringElement = strel('disk', 20);
BW = imclose(BW, structuringElement);

% Fill in any holes in the regions, since they are most likely red also.
BW = uint8(imfill(BW, 'holes'));

% We need to convert the type of redObjectsMask to the same data type as redBand.
BW = cast(BW, class(maskedRGBImage));

[~, num] = bwlabel(BW, 8);
end