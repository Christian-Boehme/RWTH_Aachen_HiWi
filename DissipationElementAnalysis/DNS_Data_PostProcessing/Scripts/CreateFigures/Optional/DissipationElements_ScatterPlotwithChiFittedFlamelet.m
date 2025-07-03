clc
clear
close all
addpath('../../../MatlabFunctions/');


% ================================
% dissipation element analysis
% -> single dissipation element: jPDF and respective flamelet
% ================================


%====
% INPUTS
%====
hdf5_data_path = ['~/itv/OXYFLAME-B3/File_Transfer/DE_analysis_code/' ...
    'trajSearch/Dataset'];
cases= {'traj_Tbox_ign.h5', 'traj_Tbox_OHmax.h5', ...
    'traj_Tbox_fullComb.h5', 'traj_Tbox_finish.h5'};
prt_data_path = '~/itv/OXYFLAME-B3/Simulation_Cases/Point-Particle/TURBULENT/TBOX_PAPER/ITV-Simulations/Point-Particle/Cluster_T_Box/T1500_eta100_D20_st5_NP10K_12,8mm_dx50/PHYSICAL_ASPECTS_ANALYSIS/VORONOI/Clustering/';
prt_data_files = {'part_data_0.02100.csv', 'part_data_0.02115.csv', ...
    'part_data_0.02125.csv', 'part_data_0.02150.csv'};
Data_path = '../../PostProcessedData/';
Fig_outpath = ['../../Figures/' ...
    'Analysis/DissipationElements/'];
DE_InputFiles = {'DEGridpointsZst_ign.csv', ...
    'DEGridpointsZst_OHmax.csv', ...
    'DEGridpointsZst_fullComb.csv',...
    'DEGridpointsZst_final.csv'};
RelevantFlameletData = ['../../../Flamelets/Cantera/OutputData/' ...
    'FlameletData/PostProcessedFlameletData.csv'];
CchiDataFile = 'AverageRatioCchi_BasedOnDNS.csv';
ofname = 'DissipationElement_';
% create regime diagram for case c
c = 2;
% use mean temperature for PDF-Tinlet detection (false is min)
Tmean = 1;
% DNS grid size
dx = 5E-5;
% domain size
nx = 256;
ny = 256;
nz = 256;
% figure title
FigureHeader_jPDF = {'$t$=0.50ms', '$t$=0.65ms', '$t$=0.75ms', ...
    '$t$=1.00ms'};
% stoichiometric mixture fraction
Z_st = 0.117;
% figure is colored by [Chi; Enth; HR; PV; PVnorm; Tgas; YOH; Zmix]
% one or multiple variables
var = {'Chi', 'Enth', 'HR', 'PV', 'PVnorm', 'Tgas', 'YOH'};
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
%====


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
set(0, 'defaultFigurePosition', [2 2 900 500]);
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
    mat = [];

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
        if Flamelet_Tinlet == 1500 && Flamelet_StrainRate <= 4
            new_idx = idx + 5 - Flamelet_StrainRate;
            dZr = dZr_(new_idx);
            %fprintf('\nModification Tinlet=1500K -> dZr = %e', dZr);
        elseif Flamelet_Tinlet == 1400 && Flamelet_StrainRate <= 2
            new_idx = idx + 3 - Flamelet_StrainRate;
            dZr = dZr_(new_idx);
            %fprintf('\nModification Tinlet=1400K -> dZr = %e', dZr);
        elseif Flamelet_Tinlet ~= 1500 && Flamelet_Tinlet ~= 1400
            frpintf('\nInlet temperature below 1400K -> Modify code!');
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
%         DE_prt = DE_NumberOfParticles(x_coords, y_coords, z_coords, ...
%             x_prt_pos, y_prt_pos, z_prt_pos, dx, nx, ny, nz);

        % regime diagram variables
