clc
clear
close all
addpath('~/NHR/DE_Analysis/MatlabFunctions');


% ================================
% average ratio C_chi = <chi / (2Dg²)>
% approach:
% -> for each dissipation element: g
% -> for each respective flamelet: chi (max!), D(@max(chi))
% ================================


%====
% INPUTS
%====
hdf5_data_path = ['~/itv/OXYFLAME-B3/File_Transfer/DE_analysis_code/' ...
    'trajSearch/Dataset'];
cases= {'traj_Tbox_ign.h5', 'traj_Tbox_OHmax.h5', ...
    'traj_Tbox_fullComb.h5', 'traj_Tbox_finish.h5'};
Data_path = '../../PostProcessedData/';
DE_InputFiles = {'DEGridpointsAll_ign.csv', ...
    'DEGridpointsAll_OHmax.csv', ...
    'DEGridpointsAll_fullComb.csv',...
    'DEGridpointsAll_finish.csv'};
DissipationElementFlameletData = {'DE_Flamelets_ign.csv', ...
    'DE_Flamelets_OHmax.csv', 'DE_Flamelets_fullComb.csv'};
FlameletDataPath = ['../../../Flamelets/Cantera/OutputData/' ...
    'Flamelet_preheated_PassiveScalarMixtureFraction/Data/'];
Fig_outpath = '../../Figures/AverageRatioC/';
OutPathDenker2020 = '../../Figures/TrajSearch_PostProcessing/Denker2020/';
ofname = 'AverageRatioCchi_BasedOnFlamelets';
% stoichiometric mixture fraction
Z_st = 0.117;
% total number of cases
tc = 3;
% DNS grid size
dx = 5E-5;
% simulation times
times = [0.50, 0.65, 0.75, 1.00]; % [ms]
% save figure in [png, eps, pdf]
FigFormat = 'png';
%====


% create output directory
if Fig_outpath(end) ~= '/'
    Fig_outpath = [Fig_outpath, '/'];
end
if Data_path(end) ~= '/'
    Data_path = [Data_path, '/'];
end
if OutPathDenker2020(end) ~= '/'
    OutPathDenker2020 = [OutPathDenker2020, '/'];
end
if ~exist(Fig_outpath, 'dir')
    mkdir(Fig_outpath);
end
if ~exist(OutPathDenker2020, 'dir')
    mkdir(OutPathDenker2020);
end


%%
% global fonts
FZ = 22;
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
for i = 1:tc
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
    % scalar position and value for each DE
    edata_dble{i} = h5read(strcat(hdf5_data_path ,'/', cases{i}), ...
        '/traj_full/edata_dble');
end


% calculate DE related variables
l = cell(1,tc);
lm = cell(1,tc);
ln = cell(1,tc);
phi = cell(1,tc);
phim = cell(1,tc);
phin = cell(1,tc);
g = cell(1,tc);
gn = cell(1,tc);
for i = 1:tc
    l{i}=edata_dble{i}(7,:) .* dx;
    lm{i}=mean(edata_dble{i}(7,:) .* dx);
    ln{i}=l{i}./lm{i};
    phi{i}=edata_dble{i}(10,:);
    phim{i}=mean(edata_dble{i}(10,:));
    phin{i}=phi{i}./phim{i};
    g{i} = phi{i}./l{i};
    gn{i} = (phi{i}./phim{i})./(l{i}./lm{i});
end


