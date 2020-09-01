function height = processImage(f,rgbImage)
%[rgbImage, ~] = imread(fullFileName);
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

[labeledImage, numberOfBlobs] = bwlabel(BW, 8);
blobMeasurements = regionprops(labeledImage, BW, 'BoundingBox');

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

if numberOfBlobs == 1
    box1 = blobMeasurements.BoundingBox;
    rectangle('Position',box1,'EdgeColor','y','LineWidth',1);
    height = box1(4);
elseif numberOfBlobs == 2
    if blobMeasurements(1).BoundingBox(2) > blobMeasurements(2).BoundingBox(2)
        box1 = blobMeasurements(2);
        box2 = blobMeasurements(1);
    else
        box1 = blobMeasurements(1);
        box2 = blobMeasurements(2);
    end
    rectangle('Position',box1.BoundingBox,'EdgeColor','y','LineWidth',1);
    rectangle('Position',box2.BoundingBox,'EdgeColor','y','LineWidth',1);
    height = box2.BoundingBox(2)+box2.BoundingBox(4)-box1.BoundingBox(2);
    linkaxes;
elseif numberOfBlobs == 0
    uiwait(msgbox('No blobs found.'));
else
    drawnow;
    uiwait(msgbox('Too many blobs found. Please play around with minimum object size.'));
end

end
