clc
clear all
close all

% ================================
% plot certain variable in dissipation element
% ================================


%====
% INPUTS
%====
hdf5_data_path = ['~/itv/OXYFLAME-B3/File_Transfer/DE_analysis_code/' ...
    'trajSearch/Dataset'];
cases= {'traj_Tbox_ign.h5', 'traj_Tbox_OHmax.h5', ...
    'traj_Tbox_fullComb.h5', 'traj_Tbox_finish.h5'};
DE_data_path = '../../PostProcessedData/';
outdir = '../../Figures/DissipationElements/Visualization/';
inputfile = 'DEGridpointsZst_OHmax.csv';
% visualize dissipation element as ['Scatter', 'Surface', 
% 'TrajectorySurface']
Visualization = 'Scatter';
% case - ! same as inputfile !
c = 2;
% figure is colored by [Chi; Enth; HR; PV; PVnorm; Tgas; YOH; Zmix]
% one or multiple variables
var = 'YOH';
% dissipation element number (not id)           TODO SHOULD BE ID
num = 10; % 1 means first DE in csv file!
Zst = 0.117;
% save figure in [png, eps, pdf]
FigFormat = 'png';
% size of markers in 3D plot
markersize = 50;
%====


% create output directory
if outdir(end) ~= '/'
    outdir = [outdir, '/'];
end
if ~exist(outdir,'dir')
    mkdir(outdir);
end


% global fonts
FZ = 20;
lw = 1;
set(0, 'defaultAxesFontName', 'Times');
set(0, 'DefaultFigureRenderer', 'painters');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex'); 
set(groot, 'defaultLegendInterpreter', 'latex');
set(0, 'defaultAxesFontSize', FZ);
set(0, 'DefaultLineLineWidth', lw);
%set(0, 'defaultFigurePosition', [2 2 600 500]);
set(gca, 'TickLabelInterpreter', 'latex');
close


% 
home = pwd;


% full path
DE_data_path = strcat(home, '/', DE_data_path, '/', inputfile);
ofname = strcat(home, '/', outdir);


% read csv file
data = readmatrix(DE_data_path);


% extract data
[DE_id, x_coords, y_coords, z_coords] = ExtractData(data(:,num));


% read data
for i = c:c %length(cases)
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


% get corresponding data points in dissipation element
chi = ExtractDataPoints(Chi{c}, x_coords, y_coords, z_coords);
enth = ExtractDataPoints(Enth{c}, x_coords, y_coords, z_coords);
hr = ExtractDataPoints(HR{c}, x_coords, y_coords, z_coords);
pv = ExtractDataPoints(PV{c}, x_coords, y_coords, z_coords);
pvnorm = ExtractDataPoints(PVnorm{c}, x_coords, y_coords, z_coords);
tgas = ExtractDataPoints(Tgas{c}, x_coords, y_coords, z_coords);
yoh = ExtractDataPoints(YOH{c}, x_coords, y_coords, z_coords);
zmix = ExtractDataPoints(Zmix{c}, x_coords, y_coords, z_coords);


% colorbar data
switch(var)
    case 'Chi'
        cb_var = chi;
        cblabel = '$\chi \mathrm{[1/s]}$';
        lowLim = 0;
        upLim = max(cb_var);
    case 'Enth'
        cb_var = enth;
        cblabel = '$H \mathrm{[kJ/kg]}$';       % TODO correct??
        lowLim = min(cb_var);
        upLim = max(cb_var);
    case 'HR'
        cb_var = HR;
        cblabel = '$\omega_\mathrm{T} \mathrm{[J/m^{3}/s]}$';
        lowLim = 0;
        upLim = max(cb_var);
    case 'PV'
        cb_var = pv;
        cblabel = '$PV \mathrm{[-]}$';
        lowLim = 0;
        upLim = max(cb_var);
    case 'PVnorm'
        cb_var = pvnorm;
        cblabel = '$PV_\mathrm{norm} \mathrm{[-]}$';
        lowLim = 0;
        upLim = max(cb_var);
    case 'Tgas'
        cb_var = tgas;
        cblabel = '$T_\mathrm{gas} \mathrm{[K]}$';
        lowLim = 0;
        upLim = max(cb_var);
    case 'YOH'
        cb_var = yoh;
        cblabel = '$Y_\mathrm{OH} \mathrm{[-]}$';
        lowLim = 0;
        upLim = max(cb_var);
    case 'Zmix'
        cb_var = zmix;
        cblabel = '$Z_\mathrm{mix} \mathrm{[-]}$';
        lowLim = 0;
        upLim = max(cb_var);
    otherwise
        fprintf('\nInvalid input!');
        return
end


% create 3D figure
close all
figure
set(gcf,'color','w');


% plot
if strcmp(Visualization, 'Scatter')
    scatter3(x_coords, y_coords, z_coords, markersize, cb_var, 'filled');
elseif strcmp(Visualization, 'Surface')
    [Xq, Yq] = meshgrid(linspace(min(x_coords), max(x_coords), 300), ...
                         linspace(min(y_coords), max(y_coords), 300));
    Zq = griddata(x_coords, y_coords, z_coords, Xq, Yq, 'cubic');
    cbq = griddata(x_coords, y_coords, cb_var, Xq, Yq, 'cubic');
    surf(Xq, Yq, Zq, 'CData', cbq, 'FaceColor', 'interp', 'EdgeColor', ...
        'none');
elseif strcmp(Visualization, 'TrajectorySurface')
    %
    a = 0;
else
    fprintf(['\nInvalid visualization approach (%s)\n => Scatter/' ...
        'Surface/TrajectorySurface\n'], Visualization);
    return
end


% colorbar
colormap(jet);
caxis([lowLim, upLim]);
cb = colorbar('eastoutside');
cb.TickLabelInterpreter = 'latex';
cb.FontName = 'Times';
%cb.FontWeight = ax.FontWeight;
cb.FontSize = FZ-5;
ylabel(cb, cblabel, 'fontsize', FZ, ...
    'interpreter', 'latex', 'FontWeight', 'bold');


% labels and title
xlabel('x', 'fontsize', FZ, 'interpreter', 'latex', 'FontWeight', 'bold');
ylabel('y', 'fontsize', FZ, 'interpreter', 'latex', 'FontWeight', 'bold');
zlabel('z', 'fontsize', FZ, 'interpreter', 'latex', 'FontWeight', 'bold');

    
% format
set(gca, 'Box', 'on');


% figure name
time = split(cases{c}(1:end-3), '_');
ofname = strcat(ofname, '/', 'Case_', time{end}, ...
    '_DEid_', num2str(DE_id), '_Variable_', var);


% save
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


% functions
function var = ExtractDataPoints(Var, x, y, z)
    
    %
    var = [];
    for i = 1:length(x)
        var = [var, Var(x(i), y(i), z(i))];
    end
    var = var';

end


function [id, x_pos,y_pos,z_pos] = ExtractData(arr)

    % dissipation element id
    id = arr(1);

    % x-position
    x_indices = 2:3:length(arr);
    x_pos = arr(x_indices);

    % y-position
    y_indices = 3:3:length(arr);
    y_pos = arr(y_indices);

    % z-position
    z_indices = 4:3:length(arr);
    z_pos = arr(z_indices);

    % clipp all elements equal zero
    x_pos = x_pos(x_pos ~= 0);
    y_pos = y_pos(y_pos ~= 0);
    z_pos = z_pos(z_pos ~= 0);

end
