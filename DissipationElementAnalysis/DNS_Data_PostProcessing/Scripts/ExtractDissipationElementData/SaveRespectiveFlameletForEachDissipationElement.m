clc
clear
close all


% ================================
% finds the respective flamelet for each
% dissipation element
% => options: based on Tgas or Yoh
% => saves: DE_id, Tinlet, strain rate
% ================================


%====
% INPUTS
%====
hdf5_data_path = ['~/itv/OXYFLAME-B3/File_Transfer/DE_analysis_code/' ...
    'trajSearch/Dataset'];
cases= {'traj_Tbox_ign.h5', 'traj_Tbox_OHmax.h5', ...
    'traj_Tbox_fullComb.h5', 'traj_Tbox_finish.h5'};
FlameletDataPath = ['../../../Flamelets/Cantera/OutputData/' ...
    'Flamelet_preheated_PassiveScalarMixtureFraction/Data/'];
DE_DataPath = '../../PostProcessedData/';
DE_InputFiles = {'DEGridpointsZst_ign.csv', ...
    'DEGridpointsZst_OHmax.csv', ...
    'DEGridpointsZst_fullComb.csv',...
    'DEGridpointsZst_final.csv'};
Data_ofname = 'DE_Flamelets_';
Fig_outpath = '../../Figures/DissipationElements/Flamelet/';
% Fit flamelets and dissipation elements based on 'Tgas' or 'YOH'
FittingVar = 'Tgas';
% run the script for case c
c = 2;
% calculate inlet temperature based on PDF (true) or mean (false)
% temperature in dissipation element
TinletApproach = true;
% save data
saveData = true;
% inputs for CellDataAvg()
n_bins = 50; %200;
sf = 0.01;
factor= 2e-5;
% save figure in [png, eps, pdf]
FigFormat = 'png';
%====


% output sub-directory
if Fig_outpath(end) ~= '/'
    Fig_outpath = [Fig_outpath, '/'];
end
if strcmp(FittingVar, 'Tgas')
    Fig_outpath = strcat(Fig_outpath, 'FittingVariable_Tgas/');
    Data_ofname = strcat(Data_ofname, 'Tgas_');
elseif strcmp(FittingVar, 'YOH')
    Fig_outpath = strcat(Fig_outpath, 'FittingVariable_YOH/');
    Data_ofname = strcat(Data_ofname, 'YOH_');
end
if TinletApproach
    Fig_outpath = strcat(Fig_outpath, 'PDFTemperature/SelectedFlamelets/');
    Data_ofname = strcat(Data_ofname, 'PDF_');
else
    Fig_outpath = strcat(Fig_outpath, 'MeanTemperature/');
    Data_ofname = strcat(Data_ofname, 'meanT_');
end


% create figure output directory
if Fig_outpath(end) ~= '/'
    Fig_outpath = [Fig_outpath, '/'];
end
if ~exist(Fig_outpath,'dir')
    mkdir(Fig_outpath);
end


% data output path
Data_output = strcat(DE_DataPath, Data_ofname);


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


% read DNS data
Tgas = cell(1,1);
YOH = cell(1,1);
Zmix = cell(1,1);
for i = 1:length(cases)
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


% get all flamelet files
flamelets_files = dir(fullfile(FlameletDataPath, '*.csv'));


