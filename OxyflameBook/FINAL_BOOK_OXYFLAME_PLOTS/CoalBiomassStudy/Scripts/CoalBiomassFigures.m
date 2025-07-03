clc
clear all
close all
%addpath('/home/cb376114/Programs/Others/Matlab2Tikz/src');
%addpath('/home/cb376114/Programs/Others/ReadCIAOBinaryFiles');

% true = save as tikz; false = save as png
UseTikz = true;
format_eps = false;

% global fonts
FZ = 30;
lw = 1;
set(0, 'defaultAxesFontName', 'Times');
set(0, 'DefaultFigureRenderer', 'painters');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex'); 
set(groot, 'defaultLegendInterpreter', 'latex');
set(0, 'defaultAxesFontSize', FZ);
set(0, 'DefaultLineLineWidth', lw);
set(0, 'defaultFigurePosition', [2 2 700 500]);
set(gca, 'TickLabelInterpreter', 'latex');
close


%
% FGM model

%====
% INPUTS
ifname_1 = '~/NHR/Oxyflame_Book_Transfer/Inputs/ign_B3';
ifname_4 = '~/NHR/Oxyflame_Book_Transfer/Inputs/ign_exp';
ifname_5 = '~/NHR/Oxyflame_Book_Transfer/Inputs/ign_C2_new';
ofname = 'CoalBiomassFigures/FGM_model';
markerSize = 10;
%====

% data
ignB3  = readtable(ifname_1);
ign_exp = readtable(ifname_4);
ignC2_new  = readtable(ifname_5);

% create figure
close all
figure
set(gcf,'color','w');
line([0, 10], [7.191, 7.191], 'LineStyle', '--', 'Color', 'red', ...
    'LineWidth', lw, 'DisplayName', 'SP');
hold on
errorbar(ign_exp.prate , ign_exp.igni, ign_exp.err , 'd', ...
    'MarkerFaceColor', 'black', 'MarkerSize', markerSize, ...
    'LineWidth', lw+1,'Color', 'black', 'DisplayName', 'Exp.');
hold on
errorbar(ignB3.inj, ignB3.OHavg, ignB3.error, '-o', ...
    'MarkerFaceColor', 'red', 'MarkerSize', markerSize, ...
    'LineWidth', lw+1, 'Color', 'red', 'DisplayName', 'FC-CPD');
hold on
errorbar(ignC2_new.inj, ignC2_new.CPD , ignC2_new.CPD_err, '-o', ...
    'MarkerFaceColor', 'blue', 'MarkerSize', markerSize, ...
    'LineWidth', lw+1, 'Color', 'blue', 'DisplayName', 'FGM-CPD');
hold on
errorbar(ignC2_new.inj, ignC2_new.C2SM , ignC2_new.C2SM_err, '-o', ...
    'MarkerFaceColor', 'green', 'MarkerSize', markerSize, ...
    'LineWidth', lw+1, 'Color', 'green', 'DisplayName', 'FGM-C2SM');
hold on
errorbar(ignC2_new.inj, ignC2_new.SFOR , ignC2_new.SFOR_err, '-s', ...
    'MarkerFaceColor', 'magenta', 'MarkerSize', markerSize, ...
    'LineWidth', lw+1, 'Color', 'magenta', 'DisplayName', 'FGM-SFOR');
hold on

xlim([0 10]);
ylim([5 25]);
xtick_positions = linspace(0, 10, 6);
set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
%ytick_positions = linspace(5, 20, 4);
%set(gca, 'YTick', ytick_positions, 'LineWidth', lw);

ylabel('$\tau_\mathrm{ign} \mathrm{[ms]}$', 'fontsize', FZ, ...
    'interpreter', 'latex', 'FontWeight', 'bold');
xlabel('$\dot{N}_\mathrm{inj} \mathrm{[prt/ms]}$','fontsize', FZ, ...
    'interpreter', 'latex', 'FontWeight', 'bold');
legend('show', 'Interpreter', 'latex', 'Location', 'northwest', 'Box', ...
    'off', 'fontsize', FZ-10);
set(gca, 'Box', 'on');

% save figure
if UseTikz
    matlab2tikz(strcat(ofname, '.tikz'));
else
    if format_eps
        saveas(gcf, strcat(ofname, '.eps'), 'epsc');
    else
        saveas(gcf, strcat(ofname, '.png'), 'png');
    end
end

%%

%
%==========
% IDT Coal
%==========

%====
% INPUTS
ifname_sim = '~/NHR/Pooria/SINGLES/PostProcessing/IDT/Data/Simulations/Sim_IDT_Coal_AIR20.txt';
ifname_exp1 = '~/NHR/Pooria/SINGLES/PostProcessing/IDT/Data/IDT_TaoLi/AIR20_C1.csv';
ifname_exp2 = '~/NHR/Pooria/SINGLES/PostProcessing/IDT/Data/IDT_TaoLi/AIR20_C2.csv';
ifname_exp3 = '~/NHR/Pooria/SINGLES/PostProcessing/IDT/Data/IDT_TaoLi/AIR20_C3.csv';
ofname = 'CoalBiomassFigures/IDTValidationCoal';
markerSize = 75;
markerSizeSim = 10;
alphaValue = 0.5;
markerColor1 = '#add8e6';
markerColor2 = '#6495ed';
markerColor3 = '#90ee90';
markerEdgeColor = 'black';
MarkerFaceColorSim = 'red';
%====

% data
xSim  = readtable(ifname_sim).Var1;
ySim  = readtable(ifname_sim).Var2;
xExp1 = readtable(ifname_exp1).Var1;
yExp1 = readtable(ifname_exp1).Var2;
xExp2 = readtable(ifname_exp2).Var1;
yExp2 = readtable(ifname_exp2).Var2;
xExp3 = readtable(ifname_exp3).Var1;
yExp3 = readtable(ifname_exp3).Var2;

