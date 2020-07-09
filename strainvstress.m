clc;
clearvars;

inputdir = '/Users/elysiasmyers/Documents/MATLAB/Data/';
myDir = uigetdir; %gets directory
myFiles = dir(fullfile(myDir,'*.txt')); %gets all wav files in struct
figure;
for k = 1:length(myFiles)
    baseFileName = myFiles(k).name;
    fullFileName = fullfile(myDir, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);

    forcedata = importdata(fullFileName,'\t',54);
    forcematrix = forcedata.data;

    engineeringstress = -1*forcematrix(:,4);
    extensionalstrain = forcematrix(:,3)*100;

    graph = plot(extensionalstrain,engineeringstress);
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    drawnow;
    
    title('Strain Percent vs Engineering Stress');
    xlabel("Extensional Strain (%)");
    ylabel("Engineering Stress (Pa)");
    xlim([0,inf]);
    graph.LineWidth = 2;
    graph.Marker = 'o';
    
    hold on;
end

message = msgbox('Graphing is done');
	