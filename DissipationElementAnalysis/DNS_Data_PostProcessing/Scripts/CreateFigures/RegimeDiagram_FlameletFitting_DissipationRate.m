clc
clear
close all
addpath('~/NHR/DE_Analysis/MatlabFunctions');


% ================================
% regime diagram: dZprime over gprime
% -> individual flamelets for each dissipation element
% => based on stoichiometric dissipation rate in each dissipation element
% ================================


%====
% INPUTS
%====
hdf5_data_path = ['/home/cb376114/itv/OXYFLAME-B3/File_Transfer/' ...
    'DE_analysis_code/trajSearch/Dataset'];
cases= {'traj_Tbox_ign.h5', 'traj_Tbox_OHmax.h5', ...
    'traj_Tbox_fullComb.h5', 'traj_Tbox_finish.h5'};
prt_data_path = ['/home/cb376114/itv/OXYFLAME-B3/Simulation_Cases/' ...
    'Point-Particle/TURBULENT/TBOX_PAPER/ITV-Simulations/' ...
    'Point-Particle/Cluster_T_Box/' ...
    'T1500_eta100_D20_st5_NP10K_12,8mm_dx50/PHYSICAL_ASPECTS_ANALYSIS/' ...
    'VORONOI/Clustering/'];
prt_data_files = {'part_data_0.021.csv', 'part_data_0.02115.csv', ...
    'part_data_0.02125.csv', 'part_data_0.02150.csv'};
Data_path = '~/NHR/DE_Analysis/DNS_Data_PostProcessing/PostProcessedData/';
Fig_outpath = ['~/NHR/DE_Analysis/DNS_Data_PostProcessing/Figures/' ...
    'RegimeDiagram_FlameletFitting_DissipationRate/'];
DE_InputFiles = {'DEGridpointsZst_ign.csv', ...
    'DEGridpointsZst_OHmax.csv', ...
    'DEGridpointsZst_fullComb.csv',...
    'DEGridpointsZst_final.csv'};
RelevantFlameletData = ['~/NHR/DE_Analysis//Flamelets/Cantera/' ...
    'OutputData/FlameletData/PostProcessedFlameletData.csv'];
CchiDataFile = 'AverageRatioCchi_BasedOnDNS_Zst.csv';
ofname = 'RegimeDiagram_';
% create regime diagram for case c
c = 2;
% use mean temperature for PDF-Tinlet detection (false is min)
Tmean = 1;
% ensure that both thresholds are visible
threshold = false;
% DNS grid size
dx = 5E-5;
% domain size
nx = 256;
ny = 256;
nz = 256;
% figure title
FigureHeader = {'$t$=0.50ms', '$t$=0.65ms', '$t$=0.75ms', '$t$=1.00ms'};
% stoichiometric mixture fraction
Z_st = 0.117;
% figure is colored by [Chi; Enth; HR; PV; PVnorm; Tgas; YOH; Zmix]
% one or multiple variables
var = {'DE_dZ', 'dZr', 'DE_g', 'gq', 'Flamelet_Tinlet', ...
    'Flamelet_StrainRate', 'Flamelet_ChiSt', 'DE_l', 'DE_chi', 'DE_d', ...
    'DE_prt', 'Chi', 'Enth', 'HR', 'PV', 'PVnorm', 'Tgas', 'YOH', 'Zmix'};
% regime diagram related number of bins
n_bins_ = {10, 50, 10, 30};
n_bins = n_bins_{c};
% n_bins for mean(t) - PDF approach
n_bins_Tpdf = 100;
% save figure in [png, eps, pdf]
FigFormat = 'png';
%====


% create output directory
if Data_path(end) ~= '/'
    Data_path = [Data_path, '/'];
end
if prt_data_path(end) ~= '/'
    prt_data_path = [prt_data_path, '/'];
end
if Fig_outpath(end) ~= '/'
    Fig_outpath = [Fig_outpath, '/'];
end
if Tmean
    Fig_outpath = strcat(Fig_outpath, 'MeanTempPDF/');
else
    Fig_outpath = strcat(Fig_outpath, 'MinTempPDF/');
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
    l{i}=edata_dble{i}(7,:) .* dx;
    lm{i}=mean(edata_dble{i}(7,:) .* dx);
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


