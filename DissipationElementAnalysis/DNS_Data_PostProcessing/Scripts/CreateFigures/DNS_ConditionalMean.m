clc
clear
close all
addpath('~/NHR/DE_Analysis/MatlabFunctions');


% ================================
% calculates and visualizes the conditional mean
% of certain variables based on DNS data over
% mixture fraction
% ================================


%====
% INPUTS
%====
hdf5_data_path = ['~/itv/OXYFLAME-B3/File_Transfer/DE_analysis_code/' ...
    'trajSearch/Dataset'];
cases= {'traj_Tbox_ign.h5', 'traj_Tbox_OHmax.h5', ...
    'traj_Tbox_fullComb.h5', 'traj_Tbox_finish.h5'};
Fig_outdir = '../../Figures/DNS_DataBased/';
ofname = 'ConditionalMean_';
header = {'t=0.5ms', 't=0.65ms', 't=0.75ms', 't=1.0ms'};
% variable on y-axis [Chi; Enth; HR; PV; PVnorm; Tgas; YOH]
% one or multiple variables
var = {'Chi', 'Enth', 'HR', 'PV', 'PVnorm', 'Tgas', 'YOH'};
% inputs for CellDataAvg()
n_bins = 50; %200;
sf = 0.01;
factor= 2e-5;
% number of ticks (nytics will be updated manually for each variable)
nxtics = 4;
nytics = 5;
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
tc = length(cases);
Chi = cell(1,tc);
Cp = cell(1,tc);
Enth = cell(1,tc);
HR = cell(1,tc);
Lambda = cell(1,tc);
PV = cell(1,tc);
PVnorm = cell(1,tc);
Rho = cell(1,tc);
Tgas = cell(1,tc);
YOH = cell(1,tc);
Zmix = cell(1,tc);
edata_dble = cell(1,tc);
for i = 1:length(cases)
    % dissipation rate
    Chi{i} = h5read(strcat(hdf5_data_path ,'/', cases{i}), ...
        '/scalar/dissp_rate');
    % Enthalpy
    Enth{i} = h5read(strcat(hdf5_data_path ,'/', cases{i}), ...
        '/scalar/Enthalpy');
    % HR
    HR{i} = h5read(strcat(hdf5_data_path ,'/', cases{i}), ...
        '/scalar/HR');
    % PV
    PV{i} = h5read(strcat(hdf5_data_path ,'/', cases{i}), ...
        '/scalar/PV');
    % PV normalized
    PVnorm{i} = h5read(strcat(hdf5_data_path ,'/', cases{i}), ...
        '/scalar/PV_norm');
    % Tgas
    Tgas{i} = h5read(strcat(hdf5_data_path ,'/', cases{i}), ...
        '/scalar/T');
    % YOH
    YOH{i} = h5read(strcat(hdf5_data_path ,'/', cases{i}), ...
        '/scalar/OH');
    % Zmix
    Zmix{i} = h5read(strcat(hdf5_data_path ,'/', cases{i}), ...
        '/scalar/ZMIX');
end


