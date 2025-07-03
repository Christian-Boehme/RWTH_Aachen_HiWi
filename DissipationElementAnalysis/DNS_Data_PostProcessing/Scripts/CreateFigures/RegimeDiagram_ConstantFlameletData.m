clc
clear
close all
addpath('~/NHR/DE_Analysis/MatlabFunctions');


% ================================
% regime diagram: dZprime over gprime
% => based on maximum chi (flamelet)
% ================================


%====
% INPUTS
%====
hdf5_data_path = ['~/itv/OXYFLAME-B3/File_Transfer/DE_analysis_code/' ...
    'trajSearch/Dataset'];
cases= {'traj_Tbox_ign.h5', 'traj_Tbox_OHmax.h5', ...
    'traj_Tbox_fullComb.h5', 'traj_Tbox_finish.h5'};
Data_path = '../../PostProcessedData/';
Fig_outpath = '../../Figures/RegimeDiagram_ConstantFlameletData/';
DE_InputFiles = {'DEGridpointsZst_ign.csv', ...
    'DEGridpointsZst_OHmax.csv', ...
    'DEGridpointsZst_fullComb.csv',...
    'DEGridpointsZst_final.csv'};
FlameletData = 'QuenchingData_FlameletsNicolai.csv';
ofname = 'RegimeDiagram_';
% create regime diagram for case c
c = 2;
% ensure that both thresholds are visible (xlim([0 2]) & ylim([0 16]))
% otherwise (xlim([0 0.4]) & ylim([0 2]))
threshold = true;
%createdZrFigure = false;
%sorted = true;
% DNS grid size
dx = 5E-5;
% quenching gradient - flamelet data
g_quenching = {8.726042e+02, 1.008789e+03, 1.008789e+03, 0}; % [1/m]
g_quench = g_quenching{c};
% figure is colored by [Chi; Enth; HR; PV; PVnorm; Tgas; YOH; Zmix]
% one or multiple variables
var = {'Chi', 'Enth', 'HR', 'PV', 'PVnorm', 'Tgas', 'YOH', 'Zmix'};
n_bins_ = {10, 50, 10, 50};
n_bins = n_bins_{c};
sf = 0.01;
factor= 2e-5;
% save figure in [png, eps, pdf]
FigFormat = 'png';
%====


% create output directory
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


% read data
Chi = cell(1,c);
Cp = cell(1,c);
Enth = cell(1,c);
HR = cell(1,c);
Lambda = cell(1,c);
PV = cell(1,c);
PVnorm = cell(1,c);
Rho = cell(1,c);
Tgas = cell(1,c);
YOH = cell(1,c);
Zmix = cell(1,c);
edata_dble = cell(1,c);
for i = c:c
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
l = cell(1,c);
lm = cell(1,c);
ln = cell(1,c);
phi = cell(1,c);
phim = cell(1,c);
phin = cell(1,c);
g = cell(1,c);
gn = cell(1,c);
for i = c:c
    l{i}=edata_dble{i}(7,:) .* dx;
    lm{i}=mean(edata_dble{i}(7,:) .* dx);
    ln{i}=l{i}./lm{i};
    phi{i}=edata_dble{i}(10,:);
    phim{i}=mean(edata_dble{i}(10,:));
    phin{i}=phi{i}./phim{i};
    g{i} = phi{i}./l{i};
    gn{i} = (phi{i}./phim{i})./(l{i}./lm{i});
end


% read flamelet data
flamelet_data = readtable(strcat(Data_path, FlameletData), ...
    'Delimiter', '\t', 'PreserveVariableNames', true);