% calculate/get regime diagram relevant data
for i = c:c
    % full path
    DE_DataPath_ = strcat(DE_DataPath, DE_InputFiles{i});

    % read csv file
    data = readmatrix(DE_DataPath_);
    
    % number of dissipation elements (containing Zst)
    [~, num_columns] = size(data);
    DE_Zst = num_columns;

    % allocate memory
    res = [];

    for j = 1:DE_Zst
        % extract data
        [DE_id, x_coords, y_coords, z_coords] = ExtractData(data(:,j));

        % get corresponding data points
        Tgas_ = ExtractDataPoints(Tgas{i}, x_coords, y_coords, z_coords);
        YOH_ = ExtractDataPoints(YOH{i}, x_coords, y_coords, z_coords);
        Zmix_ = ExtractDataPoints(Zmix{i}, x_coords, y_coords, z_coords);

        % create figure
        close all
        figure
        
        % layout
        t = tiledlayout(1,1);
        t.TileSpacing = 'compact';
        t.Padding = 'loose';                                                                                                                                                                                                                      
        nexttile([1, 1]);

        % background
        set(gcf,'color','w');

        % format
        set(gca, 'Box', 'on');
        
        % get flamelet inlet temperature
        if TinletApproach
            % inlet temperature based on PDF
            tgas_ = DissElementMeanTemperatureFromPDF(Tgas_, Zmix_, ...
                n_bins, sf, factor, Fig_outpath, cases{i}, DE_id, ...
                FigFormat, FZ, lw);
        else
            % mean data in DE
            tgas_ = mean(Tgas_);
        end

        % read corresponding flamelet files (Tinlet)
        [flamelets_zmix, flamelets_tgas, flamelets_yoh, flamelets_tin, ...
            flamelets_a] = ReadFlamelets(flamelets_files, tgas_);
        
        % plot flamelets
        cmap = jet(length(flamelets_a));
        if strcmp(FittingVar, 'Tgas')
            y_plot = flamelets_tgas;
        elseif strcmp(FittingVar, 'YOH')
            y_plot = flamelets_yoh;
        end
        for k = 1:length(flamelets_a)
            plot(flamelets_zmix{k}, y_plot{k}, '-', ...
                'LineWidth', lw, 'Color', cmap(k,:), ...
                'HandleVisibility', 'off');
            hold on;
        end

        % colorbar flamelets
        colormap(cmap);
        cb = colorbar('eastoutside');
        cb.TickLabelInterpreter = 'latex';
        caxis_min = 0;
        caxis_max = max(cellfun(@(x) max(x(:)), flamelets_a));
        caxis_min_ = caxis_min - 0.5;
        caxis_max_ = caxis_max + 0.5;
        caxis([caxis_min_ caxis_max_]);
        ticks = round(linspace(caxis_min, caxis_max, 6));
        cb.Ticks = ticks;
        ylabel(cb, '$a$ [1/s]', 'fontsize', FZ, ...
            'interpreter', 'latex', 'FontWeight', 'bold')

        % dissipation element data
        XData = squeeze(Zmix_(:));
        if strcmp(FittingVar, 'Tgas')
            YData = squeeze(Tgas_(:));
        elseif strcmp(FittingVar, 'YOH')
            YData = squeeze(YOH_(:));
        end

        % conditional mean
        [x1_data, avg_data] = CellDataAvg(XData, YData, n_bins, ...
            [min(XData) max(XData)], 1, sf, factor);
        c_max = max(size(XData),[],'all');
        z_dir = zeros(size(x1_data,1),1)+c_max+1;
        plot3(x1_data, avg_data, z_dir, 'k', 'LineWidth', lw+1);
        [PDF_x1, PDF_x2, PDF_y] = Compute_PDF_histograms_2D(XData, ...
            YData, n_bins);
        PDF_y = log10(PDF_y);
        s = imagesc(PDF_x1, PDF_x2, PDF_y);
        set(s, 'AlphaData', ~isnan(PDF_y));
        set(gca, 'YDir', 'normal');
        hold on;

        % find the nearest line (flamelet) to the conditional mean (DE) in
        % a defined Z-range
        if strcmp(FittingVar, 'Tgas')
            [flameletsNearest_zmix, flameletsNearest_tgas, strain_rate, ...
                de_target_zmix, de_target_tgas] = FindNearestFlamelet( ...
                flamelets_zmix, flamelets_tgas, flamelets_a, x1_data, ...
                avg_data);
        elseif strcmp(FittingVar, 'YOH')
            [flameletsNearest_zmix, flameletsNearest_yoh, strain_rate, ...
                de_target_zmix, de_target_yoh] = FindNearestFlamelet( ...
                flamelets_zmix, flamelets_yoh, flamelets_a, x1_data, ...
                avg_data);
        end

        % plot nearest flamelet - strain_rate+1 -> 0 to ..
        strain_rate_plot = strain_rate + 1;
        if strcmp(FittingVar, 'Tgas')
