clc
clear
close all
addpath('~/NHR/DE_Analysis/MatlabFunctions');


% ================================
% calculate and visualize the reaction zone thickness 
% based on DNS data
% NOTE: 1) double arrow to indicate the reaction zone thickness must be 
% manually modified (depends on figure size)
%       2) reaction zone thickness for case 4 is a complex number -> real
% ================================


%====
% INPUTS
%====
hdf5_data_path = ['~/itv/OXYFLAME-B3/File_Transfer/DE_analysis_code/' ...
    'trajSearch/Dataset'];
cases= {'traj_Tbox_ign.h5', 'traj_Tbox_OHmax.h5', ...
    'traj_Tbox_fullComb.h5', 'traj_Tbox_finish.h5'};
Fig_outdir = '../../Figures/DNS_DataBased/';
ofname = 'ReactionZoneThickness';
header = {'t=0.50ms', 't=0.65ms', 't=0.75ms', 't=1.00ms'};
% inputs for CellDataAvg()
n_bins = 200;
sf = 0.01;
factor= 2e-5;
% boundary limits of figure
Figxmax = 0.24;
Figymax = 8E10;
% number of x-ticks
nxticks = 5;
% number of y-ticks
nytics = 5;
% annotation inputs
LabHeight = 6.5E10;
AnnHeight = 0.75;
DistArrLab = 3E9;
% cell size DNS
dx = 5E-5;
% save figure in [png, eps, pdf]
FigFormat = 'png';
%====


% create output directory
if Fig_outdir(end) ~= '/'
    Fig_outdir = [Fig_outdir, '/'];
end
if ~exist(Fig_outdir,'dir')
    mkdir(Fig_outdir);
end


% output file in output dir
ofname = strcat(Fig_outdir, ofname);


% total number of cases
tc = length(cases);

% global fonts
FZ = 20;
lw = 1;
set(0, 'defaultAxesFontName', 'Times');
set(0, 'DefaultFigureRenderer', 'painters');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex'); 
set(groot, 'defaultLegendInterpreter', 'latex');
set(0, 'defaultAxesFontSize', FZ);
set(0, 'DefaultLineLineWidth', lw);
set(0, 'defaultFigurePosition', [2 2 600 500]);
set(gca, 'TickLabelInterpreter', 'latex');
close


% read data
HR = cell(1,tc);
Zmix = cell(1,tc);
edata_dble = cell(1,tc);
for i = 1:length(cases)
    % HR
    HR{i} = h5read(strcat(hdf5_data_path ,'/', cases{i}), ...
        '/scalar/HR');
    % Zmix
    Zmix{i} = h5read(strcat(hdf5_data_path ,'/', cases{i}), ...
        '/scalar/ZMIX');
    % edata_dble
    edata_dble{i} = h5read(strcat(hdf5_data_path ,'/', cases{i}), ...
        '/traj_full/edata_dble');
end


% calculate DE parameter
l = cell(1,tc);
lm = cell(1,tc);
ln = cell(1,tc);
phi = cell(1,tc);
phim = cell(1,tc);
phin = cell(1,tc);
g = cell(1,tc);
gn = cell(1,tc);
for i = 1:length(cases)
    l{i}=edata_dble{i}(7,:) .* dx;
    lm{i}=mean(edata_dble{i}(7,:) .* dx);
    ln{i} = l{i}./lm{i};
    phi{i} = edata_dble{i}(10,:);
    phim{i} = mean(edata_dble{i}(10,:));
    phin{i} = phi{i}./phim{i};
    g{i} = phi{i}./l{i};
    gn{i} = (phi{i}./phim{i})./(l{i}./lm{i});
end


%% create figure
set(0,'defaultFigurePosition', [2 2 1600, 500])
%close all
figure(1)
tl = tiledlayout(1, 4, 'Padding', 'compact', 'TileSpacing', 'compact');

% figure 1
ax(1) = nexttile(1);
set(gcf,'color','w');
set(gca, 'Box', 'on');
hold on
XData = squeeze(Zmix{1}(:));
YData = squeeze(HR{1}(:));
% ZData = XData;
c_max1 = max(size(XData),[],'all');
[x1_data,avg_data] = CellDataAvg(XData, YData, n_bins, ...
    [min(XData) max(XData)], 1, sf, factor);