% create figure
close all
figure
set(gcf,'color','w');
scatter(xExp1, yExp1, markerSize, 'filled', 'MarkerFaceColor', ...
    markerColor1, 'MarkerEdgeColor', markerEdgeColor, ...
    'MarkerFaceAlpha',alphaValue, 'MarkerEdgeAlpha', alphaValue, ...
    'DisplayName', 'Exp. $\overline{D}_\mathrm{P}=107\mathrm{\mu m}$');
hold on
scatter(xExp2, yExp2, markerSize, 'filled', 'MarkerFaceColor', ...
    markerColor2, 'MarkerEdgeColor', markerEdgeColor, ...
    'MarkerFaceAlpha',alphaValue, 'MarkerEdgeAlpha', alphaValue, ...
    'DisplayName', 'Exp. $\overline{D}_\mathrm{P}=126\mathrm{\mu m}$');
hold on
scatter(xExp3, yExp3, markerSize, 'filled', 'MarkerFaceColor', ...
    markerColor3, 'MarkerEdgeColor', markerEdgeColor, ...
    'MarkerFaceAlpha', alphaValue, 'MarkerEdgeAlpha', alphaValue, ...
    'DisplayName', 'Exp. $\overline{D}_\mathrm{P}=183\mathrm{\mu m}$');
hold on
plot(xSim, ySim, '-s', 'MarkerFaceColor', MarkerFaceColorSim, ...
    'MarkerSize', markerSizeSim, 'LineWidth', lw+1, 'Color', ...
    'red', 'DisplayName', 'Sim.');
hold on

xlim([80 200]);
ylim([0 25]);
xtick_positions = linspace(80, 200, 7);
set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
ytick_positions = linspace(0, 25, 6);
set(gca, 'YTick', ytick_positions, 'LineWidth', lw);

ylabel('$\tau_\mathrm{ign} \mathrm{[ms]}$', 'fontsize', FZ, ...
    'interpreter', 'latex', 'FontWeight', 'bold');
xlabel('D$_\mathrm{p} \mathrm{[\mu m]}$','fontsize', FZ, ...
    'interpreter', 'latex', 'FontWeight', 'bold');
legend('show', 'Interpreter', 'latex', 'Location', 'northwest', 'Box', ...
    'off', 'fontsize', FZ);
text(165, 22, '(a) Coal', 'Interpreter', 'latex', 'FontSize', FZ, ...
    'FontWeight', 'bold');
set(gca, 'Box', 'on');

% save figure
if UseTikz
    matlab2tikz(strcat(ofname, '.tikz'));
else
    if format_eps
        saveas(gcf, strcat(ofname, '.eps'), 'epsc');
    else
        saveas(gcf, strcat(ofname, '.png'), 'png');
    end
end



%==========
% IDT Biomass
%==========

%====
% INPUTS
ifname_sim = '~/NHR/Pooria/SINGLES/PostProcessing/IDT/Data/Simulations/Sim_IDT_WS_AIR20.txt';
ifname_exp1 = '~/NHR/Pooria/SINGLES/PostProcessing/IDT/Data/IDT_TaoLi/AIR20_W1.csv';
ifname_exp2 = '~/NHR/Pooria/SINGLES/PostProcessing/IDT/Data/IDT_TaoLi/AIR20_W2.csv';
ifname_exp3 = '~/NHR/Pooria/SINGLES/PostProcessing/IDT/Data/IDT_TaoLi/AIR20_W3.csv';
ofname = 'CoalBiomassFigures/IDTValidationWS.png';
markerSize = 75;
markerSizeSim = 10;
alphaValue = 0.5;
markerColor1 = '#ffa500';
markerColor2 = '#0d98ba';
markerColor3 = '#800080';
markerEdgeColor = 'black';
MarkerFaceColorSim = 'red';
%====

% data
xSim  = readtable(ifname_sim).Var1;
ySim  = readtable(ifname_sim).Var2;
xExp1 = readtable(ifname_exp1).Var1;
yExp1 = readtable(ifname_exp1).Var2;
xExp2 = readtable(ifname_exp2).Var1;
yExp2 = readtable(ifname_exp2).Var2;
xExp3 = readtable(ifname_exp3).Var1;
yExp3 = readtable(ifname_exp3).Var2;

% create figure
close all
figure
set(gcf,'color','w');
scatter(xExp1, yExp1, markerSize, 'filled', 'MarkerFaceColor', ...
    markerColor1, 'MarkerEdgeColor', markerEdgeColor, ...
    'MarkerFaceAlpha', alphaValue, 'MarkerEdgeAlpha', alphaValue, ...
    'DisplayName', 'Exp. $\overline{D}_\mathrm{P}=107\mathrm{\mu m}$');
hold on
scatter(xExp2, yExp2, markerSize, 'filled', 'MarkerFaceColor', ...
    markerColor2, 'MarkerEdgeColor', markerEdgeColor, ...
    'MarkerFaceAlpha', alphaValue, 'MarkerEdgeAlpha', alphaValue, ...
    'DisplayName', 'Exp. $\overline{D}_\mathrm{P}=152\mathrm{\mu m}$');
hold on
scatter(xExp3, yExp3, markerSize, 'filled', 'MarkerFaceColor', ...
    markerColor3, 'MarkerEdgeColor', markerEdgeColor, ...
    'MarkerFaceAlpha', alphaValue, 'MarkerEdgeAlpha', alphaValue, ...
    'DisplayName', 'Exp. $\overline{D}_\mathrm{P}=182\mathrm{\mu m}$');
