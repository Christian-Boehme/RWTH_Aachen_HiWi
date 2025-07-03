clc
clear all
close all
addpath('/home/cb376114/master-thesis/ReadCIAOBinaryFiles');

tign_Col = 8.30;
tign_WS = 7.40;
filenameWS = '~/p0021020/Pooria/SINGLES/WS/AIR20-DP125/monitor_TaoLi/coal';
fileIDWS = fopen(filenameWS, 'r');
dataWS = readtable(filenameWS, 'Delimiter', '\t');
fclose(fileIDWS);
filenameCol = '~/p0021020/Pooria/SINGLES/COL/AIR20-DP125/monitor_TaoLi/coal';
fileIDCol = fopen(filenameCol, 'r');
dataCol = readtable(filenameCol, 'Delimiter', '\t');
fclose(fileIDCol);

% Extract the columns
xWS = dataWS.time * 1E+03;
yWS = dataWS.rtotmax * 1E+03;
xCol = dataCol.time * 1E+03;
yCol = dataCol.rtotmax * 1E+03;

%
FZ = 22;
per = 0.1;
lw = 2;
set(0,'defaultAxesFontName','Times');
set(0, 'DefaultFigureRenderer', 'painters');

set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');
set(0,'defaultAxesFontSize',FZ);
set(0, 'DefaultLineLineWidth', lw);
set(0, 'defaultFigurePosition', [2 2 550 400]);
close

close all
figure
set(gcf,'color','w');
h1 = plot(xCol, yCol, '-', 'LineWidth', lw+1, 'DisplayName', 'Coal', 'Color', '#1f78b4');
hold on
h2 = plot(xWS, yWS, '-', 'LineWidth', lw+1, 'DisplayName', 'WS', 'Color', '#e31a1c');
xline(tign_Col, '--', 'Color', '#1f78b4', 'LineWidth', lw+1);
xline(tign_WS, '--', 'Color', '#e31a1c', 'LineWidth', lw+1);
%hold off
xlim([0 14]);
num_xticks = 8;
xtick_positions = linspace(0, 14, num_xticks);
set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
ytick_positions = linspace(0, 0.0001, 6);
set(gca, 'YTick', ytick_positions, 'LineWidth', lw);
%set(gca,'xtick',[]);
%set(gca,'ytick',[]);
set(gca,'TickLabelInterpreter','latex');
xlabel('time [ms]','fontsize',FZ,'interpreter','latex');
ylabel('$\dot{m}_\mathrm{vol+moisture}$ [kg/s]','fontsize',FZ,'interpreter','latex');
legend([h1 h2], 'Coal', 'WS', 'Location', 'northwest', 'Box', 'off');

%set(gcf, 'PaperUnits', 'Inches');
%set(gcf, 'PaperPosition', [0 0 8 5]);
saveas(gcf, 'figures/DevRate.eps', 'epsc');
