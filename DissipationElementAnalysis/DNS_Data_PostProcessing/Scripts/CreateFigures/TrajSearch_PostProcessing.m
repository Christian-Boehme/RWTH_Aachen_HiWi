clc
clear all
close all


% ================================
% trajectory search - postprocessing (use "Run and Advance" option)
% -> Figure 1 => row 125: Zmix 2D box plot + Zmix isocontour lines
% -> Figure 2 => row 224: YOH  2D box plot + Zmix isocontour lines
% -> Figure 3 => row 324: Tgas 2D box plot + Zmix isocontour lines
% -> Figure 4 => row 433: marginal pdf l
% -> Figure 5 => row 461: marginal pdf l - log-yaxis
% -> Figure 6 => row 490: marginal pdf l/lm
% -> Figure 7 => row 517: marginal pdf l/lm - log-yaxis
% -> Figure 8 => row 546: marginal pdf phi
% -> Figure 9 => row 574: marginal pdf phi - log-yaxis
% -> Figure 10 => row 603: marginal pdf phi/phim
% -> Figure 11 => row 632: marginal pdf phi/phim - log-yaxis
% -> Figure 12 => row 663: marginal pdf g
% -> Figure 13 => row 691: marginal pdf g - log-yaxis
% -> Figure 14 => row 720: marginal pdf g/gm
% -> Figure 15 => row 749: marginal pdf g/gm - log-yaxis
% -> Figure 16 => row 780: marginal pdf T                           TODO
% -> Figure 17 => row 781: marginal pdf T - log-yaxis               TODO
% -> Figure 18 => row 782: marginal pdf T/Tm                        TODO
% -> Figure 19 => row 783: marginal pdf T/Tm - log-yaxis            TODO
% -> Figure 20 => row 786: lm over eta
% -> Figure 21 => row 808: JPDF phi over l
% -> Figure 22 => row 956: JPDF phinorm over lnorm
% -> Figure 24 => row 1104: JPDF g over l
% -> Figure 24 => row 1252: JPDF gnorm over lnorm
% -> Figure 25 => row 1400: JPDF phi over g
% -> Figure 26 => row 1548: JPDF phinorm over gnorm
% -> Figure 27 => row 1696: JPDF T over l                           TODO
% -> Figure 28 => row 1697: JPDF Tnorm over lnorm                   TODO
% ================================


%=====
% Inputs
%=====
sim_folder= ['~/itv/OXYFLAME-B3/File_Transfer/DE_analysis_code/' ...
    'trajSearch/Dataset'];
save_folder=['~/NHR/DE_Analysis/DNS_Data_PostProcessing/Figures/' ...
    'TrajSearch_PostProcessing'];
cases= {'traj_Tbox_ign.h5', 'traj_Tbox_OHmax.h5', ...
    'traj_Tbox_fullComb.h5', 'traj_Tbox_finish.h5'};
dx = 50e-6;
timestr = {'t=0.50ms', 't=0.65ms', 't=0.75ms', 't=1.00ms'};
Z_st = 0.117;
SubFolder = {'AllResults/', 'Bode2017/', 'Denker2020/', ...
    'Niemietz2024/'};
% save figure in [png, eps, pdf]
FigFormat = 'png';
%=====


% create output directory
if sim_folder(end) ~= '/'
    sim_folder = [sim_folder, '/'];
end
if save_folder(end) ~= '/'
    save_folder = [save_folder, '/'];
end
if ~exist(save_folder, 'dir')
    mkdir(save_folder);
end
for i = 1:length(SubFolder)
    if SubFolder{i}(end) ~= '/'
        SubFolder{i} = [SubFolder{i}, '/'];
    end
end
for i = 1:length(SubFolder)
    if ~exist(strcat(save_folder, SubFolder{i}), 'dir')
        mkdir(strcat(save_folder, SubFolder{i}));
    end
end


% figure settings
FZ = 22;
per = 0.1;
lw = 1.5;
sf = 0.05;
set(0,'defaultAxesFontName','Times');
set(0, 'DefaultFigureRenderer', 'painters');
set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
set(groot, 'defaultLegendInterpreter','latex');
set(0,'defaultAxesFontSize',FZ);
set(0, 'DefaultLineLineWidth', lw);
set(0,'defaultFigurePosition', [2 2 800, 800])


% get data
for i = 1:length(cases)
    Zmix{i} = h5read(strcat(sim_folder ,'/', cases{i}), ...
        '/scalar/ZMIX');
    YOH{i} = h5read(strcat(sim_folder ,'/', cases{i}), ...
        '/scalar/OH');
    Tgas{i} = h5read(strcat(sim_folder ,'/', cases{i}), ...
        '/scalar/T');
    Lambda{i} = h5read(strcat(sim_folder ,'/', cases{i}), ...
        '/scalar/lambda_field');
    Rho{i} = h5read(strcat(sim_folder ,'/', cases{i}), ...
        '/scalar/RHO');
    Cp{i} = h5read(strcat(sim_folder ,'/', cases{i}), ...
        '/scalar/Cp_field');
    Dissip{i} = h5read(strcat(sim_folder ,'/', cases{i}), ...
        '/scalar/dissp_rate');
    ecount{i} = h5read(strcat(sim_folder ,'/', cases{i}), ...
        '/traj_full/ecount');
    edata_dble{i} = h5read(strcat(sim_folder ,'/', cases{i}), ...
        '/traj_full/edata_dble');
    edata_int{i} = h5read(strcat(sim_folder ,'/', cases{i}), ...
        '/traj_full/edata_int');
    egpts{i} = h5read(strcat(sim_folder ,'/', cases{i}), ...
        '/traj_full/egpts');
    eid{i} = h5read(strcat(sim_folder ,'/', cases{i}), ...
        '/traj_full/eid');
    maxcount{i} = h5read(strcat(sim_folder ,'/', cases{i}), ...
        '/traj_full/maxcount');
    mincount{i} = h5read(strcat(sim_folder ,'/', cases{i}), ...
        '/traj_full/mincount');
    minmax_coords{i} = h5read(strcat(sim_folder ,'/', cases{i}), ...
        '/traj_full/minmax_coords');
    minmax_pos{i} = h5read(strcat(sim_folder ,'/', cases{i}), ...
        '/traj_full/minmax_pos');
    minmax_type{i} = h5read(strcat(sim_folder ,'/', cases{i}), ...
        '/traj_full/minmax_type');
    minmax_val{i} = h5read(strcat(sim_folder ,'/', cases{i}), ...
        '/traj_full/minmax_val');
end


% calculate DE parameters
for i = 1:length(cases)
    l{i}=edata_dble{i}(7,:);
    lm{i}=mean(edata_dble{i}(7,:));
    ln{i}=l{i}./lm{i};
    phi{i}=edata_dble{i}(10,:);
    phim{i}=mean(edata_dble{i}(10,:));
    phin{i}=phi{i}./phim{i};
    g{i} = phi{i}./l{i};
    gm{i} = mean(phi{i}./l{i});
    gn{i} = (phi{i}./phim{i})./(l{i}./lm{i});
end


%% Zmix 2D box plot - isocontour
set(0,'defaultFigurePosition', [2 2 1800, 500])
close all
figure(1)

% format
tl = tiledlayout(1,4, 'Padding', 'compact', 'TileSpacing', 'compact');
tl.TileSpacing = 'compact';

% sub-figure 1
set(gcf,'color','w');
ax(1) = nexttile(1);
s1=pcolor(ax(1),squeeze(Zmix{1}(:,:,128)));
s1.FaceColor = 'interp';
set(s1,'edgecolor','none');
set(gca,'YDir','reverse');
axis image
hold on;
contour(Zmix{1}(:,:,128), Z_st-0.001:0.001:Z_st+0.001, 'k');
set(gca,'xtick',[])
set(gca,'ytick',[])
set(gca,'TickLabelInterpreter','latex');
%cb1=colorbar('westoutside'); 
%set(cb1,'TickLabelInterpreter','latex');
title(ax(1),timestr{1}, 'Interpreter', 'latex', 'FontSize', FZ)

% sub-figure 2
set(gcf,'color','w');
ax(2) = nexttile(2);
s1=pcolor(ax(2),squeeze(Zmix{2}(:,:,128)));
s1.FaceColor = 'interp';
set(s1,'edgecolor','none');
set(gca,'YDir','reverse');
axis image
hold on;
contour(Zmix{2}(:,:,128), Z_st-0.001:0.001:Z_st+0.001, 'k');
set(gca,'xtick',[])
set(gca,'ytick',[])
set(gca,'TickLabelInterpreter','latex');
%cb1=colorbar('westoutside'); 
%set(cb1,'TickLabelInterpreter','latex');
title(ax(2),timestr{2}, 'Interpreter', 'latex', 'FontSize', FZ)

% sub-figure 3
set(gcf,'color','w');
ax(3) = nexttile(3);
s1=pcolor(ax(3),squeeze(Zmix{3}(:,:,128)));
s1.FaceColor = 'interp';
set(s1,'edgecolor','none');
set(gca,'YDir','reverse');
axis image
hold on;
contour(Zmix{3}(:,:,128), Z_st-0.001:0.001:Z_st+0.001, 'k');
set(gca,'xtick',[])
set(gca,'ytick',[])
set(gca,'TickLabelInterpreter','latex');
%cb1=colorbar('westoutside'); 
%set(cb1,'TickLabelInterpreter','latex');
title(ax(3),timestr{3}, 'Interpreter', 'latex', 'FontSize', FZ)

% sub-figure 4
set(gcf,'color','w');
ax(4) = nexttile(4);
s1=pcolor(ax(4),squeeze(Zmix{4}(:,:,128)));
s1.FaceColor = 'interp';
set(s1,'edgecolor','none');
set(gca,'YDir','reverse');
axis image
hold on;
contour(Zmix{4}(:,:,128), Z_st-0.001:0.001:Z_st+0.001, 'k');
set(gca,'xtick',[])
set(gca,'ytick',[])
set(gca,'TickLabelInterpreter','latex');
%cb1=colorbar('westoutside'); 
%set(cb1,'TickLabelInterpreter','latex');
title(ax(4),timestr{4}, 'Interpreter', 'latex', 'FontSize', FZ)

