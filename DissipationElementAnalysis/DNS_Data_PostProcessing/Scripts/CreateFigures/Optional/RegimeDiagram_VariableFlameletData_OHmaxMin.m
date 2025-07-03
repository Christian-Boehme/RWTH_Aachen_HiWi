clc
clear all
close all


% ================================
% regime diagram: dZprime over gprime
% => individual flamelets for each dissipation element
% ================================


%====
% INPUTS
%====
hdf5_data_path = ['~/itv/OXYFLAME-B3/File_Transfer/DE_analysis_code/' ...
    'trajSearch/Dataset'];
cases= {'traj_Tbox_ign.h5', 'traj_Tbox_OHmax.h5', ...
    'traj_Tbox_fullComb.h5', 'traj_Tbox_finish.h5'};
Data_path = '../../PostProcessedData/';
Fig_outpath = '../../Figures/RegimeDiagram_VariableFlameletData/';
DE_InputFiles = {'DEGridpointsZst_ign.csv', ...
    'DEGridpointsZst_OHmax.csv', ...
    'DEGridpointsZst_fullComb.csv',...
    'DEGridpointsZst_final.csv'};
DissipationElementFlameletData = {'DE_Flamelets_ign.csv', ...
    'DE_Flamelets_OHmax.csv', 'DE_Flamelets_fullComb.csv'};
FlameletDataPath = ['../../../Flamelets/Cantera/OutputData/' ...
    'Flamelet_preheated_PassiveScalarMixtureFraction/Data/'];
CchiDataFile = 'AverageRatioCchi_BasedOnDNS.csv';
ofname = 'OHmax_gquenching_Cchi6D/RegimeDiagram_'; %'RegimeDiagram_';
% create regime diagram for case c
c = 2;
% ensure that both thresholds are visible
threshold = false;
% DNS grid size
dx = 5E-5;
% figure title
FigureHeader = {'$t$=0.50ms', '$t$=0.65ms', '$t$=0.75ms', '$t$=1.00ms'};
% stoichiometric mixture fraction
Z_st = 0.117;
% figure is colored by [Chi; Enth; HR; PV; PVnorm; Tgas; YOH; Zmix]
% one or multiple variables
var = {'Chi', 'Enth', 'HR', 'PV', 'PVnorm', 'Tgas', 'YOH', 'Zmix'};
n_bins_ = {10, 30, 10, 30};
n_bins = n_bins_{c};
sf = 0.01;
factor= 2e-5;
% use "Mean", "Max", or "Min" value of variable in dissipation element
DEDataApproach = 'Min';
% save figure in [png, eps, pdf]
FigFormat = 'png';
%====


% create output directory
if Data_path(end) ~= '/'
    Data_path = [Data_path, '/'];
end
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


% read flamelet data
de_flamelet_data = readmatrix(strcat(Data_path, ...
    DissipationElementFlameletData{c}));
flamelet_data = dir(fullfile(FlameletDataPath, '*.csv'));
Cchi = readmatrix(strcat(Data_path, CchiDataFile));


