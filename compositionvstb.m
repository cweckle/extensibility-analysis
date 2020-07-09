clc;
clearvars;

analysisdata = importdata('Video Analysis - Data.tsv');
trialbytrial = analysisdata.textdata;
metadata = analysisdata.data;

composition = rmmissing(trialbytrial(2:end,2));
strainrate = rmmissing(trialbytrial(2:end,3));
stbstd = rmmissing(metadata(:,4));
trial = trialbytrial(2:end,4);
avgstb = rmmissing(metadata(:,3));
compositiondims = size(unique(composition));

datamatrix = zeros(compositiondims(1),4);
err = zeros(compositiondims(1),4);
index = 1;
for r = 1:size(datamatrix,1)
    for c = 1:size(datamatrix,2)
        datamatrix(r,c) = avgstb(index);
        err(r,c) = stbstd(index);
        index = index + 1;
    end
end

figure;
compvstb = bar(datamatrix,'FaceColor','flat');
compvstb(1).FaceColor = [0 0.4470 0.7410];
compvstb(2).FaceColor = 'cyan';
compvstb(3).FaceColor = 'yellow';
compvstb(4).FaceColor = '#c959cf';
hold on;
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
drawnow;

set(gca,'xtick',1:size(unique(composition)),'xticklabel',unique(composition));
xlabel('Composition','FontSize',15);
ylabel('Average Strain to Break','FontSize',15);
title('Trends in Strain to Break','FontSize',20);

ngroups = size(datamatrix, 1);
nbars = size(datamatrix, 2);
% Calculating the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    errorbar(x, datamatrix(:,i), err(:,i), '.', 'LineWidth',2,'Color','k');
end

lgd = legend({'Strain Rate 6', 'Strain Rate 18', 'Strain Rate 36', 'Strain Rate 72'},'Position',[.15,.7,.1,.2]);

% text(ones(size(avgstb)), avgstb, strainrate, 'HorizontalAlignment','center', 'VerticalAlignment','bottom')

message = msgbox('Graphing is done');
	