%             plot(flamelets_zmix{strain_rate+1}, ...
%                 flamelets_tgas{strain_rate+1}, 'x-', 'LineWidth', lw+1, ...
%                 'Color', cmap(strain_rate+1,:), 'MarkerEdgeColor', 'black', ...
%                 'HandleVisibility', 'off');
            scatter(flamelets_zmix{strain_rate_plot}, ...
                flamelets_tgas{strain_rate_plot}, 'x', ...
                'MarkerEdgeColor', 'black', 'HandleVisibility', 'off');
%             plot(flameletsNearest_zmix(strain_rate), ...
%                 flameletsNearest_tgas(strain_rate), 'Marker', 'o', ...
%                 'MarkerSize', 5, 'Color','black');
        elseif strcmp(FittingVar, 'YOH')
            scatter(flamelets_zmix{strain_rate_plot}, ...
                flamelets_yoh{strain_rate_plot}, 'x', ...
                'MarkerEdgeColor', 'black', 'HandleVisibility', 'off');
        end
        hold on;

        % highlight z-range for analysis
        xline(min(de_target_zmix), '--k', 'LineWidth', lw+1, ...
            'HandleVisibility', 'off');
        hold on;
        xline(max(de_target_zmix), '--k', 'LineWidth', lw+1, ...
            'HandleVisibility', 'off');
        hold on;

        % label and title
        grid off
        header = strcat(sprintf('DE: %i; ', DE_id), ...
            ' $T_\mathrm{DE}$= ', sprintf(' %iK', round(tgas_, 0)));
        xlabel('$Z_\mathrm{mix} \mathrm{[-]}$', ...
            'Interpreter', 'latex', 'fontsize', FZ);
        if strcmp(FittingVar, 'Tgas')
            ylabel('$T_\mathrm{gas}$ [K]', ...
                'Interpreter', 'latex', 'fontsize', FZ);
        elseif strcmp(FittingVar, 'YOH')
            ylabel('$Y_\mathrm{OH}$ [-]', ...
                'Interpreter', 'latex', 'fontsize', FZ);
        end
        title(header, 'Interpreter', 'latex', 'FontSize', FZ-2);
        set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on');

        % boundaries
        lowXLim = 0;
        upXLim = 0.30;
        if strcmp(FittingVar, 'Tgas')
            lowYLim = 1000;
            upYLim = 3000;
        elseif strcmp(FittingVar, 'YOH')
            lowYLim = 0;
            upYLim = 0.02;
        end
        xlim([lowXLim upXLim]);
        ylim([lowYLim upYLim]);

        % add Tinlet and strain rate to figure
        label = strcat('$T_\mathrm{inlet}$=', num2str(flamelets_tin), ...
           'K, $a$=', num2str(strain_rate), ' $1/s$');
        if strcmp(FittingVar, 'Tgas')
            text(0.005, 2850, label, 'Interpreter', 'latex', ...
                'FontSize', FZ);
        elseif strcmp(FittingVar, 'YOH')
            text(0.005, 0.0185, label, 'Interpreter', 'latex', ...
                'FontSize', FZ);
        end

        % figure name
        if j == 1
            time = split(cases{i}(1:end-3), '_');
            Fig_outpath_ = strcat(Fig_outpath, 'Case_', time{end}, '/');
            if ~exist(Fig_outpath_,'dir')
                mkdir(Fig_outpath_);
            end
        end
        outfname = strcat(Fig_outpath_, 'DEid_', ...
            num2str(sprintf('%04d',DE_id)));
        
        % save figure
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

        % store dissipation element id and respective flamelet inlet
        % temperature and strain rate
        res = [res, [DE_id, flamelets_tin, strain_rate]'];
    end

    if saveData
        % write flamelet data for each dissipation element to a csv file
        time = split(cases{c}(1:end-3), '_');
        Data_output_ = strcat(Data_output, time{end}, '.csv');
        %writematrix(res, Data_output_);

        res = res';
        header = sprintf('%-13s\t%-13s\t%-13s', 'DE_id', 'Tinlet', ...
            'StrainRate');
        DataFormat = '%-13E\t%-13E\t%-13E\n';
        fid = fopen(Data_output_, 'w');
        fprintf(fid, '%s\n', header);
        for i1 = 1:length(res)
            fprintf(fid, DataFormat, res(i1,:));
        end
        fclose(fid);
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


function [zmix, tgas, yoh, TinFlamelet_, a] = ReadFlamelets(files, TinDE)

    % allocate memory
    zmix = {};
    tgas = {};
    yoh = {};
    a = {};

    % round dissipation element temperature to the nearest hundred
    tinde = round(TinDE, -2);

    % get flamelet data
    for i = 1:length(files)
        sp_fname = split(files(i).name, '.');
        TinFlamelet = str2double(sp_fname(2));
        aFlamelet = str2double(sp_fname(3));
        if TinFlamelet == tinde || (tinde >= 1500 && TinFlamelet == 1500)
            [zmix, tgas, yoh, a] = GetFlameletData(files(i), zmix, ...
                tgas, yoh, a, aFlamelet);
            TinFlamelet_ = TinFlamelet;
        end
    end
%     if tinde < 1500
%         disp(TinDE);
%         disp(tinde);
%         disp(TinFlamelet);
%         disp(TinFlamelet_);
%     end

end


function [z, t, yoh, a] = GetFlameletData(f, z, t, yoh, a, ain)

    %
    flamelet_data = readtable(strcat(f.folder, '/', f.name), ...
        'Delimiter', '\t', 'PreserveVariableNames', true);
    z{end + 1} = flamelet_data.Z;
    t{end + 1} = flamelet_data.Temp;
    yoh{end + 1} = flamelet_data.OH;
    a{end + 1} = ain;

end


function meanT = DissElementMeanTemperatureFromPDF(t, z, n_bins, sf, ...
    factor, Fig_outpath, sim_case, DE_id, FigFormat, FZ, lw)

    %
    x_data = z;
    y_data = t;

    % pdf
    %c_max1 = max(size(x_data), [], 'all');
    %[x1_data, avg_data] = CellDataAvg(x_data, y_data, n_bins, ...
    %    [min(x_data) max(x_data)], 1, sf, factor);
    %z_dir = zeros(size(x1_data, 1), 1) + c_max1 + 1;
    n_bins = 100;
    h = histogram(y_data, n_bins);
    binCenters = h.BinEdges; %+ (h.BinWidth/2);

    % plot
    set(0, 'defaultFigurePosition', [2 2 600 500])
    close all
    figure(2)
    tl = tiledlayout(1, 1, 'Padding', 'compact', 'TileSpacing', 'compact');
    tl.TileSpacing = 'compact';
    %plot(x1_data, avg_data, 'LineWidth', lw+1, 'DisplayName', 'DE');
    p = histcounts(y_data, n_bins, 'Normalization', 'pdf');
    plot(binCenters(1:end-1), p./trapz(p));

    % mean temperature
    [~, idx] = max(p./trapz(p));
    meanT = binCenters(idx);
    if meanT < 300
        meanT = 300;
    end

    %
    set(gcf,'color', 'w');
    set(gca, 'Box', 'on');
    header = strcat(sprintf('DE: %i; ', DE_id), ...
        ' $T_\mathrm{DE,PDF}$= ', sprintf(' %iK', round(meanT, 0)));
    xlabel('$T_\mathrm{gas}$ [K]', ...
        'Interpreter', 'latex', 'fontsize', FZ);
    ylabel('$P(T_\mathrm{gas})$ [-]', ...
        'Interpreter', 'latex', 'fontsize', FZ);
    title(header, 'Interpreter', 'latex', 'FontSize', FZ-2);

    % save figure
    time = split(sim_case(1:end-3), '_');
    disp(Fig_outpath);
    Fig_outpath_ = strcat(Fig_outpath, '../PDFs/Case_', time{end}, '/');
    if ~exist(Fig_outpath_, 'dir')
        mkdir(Fig_outpath_);
    end
    outfname = strcat(Fig_outpath_, 'DEid_', ...
        num2str(sprintf('%04d', DE_id)));
    if strcmp(FigFormat, 'png')
        saveas(figure(2), strcat(outfname, '.png'), 'png');
    elseif strcmp(FigFormat, 'eps')
        saveas(figure(2), strcat(outfname, '.eps'), 'epsc');
    elseif strcmp(FigFormat, 'pdf')
        exportgraphics(figure(2), strcat(outfname, '.pdf'), ...
            'ContentType', 'vector');
    else
        fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
            FigFormat);
        return
    end

