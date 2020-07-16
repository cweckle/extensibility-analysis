function main()
inputdir = '/Users/elysiasmyers/Documents/MATLAB/Data/';
myDir = uigetdir; %gets directory
myFiles = dir(fullfile(myDir,'*.MOV')); %gets all MOV files in struct

file = cell(length(myFiles),1);
strainInPixels = cell(length(myFiles),1);
lengthBefore = cell(length(myFiles),1);
lengthAfter = cell(length(myFiles),1);

for k = 1:length(myFiles)
    baseFileName = myFiles(k).name;
    fullFileName = fullfile(myDir, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    file{k,1} = baseFileName;
    
    vidObj = VideoReader(baseFileName);
    firstFrame = readFrame(vidObj);
    f = figure('NumberTitle','off','Name',append('Measuring ',baseFileName));
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    hold on;
    
    lengthBefore{k,1} = extensibilityMeasurements(f,firstFrame);
    counter = 1;
    subplot(2,2,3);
    title(num2str(counter));
    hold on;
    while hasFrame(vidObj)
        vidFrame = readFrame(vidObj);
        imshow(vidFrame);
        title(append('Current frame: ',num2str(counter)));
        pause((1/vidObj.FrameRate)/10);
        if numberOfBlobs(vidFrame) == 2
            lengthAfter{k,1} = extensibilityMeasurements(f,vidFrame);
            break;
        end
        counter = counter +1;
    end
end

deltaLength = cellfun(@minus,lengthAfter,lengthBefore,'UniformOutput',false);
T = table(file,lengthBefore,lengthAfter,deltaLength);
writetable(T, 'extensibilitydata.txt');
type extensibilitydata.txt

end