%% calculate/get relevant data for the regime diagram
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

    % particle data
    ND_COAL = strcat(prt_data_path, prt_data_files{c});
    prt_pos = readtable(ND_COAL, 'VariableNamingRule', 'preserve');
    x_prt_pos = prt_pos.Points_0;
    y_prt_pos = prt_pos.Points_1;
    z_prt_pos = prt_pos.Points_2;

    % allocate memory
    mat_min = [];
    mat_mean = [];
    mat_max = [];
    mat_fitting = [];

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
        %DE_d = mean(lambda ./ (rho .* cp));     % [m²/s]
        DE_d = lambda ./ (rho .* cp);           % [m²/s]

        % stoichiometric dissipation rate from dissipation element
        DE_g = g{i}(DE_id);                         % [1/m]
        [~, st_idx] = min(abs(zmix - Z_st));
        DE_dst = DE_d(st_idx);
        DE_chi = C_chi * 2 * DE_dst * DE_g^2;       % [1/s]
        % Option: ! NOT SCALED WITH C_chi -> don't use it!
        %DE_chi = chi(st_idx);                      % [1/s]

        % inlet temperature => PDF
        [MeanTinlet, MinTinlet] = DE_TinletFromTempPDF(tgas, n_bins_Tpdf);
        if Tmean
            Tinlet_ = MeanTinlet;
        else
            Tinlet_ = MinTinlet;
        end
        Tinlet = round(Tinlet_, -2);
        if Tinlet > 1500
            Tinlet = 1500;
        end

        % get respective flamelet
        FilteredFlamelts = FlameletData.Tinlet == Tinlet;
        [~, idx] = min(abs(FlameletData.ChiSt(FilteredFlamelts) - DE_chi));

        % if below -> idx + 5 - Flamelet_StrainRate
        Flamelet_Tinlet = FlameletData.Tinlet(FilteredFlamelts);
        Flamelet_Tinlet = Flamelet_Tinlet(idx);
        Flamelet_StrainRate = FlameletData.StrainRate(FilteredFlamelts);
        Flamelet_StrainRate = Flamelet_StrainRate(idx);
        Flamelet_ChiSt = FlameletData.ChiSt(FilteredFlamelts);
        Flamelet_ChiSt = Flamelet_ChiSt(idx);

        % reaction zone thickness from flamelet
        dZr_ = FlameletData.dZr(FilteredFlamelts);
        dZr = dZr_(idx);

        % ignore very small strain rates (reaction zone thickness is very
        % large)
        if Flamelet_Tinlet == 1500 && Flamelet_StrainRate <= 4
            new_idx = idx + 5 - Flamelet_StrainRate;
            dZr = dZr_(new_idx);
            %fprintf('\nModification Tinlet=1500K -> dZr = %e', dZr);
        elseif Flamelet_Tinlet == 1400 && Flamelet_StrainRate <= 2
            new_idx = idx + 3 - Flamelet_StrainRate;
            dZr = dZr_(new_idx);
            %fprintf('\nModification Tinlet=1400K -> dZr = %e', dZr);
        elseif Flamelet_Tinlet ~= 1500 && Flamelet_Tinlet ~= 1400
            fprintf('\nInlet temperature below 1400K -> Modify code!');
            return
        end

        % quenching gradient: gq
        Chi_qu = FlameletData.ChiQu(FilteredFlamelts);
        Chi_qu = Chi_qu(idx);
        D_st = FlameletData.DSt(FilteredFlamelts);
        D_st = D_st(idx);
        gq = (Chi_qu / (C_chi * 2 * D_st))^0.5;

        % get corresponding DE data
        DE_dZ = phi{i}(DE_id);
        DE_l = l{i}(DE_id);
        %DE_dZm = phin{i}(DE_id);
        %DE_gm = gn{i}(DE_id); %phim{i} ./ lm{i};
        DE_dZstar = phin{i}(DE_id);
        DE_gstar = gn{i}(DE_id);
        DE_prt = DE_NumberOfParticles(x_coords, y_coords, z_coords, ...
            x_prt_pos, y_prt_pos, z_prt_pos, dx, nx, ny, nz);

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
        mat_min = [mat_min, [DE_dZ, dZr, dZprime, DE_g, gq, ...
            gprime, Flamelet_Tinlet, Flamelet_StrainRate, ...
            Flamelet_ChiSt, DE_l, DE_chi, DE_dst, DE_prt, chi_, enth_, ...
            hr_, pv_, pvnorm_, tgas_, yoh_, zmix_, DE_dZstar, DE_gstar]'];

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
        mat_mean = [mat_mean, [DE_dZ, dZr, dZprime, DE_g, gq, ...
            gprime, Flamelet_Tinlet, Flamelet_StrainRate, ...
            Flamelet_ChiSt, DE_l, DE_chi, DE_dst, DE_prt, chi_, enth_, ...
            hr_, pv_, pvnorm_, tgas_, yoh_, zmix_, DE_dZstar, DE_gstar]'];

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
        mat_max = [mat_max, [DE_dZ, dZr, dZprime, DE_g, gq, ...
            gprime, Flamelet_Tinlet, Flamelet_StrainRate, ...
            Flamelet_ChiSt, DE_l, DE_chi, DE_dst, DE_prt, chi_, enth_, ...
            hr_, pv_, pvnorm_, tgas_, yoh_, zmix_, DE_dZstar, DE_gstar]'];

        %
        mat_fitting = [mat_fitting, [DE_id, Flamelet_Tinlet, ...
            Flamelet_StrainRate, dZprime, gprime]'];
    end
end
% %% add g* and dZ*
% mean_Z_min = mean(mat_min(1,:));
% mean_g_min = mean(mat_min(4,:));
% mean_Z_mean = mean(mat_mean(1,:));
% mean_g_mean = mean(mat_mean(4,:));
% mean_Z_max = mean(mat_max(1,:));
% mean_g_max = mean(mat_max(4,:));
% for i = 1:length(mat_mean)
%     mat_min = [mat_min, [mat_min(1,i)./mean_Z_min, mat_min(4,i)./mean_g_min]'];
% end
% return

%% write dissipation element ID and respective flamelet to file
filename = strcat(Fig_outpath, 'DissipationElementFlamelet.csv');
header = sprintf('%-13s\t%-13s\t%-13s\t%-13s\t%-13s', ...
    'DEid', 'Tinlet', 'StrainRate', 'dZprime', 'gprime');
DataFormat = '%-13E\t%-13E\t%-13E\t%-13E\t%-13E\n';
fid = fopen(filename, 'w');
fprintf(fid, '%s\n', header);
for i = 1:length(mat_fitting)
    fprintf(fid, DataFormat, mat_fitting(:,i));                                                                                                                                                                                                
end
fclose(fid);


%% create regime diagram
axis = {'dZprime_dgprime', 'dZ_dg', 'dZm_dgm'};
DataSets = {'Min', 'Mean', 'Max'};
for h = 1:length(axis)
    if strcmp(axis{h}, 'dZprime_dgprime')
        idx_xaxis = 6;
        idx_yaxis = 3;
        figure_xlabel = '$g^{\prime}$ [-]';
        figure_ylabel = '$\Delta Z^{\prime}$ [-]';
        xmax = 2;
        ymax = 5;
        xmax_steps = 5;
        ymax_steps = 6;
    elseif strcmp(axis{h}, 'dZ_dg')
        idx_xaxis = 4;
        idx_yaxis = 1;
        figure_xlabel = '$g$ [-]';
        figure_ylabel = '$\Delta Z$ [-]';
        xmax = 400;
        ymax = 0.25;
        xmax_steps = 5;
        ymax_steps = 6;
    elseif strcmp(axis{h}, 'dZm_dgm')
        idx_xaxis = 23;
        idx_yaxis = 22;
        figure_xlabel = '$g^{*}$ [-]';
        figure_ylabel = '$\Delta Z^{*}$ [-]';
        xmax = 6;
        ymax = 3;
        xmax_steps = 7;
        ymax_steps = 4;
    else
        fprintf('\nInvalid input for axis variable!');
        return
    end

    for i = 1:length(DataSets)
        
        %
        ColorApproach = DataSets{i};
        %fprintf('\n%s\n', ColorApproach);
    
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
                    var_idx = 1;
                    cb_var = mat_max(var_idx,:);
                    cblabel = '$\Delta Z_\mathrm{DE}$ [-]';
                    lowLim = 0;
                    upLim = 0.25;
                    %fprintf('-> upper limit DE_dZ: %e\n', max(cb_var));
                case 'dZr'
                    var_idx = 2;
                    cb_var = mat_max(var_idx,:);
                    cblabel = '$\delta Z_\mathrm{r}$ [-]';
                    lowLim = 0;
                    upLim = 0.15;
                    %fprintf('-> upper limit dZr: %e\n', max(cb_var));
                case 'DE_g'
                    var_idx = 4;
                    cb_var = mat_min(var_idx,:);
                    cblabel = '$g_\mathrm{DE}$ [1/m]';
                    lowLim = 0;
                    upLim = 400;
                    %fprintf('-> upper limit DE_g: %e\n', max(cb_var));
                case 'gq'
                    var_idx = 5;
                    cb_var = mat_max(var_idx,:);
                    cblabel = '$g_\mathrm{q}$ [1/m]';
                    lowLim = 200;
                    upLim = 300;
                    %fprintf('-> lower limit gq: %e\n', min(cb_var));
                    %fprintf('-> upper limit gq: %e\n', max(cb_var));
                case 'Flamelet_Tinlet'
                    var_idx = 7;
                    cb_var = mat_min(var_idx,:);
                    cblabel = '$T_\mathrm{inlet,flamelet}$ [K]';
                    lowLim = 0;
                    upLim = 1500;
                    %fprintf('-> upper limit T_in,flamelet: %e\n', ...
                    %    max(cb_var));
                case 'Flamelet_StrainRate'
                    var_idx = 8;
                    cb_var = mat_min(var_idx,:);
                    cblabel = '$a_\mathrm{flamelet}$ [1/s]';
                    lowLim = 0;
                    upLim = 37;
                    %fprintf('-> upper limit a_flamelet: %e\n', max(cb_var));
                case 'Flamelet_ChiSt'
                    var_idx = 9;
                    cb_var = mat_min(var_idx,:);
                    cblabel = '$\chi_\mathrm{st,flamelet}$ [1/s]';
                    lowLim = 0;
                    upLim = 3000;
                    %fprintf('-> lower limit DE_chi,st: %e\n', min(cb_var));
                    %fprintf('-> upper limit DE_chi,st: %e\n', max(cb_var));
                case 'DE_l'
                    var_idx = 10;
                    cb_var = mat_min(var_idx,:);
                    cblabel = '$l_\mathrm{DE}$ [-]';
                    lowLim = 0;
                    upLim = 0.005;
                    %fprintf('-> upper limit DE_l: %e\n', max(cb_var));
                case 'DE_chi'
                    var_idx = 11;
                    cb_var = mat_min(var_idx,:);
                    cblabel = '$\chi_\mathrm{DE}$ [1/s]';
                    lowLim = 0;
                    upLim = 6000;
                    %fprintf('-> lower limit DE_chi: %e\n', min(cb_var));
                    %fprintf('-> upper limit DE_chi: %e\n', max(cb_var));
                case 'DE_d'
                    var_idx = 12;
                    cb_var = mat_max(var_idx,:);
                    cblabel = '$D_\mathrm{DE}$ $\mathrm{[m^{2}/s]}$';
                    lowLim = 0;
                    upLim = 0.0007;
                    %fprintf('-> upper limit DE_d: %e\n', max(cb_var));
                case 'DE_prt'
                    var_idx = 13;
                    cb_var = mat_max(var_idx,:);
                    cblabel = '$PRT_\mathrm{DE}$ [-]';
                    lowLim = 0;
                    upLim = 3;
                    %fprintf('-> upper limit DE_prt: %e\n', max(cb_var));
                case 'Chi'
                    var_idx = 14;
                    if strcmp(ColorApproach, 'Min')
                        cb_var = mat_min(var_idx,:);
                        cblabel = '$\chi_\mathrm{min}$ [1/s]';
                        upLim = 30;
                    elseif strcmp(ColorApproach, 'Mean')
                        cb_var = mat_mean(var_idx,:);
                        cblabel = '$\chi_\mathrm{mean}$ [1/s]';
                        upLim = 500;
                    elseif strcmp(ColorApproach, 'Max')
                        cb_var = mat_max(var_idx,:);
                        cblabel = '$\chi_\mathrm{max}$ [1/s]';
                        upLim = 3500;
                    end
                    lowLim = 0;
                    %fprintf('-> lower limit Chi: %e\n', min(cb_var));
                    %fprintf('-> upper limit Chi: %e\n', max(cb_var));
                case 'Enth'
                    var_idx = 15;
                    if strcmp(ColorApproach, 'Min')
                        cb_var = mat_min(var_idx,:);
                        cblabel = '$H_\mathrm{min}$ [kJ/kg]';   % unit correct?
                        lowLim = -1600;
                        upLim = -800;
                    elseif strcmp(ColorApproach, 'Mean')
                        cb_var = mat_mean(var_idx,:);
                        cblabel = '$H_\mathrm{mean}$ [kJ/kg]';  % unit correct?
                        lowLim = -1000;
                        upLim = -600;
                    elseif strcmp(ColorApproach, 'Max')
                        cb_var = mat_max(var_idx,:);
                        cblabel = '$H_\mathrm{max}$ [kJ/kg]';   % unit correct?
                        lowLim = -900;
                        upLim = -600;
                    end
                    %fprintf('-> lower limit Enth: %e\n', min(cb_var));
                    %fprintf('-> upper limit Enth: %e\n', max(cb_var));
                case 'HR'
                    var_idx = 16;
                    if strcmp(ColorApproach, 'Min')
                        cb_var = mat_min(var_idx,:);
                        cblabel = ['$\omega_\mathrm{T,min}$ $' ...
                            '\mathrm{[J/m^{3}/s]}$'];
                        upLim = 1E9;
                    elseif strcmp(ColorApproach, 'Mean')
                        cb_var = mat_mean(var_idx,:);
                        cblabel = ['$\omega_\mathrm{T,mean}$ $' ...
                            '\mathrm{[J/m^{3}/s]}$'];
                        upLim = 3E10;
                    elseif strcmp(ColorApproach, 'Max')
                        cb_var = mat_max(var_idx,:);
                        cblabel = ['$\omega_\mathrm{T,max}$ $' ...
                            '\mathrm{[J/m^{3}/s]}$'];
                        upLim = 7E10;
                    end
                    lowLim = 0;
                    %fprintf('-> lower limit HR: %e\n', min(cb_var));
                    %fprintf('-> upper limit HR: %e\n', max(cb_var));
                case 'PV'
                    var_idx = 17;
                    if strcmp(ColorApproach, 'Min')
                        cb_var = mat_min(var_idx,:);
                        cblabel = '$PV_\mathrm{min}$ [-]';
                        lowLim = -0.005;
                        upLim = 0.01;
                    elseif strcmp(ColorApproach, 'Mean')
                        cb_var = mat_mean(var_idx,:);
                        cblabel = '$PV_\mathrm{mean}$ [-]';
                        lowLim = -0.004;
                        upLim = 0.005;
                    elseif strcmp(ColorApproach, 'Max')
                        cb_var = mat_max(var_idx,:);
                        cblabel = '$PV_\mathrm{max}$ [-]';
                        lowLim = 0;
                        upLim = 0.01;
                    end
                    %fprintf('-> lower limit PV: %e\n', min(cb_var));
                    %fprintf('-> upper limit PV: %e\n', max(cb_var));
                case 'PVnorm'
                    var_idx = 18;
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
                    lowLim = 0;
                    upLim = 1;
                    %fprintf('-> lower PVnorm: %e\n', min(cb_var));
                    %fprintf('-> upper PVnorm: %e\n', max(cb_var));
                case 'Tgas'
                    var_idx = 19;
                    if strcmp(ColorApproach, 'Min')
                        cb_var = mat_min(var_idx,:);
                        cblabel = '$T_\mathrm{gas,min}$ [K]';
                        lowLim = 1400;
                        upLim = 2100;
                    elseif strcmp(ColorApproach, 'Mean')
                        cb_var = mat_mean(var_idx,:);
                        cblabel = '$T_\mathrm{gas,mean}$ [K]';
                        lowLim = 1500;
                        upLim = 2200;
                    elseif strcmp(ColorApproach, 'Max')
                        cb_var = mat_max(var_idx,:);
                        cblabel = '$T_\mathrm{gas,max}$ [K]';
                        lowLim = 1800;
                        upLim = 2400;
                    end
                    %lowLim = 0;
                    %fprintf('-> lower limit Tgas: %e\n', min(cb_var));
                    %fprintf('-> upper limit Tgas: %e\n', max(cb_var));
                case 'YOH'
                    var_idx = 20;
                    if strcmp(ColorApproach, 'Min')
                        cb_var = mat_min(var_idx,:);
                        cblabel = '$Y_\mathrm{OH,min}$ [-]';
                        upLim = 0.012;
                    elseif strcmp(ColorApproach, 'Mean')
                        cb_var = mat_mean(var_idx,:);
                        cblabel = '$Y_\mathrm{OH,mean}$ [-]';
                        upLim = 0.012;
                    elseif strcmp(ColorApproach, 'Max')
                        cb_var = mat_max(var_idx,:);
                        cblabel = '$Y_\mathrm{OH,max}$ [-]';
                        upLim = 0.015;
                    end
                    lowLim = 0;
                    %fprintf('-> lower limit YOH: %e\n', min(cb_var));
                    %fprintf('-> upper limit YOH: %e\n', max(cb_var));
                case 'Zmix'
                    var_idx = 21;
                    if strcmp(ColorApproach, 'Min')
                        cb_var = mat_min(var_idx,:);
                        cblabel = '$Z_\mathrm{mix,min}$ [-]';
                        upLim = 0.08;
                    elseif strcmp(ColorApproach, 'Mean')
                        cb_var = mat_mean(var_idx,:);
                        cblabel = '$Z_\mathrm{mix,mean}$ [-]';
                        upLim = 0.12;
                    elseif strcmp(ColorApproach, 'Max')
                        cb_var = mat_max(var_idx,:);
                        cblabel = '$Z_\mathrm{mix,max}$ [-]';
                        upLim = 0.3;
                    end
                    lowLim = 0;
                    %fprintf('-> lower limit Zmix: %e\n', min(cb_var));
                    %fprintf('-> upper limit Zmix: %e\n', max(cb_var));
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
                x = mat_min(idx_xaxis,:);
                y = mat_min(idx_yaxis,:);
            elseif strcmp(ColorApproach, 'Mean')
                x = mat_mean(idx_xaxis,:);
                y = mat_mean(idx_yaxis,:);
            elseif strcmp(ColorApproach, 'Max')
                x = mat_max(idx_xaxis,:);
                y = mat_max(idx_yaxis,:);
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
            if strcmp(var_, 'Flamelet_Tinlet')
                caxis([250 1550]);
                cb.Ticks = [300, 600, 900, 1200, 1500];
            end
            if strcmp(var_, 'Flamelet_StrainRate')
                caxis_min = 0;
                caxis_max = 37;
                caxis_min_ = caxis_min - 0.5;
                caxis_max_ = caxis_max + 0.5;
                caxis([caxis_min_ caxis_max_]);
                ticks = round(linspace(caxis_min, caxis_max, 6));                                                                                                                                                                                  
                cb.Ticks = ticks;
            end
            if strcmp(var_, 'DE_prt')
                caxis([0 3]);
                cb.Ticks = [0, 1, 2, 3];
            end
%             if strcmp(var_, 'Enth')
%                 cb.Ticks = [-1600, -1400, -1200, -1000, -800, -600, -400];
%             end
%             if strcmp(var_, 'PV')
%                 cb.Ticks = [-5.0e-3, -2.5e-3, 0, 2.5e-3, 5.0e-3, 7.5e-3, ...
%                     10e-3];
%             end
    
            % threshold lines
            if h == 1
                xline(1, '--k', 'LineWidth', lw+1, ...
                    'HandleVisibility', 'off');
                hold on;
                yline(15, '--k', 'LineWidth', lw+1, ...
                    'HandleVisibility', 'off');
                hold on;
            end

            % lim and ticks    
            if ~threshold
                xlim([0 xmax]);
                ylim([0 ymax]);
                xtick_positions = linspace(0, xmax, xmax_steps);
                set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
                ytick_positions = linspace(0, ymax, ymax_steps);
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
            xlabel(figure_xlabel, 'fontsize', FZ, ...
                'interpreter', 'latex', 'FontWeight', 'bold', ...
                'Rotation', 0);
            xtickangle(0);
            ylabel(figure_ylabel, 'fontsize', FZ, ...
                'interpreter', 'latex', 'FontWeight', 'bold');
            title(FigureHeader{c}, 'fontsize', FZ-2, ...
                'Interpreter', 'latex');
                
            % format
            set(gca, 'Box', 'on');
            
            % figure name
            time = split(cases{c}(1:end-3), '_');
            global_var = {'DE_dZ', 'dZr', 'DE_g', 'gq', ...
                'Flamelet_Tinlet', 'Flamelet_StrainRate', ...
                'Flamelet_ChiSt', 'DE_l', 'DE_chi', 'DE_d', 'DE_prt'};
            ColorApproach_ = ColorApproach;
            if ismember(var_, global_var)
                % replace 'Min', 'Mean', or 'Max' in filename
                ColorApproach_ = 'GlobalVariable';
            end
            if ~threshold
                outfname = strcat(Fig_outpath, ofname, time{end}, '_', ...
                    axis{h}, '_', ColorApproach_, '_', var_);
            else
                outfname = strcat(Fig_outpath, ofname, 'threshold_', ...
                    time{end}, axis{h}, '_', '_', ColorApproach_, ...
                    '_', var_);
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
                fprintf(['\nInvalid figure format (%s)\n => png/eps/pdf' ...
                    '\n'], FigFormat);
                return
            end
        end
    end
end
