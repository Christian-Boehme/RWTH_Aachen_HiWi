clc
clear
close all
addpath('~/NHR/DE_Analysis/MatlabFunctions');


% ================================
% average ratio C_chi = <chi / (2Dg²)>
% approach:
% -> for each STOICHIOMETRIC dissipation element: g, % OLD schi(@st), D(@st)
%   -> mean C_chi of each dissipation element
%   -> AGAIN mean of C_chi for all dissipation elements in this time step
% ---------- OR ----------
% -> for ALL dissipation elements: g, chi(field), D(field)
%   -> mean C_chi of each dissipation element
%   -> AGAIN mean of C_chi for all dissipation elements in this time step
% ================================


%
filepath = ['~/NHR/DE_Analysis/DNS_Data_PostProcessing/Scripts/' ...
    'CreateFigures/'];
cd ( filepath );


%====
% INPUTS
%====
hdf5_data_path = ['~/itv/OXYFLAME-B3/File_Transfer/DE_analysis_code/' ...
    'trajSearch/Dataset'];
cases= {'traj_Tbox_ign.h5', 'traj_Tbox_OHmax.h5', ...
    'traj_Tbox_fullComb.h5', 'traj_Tbox_finish.h5'};
Data_path = '../../PostProcessedData/';
DE_InputFiles_st = {'DEGridpointsZst_ign.csv', ...
    'DEGridpointsZst_OHmax.csv', ...
    'DEGridpointsZst_fullComb.csv',...
    'DEGridpointsZst_finish.csv'};
DE_InputFiles_all = {'DEGridpointsAll_ign.csv', ...
    'DEGridpointsAll_OHmax.csv', ...
    'DEGridpointsAll_fullComb.csv',...
    'DEGridpointsAll_finish.csv'};
Fig_outpath = '../../Figures/AverageRatioC/';
OutPathDenker2020 = '../../Figures/TrajSearch_PostProcessing/Denker2020/';
ofname = 'AverageRatioCchi_BasedOnDNS';
% case: StoichiometricFlamelets is false -> All dissipation elements and do
% two times "mean"
StoichiometricFlamelets = true;
% stoichiometric mixture fraction
Z_st = 0.117;
% total number of cases
tc = 4;
% DNS grid size
dx = 5E-5;
% simulation times
times = [0.50, 0.65, 0.75, 1.00]; % [ms]
% save figure in [png, eps, pdf]
FigFormat = 'png';
%====


% choose the case
if StoichiometricFlamelets
    DE_InputFiles = DE_InputFiles_st;
    if tc > 3
        % max(Z) in case 4 is below Zst
        tc = 3;
    end
    ofname = strcat(ofname, '_Zst');
else
    DE_InputFiles = DE_InputFiles_all;
    ofname = strcat(ofname, '_all');
end


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
    % cp field
    Cp{i} = h5read(strcat(hdf5_data_path ,'/', cases{i}), ...
        '/scalar/Cp_field');
    % lambda field
    Lambda{i} = h5read(strcat(hdf5_data_path ,'/', cases{i}), ...
        '/scalar/lambda_field');
    % density
    Rho{i} = h5read(strcat(hdf5_data_path ,'/', cases{i}), ...
        '/scalar/RHO');
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

    % allocate memory
    mat = [];

    for j = 1:DE_Zst
        % extract data
        [DE_id, x_coords, y_coords, z_coords] = DE_GetGridPoints( ...
            data(:,j));

        % get corresponding data points
        chi = DE_ExtractData(Chi{i}, x_coords, y_coords, z_coords);
        cp = DE_ExtractData(Cp{i}, x_coords, y_coords, z_coords);
        lambda = DE_ExtractData(Lambda{i}, x_coords, y_coords, z_coords);
        rho = DE_ExtractData(Rho{i}, x_coords, y_coords, z_coords);
        zmix = DE_ExtractData(Zmix{i}, x_coords, y_coords, z_coords);

        % diffusion coefficient field in dissipation element
        diffcoeff = lambda ./ (rho .* cp);

        % get corresponding DE data
        DE_g = g{i}(DE_id);

        % calculate average ratio C_chi
        if StoichiometricFlamelets
            [~, st_idx] = min(abs(zmix - Z_st));
            chi_st = chi(st_idx);
            diffcoeff_st = diffcoeff(st_idx);
            C_chi = mean(chi_st ./ (2 .* diffcoeff_st .* DE_g^2));
            %C_chi = mean(chi ./ (2 .* diffcoeff .* DE_g^2));
        else
            C_chi = mean(chi ./ (2 .* diffcoeff .* DE_g^2));
        end

        mat = [mat, [DE_id, C_chi]'];
    end

    % save data for this time step (simulation case)
    matrix{end + 1} = mat;
end


%% write Cchi to file
Cchi = [];
for i = 1:tc
    Cchi = [Cchi, [mean(matrix{i}(2,:))]'];
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
    scatter(times(i), mean(matrix{i}(2,:)), 100, 'filled', 'blue', ...
        'Marker', 's');
    hold on;
end

% isotropic turbulence
iso_turb = 7.8;
%yline(iso_turb, '--k', 'LineWidth', lw+1, 'HandleVisibility', 'off');
plot([0.5 1.0], [iso_turb, iso_turb], '--k', 'LineWidth', lw+1, ...
    'HandleVisibility', 'off');

% axis limits
xmin = 0.45;
xmax = 1.05;
xlim([xmin xmax]);
if StoichiometricFlamelets
    ylim([0 50]);
else
    ylim([0 10]);
end
xtick_positions = linspace(0.5, 1.0, 6);
set(gca, 'XTick', xtick_positions, 'LineWidth', lw);


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
