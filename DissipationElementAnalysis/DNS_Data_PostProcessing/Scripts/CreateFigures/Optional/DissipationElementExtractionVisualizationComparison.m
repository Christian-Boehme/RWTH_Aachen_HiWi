clc
clear
close all
addpath('../../../MatlabFunctions/');


% ================================
% regime diagram: dZprime over gprime
% -> individual flamelets for each dissipation element
% => based on dissipation rate in dissipation element
% ================================


%====
% INPUTS
%====
hdf5_data_path = ['~/itv/OXYFLAME-B3/File_Transfer/DE_analysis_code/' ...
    'trajSearch/Dataset'];
cases= {'traj_Tbox_ign.h5', 'traj_Tbox_OHmax.h5', ...
    'traj_Tbox_fullComb.h5', 'traj_Tbox_finish.h5'};
Data_path = '../../PostProcessedData/';
Fig_outpath = '../../Figures/Analysis/';                        % TODO subfolder or must be empty!
DE_InputFiles = {'DEGridpointsZst_ign.csv', ...
    'DEGridpointsZst_OHmax.csv', ...
    'DEGridpointsZst_fullComb.csv',...
    'DEGridpointsZst_final.csv'};
RelevantFlameletData = ['../../../Flamelets/Cantera/OutputData/' ...
    'FlameletData/PostProcessedFlameletData.csv'];
CchiDataFile = 'AverageRatioCchi_BasedOnDNS.csv';
VisualizationFolder = 'DissipationElementVisualization/';
Visualization_ofname = 'Visualization_';
RegimeFolder = 'RegimeDiagram/';
Regime_ofname = 'RegimeDiagram_';
% create regime diagram for case c
c = 2;
% extract dissipation elements in range ymin to ymax -> dZ' axis!
threshold_extraction = [0, 2];
% ensure that both thresholds are visible
threshold = false;
% DNS grid size
dx = 5E-5;
% figure title
FigureHeader = {'$t$=0.50ms', '$t$=0.65ms', '$t$=0.75ms', '$t$=1.00ms'};
% stoichiometric mixture fraction
Z_st = 0.117;
% regime diagram is colored by [Chi; Enth; HR; PV; PVnorm; Tgas; YOH; Zmix]
% one or multiple variables
var = {'DE_dZ', 'dZr', 'DE_g', 'gq', 'DE_chi', 'DE_d', 'Chi', 'Enth', 'HR', 'PV', 'PVnorm', 'Tgas', 'YOH', 'Zmix'};
%
n_bins_ = {10, 30, 10, 30};
n_bins = n_bins_{c};
% n_bins for mean(t) - PDF approach
n_bins_Tpdf = 100;
% visualize dissipation element as ['Scatter', 'Surface', 
% 'Trajectory']
Visualization = 'Scatter';
markersize = 50; % if Visualization is Scatter
% save figure in [png, eps, pdf]
FigFormat = 'png';
%====


% create output directory
sim_case = split(cases{c}(1:end-3), '_');
ThresholdFoler = strcat('Case_', sim_case{end}, '_threshold_ymin_', ...
    num2str(threshold_extraction(1)), '_ymax_', ...
    num2str(threshold_extraction(2)), '/');
if Data_path(end) ~= '/'
    Data_path = [Data_path, '/'];
end
if Fig_outpath(end) ~= '/'
    Fig_outpath = [Fig_outpath, '/'];
end
if RegimeFolder(end) ~= '/'
    RegimeFolder = [RegimeFolder, '/'];
end
if VisualizationFolder(end) ~= '/'
    VisualizationFolder = [VisualizationFolder, '/'];
end

RegimeFolder = strcat(Fig_outpath, ThresholdFoler, RegimeFolder);
absPath = pwd;
VisualizationFolder = fullfile(absPath, strcat(Fig_outpath, ThresholdFoler, ...
    VisualizationFolder));

if ~exist(Fig_outpath, 'dir')
    mkdir(Fig_outpath);
end
if ~exist(RegimeFolder, 'dir')
    mkdir(RegimeFolder);
end
if ~exist(VisualizationFolder, 'dir')
    mkdir(VisualizationFolder);
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


%% compute data for regime diagram (dissipation rate flamelet fitting)
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
    l{i}=edata_dble{i}(7,:);
    lm{i}=mean(edata_dble{i}(7,:));
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


