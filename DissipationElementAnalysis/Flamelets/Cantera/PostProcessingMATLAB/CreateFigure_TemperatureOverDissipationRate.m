clc
clear
close all


% ================================
% temperature over dissipation rate
% - for each inlet temperature
% - one inlet temperature refers to one flamelet
% OR
% - one strain rate refers to one flamelet
% ================================


%====
% INPUTS
%====
Data_path = '../OutputData/Flamelet_preheated_relevant_PassiveScalarMixtureFraction/Data/';
% folder contains 'relevant' -> max strain rate can be plotted for all Tin
quenching = false;
if contains(Data_path, 'relevant')
    quenching = true;
end
Fig_outpath = 'Figures/';
% colorbar variable: Tinlet if its true else strainrate
cbvar = true;
if cbvar
    ofname = 'TemperatureOverDissipationRate_Tinlet';
    % if multiple strain rates for one inlet temperature are given - use
    % sRate = -1 -> max strain rate for each inlet temperature
    sRate = -1;
else
    ofname = 'TemperatureOverDissipationRate_StrainRate';
    % if multiple inlet temperatures are given - use
    Tin = 1400;
end
% save figure in [png, eps, pdf]
FigFormat = 'png';
%====


% create output directory
if ~exist(Fig_outpath,'dir')
    mkdir(Fig_outpath);                                                                                                                                                                                                               
end


% get all csv files
csv_files = dir(fullfile(Data_path, '*.csv'));


% allocate memory
mat = [];
matrix = {};
sp_fname = split(csv_files(1).name, '.');
Tinlet = sp_fname{2};
a = sp_fname{3};
inletTemp = [str2double(Tinlet)];


% get data points
for i = 1:length(csv_files)
    sp_fname = split(csv_files(i).name, '.');
    Tinlet_ = sp_fname{2};
    a_ = sp_fname{3};
    if ~strcmp(Tinlet, Tinlet_) || i == length(csv_files)
        Tinlet = Tinlet_;
        if ~quenching
            if i ~= length(csv_files)
                inletTemp = [inletTemp, str2double(Tinlet_)];
            else
                mat = [mat, [str2double(Tinlet_), str2double(a_)]'];
            end
        else
            if i ~= length(csv_files)
                inletTemp = [inletTemp, str2double(Tinlet_)];
            elseif i == length(csv_files)
                matrix{end + 1} = mat;
                mat = [];
                mat = [mat, [str2double(Tinlet_), str2double(a_)]'];
            end
        end
        matrix{end + 1} = mat;
        mat = [];
    end
    mat = [mat, [str2double(Tinlet_), str2double(a_)]'];
end


% figure fonts
FZ = 22;
lw = 1;
set(0, 'defaultAxesFontName', 'Times');
set(0, 'DefaultFigureRenderer', 'painters');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex'); 
set(groot, 'defaultLegendInterpreter', 'latex');
set(0, 'defaultAxesFontSize', FZ);
set(0, 'DefaultLineLineWidth', lw);
set(0, 'defaultFigurePosition', [2 2 700 500]);
set(gca, 'TickLabelInterpreter', 'latex');
close


% create figure
close all
figure
t = tiledlayout(1,1);
t.TileSpacing = 'compact';
t.Padding = 'loose';
nexttile([1, 1]);
set(gcf,'color','w');


% length of colorbar
maxflag = false;
if cbvar
    % get strain rate case
    if sRate == -1
        if length(matrix{1}) ~= 2
            % if strain rate not in all inlet temp levels present
            % -> set to max strain rate wich is present in all levels
            a = cellfun(@(x) x(2, :), matrix, 'UniformOutput', false);
            comm = a{1};
            for k = 2:length(a)
                comm = intersect(comm, a{k});
            end
            sRate = max(comm);
            fprintf(['Maximum strain rate sRate was modified ' ...
                'to sRate = %d\n=>max strain rate of all input ' ...
                'files.\nUse the ' ...
                'Flamelet_preheated_relevant_PassiveScalarMixtureFraction' ...
                ' folder to create the figure with the max strain rate' ...
                ' for each case.'], sRate);
        else
            maxflag = true;
        end
    end
    % get relevant inlet temperature files
    if ~maxflag
        file_end = sprintf('.%03d.csv', sRate);
    else
        file_end = '.csv';
    end
    relevant_files = csv_files(endsWith({csv_files.name}, file_end));
    c = length(matrix);
    cmap = jet(c);
else
    % get relevant inlet temperature files
    file_start = strcat('Data_yiend.', sprintf('%04d', Tin));
    relevant_files = csv_files(startsWith({csv_files.name}, file_start));
    c_ = find(inletTemp == Tin);
    c = length(matrix{c_});
    cmap = jet(c);
    caxis_min = matrix{c_}(2,1);
    caxis_max = matrix{c_}(2,end);
end


for i = 1:c
    flamelet_data = readtable(strcat(Data_path, ...
        relevant_files(i).name), 'Delimiter', '\t', ...
        'PreserveVariableNames', true);
    xdata = flamelet_data.chi;
    ydata = flamelet_data.Temp;
    plot(xdata, ydata, '-', 'LineWidth', lw+1, 'Marker', 'x', ...
        'Color', cmap(i,:), 'HandleVisibility', 'off');
    hold on
end


% colorbar
colormap(cmap);
cb = colorbar('eastoutside');
cb.TickLabelInterpreter = 'latex';
if cbvar
    caxis([250 1550]); % Ticks in the center
    cb.Ticks = [300, 600, 900, 1200, 1500];
    ylabel(cb, '$T_\mathrm{inlet} \mathrm{[K]}$', 'fontsize', FZ, ...
        'interpreter', 'latex', 'FontWeight', 'bold')
else
    % Ticks in the center
    caxis_min_ = caxis_min - 0.5;
    caxis_max_ = caxis_max + 0.5;
    caxis([caxis_min_ caxis_max_]);
    ticks = round(linspace(caxis_min, caxis_max, 6));
    cb.Ticks = ticks;
    ylabel(cb, '$a \mathrm{[1/s]}$', 'fontsize', FZ, ...
        'interpreter', 'latex', 'FontWeight', 'bold')
end


% axis limits
%xlim([0 30000]);
%ylim([0 2500]);


% ticks modification
%xtick_positions = linspace(0, 30000, 4);
%set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
%ytick_positions = linspace(0, 2500, 6);
%set(gca, 'YTick', ytick_positions, 'LineWidth', lw);


% labels and legend
xlabel('$\chi\mathrm{[1/s]}$', 'fontsize', FZ, ...
        'interpreter', 'latex', 'FontWeight', 'bold');
ylabel('$T_\mathrm{gas} \mathrm{[K]}$', 'fontsize', FZ, ...
    'interpreter', 'latex', 'FontWeight', 'bold');
legend('show', 'Interpreter', 'latex', 'Location', 'northwest', ...
    'Box', 'off', 'fontsize', FZ);


% format
set(gca, 'Box', 'on');


% figure name
if cbvar
    if sRate ~= -1
        ofname = strcat(ofname, '_a', sprintf('%03d', sRate));
    else
        ofname = strcat(ofname, '_amax');
    end
else
    ofname = strcat(ofname, '_Tin', sprintf('%04d', Tin));
end
outfname = strcat(Fig_outpath, ofname);


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