% Set colormap and color limits for all subplots
max_fig_1 = max(YOH{1}(:,:,128));
max_fig_2 = max(YOH{2}(:,:,128));
max_fig_3 = max(YOH{3}(:,:,128));
max_fig_4 = max(YOH{4}(:,:,128));
upLim = max([max_fig_1, max_fig_2, max_fig_3, max_fig_4]);
fprintf('Upper limit for Z = %e\n', upLim);
set(ax, 'Colormap', jet, 'CLim', [0 0.14])
% assign color bar to one tile 
cbh = colorbar(ax(end)); 
% To position the colorbar as a global colorbar representing
% all tiles, 
cbh.Layout.Tile = 'south'; 
set(cbh,'TickLabelInterpreter','latex');
ylabel(cbh, '$Z$ [-]','fontsize',FZ,'interpreter','latex')
% Adjust figure properties for tight fitting
set(gcf, 'PaperPositionMode', 'auto');
%set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02))
% save figure
%saveas(figure(1),strcat(save_folder,'Zmix_isocontour.png'));
% save figure
outfname = strcat(save_folder, SubFolder{1}, 'Zmix_isocontour');
if strcmp(FigFormat, 'png')
    saveas(figure(1), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(1), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(1), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end


%% YOH 2D box plot - isocontour
set(0,'defaultFigurePosition', [2 2 1800, 500])
close all
figure(2)

% format
tl = tiledlayout(1,4, 'Padding', 'compact', 'TileSpacing', 'compact');
tl.TileSpacing = 'compact';

% sub-figure 1
set(gcf,'color','w');
ax(1) = nexttile(1);
s1=pcolor(ax(1),squeeze(YOH{1}(:,:,128)));
s1.FaceColor = 'interp';
set(s1,'edgecolor','none');
set(gca,'YDir','reverse');
axis image
hold on;
contour(Zmix{1}(:,:,128), Z_st-0.001:0.001:Z_st+0.001, 'k');
set(gca,'xtick',[])
set(gca,'ytick',[])
set(gca,'TickLabelInterpreter','latex');
%cb1=colorbar('westoutside'); 
%set(cb1,'TickLabelInterpreter','latex');
title(ax(1),timestr{1}, 'Interpreter', 'latex', 'FontSize', FZ)

% sub-figure 2
set(gcf,'color','w');
ax(2) = nexttile(2);
s1=pcolor(ax(2),squeeze(YOH{2}(:,:,128)));
s1.FaceColor = 'interp';
set(s1,'edgecolor','none');
set(gca,'YDir','reverse');
axis image
hold on;
contour(Zmix{2}(:,:,128), Z_st-0.001:0.001:Z_st+0.001, 'k');
set(gca,'xtick',[])
set(gca,'ytick',[])
set(gca,'TickLabelInterpreter','latex');
%cb1=colorbar('westoutside'); 
%set(cb1,'TickLabelInterpreter','latex');
title(ax(2),timestr{2}, 'Interpreter', 'latex', 'FontSize', FZ)

% sub-figure 3
set(gcf,'color','w');
ax(3) = nexttile(3);
s1=pcolor(ax(3),squeeze(YOH{3}(:,:,128)));
s1.FaceColor = 'interp';
set(s1,'edgecolor','none');
set(gca,'YDir','reverse');
axis image
hold on;
contour(Zmix{3}(:,:,128), Z_st-0.001:0.001:Z_st+0.001, 'k');
set(gca,'xtick',[])
set(gca,'ytick',[])
set(gca,'TickLabelInterpreter','latex');
%cb1=colorbar('westoutside'); 
%set(cb1,'TickLabelInterpreter','latex');
title(ax(3),timestr{3}, 'Interpreter', 'latex', 'FontSize', FZ)

% sub-figure 4
set(gcf,'color','w');
ax(4) = nexttile(4);
s1=pcolor(ax(4),squeeze(YOH{4}(:,:,128)));
s1.FaceColor = 'interp';
set(s1,'edgecolor','none');
set(gca,'YDir','reverse');
axis image
hold on;
contour(Zmix{4}(:,:,128), Z_st-0.001:0.001:Z_st+0.001, 'k');
set(gca,'xtick',[])
set(gca,'ytick',[])
set(gca,'TickLabelInterpreter','latex');
%cb1=colorbar('westoutside'); 
%set(cb1,'TickLabelInterpreter','latex');
title(ax(4),timestr{4}, 'Interpreter', 'latex', 'FontSize', FZ)

% Set colormap and color limits for all subplots
max_fig_1 = max(YOH{1}(:,:,128));
max_fig_2 = max(YOH{2}(:,:,128));
max_fig_3 = max(YOH{3}(:,:,128));
max_fig_4 = max(YOH{4}(:,:,128));
upLim = max([max_fig_1, max_fig_2, max_fig_3, max_fig_4]);
fprintf('Upper limit for YOH = %e\n', upLim);
set(ax, 'Colormap', jet, 'CLim', [0 0.014])
% assign color bar to one tile 
cbh = colorbar(ax(end)); 
% To position the colorbar as a global colorbar representing
% all tiles, 
cbh.Layout.Tile = 'south'; 
set(cbh,'TickLabelInterpreter','latex');
ylabel(cbh, '$Y_\mathrm{OH}$ [-]','fontsize',FZ,'interpreter','latex')
% Adjust figure properties for tight fitting
set(gcf, 'PaperPositionMode', 'auto');
%set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02))
% save figure
%saveas(figure(2),strcat(save_folder,'YOH_isocontour.png'));
% save figure
outfname = strcat(save_folder, SubFolder{1}, 'YOH_isocontour');
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


%% Tgas 2D box plot - isocontour
set(0,'defaultFigurePosition', [2 2 1800, 500])
close all
figure(3)

% format
tl = tiledlayout(1,4, 'Padding', 'compact', 'TileSpacing', 'compact');
tl.TileSpacing = 'compact';

% sub-figure 1
set(gcf,'color','w');
ax(1) = nexttile(1);
s1=pcolor(ax(1),squeeze(Tgas{1}(:,:,128)));
s1.FaceColor = 'interp';
set(s1,'edgecolor','none');
set(gca,'YDir','reverse');
axis image
hold on;
contour(Zmix{1}(:,:,128), Z_st-0.001:0.001:Z_st+0.001, 'k');
set(gca,'xtick',[])
set(gca,'ytick',[])
set(gca,'TickLabelInterpreter','latex');
%cb1=colorbar('westoutside'); 
%set(cb1,'TickLabelInterpreter','latex');
title(ax(1),timestr{1}, 'Interpreter', 'latex', 'FontSize', FZ)

% sub-figure 2
set(gcf,'color','w');
ax(2) = nexttile(2);
s1=pcolor(ax(2),squeeze(Tgas{2}(:,:,128)));
s1.FaceColor = 'interp';
set(s1,'edgecolor','none');
set(gca,'YDir','reverse');
axis image
hold on;
contour(Zmix{2}(:,:,128), Z_st-0.001:0.001:Z_st+0.001, 'k');
set(gca,'xtick',[])
set(gca,'ytick',[])
set(gca,'TickLabelInterpreter','latex');
%cb1=colorbar('westoutside'); 
%set(cb1,'TickLabelInterpreter','latex');
title(ax(2),timestr{2}, 'Interpreter', 'latex', 'FontSize', FZ)

% sub-figure 3
set(gcf,'color','w');
ax(3) = nexttile(3);
s1=pcolor(ax(3),squeeze(Tgas{3}(:,:,128)));
s1.FaceColor = 'interp';
set(s1,'edgecolor','none');
set(gca,'YDir','reverse');
axis image
hold on;
contour(Zmix{3}(:,:,128), Z_st-0.001:0.001:Z_st+0.001, 'k');
set(gca,'xtick',[])
set(gca,'ytick',[])
set(gca,'TickLabelInterpreter','latex');
%cb1=colorbar('westoutside'); 
%set(cb1,'TickLabelInterpreter','latex');
title(ax(3),timestr{3}, 'Interpreter', 'latex', 'FontSize', FZ)

% sub-figure 4
set(gcf,'color','w');
ax(4) = nexttile(4);
s1=pcolor(ax(4),squeeze(Tgas{4}(:,:,128)));
s1.FaceColor = 'interp';
set(s1,'edgecolor','none');
set(gca,'YDir','reverse');
axis image
hold on;
contour(Zmix{4}(:,:,128), Z_st-0.001:0.001:Z_st+0.001, 'k');
set(gca,'xtick',[])
set(gca,'ytick',[])
set(gca,'TickLabelInterpreter','latex');
%cb1=colorbar('westoutside'); 
%set(cb1,'TickLabelInterpreter','latex');
title(ax(4),timestr{4}, 'Interpreter', 'latex', 'FontSize', FZ)