hold on
plot(xSim, ySim, '-s', 'MarkerFaceColor', MarkerFaceColorSim, ...
    'MarkerSize', markerSizeSim, 'LineWidth', lw+1, 'Color', ...
    'red', 'DisplayName', 'Sim.');
hold on

xlim([80 200]);
ylim([0 25]);
xtick_positions = linspace(80, 200, 7);
set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
ytick_positions = linspace(0, 25, 6);
set(gca, 'YTick', ytick_positions, 'LineWidth', lw);

ylabel('$\tau_\mathrm{ign} \mathrm{[ms]}$', 'fontsize', FZ, ...
    'interpreter', 'latex', 'FontWeight', 'bold');
xlabel('D$_\mathrm{p} \mathrm{[\mu m]}$', 'fontsize', FZ, ...
    'interpreter', 'latex', 'FontWeight', 'bold');
legend('show', 'Interpreter', 'latex', 'Location', 'northwest', ...
    'Box', 'off', 'fontsize', FZ);

text(165, 22, '(a) WS', 'Interpreter', 'latex', 'FontSize', FZ, ...
    'FontWeight', 'bold');
set(gca, 'Box', 'on');

% save figure
if UseTikz
    matlab2tikz(strcat(ofname, '.tikz'));
else
    if format_eps
        saveas(gcf, strcat(ofname, '.eps'), 'epsc');
    else
        saveas(gcf, strcat(ofname, '.png'), 'png');
    end
end



%==========
% Devotalization rate
%==========

%====
tign_Col = 8.30;
tign_WS = 7.40;
filenameWS = '~/NHR/Pooria/SINGLES/WS/AIR20-DP125/monitor_TaoLi/coal';
fileIDWS = fopen(filenameWS, 'r');
dataWS = readtable(filenameWS, 'Delimiter', '\t');
fclose(fileIDWS);
filenameCol = '~/NHR/Pooria/SINGLES/COL/AIR20-DP125/monitor_TaoLi/coal';
fileIDCol = fopen(filenameCol, 'r');
dataCol = readtable(filenameCol, 'Delimiter', '\t');
fclose(fileIDCol);
%
ofname = 'CoalBiomassFigures/DevRate';
%====

% Extract the columns
xWS = dataWS.time * 1E+03;
yWS = dataWS.rtotmax * 1E+03;
xCol = dataCol.time * 1E+03;
yCol = dataCol.rtotmax * 1E+03;

% create figure
close all
figure
set(gcf,'color','w');
h1 = plot(xCol, yCol, '-', 'LineWidth', lw+1, 'DisplayName', 'Coal', ...
    'Color', 'blue');
hold on
h2 = plot(xWS, yWS, '-', 'LineWidth', lw+1, 'DisplayName', 'WS', ...
    'Color', 'red');
xline(tign_Col, '--', 'Color', 'blue', 'LineWidth', lw+1);
xline(tign_WS, '--', 'Color', 'red', 'LineWidth', lw+1);
xlim([0 14]);
ylim([0 0.0001]);
num_xticks = 8;
xtick_positions = linspace(0, 14, num_xticks);
set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
% Access the current axes
ax = gca;
% Set the exponent of the y-axis (e.g., 10^2)
ax.YAxis.Exponent = -5;
ytick_positions = linspace(0, 0.0001, 6);
set(gca, 'YTick', ytick_positions, 'LineWidth', lw);
%set(gca,'xtick',[]);
%set(gca,'ytick',[]);
set(gca,'TickLabelInterpreter','latex');
xlabel('time [ms]', 'fontsize', FZ, 'interpreter', 'latex');
ylabel('$\dot{m}_\mathrm{vol+moisture}$ [kg/s]', 'fontsize', FZ, ...
    'interpreter','latex');
legend([h1 h2], 'Coal', 'WS', 'Location', 'northwest', 'Box', 'off');

% save figure
if UseTikz
    matlab2tikz(strcat(ofname, '.tikz'));
else
    if format_eps
        saveas(gcf, strcat(ofname, '.eps'), 'epsc');
    else
        saveas(gcf, strcat(ofname, '.png'), 'png');
    end
end



%==========
% Evaporation rate
%==========

%====
tign_Col = 8.30;
tign_WS = 7.40;
filenameWS = '~/NHR/Pooria/SINGLES/WS/AIR20-DP125/monitor_TaoLi/coal';
fileIDWS = fopen(filenameWS, 'r');
dataWS = readtable(filenameWS, 'Delimiter', '\t');
fclose(fileIDWS);
filenameCol = '~/NHR/Pooria/SINGLES/COL/AIR20-DP125/monitor_TaoLi/coal';
fileIDCol = fopen(filenameCol, 'r');
dataCol = readtable(filenameCol, 'Delimiter', '\t');
fclose(fileIDCol);
%
ofname = 'CoalBiomassFigures/EvapRate';
%====

% Extract the columns
xWS = dataWS.time * 1E+03;
yWS = dataWS.MOIST_max * 1E+02;
xCol = dataCol.time * 1E+03;
yCol = dataCol.MOIST_max * 1E+02;

% create figure
close all
figure
set(gcf,'color','w');
h1 = plot(xCol, yCol, '-', 'LineWidth', lw+1, 'DisplayName', 'Coal', ...
    'Color', 'blue');
hold on
h2 = plot(xWS, yWS, '-', 'LineWidth', lw+1, 'DisplayName', 'WS', ...
    'Color', 'red');