z_dir = zeros(size(x1_data, 1), 1) + c_max1 + 1;
plot3(x1_data, avg_data, z_dir, 'k', 'LineWidth', lw+1);
[PDF_x1, PDF_x2, PDF_y] = Compute_PDF_histograms_2D(XData, YData, n_bins);
PDF_y=log10(PDF_y);
s=imagesc(ax(1), PDF_x1, PDF_x2, PDF_y);
set(s, 'AlphaData', ~isnan(PDF_y))
set(gca,'YDir','normal')
% [x1, x2, cond_mean] = ComputeConditionalMeanHistograms2D(ZData, ...
%     XData, YData, n_bins);
% s=imagesc(x1, x2, cond_mean);
% set(s, 'AlphaData', ~isnan(cond_mean));
% set(gca, 'YDir', 'normal');
% hold on;

% reaction zone thickness (Niemietz 2024)
dZr = ComputeReactionZoneThickness(YData, XData);
[~, max_idx] = max(YData);
Z_wmax = XData(max_idx);

% axis limits
xlim([0 Figxmax]);
ylim([0 Figymax]);

% ticks modification
xtick_positions = linspace(0, Figxmax, nxticks);
set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
ytick_positions = linspace(0, Figymax, nytics);
set(gca, 'YTick', ytick_positions, 'LineWidth', lw);

% annotation
hold on
if Z_wmax - 0.5*dZr > 0
    xline(Z_wmax - 0.5*dZr, '--k', 'LineWidth', lw+1, ...
        'HandleVisibility', 'off');
else
    xline(0, '--k', 'LineWidth', lw+1, 'HandleVisibility', 'off');
end
hold on
xline(Z_wmax + 0.5*dZr, '--k', 'LineWidth', lw+1, ...
    'HandleVisibility', 'off');
hold on
arrowX = [Z_wmax - 0.5*dZr, Z_wmax + 0.5*dZr];
arrowY = [LabHeight, LabHeight];
% normalized to figure size ! not to coordinates !
annotation("doublearrow", [0.08, 0.15], [AnnHeight, AnnHeight]);
Label = '$\delta{Z_{\mathrm{r}}}$';
text(mean(arrowX), arrowY(1) + DistArrLab, ...
    Label, 'HorizontalAlignment', 'center', ...
    'FontSize', FZ, 'Color', 'k', 'Interpreter', 'latex');

% labels and title
xtickangle(0);
xlabel('$Z \mathrm{[-]}$', 'fontsize', FZ, ...
    'interpreter', 'latex', 'FontWeight', 'bold');
ylabel('$\omega_\mathrm{T} \mathrm{[J/m^{3}/s]}$', 'fontsize', FZ, ...
    'interpreter', 'latex', 'FontWeight', 'bold');
title(header{1}, 'Interpreter', 'latex', 'FontSize', FZ);


% figure 2
ax(2) = nexttile(2);
set(gcf,'color','w');
set(gca, 'Box', 'on');
hold on
XData = squeeze(Zmix{2}(:));
YData = squeeze(HR{2}(:));
% ZData = XData;
c_max1 = max(size(XData),[],'all');
[x1_data,avg_data] = CellDataAvg(XData, YData, n_bins, ...
    [min(XData) max(XData)], 1, sf, factor);
z_dir = zeros(size(x1_data, 1), 1) + c_max1 + 1;
plot3(x1_data, avg_data, z_dir, 'k', 'LineWidth', lw+1);
[PDF_x1, PDF_x2, PDF_y] = Compute_PDF_histograms_2D(XData, YData, n_bins);
PDF_y=log10(PDF_y);
s=imagesc(ax(2), PDF_x1, PDF_x2, PDF_y);
set(s, 'AlphaData', ~isnan(PDF_y))
set(gca,'YDir','normal')
% [x1, x2, cond_mean] = ComputeConditionalMeanHistograms2D(ZData, ...
%     XData, YData, n_bins);
% s=imagesc(x1, x2, cond_mean);
% set(s, 'AlphaData', ~isnan(cond_mean));
% set(gca, 'YDir', 'normal');
% hold on;

% reaction zone thickness (Niemietz 2024)
dZr = ComputeReactionZoneThickness(YData, XData);
[~, max_idx] = max(YData);
Z_wmax = XData(max_idx);

% axis limits
xlim([0 Figxmax]);
ylim([0 Figymax]);