%% calculate/get relevant data
matrix = {};
for i = 1:tc
    % full path
    Data_path_ = strcat(Data_path, DE_InputFiles{i});

    % read the csv file
    data = readmatrix(Data_path_);
    
    % number of dissipation elements (containing Zst)
    [~, num_columns] = size(data);
    DE_Zst = num_columns;

    % read flamelet data
    de_flamelet_data = readmatrix(strcat(Data_path, ...
        DissipationElementFlameletData{i}));
    flamelet_data = dir(fullfile(FlameletDataPath, '*.csv'));

    % allocate memory
    mat = [];

    for j = 1:DE_Zst
        % extract data
        [DE_id, x_coords, y_coords, z_coords] = DE_GetGridPoints( ...
            data(:,j));

        % get corresponding data points
        chi = DE_ExtractData(Chi{i}, x_coords, y_coords, z_coords);
        enth = DE_ExtractData(Enth{i}, x_coords, y_coords, z_coords);
        hr = DE_ExtractData(HR{i}, x_coords, y_coords, z_coords);
        pv = DE_ExtractData(PV{i}, x_coords, y_coords, z_coords);
        pvnorm = DE_ExtractData(PVnorm{i}, x_coords, y_coords, ...
            z_coords);
        tgas = DE_ExtractData(Tgas{i}, x_coords, y_coords, z_coords);
        yoh = DE_ExtractData(YOH{i}, x_coords, y_coords, z_coords);
        zmix = DE_ExtractData(Zmix{i}, x_coords, y_coords, z_coords);

        % get flamelet data
        [fl_chi, fl_d] = GetRespectiveFlameletData(de_flamelet_data, ...
            DE_id, flamelet_data);

        % get corresponding DE data
        DE_g = g{i}(DE_id) * (1/dx);

        % calculate average ratio C_chi
        C_chi = fl_chi / (2 * fl_d * DE_g^2);

        % store data in matrix
        mat = [mat, [DE_id, fl_chi, fl_d, DE_g, C_chi]'];
    end

    %
    matrix{end + 1} = mat;
end


%% write Cchi to file
Cchi = [];
for i = 1:tc
    Cchi = [Cchi, [mean(matrix{i}(5,:))]'];
end
writematrix(Cchi, strcat(Data_path, ofname, '.csv'));


%% create figure
close all
figure

% layout
t = tiledlayout(1,1);
t.TileSpacing = 'compact';
t.Padding = 'loose';                                                                                                                                                                                                                      
nexttile([1, 1]);

% background
set(gcf,'color','w');
    
% plot
for i = 1:tc
    scatter(times(i), mean(matrix{i}(5,:)), 100, 'filled', 'blue', ...
        'Marker', 's');
    hold on;
end

% isotropic turbulence
iso_turb = 7.8;
%yline(iso_turb, '--k', 'LineWidth', lw+1, 'HandleVisibility', 'off');
plot([0.5 1.0], [iso_turb, iso_turb], '--k', 'LineWidth', lw+1, ...
    'HandleVisibility', 'off');

% axis limits
% xmin = 0.4;
% xmax = 0.8;
% xlim([xmin xmax]);
% ylim([0 12E11]);
% xtick_positions = linspace(xmin, xmax, 5);
% set(gca, 'XTick', xtick_positions, 'LineWidth', lw);


% labels and title
xlabel('$t$ [ms]', 'fontsize', FZ, ...
    'interpreter', 'latex', 'FontWeight', 'bold');
ylabel('$C_\mathrm{\chi}$ [-]', ...
    'fontsize', FZ, 'interpreter', 'latex', 'FontWeight', 'bold');
%header = sprintf('case: %s', cases{c}(1:end-3));
%title(header, 'fontsize', FZ, 'Interpreter', 'latex');

% use minor ticks
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on');

% format
set(gca, 'Box', 'on');

% figure name
outfname = strcat(Fig_outpath, ofname);

% save
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

% save - Denker 2020
outfname = strcat(OutPathDenker2020, 'DenkerFigure11a');
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


% functions
function [max_Chi, D_max_Chi] = GetRespectiveFlameletData(data, ...
    id, flamelets)

    % get Tinlet levels
    DE_id = data(1,:);
    [~, idx_col] = find(DE_id == id);
    Tinlet = data(2,idx_col);
    strain_rate = data(3,idx_col);

    % get flamelet file
    idx = 0;
    for i = 1:length(flamelets)
        sp_fname = split(flamelets(i).name, '.');
        Tinlet_ = str2double(sp_fname{2});
        a_ = str2double(sp_fname{3});
        if (Tinlet_ == Tinlet) && (a_ == strain_rate)
            idx = i;
            break
        end
    end

    % read flamelet data
    flamelet_data = readtable(strcat(flamelets(idx).folder, '/', ...
        flamelets(idx).name), 'Delimiter', '\t', ...
        'PreserveVariableNames', true);
    
    % get data
    Chi = flamelet_data.chi;
    D = flamelet_data.D;

    % get chi and diffusion coefficient
    %[max_Chi, max_Chi_idx] = max(Chi);
    %D_max_Chi = D(max_Chi_idx);
    max_Chi = mean(Chi);
    D_max_Chi = mean(D);
%     max_Chi_idx = find(Chi == max_Chi);
%     D_max_Chi = D(max_Chi_idx);

end