%% create figure
for i = 1:length(var)

    % get variable
    var_ = var{i};

    % x-axis variable
    xaxis_var = Zmix;
    cblabel = '$Z_\mathrm{mix} \mathrm{[-]}$';
    loXLim = 0;
    %upXLim = max(cellfun(@(x) max(x(:)), xaxis_var));
    upXLim = 0.30;

    % y-axis variable
    switch(var_)
        case 'Chi'
            yaxis_var = Chi;
            yaxis_label = '$\chi \mathrm{[1/s]}$';
            loYLim = 0;
            upYLim = max(cellfun(@(x) max(x(:)), yaxis_var));
            fprintf('Variable "%s" -> upper y-axis limit: %e\n', ...
                var_, upYLim);
            upYLim = 5000;
            nytics = 6;
        case 'Enth'
            yaxis_var = Enth;
            yaxis_label = '$H \mathrm{[kJ/kg]}$';       % TODO correct??
            loYLim = min(cellfun(@(x) min(x(:)), yaxis_var));
            upYLim = max(cellfun(@(x) max(x(:)), yaxis_var));
            fprintf('Variable "%s" -> lower y-axis limit: %e\n', ...
                var_, loYLim);
            fprintf('Variable "%s" -> upper y-axis limit: %e\n', ...
                var_, upYLim);
            loYLim = -1600;
            upYLim = -400;
        case 'HR'
            yaxis_var = HR;
            yaxis_label = '$\omega_\mathrm{T} \mathrm{[J/m^{3}/s]}$';
            loYLim = 0;
            upYLim = max(cellfun(@(x) max(x(:)), yaxis_var));
            fprintf('Variable "%s" -> upper y-axis limit: %e\n', ...
                var_, upYLim);
            upYLim = 7E10;
            nytics = 8;
        case 'PV'
            yaxis_var = PV;
            yaxis_label = '$PV \mathrm{[-]}$';
            loYLim = 0;
            upYLim = max(cellfun(@(x) max(x(:)), yaxis_var));
            fprintf('Variable "%s" -> upper y-axis limit: %e\n', ...
                var_, upYLim);
            upYLim = 0.009;
            nytics = 4;
        case 'PVnorm'
            yaxis_var = PVnorm;
            yaxis_label = '$PV_\mathrm{norm} \mathrm{[-]}$';
            loYLim = 0;
            upYLim = max(cellfun(@(x) max(x(:)), yaxis_var));
            fprintf('Variable "%s" -> upper y-axis limit: %e\n', ...
                var_, upYLim);
            nytics = 6;
        case 'Tgas'
            yaxis_var = Tgas;
            yaxis_label = '$T_\mathrm{gas} \mathrm{[K]}$';
            loYLim = 800;
            upYLim = max(cellfun(@(x) max(x(:)), yaxis_var));
            fprintf('Variable "%s" -> upper y-axis limit: %e\n', ...
                var_, upYLim);
            upYLim = 2400;
        case 'YOH'
            yaxis_var = YOH;
            yaxis_label = '$Y_\mathrm{OH} \mathrm{[-]}$';
            loYLim = 0;
            upYLim = max(cellfun(@(x) max(x(:)), yaxis_var));
            fprintf('Variable "%s" -> upper y-axis limit: %e\n', ...
                var_, upYLim);
            upYLim = 0.015;
            nytics = 6;
        otherwise
            fprintf('\nInvalid input!');
            return
    end

    % figure format
    set(0,'defaultFigurePosition', [2 2 1600, 500])
    close all
    figure(1)
    tl = tiledlayout(1, 4, 'Padding', 'compact', 'TileSpacing', 'compact');


    % figure 1
    ax(1) = nexttile(1);
    set(gcf,'color','w');
    set(gca, 'Box', 'on');
    hold on
    XData = squeeze(xaxis_var{1}(:));
    YData = squeeze(yaxis_var{1}(:));
    % ZData = XData;
    c_max1 = max(size(XData),[],'all');
    [x1_data,avg_data] = CellDataAvg(XData, YData, n_bins, ...
        [min(XData) max(XData)], 1, sf, factor);
    z_dir = zeros(size(x1_data, 1), 1) + c_max1 + 1;
    plot3(x1_data, avg_data, z_dir, 'k', 'LineWidth', lw+1);
    [PDF_x1, PDF_x2, PDF_y] = Compute_PDF_histograms_2D(XData, YData, ...
        n_bins);
    PDF_y=log10(PDF_y);
    s=imagesc(ax(1), PDF_x1, PDF_x2, PDF_y);
    set(s, 'AlphaData', ~isnan(PDF_y))
    set(gca,'YDir','normal')
    % [x1, x2, cond_mean] = Compute_ConditionalMean_histograms_2D(ZData, ...
    %     XData, YData, n_bins);
    % s=imagesc(x1, x2, cond_mean);
    % set(s, 'AlphaData', ~isnan(cond_mean));
    % set(gca, 'YDir', 'normal');
    % hold on;

    % axis limits
    xlim([loXLim upXLim]);
    ylim([loYLim upYLim]);
    
    % ticks modification
    xtick_positions = linspace(loXLim, upXLim, nxtics);
    set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
    ytick_positions = linspace(loYLim, upYLim, nytics);
    set(gca, 'YTick', ytick_positions, 'LineWidth', lw);

    % labels and title
    xlabel('$Z \mathrm{[-]}$', 'fontsize', FZ, ...
        'interpreter', 'latex', 'FontWeight', 'bold');
    ylabel(yaxis_label, 'fontsize', FZ, 'interpreter', 'latex', ...
        'FontWeight', 'bold');
    title(header{1}, 'Interpreter', 'latex', 'FontSize', FZ);


    % figure 2
    ax(2) = nexttile(2);
    set(gcf,'color','w');
    set(gca, 'Box', 'on');
    hold on
    XData = squeeze(xaxis_var{2}(:));
    YData = squeeze(yaxis_var{2}(:));
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
    % [x1, x2, cond_mean] = Compute_ConditionalMean_histograms_2D(ZData, ...
    %     XData, YData, n_bins);
    % s=imagesc(x1, x2, cond_mean);
    % set(s, 'AlphaData', ~isnan(cond_mean));
    % set(gca, 'YDir', 'normal');
    % hold on;

    % axis limits
    xlim([loXLim upXLim]);
    ylim([loYLim upYLim]);
    
    % ticks modification
    xtick_positions = linspace(loXLim, upXLim, nxtics);
    set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
    ytick_positions = linspace(loYLim, upYLim, nytics);
    set(gca, 'YTick', ytick_positions, 'LineWidth', lw);

    % labels and title
    xlabel('$Z \mathrm{[-]}$', 'fontsize', FZ, ...
        'interpreter', 'latex', 'FontWeight', 'bold');
    ylabel(yaxis_label, 'fontsize', FZ, 'interpreter', 'latex', ...
        'FontWeight', 'bold');
    title(header{2}, 'Interpreter', 'latex', 'FontSize', FZ);


    % figure 3
    ax(3) = nexttile(3);
    set(gcf,'color','w');
    set(gca, 'Box', 'on');
    hold on
    XData = squeeze(xaxis_var{3}(:));
    YData = squeeze(yaxis_var{3}(:));
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
    % [x1, x2, cond_mean] = Compute_ConditionalMean_histograms_2D(ZData, ...
    %     XData, YData, n_bins);
    % s=imagesc(x1, x2, cond_mean);
    % set(s, 'AlphaData', ~isnan(cond_mean));
    % set(gca, 'YDir', 'normal');
    % hold on;

    % axis limits
    xlim([loXLim upXLim]);
    ylim([loYLim upYLim]);
    
    % ticks modification
    xtick_positions = linspace(loXLim, upXLim, nxtics);
    set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
    ytick_positions = linspace(loYLim, upYLim, nytics);
    set(gca, 'YTick', ytick_positions, 'LineWidth', lw);

    % labels and title
    xlabel('$Z \mathrm{[-]}$', 'fontsize', FZ, ...
        'interpreter', 'latex', 'FontWeight', 'bold');
    ylabel(yaxis_label, 'fontsize', FZ, 'interpreter', 'latex', ...
        'FontWeight', 'bold');
    title(header{3}, 'Interpreter', 'latex', 'FontSize', FZ);


    % figure 4
    ax(4) = nexttile(4);
    set(gcf,'color','w');
    set(gca, 'Box', 'on');
    hold on
    XData = squeeze(xaxis_var{4}(:));
    YData = squeeze(yaxis_var{4}(:));
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
    % [x1, x2, cond_mean] = Compute_ConditionalMean_histograms_2D(ZData, ...
    %     XData, YData, n_bins);
    % s=imagesc(x1, x2, cond_mean);
    % set(s, 'AlphaData', ~isnan(cond_mean));
    % set(gca, 'YDir', 'normal');
    % hold on;

    % axis limits
    xlim([loXLim upXLim]);
    ylim([loYLim upYLim]);
    
    % ticks modification
    xtick_positions = linspace(loXLim, upXLim, nxtics);
    set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
    ytick_positions = linspace(loYLim, upYLim, nytics);
    set(gca, 'YTick', ytick_positions, 'LineWidth', lw);

    % labels and title
    xlabel('$Z \mathrm{[-]}$', 'fontsize', FZ, ...
        'interpreter', 'latex', 'FontWeight', 'bold');
    ylabel(yaxis_label, 'fontsize', FZ, 'interpreter', 'latex', ...
        'FontWeight', 'bold');
    title(header{4}, 'Interpreter', 'latex', 'FontSize', FZ);

    
    % rename output-file
    ofname_ = strcat(ofname, var_);

    % save figure
    if strcmp(FigFormat, 'png')
        saveas(gca, strcat(ofname_, '.png'), 'png');
    elseif strcmp(FigFormat, 'eps')
        saveas(gca, strcat(ofname_, '.eps'), 'epsc');
    elseif strcmp(FigFormat, 'pdf')
        exportgraphics(gca, strcat(ofname_, '.pdf'), ...
            'ContentType', 'vector');
    else
        fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
            FigFormat);
        return
    end
end