% Set colormap and color limits for all subplots
max_fig_1 = max(Tgas{1}(:,:,128));
max_fig_2 = max(Tgas{2}(:,:,128));
max_fig_3 = max(Tgas{3}(:,:,128));
max_fig_4 = max(Tgas{4}(:,:,128));
upLim = max([max_fig_1, max_fig_2, max_fig_3, max_fig_4]);
fprintf('Upper limit for Tgas = %e\n', upLim);
set(ax, 'Colormap', jet, 'CLim', [0 2500])
% assign color bar to one tile 
cbh = colorbar(ax(end)); 
% To position the colorbar as a global colorbar representing
% all tiles, 
cbh.Layout.Tile = 'south'; 
set(cbh,'TickLabelInterpreter','latex');
ylabel(cbh, '$T_\mathrm{gas}$ [K]','fontsize',FZ,'interpreter','latex')
% Adjust figure properties for tight fitting
set(gcf, 'PaperPositionMode', 'auto');
%set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02))
% save figure
%saveas(figure(3),strcat(save_folder,'Tgas_isocontour.png'));
% save figure
outfname = strcat(save_folder, SubFolder{1}, 'Tgas_isocontour');
if strcmp(FigFormat, 'png')
    saveas(figure(3), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(3), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(3), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end


%% marginal PDF l
set(0,'defaultFigurePosition', [2 2 600, 500])
close all
n_bins = 100;
for i = 1:length(cases)
    h{i} = histogram(l{i}, n_bins);
    binCenters{i} = h{i}.BinEdges; %+ (h.BinWidth/2);
end
close all
figure(4)
set(gcf,'color','w');
for i = 1:length(cases)
    p{i} = histcounts(l{i}, n_bins, 'Normalization', 'pdf');
    plot(binCenters{i}(1:end-1), p{i}./trapz(p{i}))
    legend(timestr)
    hold on
end
xlabel('$l$', 'Interpreter', 'latex', 'fontsize',FZ)
ylabel('$P(l)$', 'Interpreter',' latex', 'fontsize',FZ)
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on')
set(legend, 'Box', 'off')
xmax = 120;
xlim([0 xmax]);
xtick_positions = linspace(0, xmax, 5);
set(gca, 'XTick', xtick_positions, 'LineWidth', lw-1);
%saveas(figure(4), strcat(save_folder, 'MarginalPDF_l.png'));
% save figure
outfname = strcat(save_folder, SubFolder{1}, 'MarginalPDF_l');
if strcmp(FigFormat, 'png')
    saveas(figure(4), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(4), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(4), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end


%% marginal PDF l log-yaxis
set(0,'defaultFigurePosition', [2 2 600, 500])
close all
n_bins = 100;
for i = 1:length(cases)
    h{i} = histogram(l{i}, n_bins);
    binCenters{i} = h{i}.BinEdges ;%+ (h.BinWidth/2);
end
close all
figure(5)
set(gcf,'color','w');
for i = 1:length(cases)
    p{i} = histcounts(l{i}, n_bins, 'Normalization', 'pdf');
    plot(binCenters{i}(1:end-1), p{i}./trapz(p{i}))
    legend(timestr)
    hold on
end
xlabel('$l$', 'Interpreter', 'latex', 'fontsize', FZ)
ylabel('$P(l)$', 'Interpreter','latex', 'fontsize', FZ)
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on')
set(gca, 'YScale', 'log')
set(legend, 'Box', 'off')
xmax = 120;
xlim([0 xmax]);
xtick_positions = linspace(0, xmax, 5);
set(gca, 'XTick', xtick_positions, 'LineWidth', lw-1);
%saveas(figure(5), strcat(save_folder, 'MarginalPDF_l_log.png'));
% save figure
outfname = strcat(save_folder, SubFolder{1}, 'MarginalPDF_l_log');
if strcmp(FigFormat, 'png')
    saveas(figure(5), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(5), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(5), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end


%% marginal pdf l/lm
set(0,'defaultFigurePosition', [2 2 600, 500])
close all
n_bins = 100;
for i = 1:length(cases)
    h{i} = histogram(l{i}/lm{i}, n_bins);
    binCenters{i} = h{i}.BinEdges ;%+ (h.BinWidth/2);
end
figure(6)
set(gcf,'color','w');
for i = 1:length(cases)
    p{i} = histcounts(l{i}/lm{i}, n_bins, 'Normalization', 'pdf');
    plot(binCenters{i}(1:end-1), p{i}./trapz(p{i}))
    legend(timestr)
    hold on
end
xlabel('$l/l_\mathrm{m}$', 'Interpreter', 'latex', 'fontsize', FZ)
ylabel('$P(l/l_\mathrm{m})$', 'Interpreter', 'latex', 'fontsize', FZ)
set(gca, 'XMinorTick', 'on', 'YMinorTick','on')
set(legend, 'Box', 'off')
xmax = 4;
xlim([0 xmax]);
xtick_positions = linspace(0, xmax, 5);
set(gca, 'XTick', xtick_positions, 'LineWidth', lw-1);
%saveas(figure(6), strcat(save_folder, 'MarginalPDF_lnorm.png'));
% save figure
outfname = strcat(save_folder, SubFolder{1}, 'MarginalPDF_lnorm');
if strcmp(FigFormat, 'png')
    saveas(figure(6), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(6), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(6), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end
% save figure - Bode 2017
outfname = strcat(save_folder, SubFolder{2}, 'BodeFigure5a');
if strcmp(FigFormat, 'png')
    saveas(figure(6), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(6), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(6), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end
% save figure - Denker 2020
outfname = strcat(save_folder, SubFolder{3}, 'DenkerFigure8a');
if strcmp(FigFormat, 'png')
    saveas(figure(6), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(6), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(6), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end
% save figure - Niemietz 2024
outfname = strcat(save_folder, SubFolder{4}, 'NiemietzFigure2a');
if strcmp(FigFormat, 'png')
    saveas(figure(6), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(6), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(6), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end


%% marginal pdf l/lm - log-yaxis
set(0,'defaultFigurePosition', [2 2 600, 500])
close all
n_bins = 100;
for i = 1:length(cases)
    h{i} = histogram(l{i}/lm{i}, n_bins);
    binCenters{i} = h{i}.BinEdges ;%+ (h.BinWidth/2);
end
close all
figure(7)
set(gcf,'color','w');
for i = 1:length(cases)
    p{i} = histcounts(l{i}/lm{i}, n_bins, 'Normalization', 'pdf');
    plot(binCenters{i}(1:end-1), p{i}./trapz(p{i}))
    legend(timestr)
    hold on
end
xlabel('$l/l_\mathrm{m}$', 'Interpreter', 'latex', 'fontsize', FZ)
ylabel('$P(l/l_\mathrm{m})$', 'Interpreter', 'latex', 'fontsize', FZ)
set(gca,'XMinorTick', 'on', 'YMinorTick', 'on')
set(gca, 'YScale', 'log')
set(legend, 'Box', 'off')
xmax = 4;
xlim([0 xmax]);
xtick_positions = linspace(0, xmax, 5);
set(gca, 'XTick', xtick_positions, 'LineWidth', lw-1);
%saveas(figure(7), strcat(save_folder, 'MarginalPDF_lnorm_log.png'));
% save figure
outfname = strcat(save_folder, SubFolder{1}, 'MarginalPDF_lnorm_log');
if strcmp(FigFormat, 'png')
    saveas(figure(7), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(7), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(7), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end
% save figure - Denker 2020
outfname = strcat(save_folder, SubFolder{3}, 'DenkerFigure8b');
if strcmp(FigFormat, 'png')
    saveas(figure(7), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(7), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(7), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end


%% marginal PDF phi
set(0,'defaultFigurePosition', [2 2 600, 500])
close all
n_bins = 100;
for i = 1:length(cases)
    h{i} = histogram(phi{i}, n_bins);
    binCenters{i} = h{i}.BinEdges; %+ (h.BinWidth/2);
end
close all
figure(8)
set(gcf,'color','w');
for i = 1:length(cases)
    p{i} = histcounts(phi{i}, n_bins, 'Normalization', 'pdf');
    plot(binCenters{i}(1:end-1), p{i}./trapz(p{i}))
    legend(timestr)
    hold on
end
xlabel('$\Delta Z$', 'Interpreter', 'latex', 'fontsize',FZ)
ylabel('$P(\Delta Z)$', 'Interpreter',' latex', 'fontsize',FZ)
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on')
set(legend, 'Box', 'off')
% xmax = 120;
% xlim([0 xmax]);
% xtick_positions = linspace(0, xmax, 5);
% set(gca, 'XTick', xtick_positions, 'LineWidth', lw-1);
%saveas(figure(8), strcat(save_folder, 'MarginalPDF_phi.png'));
% save figure
outfname = strcat(save_folder, SubFolder{1}, 'MarginalPDF_phi');
if strcmp(FigFormat, 'png')
    saveas(figure(8), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(8), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(8), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end


%% marginal PDF phi log-yaxis
set(0,'defaultFigurePosition', [2 2 600, 500])
close all
n_bins = 100;
for i = 1:length(cases)
    h{i} = histogram(phi{i}, n_bins);
    binCenters{i} = h{i}.BinEdges ;%+ (h.BinWidth/2);
end
close all
figure(9)
set(gcf,'color','w');
for i = 1:length(cases)
    p{i} = histcounts(phi{i}, n_bins, 'Normalization', 'pdf');
    plot(binCenters{i}(1:end-1), p{i}./trapz(p{i}))
    legend(timestr)
    hold on
end
xlabel('$\Delta Z$', 'Interpreter', 'latex', 'fontsize', FZ)
ylabel('$P(\Delta Z)$', 'Interpreter','latex', 'fontsize', FZ)
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on')
set(gca, 'YScale', 'log')
set(legend, 'Box', 'off')
% xmax = 120;
% xlim([0 xmax]);
% xtick_positions = linspace(0, xmax, 5);
% set(gca, 'XTick', xtick_positions, 'LineWidth', lw-1);
%saveas(figure(9), strcat(save_folder, 'MarginalPDF_phi_log.png'));
% save figure
outfname = strcat(save_folder, SubFolder{1}, 'MarginalPDF_phi_log');
if strcmp(FigFormat, 'png')
    saveas(figure(9), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(9), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(9), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end


%% marginal pdf phi/phim
set(0,'defaultFigurePosition', [2 2 600, 500])
close all
n_bins = 100;
for i = 1:length(cases)
    h{i} = histogram(phi{i}/phim{i}, n_bins);
    binCenters{i} = h{i}.BinEdges ;%+ (h.BinWidth/2);
end
figure(10)
set(gcf,'color','w');
for i = 1:length(cases)
    p{i} = histcounts(phi{i}/phim{i}, n_bins, 'Normalization', 'pdf');
    plot(binCenters{i}(1:end-1), p{i}./trapz(p{i}))
    legend(timestr)
    hold on
end
xlabel('$\Delta Z/\Delta Z_\mathrm{m}$', 'Interpreter', 'latex', ...
    'fontsize', FZ)
ylabel('$P(\Delta Z/\Delta Z_\mathrm{m})$', 'Interpreter', 'latex', ...
    'fontsize', FZ)
set(gca, 'XMinorTick', 'on', 'YMinorTick','on')
set(legend, 'Box', 'off')
% xmax = 4;
% xlim([0 xmax]);
% xtick_positions = linspace(0, xmax, 5);
% set(gca, 'XTick', xtick_positions, 'LineWidth', lw-1);
%saveas(figure(10), strcat(save_folder, 'MarginalPDF_phinorm.png'));
% save figure
outfname = strcat(save_folder, SubFolder{1}, 'MarginalPDF_phinorm');
if strcmp(FigFormat, 'png')
    saveas(figure(10), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(10), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(10), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end
% save figure - Bode 2017
outfname = strcat(save_folder, SubFolder{2}, 'BodeFigure5b');
if strcmp(FigFormat, 'png')
    saveas(figure(10), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(10), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(10), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end


%% marginal pdf phi/phim - log-yaxis
set(0,'defaultFigurePosition', [2 2 600, 500])
close all
n_bins = 100;
for i = 1:length(cases)
    h{i} = histogram(phi{i}/phim{i}, n_bins);
    binCenters{i} = h{i}.BinEdges ;%+ (h.BinWidth/2);
end
close all
figure(11)
set(gcf,'color','w');
for i = 1:length(cases)
    p{i} = histcounts(phi{i}/phim{i}, n_bins, 'Normalization', 'pdf');
    plot(binCenters{i}(1:end-1), p{i}./trapz(p{i}))
    legend(timestr)
    hold on
end
xlabel('$\Delta Z/\Delta Z_\mathrm{m}$ ', 'Interpreter', 'latex', ...
    'fontsize', FZ)
ylabel('$P(\Delta Z/\Delta Z_\mathrm{m})$', 'Interpreter', 'latex', ...
    'fontsize', FZ)
set(gca,'XMinorTick', 'on', 'YMinorTick', 'on')
set(gca, 'YScale', 'log')
set(legend, 'Box', 'off')
% xmax = 4;
% xlim([0 xmax]);
% xtick_positions = linspace(0, xmax, 5);
% set(gca, 'XTick', xtick_positions, 'LineWidth', lw-1);
%saveas(figure(11), strcat(save_folder, 'MarginalPDF_phinorm_log.png'));
% save figure
outfname = strcat(save_folder, SubFolder{1}, 'MarginalPDF_phinorm_log');
if strcmp(FigFormat, 'png')
    saveas(figure(11), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(11), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(11), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end


%% marginal PDF g
set(0,'defaultFigurePosition', [2 2 600, 500])
close all
n_bins = 100;
for i = 1:length(cases)
    h{i} = histogram(g{i}, n_bins);
    binCenters{i} = h{i}.BinEdges; %+ (h.BinWidth/2);
end
close all
figure(12)
set(gcf,'color','w');
for i = 1:length(cases)
    p{i} = histcounts(g{i}, n_bins, 'Normalization', 'pdf');
    plot(binCenters{i}(1:end-1), p{i}./trapz(p{i}))
    legend(timestr)
    hold on
end
xlabel('$g$', 'Interpreter', 'latex', 'fontsize',FZ)
ylabel('$P(g)$', 'Interpreter',' latex', 'fontsize',FZ)
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on')
set(legend, 'Box', 'off')
% xmax = 120;
% xlim([0 xmax]);
% xtick_positions = linspace(0, xmax, 5);
% set(gca, 'XTick', xtick_positions, 'LineWidth', lw-1);
%saveas(figure(12), strcat(save_folder, 'MarginalPDF_g.png'));
% save figure
outfname = strcat(save_folder, SubFolder{1}, 'MarginalPDF_g');
if strcmp(FigFormat, 'png')
    saveas(figure(12), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(12), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(12), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end


%% marginal PDF g log-yaxis
set(0,'defaultFigurePosition', [2 2 600, 500])
close all
n_bins = 100;
for i = 1:length(cases)
    h{i} = histogram(g{i}, n_bins);
    binCenters{i} = h{i}.BinEdges ;%+ (h.BinWidth/2);
end
close all
figure(13)
set(gcf,'color','w');
for i = 1:length(cases)
    p{i} = histcounts(g{i}, n_bins, 'Normalization', 'pdf');
    plot(binCenters{i}(1:end-1), p{i}./trapz(p{i}))
    legend(timestr)
    hold on
end
xlabel('$g$', 'Interpreter', 'latex', 'fontsize', FZ)
ylabel('$P(g)$', 'Interpreter','latex', 'fontsize', FZ)
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on')
set(gca, 'YScale', 'log')
set(legend, 'Box', 'off')
% xmax = 120;
% xlim([0 xmax]);
% xtick_positions = linspace(0, xmax, 5);
% set(gca, 'XTick', xtick_positions, 'LineWidth', lw-1);
%saveas(figure(13), strcat(save_folder, 'MarginalPDF_g_log.png'));
% save figure
outfname = strcat(save_folder, SubFolder{1}, 'MarginalPDF_g_log');
if strcmp(FigFormat, 'png')
    saveas(figure(13), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(13), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(13), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end


%% marginal pdf g/gm
set(0,'defaultFigurePosition', [2 2 600, 500])
close all
n_bins = 100;
for i = 1:length(cases)
    h{i} = histogram(g{i}/gm{i}, n_bins);
    binCenters{i} = h{i}.BinEdges ;%+ (h.BinWidth/2);
end
figure(14)
set(gcf,'color','w');
for i = 1:length(cases)
    p{i} = histcounts(g{i}/gm{i}, n_bins, 'Normalization', 'pdf');
    plot(binCenters{i}(1:end-1), p{i}./trapz(p{i}))
    legend(timestr)
    hold on
end
xlabel('$g/g_\mathrm{m}$', 'Interpreter', 'latex', ...
    'fontsize', FZ)
ylabel('$P(g/g_\mathrm{m})$', 'Interpreter', 'latex', ...
    'fontsize', FZ)
set(gca, 'XMinorTick', 'on', 'YMinorTick','on')
set(legend, 'Box', 'off')
% xmax = 4;
% xlim([0 xmax]);
% xtick_positions = linspace(0, xmax, 5);
% set(gca, 'XTick', xtick_positions, 'LineWidth', lw-1);
%saveas(figure(14), strcat(save_folder, 'MarginalPDF_gnorm.png'));
% save figure
outfname = strcat(save_folder, SubFolder{1}, 'MarginalPDF_gnorm');
if strcmp(FigFormat, 'png')
    saveas(figure(14), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(14), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(14), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end
% save figure - Bode 2017
outfname = strcat(save_folder, SubFolder{2}, 'BodeFigure5c');
if strcmp(FigFormat, 'png')
    saveas(figure(14), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(14), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(14), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end


%% marginal pdf g/gm - log-yaxis
set(0,'defaultFigurePosition', [2 2 600, 500])
close all
n_bins = 100;
for i = 1:length(cases)
    h{i} = histogram(g{i}/gm{i}, n_bins);
    binCenters{i} = h{i}.BinEdges ;%+ (h.BinWidth/2);
end
close all
figure(15)
set(gcf,'color','w');
for i = 1:length(cases)
    p{i} = histcounts(g{i}/gm{i}, n_bins, 'Normalization', 'pdf');
    plot(binCenters{i}(1:end-1), p{i}./trapz(p{i}))
    legend(timestr)
    hold on
end
xlabel('$g/g_\mathrm{m}$ ', 'Interpreter', 'latex', ...
    'fontsize', FZ)
ylabel('$P(g/g_\mathrm{m})$', 'Interpreter', 'latex', ...
    'fontsize', FZ)
set(gca,'XMinorTick', 'on', 'YMinorTick', 'on')
set(gca, 'YScale', 'log')
set(legend, 'Box', 'off')
% xmax = 4;
% xlim([0 xmax]);
% xtick_positions = linspace(0, xmax, 5);
% set(gca, 'XTick', xtick_positions, 'LineWidth', lw-1);
%saveas(figure(15), strcat(save_folder, 'MarginalPDF_gnorm_log.png'));
% save figure
outfname = strcat(save_folder, SubFolder{1}, 'MarginalPDF_gnorm_log');
if strcmp(FigFormat, 'png')
    saveas(figure(15), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(15), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(15), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end


%% marginal PDF T
%% marginal PDF T log-yaxis
%% marginal pdf T/Tm
%% marginal pdf T/Tm - log-yaxis


%% Mean normalized scalar difference 𝛥𝑍∗, conditioned on the normalized 
% DE length 𝓁∗
set(0, 'defaultFigurePosition', [2 2 600, 500])
close all
figure(20)
tl = tiledlayout(1, 1, 'Padding', 'compact', 'TileSpacing', 'compact');
tl.TileSpacing = 'compact';

set(gcf,'color','w');

n_bins = 100;
%color = {'', '', '', ''};
times = {'$t$=0.50ms', '$t$=0.65ms', '$t$=0.75ms', '$t$=1.00ms' };
for i = 1:length(cases)
    c_max1 = max(size(ln{i}), [], 'all');
    [x1_data, avg_data] = cell_data_avg(ln{i}', phin{i}', n_bins, ...
        [min(ln{i}) max(ln{i})], 1, sf);
    z_dir = zeros(size(x1_data, 1), 1) + c_max1 + 1;
    plot(x1_data, avg_data, 'LineWidth', lw+1, ...
        'DisplayName', times{i});
    hold on
end

% grey reference line
x = logspace(log10(0.2), log10(3), 100);
y = 4*x.^(1/3);
plot(x, y, 'Color', [0.5, 0.5, 0.5], 'LineWidth', lw, ...
    'LineStyle', '--', 'HandleVisibility', 'off');
hold on;

grid off
box on

xmin = 0.05;
xmax = 4;
xlim([xmin xmax]);
% xtick_positions = linspace(xmin, xmax, 5);
% set(gca, 'XTick', xtick_positions, 'LineWidth', lw-1);
xticks([10^-1, 10^0]);

ymin = 0.01;
ymax = 10;
ylim([ymin ymax]);
% ytick_positions = linspace(ymin, ymax, 5);
% set(gca, 'YTick', ytick_positions, 'LineWidth', lw-1);

xlabel('$l/l_\mathrm{m}$ ', 'Interpreter', 'latex', ...
    'fontsize', FZ)
ylabel('$<\Delta Z/\Delta Z_\mathrm{m}|l/l_\mathrm{m}>$', ...
    'Interpreter', 'latex', 'fontsize', FZ)
set(gca,'XMinorTick', 'on', 'YMinorTick', 'on')
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
set(legend, 'Box', 'off')
set(legend, 'Location', 'southeast')

% save figure
outfname = strcat(save_folder, SubFolder{1}, 'ConditionalMean_z_l');
if strcmp(FigFormat, 'png')
    saveas(figure(20), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(20), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(20), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end
% save figure - Bode 2017
outfname = strcat(save_folder, SubFolder{2}, 'BodeFigure9');
if strcmp(FigFormat, 'png')
    saveas(figure(20), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(20), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(20), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end
% save figure - Denker 2020
outfname = strcat(save_folder, SubFolder{3}, 'DenkerFigure10a');
if strcmp(FigFormat, 'png')
    saveas(figure(20), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(20), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(20), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end
% save figure - Niemietz 2024
outfname = strcat(save_folder, SubFolder{4}, 'NiemietzFigure2b');
if strcmp(FigFormat, 'png')
    saveas(figure(20), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(20), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(20), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end


%% mean dissipation element length over eta
set(0,'defaultFigurePosition', [2 2 600, 500])
close all
n_bins = 100;
eta = [96,104,103,114];
time = [0.5,0.65,0.75,1.0];
for i = 1:length(cases)
    lm_(i) = mean(edata_dble{i}(7,:));
end
close all
figure(20)
set(gcf,'color','w');
dx = 50;
plot(time,lm_/(eta/dx),'s')
hold on
yline(1, 'k--', 'LineWidth', 1); % Horizontal line at y = 1
xlabel('$t$  [ms] ','Interpreter','latex','fontsize',FZ)
ylabel('$l_m/\eta$','Interpreter','latex','fontsize',FZ)
%ylim([0 1.5])
set(gca,'XMinorTick','on','YMinorTick','on')
%saveas(figure(20),strcat(save_folder,'lm_over_eta.png'));
% save figure
outfname = strcat(save_folder, SubFolder{1}, 'lm_over_eta');
if strcmp(FigFormat, 'png')
    saveas(figure(20), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(20), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(20), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end
% save figure - Denker 2020
outfname = strcat(save_folder, SubFolder{3}, 'DenkerFigure8d');
if strcmp(FigFormat, 'png')
    saveas(figure(20), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(20), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(20), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end


%% Scalar dissipation rate ratio (chi_st / chi_q) over time
set(0, 'defaultFigurePosition', [2 2 600, 500])
close all
figure(20)
tl = tiledlayout(1, 1, 'Padding', 'compact', 'TileSpacing', 'compact');
tl.TileSpacing = 'compact';

set(gcf,'color','w');

% grid
nx = 256;
ny = 256;
nz = 256;

times = [0.50, 0.65, 0.75, 1.00];
header = {'$t$=0.50ms', '$t$=0.65ms', '$t$=0.75ms', '$t$=1.00ms' };
UpTol = Z_st * 1.01;
LowTol = Z_st * 0.99;
for i = 1:length(cases)
    ChiRatio = GetDissipationRateRatio(Zmix{i}, nx, ny, nz, Dissip{i}, ...
        UpTol, LowTol);
    scatter(times(i), ChiRatio,  100, 'filled', 'blue', ...
        'Marker', 's', 'HandleVisibility', 'off');
    hold on
end

grid off
box on
set(gca,'XMinorTick', 'on', 'YMinorTick', 'on');

xlim([0.4 1]);
ylim([0 0.15]);

xlabel('$t$ [s]', 'Interpreter', 'latex', ...
    'fontsize', FZ)
ylabel('$\chi_\mathrm{st}/\chi_\mathrm{q}$', ...
    'Interpreter', 'latex', 'fontsize', FZ)

% save figure
outfname = strcat(save_folder, SubFolder{1}, ...
    'DissipationRateRatioOverTime');
if strcmp(FigFormat, 'png')
    saveas(figure(20), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(20), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(20), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end
% save figure - Denker 2020
outfname = strcat(save_folder, SubFolder{3}, 'DenkerFigure5a');
if strcmp(FigFormat, 'png')
    saveas(figure(20), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(20), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(20), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end


%% joint pdf: phi over l
set(0,'defaultFigurePosition', [2 2 1800, 500])
close all
figure(21)
tl = tiledlayout(1,4, 'Padding', 'compact', 'TileSpacing', 'compact');
tl.TileSpacing = 'compact';

% sub-figure 1
set(gcf,'color','w');
ax(1) = nexttile(1);
hold on
box on
c_max1 = max(size(l{1}),[],'all');
[x1_data,avg_data] = cell_data_avg(l{1}',phi{1}',n_bins,[min(l{1}) max(l{1})],1,sf);
z_dir = zeros(size(x1_data,1),1)+c_max1+1;
plot3(x1_data,avg_data,z_dir,'k','LineWidth', lw);
[PDF_x1,PDF_x2,PDF_y ] = Compute_PDF_histograms_2D(l{1},phi{1},n_bins);
PDF_y=log10(PDF_y);
s=imagesc(ax(1),PDF_x1,PDF_x2,PDF_y);
set(s, 'AlphaData', ~isnan(PDF_y))
set(gca,'YDir','normal') 
%colormap('jet');
%s=colorbar;
%set(s,'TickLabelInterpreter','latex')
%c_max = max(max(PDF_y));%NN/Del;
%caxis([0 c_max]);
format long
%ylabel(s, '$P(l*,\Delta Z*)$','Interpreter','latex','fontsize',FZ-4)
%set(gca,'ColorScale','log')
hold on
grid off
%set(gca,'ColorScale','log')
ylabel('$\Delta Z$ ','Interpreter','latex','fontsize',FZ)
xlabel('$l$','Interpreter','latex','fontsize',FZ)
title(timestr{1}, 'Interpreter', 'latex', 'FontSize', FZ-2)
set(gca,'XMinorTick','on','YMinorTick','on')
hold off

% sub-figure 2
set(gcf,'color','w');
ax(2) = nexttile(2);
hold on
box on
c_max1 = max(size(l{2}),[],'all');
[x1_data,avg_data] = cell_data_avg(l{2}',phi{2}',n_bins,[min(l{2}) max(l{2})],1,sf);
z_dir = zeros(size(x1_data,1),1)+c_max1+1;
plot3(x1_data,avg_data,z_dir,'k','LineWidth', lw);
[PDF_x1,PDF_x2,PDF_y ] = Compute_PDF_histograms_2D(l{2},phi{2},n_bins);
PDF_y=log10(PDF_y);
s=imagesc(ax(2),PDF_x1,PDF_x2,PDF_y);
set(s, 'AlphaData', ~isnan(PDF_y))
set(gca,'YDir','normal') 
%colormap('jet');
%s=colorbar;
%set(s,'TickLabelInterpreter','latex')
%c_max = max(max(PDF_y));%NN/Del;
%caxis([0 c_max]);
format long
%ylabel(s, '$P(l*,\Delta Z*)$','Interpreter','latex','fontsize',FZ-4)
%set(gca,'ColorScale','log')
hold on
grid off
%set(gca,'ColorScale','log')
ylabel('$\Delta Z$ ','Interpreter','latex','fontsize',FZ)
xlabel('$l$','Interpreter','latex','fontsize',FZ)
title(timestr{2}, 'Interpreter', 'latex', 'FontSize', FZ-2)
set(gca,'XMinorTick','on','YMinorTick','on')
hold off

% sub-figure 3
set(gcf,'color','w');
ax(3) = nexttile(3);
hold on
box on
c_max1 = max(size(l{3}),[],'all');
[x1_data,avg_data] = cell_data_avg(l{3}',phi{3}',n_bins,[min(l{3}) max(l{3})],1,sf);
z_dir = zeros(size(x1_data,1),1)+c_max1+1;
plot3(x1_data,avg_data,z_dir,'k','LineWidth', lw);
[PDF_x1,PDF_x2,PDF_y ] = Compute_PDF_histograms_2D(l{3},phi{3},n_bins);
PDF_y=log10(PDF_y);
s=imagesc(ax(3),PDF_x1,PDF_x2,PDF_y);
set(s, 'AlphaData', ~isnan(PDF_y))
set(gca,'YDir','normal') 
%colormap('jet');
%s=colorbar;
%set(s,'TickLabelInterpreter','latex')
%c_max = max(max(PDF_y));%NN/Del;
%caxis([0 c_max]);
format long
%ylabel(s, '$P(l*,\Delta Z*)$','Interpreter','latex','fontsize',FZ-4)
%set(gca,'ColorScale','log')
hold on
grid off
%set(gca,'ColorScale','log')
ylabel('$\Delta Z$ ','Interpreter','latex','fontsize',FZ)
xlabel('$l$','Interpreter','latex','fontsize',FZ)
title(timestr{3}, 'Interpreter', 'latex', 'FontSize', FZ-2)
set(gca,'XMinorTick','on','YMinorTick','on')
hold off

% sub-figure 4
set(gcf,'color','w');
ax(4) = nexttile(4);
hold on
box on
c_max1 = max(size(l{4}),[],'all');
[x1_data,avg_data] = cell_data_avg(l{4}',phi{4}',n_bins,[min(l{4}) max(l{4})],1,sf);
z_dir = zeros(size(x1_data,1),1)+c_max1+1;
plot3(x1_data,avg_data,z_dir,'k','LineWidth', lw);
[PDF_x1,PDF_x2,PDF_y ] = Compute_PDF_histograms_2D(l{4},phi{4},n_bins);
PDF_y=log10(PDF_y);
s=imagesc(ax(4),PDF_x1,PDF_x2,PDF_y);
set(s, 'AlphaData', ~isnan(PDF_y))
set(gca,'YDir','normal') 
%colormap('jet');
%s=colorbar;
%set(s,'TickLabelInterpreter','latex')
%c_max = max(max(PDF_y));%NN/Del;
%caxis([0 c_max]);
format long
%ylabel(s, '$P(l*,\Delta Z*)$','Interpreter','latex','fontsize',FZ-4)
%set(gca,'ColorScale','log')
hold on
grid off
%set(gca,'ColorScale','log')
ylabel('$\Delta Z$ ','Interpreter','latex','fontsize',FZ)
xlabel('$l$','Interpreter','latex','fontsize',FZ)
title(timestr{4}, 'Interpreter', 'latex', 'FontSize', FZ-2)
set(gca,'XMinorTick','on','YMinorTick','on')
hold off

% Set colormap and color limits for all subplots
set(ax, 'Colormap', jet)
% assign color bar to one tile 
cbh = colorbar(ax(end)); 
% To position the colorbar as a global colorbar representing
% all tiles, 
cbh.Layout.Tile = 'south'; 
set(cbh,'TickLabelInterpreter','latex');
ylabel(cbh, '$log(P(l,\Delta Z))$','fontsize',FZ,'interpreter','latex')
ylim(ax,[0 0.25])
xlim(ax,[0 110])
% Adjust figure properties for tight fitting
set(gcf, 'PaperPositionMode', 'auto');
%set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02))
%saveas(figure(21),strcat(save_folder,'JointPDF_phi_l.png'));
% save figure
outfname = strcat(save_folder, SubFolder{1}, 'JointPDF_phi_l');
if strcmp(FigFormat, 'png')
    saveas(figure(21), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(21), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(21), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end


%% joint pdf: phinorm over lnorm
set(0,'defaultFigurePosition', [2 2 1800, 500])
close all
figure(22)
tl = tiledlayout(1,4, 'Padding', 'compact', 'TileSpacing', 'compact');
tl.TileSpacing = 'compact';

% sub-figure 1
set(gcf,'color','w');
ax(1) = nexttile(1);
hold on
box on
c_max1 = max(size(ln{1}),[],'all');
[x1_data,avg_data] = cell_data_avg(ln{1}',phin{1}',n_bins,[min(ln{1}) max(ln{1})],1,sf);
z_dir = zeros(size(x1_data,1),1)+c_max1+1;
plot3(x1_data,avg_data,z_dir,'k','LineWidth', lw);
[PDF_x1,PDF_x2,PDF_y ] = Compute_PDF_histograms_2D(ln{1},phin{1},n_bins);
PDF_y=log10(PDF_y);
s=imagesc(ax(1),PDF_x1,PDF_x2,PDF_y);
set(s, 'AlphaData', ~isnan(PDF_y))
set(gca,'YDir','normal') 
%colormap('jet');
%s=colorbar;
%set(s,'TickLabelInterpreter','latex')
%c_max = max(max(PDF_y));%NN/Del;
%caxis([0 c_max]);
format long
%ylabel(s, '$P(l*,\Delta Z*)$','Interpreter','latex','fontsize',FZ-4)
%set(gca,'ColorScale','log')
hold on
grid off
%set(gca,'ColorScale','log')
ylabel('$\Delta Z/ \Delta Z_m$ ','Interpreter','latex','fontsize',FZ)
xlabel('$l/l_m$','Interpreter','latex','fontsize',FZ)
title(timestr{1}, 'Interpreter', 'latex', 'FontSize', FZ-2)
set(gca,'XMinorTick','on','YMinorTick','on')
hold off

% sub-figure 2
set(gcf,'color','w');
ax(2) = nexttile(2);
hold on
box on
c_max1 = max(size(ln{2}),[],'all');
[x1_data,avg_data] = cell_data_avg(ln{2}',phin{2}',n_bins,[min(ln{2}) max(ln{2})],1,sf);
z_dir = zeros(size(x1_data,1),1)+c_max1+1;
plot3(x1_data,avg_data,z_dir,'k','LineWidth', lw);
[PDF_x1,PDF_x2,PDF_y ] = Compute_PDF_histograms_2D(ln{2},phin{2},n_bins);
PDF_y=log10(PDF_y);
s=imagesc(ax(2),PDF_x1,PDF_x2,PDF_y);
set(s, 'AlphaData', ~isnan(PDF_y))
set(gca,'YDir','normal') 
%colormap('jet');
%s=colorbar;
%set(s,'TickLabelInterpreter','latex')
%c_max = max(max(PDF_y));%NN/Del;
%caxis([0 c_max]);
format long
%ylabel(s, '$P(l*,\Delta Z*)$','Interpreter','latex','fontsize',FZ-4)
%set(gca,'ColorScale','log')
hold on
grid off
%set(gca,'ColorScale','log')
ylabel('$\Delta Z/ \Delta Z_m$ ','Interpreter','latex','fontsize',FZ)
xlabel('$l/l_m$','Interpreter','latex','fontsize',FZ)
title(timestr{2}, 'Interpreter', 'latex', 'FontSize', FZ-2)
set(gca,'XMinorTick','on','YMinorTick','on')
hold off

% sub-figure 3
set(gcf,'color','w');
ax(3) = nexttile(3);
hold on
box on
c_max1 = max(size(ln{3}),[],'all');
[x1_data,avg_data] = cell_data_avg(ln{3}',phin{3}',n_bins,[min(ln{3}) max(ln{3})],1,sf);
z_dir = zeros(size(x1_data,1),1)+c_max1+1;
plot3(x1_data,avg_data,z_dir,'k','LineWidth', lw);
[PDF_x1,PDF_x2,PDF_y ] = Compute_PDF_histograms_2D(ln{3},phin{3},n_bins);
PDF_y=log10(PDF_y);
s=imagesc(ax(3),PDF_x1,PDF_x2,PDF_y);
set(s, 'AlphaData', ~isnan(PDF_y))
set(gca,'YDir','normal') 
%colormap('jet');
%s=colorbar;
%set(s,'TickLabelInterpreter','latex')
%c_max = max(max(PDF_y));%NN/Del;
%caxis([0 c_max]);
format long
%ylabel(s, '$P(l*,\Delta Z*)$','Interpreter','latex','fontsize',FZ-4)
%set(gca,'ColorScale','log')
hold on
grid off
%set(gca,'ColorScale','log')
ylabel('$\Delta Z/ \Delta Z_m$ ','Interpreter','latex','fontsize',FZ)
xlabel('$l/l_m$','Interpreter','latex','fontsize',FZ)
title(timestr{3}, 'Interpreter', 'latex', 'FontSize', FZ-2)
set(gca,'XMinorTick','on','YMinorTick','on')
hold off

% sub-figure 4
set(gcf,'color','w');
ax(4) = nexttile(4);
hold on
box on
c_max4 = max(size(ln{4}),[],'all');
[x4_data,avg4_data] = cell_data_avg(ln{4}',phin{4}',n_bins,[min(ln{4}) max(ln{4})],1,sf);
z_dir4 = zeros(size(x4_data,1),1)+c_max4+1;
plot3(x4_data,avg4_data,z_dir4,'k','LineWidth', lw);
[PDF_x1,PDF_x2,PDF_y ] = Compute_PDF_histograms_2D(ln{4},phin{4},n_bins);
PDF_y=log10(PDF_y);
s=imagesc(ax(4),PDF_x1,PDF_x2,PDF_y);
set(s, 'AlphaData', ~isnan(PDF_y))
set(gca,'YDir','normal') 
%colormap('jet');
%s=colorbar;
%set(s,'TickLabelInterpreter','latex')
%c_max = max(max(PDF_y));%NN/Del;
%caxis([0 c_max]);
format long
%ylabel(s, '$P(l*,\Delta Z*)$','Interpreter','latex','fontsize',FZ-4)
%set(gca,'ColorScale','log')
hold on
grid off
%set(gca,'ColorScale','log')
ylabel('$\Delta Z/ \Delta Z_m$ ','Interpreter','latex','fontsize',FZ)
xlabel('$l/l_m$','Interpreter','latex','fontsize',FZ)
title(timestr{4}, 'Interpreter', 'latex', 'FontSize', FZ-2)
set(gca,'XMinorTick','on','YMinorTick','on')
hold off

% Set colormap and color limits for all subplots
set(ax, 'Colormap', jet)
% assign color bar to one tile 
cbh = colorbar(ax(end)); 
% To position the colorbar as a global colorbar representing
% all tiles, 
cbh.Layout.Tile = 'south'; 
set(cbh,'TickLabelInterpreter','latex');
ylabel(cbh, '$log(P(l^*,\Delta Z^*))$','fontsize',FZ,'interpreter','latex')
ylim(ax,[0 3])
xlim(ax,[0 4])
% Adjust figure properties for tight fitting
set(gcf, 'PaperPositionMode', 'auto');
%set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02))
%saveas(figure(22),strcat(save_folder,'JointPDF_phinorm_lnorm.png'));
% save figure
outfname = strcat(save_folder, SubFolder{1}, 'JointPDF_phinorm_lnorm');
if strcmp(FigFormat, 'png')
    saveas(figure(22), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(22), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(22), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end
% save figure - Bode 2017
outfname = strcat(save_folder, SubFolder{2}, 'BodeFigure6');
if strcmp(FigFormat, 'png')
    saveas(figure(22), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(22), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(22), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end
% save figure - Denker 2020
outfname = strcat(save_folder, SubFolder{3}, 'DenkerFigure9');
if strcmp(FigFormat, 'png')
    saveas(figure(22), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(22), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(22), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end


%% joint pdf: g over l
set(0,'defaultFigurePosition', [2 2 1800, 500])
close all
figure(23)
tl = tiledlayout(1,4, 'Padding', 'compact', 'TileSpacing', 'compact');
tl.TileSpacing = 'compact';

% sub-figure 1
set(gcf,'color','w');
ax(1) = nexttile(1);
hold on
box on
c_max1 = max(size(l{1}),[],'all');
[x1_data,avg_data] = cell_data_avg(l{1}',g{1}',n_bins,[min(l{1}) max(l{1})],1,sf);
z_dir = zeros(size(x1_data,1),1)+c_max1+1;
plot3(x1_data,avg_data,z_dir,'k','LineWidth', lw);
[PDF_x1,PDF_x2,PDF_y ] = Compute_PDF_histograms_2D(l{1},g{1},n_bins);
PDF_y=log10(PDF_y);
s=imagesc(ax(1),PDF_x1,PDF_x2,PDF_y);
set(s, 'AlphaData', ~isnan(PDF_y))
set(gca,'YDir','normal') 
%colormap('jet');
%s=colorbar;
%set(s,'TickLabelInterpreter','latex')
%c_max = max(max(PDF_y));%NN/Del;
%caxis([0 c_max]);
format long
%ylabel(s, '$P(l*,\Delta Z*)$','Interpreter','latex','fontsize',FZ-4)
%set(gca,'ColorScale','log')
hold on
grid off
%set(gca,'ColorScale','log')
ylabel('$g$ ','Interpreter','latex','fontsize',FZ)
xlabel('$l$','Interpreter','latex','fontsize',FZ)
title(timestr{1}, 'Interpreter', 'latex', 'FontSize', FZ-2)
set(gca,'XMinorTick','on','YMinorTick','on')
hold off

% sub-figure 2
set(gcf,'color','w');
ax(2) = nexttile(2);
hold on
box on
c_max1 = max(size(l{2}),[],'all');
[x1_data,avg_data] = cell_data_avg(l{2}',g{2}',n_bins,[min(l{2}) max(l{2})],1,sf);
z_dir = zeros(size(x1_data,1),1)+c_max1+1;
plot3(x1_data,avg_data,z_dir,'k','LineWidth', lw);
[PDF_x1,PDF_x2,PDF_y ] = Compute_PDF_histograms_2D(l{2},g{2},n_bins);
PDF_y=log10(PDF_y);
s=imagesc(ax(2),PDF_x1,PDF_x2,PDF_y);
set(s, 'AlphaData', ~isnan(PDF_y))
set(gca,'YDir','normal') 
%colormap('jet');
%s=colorbar;
%set(s,'TickLabelInterpreter','latex')
%c_max = max(max(PDF_y));%NN/Del;
%caxis([0 c_max]);
format long
%ylabel(s, '$P(l*,\Delta Z*)$','Interpreter','latex','fontsize',FZ-4)
%set(gca,'ColorScale','log')
hold on
grid off
%set(gca,'ColorScale','log')
ylabel('$g$ ','Interpreter','latex','fontsize',FZ)
xlabel('$l$','Interpreter','latex','fontsize',FZ)
title(timestr{2}, 'Interpreter', 'latex', 'FontSize', FZ-2)
set(gca,'XMinorTick','on','YMinorTick','on')
hold off

% sub-figure 3
set(gcf,'color','w');
ax(3) = nexttile(3);
hold on
box on
c_max1 = max(size(l{3}),[],'all');
[x1_data,avg_data] = cell_data_avg(l{3}',g{3}',n_bins,[min(l{3}) max(l{3})],1,sf);
z_dir = zeros(size(x1_data,1),1)+c_max1+1;
plot3(x1_data,avg_data,z_dir,'k','LineWidth', lw);
[PDF_x1,PDF_x2,PDF_y ] = Compute_PDF_histograms_2D(l{3},g{3},n_bins);
PDF_y=log10(PDF_y);
s=imagesc(ax(3),PDF_x1,PDF_x2,PDF_y);
set(s, 'AlphaData', ~isnan(PDF_y))
set(gca,'YDir','normal') 
%colormap('jet');
%s=colorbar;
%set(s,'TickLabelInterpreter','latex')
%c_max = max(max(PDF_y));%NN/Del;
%caxis([0 c_max]);
format long
%ylabel(s, '$P(l*,\Delta Z*)$','Interpreter','latex','fontsize',FZ-4)
%set(gca,'ColorScale','log')
hold on
grid off
%set(gca,'ColorScale','log')
ylabel('$g$ ','Interpreter','latex','fontsize',FZ)
xlabel('$l$','Interpreter','latex','fontsize',FZ)
title(timestr{3}, 'Interpreter', 'latex', 'FontSize', FZ-2)
set(gca,'XMinorTick','on','YMinorTick','on')
hold off

% sub-figure 4
set(gcf,'color','w');
ax(4) = nexttile(4);
hold on
box on
c_max1 = max(size(l{4}),[],'all');
[x1_data,avg_data] = cell_data_avg(l{4}',g{4}',n_bins,[min(l{4}) max(l{4})],1,sf);
z_dir = zeros(size(x1_data,1),1)+c_max1+1;
plot3(x1_data,avg_data,z_dir,'k','LineWidth', lw);
[PDF_x1,PDF_x2,PDF_y ] = Compute_PDF_histograms_2D(l{4},g{4},n_bins);
PDF_y=log10(PDF_y);
s=imagesc(ax(4),PDF_x1,PDF_x2,PDF_y);
set(s, 'AlphaData', ~isnan(PDF_y))
set(gca,'YDir','normal') 
%colormap('jet');
%s=colorbar;
%set(s,'TickLabelInterpreter','latex')
%c_max = max(max(PDF_y));%NN/Del;
%caxis([0 c_max]);
format long
%ylabel(s, '$P(l*,\Delta Z*)$','Interpreter','latex','fontsize',FZ-4)
%set(gca,'ColorScale','log')
hold on
grid off
%set(gca,'ColorScale','log')
ylabel('$g$ ','Interpreter','latex','fontsize',FZ)
xlabel('$l$','Interpreter','latex','fontsize',FZ)
title(timestr{4}, 'Interpreter', 'latex', 'FontSize', FZ-2)
set(gca,'XMinorTick','on','YMinorTick','on')
hold off

% Set colormap and color limits for all subplots
set(ax, 'Colormap', jet)
% assign color bar to one tile 
cbh = colorbar(ax(end)); 
% To position the colorbar as a global colorbar representing
% all tiles, 
cbh.Layout.Tile = 'south'; 
set(cbh,'TickLabelInterpreter','latex');
ylabel(cbh, '$log(P(l,g))$','fontsize',FZ,'interpreter','latex')
ylim(ax,[0 0.02])
xlim(ax,[0 110])
% Adjust figure properties for tight fitting
set(gcf, 'PaperPositionMode', 'auto');
%set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02))
%saveas(figure(23),strcat(save_folder,'JointPDF_g_over_l.png'));
% save figure
outfname = strcat(save_folder, SubFolder{1}, 'JointPDF_g_over_l');
if strcmp(FigFormat, 'png')
    saveas(figure(23), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(23), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(23), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end


%% joint pdf: gnorm over lnorm
set(0,'defaultFigurePosition', [2 2 1800, 500])
close all
figure(24)
tl = tiledlayout(1,4, 'Padding', 'compact', 'TileSpacing', 'compact');
tl.TileSpacing = 'compact';

% sub-figure 1
set(gcf,'color','w');
ax(1) = nexttile(1);
hold on
box on
c_max1 = max(size(ln{1}),[],'all');
[x1_data,avg_data] = cell_data_avg(ln{1}',gn{1}',n_bins,[min(ln{1}) max(ln{1})],1,sf);
z_dir = zeros(size(x1_data,1),1)+c_max1+1;
plot3(x1_data,avg_data,z_dir,'k','LineWidth', lw);
[PDF_x1,PDF_x2,PDF_y ] = Compute_PDF_histograms_2D(ln{1},gn{1},n_bins);
PDF_y=log10(PDF_y);
s=imagesc(ax(1),PDF_x1,PDF_x2,PDF_y);
set(s, 'AlphaData', ~isnan(PDF_y))
set(gca,'YDir','normal') 
%colormap('jet');
%s=colorbar;
%set(s,'TickLabelInterpreter','latex')
%c_max = max(max(PDF_y));%NN/Del;
%caxis([0 c_max]);
format long
%ylabel(s, '$P(l*,\Delta Z*)$','Interpreter','latex','fontsize',FZ-4)
%set(gca,'ColorScale','log')
hold on
grid off
%set(gca,'ColorScale','log')
ylabel('$g/g_m$ ','Interpreter','latex','fontsize',FZ)
xlabel('$l/l_m$','Interpreter','latex','fontsize',FZ)
title(timestr{1}, 'Interpreter', 'latex', 'FontSize', FZ-2)
set(gca,'XMinorTick','on','YMinorTick','on')
hold off

% sub-figure 2
set(gcf,'color','w');
ax(2) = nexttile(2);
hold on
box on
c_max1 = max(size(ln{2}),[],'all');
[x1_data,avg_data] = cell_data_avg(ln{1}',gn{1}',n_bins,[min(ln{1}) max(ln{1})],1,sf);
z_dir = zeros(size(x1_data,1),1)+c_max1+1;
plot3(x1_data,avg_data,z_dir,'k','LineWidth', lw);
[PDF_x1,PDF_x2,PDF_y ] = Compute_PDF_histograms_2D(ln{2},gn{2},n_bins);
PDF_y=log10(PDF_y);
s=imagesc(ax(2),PDF_x1,PDF_x2,PDF_y);
set(s, 'AlphaData', ~isnan(PDF_y))
set(gca,'YDir','normal') 
%colormap('jet');
%s=colorbar;
%set(s,'TickLabelInterpreter','latex')
%c_max = max(max(PDF_y));%NN/Del;
%caxis([0 c_max]);
format long
%ylabel(s, '$P(l*,\Delta Z*)$','Interpreter','latex','fontsize',FZ-4)
%set(gca,'ColorScale','log')
hold on
grid off
%set(gca,'ColorScale','log')
ylabel('$g/g_m$ ','Interpreter','latex','fontsize',FZ)
xlabel('$l/l_m$','Interpreter','latex','fontsize',FZ)
title(timestr{2}, 'Interpreter', 'latex', 'FontSize', FZ-2)
set(gca,'XMinorTick','on','YMinorTick','on')
hold off

% sub-figure 3
set(gcf,'color','w');
ax(3) = nexttile(3);
hold on
box on
c_max1 = max(size(ln{3}),[],'all');
[x1_data,avg_data] = cell_data_avg(ln{3}',gn{3}',n_bins,[min(ln{3}) max(ln{3})],1,sf);
z_dir = zeros(size(x1_data,1),1)+c_max1+1;
plot3(x1_data,avg_data,z_dir,'k','LineWidth', lw);
[PDF_x1,PDF_x2,PDF_y ] = Compute_PDF_histograms_2D(ln{3},gn{3},n_bins);
PDF_y=log10(PDF_y);
s=imagesc(ax(3),PDF_x1,PDF_x2,PDF_y);
set(s, 'AlphaData', ~isnan(PDF_y))
set(gca,'YDir','normal') 
%colormap('jet');
%s=colorbar;
%set(s,'TickLabelInterpreter','latex')
%c_max = max(max(PDF_y));%NN/Del;
%caxis([0 c_max]);
format long
%ylabel(s, '$P(l*,\Delta Z*)$','Interpreter','latex','fontsize',FZ-4)
%set(gca,'ColorScale','log')
hold on
grid off
%set(gca,'ColorScale','log')
ylabel('$g/g_m$ ','Interpreter','latex','fontsize',FZ)
xlabel('$l/l_m$','Interpreter','latex','fontsize',FZ)
title(timestr{3}, 'Interpreter', 'latex', 'FontSize', FZ-2)
set(gca,'XMinorTick','on','YMinorTick','on')
hold off

% sub-figure 4
set(gcf,'color','w');
ax(4) = nexttile(4);
hold on
box on
c_max1 = max(size(ln{4}),[],'all');
[x1_data,avg_data] = cell_data_avg(ln{4}',gn{4}',n_bins,[min(ln{4}) max(ln{4})],1,sf);
z_dir = zeros(size(x1_data,1),1)+c_max1+1;
plot3(x1_data,avg_data,z_dir,'k','LineWidth', lw);
[PDF_x1,PDF_x2,PDF_y ] = Compute_PDF_histograms_2D(ln{4},gn{4},n_bins);
PDF_y=log10(PDF_y);
s=imagesc(ax(4),PDF_x1,PDF_x2,PDF_y);
set(s, 'AlphaData', ~isnan(PDF_y))
set(gca,'YDir','normal') 
%colormap('jet');
%s=colorbar;
%set(s,'TickLabelInterpreter','latex')
%c_max = max(max(PDF_y));%NN/Del;
%caxis([0 c_max]);
format long
%ylabel(s, '$P(l*,\Delta Z*)$','Interpreter','latex','fontsize',FZ-4)
%set(gca,'ColorScale','log')
hold on
grid off
%set(gca,'ColorScale','log')
ylabel('$g/g_m$ ','Interpreter','latex','fontsize',FZ)
xlabel('$l/l_m$','Interpreter','latex','fontsize',FZ)
title(timestr{4}, 'Interpreter', 'latex', 'FontSize', FZ-2)
set(gca,'XMinorTick','on','YMinorTick','on')
hold off

% Set colormap and color limits for all subplots
set(ax, 'Colormap', jet)
% assign color bar to one tile 
cbh = colorbar(ax(end)); 
% To position the colorbar as a global colorbar representing
% all tiles, 
cbh.Layout.Tile = 'south'; 
set(cbh,'TickLabelInterpreter','latex');
ylabel(cbh, '$log(P(l^*,g^*))$','fontsize',FZ,'interpreter','latex')
ylim(ax,[0 7])
xlim(ax,[0 4])
% Adjust figure properties for tight fitting
set(gcf, 'PaperPositionMode', 'auto');
%set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02))
%saveas(figure(24),strcat(save_folder,'JointPDF_gnorm_over_lnorm.png'));
% save figure
outfname = strcat(save_folder, SubFolder{1}, 'JointPDF_gnorm_over_lnorm');
if strcmp(FigFormat, 'png')
    saveas(figure(24), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(24), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(24), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end


%% joint pdf: phi over g
set(0,'defaultFigurePosition', [2 2 1800, 500])
close all
figure(25)
tl = tiledlayout(1,4, 'Padding', 'compact', 'TileSpacing', 'compact');
tl.TileSpacing = 'compact';

% sub-figure 1
set(gcf,'color','w');
ax(1) = nexttile(1);
hold on
box on
c_max1 = max(size(g{1}),[],'all');
[x1_data,avg_data] = cell_data_avg(g{1}',phi{1}',n_bins,[min(g{1}) max(g{1})],1,sf);
z_dir = zeros(size(x1_data,1),1)+c_max1+1;
plot3(x1_data,avg_data,z_dir,'k','LineWidth', lw);
[PDF_x1,PDF_x2,PDF_y ] = Compute_PDF_histograms_2D(g{1},phi{1},n_bins);
PDF_y=log10(PDF_y);
s=imagesc(ax(1),PDF_x1,PDF_x2,PDF_y);
set(s, 'AlphaData', ~isnan(PDF_y))
set(gca,'YDir','normal') 
%colormap('jet');
%s=colorbar;
%set(s,'TickLabelInterpreter','latex')
%c_max = max(max(PDF_y));%NN/Del;
%caxis([0 c_max]);
format long
%ylabel(s, '$P(l*,\Delta Z*)$','Interpreter','latex','fontsize',FZ-4)
%set(gca,'ColorScale','log')
hold on
grid off
%set(gca,'ColorScale','log')
ylabel('$\Delta Z$ ','Interpreter','latex','fontsize',FZ)
xlabel('$g$','Interpreter','latex','fontsize',FZ)
title(timestr{1}, 'Interpreter', 'latex', 'FontSize', FZ-2)
set(gca,'XMinorTick','on','YMinorTick','on')
hold off

% sub-figure 2
set(gcf,'color','w');
ax(2) = nexttile(2);
hold on
box on
c_max1 = max(size(g{2}),[],'all');
[x1_data,avg_data] = cell_data_avg(g{2}',phi{2}',n_bins,[min(g{2}) max(g{2})],1,sf);
z_dir = zeros(size(x1_data,1),1)+c_max1+1;
plot3(x1_data,avg_data,z_dir,'k','LineWidth', lw);
[PDF_x1,PDF_x2,PDF_y ] = Compute_PDF_histograms_2D(g{2},phi{2},n_bins);
PDF_y=log10(PDF_y);
s=imagesc(ax(2),PDF_x1,PDF_x2,PDF_y);
set(s, 'AlphaData', ~isnan(PDF_y))
set(gca,'YDir','normal') 
%colormap('jet');
%s=colorbar;
%set(s,'TickLabelInterpreter','latex')
%c_max = max(max(PDF_y));%NN/Del;
%caxis([0 c_max]);
format long
%ylabel(s, '$P(l*,\Delta Z*)$','Interpreter','latex','fontsize',FZ-4)
%set(gca,'ColorScale','log')
hold on
grid off
%set(gca,'ColorScale','log')
ylabel('$\Delta Z$ ','Interpreter','latex','fontsize',FZ)
xlabel('$g$','Interpreter','latex','fontsize',FZ)
title(timestr{2}, 'Interpreter', 'latex', 'FontSize', FZ-2)
set(gca,'XMinorTick','on','YMinorTick','on')
hold off

% sub-figure 3
set(gcf,'color','w');
ax(3) = nexttile(3);
hold on
box on
c_max1 = max(size(g{3}),[],'all');
[x1_data,avg_data] = cell_data_avg(g{3}',phi{3}',n_bins,[min(g{3}) max(g{3})],1,sf);
z_dir = zeros(size(x1_data,1),1)+c_max1+1;
plot3(x1_data,avg_data,z_dir,'k','LineWidth', lw);
[PDF_x1,PDF_x2,PDF_y ] = Compute_PDF_histograms_2D(g{3},phi{3},n_bins);
PDF_y=log10(PDF_y);
s=imagesc(ax(3),PDF_x1,PDF_x2,PDF_y);
set(s, 'AlphaData', ~isnan(PDF_y))
set(gca,'YDir','normal') 
%colormap('jet');
%s=colorbar;
%set(s,'TickLabelInterpreter','latex')
%c_max = max(max(PDF_y));%NN/Del;
%caxis([0 c_max]);
format long
%ylabel(s, '$P(l*,\Delta Z*)$','Interpreter','latex','fontsize',FZ-4)
%set(gca,'ColorScale','log')
hold on
grid off
%set(gca,'ColorScale','log')
ylabel('$\Delta Z$ ','Interpreter','latex','fontsize',FZ)
xlabel('$g$','Interpreter','latex','fontsize',FZ)
title(timestr{3}, 'Interpreter', 'latex', 'FontSize', FZ-2)
set(gca,'XMinorTick','on','YMinorTick','on')
hold off

% sub-figure 4
set(gcf,'color','w');
ax(4) = nexttile(4);
hold on
box on
c_max1 = max(size(g{4}),[],'all');
[x1_data,avg_data] = cell_data_avg(g{4}',phi{4}',n_bins,[min(g{4}) max(g{4})],1,sf);
z_dir = zeros(size(x1_data,1),1)+c_max1+1;
plot3(x1_data,avg_data,z_dir,'k','LineWidth', lw);
[PDF_x1,PDF_x2,PDF_y ] = Compute_PDF_histograms_2D(g{4},phi{4},n_bins);
PDF_y=log10(PDF_y);
s=imagesc(ax(4),PDF_x1,PDF_x2,PDF_y);
set(s, 'AlphaData', ~isnan(PDF_y))
set(gca,'YDir','normal') 
%colormap('jet');
%s=colorbar;
%set(s,'TickLabelInterpreter','latex')
%c_max = max(max(PDF_y));%NN/Del;
%caxis([0 c_max]);
format long
%ylabel(s, '$P(l*,\Delta Z*)$','Interpreter','latex','fontsize',FZ-4)
%set(gca,'ColorScale','log')
hold on
grid off
%set(gca,'ColorScale','log')
ylabel('$\Delta Z$ ','Interpreter','latex','fontsize',FZ)
xlabel('$g$','Interpreter','latex','fontsize',FZ)
title(timestr{4}, 'Interpreter', 'latex', 'FontSize', FZ-2)
set(gca,'XMinorTick','on','YMinorTick','on')
hold off

% Set colormap and color limits for all subplots
set(ax, 'Colormap', jet)
% assign color bar to one tile 
cbh = colorbar(ax(end)); 
% To position the colorbar as a global colorbar representing
% all tiles, 
cbh.Layout.Tile = 'south'; 
set(cbh,'TickLabelInterpreter','latex');
ylabel(cbh, '$log(P(g,\Delta Z))$','fontsize',FZ,'interpreter','latex')
ylim(ax,[0 0.3])
xlim(ax,[0 0.02])
% Adjust figure properties for tight fitting
set(gcf, 'PaperPositionMode', 'auto');
%set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02))
%saveas(figure(25),strcat(save_folder,'JointPDF_phi_over_g.png'));
% save figure
outfname = strcat(save_folder, SubFolder{1}, 'JointPDF_phi_over_g');
if strcmp(FigFormat, 'png')
    saveas(figure(25), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(25), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(25), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end


%% joint pdf: phinorm over gnorm
set(0,'defaultFigurePosition', [2 2 1800, 500])
close all
figure(26)
tl = tiledlayout(1,4, 'Padding', 'compact', 'TileSpacing', 'compact');
tl.TileSpacing = 'compact';

% sub-figure 1
set(gcf,'color','w');
ax(1) = nexttile(1);
hold on
box on
c_max1 = max(size(gn{1}),[],'all');
[x1_data,avg_data] = cell_data_avg(gn{1}',phin{1}',n_bins,[min(gn{1}) max(gn{1})],1,sf);
z_dir = zeros(size(x1_data,1),1)+c_max1+1;
plot3(x1_data,avg_data,z_dir,'k','LineWidth', lw);
[PDF_x1,PDF_x2,PDF_y ] = Compute_PDF_histograms_2D(gn{1},phin{1},n_bins);
PDF_y=log10(PDF_y);
s=imagesc(ax(1),PDF_x1,PDF_x2,PDF_y);
set(s, 'AlphaData', ~isnan(PDF_y))
set(gca,'YDir','normal') 
%colormap('jet');
%s=colorbar;
%set(s,'TickLabelInterpreter','latex')
%c_max = max(max(PDF_y));%NN/Del;
%caxis([0 c_max]);
format long
%ylabel(s, '$P(l*,\Delta Z*)$','Interpreter','latex','fontsize',FZ-4)
%set(gca,'ColorScale','log')
hold on
grid off
%set(gca,'ColorScale','log')
ylabel('$\Delta Z^*$ ','Interpreter','latex','fontsize',FZ)
xlabel('$g^*$','Interpreter','latex','fontsize',FZ)
title(timestr{1}, 'Interpreter', 'latex', 'FontSize', FZ-2)
set(gca,'XMinorTick','on','YMinorTick','on')
hold off

% sub-figure 2
set(gcf,'color','w');
ax(2) = nexttile(2);
hold on
box on
c_max1 = max(size(gn{2}),[],'all');
[x1_data,avg_data] = cell_data_avg(gn{2}',phin{2}',n_bins,[min(gn{2}) max(gn{2})],1,sf);
z_dir = zeros(size(x1_data,1),1)+c_max1+1;
plot3(x1_data,avg_data,z_dir,'k','LineWidth', lw);
[PDF_x1,PDF_x2,PDF_y ] = Compute_PDF_histograms_2D(gn{2},phin{2},n_bins);
PDF_y=log10(PDF_y);
s=imagesc(ax(2),PDF_x1,PDF_x2,PDF_y);
set(s, 'AlphaData', ~isnan(PDF_y))
set(gca,'YDir','normal') 
%colormap('jet');
%s=colorbar;
%set(s,'TickLabelInterpreter','latex')
%c_max = max(max(PDF_y));%NN/Del;
%caxis([0 c_max]);
format long
%ylabel(s, '$P(l*,\Delta Z*)$','Interpreter','latex','fontsize',FZ-4)
%set(gca,'ColorScale','log')
hold on
grid off
%set(gca,'ColorScale','log')
ylabel('$\Delta Z^*$ ','Interpreter','latex','fontsize',FZ)
xlabel('$g^*$','Interpreter','latex','fontsize',FZ)
title(timestr{2}, 'Interpreter', 'latex', 'FontSize', FZ-2)
set(gca,'XMinorTick','on','YMinorTick','on')
hold off

% sub-figure 3
set(gcf,'color','w');
ax(3) = nexttile(3);
hold on
box on
c_max1 = max(size(gn{3}),[],'all');
[x1_data,avg_data] = cell_data_avg(gn{3}',phin{3}',n_bins,[min(gn{3}) max(gn{3})],1,sf);
z_dir = zeros(size(x1_data,1),1)+c_max1+1;
plot3(x1_data,avg_data,z_dir,'k','LineWidth', lw);
[PDF_x1,PDF_x2,PDF_y ] = Compute_PDF_histograms_2D(gn{3},phin{3},n_bins);
PDF_y=log10(PDF_y);
s=imagesc(ax(3),PDF_x1,PDF_x2,PDF_y);
set(s, 'AlphaData', ~isnan(PDF_y))
set(gca,'YDir','normal') 
%colormap('jet');
%s=colorbar;
%set(s,'TickLabelInterpreter','latex')
%c_max = max(max(PDF_y));%NN/Del;
%caxis([0 c_max]);
format long
%ylabel(s, '$P(l*,\Delta Z*)$','Interpreter','latex','fontsize',FZ-4)
%set(gca,'ColorScale','log')
hold on
grid off
%set(gca,'ColorScale','log')
ylabel('$\Delta Z^*$ ','Interpreter','latex','fontsize',FZ)
xlabel('$g^*$','Interpreter','latex','fontsize',FZ)
title(timestr{3}, 'Interpreter', 'latex', 'FontSize', FZ-2)
set(gca,'XMinorTick','on','YMinorTick','on')
hold off

% sub-figure 4
set(gcf,'color','w');
ax(4) = nexttile(4);
hold on
box on
c_max1 = max(size(gn{4}),[],'all');
[x1_data,avg_data] = cell_data_avg(gn{4}',phin{4}',n_bins,[min(gn{4}) max(gn{4})],1,sf);
z_dir = zeros(size(x1_data,1),1)+c_max1+1;
plot3(x1_data,avg_data,z_dir,'k','LineWidth', lw);
[PDF_x1,PDF_x2,PDF_y ] = Compute_PDF_histograms_2D(gn{4},phin{4},n_bins);
PDF_y=log10(PDF_y);
s=imagesc(ax(4),PDF_x1,PDF_x2,PDF_y);
set(s, 'AlphaData', ~isnan(PDF_y))
set(gca,'YDir','normal') 
%colormap('jet');
%s=colorbar;
%set(s,'TickLabelInterpreter','latex')
%c_max = max(max(PDF_y));%NN/Del;
%caxis([0 c_max]);
format long
%ylabel(s, '$P(l*,\Delta Z*)$','Interpreter','latex','fontsize',FZ-4)
%set(gca,'ColorScale','log')
hold on
grid off
%set(gca,'ColorScale','log')
ylabel('$\Delta Z^*$ ','Interpreter','latex','fontsize',FZ)
xlabel('$g^*$','Interpreter','latex','fontsize',FZ)
title(timestr{4}, 'Interpreter', 'latex', 'FontSize', FZ-2)
set(gca,'XMinorTick','on','YMinorTick','on')
hold off

% Set colormap and color limits for all subplots
set(ax, 'Colormap', jet)
% assign color bar to one tile 
cbh = colorbar(ax(end)); 
% To position the colorbar as a global colorbar representing
% all tiles, 
cbh.Layout.Tile = 'south'; 
set(cbh,'TickLabelInterpreter','latex');
ylabel(cbh, '$log(P(g^*,\Delta Z^*))$','fontsize',FZ,'interpreter','latex')
ylim(ax,[0 3])
xlim(ax,[0 6])
% Adjust figure properties for tight fitting
set(gcf, 'PaperPositionMode', 'auto');
%set(gca, 'LooseInset', max(get(gca, 'TightInset'), 0.02))
%saveas(figure(26),strcat(save_folder,'JointPDF_phinorm_over_gnorm.png'));
% save figure
outfname = strcat(save_folder, SubFolder{1}, 'JointPDF_phinorm_over_gnorm');
if strcmp(FigFormat, 'png')
    saveas(figure(26), strcat(outfname, '.png'), 'png');
elseif strcmp(FigFormat, 'eps')
    saveas(figure(26), strcat(outfname, '.eps'), 'epsc');
elseif strcmp(FigFormat, 'pdf')
    exportgraphics(figure(26), strcat(outfname, '.pdf'), ...
        'ContentType', 'vector');
else
    fprintf('\nInvalid figure format (%s)\n => png/eps/pdf\n', ...                                                                                                                                                                    
        FigFormat);
    return
end


%% joint pdf: T over l
%% joint pdf: Tnorm over lnorm


%%
close all


% functions
function ratio = GetDissipationRateRatio(z, nx, ny, nz, chi, ut, lt)
    
    % quenching dissipation rate
    chi_q = max(max(max(chi)));
    
    % stoichiometric dissipation rate
    chi_st = [];

    %
    disp('NEW CASE - NOT CORR');
    for i = 1:nx
        for j = 1:ny
            for k = 1:nz
                if z(i, j, k) <= ut && z(i, j, k) >= lt
                    %fprintf('\nInside: Z = %e', z(i, j, k));
                    chi_st = [chi_st, chi(i, j, k)];
                end
            end
        end
    end

    disp(length(chi_st));
    %
    mean_chi_st = mean(chi_st);

    %
    ratio = mean_chi_st / chi_q;

end


function [ PDF_x1,PDF_x2,PDF_y ] = Compute_PDF_histograms_2D(array_1,array_2,n_bins)

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

[N,X1_edges,X2_edges] = histcounts2(array1,array2,n_bins);

N_sum = sum(sum(N));

dx=X1_edges(2)-X1_edges(1);
dy=X2_edges(2)-X2_edges(1);

PDF_y = N'./N_sum/dx/dy;

PDF_x1 = 0.5*(X1_edges(1:end-1) + X1_edges(2:end));
PDF_x2 = 0.5*(X2_edges(1:end-1) + X2_edges(2:end));

PDF_y(N'==0)=NaN;

end


function [x_data, avg_data,std_data] = cell_data_avg(X,Y,n,X_lim,type,sf)
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
factor = 0.00005;
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