xline(tign_Col, '--', 'Color', 'blue', 'LineWidth', lw+1);
xline(tign_WS, '--', 'Color', 'red', 'LineWidth', lw+1);
%hold off
xlim([0 14]);
num_xticks = 8;
xtick_positions = linspace(0, 14, num_xticks);
set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
ytick_positions = linspace(0, 10, 6);
set(gca, 'YTick', ytick_positions, 'LineWidth', lw);
%set(gca,'xtick',[]);
%set(gca,'ytick',[]);
set(gca,'TickLabelInterpreter','latex');
xlabel('time [ms]', 'fontsize', FZ, 'interpreter', 'latex');
ylabel('$\mathrm{Moisture} [\%]$', 'fontsize', FZ, 'interpreter', 'latex');
legend([h1 h2], 'Coal', 'WS', 'Location', 'northeast', 'Box', 'off');

% save figure
if UseTikz
    matlab2tikz(strcat(ofname, '.tikz'));
else
    if format_eps
        saveas(gcf, strcat(ofname, '.eps'), 'epsc');
    else
        saveas(gcf, strcat(ofname, '.png'), 'png');
    end
end



%==========
% Volatile flame stand off distance - size effect
%==========

%====
filename90 = '~/NHR/Pooria/SINGLES/PostProcessing/VolatileFlameStandOffDistance/Data/4_NormalizedGrid/Sim_Coal_EffectOfSize_Air.csv';
fileID90 = fopen(filename90, 'r');
data90 = readtable(filename90, 'Delimiter', '\t');
fclose(fileID90);
filename125 = '~/NHR/Pooria/SINGLES/PostProcessing/VolatileFlameStandOffDistance/Data/4_NormalizedGrid/Sim_WS_EffectOfSize_Air.csv';
fileID125 = fopen(filename125, 'r');
data125 = readtable(filename125, 'Delimiter', '\t');
fclose(fileID125);
%
ofname = 'CoalBiomassFigures/VolFlameDistance_CoalBio_SizeEffect_Air';
%====

% Extract the columns
x90 = data90.Xaxis;
y90 = data90.Data;
x125 = data125.Xaxis;
y125 = data125.Data;

% create figure
close all
figure
set(gcf,'color','w');
h1 = plot(x90, y90, '-s', 'MarkerFaceColor', 'blue', 'LineWidth', ...
    lw+1, 'Color', 'blue', 'DisplayName', 'Coal');
hold on
h2 = plot(x125, y125, '-s', 'MarkerFaceColor', 'red', 'LineWidth', ...
    lw+1, 'Color', 'red', 'DisplayName', 'WS');
hold on
xlim([80 180]);
ylim([0 15]);
%xtick_positions = linspace(80, 160, 5);
%set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
ytick_positions = linspace(0, 15, 6);
set(gca, 'YTick', ytick_positions, 'LineWidth', lw);
%set(gca,'xtick',[]);
%set(gca,'ytick',[]);
set(gca,'TickLabelInterpreter','latex');
text(167, 1.5, '(a)', 'Interpreter', 'latex', 'FontSize', FZ);
xlabel('$D_\mathrm{p} \mathrm{[\mu m]}$', 'fontsize', FZ, ...
    'interpreter', 'latex');
ylabel('$r_\mathrm{f}/r_\mathrm{p}$ [-]', 'fontsize', FZ, ...
    'interpreter', 'latex');
legend('show', 'Interpreter', 'latex', 'Location', 'northeast', 'Box', ...
    'off', 'fontsize', FZ);

% save figure
if UseTikz
    matlab2tikz(strcat(ofname, '.tikz'));
else
    if format_eps
        saveas(gcf, strcat(ofname, '.eps'), 'epsc');
    else
        saveas(gcf, strcat(ofname, '.png'), 'png');
    end
end



%==========
% Devotalization rate per area - size effect
%==========

%====
tign_90  = 4.20;
tign_125 = 7.40;
tign_160 = 11.1;
filename90 = '~/NHR/Pooria/SINGLES/WS/AIR20-DP90/monitor_TaoLi/coal';
fileID90 = fopen(filename90, 'r');
data90 = readtable(filename90, 'Delimiter', '\t');
fclose(fileID90);
filename125 = '~/NHR/Pooria/SINGLES/WS/AIR20-DP125/monitor_TaoLi/coal';
fileID125 = fopen(filename125, 'r');
data125 = readtable(filename125, 'Delimiter', '\t');
fclose(fileID125);
filename160 = '~/NHR/Pooria/SINGLES/WS/AIR20-DP160/monitor_TaoLi/coal';
fileID160 = fopen(filename160, 'r');
data160 = readtable(filename160, 'Delimiter', '\t');
fclose(fileID160);
%
ofname = 'CoalBiomassFigures/DevRatePerArea_WS_SizeEffect';
%====

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

% create figure
close all
figure
set(gcf,'color','w');
h1 = plot(x90, y90, '-', 'LineWidth', lw+1, 'Color', 'blue', ...
    'DisplayName', '$D_\mathrm{p}=90\mathrm{\mu m}$');
hold on
h2 = plot(x125, y125, '-', 'LineWidth', lw+1, 'Color', 'green', ...
    'DisplayName', '$D_\mathrm{p}=125\mathrm{\mu m}$');
hold on
h3 = plot(x160, y160, '-', 'LineWidth', lw+1, 'Color', 'red', ...
    'DisplayName', '$D_\mathrm{p}=160\mathrm{\mu m}$');
hold on
xlim([0 30]);
ylim([0 0.008]);
xtick_positions = linspace(0, 30, 7);
set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
ytick_positions = linspace(0, 0.008, 5);
set(gca, 'YTick', ytick_positions, 'LineWidth', lw);
%set(gca,'xtick',[]);
%set(gca,'ytick',[]);
set(gca,'TickLabelInterpreter','latex');
text(26, 0.0008, '(b)', 'Interpreter', 'latex', 'FontSize', FZ);
xlabel('$t-t_\mathrm{ign}$ [ms]','fontsize', FZ, 'interpreter', 'latex');
ylabel('$\dot{m}_\mathrm{dev}/A_\mathrm{p} \mathrm{[kg/s/mm^{2}]}$', ...
    'fontsize', FZ, 'interpreter', 'latex');
