clc
clear
close all
addpath('../../../MatlabFunctions/');


% ================================
% heat release over mixture fraction
% -> visualization of reaction zone thickness
% input can be single file or folder
% if single -> figure is saved in Figures & has annotations
% if folder -> figures and a movie are saved in 
% Figures/ReactionZoneThickenss & DONT have annotations 
% => xlim and ylim make problems
% ================================


%====
% INPUTS
%====
%Data_path = '../OutputData/Flamelet_preheated_PassiveScalarMixtureFraction/Data/Data_yiend.1500.001.csv';
Data_path = '../OutputData/Flamelet_preheated_PassiveScalarMixtureFraction/Data/';
Zst = 0.117;
Fig_outpath = 'Figures/';
ofname = 'ReactionZoneThickness_';
% save figure in [png, eps, pdf]
FigFormat = 'png';
%====


% get all csv files
input_is_folder = false;
if isfolder(Data_path)
    input_is_folder = true;
    csv_files = dir(fullfile(Data_path, '*.csv'));
    Fig_outpath = 'Figures/ReactionZoneThicknessVisualization/';
else
    csv_files = dir(Data_path);
    Data_path = strcat(csv_files.folder, '/');
end


% create output directory
if ~exist(Fig_outpath,'dir')
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
set(0, 'defaultFigurePosition', [2 2 700 500]);
set(gca, 'TickLabelInterpreter', 'latex');
close


for i = 1:length(csv_files)

    % create figure
    close all
    figure
    t = tiledlayout(1,1);
    t.TileSpacing = 'compact';
    t.Padding = 'loose';
    nexttile([1, 1]);
    set(gcf,'color','w');

    % get data
    flamelet_data = readtable(strcat(Data_path, ...
        csv_files(i).name), 'Delimiter', '\t', ...
        'PreserveVariableNames', true);
    xdata = flamelet_data.Z;
    ydata = flamelet_data.HeatRelease;

    dZr = ComputeReactionZoneThickness(flamelet_data.HeatRelease, ...
        flamelet_data.Z);

    % create curve
    plot(xdata, ydata, '-', 'LineWidth', lw+1, ...
        'HandleVisibility', 'off');
    hold on

    % gaussian function based on adjacent left and right data points
    %[xfit, yfit] = Flamelets_GaussianCurveFitting(xdata, ydata);
    %plot(xfit, yfit, '--k', 'LineWidth', lw+1, ...
    %    'HandleVisibility', 'off');

    % approach: gaussian function based on half-width at half-maximum
    % half-width at half-maximum
    HWHM = dZr / 2;
    % peak position
    [max_y, max_idx] = max(ydata);
    x_ymax = xdata(max_idx);
    %max_idx = FindIndexOfPeak(ydata);
    %max_y = ydata(max_idx);
    %x_ymax = xdata(max_idx);
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

    if ~input_is_folder
        % vertical lines
%         plot([x_ymax - 0.5*dZr, x_ymax - 0.5*dZr], [0, 3.125E10], ...
%             '-k', 'LineWidth', lw+1, 'HandleVisibility', 'off');
%         hold on;
%         plot([x_ymax + 0.5*dZr, x_ymax + 0.5*dZr], [0, 3.125E10], ...
%             '-k', 'LineWidth', lw+1, 'HandleVisibility', 'off');
%         hold on;

        % figure update for annotation/reaction zone thickness
        % => requires normalized axis
        axis tight;
        drawnow;

        % axis limits
        %ymax= 3.5E+10;
        xlim([0 1]);
        %ylim([0 ymax]);
        
        % ticks modification
        xtick_positions = linspace(0, 1, 6);
        set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
        %ytick_positions = linspace(0, ymax, 8);
        %set(gca, 'YTick', ytick_positions, 'LineWidth', lw);
    
        % apply limits before annotation
        drawnow;

        % arrow (annotation) coordinates
%         arrowX = [x_ymax - 0.5*dZr, x_ymax + 0.5*dZr];
%         arrowY = [3.125E10, 3.125E10];
%         
%         % normalize coordinates for annotation
%         ax = gca;
%         xlim = ax.XLim;
%         ylim = ax.YLim;
%         pos = ax.Position;
%         x_norm = (arrowX - xlim(1)) / (xlim(2) - xlim(1)) * pos(3) + pos(1);
%         y_norm = (arrowY - ylim(1)) / (ylim(2) - ylim(1)) * pos(4) + pos(2);
%         
%         % draw arrow
%         fac = 1.025; % Move arrow slightly to the right hand side
%         annotation('doublearrow', x_norm * 1.025, y_norm, ...
%             'Color', 'k', 'LineWidth', lw+1);

        % annotation
%         arrowY = [3.3E10, 3.3E10];
%         Label = '$\delta Z_{\mathrm{r}}$';
%         text(mean(arrowX), arrowY(1) + 5, Label, ...
%             'HorizontalAlignment', 'center', 'FontSize', FZ, ...
%             'Color', 'k', 'Interpreter', 'latex');
    else
        % axis limits
        %ymax= 3.5E+10;
        xlim([0 1]);
        %ylim([0 ymax]);
        
        % ticks modification
        xtick_positions = linspace(0, 1, 6);
        set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
        %ytick_positions = linspace(0, ymax, 8);
        %set(gca, 'YTick', ytick_positions, 'LineWidth', lw);
    end

    % labels and legend
    sp_fname = split(csv_files(i).name, '.');
    Tin = str2double(sp_fname{2});
    a = str2double(sp_fname{3});
    xlabel('$Z \mathrm{[-]}$', 'fontsize', FZ, ...
            'interpreter', 'latex', 'FontWeight', 'bold');
    ylabel('$\omega_\mathrm{T} \mathrm{[J/m^{3}/s]}$', ...
        'fontsize', FZ, 'interpreter', 'latex', 'FontWeight', 'bold');
    header = strcat('$T_\mathrm{in}$=', num2str(Tin), ...
        'K $a$=', num2str(a), ' $1/s$');
    title(header, 'Interpreter', 'latex', 'FontSize', FZ);
    legend('show', 'Interpreter', 'latex', 'Location', 'northwest', ...
        'Box', 'off', 'fontsize', FZ);
    
    % format
    set(gca, 'Box', 'on');
    
    % figure name
    ofname_ = strcat(ofname, '_Tin', sprintf('%04d', Tin), ...
        '_a', sprintf('%03d', a));
    outfname = strcat(Fig_outpath, ofname_);
    
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

    hold off;
end


if input_is_folder
    % create movie
    home = pwd;
    cd  (Fig_outpath);
    if strcmp(FigFormat, 'png')
        dZr_images = dir(strcat(ofname, '*.png'));
    elseif strcmp(FigFormat, 'eps')
        dZr_images = dir(strcat(ofname, '*.png'));
    elseif strcmp(FigFormat, 'pdf')
        dZr_images = dir(strcat(ofname, '*.png'));
    end
    v_dZr = VideoWriter('ReactionZoneThickness.avi', ...
        'Uncompressed AVI');
    v_dZr.FrameRate = 8;
    open(v_dZr);
    for dZr_file = 1:length(dZr_images)
        A = imread(dZr_images(dZr_file).name);
        A_res = imresize(A, [781, 1094]);
        writeVideo(v_dZr, A_res)
    end
    close(v_dZr);
    cd (home);
end
