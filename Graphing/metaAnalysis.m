MetaAnalysis = importfile("/Users/elysiasmyers/Documents/MATLAB/Data/Meta-Analysis.csv", [2, Inf]);
yieldStress = MetaAnalysis{:,1};
stb = MetaAnalysis{:,2};
type = MetaAnalysis{:,3};

fullData = MetaAnalysis(:,1:3);

data2D = MetaAnalysis(:,1:2);
stbNaN = isnan(stb);
ysNaN = isnan(yieldStress);
stb1D = 0;
ys1D = 0;

physicalstb = table2array(rmmissing(fullData((fullData{:,3}=="P"),2)));
covalentstb = table2array(rmmissing(fullData((fullData{:,3}=="C"),2)));
unknownstb = table2array(rmmissing(fullData((fullData{:,3}=="U"),2)));

physicalys = table2array(rmmissing(fullData((fullData{:,3}=="P"),1)));
covalentys = table2array(rmmissing(fullData((fullData{:,3}=="C"),1)));
unknownys = table2array(rmmissing(fullData((fullData{:,3}=="U"),1)));

removed = ismissing(data2D);
data2D = rmmissing(data2D);

figure;
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);

subplot(1,1,1);
plot(data2D{:,1},data2D{:,2},'ro','MarkerSize',10,'LineWidth',5);
title('Yield Stress vs Strain to Break','FontSize',20);
xlabel('Yield Stress (Pa)','FontSize',15);
ylabel('Strain to Break (%)','FontSize',15);
hold on;
plot(physicalys,0,'ro','MarkerSize',10,'LineWidth',5);
%plot(unknownys,0,'cv','MarkerSize',10,'LineWidth',5);
plot(0,physicalstb,'ro','MarkerSize',10,'LineWidth',5);
plot(0,covalentstb,'bx','MarkerSize',10,'LineWidth',5);
%plot(0,unknownstb,'cv','MarkerSize',10,'LineWidth',5);

% Set legend
h = zeros(3,1);
h(1) = plot(NaN,NaN,'ro','MarkerSize',10,'LineWidth',5);
h(2) = plot(NaN,NaN,'cv','MarkerSize',10,'LineWidth',5);
h(3) = plot(NaN,NaN,'bx','MarkerSize',10,'LineWidth',5);
legend(h, 'Physical Gels','Unknown Type','Covalent Gels','FontSize',15);


% data1 = physicalys;      %# Sample data set 1
% data2 = covalentys;  %# Sample data set 2
% data3 = unknownys;
% hAxes = axes('NextPlot','add',...           %# Add subsequent plots to the axes,
%              'DataAspectRatio',[1 1 1],...  %#   match the scaling of each axis,
%              'XLim',[0 inf],...               %#   set the x axis limit,
%              'YLim',[0 eps],...
%              'YAxisLocation','left',...
%              'Position',[.13 -.45 .775 1]);               %#   and don't use a background color
% plot(data1,0,'ro','MarkerSize',10);  %# Plot data set 1
% plot(data2,[],'bx','MarkerSize',10);  %# Plot data set 2
% plot(data3,0,'cv','MarkerSize',10);
% 
% data1 = physicalstb;      %# Sample data set 1
% data2 = covalentstb;  %# Sample data set 2
% data3 = unknownstb;
% vAxes = axes('NextPlot','add',...           %# Add subsequent plots to the axes,
%              'DataAspectRatio',[1 1 1],...  %#   match the scaling of each axis,
%              'XLim',[0 eps],...               %#   set the x axis limit,
%              'YLim',[0 inf],...             %#   set the y axis limit (tiny!),
%              'Color','none',...
%              'Position',[-.34 .1 .8 .83]);               %#   and don't use a background color
% plot(0,data1,'ro','MarkerSize',10);  %# Plot data set 1
% plot(0,data2,'bx','MarkerSize',10);  %# Plot data set 2
% plot(0,data3,'cv','MarkerSize',10);