legend('show', 'Interpreter', 'latex', 'Location', 'northeast', 'Box', ...
    'off', 'fontsize', FZ);

% save figure
if UseTikz
    matlab2tikz(strcat(ofname, '.tikz'));
else
    if format_eps
        saveas(gcf, strcat(ofname, '.eps'), 'epsc');
    else
        saveas(gcf, strcat(ofname, '.png'), 'png');
    end
end



%==========
% Volatile flame stand off distance - oxygen congent effect
%==========

%====
filename90 = '~/NHR/Pooria/SINGLES/PostProcessing/VolatileFlameStandOffDistance/Data/4_NormalizedGrid/Sim_Coal_EffectOfOxygenContent_Air.csv';
fileID90 = fopen(filename90, 'r');
data90 = readtable(filename90, 'Delimiter', '\t');
fclose(fileID90);
filename125 = '~/NHR/Pooria/SINGLES/PostProcessing/VolatileFlameStandOffDistance/Data/4_NormalizedGrid/Sim_WS_EffectOfOxygenContent_Air.csv';
fileID125 = fopen(filename125, 'r');
data125 = readtable(filename125, 'Delimiter', '\t');
fclose(fileID125);
%
ofname = 'CoalBiomassFigures/VolFlameDistance_CoalBio_OxygenContent_Air';
%====

% Extract the columns
x90 = data90.Xaxis;
y90 = data90.Data;
x125 = data125.Xaxis;
y125 = data125.Data;

% create figure
close all
figure
set(gcf,'color','w');
h1 = plot(x90, y90, '-s', 'MarkerFaceColor', 'blue', 'LineWidth', ...
    lw+1, 'Color', 'blue', 'DisplayName', 'Coal');
hold on
h2 = plot(x125, y125, '-s', 'MarkerFaceColor', 'red', 'LineWidth', ...
    lw+1, 'Color', 'red', 'DisplayName', 'WS');
hold on
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
xlabel('$X_\mathrm{O_2} \mathrm{[\%]}$', 'fontsize', FZ, ...
    'interpreter', 'latex');
ylabel('$r_\mathrm{f}/r_\mathrm{p}$ [-]', 'fontsize', FZ, ...
    'interpreter', 'latex');
legend('show', 'Interpreter', 'latex', 'Location', 'northeast', 'Box', ...
    'off', 'fontsize', FZ);

% save figure
if UseTikz
    matlab2tikz(strcat(ofname, '.tikz'));
else
    if format_eps
        saveas(gcf, strcat(ofname, '.eps'), 'epsc');
    else
        saveas(gcf, strcat(ofname, '.png'), 'png');
    end
end



%==========
% Devotalization rate per area - size effect
%==========

%====
tign_90  = 7.30;
tign_125 = 7.40;
tign_160 = 7.50;
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
%
ofname = 'CoalBiomassFigures/DevRatePerArea_WS_OxygenContentEffect';
%====

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

% create figure
close all
figure
set(gcf,'color','w');
h1 = plot(x10, y10, '-', 'LineWidth', lw+1, 'Color', 'blue', ...
    'DisplayName', '$X_\mathrm{O_2}=0.1$');
hold on
h2 = plot(x20, y20, '-', 'LineWidth', lw+1, 'Color', 'green', ...
    'DisplayName', '$X_\mathrm{O_2}=0.2$');
hold on
h3 = plot(x40, y40, '-', 'LineWidth', lw+1, 'Color', 'red', ...
    'DisplayName', '$X_\mathrm{O_2}=0.4$');
hold on
xlim([0 30]);
ylim([0 0.006]);
xtick_positions = linspace(0, 30, 7);
set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
ytick_positions = linspace(0, 0.006, 7);
set(gca, 'YTick', ytick_positions, 'LineWidth', lw);
% Access the current axes
ax = gca;
% Set the exponent of the y-axis (e.g., 10^2)
ax.YAxis.Exponent = -3;
ytick_positions = linspace(0, 0.006, 7);
set(gca, 'YTick', ytick_positions, 'LineWidth', lw);
%set(gca,'xtick',[]);
%set(gca,'ytick',[]);
set(gca,'TickLabelInterpreter','latex');
text(26, 0.001, '(b)', 'Interpreter', 'latex', 'FontSize', FZ);
xlabel('$t-t_\mathrm{ign}$ [ms]', 'fontsize',FZ, 'interpreter', 'latex');
ylabel('$\dot{m}_\mathrm{dev}/A_\mathrm{p} \mathrm{[kg/s/mm^{2}]}$', ...
    'fontsize', FZ, 'interpreter', 'latex');
legend('show', 'Interpreter', 'latex', 'Location', 'northeast', 'Box', ...
    'off', 'fontsize', FZ);

% save figure
if UseTikz
    matlab2tikz(strcat(ofname, '.tikz'));
else
    if format_eps
        saveas(gcf, strcat(ofname, '.eps'), 'epsc');
    else
        saveas(gcf, strcat(ofname, '.png'), 'png');
    end
end


%==========
% Single particle model validation - temperature
%==========

%====
% INPUTS
ifname_exp = '~/NHR/NOx_JETS_ICNC24/Post/Validation/JetAndSingle_DTF_Validation/Inputs_Panahi2019/DTF_Experiments_Panahi2019_Tvolatile.txt';
ifname_sim = '~/NHR/NOx_JETS_ICNC24/Post/Validation/JetAndSingle_DTF_Validation/Inputs_Panahi2019/CRECKSC_Tpeak.txt';
ofname = 'CoalBiomassFigures/Panahi2019_Tvolatile';
markerSizeExp = 10;
markerSizeSim = 10;
markerFaceColorExp = 'black';
MarkerFaceColorSim = 'red';
%====

