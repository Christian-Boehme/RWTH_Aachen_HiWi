clc
clear all
close all

%%%%%
% INPUTS
ifname_sim = '../Data/Simulations/Sim_IDT_WS_AIR20.txt';
ifname_exp1 = '../Data/IDT_TaoLi/AIR20_W1.csv';
ifname_exp2 = '../Data/IDT_TaoLi/AIR20_W2.csv';
ifname_exp3 = '../Data/IDT_TaoLi/AIR20_W3.csv';
ofname = 'figures/IDTValidationWS.eps';
markerSize = 75;
markerSizeSim = 10;
alphaValue = 0.5;
markerColor1 = '#ffa500';
markerColor2 = '#0d98ba';
markerColor3 = '#800080';
markerEdgeColor = 'black';
MarkerFaceColorSim = '#e31a1c';
%%%%%

% data
xSim  = readtable(ifname_sim).Var1;
ySim  = readtable(ifname_sim).Var2;
xExp1 = readtable(ifname_exp1).Var1;
yExp1 = readtable(ifname_exp1).Var2;
xExp2 = readtable(ifname_exp2).Var1;
yExp2 = readtable(ifname_exp2).Var2;
xExp3 = readtable(ifname_exp3).Var1;
yExp3 = readtable(ifname_exp3).Var2;

% font
FZ = 25; %30;
per = 0.1;
lw = 2;
set(0, 'defaultAxesFontName', 'Times');
set(0, 'DefaultFigureRenderer', 'painters');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex'); 
set(groot, 'defaultLegendInterpreter', 'latex');
set(0, 'defaultAxesFontSize', FZ);
set(0, 'DefaultLineLineWidth', lw);
%set(0, 'defaultFigurePosition', [2 2 850 500]); %[2 2 1200 380]); % ok or change?
set(gca, 'TickLabelInterpreter', 'latex');
close

close all
figure
set(gcf,'color','w');
scatter(xExp1, yExp1, markerSize, 'filled', 'MarkerFaceColor', ...
    markerColor1, 'MarkerEdgeColor', markerEdgeColor, 'MarkerFaceAlpha', ...
    alphaValue, 'MarkerEdgeAlpha', alphaValue, 'DisplayName', ...
    'Exp. $\overline{D}_\mathrm{P}=127\mathrm{\mu m}$');
hold on
scatter(xExp2, yExp2, markerSize, 'filled', 'MarkerFaceColor', ...
    markerColor2, 'MarkerEdgeColor', markerEdgeColor, 'MarkerFaceAlpha', ...
    alphaValue, 'MarkerEdgeAlpha', alphaValue, 'DisplayName', ...
    'Exp. $\overline{D}_\mathrm{P}=152\mathrm{\mu m}$');
hold on
scatter(xExp3, yExp3, markerSize, 'filled', 'MarkerFaceColor', ...
    markerColor3, 'MarkerEdgeColor', markerEdgeColor, 'MarkerFaceAlpha', ...
    alphaValue, 'MarkerEdgeAlpha', alphaValue, 'DisplayName', ...
    'Exp. $\overline{D}_\mathrm{P}=182\mathrm{\mu m}$');
hold on
plot(xSim, ySim, '-s', 'MarkerFaceColor', MarkerFaceColorSim, 'MarkerSize', markerSizeSim, 'LineWidth', lw+1, 'Color', '#e31a1c', ...
    'DisplayName', 'Sim.');
hold on

xlim([80 200]);
ylim([0 25]); % 20!!!
%xtick_positions = linspace(80, 200, 7);
%set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
ytick_positions = linspace(0, 25, 6);
set(gca, 'YTick', ytick_positions, 'LineWidth', lw);

ylabel('$\tau_\mathrm{ign} \mathrm{[ms]}$','fontsize',FZ,'interpreter','latex', 'FontWeight', 'bold');
xlabel('D$_\mathrm{p} \mathrm{[\mu m]}$','fontsize',FZ,'interpreter','latex', 'FontWeight', 'bold');
legend('show', 'Interpreter', 'latex', 'Location', 'northwest', 'Box', 'off', 'fontsize', FZ);

text(175, 22, '(a) WS', 'Interpreter', 'latex', 'FontSize', FZ, 'FontWeight', 'bold');
%annotation('textbox', [0.815, 0.92, 0.1, 0.1], 'String', '(a) Coal', ...
%           'FontSize', FZ, 'FontWeight', 'bold', 'EdgeColor', 'none', ...
%           'HorizontalAlignment', 'right', 'VerticalAlignment', 'top', 'Interpreter','latex');
set(gca, 'Box', 'on');

saveas(gcf, ofname, 'epsc');