%         fprintf('\nDE_dZ = %e and dZr = %e => DE_dZ/dZr = %e', ...
%             DE_dZ, dZr, DE_dZ/dZr);
%         fprintf('\nDE_g = %e and gq = %e => DE_g/gq = %e', ...
%             DE_g, gq, DE_g/gq);
        dZprime = DE_dZ / dZr;
        gprime = DE_g / gq;

        % add data to matrix
        % add data
        mat = [mat, [DE_dZ, dZr, dZprime, DE_g, gq, ...
            gprime, DE_id, Flamelet_Tinlet, Flamelet_StrainRate, DE_l]'];
    end
end


%% create figure
target_dZprime = 2.5;
target_gprime = 0.05;
tol_dZprime = 0.30;
tol_gprime = 0.01;
for i = 1:DE_Zst
    
    %fprintf('\ndZprime=%e', mat(3,i));
    if (mat(3,i) >= target_dZprime + tol_dZprime) || ( ...
            mat(3,i) <= target_dZprime - tol_dZprime)
        %fprintf('\n1');
        continue;
    end    
    if (mat(6,i) >= target_gprime + tol_gprime) || ( ...
            mat(6,i) <= target_gprime - tol_gprime)
        %fprintf('\n2');
        continue;
    end
    fprintf('Create figure for DE %i - %i/%i\n', i, i, DE_Zst);
    %continue
    DEidFolder = sprintf('dZprime_%.3f_gprime_%.3f_DE_%05d/', ...
        mat(3,i), mat(6,i), mat(7,i));
    DEidFolder_ = strcat(Fig_outpath, DEidFolder);
    if ~exist(DEidFolder_, 'dir')
        mkdir(DEidFolder_);
    end

    % extract grid points of dissipation element in domain
    [DE_id, x_coords, y_coords, z_coords] = DE_GetGridPoints( ...
        data(:,i));
    [DE_prt, PrtPos] = DE_NumberOfParticles(x_coords, y_coords, ...
        z_coords, x_prt_pos, y_prt_pos, z_prt_pos, dx, nx, ny, nz);
%     if DE_prt ~= 0
%         fprintf('\nParticle in dissipation element! DE_prt = %i', DE_prt);
%     end

    for k = 1:length(var)
    
        % get variable
        var_ = var{k};
    
        % create regime diagram
        close all
        figure
        
        % layout
        t = tiledlayout(1,2);
        t.TileSpacing = 'compact';
        t.Padding = 'loose'; 

        % jPDF figure
        ax(1) = nexttile(1);
        
        % background
        set(gcf,'color','w');
        set(gca, 'Box', 'on');

        % colorbar variable
        switch(var_)
            case 'Chi'
                var_idx = 1;
                cb_var = DE_ExtractData(Chi{c}, x_coords, y_coords, ...
                    z_coords);
                cblabel = '$\chi$ [1/s]';
                %yaxislabel = '$\chi$';
                lowLim = 0; % TODO
                %upLim = max(cb_var); % TODO
                %fprintf('-> Chi: %e\n', upLim);
                upLim = 3500; % 3062 % TODO
            case 'Enth'
                var_idx = 2;
                cb_var = DE_ExtractData(Enth{c}, x_coords, y_coords, ...
                    z_coords);
                cblabel = '$H$ [kJ/kg]';   % unit correct?
                %yaxislabel = '$H$';
                %lowLim = min(cb_var); % TODO
                %upLim = max(cb_var); % TODO
                %fprintf('-> Enth: %e\n', upLim);
                lowLim = -1600; % -1568 % TODO
                upLim = -400; % -587 % TODO
            case 'HR'
                var_idx = 12;
                cb_var = DE_ExtractData(HR{c}, x_coords, y_coords, ...
                    z_coords);
                cblabel = ['$\omega_\mathrm{T}$ $\mathrm{[' ...
                    'J/m^{3}/s]}$'];
                %yaxislabel = '$\omega_\mathrm{T}$';
                lowLim = 0; % TODO
                %upLim = max(cb_var); % TODO
                %fprintf('-> HR: %e\n', upLim);
                upLim = 7.0E10; % 6.05E10 % TODO
            case 'PV'
                var_idx = 13;
                cb_var = DE_ExtractData(PV{c}, x_coords, y_coords, ...
                    z_coords);
                cblabel = '$PV$ [-]';
                %yaxislabel = '$PV$';
                %lowLim = min(cb_var); % TODO
                %upLim = max(cb_var); % TODO
                %fprintf('-> PV: %e\n', upLim);
                %fprintf('-> lower limit PV: %e\n', lowLim);
                lowLim = -5E-03; % -4.603e-3 % TODO
                upLim = 10E-03; % 8.3e-3 % TODO
            case 'PVnorm'
                var_idx = 14;
                cb_var = DE_ExtractData(PVnorm{c}, x_coords, y_coords, ...
                    z_coords);
                cblabel = '$PV_\mathrm{norm}$ [-]';
                %yaxislabel = '$PV_\mathrm{norm}$';
                lowLim = 0; % TODO
                %upLim = max(cb_var); % TODO
                %fprintf('-> PVnorm: %e\n', upLim);
                upLim = 1; % 1 %TODO
            case 'Tgas'
                var_idx = 15;
                cb_var = DE_ExtractData(Tgas{c}, x_coords, y_coords, ...
                    z_coords);
                cblabel = '$T_\mathrm{gas}$ [K]';
                %yaxislabel = '$T_\mathrm{gas}$';
                lowLim = 0; % TODO
                %upLim = max(cb_var); % TODO
                %fprintf('-> Tgas: %e\n', upLim);
                upLim = 2500; % 2348 % TODO
            case 'YOH'
                var_idx = 16;
                cb_var = DE_ExtractData(YOH{c}, x_coords, y_coords, ...
                    z_coords);
                cblabel = '$Y_\mathrm{OH}$ [-]';
                %yaxislabel = '$Y_\mathrm{OH}$';
                lowLim = 0; % TODO
                %upLim = max(cb_var); % TODO
                %fprintf('-> YOH: %e\n', upLim);
                upLim = 0.014; % 0.013 % TODO
            case 'Zmix'
                var_idx = 17;
                cb_var = DE_ExtractData(Zmix{c}, x_coords, y_coords, ...
                    z_coords);
                cblabel = '$Z_\mathrm{mix}$ [-]';
                yaxislabel = '$Z_\mathrm{mix}$';
                lowLim = 0; % TODO
                %upLim = max(cb_var); % TODO
                %fprintf('-> Zmix: %e\n', upLim);
                upLim = 0.3; % 0.262 %TODO
            otherwise
                fprintf('\nInvalid variable!');
                return
        end

%             % warning if max value is above the limit
%             if max(cb_var) > upLim
%                 fprintf(['Max(%s) is > upper limit in colorbar!' ...
%                     '\n=>%e > %e\n'], var_, max(cb_var), upLim);
%             end
%             % warning if min value is below the limit
%             if min(cb_var) < lowLim
%                 fprintf(['Min(%s) is < lower limit in colorbar!' ...
%                     '\n=>%e > %e\n'], var_, min(cb_var), lowLim);
%             end

        % plot
        y = cb_var;
        x = DE_ExtractData(Zmix{c}, x_coords, y_coords, z_coords);

        scatter(x, y, 50, 'blue', 'x');
        hold on;
%         % highlight particles
%         scatter(x(PrtPos == 1), y(PrtPos == 1), 50, 'o', 'red');
%         hold on;

%             XData = squeeze(x(:));
%             YData = squeeze(y(:));
%             c_max1 = max(size(XData), [], 'all');
%             [x1_data, avg_data] = CellDataAvg(XData, YData, n_bins, ...
%                 [min(XData) max(XData)], 1, sf, factor);
%             z_dir = zeros(size(x1_data, 1), 1) + c_max1 + 1;
%             plot3(x1_data, avg_data, z_dir,'k','LineWidth', lw);
%             [PDF_x1, PDF_x2, PDF_y] = Compute_PDF_histograms_2D(XData, ...
%                 YData, n_bins);
%             PDF_y=log10(PDF_y);
%             s = imagesc(ax(1), PDF_x1, PDF_x2, PDF_y);
%             set(s, 'AlphaData', ~isnan(PDF_y));
%             set(gca, 'YDir', 'normal');
%             hold on;

%             % colorbar
%             cb = colorbar('eastoutside');
%             colormap(jet);
%             %caxis([lowLim upLim]);
%             set(cb, 'TickLabelInterpreter', 'latex');
%             ylabel(cb, cblabel, 'fontsize', FZ, 'interpreter', 'latex');
%             if strcmp(var_, 'Enth')
%                 cb.Ticks = [-1600, -1400, -1200, -1000, -800, -600, -400];
%             end
%             if strcmp(var_, 'PV')
%                 cb.Ticks = [-5.0e-3, -2.5e-3, 0, 2.5e-3, 5.0e-3, ...
%                     7.5e-3, 10e-3];
%             end

%             % lim and ticks 
%             xmax = 1;
%             ymax = 8;
         xlim([0 0.3]);
         ylim([lowLim upLim]);
         xtick_positions = linspace(0, 0.3, 4);
         set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
%             ytick_positions = linspace(0, ymax, 5);
%             set(gca, 'YTick', ytick_positions, 'LineWidth', lw);

        % labels and title
%             xlabel('$l$ [-]', 'fontsize', FZ, ...
%                 'interpreter', 'latex', 'FontWeight', 'bold', ...
%                 'Rotation', 0);
        xlabel('$Z_\mathrm{mix}$ [-]', 'fontsize', FZ, ...
            'interpreter', 'latex', 'FontWeight', 'bold', ...
            'Rotation', 0);
        xtickangle(0);
        ylabel(cblabel, ...
            'fontsize', FZ, 'interpreter', 'latex', ...
            'FontWeight', 'bold');
        Header = strcat('$N_\mathrm{prt}=$', num2str(DE_prt));
        title(Header, 'fontsize', FZ-2, ...
            'Interpreter', 'latex');

        % background
        set(gcf,'color','w');
        set(gca, 'Box', 'on');
            

        % flamelet figure
        hold on;
        ax(2) = nexttile(2);
        
        % background
        set(gcf,'color','w');
        set(gca, 'Box', 'on');

        % get flamelets
        Fl_Tinlet = mat(8,i);
        Fl_StrainRate = mat(9,i);
        Fl_FilteredFlamelts = FlameletData.Tinlet == Fl_Tinlet;
        [~, idx] = min(abs(FlameletData.StrainRate( ...
            Fl_FilteredFlamelts) - Fl_StrainRate));

        % create figure
        xdata = FlameletData.ChiStQu(Fl_FilteredFlamelts);
        ydata = FlameletData.dZr(Fl_FilteredFlamelts);
        semilogx(xdata, ydata, 'x-', 'LineWidth', lw+1, ...
            'Marker', 'x', 'Color', 'black', ...
            'HandleVisibility', 'off');

        % highlight flamelet
        hold on
        xdata = xdata(idx);
        ydata = ydata(idx);
        scatter(xdata, ydata, 50, 'red', 'filled', 'o');

        % axis limits
        ymax2 = 0.15;
        ylim([0 ymax2]);
        
        
        % ticks modification
        ytick_positions = linspace(0, ymax2, 6);
        set(gca, 'YTick', ytick_positions, 'LineWidth', lw);

        % labels and title
        FigureHeader = strcat('$T_\mathrm{in}=$', ...
            num2str(Fl_Tinlet), ' K,  $a=$', ...
            num2str(Fl_StrainRate), ' 1/s');
        xlabel('$\chi_\mathrm{st}/\chi_\mathrm{q}$ [-]', ...
            'fontsize', FZ, 'interpreter', 'latex', ...
            'FontWeight', 'bold');
        ylabel('$\delta Z_\mathrm{r}$ [-]', 'fontsize', FZ, ...
            'interpreter', 'latex', 'FontWeight', 'bold');
        title(FigureHeader, 'fontsize', FZ-2, ...
            'Interpreter', 'latex');


        % global title
        header = strcat('DE=', num2str(mat(7,i), '%i'), ...
            ', dZ$^{\prime}$=', num2str(mat(3,i), '%0.3f'), ...
            ', g$^{\prime}$=', num2str(mat(6,i), '%0.3f'), ...
            ', ', FigureHeader_jPDF{c});
        sgtitle(header, 'fontsize', FZ-2, 'Interpreter', 'latex');

        % figure name
        time = split(cases{c}(1:end-3), '_');
        outfname = strcat(DEidFolder_, ofname, time{end}, '_', var_);

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