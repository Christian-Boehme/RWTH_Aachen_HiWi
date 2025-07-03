clc
clear
close all
addpath('~/NHR/DE_Analysis/MatlabFunctions');


% ================================
% gradient over dissipation rate - DNS data
% Dissipation elements with Zst
% -> Use i.e. DEGridpointsAll_ign.csv to plot all dissipation elements
% ================================


%====
% INPUTS
%====
hdf5_data_path = ['~/itv/OXYFLAME-B3/File_Transfer/DE_analysis_code/' ...
    'trajSearch/Dataset'];
cases= {'traj_Tbox_ign.h5', 'traj_Tbox_OHmax.h5', ...
    'traj_Tbox_fullComb.h5', 'traj_Tbox_finish.h5'};
Fig_outpath = '../../Figures/DNS_DataBased/';
Data_path = '../../PostProcessedData/';
FlameletData = 'QuenchingData_FlameletsNicolai.csv';
DE_InputFiles = {'DEGridpointsZst_ign.csv', ...
    'DEGridpointsZst_OHmax.csv', ...
    'DEGridpointsZst_fullComb.csv',...
    'DEGridpointsZst_final.csv'};
header = {'t=0.50ms', 't=0.65ms', 't=0.75ms', 't=1.00ms'};
ofname = 'GradientOverDissipationRate';
n_bins = 50;
sf = 0.01;
factor= 2e-5;
% cell size DNS
dx = 5E-5;
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


% total number of cases
tc = length(cases);


% global fonts
FZ = 22;
lw = 1;
set(0, 'defaultAxesFontName', 'Times');
set(0, 'DefaultFigureRenderer', 'painters');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex'); 
set(groot, 'defaultLegendInterpreter', 'latex');
set(0, 'defaultAxesFontSize', FZ);
set(0, 'DefaultLineLineWidth', lw);
set(0, 'defaultFigurePosition', [2 2 800 800]);
set(gca, 'TickLabelInterpreter', 'latex');
close


