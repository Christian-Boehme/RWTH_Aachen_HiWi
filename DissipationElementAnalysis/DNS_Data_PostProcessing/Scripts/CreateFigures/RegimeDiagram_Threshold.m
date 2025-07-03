clc
clear
close all
addpath('~/NHR/DE_Analysis/MatlabFunctions');


% ================================
% regime diagram threshold
% -> threshold is defined based on the thickness of the Tgas/YOH profile
% ================================


%====
% INPUTS
%====
hdf5_data_path = ['~/itv/OXYFLAME-B3/File_Transfer/DE_analysis_code/' ...
    'trajSearch/Dataset'];
Dataf_path = ['~/NHR/DE_Analysis/Flamelets/Cantera/OutputData/' ...
    'Flamelet_preheated_PassiveScalarMixtureFraction/Data/'];
cases= {'traj_Tbox_ign.h5', 'traj_Tbox_OHmax.h5', ...
    'traj_Tbox_fullComb.h5', 'traj_Tbox_finish.h5'};
% prt_data_path = '~/itv/OXYFLAME-B3/Simulation_Cases/Point-Particle/TURBULENT/TBOX_PAPER/ITV-Simulations/Point-Particle/Cluster_T_Box/T1500_eta100_D20_st5_NP10K_12,8mm_dx50/PHYSICAL_ASPECTS_ANALYSIS/VORONOI/Clustering/';
% prt_data_files = {'part_data_0.02100.csv', 'part_data_0.02115.csv', ...
%     'part_data_0.02125.csv', 'part_data_0.02150.csv'};
Data_path = '~/NHR/DE_Analysis/DNS_Data_PostProcessing/PostProcessedData/';
DE_InputFiles = {'DEGridpointsZst_ign.csv', ...
    'DEGridpointsZst_OHmax.csv', ...
    'DEGridpointsZst_fullComb.csv',...
    'DEGridpointsZst_final.csv'};
RelevantFlameletData = ['~/NHR/DE_Analysis/Flamelets/Cantera/' ...
    'OutputData/FlameletData/PostProcessedFlameletData.csv'];
CchiDataFile = 'AverageRatioCchi_BasedOnDNS_Zst.csv';
ofname = 'Threshold';
% fitting approach
Fitted_chi = true;
Fitted_Tgas = false;
Tin_mean = true;
if Fitted_chi
    dZprime_points = linspace(1.0, 5.5, 10);
    if Tin_mean
        Fig_outpath = ['~/NHR/DE_Analysis/DNS_Data_PostProcessing/' ...
            'Figures/RegimeDiagram_FlameletFitting_DissipationRate/' ...
            'MeanTempPDF_CchiEquation/'];
    else
        Fig_outpath = ['~/NHR/DE_Analysis/DNS_Data_PostProcessing/Figures/' ...
            'RegimeDiagram_FlameletFitting_DissipationRate/MeanTempPDF/'];
    end
else
    dZprime_points = linspace(0.8, 2.0, 7);
    if Fitted_Tgas
        DissipationElementFlameletData = {
            'DE_Flamelets_Tgas_PDF_ign.csv', ...
            'DE_Flamelets_Tgas_PDF_OHmax.csv', ...
            'DE_Flamelets_Tgas_PDF_fullComb.csv'};
        Fig_outpath = ['~/NHR/DE_Analysis/DNS_Data_PostProcessing/Figures/' ...
            'RegimeDiagram_FlameletFitting_TgasYOH/Tgas'];
    else
        DissipationElementFlameletData = {
            'DE_Flamelets_YOH_PDF_ign.csv', ...
            'DE_Flamelets_YOH_PDF_OHmax.csv', ...
            'DE_Flamelets_YOH_PDF_fullComb.csv'};
        Fig_outpath = ['~/NHR/DE_Analysis/DNS_Data_PostProcessing/Figures/' ...
            'RegimeDiagram_FlameletFitting_TgasYOH/YOH'];
    end
