clc
clear all
close all


% ================================
% Saves the following variables:
% ID, g, dZ, dZr, dZ/dZr
% for each DE in a csv file
% ================================


%====
% INPUTS
%====
data_path = ['~/itv/OXYFLAME-B3/File_Transfer/DE_analysis_code/' ...
    'trajSearch/Dataset'];
cases= {'traj_Tbox_ign.h5', 'traj_Tbox_OHmax.h5', ...
    'traj_Tbox_fullComb.h5', 'traj_Tbox_finish.h5'};
DE_data_path = '../../PostProcessedData/';
Fig_path = '../../Figures/DissipationElements/ReactionZoneThickness/';
inputfiles = {'DEGridpointsZst_ign.csv', ...
    'DEGridpointsZst_OHmax.csv', ...
    'DEGridpointsZst_fullComb.csv',...
    'DEGridpointsZst_final.csv'};
ofname = 'RegimeDiagramData_';
sorted = true;
Zst = 0.117;
createdZrFigure = true;
% save figure in [png, eps, pdf]
FigFormat = 'png';
%====


% create output directory
if Fig_path(end) ~= '/'
    Fig_path = [Fig_path, '/'];
end
if ~exist(Fig_path,'dir')
    mkdir(Fig_path);
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
set(0, 'defaultFigurePosition', [2 2 600 500]);
set(gca, 'TickLabelInterpreter', 'latex');
close


% 
home = pwd;


%
if sorted
    ofname = strcat(ofname, 'SortedZmin2Zmax_');
end


% read data
for i = 1:3 %length(cases)
    % Zmix
    Zmix{i} = h5read(strcat(data_path ,'/', cases{i}), ...
        '/scalar/ZMIX');
    % HR
    HR{i} = h5read(strcat(data_path ,'/', cases{i}), ...
        '/scalar/HR');
    % scalar position and value for each DE
    edata_dble{i} = h5read(strcat(data_path ,'/', cases{i}), ...
        '/traj_full/edata_dble');
end


% calculate DE related variables
for i = 1:3 %length(cases)
    l{i}=edata_dble{i}(7,:);
    lm{i}=mean(edata_dble{i}(7,:));
    ln{i}=l{i}./lm{i};
    phi{i}=edata_dble{i}(10,:);
    phim{i}=mean(edata_dble{i}(10,:));
    phin{i}=phi{i}./phim{i};
    g{i} = phi{i}./l{i};
    gn{i} = (phi{i}./phim{i})./(l{i}./lm{i});
end


for i = 2:2 %length(cases)
    % full path
    DE_data_path_ = strcat(DE_data_path, inputfiles{i});

    % read the csv file
    data = readmatrix(DE_data_path_);
    
    % number of dissipation elements (containing Zst)
    [~, num_columns] = size(data);
    DE_Zst = num_columns;

    % allocate memory
    mat = [];
    for j = 1:DE_Zst
        % extract data
        [DE_id, x_coords, y_coords, z_coords] = ExtractData(data(:,j));

        % get corresponding data points
        zmix = ExtractDataPoints(Zmix{i}, x_coords, y_coords, z_coords);
        hr = ExtractDataPoints(HR{i}, x_coords, y_coords, z_coords);

        % calculate reaction zone thickness
        [dZr, Z_wmax] = ComputeReactionZoneThickness(hr, zmix, ...
            cases{i}, DE_id, createdZrFigure, lw, FZ, Fig_path, ...
            FigFormat, sorted);

        if dZr ~= 0
            %
            DE_g = g{i}(DE_id);
            DE_dZ = phi{i}(DE_id);
    
            % store data in matrix
            % TODO save it in scientific notation
            mat = [mat, [DE_id, DE_g, DE_dZ, dZr, DE_dZ/dZr]'];
        end
    end

    % write matrix to file
    SimCase = cases{i}(1:end-3);
    writematrix(mat, strcat(DE_data_path, ofname, SimCase, '.csv'));
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


function [dZr, Z_wmax] = ComputeReactionZoneThickness(hr, z, c, e, s, ...
    lw, FZ, Figpath, FigFormat, sorted)

    % ignore DE if profile is incomplete (= max at the end)
    subdir = 'NotSorted/';
    flag = false;
    condition = false;

    % sort array's from small to large
    [z_, idx_] = sort(z);
    hr_ = hr(idx_);
    if sorted
        subdir = 'Sorted_Zmin2Zmax/';
        z = z_;
        hr = hr_;
    end

    % max heat-release
    [wmax_val, wmax_idx] = max(hr);
    
    % condition = max is not the last data point
    if sorted
        if wmax_idx ~= length(hr)
            condition = true;
        end
    else
        if z(wmax_idx) ~= z_(end) && wmax_idx ~= length(hr)
            condition = true;
        end
    end

    % second gradient
    if condition
        dwdZ_sec = (hr(wmax_idx + 1) - 2*hr(wmax_idx) + ...
            hr(wmax_idx - 1)) / (z(wmax_idx + 1) - ...
            z(wmax_idx))^2;
    else
        % max point at the end
        %fprintf(['Max at end -> finite difference at boundary for ' ...
        %    'case: %s and dissipation element: %i\n'] ,c, e);
        %dwdZ_sec = (-hr(wmax_idx) + 2*hr(wmax_idx - 1) - ...
        %   hr(wmax_idx - 2)) / (z(wmax_idx) - ...
        %   z(wmax_idx - 1))^2;
        %dwdZ_sec = (hr(wmax_idx) - 2*hr(wmax_idx - 1) + ...
        %    hr(wmax_idx - 2)) / (z(wmax_idx) - ...
        %    z(wmax_idx - 1))^2;
        %if dwdZ_sec > 0  % ask Pooria ... dwdZ_sec must be negative ...
        %    dwdZ_sec = dwdZ_sec * -1;
        %    disp('and *-1 ... ?');
        %end
        flag = true;
        s = false;
        wmax_val = 1;
        dwdZ_sec = 1;
    end

    % reaction zone thickness (Niemietz 2024)
    dZr = 2 * (-2 * log(2) * wmax_val * (dwdZ_sec)^(-1))^(0.5);
    %fprintf('Reaction zone thickness for case "%s" = %e\n', ...
    %    c(1:end-3), dZr);
    
    %
    Z_wmax = z(wmax_idx);
    
    if flag
        dZr = 0;
    end

    % show figure (optional)
    if s
        dirpath = strcat(Figpath, subdir);
        if ~exist(dirpath,'dir')
            mkdir(dirpath);
        end
        % plot
        %plot(z, hr, 'LineWidth', lw+1, 'Color', 'blue');
        hold off;
        scatter(z, hr, 'Marker', 'x', 'Color', 'blue');
        hold on;
        scatter(z(wmax_idx), hr(wmax_idx), 'Marker', 'o', 'Color', 'red');

        % labels and title
        xlabel('$Z \mathrm{[-]}$', 'fontsize', FZ, ...
            'interpreter', 'latex', 'FontWeight', 'bold');
        ylabel('$\omega_\mathrm{T} \mathrm{[J/m^{3}/s]}$', ...
            'fontsize', FZ, 'interpreter', 'latex', 'FontWeight', 'bold');
        header = sprintf('DE: %i', e);
        title(header, 'fontsize', ...
            FZ, 'Interpreter', 'latex', 'FontSize', FZ);
        
        % background
        set(gcf,'color','w');

        % format
        set(gca, 'Box', 'on');

        % figure name
        time = split(c(1:end-3), '_');
        outfname = strcat(dirpath, 'ReactionZoneThickness_', time{end}, ...
            '_DE_', num2str(sprintf('%05d',e)));

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

end