end


function [x_flamelets, y_flamelets, a, z_target, ...
    t_target] = FindNearestFlamelet(fl_zmix, fl_tgas, fl_a, cm_zmix, ...
    cm_tgas)

    % intersection conditional mean and flamelet with max(a)
    %intersection = GetIntersectionPoint(cm_zmix, cm_tgas, fl_zmix{end}, ...
    %    fl_tgas{end});
    intersection = max(cm_zmix);

    % DE: extract relevant temperature values within the Z-range
    Z_range = (min(cm_zmix) & cm_zmix <= intersection);
    z_target = cm_zmix(Z_range);
    t_target = cm_tgas(Z_range);
    fprintf('Z-range: Min=%e and Max=%e\n', min(z_target), ...
        max(z_target));

    % flamelets
    x_flamelets = [];
    y_flamelets = [];
    for i = 1:length(fl_a)
        % relevant flamelet range
        fl_range = (fl_zmix{i} >= min(cm_zmix)) & (fl_zmix{i} <= ...
            intersection);
        % clipp smaller and larger flamelet temperatures
        tgas = fl_tgas{i}(fl_range);
        zmix = fl_zmix{i}(fl_range);
        % allocate memory
        flamelet_tgas = [];
        flamelet_zmix = [];
        % get nearest temperature
        for j = 1:length(t_target)
            %[~, idx] = min(abs(tgas - t_target(j)));
            [~, idx] = min(abs(zmix - z_target(j)));
            flamelet_tgas = [flamelet_tgas, tgas(idx)];
            flamelet_zmix = [flamelet_zmix, zmix(idx)];
        end
        % store data
        x_flamelets = [x_flamelets, flamelet_zmix'];
        y_flamelets = [y_flamelets, flamelet_tgas'];
    end

    % distances to target line (dissipation element)
    % -> mean absolute difference for each column ('1') [column = gas
    % temperature]
    distances = mean(abs(y_flamelets - t_target), 1);

    % nearest line to conditional mean
    [~, idx] = min(distances);

    if isempty(idx)
        fprintf('No intersection point! => max strain rate selected!\n');
        idx = length(fl_a);
    end

    % respective flamelet
    a = fl_a{idx};
    fprintf('The closest flamelet has the strain rate %i!\n', a);

end


function x_intersection = GetIntersectionPoint(de_x, de_y, fl_x, fl_y)

    % common data points - high resolution (500)
    [fl_x, unique_idx] = unique(fl_x, 'stable'); % parablua -> sorted
    fl_y = fl_y(unique_idx); 
    x_com = linspace(min(min(de_x), min(fl_x)), max(max(de_x), ...
        max(fl_x)), 1E4);
    y_de_interp = interp1(de_x, de_y, x_com, 'linear', 'extrap');
    y_fl_interp = interp1(fl_x, fl_y, x_com, 'linear', 'extrap');

    % intersection point
    idx = find(abs(y_de_interp - y_fl_interp) < 0.1);
    if length(idx) > 1
        % condition above is not accurate enough!
        fprintf(['Multiple intersection points detected - minimun ' ...
            'selected on the Z-axis!\n']);
        idx = min(idx);
    elseif isempty(idx)
        % no intersection point between both lines
        % -> max limit = min limit
        fprintf('No intersection point between both lines detected!\n');
        [~, idx] = min(idx);
    end
    x_intersection = x_com(idx);
%     fprintf(['max intersection point of conditional mean and flamelet ' ...
%         'with highest strain rate: %d\n'], x_intersection);
% 
%     figure;
%     hold on;
%     plot(de_x, de_y, 'r', 'DisplayName', 'Curve 1');
%     plot(fl_x, fl_y, 'b', 'DisplayName', 'Curve 2');
%     xline(x_intersection, '--k', 'LineWidth', 1, ...
%         'HandleVisibility', 'off');
%     legend;
%     grid on;

end


function [PDF_x1, PDF_x2, PDF_y] = Compute_PDF_histograms_2D(array_1, ...
    array_2, n_bins)

% prepare array
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

[N,X1_edges,X2_edges] = histcounts2(array1,array2,n_bins);

N_sum = sum(sum(N));

dx=X1_edges(2)-X1_edges(1);
dy=X2_edges(2)-X2_edges(1);

PDF_y = N'./N_sum/dx/dy;

PDF_x1 = 0.5*(X1_edges(1:end-1) + X1_edges(2:end));
PDF_x2 = 0.5*(X2_edges(1:end-1) + X2_edges(2:end));

PDF_y(N'==0)=NaN;

end


function [x_data, avg_data, std_data] = CellDataAvg(X, Y, n, X_lim, ...
    type, sf, factor)
% X = Column Vector
% Y = Column Vector
% n = Maximum number of Conditional Mean Points; Note that the function
% would not return the same number of points as there are come cells which
% may have no data points
% xlim = Entered in Format [lower limit of X, higher limit of X] --- limit from maximum to minimum for which conditional mean is
% required, this limit may be trimmed for places where data is sparse
% type == possible values 1 or else(e.g. 0) if type == 1, the program will
% automatically determine if the data is sparse at some points and will not
% include those points in the output. This is usefull for plotting,
% especially DNS data and autmatic adjustments while plottting many plots
% and plotting automation. Note that in case, type == 1, the xlim should be given as following input xlim = [min(X), max(X)]
% sf = smoothing factor based on number of points in the input; use around 0.05 for good result ( emperical test)
% --- May need to Change upon use ----------
%factor = 0.0000001;
% -- factor is related to type, the program will ignore any cells with
% value count less than 'factor x n'

xy = sortrows([X, Y],1);
X = xy(:,1);
Y = xy(:,2);

div = min(X):(max(X)-min(X))/n:max(X);
%div = logspace(log10(min(X)),log10(max(X)),n+1);

s1 = max(size(X),[],'all');
for i = 1:n
    count = 1;
    index_list = [];
    for j = 1:s1
        if X(j)>=div(i) && X(j)<=div(i+1)
            index_list(count) = j;
            count = count + 1;
        end
    end
    if count < round(factor*s1) && type == 1 % For Field plots
        x_data(i,1) = NaN;
        avg_data(i,1) = NaN;
        std_data(i,1) = NaN;
    else
        x_data(i,1) = (div(i) + div(i+1))/2;
        avg_data(i,1) = mean(Y(index_list));
        std_data(i,1) = std(Y(index_list));
     end
end
data = [x_data,avg_data,std_data];
data = data((~isnan(data(:,1)) & ~isnan(data(:,2)) & ~isnan(data(:,3))),:);

% data clipping on X axis
data = data(data(:,1)>=X_lim(1),:);
data = data(data(:,1)<=X_lim(2),:);

x_data = data(:,1);
avg_data = data(:,2);
std_data = data(:,3);

avg_data = smooth(x_data,avg_data,n*sf);
std_data = smooth(x_data,std_data,n*sf);

end