end
% create regime diagram for case c
c = 2;
% DNS grid size
dx = 5E-5;
% domain size
nx = 256;
ny = 256;
nz = 256;
% stoichiometric mixture fraction
Z_st = 0.117;
%
n_bins_ = {10, 30, 10, 30};
n_bins = n_bins_{c};
% n_bins for mean(t) - PDF approach
n_bins_Tpdf = 100;
% Cell data average
sf = 0.05;
factor = 0.00005;
% save figure in [png, eps, pdf]
FigFormat = 'png';
%
Target_gprime = [0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0];
tol_gprime = 0.05;
tol_dZprime = 0.05;
%====


% get all csv files
input_is_folder = false;
if isfolder(Dataf_path)
    input_is_folder = true;
    csv_files = dir(fullfile(Dataf_path, '*.csv'));
    %Fig_outpath = 'Figures/ReactionZoneThicknessVisualization_ModifiedPeaks/';
else
    csv_files = dir(Dataf_path);
    Dataf_path = strcat(csv_files.folder, '/');
end


% create output directory
if Data_path(end) ~= '/'
    Data_path = [Data_path, '/'];
end
% if prt_data_path(end) ~= '/'
%     prt_data_path = [prt_data_path, '/'];
% end
if Fig_outpath(end) ~= '/'
    Fig_outpath = [Fig_outpath, '/'];
end
if ~exist(Fig_outpath,'dir')
    mkdir(Fig_outpath);
end


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


% read DNS data
Chi = cell(1,1);
Cp = cell(1,1);
Enth = cell(1,1);
HR = cell(1,1);
Lambda = cell(1,1);
PV = cell(1,1);
PVnorm = cell(1,1);
Rho = cell(1,1);
Tgas = cell(1,1);
YOH = cell(1,1);
Zmix = cell(1,1);
edata_dble = cell(1,1);
for i = c:c
    % dissipation rate
    Chi{i} = h5read(strcat(hdf5_data_path ,'/', cases{i}), ...
        '/scalar/dissp_rate');
    % isobaric heat capacity
    Cp{i} = h5read(strcat(hdf5_data_path ,'/', cases{i}), ...
        '/scalar/Cp_field');
    % Enthalpy
    Enth{i} = h5read(strcat(hdf5_data_path ,'/', cases{i}), ...
        '/scalar/Enthalpy');
    % HR
    HR{i} = h5read(strcat(hdf5_data_path ,'/', cases{i}), ...
        '/scalar/HR');
    % lambda
    Lambda{i} = h5read(strcat(hdf5_data_path ,'/', cases{i}), ...
        '/scalar/lambda_field');
    % PV
    PV{i} = h5read(strcat(hdf5_data_path ,'/', cases{i}), ...
        '/scalar/PV');
    % PV normalized
    PVnorm{i} = h5read(strcat(hdf5_data_path ,'/', cases{i}), ...
        '/scalar/PV_norm');
    % density
    Rho{i} = h5read(strcat(hdf5_data_path ,'/', cases{i}), ...
        '/scalar/RHO');
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
l = cell(1,1);
lm = cell(1,1);
ln = cell(1,1);
phi = cell(1,1);
phim = cell(1,1);
phin = cell(1,1);
g = cell(1,1);
gn = cell(1,1);
for i = c:c
    l{i}=edata_dble{i}(7,:).*dx;
    lm{i}=mean(edata_dble{i}(7,:).*dx);
    ln{i}=l{i}./lm{i};
    phi{i}=edata_dble{i}(10,:);
    phim{i}=mean(edata_dble{i}(10,:));
    phin{i}=phi{i}./phim{i};
    g{i} = phi{i}./l{i};
    gn{i} = (phi{i}./phim{i})./(l{i}./lm{i});
end


% read additional data
Cchi = readmatrix(strcat(Data_path, CchiDataFile));
FlameletData = readtable(RelevantFlameletData);
DissipationFlamelets = readtable(strcat(Fig_outpath, ...
    'DissipationElementFlamelet.csv'));