% ticks modification
xtick_positions = linspace(0, Figxmax, nxticks);
set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
ytick_positions = linspace(0, Figymax, nytics);
set(gca, 'YTick', ytick_positions, 'LineWidth', lw);

% annotation
hold on
if Z_wmax - 0.5*dZr > 0
    xline(Z_wmax - 0.5*dZr, '--k', 'LineWidth', lw+1, ...
        'HandleVisibility', 'off');
else
    xline(0, '--k', 'LineWidth', lw+1, 'HandleVisibility', 'off');
end
hold on
xline(Z_wmax + 0.5*dZr, '--k', 'LineWidth', lw+1, ...
    'HandleVisibility', 'off');
hold on
arrowX = [Z_wmax - 0.5*dZr, Z_wmax + 0.5*dZr];
arrowY = [LabHeight, LabHeight];
% normalized to figure size ! not to coordinates !
annotation("doublearrow", [0.31, 0.475], [AnnHeight, AnnHeight]);
Label = '$\delta{Z_{\mathrm{r}}}$';
text(mean(arrowX), arrowY(1) + DistArrLab, ...
    Label, 'HorizontalAlignment', 'center', ...
    'FontSize', FZ, 'Color', 'k', 'Interpreter', 'latex');

% labels and title
xtickangle(0);
xlabel('$Z \mathrm{[-]}$', 'fontsize', FZ, ...
    'interpreter', 'latex', 'FontWeight', 'bold');
ylabel('$\omega_\mathrm{T} \mathrm{[J/m^{3}/s]}$', 'fontsize', FZ, ...
    'interpreter', 'latex', 'FontWeight', 'bold');
title(header{2}, 'Interpreter', 'latex', 'FontSize', FZ);


% figure 3
ax(3) = nexttile(3);
set(gcf,'color','w');
set(gca, 'Box', 'on');
hold on
XData = squeeze(Zmix{3}(:));
YData = squeeze(HR{3}(:));
% ZData = XData;
c_max1 = max(size(XData),[],'all');
[x1_data,avg_data] = CellDataAvg(XData, YData, n_bins, ...
    [min(XData) max(XData)], 1, sf, factor);
z_dir = zeros(size(x1_data, 1), 1) + c_max1 + 1;
plot3(x1_data, avg_data, z_dir, 'k', 'LineWidth', lw+1);
[PDF_x1, PDF_x2, PDF_y] = Compute_PDF_histograms_2D(XData, YData, n_bins);
PDF_y=log10(PDF_y);
s=imagesc(ax(3), PDF_x1, PDF_x2, PDF_y);
set(s, 'AlphaData', ~isnan(PDF_y))
set(gca,'YDir','normal')
% [x1, x2, cond_mean] = ComputeConditionalMeanHistograms2D(ZData, ...
%     XData, YData, n_bins);
% s=imagesc(x1, x2, cond_mean);
% set(s, 'AlphaData', ~isnan(cond_mean));
% set(gca, 'YDir', 'normal');
% hold on;

% reaction zone thickness (Niemietz 2024)
dZr = ComputeReactionZoneThickness(YData, XData);
[~, max_idx] = max(YData);
Z_wmax = XData(max_idx);

% axis limits
xlim([0 Figxmax]);
ylim([0 Figymax]);

% ticks modification
xtick_positions = linspace(0, Figxmax, nxticks);
set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
ytick_positions = linspace(0, Figymax, nytics);
set(gca, 'YTick', ytick_positions, 'LineWidth', lw);

% annotation
hold on
if Z_wmax - 0.5*dZr > 0
    xline(Z_wmax - 0.5*dZr, '--k', 'LineWidth', lw+1, ...
        'HandleVisibility', 'off');
else
    xline(0, '--k', 'LineWidth', lw+1, 'HandleVisibility', 'off');
end
hold on
xline(Z_wmax + 0.5*dZr, '--k', 'LineWidth', lw+1, ...
    'HandleVisibility', 'off');
hold on
arrowX = [Z_wmax - 0.5*dZr, Z_wmax + 0.5*dZr];
arrowY = [LabHeight, LabHeight];
% normalized to figure size ! not to coordinates !
annotation("doublearrow", [0.56, 0.685], [AnnHeight, AnnHeight]);
Label = '$\delta{Z_{\mathrm{r}}}$';
text(mean(arrowX), arrowY(1) + DistArrLab, ...
    Label, 'HorizontalAlignment', 'center', ...
    'FontSize', FZ, 'Color', 'k', 'Interpreter', 'latex');