% calculate/get relevant data for the regime diagram
for i = c:c
    % full path
    Data_path_ = strcat(Data_path, DE_InputFiles{i});

    % read the csv file
    data = readmatrix(Data_path_);
    
    % number of dissipation elements
    [~, num_columns] = size(data);
    DE_Zst = num_columns;

    % coefficient C_chi
    C_chi = Cchi(i);

    % allocate memory
    DE_id_extracted = [];
    mat_min = [];
    mat_mean = [];
    mat_max = [];

    for j = 1:DE_Zst
        % DE data
        [DE_id, x_coords, y_coords, z_coords] = DE_GetGridPoints( ...
            data(:,j));

        % get corresponding data points
        chi = DE_ExtractData(Chi{i}, x_coords, y_coords, z_coords);
        cp = DE_ExtractData(Cp{i}, x_coords, y_coords, z_coords);
        enth = DE_ExtractData(Enth{i}, x_coords, y_coords, z_coords);
        hr = DE_ExtractData(HR{i}, x_coords, y_coords, z_coords);
        lambda = DE_ExtractData(Lambda{i}, x_coords, y_coords, z_coords);
        pv = DE_ExtractData(PV{i}, x_coords, y_coords, z_coords);
        pvnorm = DE_ExtractData(PVnorm{i}, x_coords, y_coords, ...
            z_coords);
        rho = DE_ExtractData(Rho{i}, x_coords, y_coords, z_coords);
        tgas = DE_ExtractData(Tgas{i}, x_coords, y_coords, z_coords);
        yoh = DE_ExtractData(YOH{i}, x_coords, y_coords, z_coords);
        zmix = DE_ExtractData(Zmix{i}, x_coords, y_coords, z_coords);

        % diffusion coefficient from dissipation element (Le=1)
        DE_d = mean(lambda ./ (rho .* cp)); % [m²/s]

        % dissipation rate from dissipation element
        DE_g = g{i}(DE_id) * (1/dx);        % [1/m]
        DE_chi = C_chi * DE_d * DE_g^2;     % [1/s]

        % inlet temperature => PDF
        Tinlet_ = DE_TinletFromTempPDF(tgas, n_bins_Tpdf);
        Tinlet = round(Tinlet_, -2);
        if Tinlet > 1500
            Tinlet = 1500;
        end

        % get respective flamelet
        FilteredFlamelts = FlameletData.Tinlet == Tinlet;
        [~, idx] = min(abs(FlameletData.ChiSt(FilteredFlamelts) - DE_chi));

%         Flamelet_Tinlet = FlameletData.Tinlet(FilteredFlamelts);
%         Flamelet_Tinlet = Flamelet_Tinlet(idx);
%         disp(Flamelet_Tinlet);
%         Flamelet_StrainRate = FlameletData.StrainRate(FilteredFlamelts);
%         Flamelet_StrainRate = Flamelet_StrainRate(idx);
%         disp(Flamelet_StrainRate);
%         Flamelet_ChiSt = FlameletData.ChiSt(FilteredFlamelts);
%         Flamelet_ChiSt = Flamelet_ChiSt(idx);
%         disp(Flamelet_ChiSt);

        % reaction zone thickness from flamelet
        dZr = FlameletData.dZr(FilteredFlamelts);
        dZr = dZr(idx);

        % quenching gradient: gq
        Chi_qu = FlameletData.ChiQu(FilteredFlamelts);
        Chi_qu = Chi_qu(idx);
        D_st = FlameletData.DSt(FilteredFlamelts);
        D_st = D_st(idx);
        gq = (Chi_qu / (C_chi * 2 * D_st))^0.5;

        % get corresponding DE data
        DE_dZ = phi{i}(DE_id);

        % regime diagram variables
