clc
clear all
close all
addpath('/home/cb376114/master-thesis/ReadCIAOBinaryFiles');

filename90 = '~/p0021020/Pooria/SINGLES/PostProcessing/VolatileFlameStandOffDistance/Data/4_NormalizedGrid/Sim_Coal_EffectOfOxygenContent_Air.csv';
fileID90 = fopen(filename90, 'r');
data90 = readtable(filename90, 'Delimiter', '\t');
fclose(fileID90);
filename125 = '~/p0021020/Pooria/SINGLES/PostProcessing/VolatileFlameStandOffDistance/Data/4_NormalizedGrid/Sim_WS_EffectOfOxygenContent_Air.csv';
fileID125 = fopen(filename125, 'r');
data125 = readtable(filename125, 'Delimiter', '\t');
fclose(fileID125);

% Extract the columns
x90 = data90.Xaxis;
y90 = data90.Data;
x125 = data125.Xaxis;
y125 = data125.Data;

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
h1 = plot(x90, y90, '-s', 'LineWidth', lw+1, 'Color', '#1f78b4', 'DisplayName', 'Coal');
hold on
h2 = plot(x125, y125, '-s', 'LineWidth', lw+1, 'Color', '#e31a1c', 'DisplayName', 'WS');
hold on
%h4 = plot(xC90, yC90, ':', 'LineWidth', lw+1, 'Color', '#1f78b4');
%xline(tign_90, '--', 'Color', '#1f78b4', 'LineWidth', lw+1);
%xline(tign_125, '--', 'Color', '#e31a1c', 'LineWidth', lw+1);
%hold off
xlim([0 50]);
ylim([0 15]);
xtick_positions = linspace(0, 50, 6);
set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
ytick_positions = linspace(0, 15, 6);
set(gca, 'YTick', ytick_positions, 'LineWidth', lw);
%set(gca,'xtick',[]);
%set(gca,'ytick',[]);
set(gca,'TickLabelInterpreter','latex');
text(43, 1.5, '(a)', 'Interpreter', 'latex', 'FontSize', FZ);
xlabel('$X_\mathrm{O_2}$ [-]','fontsize',FZ,'interpreter','latex');
ylabel('$r_\mathrm{f}/r_\mathrm{p}$ [-]','fontsize',FZ,'interpreter','latex');
%legend([h1 h2 h3], '$D_\mathrm{p}=90µm$', '$D_\mathrm{p}=125µm$', '$D_\mathrm{p}=160µm$', 'Location', 'northeast', 'Box', 'off', 'fontsize', FZ, 'interpreter', 'latex');
legend('show', 'Interpreter', 'latex', 'Location', 'northeast', 'Box', 'off', 'fontsize', FZ);

%set(gcf, 'PaperUnits', 'Inches');
%set(gcf, 'PaperPosition', [0 0 8 5]);
saveas(gcf, 'figures/VolFlameDistance_CoalBio_OxygenContent_Air.eps', 'epsc');
