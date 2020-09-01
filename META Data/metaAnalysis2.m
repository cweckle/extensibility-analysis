unknown2D = importfile("Unknown 2D.csv");
singlemol1D = importfile("Single-Mol 1D.csv");
physical2D = importfile("Physical 2D.csv");
physical1D = importfile("Physical 1D.csv");
covalent1D = importfile("Covalent 1D.csv");
ourgels2D = importdata("Our Data.csv").data;

figure;
set(gcf, 'units','normalized','outerposition',[.3 .25 .4 .5]);
set(gca, 'XScale', 'log','XTickLabels',[],'YTickLabels',[]);
set(gcf,'color','w');

%subplot(1,1,1);
hold on;
semilogx(physical2D{:,1},physical2D{:,2},'ro','MarkerSize',7,'LineWidth',2);
semilogx(ourgels2D(:,1),ourgels2D(:,2),'d','Color',[0 0.4470 0.7410],'MarkerSize',7,'LineWidth',2);
allphysicalstb = rmmissing([physical2D{:,2};physical1D{:,2}]);
yline(max(physical2D{:,2}),'r--','LineWidth',2);
%yline(mean(allphysicalstb,'omitnan'),'r--','LineWidth',2);
ylim([0 700]);
xlim([.01 250]);

title('Meta-Analysis of Physical Gels + Our Data','FontSize',20);
xlabel('Yield Stress (Pa)','FontSize',15);
ylabel('Strain to Break (%)','FontSize',15);
hold on;

% Set legend
h = zeros(3,1);
h(1) = plot(NaN,NaN,'ro','MarkerSize',7,'LineWidth',2);
h(2) = plot(NaN,NaN,'r--','LineWidth',2);
%h(3) = plot(NaN,NaN,'bx','MarkerSize',7,'LineWidth',2);
h(3) = plot(NaN,NaN,'kd','MarkerSize',7,'LineWidth',2);
legend(h, 'Physical Gels','Max. of Physical Gels','HPMC-C12 PEG-PLA','FontSize',15);


data1 = rmmissing(physical1D{:,1});      %# Sample data set 1
hAxes = axes('NextPlot','add',...           %# Add subsequent plots to the axes,
             'DataAspectRatio',[1 1 1],...  %#   match the scaling of each axis,
             'XLim',[0.01 250],...               %#   set the x axis limit,
             'YLim',[0 eps],...
             'YAxisLocation','left',...
             'Position',[.13 -.45 .775 1],...
             'XScale','log');               %#   and don't use a background color
plot(data1,0,'ro','MarkerSize',7,'LineWidth',2);  %# Plot data set 1

data1 = rmmissing(physical1D{:,2});      %# Sample data set 1
data2 = covalent1D{:,2};  %# Sample data set 2
vAxes = axes('NextPlot','add',...           %# Add subsequent plots to the axes,
             'DataAspectRatio',[1 1 1],...  %#   match the scaling of each axis,
             'XLim',[0 eps],...               %#   set the x axis limit,
             'YLim',[0 700],...             %#   set the y axis limit (tiny!),
             'Color','none',...
             'Position',[-.34 .11 .82 .814]);               %#   and don't use a background color
plot(0,data1,'ro','MarkerSize',7,'LineWidth',2);  %# Plot data set 1
%plot(0,data2,'bx','MarkerSize',7,'LineWidth',2);  %# Plot data set 2
