function videoAnalysis()
inputdir = '/Users/elysiasmyers/Documents/MATLAB/Data/';
myDir = uigetdir; %gets directory
myFiles = dir(fullfile(myDir,'*.MOV')); %gets all MOV files in struct

% initializes the necessary cell arrays where data will be added
file = cell(length(myFiles),1);
strainInPixels = cell(length(myFiles),1);
lengthBefore = cell(length(myFiles),1);
lengthAfter = cell(length(myFiles),1);
fprintf(num2str(length(myFiles)));

for k = 1:length(myFiles)
    baseFileName = myFiles(k).name;
    fullFileName = fullfile(myDir, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    file{k,1} = baseFileName;
    
    vidObj = VideoReader(baseFileName);
    firstFrame = readFrame(vidObj);
    f = figure('NumberTitle','off','Name',append('Measuring ',baseFileName));
    set(gcf, 'units','normalized','outerposition',[0 0 0.5 1]);
    hold on;
    
    lengthBefore{k,1} = processImage(f,firstFrame);
    counter = 1;
    subplot(2,2,3);
    imshow(firstFrame);
    drawnow;
    hold on;
    while hasFrame(vidObj)
        vidFrame = readFrame(vidObj);
        vidFrame = readFrame(vidObj);
        imshow(vidFrame);
        title(append('Current frame: ',num2str(counter)));
        drawnow;
        if numberOfBlobs(vidFrame) == 2
            lengthAfter{k,1} = processImage(f,vidFrame);
            break;
        end
        counter = counter +2;
    end
end

deltaLength = cellfun(@minus,lengthAfter,lengthBefore,'UniformOutput',false);
T = table(file,lengthBefore,lengthAfter,deltaLength);
writetable(T, 'extensibilitydata.txt');
type extensibilitydata.txt

end