% read data
chi = cell(1,tc);
edata_dble = cell(1,tc);
for i = 1:length(cases)
    % scalar dissipation rate
    chi{i} = h5read(strcat(hdf5_data_path ,'/', cases{i}), ...
        '/scalar/dissp_rate');
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
for i = 1:length(cases)
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
matrix = {};
for i = 1:3 %length(cases)
    % full path
    Data_path_ = strcat(Data_path, DE_InputFiles{i});

    % read the csv file
    data = readmatrix(Data_path_);
    
    % number of dissipation elements
    [~, num_columns] = size(data);
    DE_Zst = num_columns;

    % allocate memory
    mat = [];

    for j = 1:DE_Zst
        % extract data
        [DE_id, x_coords, y_coords, z_coords] = DE_GetGridPoints( ...
            data(:,j));

        % get corresponding data points
        chi_ = DE_ExtractData(chi{i}, x_coords, y_coords, z_coords);
        
        % maximum points
        chi_ = max(chi_);

        % gradient of dissipation element
        DE_g = g{i}(DE_id);

        % store data in matrix
        mat = [mat, [DE_id, chi_, DE_g]'];
    end
    matrix{end + 1} = mat;
end


%% create figure
set(0,'defaultFigurePosition', [2 2 1800, 500])
%close all
figure(1)
tl = tiledlayout(1, 3, 'Padding', 'compact', 'TileSpacing', 'compact');

% 1st figure
set(gcf,'color','w');
ax(1) = nexttile(1);
hold on
box on

x = matrix{1}(2,:);
y = matrix{1}(3,:);
XData = squeeze(x(:));
YData = squeeze(y(:));
ZData = squeeze(x(:));

[x1,x2,cond_mean ] = ComputeConditionalMeanHistograms2D(ZData, XData, ...
    YData, n_bins);
s=imagesc(x1,x2,cond_mean);
set(s, 'AlphaData', ~isnan(cond_mean));
set(gca,'YDir','normal');

% [x1_data, avg_data] = CellDataAvg(XData, YData, n_bins, ...
%     [min(XData) max(XData)], 1, sf, factor);
% c_max = max(size(XData),[],'all');
% z_dir = zeros(size(x1_data,1),1)+c_max+1;
% plot3(x1_data,avg_data,z_dir,'k','LineWidth', lw);
% [PDF_x1, PDF_x2, PDF_y] = ComputeConditionalMeanHistograms2D(XData, ...
%     YData, n_bins);
% PDF_y = log10(PDF_y);
% s = imagesc(PDF_x1, PDF_x2, PDF_y);
% set(s, 'AlphaData', ~isnan(PDF_y));
% set(gca, 'YDir', 'normal');

format long
hold on
grid off
ylabel('$g$ ','Interpreter','latex','fontsize',FZ)
xlabel('$\chi$','Interpreter','latex','fontsize',FZ)
title(header{1}, 'Interpreter', 'latex', 'FontSize', FZ-2)
set(gca,'XMinorTick','on','YMinorTick','on')
hold off


% 2nd figure
set(gcf,'color','w');
ax(2) = nexttile(2);
hold on
box on

x = matrix{2}(2,:);
y = matrix{2}(3,:);
XData = squeeze(x(:));
YData = squeeze(y(:));
ZData = squeeze(x(:));

[x1,x2,cond_mean ] = ComputeConditionalMeanHistograms2D(ZData, XData, ...
    YData, n_bins);
s=imagesc(x1,x2,cond_mean);
set(s, 'AlphaData', ~isnan(cond_mean));
set(gca,'YDir','normal');

% [x1_data, avg_data] = CellDataAvg(XData, YData, n_bins, ...
%     [min(XData) max(XData)], 1, sf, factor);
% c_max = max(size(XData),[],'all');
% z_dir = zeros(size(x1_data,1),1)+c_max+1;
% plot3(x1_data,avg_data,z_dir,'k','LineWidth', lw);
% [PDF_x1, PDF_x2, PDF_y] = ComputeConditionalMeanHistograms2D(XData, ...
%     YData, n_bins);
% PDF_y = log10(PDF_y);
% s = imagesc(PDF_x1, PDF_x2, PDF_y);
% set(s, 'AlphaData', ~isnan(PDF_y));
% set(gca, 'YDir', 'normal');

format long
hold on
grid off
ylabel('$g$ ','Interpreter','latex','fontsize',FZ)
xlabel('$\chi$','Interpreter','latex','fontsize',FZ)
title(header{2}, 'Interpreter', 'latex', 'FontSize', FZ-2)
set(gca,'XMinorTick','on','YMinorTick','on')
hold off


% 3rd figure
set(gcf,'color','w');
ax(3) = nexttile(3);
hold on
box on

x = matrix{3}(2,:);
y = matrix{3}(3,:);
XData = squeeze(x(:));
YData = squeeze(y(:));
ZData = squeeze(x(:));
[x1,x2,cond_mean ] = ComputeConditionalMeanHistograms2D(ZData, XData, ...
    YData, n_bins);
s=imagesc(x1,x2,cond_mean);
set(s, 'AlphaData', ~isnan(cond_mean));
set(gca,'YDir','normal');

% XData = squeeze(CHI(:));
% YData = squeeze(G(:));
% [x1_data, avg_data] = CellDataAvg(XData, YData, n_bins, ...
%     [min(XData) max(XData)], 1, sf, factor);
% c_max = max(size(XData),[],'all');
% z_dir = zeros(size(x1_data,1),1)+c_max+1;
% plot3(x1_data,avg_data,z_dir,'k','LineWidth', lw);
% [PDF_x1, PDF_x2, PDF_y] = ComputeConditionalMeanHistograms2D(XData, ...
%     YData, n_bins);
% PDF_y = log10(PDF_y);
% s = imagesc(PDF_x1, PDF_x2, PDF_y);
% set(s, 'AlphaData', ~isnan(PDF_y));
% set(gca, 'YDir', 'normal');

format long
hold on
grid off
ylabel('$g$ ','Interpreter','latex','fontsize',FZ)
xlabel('$\chi$','Interpreter','latex','fontsize',FZ)
title(header{3}, 'Interpreter', 'latex', 'FontSize', FZ-2)
set(gca,'XMinorTick','on','YMinorTick','on')
hold off

% % 4th figure
% set(gcf,'color','w');
% ax(4) = nexttile(4);
% hold on
% box on
% 
% CHI = matrix{4}(2,:);
% G = matrix{4}(3,:);
% XData = squeeze(CHI(:));
% YData = squeeze(G(:));
% [x1_data, avg_data] = CellDataAvg(XData, YData, n_bins, ...
%     [min(XData) max(XData)], 1, sf, factor);
% c_max = max(size(XData),[],'all');
% z_dir = zeros(size(x1_data,1),1)+c_max+1;
% plot3(x1_data,avg_data,z_dir,'k','LineWidth', lw);
% [PDF_x1, PDF_x2, PDF_y] = ComputeConditionalMeanHistograms2D(XData, ...
%     YData, n_bins);
% PDF_y = log10(PDF_y);
% s = imagesc(PDF_x1, PDF_x2, PDF_y);
% set(s, 'AlphaData', ~isnan(PDF_y));
% set(gca, 'YDir', 'normal');
% 
% format long
% hold on
% grid off
% ylabel('$g$ ','Interpreter','latex','fontsize',FZ)
% xlabel('$\chi$','Interpreter','latex','fontsize',FZ)
% title(header{4}, 'Interpreter', 'latex', 'FontSize', FZ-2)
% set(gca,'XMinorTick','on','YMinorTick','on')
% hold off


% Set colormap and color limits for all subplots
set(ax, 'Colormap', jet)
% assign color bar to one tile 
cbh = colorbar(ax(end)); 
% To position the colorbar as a global colorbar representing
% all tiles, 
cbh.Layout.Tile = 'south'; 
set(cbh,'TickLabelInterpreter','latex');
ylabel(cbh, '$\chi$','fontsize',FZ,'interpreter','latex')
%ylim(ax,[0 7])
%xlim(ax,[0 4])
% Adjust figure properties for tight fitting
set(gcf, 'PaperPositionMode', 'auto');
%set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02))
%saveas(figure(1),strcat(Fig_outname,'joint_norm_g.png'));


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
