clc
clear
close all
addpath('../../../MatlabFunctions/');


% ================================
% temperature over stoichiometric dissipation rate
% - for each inlet temperature
% - data at Zst(DNS) are selected
% ================================


%====
% INPUTS
%====
Data_path = '../OutputData/Flamelet_preheated_PassiveScalarMixtureFraction/Data/';
Zst = 0.117;
Fig_outpath = 'Figures/';
ofname = 'ReactionZoneThicknessOverDissipationRateRatio';
Denker2020Path = ['../../../../DNS_Data_PostProcessing/Figures/' ...
    'TrajSearch_PostProcessing/Denker2020/'];
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
Denker2020Path = strcat(Fig_outpath, Denker2020Path);
if Denker2020Path(end) ~= '/'
    Denker2020Path = [Fig_ouDenker2020Pathtpath, '/'];
end
if ~exist(Denker2020Path, 'dir')
    mkdir(Denker2020Path);                                                                                                                                                                                                               
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
    [Chi_st, Chi_qu] = GetRespectiveFlameletData(flamelet_data, Zst);
    dZr = ComputeReactionZoneThickness(flamelet_data.HeatRelease, ...
        flamelet_data.Z);
    if ~strcmp(Tinlet, Tinlet_) || i == length(csv_files)
        Tinlet = Tinlet_;
        matrix{end + 1} = mat;
        mat = [];
    else
        mat = [mat, [Chi_st, dZr]'];
    end

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
    xdata = matrix{i}(1,:)./max(matrix{i}(1,:));
    ydata = matrix{i}(2,:);
    semilogx(xdata, ydata, 's-', 'LineWidth', lw+1, 'Marker', 'x', ...
        'HandleVisibility', 'off');
    %xlim([0 1])
    hold on
end

%legend('$T=1400K$','$T=1500K$','interpreter', 'latex','Box','off','location','north')

% colorbar
colormap(cmap);
cb = colorbar('eastoutside');
caxis([250 1550]); % Ticks in the center
cb.TickLabelInterpreter = 'latex';
cb.Ticks = [300, 600, 900, 1200, 1500];
ylabel(cb, '$T_\mathrm{inlet} \mathrm{[K]}$', 'fontsize', FZ, ...
    'interpreter', 'latex', 'FontWeight', 'bold')


% axis limits
%xlim([0.06 0.11]);
%ylim([0 2500]);


% ticks modification
%xtick_positions = linspace(0, 30000, 4);
%set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
%ytick_positions = linspace(0, 2500, 6);
%set(gca, 'YTick', ytick_positions, 'LineWidth', lw);


% labels and legend
xlabel('$\chi_\mathrm{st}/\chi_\mathrm{q}$ [-]', 'fontsize', FZ, ...
        'interpreter', 'latex', 'FontWeight', 'bold');
ylabel('$\delta Z_\mathrm{r}$ [-]', 'fontsize', FZ, ...
    'interpreter', 'latex', 'FontWeight', 'bold');
legend('show', 'Interpreter', 'latex', 'Location', 'northwest', ...
    'Box', 'off', 'fontsize', FZ);


% format
set(gca, 'Box', 'on');
set(gca, 'XScale', 'log');


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
% save figure - Denker 2020
outfname = strcat(Denker2020Path, 'DenkerFigure14b');
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
function [chi_st, chi_qu] = GetRespectiveFlameletData(data, zst)

    % get Tinlet levels
    Z_data = data.Z;
    Chi_data = data.chi;

    % find the closest temperature level and index
    [~, idx] = min(abs(Z_data - zst));
    %Zst_ = Z_data(idx);
    %if Zst_ ~= 1500
    %    fprintf('Zst is: %e\n', Zst_);
    %end

    % stoichiometric dissipation rate
    chi_st = Chi_data(idx);

    % quenching dissipation rate
    chi_qu = max(Chi_data);

end