% data
ExpData = readtable(ifname_exp);
SimData = readtable(ifname_sim);

% create figure
close all
figure
set(gcf,'color','w');
errorbar(ExpData.TFurnace, ExpData.Tvol, ...
    ExpData.Tvol - ExpData.TvolMin, ExpData.Tvol - ExpData.TvolMax, ...
    '-x', 'MarkerFaceColor', markerFaceColorExp, 'MarkerSize', ...
    markerSizeExp, 'LineWidth', lw+1, 'Color', 'blue', ...
    'DisplayName', 'Panahi et al.');
hold on
plot(SimData.TFurnace, SimData.TGasPhase, '-s', 'MarkerFaceColor', ...
    MarkerFaceColorSim, 'MarkerSize', markerSizeSim, ...
    'LineWidth', lw+1, 'Color', 'red', ...
    'DisplayName', 'SP simulation');
hold on

xlim([1250 1550]);
ylim([1900 2300]);
xtick_positions = linspace(1300, 1500, 3);
set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
ytick_positions = linspace(1900, 2300, 5);
set(gca, 'YTick', ytick_positions, 'LineWidth', lw);

ylabel('T$_\mathrm{flame} \mathrm{[K]}$', 'fontsize',FZ, ...
    'interpreter', 'latex', 'FontWeight', 'bold');
xlabel('T$_\mathrm{Furnace} \mathrm{[K]}$', 'fontsize', FZ, ...
    'interpreter', 'latex', 'FontWeight', 'bold');
legend('show', 'Interpreter', 'latex', 'Location', 'northwest', 'Box', ...
    'off', 'fontsize', FZ);
text(175, 22, '(a) Coal', 'Interpreter', 'latex', 'FontSize', FZ, ...
    'FontWeight', 'bold');
set(gca, 'Box', 'on');

% save figure
if UseTikz
    matlab2tikz(strcat(ofname, '.tikz'));
else
    if format_eps
        saveas(gcf, strcat(ofname, '.eps'), 'epsc');
    else
        saveas(gcf, strcat(ofname, '.png'), 'png');
    end
end



%==========
% Single particle model validation - NOx
%==========

%====
% INPUTS
ifname_exp = '~/NHR/NOx_JETS_ICNC24/Post/Validation/JetAndSingle_DTF_Validation/Inputs_Panahi2019/DTF_Experiments_Panahi2019_NOx.txt';
ifname_sim = '~/NHR/NOx_JETS_ICNC24/Post/Validation/JetAndSingle_DTF_Validation/Inputs_Panahi2019/CRECKSC_NOx_1s.txt';
ofname = 'CoalBiomassFigures/Panahi2019_NOx';
markerSizeExp = 10;
markerSizeSim = 10;
markerFaceColorExp = 'black';
MarkerFaceColorSim = 'red';
%====

% data
ExpData = readtable(ifname_exp);
SimData = readtable(ifname_sim);

% create figure
close all
figure
set(gcf,'color','w');
errorbar(ExpData.TFurnace, ExpData.XNOx, ...
    ExpData.XNOx - ExpData.XNOxMin, ExpData.XNOx - ExpData.XNOxMax, ...
    '-x', 'MarkerFaceColor', markerFaceColorExp, 'MarkerSize', ...
    markerSizeExp, 'LineWidth', lw+1, 'Color', 'blue', ...
    'DisplayName', 'Panahi et al.');
hold on
plot(SimData.TFurnace, (SimData.DTF90_288 * 60.13 - 95) * 1.0, ...
    '-s', 'MarkerFaceColor', MarkerFaceColorSim, 'MarkerSize', ...
    markerSizeSim, 'LineWidth', lw+1, 'Color', 'red', ...
    'DisplayName', 'SP simulation');
hold on

xlim([1250 1550]);
ylim([0 800]);
xtick_positions = linspace(1300, 1500, 3);
set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
ytick_positions = linspace(0, 800, 5);
set(gca, 'YTick', ytick_positions, 'LineWidth', lw);

ylabel('X$_\mathrm{NO_x} \mathrm{[ppm]}$', 'fontsize', FZ, ...
    'interpreter', 'latex', 'FontWeight', 'bold');
xlabel('T$_\mathrm{Furnace} \mathrm{[K]}$', 'fontsize',FZ, ...
    'interpreter', 'latex', 'FontWeight', 'bold');
legend('show', 'Interpreter', 'latex', 'Location', 'southeast', 'Box', ...
    'off', 'fontsize', FZ);
text(175, 22, '(a) Coal', 'Interpreter', 'latex', 'FontSize', FZ, ...
    'FontWeight', 'bold');
set(gca, 'Box', 'on');

% save figure
if UseTikz
    matlab2tikz(strcat(ofname, '.tikz'));
else
    if format_eps
        saveas(gcf, strcat(ofname, '.eps'), 'epsc');
    else
        saveas(gcf, strcat(ofname, '.png'), 'png');
    end
end






if 1 == 1
    return
end
%%



%==========
% YOH around particle - Coal
%==========

%====
% INPUTS
path = '~/NHR/Pooria/SINGLES/COL/AIR20-DP125/';
ofname = 'CoalBiomassFigures/COL_AIR20_DP125_5subfigures';
tign = 8.3; % [ms]
nfig = 5; % number of subfigures in plot
xcells = 15; % number of x-cells from particle
ycells = 15; % number of y-cells from particle
ulimit = 0.018; % colorbar
x_width = 12;
y_width = 3.5; % for 6 subplots use: 3;
%====

% read in data.out files
dirFiles = dir(fullfile(path, 'data.out_*'));
files = {dirFiles.name};