%         fprintf('\nDE_dZ = %e and dZr = %e => DE_dZ/dZr = %e', ...
%             DE_dZ, dZr, DE_dZ/dZr);
%         fprintf('\nDE_g = %e and gq = %e => DE_g/gq = %e', ...
%             DE_g, gq, DE_g/gq);
        dZprime = DE_dZ / dZr;
        gprime = DE_g / gq;

        % add data to matrix - "min"
        chi_ = min(chi);
        enth_ = min(enth);
        hr_ = min(hr);
        pv_ = min(pv);
        pvnorm_ = min(pvnorm);
        tgas_ = min(tgas);
        yoh_ = min(yoh);
        zmix_ = min(zmix);
        % add data
        mat_min = [mat_min, [DE_id, DE_dZ, dZr, dZprime, DE_g, gq, ...
            gprime, DE_chi, DE_d, chi_, enth_, hr_, pv_, pvnorm_, ...
            tgas_, yoh_, zmix_]'];

        % add data to matrix - "mean"
        chi_ = mean(chi);
        enth_ = mean(enth);
        hr_ = mean(hr);
        pv_ = mean(pv);
        pvnorm_ = mean(pvnorm);
        tgas_ = mean(tgas);
        yoh_ = mean(yoh);
        zmix_ = mean(zmix);
        % add data
        mat_mean = [mat_mean, [DE_id, DE_dZ, dZr, dZprime, DE_g, gq, ...
            gprime, DE_chi, DE_d, chi_, enth_, hr_, pv_, pvnorm_, ...
            tgas_, yoh_, zmix_]'];

        % add data to matrix - "max"
        chi_ = max(chi);
        enth_ = max(enth);
        hr_ = max(hr);
        pv_ = max(pv);
        pvnorm_ = max(pvnorm);
        tgas_ = max(tgas);
        yoh_ = max(yoh);
        zmix_ = max(zmix);
        % add data
        mat_max = [mat_max, [DE_id, DE_dZ, dZr, dZprime, DE_g, gq, ...
            gprime, DE_chi, DE_d, chi_, enth_, hr_, pv_, pvnorm_, ...
            tgas_, yoh_, zmix_]'];

        % extract dissipation elements (id) in threshold range
        if (threshold_extraction(1) <= dZprime) && (dZprime <= ...
                threshold_extraction(2))
            DE_id_extracted = [DE_id_extracted, [mat_mean(1,j), j]'];
        end
    end
end


%% visualize dissipation elements
viz_vars = {'Chi', 'Enth', 'Cp', 'HR', 'Lambda', 'PV', 'PVnorm', ...
    'Rho', 'Tgas', 'YOH', 'Zmix'};
etraj = cell(1,length(DE_id_extracted));
etraj_int = cell(1,length(DE_id_extracted));
for i = c:c
    for j = 1:length(DE_id_extracted)
        keyname_etraj = strcat('/traj_full/etraj/etraj_', num2str(DE_id_extracted(j)));
        keyname_etraj_int = strcat('/traj_full/etraj/etraj_', num2str(DE_id_extracted(j)), '_int');
        etraj{j} = h5read(strcat(hdf5_data_path ,'/', cases{i}), ...
            keyname_etraj);
        etraj_int{j} = h5read(strcat(hdf5_data_path ,'/', cases{i}), ...
            keyname_etraj_int);
    end
end
return
%%
%%
for i = 1:length(DE_id_extracted)
    fprintf('\nCreating figure %i/%i', i, length(DE_id_extracted));
    FigDir = strcat(VisualizationFolder, 'DE_', ...
        sprintf('%05d', DE_id_extracted(1,i)), '_Visualization_', ...
        Visualization, '/');
    if ~exist(FigDir, 'dir')
        mkdir(FigDir);
    end
    for j = 1:length(viz_vars)
        viz_vars_ = viz_vars{j};
        switch(viz_vars_)
            case 'Chi'
                cbdata = Chi{c};
            case 'Cp'
                cbdata = Cp{c};
            case 'Enth'
                cbdata = Enth{c};
            case 'HR'
                cbdata = HR{c};
            case 'Lambda'
                cbdata = Lambda{c};
            case 'PV'
                cbdata = PV{c};
            case 'PVnorm'
                cbdata = PVnorm{c};
            case 'Rho'
                cbdata = Rho{c};
            case 'Tgas'
                cbdata = Tgas{c};
            case 'YOH'
                cbdata = YOH{c};
            case 'Zmix'
                cbdata = Zmix{c};
        end
        DE_Visualization(DE_id_extracted(1,i), data, ...
            DE_id_extracted(2,i), viz_vars_, cbdata, Visualization, ...
            markersize, FZ, FigDir, sim_case{end}, FigFormat);
    end
end


%% create regime diagram
DataSets = {'Min', 'Mean', 'Max'};
for i = 1:length(DataSets)
    
    %
    ColorApproach = DataSets{i};

    for j = 1:length(var)
    
        % get variable
        var_ = var{j};
    
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
            case 'DE_dZ'
                var_idx = 2;
                cb_var = mat_max(var_idx,:);
                cblabel = '$\Delta Z_\mathrm{DE}$ [-]';
                lowLim = 0; % TODO
                %upLim = max(cb_var); % TODO
                %fprintf('-> DE_dZ: %e\n', upLim);
                upLim = 0.25; % 0.248 % TODO
            case 'dZr'
                var_idx = 3;
                cb_var = mat_max(var_idx,:);
                cblabel = '$\delta Z_\mathrm{r}$ [-]';
                lowLim = 0; % TODO
                %upLim = max(cb_var); % TODO
                %fprintf('-> dZr: %e\n', upLim);
                upLim = 0.10; % 0.089 % TODO
            case 'DE_g'
                var_idx = 5;
                cb_var = mat_min(var_idx,:);
                cblabel = '$g_\mathrm{DE}$ [1/m]';
                lowLim = 0; % TODO
                %upLim = max(cb_var); % TODO
                %fprintf('-> DE_g: %e\n', upLim);
                upLim = 400; % 368 % TODO
            case 'gq'
                var_idx = 6;
                cb_var = mat_max(var_idx,:);
                cblabel = '$g_\mathrm{q}$ [1/m]';
                lowLim = 0; % TODO
                %upLim = max(cb_var); % TODO
                %fprintf('-> gq: %e\n', upLim);
                upLim = 700; % 669 % TODO
            case 'DE_chi'
                var_idx = 8;
                cb_var = mat_min(var_idx,:);
                cblabel = '$\chi_\mathrm{DE}$ [-]';
                lowLim = 0; % TODO
                %upLim = max(cb_var); % TODO
                %fprintf('-> DE_chi: %e\n', upLim);
                upLim = 125; % 111 % TODO
            case 'DE_d'
                var_idx = 9;
                cb_var = mat_max(var_idx,:);
                cblabel = '$D_\mathrm{DE}$ [-]';
                lowLim = 0; % TODO
                %upLim = max(cb_var); % TODO
                %fprintf('-> DE_d: %e\n', upLim);
                upLim = 0.0006; % 0.00057 % TODO
            case 'Chi'
                var_idx = 10;
                if strcmp(ColorApproach, 'Min')
                    cb_var = mat_min(var_idx,:);
                    cblabel = '$\chi_\mathrm{min}$ [1/s]';
                elseif strcmp(ColorApproach, 'Mean')
                    cb_var = mat_mean(var_idx,:);
                    cblabel = '$\chi_\mathrm{mean}$ [1/s]';
                elseif strcmp(ColorApproach, 'Max')
                    cb_var = mat_max(var_idx,:);
                    cblabel = '$\chi_\mathrm{max}$ [1/s]';
                end
                lowLim = 0; % TODO
                %upLim = max(cb_var); % TODO
                %fprintf('-> Chi: %e\n', upLim);
                upLim = 3500; % 3062 % TODO
            case 'Enth'
                var_idx = 11;
                if strcmp(ColorApproach, 'Min')
                    cblabel = '$H_\mathrm{min}$ [kJ/kg]';   % unit correct?
                    cb_var = mat_min(var_idx,:);
                elseif strcmp(ColorApproach, 'Mean')
                    cblabel = '$H_\mathrm{mean}$ [kJ/kg]';  % unit correct?
                    cb_var = mat_mean(var_idx,:);
                elseif strcmp(ColorApproach, 'Max')
                    cblabel = '$H_\mathrm{max}$ [kJ/kg]';   % unit correct?
                    cb_var = mat_max(var_idx,:);
                end
                %lowLim = min(cb_var); % TODO
                %upLim = max(cb_var); % TODO
                %fprintf('-> Enth: %e\n', upLim);
                lowLim = -1600; % -1568 % TODO
                upLim = -400; % -587 % TODO
            case 'HR'
                var_idx = 12;
                if strcmp(ColorApproach, 'Min')
                    cb_var = mat_min(var_idx,:);
                    cblabel = ['$\omega_\mathrm{T,min}$ $\mathrm{[' ...
                        'J/m^{3}/s]}$'];
                elseif strcmp(ColorApproach, 'Mean')
                    cb_var = mat_mean(var_idx,:);
                    cblabel = ['$\omega_\mathrm{T,mean}$ $\mathrm{[' ...
                        'J/m^{3}/s]}$'];
                elseif strcmp(ColorApproach, 'Max')
                    cb_var = mat_max(var_idx,:);
                    cblabel = ['$\omega_\mathrm{T,max}$ $\mathrm{[' ...
                        'J/m^{3}/s]}$'];
                end
                lowLim = 0; % TODO
                %upLim = max(cb_var); % TODO
                %fprintf('-> HR: %e\n', upLim);
                upLim = 7.0E10; % 6.05E10 % TODO
            case 'PV'
                var_idx = 13;
                if strcmp(ColorApproach, 'Min')
                    cb_var = mat_min(var_idx,:);
                    cblabel = '$PV_\mathrm{min}$ [-]';
                elseif strcmp(ColorApproach, 'Mean')
                    cb_var = mat_mean(var_idx,:);
                    cblabel = '$PV_\mathrm{mean}$ [-]';
                elseif strcmp(ColorApproach, 'Max')
                    cb_var = mat_max(var_idx,:);
                    cblabel = '$PV_\mathrm{max}$ [-]';
                end
                %lowLim = min(cb_var); % TODO
                %upLim = max(cb_var); % TODO
                %fprintf('-> PV: %e\n', upLim);
                %fprintf('-> lower limit PV: %e\n', lowLim);
                lowLim = -5E-03; % -4.603e-3 % TODO
                upLim = 10E-03; % 8.3e-3 % TODO
            case 'PVnorm'
                var_idx = 14;
                if strcmp(ColorApproach, 'Min')
                    cb_var = mat_min(var_idx,:);
                    cblabel = '$PV_\mathrm{norm,min}$ [-]';
                elseif strcmp(ColorApproach, 'Mean')
                    cb_var = mat_mean(var_idx,:);
                    cblabel = '$PV_\mathrm{norm,mean}$ [-]';
                elseif strcmp(ColorApproach, 'Max')
                    cb_var = mat_max(var_idx,:);
                    cblabel = '$PV_\mathrm{norm,max}$ [-]';
                end
                lowLim = 0; % TODO
                %upLim = max(cb_var); % TODO
                %fprintf('-> PVnorm: %e\n', upLim);
                upLim = 1; % 1 %TODO
            case 'Tgas'
                var_idx = 15;
                if strcmp(ColorApproach, 'Min')
                    cb_var = mat_min(var_idx,:);
                    cblabel = '$T_\mathrm{gas,min}$ [K]';
                elseif strcmp(ColorApproach, 'Mean')
                    cb_var = mat_mean(var_idx,:);
                    cblabel = '$T_\mathrm{gas,mean}$ [K]';
                elseif strcmp(ColorApproach, 'Max')
                    cb_var = mat_max(var_idx,:);
                    cblabel = '$T_\mathrm{gas,max}$ [K]';
                end
                lowLim = 0; % TODO
                %upLim = max(cb_var); % TODO
                %fprintf('-> Tgas: %e\n', upLim);
                upLim = 2500; % 2348 % TODO
            case 'YOH'
                var_idx = 16;
                if strcmp(ColorApproach, 'Min')
                    cb_var = mat_min(var_idx,:);
                    cblabel = '$Y_\mathrm{OH,min}$ [-]';
                elseif strcmp(ColorApproach, 'Mean')
                    cb_var = mat_mean(var_idx,:);
                    cblabel = '$Y_\mathrm{OH,mean}$ [-]';
                elseif strcmp(ColorApproach, 'Max')
                    cb_var = mat_max(var_idx,:);
                    cblabel = '$Y_\mathrm{OH,max}$ [-]';
                end
                lowLim = 0; % TODO
                %upLim = max(cb_var); % TODO
                %fprintf('-> YOH: %e\n', upLim);
                upLim = 0.014; % 0.013 % TODO
            case 'Zmix'
                var_idx = 17;
                if strcmp(ColorApproach, 'Min')
                    cb_var = mat_min(var_idx,:);
                    cblabel = '$Z_\mathrm{mix,min}$ [-]';
                elseif strcmp(ColorApproach, 'Mean')
                    cb_var = mat_mean(var_idx,:);
                    cblabel = '$Z_\mathrm{mix,mean}$ [-]';
                elseif strcmp(ColorApproach, 'Max')
                    cb_var = mat_max(var_idx,:);
                    cblabel = '$Z_\mathrm{mix,max}$ [-]';
                end
                lowLim = 0; % TODO
                %upLim = max(cb_var); % TODO
                %fprintf('-> Zmix: %e\n', upLim);
                upLim = 0.3; % 0.262 %TODO
            otherwise
                fprintf('\nInvalid variable!');
                return
        end

        % warning if max value is above the limit
        if max(cb_var) > upLim
            fprintf(['Max(%s) is > upper limit in colorbar!' ...
                '\n=>%e > %e\n'], var_, max(cb_var), upLim);
        end
        % warning if min value is below the limit
        if min(cb_var) < lowLim
            fprintf(['Min(%s) is < lower limit in colorbar!' ...
                '\n=>%e > %e\n'], var_, min(cb_var), lowLim);
        end


        % plot
        if strcmp(ColorApproach, 'Min')
            x = mat_min(7,:);   % dgprime
            y = mat_min(4,:);   % dZprime
        elseif strcmp(ColorApproach, 'Mean')
            x = mat_mean(7,:);  % dgprime
            y = mat_mean(4,:);  % dZprime
        elseif strcmp(ColorApproach, 'Max')
            x = mat_max(7,:);   % dgprime
            y = mat_max(4,:);   % dZprime
        end
        z = cb_var;

        % color figure
        XData = squeeze(x(:));
        YData = squeeze(y(:));
        [x1,x2,cond_mean ] = ComputeConditionalMeanHistograms2D( ...
            z, x, y, n_bins);
        s=imagesc(x1,x2,cond_mean);
        set(s, 'AlphaData', ~isnan(cond_mean));
        set(gca,'YDir','normal');
        hold on;

        % colorbar
        cb = colorbar('eastoutside');
        colormap(jet);
        caxis([lowLim upLim]);
        set(cb, 'TickLabelInterpreter', 'latex');
        ylabel(cb, cblabel, 'fontsize', FZ, 'interpreter', 'latex');
        if strcmp(var_, 'Enth')
            cb.Ticks = [-1600, -1400, -1200, -1000, -800, -600, -400];
        end
        if strcmp(var_, 'PV')
            cb.Ticks = [-5.0e-3, -2.5e-3, 0, 2.5e-3, 5.0e-3, 7.5e-3, ...
                10e-3];
        end

        % threshold lines - regime diagram
        xline(1, '--k', 'LineWidth', lw+1, 'HandleVisibility', 'off');
        hold on;
        yline(15, '--k', 'LineWidth', lw+1, 'HandleVisibility', 'off');
        hold on;

        % threshold lines - dissipatoin element extraction
        yline(threshold_extraction(1), '-k', 'LineWidth', lw+1, ...
            'HandleVisibility', 'off');
        hold on;
        yline(threshold_extraction(2), '-k', 'LineWidth', lw+1, ...
            'HandleVisibility', 'off');
        hold on;

        % lim and ticks    
        if ~threshold
            xmax = 1;
            ymax = 8;
            xlim([0 xmax]);
            ylim([0 ymax]);
            xtick_positions = linspace(0, xmax, 6);
            set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
            ytick_positions = linspace(0, ymax, 5);
            set(gca, 'YTick', ytick_positions, 'LineWidth', lw);
        else
            xlim([0 5]);
            ylim([0 16]);
            xtick_positions = linspace(0, 5, 6);
            set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
            ytick_positions = linspace(0, 16, 5);
            set(gca, 'YTick', ytick_positions, 'LineWidth', lw);
        end

        % labels and title
        xlabel('$g^{\prime} \mathrm{[-]}$', 'fontsize', FZ, ...
            'interpreter', 'latex', 'FontWeight', 'bold', 'Rotation', 0);
        xtickangle(0);
        ylabel('$\Delta Z^{\prime} \mathrm{[-]}$', ...
            'fontsize', FZ, 'interpreter', 'latex', 'FontWeight', 'bold');
        title(FigureHeader{c}, 'fontsize', FZ-2, 'Interpreter', 'latex');
            
        % format
        set(gca, 'Box', 'on');
        
        % figure name
        time = split(cases{c}(1:end-3), '_');
        global_var = {'DE_dZ', 'dZr', 'DE_g', 'gq', 'DE_chi', 'DE_d'};
        ColorApproach_ = ColorApproach;
        if ismember(var_, global_var)
            % replace 'Min', 'Mean', or 'Max' in filename
            ColorApproach_ = 'GlobalVariable';
        end
        if ~threshold
            outfname = strcat(RegimeFolder, Regime_ofname, ...
                time{end}, '_', ColorApproach_, '_', var_);
        else
            outfname = strcat(RegimeFolder, Regime_ofname, ...
                'threshold_', time{end}, '_', ColorApproach_, '_', var_);
        end

        % save regime diagram
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
end