% labels and title
xtickangle(0);
xlabel('$Z \mathrm{[-]}$', 'fontsize', FZ, ...
    'interpreter', 'latex', 'FontWeight', 'bold');
ylabel('$\omega_\mathrm{T} \mathrm{[J/m^{3}/s]}$', 'fontsize', FZ, ...
    'interpreter', 'latex', 'FontWeight', 'bold');
title(header{3}, 'Interpreter', 'latex', 'FontSize', FZ);


% figure 4
ax(4) = nexttile(4);
set(gcf,'color','w');
set(gca, 'Box', 'on');
hold on
XData = squeeze(Zmix{4}(:));
YData = squeeze(HR{4}(:));
% ZData = XData;
c_max1 = max(size(XData),[],'all');
[x1_data,avg_data] = CellDataAvg(XData, YData, n_bins, ...
    [min(XData) max(XData)], 1, sf, factor);
z_dir = zeros(size(x1_data, 1), 1) + c_max1 + 1;
plot3(x1_data, avg_data, z_dir, 'k', 'LineWidth', lw+1);
[PDF_x1, PDF_x2, PDF_y] = Compute_PDF_histograms_2D(XData, YData, n_bins);
PDF_y=log10(PDF_y);
s=imagesc(ax(4), PDF_x1, PDF_x2, PDF_y);
set(s, 'AlphaData', ~isnan(PDF_y))
set(gca,'YDir','normal')
% [x1, x2, cond_mean] = ComputeConditionalMeanHistograms2D(ZData, ...
%     XData, YData, n_bins);
% s=imagesc(x1, x2, cond_mean);
% set(s, 'AlphaData', ~isnan(cond_mean));
% set(gca, 'YDir', 'normal');
% hold on;

% reaction zone thickness (Niemietz 2024)
dZr = ComputeReactionZoneThickness(YData, XData);
[~, max_idx] = max(YData);
Z_wmax = XData(max_idx);

% axis limits
xlim([0 Figxmax]);
ylim([0 Figymax]);

% ticks modification
xtick_positions = linspace(0, Figxmax, nxticks);
set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
ytick_positions = linspace(0, Figymax, nytics);
set(gca, 'YTick', ytick_positions, 'LineWidth', lw);

% annotation
hold on
if ~isreal(dZr)
    dZr = real(dZr);
    fprintf(['\nComplex number for reaction zone thickness ' ...
        'calculated - dZr is set to the real part of the ' ...
        'complex number: %e'], dZr);
end
if Z_wmax - 0.5*dZr > 0
    xline(Z_wmax - 0.5*dZr, '--k', 'LineWidth', lw+1, ...
        'HandleVisibility', 'off');
else
    xline(0, '--k', 'LineWidth', lw+1, 'HandleVisibility', 'off');
end
hold on
xline(Z_wmax + 0.5*dZr, '--k', 'LineWidth', lw+1, ...
    'HandleVisibility', 'off');
hold on
arrowX = [Z_wmax - 0.5*dZr, Z_wmax + 0.5*dZr];
arrowY = [LabHeight, LabHeight];
% normalized to figure size ! not to coordinates !
annotation("doublearrow", [0.817, 0.817], [AnnHeight, AnnHeight]);
Label = '$\delta{Z_{\mathrm{r}}}$';
text(mean(arrowX), arrowY(1) + DistArrLab, ...
    Label, 'HorizontalAlignment', 'center', ...
    'FontSize', FZ, 'Color', 'k', 'Interpreter', 'latex');

% labels and title
xtickangle(0);
xlabel('$Z \mathrm{[-]}$', 'fontsize', FZ, ...
    'interpreter', 'latex', 'FontWeight', 'bold');
ylabel('$\omega_\mathrm{T} \mathrm{[J/m^{3}/s]}$', 'fontsize', FZ, ...
    'interpreter', 'latex', 'FontWeight', 'bold');
title(header{4}, 'Interpreter', 'latex', 'FontSize', FZ);


% save figure
if strcmp(FigFormat, 'png')
    saveas(gca, strcat(ofname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(gca, strcat(ofname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(gca, strcat(ofname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end