% sort files numerically
filenum = cellfun(@(x)sscanf(x, 'data.out_%e'), files);
[~,Sidx] = sort(filenum);
filenames_ = files(Sidx);

% clipp files
counter = 0;
filenames = {};
numfile = sort(filenum);
for i = 2:2:length(filenames_)
    %for i = 1:length(filenames_)
    if numfile(i) >= tign/1000
        counter = counter + 1;
        filenames{counter} = filenames_{i};
    end
end

% working directory
home = pwd;

% path directory
cd ( path );

% grid
grid  = CIAO_read_grid(filenames{1});
xm = grid.xm;
ym = grid.ym;
zm = grid.zm;
nx = size(xm,1);
ny = size(ym,1);
nz = size(zm,1);

% correction of xyplain
if ycells * 2 > ny
    ycells = int32(ny / 2) - 1;
    disp(ycells);
end

% font
FZ = 30;
per = 0.1;
lw = 2;
set(0, 'defaultAxesFontName', 'Times');
set(0, 'DefaultFigureRenderer', 'painters');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex'); 
set(groot, 'defaultLegendInterpreter', 'latex');
set(0, 'defaultAxesFontSize', FZ);
set(0, 'DefaultLineLineWidth', lw);
set(0, 'defaultFigurePosition', [2 2 1200 380]);
close

% create figure
close all
figure(1)

globalOHmax = 0;
for fname = 1:nfig
    files = dir(fullfile(path, filenames{fname}));
    filename = files(1).name;

    % read data
    OH = CIAO_read_real(filename,'OH');
    ND_COAL = CIAO_read_real(filename,'ND_COAL');
    time(1) = CIAO_read_real(filename,'time');

    % particle must be in front!
    xplain = 1;
    yplain = 1;
    zplain = 1;
    % particle-plain
    for i = 1:nx
        for j = 1:ny
            for k = 1:nz
                if ND_COAL(i,j,k) == 1
                    xplain = i;
                    yplain = j;
                    zplain = k;
                    break
                end
            end
        end
    end
    
    OHmax = max(max(max(OH(xplain-xcells:xplain+xcells, ...
        yplain-ycells:yplain+ycells,zplain))));
    if globalOHmax < OHmax
        globalOHmax = OHmax;
    end
end

% generate plots for each file/time
for fname = 1:nfig
    fprintf('%s\n', filenames{fname});
    files = dir(fullfile(path, filenames{fname}));
    filename = files(1).name;

    % read data
    OH = CIAO_read_real(filename,'OH');
    ND_COAL = CIAO_read_real(filename,'ND_COAL');
    time(1) = CIAO_read_real(filename,'time');

    % particle must be in front!
    xplain = 1;
    yplain = 1;
    zplain = 1;
    % particle-plain
    for i = 1:nx
        for j = 1:ny
            for k = 1:nz
                if ND_COAL(i,j,k) == 1
                    xplain = i;
                    yplain = j;
                    zplain = k;
                    break
                end
            end
        end
    end

    % create figure
    ax = subplot(1,nfig,fname);

    set(gcf,'color','w');
    s1=pcolor(OH(xplain-xcells:xplain+xcells, ...
        yplain-ycells:yplain+ycells,zplain));
    colormap(ax,jet);
    caxis(ax, [0 ulimit]); %1.1*globalOHmax]);
    %cb = colorbar;
    %cb.Ticks = [0, ulimit/2, ulimit];
    s1.FaceColor = 'interp';
    set(s1,'edgecolor','none');
    axis image
    set(gca,'xtick',[])
    set(gca,'ytick',[])
    set(gca,'TickLabelInterpreter','latex');
    camroll(-90);
    if fname == 1
        t = sprintf('t$_{ign}$');
    else
        t = sprintf('t$_{ign}$+%.0fms', (fname - 1));
    end
    title(t,'fontsize' ,FZ, 'interpreter', 'latex', 'FontName', ...
        'Times', 'FontWeight', 'bold')
    hold on
end

% colorbar poistion
h = colorbar('southoutside');
h.Position = [0.13 0.275 0.775 0.03];
h.Ticks = [0, ulimit/6, ulimit/3, ulimit/2, ulimit/3*2, ulimit/6*5, ...
    ulimit];
h.FontName = ax.FontName;
h.FontWeight = ax.FontWeight;
h.FontSize = FZ-4;


% subfigure positions & make space for the colorbar
%for i = 1:nfig
%    subplot(1, nfig, i);
%    pos = get(gca, 'Position');
%    pos(2) = pos(2) - 0.05;
%    set(gca, 'Position', pos);
%end
ylabel(h,'Y$_\mathrm{OH} \mathrm{[-]}$', 'fontsize', FZ, ...
    'interpreter', 'latex', 'FontWeight', 'bold');
annotation('textbox', [0.815, 0.92, 0.1, 0.1], 'String', '(c) Coal', ...
           'FontSize', FZ, 'FontWeight', 'bold', 'EdgeColor', 'none', ...
           'HorizontalAlignment', 'right', 'VerticalAlignment', ...
           'top', 'Interpreter','latex');

% save figure
cd ( home );
if UseTikz
    matlab2tikz(strcat(ofname, '.tikz'));
else
    if format_eps
        saveas(gcf, strcat(ofname, '.eps'), 'epsc');
    else
        saveas(gcf, strcat(ofname, '.png'), 'png');
    end
end
hold off


%==========
% YOH around particle - Biomass
%==========


%====
% INPUTS
path = '~/NHR/Pooria/SINGLES/WS/AIR20-DP125/';
ofname = '~/NHR/Pooria/SINGLES/PostProcessing/OH_around_particle/figures/WS_AIR20_DP125_5subfigures';
tign = 7.4; % [ms]
nfig = 5; % number of subfigures in plot
xcells = 15; % number of x-cells from particle
ycells = 15; % number of y-cells from particle
ulimit = 0.018; % colorbar
x_width = 12;
y_width = 3.5; % for 6 subplots use: 3;
%====

