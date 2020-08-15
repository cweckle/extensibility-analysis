function strainvstress;
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
[~, ~, ~, ~, stbmatrix, err] = gatherVideoData();
compnum = getCompositionNumber(myFiles(1).name);
colors = {'r','g','m','b','y'}
rates = {6,18,36,72};
hold on;
for k = 1:size(stbmatrix,2)
    stbline = xline(stbmatrix(compnum,k),'--r',append('STB ',num2str(rates{k})),'LineWidth',2,'LabelHorizontalAlignment','center');
    set(stbline,'Color',colors{k});
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
    
    if contains(fullFileName, 'SR06')
        sr = 1;
    elseif contains(fullFileName, 'SR18')
        sr = 2;
    elseif contains(fullFileName, 'SR36')
        sr = 3;
    elseif contains(fullFileName, 'SR72')
        sr = 4;
    else
        sr = 5;
    end
    
    % Draws background noise lines
%     if sr ~= 5
%         indexesInRange = extensionalstrain > stbmatrix(compnum,sr);
%         strainafterbreak = extensionalstrain(indexesInRange);
%         stressafterbreak = engineeringstress(indexesInRange);
%         
%         bestfit = polyfit(strainafterbreak,stressafterbreak,1);
%         y = bestfit(1)*extensionalstrain + bestfit(2);
%         if sr == 1 || sr == 2
%             noise = plot(extensionalstrain,y,':','LineWidth',2);
%             set(noise, 'Color', 'black');
%         end
%     end
    
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
    graph = plot(extensionalstrain,engineeringstress,'-o','LineWidth',2);
    set(graph, 'Color', colors{sr});
    drawnow;
    
    hold on;
end

% Set figure graphics
title({composition,'Strain Percent vs Engineering Stress'},'FontSize',20);
xlabel("Extensional Strain (%)",'FontSize',15);
ylabel("Engineering Stress (Pa)",'FontSize',15);
xlim([0,inf]);
ylim([-inf,inf]);

% Set legend
h = zeros(4,1);
h(1) = plot(NaN,NaN,'Color','r','Marker','o','LineWidth',2);
h(2) = plot(NaN,NaN,'Color','g','Marker','o','LineWidth',2);
h(3) = plot(NaN,NaN,'Color','m','Marker','o','LineWidth',2);
h(4) = plot(NaN,NaN,'Color','b','Marker','o','LineWidth',2);
legend(h, 'Strain Rate 6','Strain Rate 18','Strain Rate 36','Strain Rate 72','FontSize',13);

message = msgbox('Graphing is done');
	
end