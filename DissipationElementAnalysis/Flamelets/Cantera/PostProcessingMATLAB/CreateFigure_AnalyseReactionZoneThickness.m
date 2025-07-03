clc
clear
close all
addpath('../../../MatlabFunctions/');


% ================================
% analysis of the reaction zone thickness
% w over z & temperature over stoichiometric dissipation rate
% - for each inlet temperature
% - data at Zst(DNS) are selected
% ================================


%====
% INPUTS
%====
Flamelet_data_path = ['../OutputData/' ...
    'Flamelet_preheated_PassiveScalarMixtureFraction/Data/'];
RelevantFlameletData = ['../../../Flamelets/Cantera/OutputData/' ...
    'FlameletData/PostProcessedFlameletData.csv'];
Fig_outpath = 'Figures/AnalysisReactionZoneThickness/';
% save figure in [png, eps, pdf]
FigFormat = 'png';
%====


% create output directory
if Fig_outpath(end) ~= '/'
    Fig_outpath = [Fig_outpath, '/'];
end
if ~exist(Fig_outpath, 'dir')
    mkdir(Fig_outpath);                                                                                                                                                                                                               
end


% figure fonts
FZ = 22;
lw = 1;
set(0, 'defaultAxesFontName', 'Times');
set(0, 'DefaultFigureRenderer', 'painters');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex'); 
set(groot, 'defaultLegendInterpreter', 'latex');
set(0, 'defaultAxesFontSize', FZ);
set(0, 'DefaultLineLineWidth', lw);
set(0, 'defaultFigurePosition', [2 2 900 500]);
set(gca, 'TickLabelInterpreter', 'latex');
close


% get all csv files
flamelt_files = dir(fullfile(Flamelet_data_path, '*.csv'));
FlameletData = readtable(RelevantFlameletData);
if length(flamelt_files) ~= height(FlameletData)
    fprintf('\nIncorrect inputs!');
    return
end


% get data points
for i = 1:length(flamelt_files)
    % get data
    Tinlet = FlameletData.Tinlet(i);
    StrainRate = FlameletData.StrainRate(i);
    dZr = FlameletData.dZr(i);
    ChiStQu = FlameletData.ChiStQu(i);
    flamelet_data = readtable(strcat(Flamelet_data_path, ...
        flamelt_files(i).name), 'Delimiter', '\t', ...
        'PreserveVariableNames', true);


    % create figure
    close all
    figure
    t = tiledlayout(1,2);
    t.TileSpacing = 'compact';
    t.Padding = 'loose';


    % figure 1: heat release profile with gaussian function
    ax(1) = nexttile(1);

    % background
    set(gcf,'color','w');
    set(gca, 'Box', 'on');

    % create heat release curve
    xdata = flamelet_data.Z;
    ydata = flamelet_data.HeatRelease;
    plot(xdata, ydata, '-', 'LineWidth', lw+1, 'HandleVisibility', 'off');
    hold on
    
    % gaussian curve
    % approach: gaussian function based on half-width at half-maximum
    % half-width at half-maximum
    HWHM = dZr / 2;
    % peak position
    [max_y, max_idx] = max(ydata);
    x_ymax = xdata(max_idx);
    % sigma from HWHM
    sigma = HWHM / sqrt(2 * log(2));
    % gaussian function
    gaussian = @(xdata) max_y * exp(-((xdata - ...
        x_ymax).^2) / (2 * sigma^2));
    % smooth x values for Gaussian fit
    x_fit = linspace(min(xdata), max(xdata), length(xdata));
    y_fit = gaussian(x_fit);
    % create line
    plot(x_fit, y_fit, 'k--', 'LineWidth', lw+1, ...
        'HandleVisibility', 'off');
    hold on;

    % label and title
    xlabel('$Z \mathrm{[-]}$', 'fontsize', FZ, 'interpreter', 'latex', ...
        'FontWeight', 'bold');
    ylabel('$\omega_\mathrm{T} \mathrm{[J/m^{3}/s]}$', ...
        'fontsize', FZ, 'interpreter', 'latex', 'FontWeight', 'bold');


    % figure 2: reaction zone thickness over dissipation rate ratio
    hold on;
    ax(2) = nexttile(2);

    % background
    set(gcf,'color','w');
    set(gca, 'Box', 'on');

    % create figure (Denker 2020 Fig.)
    FilteredFlamelts = FlameletData.Tinlet == Tinlet;
    [~, idx] = min(abs(FlameletData.StrainRate( ...
        FilteredFlamelts) - StrainRate));
    xdata = FlameletData.ChiStQu(FilteredFlamelts);
    ydata = FlameletData.dZr(FilteredFlamelts);
    semilogx(xdata, ydata, 'x-', 'LineWidth', lw+1, 'Marker', 'x', ...
        'Color', 'black', 'HandleVisibility', 'off');

    % highlight flamelet
    hold on
    xdata = xdata(idx);
    ydata = ydata(idx);
    scatter(xdata, ydata, 50, 'red', 'filled', 'o');

    % axis limits
    xmin = 1E-04;
    xlim([xmin 1]);
    ymax = 0.21;
    ylim([0 ymax]);
    
    % ticks modification
    ytick_positions = linspace(0, ymax, 4);
    set(gca, 'YTick', ytick_positions, 'LineWidth', lw);

    % minor ticks
    set(gca,'XMinorTick','on','YMinorTick','on');

    % labels and title
    xlabel('$\chi_\mathrm{st}/\chi_\mathrm{q}$ [-]', ...
        'fontsize', FZ, 'interpreter', 'latex', ...
        'FontWeight', 'bold');
    ylabel('$\delta Z_\mathrm{r}$ [-]', 'fontsize', FZ, ...
        'interpreter', 'latex', 'FontWeight', 'bold');


    % global figure title
    header = strcat('$T_\mathrm{in}$=', num2str(Tinlet), ...
        ' K $a$=', num2str(StrainRate), ' $1/s$');
    sgtitle(header, 'Interpreter', 'latex', 'FontSize', FZ);

    % figure name
    ofname = strcat(sprintf('Tinlet_%04d', Tinlet), ...
        sprintf('_StrainRate_%02d', StrainRate));
    outfname = strcat(Fig_outpath, ofname);

    % save figure
    if strcmp(FigFormat, 'png')
        saveas(gca, strcat(outfname, '.png'), 'png');
    elseif strcmp(FigFormat, 'eps')
        saveas(gca, strcat(outfname, '.eps'), 'epsc');
    elseif strcmp(FigFormat, 'pdf')
        exportgraphics(gca, strcat(outfname, '.pdf'), ...
            'ContentType', 'vector');
    else
        fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
            FigFormat);
        return
    end
end