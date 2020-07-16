clc;
clearvars;

% Create set of files within the input directory
inputdir = '/Users/elysiasmyers/Documents/MATLAB/Data/';
myDir = uigetdir; %gets directory
myFiles = dir(fullfile(myDir,'*.txt')); %gets all txt files in struct
figure;

% Extracts composition from the file name
idx = strfind(myFiles(1).name,'SR');
composition = strrep(myFiles(1).name(1:idx-1),'_',' ');

% Plots STB lines // can be commented out if testing just strain v stress
[~, ~, ~, ~, ~, ~, stbmatrix, err] = gatherVideoData();
compnum = getCompositionNumber(myFiles(1).name);
rates = {6,18,36,72};
hold on;
for k = 1:size(stbmatrix,2)
    xline(stbmatrix(compnum,k),'--r',append('STB ',num2str(rates{k})),'LineWidth',2,'LabelHorizontalAlignment','center');
end

% Goes through each file and plots strain v stress
for k = 1:length(myFiles)
    baseFileName = myFiles(k).name;
    fullFileName = fullfile(myDir, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);

    forcedata = importdata(fullFileName,'\t',54);
    forcematrix = forcedata.data;

    engineeringstress = -1*forcematrix(:,4);
    extensionalstrain = forcematrix(:,3)*100;
        
    graph = plot(extensionalstrain,engineeringstress,'-o','LineWidth',2);
    if contains(fullFileName, 'SR06')
        set(graph, 'Color', 'r');
    elseif contains(fullFileName, 'SR18')
        set(graph, 'Color', 'g');
    elseif contains(fullFileName, 'SR36')
        set(graph, 'Color', 'm');
    elseif contains(fullFileName, 'SR72')
        set(graph, 'Color', 'b');
    else 
        set(graph, 'Color', 'y');
    end
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    drawnow;
    
    hold on;
end

% Set figure graphics
title({composition,'Strain Percent vs Engineering Stress'},'FontSize',20);
xlabel("Extensional Strain (%)",'FontSize',15);
ylabel("Engineering Stress (Pa)",'FontSize',15);
xlim([0,inf]);

% Set legend
h = zeros(4,1);
h(1) = plot(NaN,NaN,'Color','r','Marker','o','LineWidth',2);
h(2) = plot(NaN,NaN,'Color','g','Marker','o','LineWidth',2);
h(3) = plot(NaN,NaN,'Color','m','Marker','o','LineWidth',2);
h(4) = plot(NaN,NaN,'Color','b','Marker','o','LineWidth',2);
legend(h, 'Strain Rate 6','Strain Rate 18','Strain Rate 36','Strain Rate 72','FontSize',13);

message = msgbox('Graphing is done');
	