% calculate/get regime diagram relevant data
for i = c:c
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
        enth = DE_ExtractData(Enth{i}, x_coords, y_coords, z_coords);
        hr = DE_ExtractData(HR{i}, x_coords, y_coords, z_coords);
        pv = DE_ExtractData(PV{i}, x_coords, y_coords, z_coords);
        pvnorm = DE_ExtractData(PVnorm{i}, x_coords, y_coords, ...
            z_coords);
        tgas = DE_ExtractData(Tgas{i}, x_coords, y_coords, z_coords);
        yoh = DE_ExtractData(YOH{i}, x_coords, y_coords, z_coords);
        zmix = DE_ExtractData(Zmix{i}, x_coords, y_coords, z_coords);

        % calculate reaction zone thickness
        %[dZr, Z_wmax] = ComputeReactionZoneThickness(hr, zmix, ...
        %    cases{i}, j, createdZrFigure, lw, FZ, Fig_outpath, ...
        %    FigFormat, sorted);

        % Tinlet from DE
        Tin = mean(tgas);

        % get flamelet data
        [dZr, ~] = GetRespectiveFlameletData(flamelet_data, Tin);
        gq = g_quench;

        % get corresponding DE data
        DE_dZ = phim{i}(DE_id);
        DE_g = g{i}(DE_id);

        % mean data in DE
        chi_ = mean(chi);
        enth_ = mean(enth);
        hr_ = mean(hr);
        pv_ = mean(pv);
        pvnorm_ = mean(pvnorm);
        tgas_ = mean(tgas);
        yoh_ = mean(yoh);
        zmix_ = mean(zmix);

        % regime diagram variables
        %fprintf('\nDE_dZ = %e and dZr = %e => DE_dZ/dZr = %e', DE_dZ, dZr, DE_dZ/dZr);
        %fprintf('\nDE_g = %e and gq = %e => DE_g/gq = %e', DE_g, gq, DE_g/gq);
        dZprime = DE_dZ / dZr;
        gprime = DE_g / gq;

        % store data in matrix
        mat = [mat, [DE_id, Tin, dZr, gq, DE_g, DE_dZ, ...
            dZprime, gprime, chi_, enth_, hr_, pv_, pvnorm_, ...
            tgas_, yoh_, zmix_]']; % works only if for loop c:c !!!
    end
end


% create regime diagram
for i = 1:length(var)

    % get variable
    var_ = var{i};

    % create regime diagram
    close all
    figure
    
    % layout
    t = tiledlayout(1,1);
    t.TileSpacing = 'compact';
    t.Padding = 'loose';                                                                                                                                                                                                                      
    nexttile([1, 1]);
    
    % background
    set(gcf,'color','w');
    
    % colorbar variable
    switch(var_)
        case 'Chi'
            cb_var = mat(9,:);
            cblabel = '$\chi \mathrm{[1/s]}$';
            lowLim = 0;
            %fprintf('Upper limit for Chi = %e\n', max(cb_var));
            upLim = 450;
        case 'Enth'
            cb_var = mat(10,:);
            cblabel = '$H \mathrm{[kJ/kg]}$';       % TODO correct??
            %fprintf('Lower limit for H = %e\n', min(cb_var));
            %fprintf('Upper limit for H = %e\n', max(cb_var));
            lowLim = -1000;
            upLim = -600;
        case 'HR'
            cb_var = mat(11,:);
            cblabel = '$\omega_\mathrm{T} \mathrm{[J/m^{3}/s]}$';
            lowLim = 0;
            %fprintf('Upper limit for HR = %e\n', max(cb_var));
            upLim = 2.5E10;
        case 'PV'
            cb_var = mat(12,:);
            cblabel = '$PV \mathrm{[-]}$';
            lowLim = 0;
            %fprintf('Upper limit for PV = %e\n', max(cb_var));
            upLim = 5E-03;
        case 'PVnorm'
            cb_var = mat(13,:);
            cblabel = '$PV_\mathrm{norm} \mathrm{[-]}$';
            lowLim = 0; % TODO
            upLim = max(cb_var); % TODO
            upLim = 1; % TODO
        case 'Tgas'
            cb_var = mat(14,:);
            cblabel = '$T_\mathrm{gas} \mathrm{[K]}$';
            lowLim = 0; 
            %fprintf('Upper limit for Tgas = %e\n', max(cb_var));
            upLim = 2200;
        case 'YOH'
            cb_var = mat(15,:);
            cblabel = '$Y_\mathrm{OH} \mathrm{[-]}$';
            lowLim = 0;
            %fprintf('Upper limit for YOH = %e\n', max(cb_var));
            upLim = 0.012;
        case 'Zmix'
            cb_var = mat(16,:);
            cblabel = '$Z_\mathrm{mix} \mathrm{[-]}$';
            lowLim = 0;
            %fprintf('Upper limit for Zmix = %e\n', max(cb_var));
            upLim = 0.1;
        otherwise
            fprintf('\nInvalid input!');
            return
    end


    % plot
    x = mat(8,:); % dgprime
    y = mat(7,:); % dZprime
    z = cb_var;

    % color figure
    XData = squeeze(x(:));
    YData = squeeze(y(:));
    [x1,x2,cond_mean ] = ComputeConditionalMeanHistograms2D(z, x, y, ...
        n_bins);
    s=imagesc(x1,x2,cond_mean);
    set(s, 'AlphaData', ~isnan(cond_mean));
    set(gca,'YDir','normal');
    hold on;
    cb = colorbar('eastoutside');
    colormap(jet);
    caxis([lowLim upLim]);
    set(cb, 'TickLabelInterpreter', 'latex');
    ylabel(cb, cblabel, 'fontsize', FZ, 'interpreter', 'latex');

    % threshold lines
    xline(1, '--k', 'LineWidth', lw+1, 'HandleVisibility', 'off');
    hold on;
    yline(15, '--k', 'LineWidth', lw+1, 'HandleVisibility', 'off');
    hold on;

    % lim and ticks    
    if ~threshold
        xlim([0 0.4]);
        ylim([0 2]);
        xtick_positions = linspace(0, 0.4, 5);
        set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
        ytick_positions = linspace(0, 2, 5);
        set(gca, 'YTick', ytick_positions, 'LineWidth', lw);
    else
        xlim([0 2]);
        ylim([0 16]);
        xtick_positions = linspace(0, 2, 5);
        set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
        ytick_positions = linspace(0, 16, 5);
        set(gca, 'YTick', ytick_positions, 'LineWidth', lw);
    end

    % labels and title
    xlabel('$g^{\prime} \mathrm{[-]}$', 'fontsize', FZ, ...
        'interpreter', 'latex', 'FontWeight', 'bold');
    ylabel('$\Delta Z^{\prime} \mathrm{[-]}$', ...
        'fontsize', FZ, 'interpreter', 'latex', 'FontWeight', 'bold');
    %header = sprintf('case: %s', cases{c}(1:end-3));
    %title(header, 'fontsize', FZ, 'Interpreter', 'latex');
            
    % format
    set(gca, 'Box', 'on');
    ComputeConditionalMeanHistograms2D.m
    % figure name
    time = split(cases{c}(1:end-3), '_');
    if ~threshold
        outfname = strcat(Fig_outpath, ofname, time{end}, '_', var_);
    else
        outfname = strcat(Fig_outpath, ofname, 'threshold_', ...
            time{end}, '_', var_);
    end

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
end


% functions
function [DE_dZr, DE_gq] = GetRespectiveFlameletData(data, T)

    % get Tinlet levels
    Tin_data = data.InletTemp;
    dZr_data = data.dZr;
    gq_data = data.g_q;

    % find the closest temperature level and index
    [~, idx] = min(abs(Tin_data - T));
    DE_Tinlet = Tin_data(idx);
    if DE_Tinlet ~= 1500
        fprintf('Tinlet is: %i\n', DE_Tinlet);
    end

    % reaction zone thickness
    DE_dZr = dZr_data(idx);

    % reaction zone thickness
    DE_gq = gq_data(idx);

end