% calculate/get regime diagram relevant data
for i = c:c
    % full path
    Data_path_ = strcat(Data_path, DE_InputFiles{i});

    % read the csv file
    data = readmatrix(Data_path_);
    
    % number of dissipation elements (containing Zst)
    [~, num_columns] = size(data);
    DE_Zst = num_columns;

    % Coefficient C_chi
    C_chi = Cchi(i);

    % allocate memory
    mat = [];

    for j = 1:DE_Zst
        % extract data
        [DE_id, x_coords, y_coords, z_coords] = ExtractData(data(:,j));

        % get corresponding data points
        chi = ExtractDataPoints(Chi{i}, x_coords, y_coords, z_coords);
        enth = ExtractDataPoints(Enth{i}, x_coords, y_coords, z_coords);
        hr = ExtractDataPoints(HR{i}, x_coords, y_coords, z_coords);
        pv = ExtractDataPoints(PV{i}, x_coords, y_coords, z_coords);
        pvnorm = ExtractDataPoints(PVnorm{i}, x_coords, y_coords, ...
            z_coords);
        tgas = ExtractDataPoints(Tgas{i}, x_coords, y_coords, z_coords);
        yoh = ExtractDataPoints(YOH{i}, x_coords, y_coords, z_coords);
        zmix = ExtractDataPoints(Zmix{i}, x_coords, y_coords, z_coords);

        % Tinlet from DE
        Tin = mean(tgas);

        % get flamelet data
        [dZr, gq] = GetRespectiveFlameletData(de_flamelet_data, DE_id, ...
            flamelet_data, Z_st, C_chi);

        % get corresponding DE data
        DE_dZ = phi{i}(DE_id);
        DE_g = g{i}(DE_id) * (1/dx);

        % data in DE
        if strcmp(DEDataApproach, 'Mean')
            chi_ = mean(chi);
            enth_ = mean(enth);
            hr_ = mean(hr);
            pv_ = mean(pv);
            pvnorm_ = mean(pvnorm);
            tgas_ = mean(tgas);
            yoh_ = mean(yoh);
            zmix_ = mean(zmix);
        elseif strcmp(DEDataApproach, 'Max')
            chi_ = max(chi);
            enth_ = max(enth);
            hr_ = max(hr);
            pv_ = max(pv);
            pvnorm_ = max(pvnorm);
            tgas_ = max(tgas);
            yoh_ = max(yoh);
            zmix_ = max(zmix);
        elseif strcmp(DEDataApproach, 'Min')
            chi_ = min(chi);
            enth_ = min(enth);
            hr_ = min(hr);
            pv_ = min(pv);
            pvnorm_ = min(pvnorm);
            tgas_ = min(tgas);
            yoh_ = min(yoh);
            zmix_ = min(zmix);
        else
            fprintf(['\nInvalid dissipation element format: %s\n=> ' ...
                'Use: "Mean", "Max", or "Min"!'], DEDataApproach);
            return
        end

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
            if strcmp(DEDataApproach, 'Min')
                cblabel = '$\chi_\mathrm{min}$ [1/s]';
            elseif strcmp(DEDataApproach, 'Mean')
                cblabel = '$\chi_\mathrm{mean}$ [1/s]';
            elseif strcmp(DEDataApproach, 'Max')
                cblabel = '$\chi_\mathrm{max}$ [1/s]';
            end
            lowLim = 0; % TODO
            upLim = max(cb_var); % TODO
            %fprintf('-> Chi: %e\n', upLim);
            upLim = 3500; % 3062 % TODO
        case 'Enth'
            cb_var = mat(10,:);
            if strcmp(DEDataApproach, 'Min')
                cblabel = '$H_\mathrm{min}$ [kJ/kg]';   % unit correct?
            elseif strcmp(DEDataApproach, 'Mean')
                cblabel = '$H_\mathrm{mean}$ [kJ/kg]';   % unit correct?
            elseif strcmp(DEDataApproach, 'Max')
                cblabel = '$H_\mathrm{max}$ [kJ/kg]';   % unit correct?
            end
            lowLim = min(cb_var); % TODO
            upLim = max(cb_var); % TODO
            %fprintf('-> Enth: %e\n', upLim);
            lowLim = -1600; % -1568 % TODO
            upLim = -400; % -587 % TODO
        case 'HR'
            cb_var = mat(11,:);
            if strcmp(DEDataApproach, 'Min')
                cblabel = '$\omega_\mathrm{T,min}$ $\mathrm{[J/m^{3}/s]}$';
            elseif strcmp(DEDataApproach, 'Mean')
                cblabel = '$\omega_\mathrm{T,mean}$ $\mathrm{[J/m^{3}/s]}$';
            elseif strcmp(DEDataApproach, 'Max')
                cblabel = '$\omega_\mathrm{T,max}$ $\mathrm{[J/m^{3}/s]}$';
            end
            lowLim = 0; % TODO
            upLim = max(cb_var); % TODO
            %fprintf('-> HR: %e\n', upLim);
            upLim = 7.0E10; % 6.05E10 % TODO
        case 'PV'
            cb_var = mat(12,:);
            if strcmp(DEDataApproach, 'Min')
                cblabel = '$PV_\mathrm{min}$ [-]';
            elseif strcmp(DEDataApproach, 'Mean')
                cblabel = '$PV_\mathrm{mean}$ [-]';
            elseif strcmp(DEDataApproach, 'Max')
                cblabel = '$PV_\mathrm{max}$ [-]';
            end
            lowLim = min(cb_var); % TODO
            upLim = max(cb_var); % TODO
            %fprintf('-> PV: %e\n', upLim);
            %fprintf('-> lower limit PV: %e\n', lowLim);
            lowLim = -5E-03; % -4.603e-3 % TODO
            upLim = 10E-03; % 8.3e-3 % TODO
        case 'PVnorm'
            cb_var = mat(13,:);
            if strcmp(DEDataApproach, 'Min')
                cblabel = '$PV_\mathrm{norm,min}$ [-]';
            elseif strcmp(DEDataApproach, 'Mean')
                cblabel = '$PV_\mathrm{norm,mean}$ [-]';
            elseif strcmp(DEDataApproach, 'Max')
                cblabel = '$PV_\mathrm{norm,max}$ [-]';
            end
            lowLim = 0; % TODO
            upLim = max(cb_var); % TODO
            %fprintf('-> PVnorm: %e\n', upLim);
            upLim = 1; % 1 %TODO
        case 'Tgas'
            cb_var = mat(14,:);
            if strcmp(DEDataApproach, 'Min')
                cblabel = '$T_\mathrm{gas,min}$ [K]';
            elseif strcmp(DEDataApproach, 'Mean')
                cblabel = '$T_\mathrm{gas,mean}$ [K]';
            elseif strcmp(DEDataApproach, 'Max')
                cblabel = '$T_\mathrm{gas,max}$ [K]';
            end
            lowLim = 0; % TODO
            upLim = max(cb_var); % TODO
            %fprintf('-> Tgas: %e\n', upLim);
            upLim = 2500; % 2348 % TODO
        case 'YOH'
            cb_var = mat(15,:);
            if strcmp(DEDataApproach, 'Min')
                cblabel = '$Y_\mathrm{OH,min}$ [-]';
            elseif strcmp(DEDataApproach, 'Mean')
                cblabel = '$Y_\mathrm{OH,mean}$ [-]';
            elseif strcmp(DEDataApproach, 'Max')
                cblabel = '$Y_\mathrm{OH,max}$ [-]';
            end
            lowLim = 0; % TODO
            upLim = max(cb_var); % TODO
            %fprintf('-> YOH: %e\n', upLim);
            upLim = 0.014; % 0.013 % TODO
        case 'Zmix'
            cb_var = mat(16,:);
            if strcmp(DEDataApproach, 'Min')
                cblabel = '$Z_\mathrm{mix,min}$ [-]';
            elseif strcmp(DEDataApproach, 'Mean')
                cblabel = '$Z_\mathrm{mix,mean}$ [-]';
            elseif strcmp(DEDataApproach, 'Max')
                cblabel = '$Z_\mathrm{mix,max}$ [-]';
            end
            lowLim = 0; % TODO
            upLim = max(cb_var); % TODO
            %fprintf('-> Zmix: %e\n', upLim);
            upLim = 0.3; % 0.262 %TODO
        otherwise
            fprintf('\nInvalid variable!');
            return
    end

    % warning if max value is above the limit
    if max(cb_var) > upLim
        fprintf('Max(%s) is > upper limit in colorbar!\n=>%e > %e\n', ...
            var_, max(cb_var), upLim);
    end
    % warning if min value is below the limit
    if min(cb_var) < lowLim
        fprintf('Min(%s) is < lower limit in colorbar!\n=>%e > %e\n', ...
            var_, min(cb_var), lowLim);
    end


    % plot
    x = mat(8,:); %(1/dx)*mat(8,:); % dgprime
    y = mat(7,:); % dZprime
    z = cb_var;

    % color figure
    XData = squeeze(x(:));
    YData = squeeze(y(:));
    [x1,x2,cond_mean ] = Compute_ConditionalMean_histograms_2D(z, x, y, ...
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
    if strcmp(var_, 'Enth')
        cb.Ticks = [-1600, -1400, -1200, -1000, -800, -600, -400];
    end
    if strcmp(var_, 'PV')
        cb.Ticks = [-5.0e-3, -2.5e-3, 0, 2.5e-3, 5.0e-3, 7.5e-3, 10e-3];
    end

    % threshold lines
    xline(1, '--k', 'LineWidth', lw+1, 'HandleVisibility', 'off');
    hold on;
    yline(15, '--k', 'LineWidth', lw+1, 'HandleVisibility', 'off');
    hold on;

    % lim and ticks    
    if ~threshold
%         if c == 1
%             xmax = 5;
%             ymax = 2;
%             xlim([0 xmax]);
%             ylim([0 ymax]);
%             xtick_positions = linspace(0, xmax, 6);
%             set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
%             ytick_positions = linspace(0, ymax, 5);
%             set(gca, 'YTick', ytick_positions, 'LineWidth', lw);
%         elseif c == 2
        xmax = 5;
        ymax = 5;
        xlim([0 xmax]);
        ylim([0 ymax]);
        xtick_positions = linspace(0, xmax, 6);
        set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
        ytick_positions = linspace(0, ymax, 6);
        set(gca, 'YTick', ytick_positions, 'LineWidth', lw);
%         elseif c == 3
%             xmax = 0.2;
%             ymax = 2.5;
%             xlim([0 xmax]);
%             ylim([0 ymax]);
%             xtick_positions = linspace(0, xmax, 5);
%             set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
%             ytick_positions = linspace(0, ymax, 6);
%             set(gca, 'YTick', ytick_positions, 'LineWidth', lw);
%         end
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
    if ~threshold
        outfname = strcat(Fig_outpath, ofname, time{end}, '_', ...
            DEDataApproach, '_', var_);
    else
        outfname = strcat(Fig_outpath, ofname, 'threshold_', ...
            time{end}, '_', DEDataApproach, '_', var_);
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


function [Flamelet_dZr,Flamelet_gq] = GetRespectiveFlameletData(data, ...
    id, flamelets, zst, C_chi)

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
    %Chi = flamelet_data.chi;
    %D = flamelet_data.D;
    HR = flamelet_data.HeatRelease;
    Z = flamelet_data.Z;

    % calculate reaction zone thickness
    Flamelet_dZr = ComputeReactionZoneThickness(HR, Z);
    %fprintf('Reaction zone thickness dZr = %e\n', Flamelet_dZr);

    % calculate quenching gradient (= max(chi_st) for Tinlet)
    chi_quenching = [];
    d_chi_quenching = [];
    for i = 1:length(flamelets)
        sp_fname = split(flamelets(i).name, '.');
        Tinlet_ = str2double(sp_fname{2});
        if Tinlet_ == Tinlet
            data = readtable(strcat(flamelets(i).folder, '/', ...
                flamelets(i).name), 'Delimiter', '\t', ...
                'PreserveVariableNames', true);
            chi_ = data.chi;
            d_ = data.D;
            zmix_ = data.Z;
            [~, idx] = min(abs(zmix_ - zst));
            chiqu = chi_(idx);
            dqu = d_(idx);
            chi_quenching = [chi_quenching, chiqu];
            d_chi_quenching = [d_chi_quenching, dqu];
        elseif Tinlet_ > Tinlet
            break
        end
    end
    [Chi_qu, idx_q] = max(chi_quenching);
    D_qu = d_chi_quenching(idx_q);

    Flamelet_gq = (Chi_qu / (C_chi * 6 * D_qu))^0.5;
    %fprintf('Quenching gradient g_q = %e 1/m\n', Flamelet_gq);

end


function dZr = ComputeReactionZoneThickness(w, Z)

    % max heat-release
    [wmax_val, wmax_idx] = max(w);
    
    % second gradient
    if wmax_idx ~= length(w)
        % dZ = Z(wmax_idx + 1) - Z(wmax_idx);
        % "ensure" to have a equidistant grid
        dZp = Z(wmax_idx+1) - Z(wmax_idx);
        dZm = Z(wmax_idx) - Z(wmax_idx-1);
        dwdZ_sec = 2.*( dZm .* w(wmax_idx + 1) - (dZm + dZp) .* ...
            w(wmax_idx) + dZp .* w(wmax_idx - 1)) ./ ((dZm + ...
            dZp) .* (dZm .* dZp));
    else
        % max point at the end
        fprintf(['Max at end -> finite difference at boundary for ' ...
            'case: %s\n'] ,c);
        return
    end

    % reaction zone thickness (Niemietz 2024)
    dZr = 2 .* (-2 .* log(2) .* wmax_val .* (dwdZ_sec).^(-1)).^(0.5);
    %fprintf('Reaction zone thickness = %e\n', dZr);

end


function [ x1,x2,cond_mean ] = Compute_ConditionalMean_histograms_2D(quantity_interest,array_1,array_2,n_bins)

%Prepare array
[a,b,c] = size(array_1);
nx=a*b*c;
[a,b,c] = size(array_2);
ny=a*b*c;


if (nx~=ny)
disp('!!!!!!!!!!!!!!!!!!!! Error !!!!!!!!!!!!!!!!!!!!') 
disp('!!!!!!!!!!!!!!!!!!!! Error !!!!!!!!!!!!!!!!!!!!') 
disp('!!!!! x- and y-array need to be same size !!!!!') 
disp('!!!!!!!!!!!!!!!!!!!! Error !!!!!!!!!!!!!!!!!!!!') 
disp('!!!!!!!!!!!!!!!!!!!! Error !!!!!!!!!!!!!!!!!!!!') 
end
n=nx;

array1 = reshape(array_1,[n 1]);
array2 = reshape(array_2,[n 1]);
array_tmp = reshape(quantity_interest,[n 1]);


[N,X1_edges,X2_edges,binX,binY] = histcounts2(array1,array2,n_bins);

x1=(X1_edges(2:end)+X1_edges(1:end-1))/2;
x2=(X2_edges(2:end)+X2_edges(1:end-1))/2;

cond_mean = zeros(n_bins,n_bins);

for i=1:n
cond_mean(binY(i),binX(i)) = cond_mean(binY(i),binX(i)) + array_tmp(i)/N(binX(i),binY(i));
end 

cond_mean(N'==0)=NaN;


end