%% convert table to mat
% row 1: DE_id
% row 2: Tinlet (flamelet)
% row 3: StrainRate (flamelet)
% row 4: dZprime
% row 5: gprime
mat = table2array(DissipationFlamelets)';
DE_Zst = height(DissipationFlamelets);
Data_path_ = strcat(Data_path, DE_InputFiles{c});
data = readmatrix(Data_path_);


%% extract dissipation elements in a defined g' range
% g' range
%[~, dZprime_idx] = max(mat(4,:));
%target_gprime = max(mat(5, dZprime_idx));
for h = 1:length(Target_gprime)
    target_gprime = Target_gprime(h);
    fprintf("Analyse dissipation elements => g'=%e\n", target_gprime);
    
    % allocate memory
    matrix_chi = [];
    matrix_hr = [];
    matrix_tgas = [];
    matrix_yoh = [];
    for i = 1:DE_Zst
        
        % consider only dissipation elements in tolerance range
        if (mat(5,i) >= target_gprime + tol_gprime) || ( ...
                mat(5,i) <= target_gprime - tol_gprime)
            continue;
        end
        %fprintf('Create figure for DE %i - %i/%i\n', i, i, DE_Zst);
    
        % extract grid points of dissipation element in domain
        [DE_id, x_coords, y_coords, z_coords] = DE_GetGridPoints( ...
            data(:,i));
        chi = DE_ExtractData(Chi{c}, x_coords, y_coords, z_coords);
        hr = DE_ExtractData(HR{c}, x_coords, y_coords, z_coords);
        tgas = DE_ExtractData(Tgas{c}, x_coords, y_coords, z_coords);
        yoh = DE_ExtractData(YOH{c}, x_coords, y_coords, z_coords);
        zmix = DE_ExtractData(Zmix{c}, x_coords, y_coords, z_coords);
    
        %
        thickness = CalculateThickness(chi, zmix);
        matrix_chi = [matrix_chi, [thickness, mat(4,i)]'];
        thickness = CalculateThickness(hr, zmix);
        matrix_hr = [matrix_hr, [thickness, mat(4,i)]'];
        thickness = CalculateThickness(tgas, zmix);
        matrix_tgas = [matrix_tgas, [thickness, mat(4,i)]'];
        thickness = CalculateThickness(yoh, zmix);
        matrix_yoh = [matrix_yoh, [thickness, mat(4,i)]'];
    end
    cols_to_remove = matrix_chi(1, :) == -1;
    matrix_chi(:, cols_to_remove) = [];
    cols_to_remove = matrix_hr(1, :) == -1;
    matrix_hr(:, cols_to_remove) = [];
    cols_to_remove = matrix_tgas(1, :) == -1;
    matrix_tgas(:, cols_to_remove) = [];
    cols_to_remove = matrix_yoh(1, :) == -1;
    matrix_yoh(:, cols_to_remove) = [];
    
    
    %% create figure: scatter
    close all
    var = {'Chi', 'HR', 'Tgas', 'Yoh'};
    for i = 1:length(var)
        %
        close all
    
        %
        figure(i)
        
        % layout
        t = tiledlayout(1,1);
        t.TileSpacing = 'compact';
        t.Padding = 'loose'; 
        
        % background
        set(gcf,'color','w');
        set(gca, 'Box', 'on');
        
        % plot
        if strcmp(var{i}, 'Chi')
            xdata = matrix_chi(2,:);
            ydata = matrix_chi(1,:);
            yaxislabel = '$\mathrm{\chi}|_\mathrm{DE,max}$';
        elseif strcmp(var{i}, 'HR')
            xdata = matrix_hr(2,:);
            ydata = matrix_hr(1,:);
            yaxislabel = '$\mathrm{\omega_\mathrm{T}}|_\mathrm{DE,max}$';
        elseif strcmp(var{i}, 'Tgas')
            xdata = matrix_tgas(2,:);
            ydata = matrix_tgas(1,:);
            yaxislabel = '$\mathrm{T_\mathrm{gas}}|_\mathrm{DE,max}$';
        elseif strcmp(var{i}, 'Yoh')
            xdata = matrix_yoh(2,:);
            ydata = matrix_yoh(1,:);
            yaxislabel = '$\mathrm{Y_\mathrm{OH}}|_\mathrm{DE,max}$';
        end
        %scatter(xdata, ydata, 50, 'blue', 'o');
        plot(xdata, ydata, 'o', 'MarkerSize', 4, ...
            'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'red', ...
            'LineWidth', lw);
        % plot(xdata, ydata, 'x-', 'LineWidth', lw+1, ...
        %     'Marker', 'x', 'Color', 'black', ...
        %     'HandleVisibility', 'off');
        
        % labels
        xlabel('$\Delta Z^{\prime}$ [-]', ...
            'fontsize', FZ, 'interpreter', 'latex', ...
            'FontWeight', 'bold');
        ylabel(yaxislabel, 'fontsize', FZ, ...
            'interpreter', 'latex', 'FontWeight', 'bold');
        
        % background
        set(gca, 'Box', 'on');
        
        % figure name
        outfname = strcat(Fig_outpath, ofname, 'Scatter_', var{i}, ...
            '_gprime', num2str(target_gprime));
        
        % save figure
        if strcmp(FigFormat, 'png')
            saveas(gca, strcat(outfname, '.png'), 'png');
        elseif strcmp(FigFormat, 'eps')
            saveas(gca, strcat(outfname, '.eps'), 'epsc');
        elseif strcmp(FigFormat, 'pdf')
            exportgraphics(gca, strcat(outfname, '.pdf'), ...
                'ContentType', 'vector');
        else
            fprintf(['\nInvalid figure format (%s)\n => ' ...
                'png/eps/pdf\n'], FigFormat);
            return
        end
    end
    
    
     %% create figure: profile
    close all
    var = {'Chi', 'HR', 'Tgas', 'YOH'};
    for i = 1:length(var)
        
        %
        close all
        figure(i)
        
        % layout
        t = tiledlayout(1,1);
        t.TileSpacing = 'compact';
        t.Padding = 'loose'; 
        
        % background
        set(gcf,'color','w');
        set(gca, 'Box', 'on');
        
        % allocate memory
        DataPoints = {};
        FlameletData_Zmix = {};
        FlameletData_Chi = {};
        FlameletData_HR = {};
        FlameletData_Tgas = {};
        FlameletData_YOH = {};
    
        % get data points
        for j = 1:length(dZprime_points)
            %fprintf('\ndZprime ~> %i', dZprime_points(j));
            for k = 1:DE_Zst
                if (mat(5,k) >= target_gprime + tol_gprime) || ( ...
                        mat(5,k) <= target_gprime - tol_gprime)
                    continue;
                end
                if (mat(4,k) >= dZprime_points(j) + tol_dZprime) || ( ...
                        mat(4,k) <= dZprime_points(j) - tol_dZprime)
                    continue;
                end
    
                % define the desired Tinlet and strain values
                desired_Tinlet = mat(2,k);      % Example: 0300 -> 300
                desired_strain = mat(3,k);      % Example: 000 -> 0
                for jj = 1:length(csv_files)
                    filename = csv_files(jj).name;
                    
                    % Extract the Tinlet and strain from the filename
                    tokens = regexp(filename, ...
                        'Data_yiend\.(\d+)\.(\d+)\.csv', 'tokens');
            
                    if ~isempty(tokens)
                        % Convert to number
                        Tinlet = str2double(tokens{1}{1});
                        strain = str2double(tokens{1}{2});
    
                        % Check if the file matches the desired values
                        if (Tinlet == desired_Tinlet) && (strain == ...
                                desired_strain)
                            % Read the data
                            flamelet_data = readtable(fullfile( ...
                                Dataf_path, filename), ...
                                'Delimiter', '\t', ...
                                'PreserveVariableNames', true);
                            FlameletData_Zmix{end + 1} = flamelet_data.Z;
                            FlameletData_Chi{end + 1} = flamelet_data.chi;
                            FlameletData_HR{end + 1} = flamelet_data.HeatRelease;
                            FlameletData_Tgas{end + 1} = flamelet_data.Temp;
                            FlameletData_YOH{end + 1} = flamelet_data.OH;
                            %fprintf('\nTinlet = %i, StrainRate = %i\n', ...
                            %    Tinlet, strain);
                            %fprintf(['\nFile %s read successfully => ' ...
                            %    'DE(id)=%e\n'], filename, mat(1,k));
                            % Stop after finding the first matching file
                            break;
                        end
                    end
                end
    
                [DE_id, x_coords, y_coords, ...
                    z_coords] = DE_GetGridPoints(data(:,k));
                zmix = DE_ExtractData(Zmix{c}, x_coords, y_coords, ...
                    z_coords);
                if strcmp(var{i}, 'Chi')
                    y = DE_ExtractData(Chi{c}, x_coords, y_coords, ...
                        z_coords);
                elseif strcmp(var{i}, 'HR')
                    y = DE_ExtractData(HR{c}, x_coords, y_coords, ...
                        z_coords);
                elseif strcmp(var{i}, 'Tgas')
                    y = DE_ExtractData(Tgas{c}, x_coords, y_coords, ...
                        z_coords);
                elseif strcmp(var{i}, 'YOH')
                    y = DE_ExtractData(YOH{c}, x_coords, y_coords, ...
                        z_coords);
                end
                DataPoints{end + 1} = zmix;
                DataPoints{end + 1} = y;
                %fprintf('Added: dZprime = %i, gprime = %i\n', ...
                %    mat(4,k), mat(5,k));
                break
            end
    
            % fill with [] if no dissipation element is present
            if length(DataPoints) ~= 2*j
                DataPoints{end + 1} = [];
                DataPoints{end + 1} = [];
            end
        end
        
        % ylabel
        if strcmp(var{i}, 'HR')
            yaxislabel = '$\mathrm{\omega_\mathrm{T}} @ \mathrm{DE}$';
        elseif strcmp(var{i}, 'Tgas')
            yaxislabel = '$\mathrm{T_\mathrm{gas}} @ \mathrm{DE}$';
            elseif strcmp(var{i}, 'Chi')
            yaxislabel = '$\mathrm{\chi} @ \mathrm{DE}$';
        elseif strcmp(var{i}, 'YOH')
            yaxislabel = '$\mathrm{Y_\mathrm{OH}} @ \mathrm{DE}$';
        end
    
        % Colormap with the same length as points
        cmap = turbo(length(dZprime_points));
        % Number of colors available
        numColors = size(cmap, 1);
        % Initialize color index
        colorIndex = 1;
        % Initialize flamelet index
        idx_flamelet = 0;
    
        % create figure
        for j = 1:2:length(DataPoints)
            color = cmap(colorIndex,:);
            xdata = DataPoints{j};
            ydata = DataPoints{j+1};
            XData = squeeze(xdata(:));
            YData = squeeze(ydata(:));
            if ~isempty(XData)
                idx_flamelet = idx_flamelet + 1;
                hold on;
                % dissipation element
                plot(xdata, ydata, 'o', 'MarkerSize', 4, ...
                    'MarkerFaceColor', color, ...
                    'MarkerEdgeColor', color, 'LineWidth', 1);
                hold on;
                % conditional mean
                n_bins_cm = 10;
                [x1_data,avg_data] = CellDataAvg(XData, YData, ...
                    n_bins_cm, [min(XData) max(XData)], 1, sf, factor);
                plot(x1_data, avg_data, 'Color', color, ...
                    'LineWidth', lw+1);
                hold on;
                % flamelet
                %fprintf('\nIDX: %i\n', colorIndex);
                if strcmp(var{i}, 'Chi')
                    plot(FlameletData_Zmix{idx_flamelet}, ...
                        FlameletData_Chi{idx_flamelet}, ...
                        'Color', color, 'LineWidth', lw+1, ...
                        'LineStyle','--');
                elseif strcmp(var{i}, 'HR')
                    plot(FlameletData_Zmix{idx_flamelet}, ...
                        FlameletData_HR{idx_flamelet}, ...
                        'Color', color, 'LineWidth', lw+1, ...
                        'LineStyle','--');
                elseif strcmp(var{i}, 'Tgas')
                    plot(FlameletData_Zmix{idx_flamelet}, ...
                        FlameletData_Tgas{idx_flamelet}, ...
                        'Color', color, 'LineWidth', lw+1, ...
                        'LineStyle','--');
                elseif strcmp(var{i}, 'YOH')
                    plot(FlameletData_Zmix{idx_flamelet}, ...
                        FlameletData_YOH{idx_flamelet}, ...
                        'Color', color, 'LineWidth', lw+1, ...
                        'LineStyle','--');
                end
                hold on;
            end
            hold on;
            colorIndex = colorIndex + 1;
            
            % wrap around the color index if it exceeds numColors
            if colorIndex > numColors
                colorIndex = 1;
            end
        end
    
        % colorbar
        cb = colorbar;
        colormap(cmap);
        %min_ = min(dZprime_points) - 0.25;
        %max_ = max(dZprime_points) + 0.25;
        min_ = min(dZprime_points) - 0.5*(dZprime_points(2) - ...
            dZprime_points(1));
        max_ = max(dZprime_points) + 0.5*(dZprime_points(2) - ...
            dZprime_points(1));
        caxis([min_, max_]);
        cb.TickLabelInterpreter = 'latex';
        ylabel(cb, '$\Delta Z^{\prime}$', 'fontsize', FZ, ...
            'interpreter', 'latex', 'FontWeight', 'bold')
        cb.Ticks = dZprime_points;
    
        % limits
        xlim([0 0.2])
    
        % labels
        xlabel('$Z_\mathrm{mix}$ [-]', ...
            'fontsize', FZ, 'interpreter', 'latex', ...
            'FontWeight', 'bold');
        ylabel(yaxislabel, 'fontsize', FZ, ...
            'interpreter', 'latex', 'FontWeight', 'bold');
        legend({'', 'DE', 'Flamelet'}, 'Location', 'best');
        legend boxoff;
    
        % background
        set(gca, 'Box', 'on');
        
        % figure name
        outfname = strcat(Fig_outpath, ofname, '_Profile_', var{i}, ...
            '_gprime', num2str(target_gprime));
        
        % save figure
        if strcmp(FigFormat, 'png')
            saveas(gca, strcat(outfname, '.png'), 'png');
        elseif strcmp(FigFormat, 'eps')
            saveas(gca, strcat(outfname, '.eps'), 'epsc');
        elseif strcmp(FigFormat, 'pdf')
            exportgraphics(gca, strcat(outfname, '.pdf'), ...
                'ContentType', 'vector');
        else
            fprintf(['\nInvalid figure format (%s)\n => ' ...
                'png/eps/pdf\n'], FigFormat);
            return
        end
    end
end


% functions
function thickness = CalculateThickness(para, zmix)
    [~, max_idx] = max(para);
    zmixmax = zmix(max_idx);
    zmix_max = zmixmax * 1.05;
    zmix_min = zmixmax * 0.95;
    zmix(zmix < zmix_min| zmix > zmix_max) = 0;
    if nnz(zmix) <= 1
        %fprintf(['\nIncrease tolerance! This dissipation element is ' ...
        %    'ignored now!']);
        %continue
        thickness = -1;
    else
        idx_nnz = find(zmix);
        para_ = para(idx_nnz);
        thickness = max(para_); %- min(para_);
    end
end