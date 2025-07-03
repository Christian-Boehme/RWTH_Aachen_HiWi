clc
clear all
close all
%addpath('/home/cb376114/master-thesis/ReadCIAOBinaryFiles');
addpath('/home/jj343181/ReadCIAOBinaryFiles');
tign_90  = 7.30;
tign_125 = 7.40;
tign_160 = 7.50;
%tign_C90 = 4.50;
filename90 = '~/NHR/Pooria/SINGLES/WS/AIR10-DP125/monitor_TaoLi/coal';
fileID90 = fopen(filename90, 'r');
data90 = readtable(filename90, 'Delimiter', '\t');
fclose(fileID90);
filename125 = '~/NHR/Pooria/SINGLES/WS/AIR20-DP125/monitor_TaoLi/coal';
fileID125 = fopen(filename125, 'r');
data125 = readtable(filename125, 'Delimiter', '\t');
fclose(fileID125);
filename160 = '~/NHR/Pooria/SINGLES/WS/AIR40-DP125/monitor_TaoLi/coal';
fileID160 = fopen(filename160, 'r');
data160 = readtable(filename160, 'Delimiter', '\t');
fclose(fileID160);
%filenameC90 = '~/NHR/Pooria/SINGLES/COL/AIR20-DP90/monitor_TaoLi/coal';
%fileIDC90 = fopen(filenameC90, 'r');
%dataC90 = readtable(filenameC90, 'Delimiter', '\t');
%fclose(fileIDC90);

A90  = 0.25*pi*(0.090^2);
A125 = 0.25*pi*(0.125^2);
A160 = 0.25*pi*(0.160^2);

% Extract the columns
x90 = data90.time * 1E+03 - tign_90;
y90 = data90.rtotmax * 1E+03 / A90;
x125 = data125.time * 1E+03 - tign_125;
y125 = data125.rtotmax * 1E+03 / A125;
x160 = data160.time * 1E+03 - tign_160;
y160 = data160.rtotmax * 1E+03 / A160;

x10 = data90.time * 1E+03 - tign_90;
y10 = data90.rtotmax * 1E+03 / A125;
x20 = data125.time * 1E+03 - tign_125;
y20 = data125.rtotmax * 1E+03 / A125;
x40 = data160.time * 1E+03 - tign_160;
y40 = data160.rtotmax * 1E+03 / A125;

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
h1 = plot(x10, y10, '-', 'LineWidth', lw+1, 'Color', '#1f78b4', 'DisplayName', '$X_\mathrm{O_2}=0.1$');
hold on
h2 = plot(x20, y20, '-', 'LineWidth', lw+1, 'Color', '#33a02c', 'DisplayName', '$X_\mathrm{O_2}=0.2$');
hold on
h3 = plot(x40, y40, '-', 'LineWidth', lw+1, 'Color', '#e31a1c', 'DisplayName', '$X_\mathrm{O_2}=0.4$');
hold on
%h4 = plot(xC90, yC90, ':', 'LineWidth', lw+1, 'Color', '#1f78b4');
%xline(tign_90, '--', 'Color', '#1f78b4', 'LineWidth', lw+1);
%xline(tign_125, '--', 'Color', '#e31a1c', 'LineWidth', lw+1);
%hold off
xlim([0 30]);
xtick_positions = linspace(0, 30, 7);
set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
%yticks = get(gca, 'YTick');
%yticklabels = arrayfun(@(y) sprintf('%.0e', y), yticks, 'UniformOutput', false);
%set(gca, 'YTickLabel', yticklabels);
%ytickformat(ax, '%e')
% Access the current axes
ax = gca;
% Set the exponent of the y-axis (e.g., 10^2)
ax.YAxis.Exponent = -2;
ytick_positions = linspace(0, 0.01, 6);
set(gca, 'YTick', ytick_positions, 'LineWidth', lw);
%set(gca,'xtick',[]);
%set(gca,'ytick',[]);
set(gca,'TickLabelInterpreter','latex');
text(26, 0.001, '(b)', 'Interpreter', 'latex', 'FontSize', FZ);
xlabel('$t-t_\mathrm{ign}$ [ms]','fontsize',FZ,'interpreter','latex');
ylabel('$\dot{m}_\mathrm{dev}/A_\mathrm{p} \mathrm{[kg/s/mm^{2}]}$','fontsize',FZ,'interpreter','latex');
%legend([h1 h2 h3], '$D_\mathrm{p}=90µm$', '$D_\mathrm{p}=125µm$', '$D_\mathrm{p}=160µm$', 'Location', 'northeast', 'Box', 'off', 'fontsize', FZ, 'interpreter', 'latex');
legend('show', 'Interpreter', 'latex', 'Location', 'northeast', 'Box', 'off', 'fontsize', FZ);

%set(gcf, 'PaperUnits', 'Inches');
%set(gcf, 'PaperPosition', [0 0 8 5]);
saveas(gcf, 'figures/DevRatePerArea_WS_OxygenContentEffect.eps', 'epsc');
