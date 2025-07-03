clc
clear
close all


% ================================
% temperature over stoichiometric dissipation rate
% - for each inlet temperature
% - data at Zst are selected
% ================================


%====
% INPUTS
%====
Data_path = '../OutputData/Flamelet_preheated_PassiveScalarMixtureFraction/Data/';
Zst = 0.117;
Fig_outpath = 'Figures/';
Inverse = false;
if Inverse
    ofname = 'TemperatureOverInverseStoichDissipationRate';
else
    ofname = 'TemperatureOverStoichDissipationRate';
end
% save figure in [png, eps, pdf]
FigFormat = 'png';
%====


% create output directory
if ~exist(Fig_outpath,'dir')
    mkdir(Fig_outpath);                                                                                                                                                                                                               
end


% get all csv files
csv_files = dir(fullfile(Data_path, '*.csv'));


% allocate memory
mat = [];
matrix = {};
Tinlet = split(csv_files(1).name, '.');
Tinlet = Tinlet{2};


% get data points
for i = 1:length(csv_files)
    Tinlet_ = split(csv_files(i).name, '.');
    Tinlet_ = Tinlet_{2};
    flamelet_data = readtable(strcat(Data_path, csv_files(i).name), ...
        'Delimiter', '\t', 'PreserveVariableNames', true);
    [ChiSt, ChiQ, Temp, D] = GetRespectiveFlameletData(flamelet_data, Zst);
    if ~strcmp(Tinlet, Tinlet_) || i == length(csv_files)
        Tinlet = Tinlet_;
        matrix{end + 1} = mat;
        mat = [];
    else
        if Inverse
            mat = [mat, [1/ChiSt, Temp, D, ChiQ/ChiSt]'];
        else
            mat = [mat, [ChiSt, Temp, D, ChiSt/ChiQ]'];
        end
    end

end


% get min/max dissipation rate
min_Chi = 1e999;
max_Chi = 0;
for i = 1:numel(matrix)
    rowData = matrix{i}(1,:);
    [minChi, localMinIdx] = min(rowData);
    [maxChi, localMaxIdx] = max(rowData);
    
    % global minimum
    if minChi < min_Chi
        min_Chi = minChi;
        globalMinIdx = [i, localMinIdx];
    end

    % global maximum
    if maxChi > max_Chi
        max_Chi = maxChi;
        globalMaxIdx = [i, localMaxIdx];
    end
end


% calculate quenching gradient
if Inverse
    D_max_Chi = matrix{globalMinIdx(1)}(3,globalMinIdx(2));
    g_quench = ((1 / min_Chi) / (6 * D_max_Chi))^0.5;
else
    D_max_Chi = matrix{globalMaxIdx(1)}(3,globalMaxIdx(2));
    g_quench = (max_Chi / (6 * D_max_Chi))^0.5;
end
fprintf('Quenching gradient g_q = %e 1/m\n', g_quench);


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


% create figure
close all
figure
t = tiledlayout(1,1);
t.TileSpacing = 'compact';
t.Padding = 'loose';
nexttile([1, 1]);
set(gcf,'color','w');
cmap = jet(length(matrix));
for i = 1:length(matrix)
    xdata = matrix{i}(1,:);
    ydata = matrix{i}(2,:);
    plot(xdata, ydata, '-', 'LineWidth', lw+1, 'Marker', 'x', ...
        'Color', cmap(i,:), 'HandleVisibility', 'off');
    hold on
end


% colorbar
colormap(cmap);
cb = colorbar('eastoutside');
caxis([250 1550]); % Ticks in the center
cb.TickLabelInterpreter = 'latex';
cb.Ticks = [300, 600, 900, 1200, 1500];
ylabel(cb, '$T_\mathrm{inlet} \mathrm{[K]}$', 'fontsize', FZ, ...
    'interpreter', 'latex', 'FontWeight', 'bold')


% axis limits
%xlim([0 30000]);
%ylim([0 2500]);


% ticks modification
%xtick_positions = linspace(0, 30000, 4);
%set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
%ytick_positions = linspace(0, 2500, 6);
%set(gca, 'YTick', ytick_positions, 'LineWidth', lw);


% labels and legend
if Inverse
    xlabel('$1/\chi_\mathrm{st}$ [s]', 'fontsize', FZ, ...
        'interpreter', 'latex', 'FontWeight', 'bold');
else
    xlabel('$\chi_\mathrm{st}$ [1/s]', 'fontsize', FZ, ...
        'interpreter', 'latex', 'FontWeight', 'bold');
end
ylabel('$T_\mathrm{gas}$ [K]', 'fontsize', FZ, ...
    'interpreter', 'latex', 'FontWeight', 'bold');
legend('show', 'Interpreter', 'latex', 'Location', 'northwest', ...
    'Box', 'off', 'fontsize', FZ);


% format
set(gca, 'Box', 'on');


% figure name
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


%=====
% functions
%=====
function [chi_st, chi_q, temp_st, d_st] = GetRespectiveFlameletData( ...
    data, zst)

    % get Tinlet levels
    Z_data = data.Z;
    Chi_data = data.chi;
    T_data = data.Temp;
    D_data = data.D;

    % find the closest temperature and index
    [~, idx] = min(abs(Z_data - zst));
    %Zst_ = Z_data(idx);
    %if Zst_ ~= 1500
    %    fprintf('Zst is: %e\n', Zst_);
    %end

    % dissipation rate
    chi_st = Chi_data(idx);

    % temperature
    temp_st = T_data(idx);

    % diffustion coefficent
    d_st = D_data(idx);

    % quenching dissipation rate
    chi_q = max(Chi_data);

end