% read in data.out files
dirFiles = dir(fullfile(path, 'data.out_*'));
files = {dirFiles.name};

% sort files numerically
filenum = cellfun(@(x)sscanf(x, 'data.out_%e'), files);
[~,Sidx] = sort(filenum);
filenames_ = files(Sidx);

% clipp files
counter = 0;
filenames = {};
numfile = sort(filenum);
for i = 2:2:length(filenames_)
    %for i = 1:length(filenames_)
    if numfile(i) >= tign/1000
        counter = counter + 1;
        filenames{counter} = filenames_{i};
    end
end

% working directory
home = pwd;

% path directory
cd ( path );

% grid
grid  = CIAO_read_grid(filenames{1});
xm = grid.xm;
ym = grid.ym;
zm = grid.zm;
nx = size(xm,1);
ny = size(ym,1);
nz = size(zm,1);

% correction of xyplain
if ycells * 2 > ny
    ycells = int32(ny / 2) - 1;
    disp(ycells);
end

% font
FZ = 30;
per = 0.1;
lw = 2;
set(0, 'defaultAxesFontName', 'Times');
set(0, 'DefaultFigureRenderer', 'painters');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex'); 
set(groot, 'defaultLegendInterpreter', 'latex');
set(0, 'defaultAxesFontSize', FZ);
set(0, 'DefaultLineLineWidth', lw);
set(0, 'defaultFigurePosition', [2 2 1200 380]);
close

% create figure
close all
figure(1)

globalOHmax = 0;
for fname = 1:nfig
    files = dir(fullfile(path, filenames{fname}));
    filename = files(1).name;

    % read data
    OH = CIAO_read_real(filename,'OH');
    ND_COAL = CIAO_read_real(filename,'ND_COAL');
    time(1) = CIAO_read_real(filename,'time');

    % particle must be in front!
    xplain = 1;
    yplain = 1;
    zplain = 1;
    % particle-plain
    for i = 1:nx
        for j = 1:ny
            for k = 1:nz
                if ND_COAL(i,j,k) == 1
                    xplain = i;
                    yplain = j;
                    zplain = k;
                    break
                end
            end
        end
    end
    
    OHmax = max(max(max(OH(xplain-xcells:xplain+xcells, ...
        yplain-ycells:yplain+ycells,zplain))));
    if globalOHmax < OHmax
        globalOHmax = OHmax;
    end
end

% generate plots for each file/time
for fname = 1:nfig
    fprintf('%s\n', filenames{fname});
    files = dir(fullfile(path, filenames{fname}));
    filename = files(1).name;

    % read data
    OH = CIAO_read_real(filename,'OH');
    ND_COAL = CIAO_read_real(filename,'ND_COAL');
    time(1) = CIAO_read_real(filename,'time');

    % particle must be in front!
    xplain = 1;
    yplain = 1;
    zplain = 1;
    % particle-plain
    for i = 1:nx
        for j = 1:ny
            for k = 1:nz
                if ND_COAL(i,j,k) == 1
                    xplain = i;
                    yplain = j;
                    zplain = k;
                    break
                end
            end
        end
    end

    % create figure
    ax = subplot(1,nfig,fname);

    set(gcf,'color','w');
    s1=pcolor(OH(xplain-xcells:xplain+xcells, ...
        yplain-ycells:yplain+ycells,zplain));
    colormap(ax,jet);
    caxis(ax, [0 ulimit]); %1.1*globalOHmax]);
    %cb = colorbar;
    %cb.Ticks = [0, ulimit/2, ulimit];
    s1.FaceColor = 'interp';
    set(s1,'edgecolor','none');
    axis image
    set(gca,'xtick',[])
    set(gca,'ytick',[])
    set(gca,'TickLabelInterpreter','latex');
    camroll(-90);
    if fname == 1
        t = sprintf('t$_{ign}$');
    else
        t = sprintf('t$_{ign}$+%.0fms', (fname - 1));
    end
    title(t,'fontsize', FZ, 'interpreter', 'latex', 'FontName', ...
        'Times', 'FontWeight', 'bold')
    hold on
end

% colorbar poistion
h = colorbar('southoutside');
h.Position = [0.13 0.275 0.775 0.03];
h.Ticks = [0, ulimit/6, ulimit/3, ulimit/2, ulimit/3*2, ulimit/6*5, ...
    ulimit];
h.FontName = ax.FontName;
h.FontWeight = ax.FontWeight;
h.FontSize = FZ-4;


% subfigure positions & make space for the colorbar
%for i = 1:nfig
%    subplot(1, nfig, i);
%    pos = get(gca, 'Position');
%    pos(2) = pos(2) - 0.05;
%    set(gca, 'Position', pos);
%end
ylabel(h,'Y$_\mathrm{OH} \mathrm{[-]}$', 'fontsize', FZ, ...
    'interpreter', 'latex', 'FontWeight', 'bold');
annotation('textbox', [0.815, 0.92, 0.1, 0.1], 'String', '(d) WS', ...
           'FontSize', FZ, 'FontWeight', 'bold', 'EdgeColor', 'none', ...
           'HorizontalAlignment', 'right', 'VerticalAlignment', ...
           'top', 'Interpreter','latex');

% save figure
cd ( home );
if UseTikz
    matlab2tikz(strcat(ofname, '.tikz'));
else
    if format_eps
        saveas(gcf, strcat(ofname, '.eps'), 'epsc');
    else
        saveas(gcf, strcat(ofname, '.png'), 'png');
    end
end
hold off

