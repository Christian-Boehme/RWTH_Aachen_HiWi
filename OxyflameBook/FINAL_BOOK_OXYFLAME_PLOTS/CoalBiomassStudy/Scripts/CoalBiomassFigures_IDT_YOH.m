clc
clear all
close all
addpath('/home/cb376114/Programs/Others/Matlab2Tikz/src');
addpath('/home/cb376114/Programs/Others/ReadCIAOBinaryFiles');

% true = save as tikz; false = save as png
UseTikz = false;

format = 'eps';
%
outfname = 'CoalBiomassFigures/Figure_IDT_YOH_manually';

% global fonts
FZ = 25;
lw = 1;
set(0, 'defaultAxesFontName', 'Times');
set(0, 'DefaultFigureRenderer', 'painters');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex'); 
set(groot, 'defaultLegendInterpreter', 'latex');
set(0, 'defaultAxesFontSize', FZ);
set(0, 'DefaultLineLineWidth', lw);
set(gca, 'TickLabelInterpreter', 'latex');
set(0, 'defaultFigurePosition', [2 2 1400 1200]); %[2 2 700 500]);
close



%==========
% IDT Coal
%==========

%====
% INPUTS
ifname_sim = '~/NHR/Pooria/SINGLES/PostProcessing/IDT/Data/Simulations/Sim_IDT_Coal_AIR20.txt';
ifname_exp1 = '~/NHR/Pooria/SINGLES/PostProcessing/IDT/Data/IDT_TaoLi/AIR20_C1.csv';
ifname_exp2 = '~/NHR/Pooria/SINGLES/PostProcessing/IDT/Data/IDT_TaoLi/AIR20_C2.csv';
ifname_exp3 = '~/NHR/Pooria/SINGLES/PostProcessing/IDT/Data/IDT_TaoLi/AIR20_C3.csv';
ofname = 'CoalBiomassFigures/IDTValidationCoal';
markerSize = 75;
markerSizeSim = 10;
alphaValue = 0.5;
markerColor1 = '#add8e6';
markerColor2 = '#6495ed';
markerColor3 = '#90ee90';
markerEdgeColor = 'black';
MarkerFaceColorSim = '#e31a1c';
%====

% data
xSim  = readtable(ifname_sim).Var1;
ySim  = readtable(ifname_sim).Var2;
xExp1 = readtable(ifname_exp1).Var1;
yExp1 = readtable(ifname_exp1).Var2;
xExp2 = readtable(ifname_exp2).Var1;
yExp2 = readtable(ifname_exp2).Var2;
xExp3 = readtable(ifname_exp3).Var1;
yExp3 = readtable(ifname_exp3).Var2;

% create figure
%close all
%Fig1 = figure;
figure;
set(gcf,'color','w');

t = tiledlayout(2, 12);
% Adjust tile spacing and row height
t.TileSpacing = 'none';
t.Padding = 'tight';
%xmin = 0.01;
%ymin = 0.01;
%t.OuterPosition = [xmin, ymin, 0.99, 0.80];
%t.Padding = [0.1, 0.5];
%t.RowHeight = {'1x', '2x'};

nexttile([1, 5]);
%subplot(2,10,1);
%set(gcf,'color','w');
scatter(xExp1, yExp1, markerSize, 'filled', 'MarkerFaceColor', ...
    markerColor1, 'MarkerEdgeColor', markerEdgeColor, ...
    'MarkerFaceAlpha',alphaValue, 'MarkerEdgeAlpha', alphaValue, ...
    'DisplayName', 'Exp. $\overline{D}_\mathrm{p}=107\mathrm{\mu m}$');
hold on
scatter(xExp2, yExp2, markerSize, 'filled', 'MarkerFaceColor', ...
    markerColor2, 'MarkerEdgeColor', markerEdgeColor, ...
    'MarkerFaceAlpha',alphaValue, 'MarkerEdgeAlpha', alphaValue, ...
    'DisplayName', 'Exp. $\overline{D}_\mathrm{p}=126\mathrm{\mu m}$');
hold on
scatter(xExp3, yExp3, markerSize, 'filled', 'MarkerFaceColor', ...
    markerColor3, 'MarkerEdgeColor', markerEdgeColor, ...
    'MarkerFaceAlpha', alphaValue, 'MarkerEdgeAlpha', alphaValue, ...
    'DisplayName', 'Exp. $\overline{D}_\mathrm{p}=183\mathrm{\mu m}$');
hold on
plot(xSim, ySim, '-s', 'MarkerFaceColor', MarkerFaceColorSim, ...
    'MarkerSize', markerSizeSim, 'LineWidth', lw+1, 'Color', ...
    '#e31a1c', 'DisplayName', 'Sim.');
hold on

xlim([80 200]);
ylim([0 25]);
xtick_positions = linspace(80, 200, 7);
set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
ytick_positions = linspace(0, 25, 6);
set(gca, 'YTick', ytick_positions, 'LineWidth', lw);

ylabel('$\tau_\mathrm{ign} \mathrm{[ms]}$', 'fontsize', FZ, ...
    'interpreter', 'latex', 'FontName', 'Times', 'FontWeight', 'bold');
xlabel('D$_\mathrm{p} \mathrm{[\mu m]}$', 'fontsize', FZ, ...
    'interpreter', 'latex', 'FontWeight', 'bold');
legend('show', 'Interpreter', 'latex', 'Location', 'northwest', 'Box', ...
    'off', 'fontsize', FZ);
title('(a) Coal', 'Interpreter', 'latex', 'FontSize', FZ, ...
    'FontWeight', 'bold');
%text(165, 22, '(a) Coal', 'Interpreter', 'latex', 'FontSize', FZ, ...
%    'FontWeight', 'bold');
set(gca, 'Box', 'on');

% save figure
%if UseTikz
%    matlab2tikz(strcat(ofname, '.tikz'));
%else
%    saveas(gcf, strcat(ofname, '.png'), 'png');
%end



%==========
% IDT Biomass
%==========

%====
% INPUTS
ifname_sim = '~/NHR/Pooria/SINGLES/PostProcessing/IDT/Data/Simulations/Sim_IDT_WS_AIR20.txt';
ifname_exp1 = '~/NHR/Pooria/SINGLES/PostProcessing/IDT/Data/IDT_TaoLi/AIR20_W1.csv';
ifname_exp2 = '~/NHR/Pooria/SINGLES/PostProcessing/IDT/Data/IDT_TaoLi/AIR20_W2.csv';
ifname_exp3 = '~/NHR/Pooria/SINGLES/PostProcessing/IDT/Data/IDT_TaoLi/AIR20_W3.csv';
ofname = 'CoalBiomassFigures/IDTValidationWS';
markerSize = 75;
markerSizeSim = 10;
alphaValue = 0.5;
markerColor1 = '#ffa500';
markerColor2 = '#0d98ba';
markerColor3 = '#800080';
markerEdgeColor = 'black';
MarkerFaceColorSim = '#e31a1c';
%====

% data
xSim  = readtable(ifname_sim).Var1;
ySim  = readtable(ifname_sim).Var2;
xExp1 = readtable(ifname_exp1).Var1;
yExp1 = readtable(ifname_exp1).Var2;
xExp2 = readtable(ifname_exp2).Var1;
yExp2 = readtable(ifname_exp2).Var2;
xExp3 = readtable(ifname_exp3).Var1;
yExp3 = readtable(ifname_exp3).Var2;

% create figure
set(0, 'defaultAxesFontName', 'Times');
set(0, 'DefaultFigureRenderer', 'painters');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex'); 
set(groot, 'defaultLegendInterpreter', 'latex');
set(0, 'defaultAxesFontSize', FZ);
set(0, 'DefaultLineLineWidth', lw);
set(gca, 'TickLabelInterpreter', 'latex');
%close all
%Fig2 = figure;


%subplot(2,10,2);
nexttile([1, 2]);
axis off;
nexttile([1, 5]);
%set(gcf,'color','w');
scatter(xExp1, yExp1, markerSize, 'filled', 'MarkerFaceColor', ...
    markerColor1, 'MarkerEdgeColor', markerEdgeColor, ...
    'MarkerFaceAlpha', alphaValue, 'MarkerEdgeAlpha', alphaValue, ...
    'DisplayName', 'Exp. $\overline{D}_\mathrm{p}=127\mathrm{\mu m}$');
hold on
scatter(xExp2, yExp2, markerSize, 'filled', 'MarkerFaceColor', ...
    markerColor2, 'MarkerEdgeColor', markerEdgeColor, ...
    'MarkerFaceAlpha', alphaValue, 'MarkerEdgeAlpha', alphaValue, ...
    'DisplayName', 'Exp. $\overline{D}_\mathrm{p}=152\mathrm{\mu m}$');
hold on
scatter(xExp3, yExp3, markerSize, 'filled', 'MarkerFaceColor', ...
    markerColor3, 'MarkerEdgeColor', markerEdgeColor, ...
    'MarkerFaceAlpha', alphaValue, 'MarkerEdgeAlpha', alphaValue, ...
    'DisplayName', 'Exp. $\overline{D}_\mathrm{p}=182\mathrm{\mu m}$');
    %'HandleVisibility', 'off');
hold on
% % dummy for legend (same marker size)
% plot(NaN, NaN, '-o', 'MarkerFaceColor', markerColor3Legend, ...
%     'MarkerSize', 10, 'LineWidth', 1, 'Color', 'white', ...
%     'DisplayName', 'Exp. $\overline{D}_\mathrm{p}=182\mathrm{\mu m}$');
% hold on
plot(xSim, ySim, '-s', 'MarkerFaceColor', MarkerFaceColorSim, ...
    'MarkerSize', markerSizeSim, 'LineWidth', lw+1, 'Color', ...
    '#e31a1c', 'DisplayName', 'Sim.');
hold on

xlim([80 200]);
ylim([0 25]);
xtick_positions = linspace(80, 200, 7);
set(gca, 'XTick', xtick_positions, 'LineWidth', lw);
ytick_positions = linspace(0, 25, 6);
set(gca, 'YTick', ytick_positions, 'LineWidth', lw);

ylabel('$\tau_\mathrm{ign} \mathrm{[ms]}$', 'fontsize', FZ, ...
    'interpreter', 'latex', 'FontWeight', 'bold');
xlabel('D$_\mathrm{p} \mathrm{[\mu m]}$', 'fontsize', FZ, ...
    'interpreter', 'latex', 'FontWeight', 'bold');
legend('show', 'Interpreter', 'latex', 'Location', 'northwest', ...
    'Box', 'off', 'fontsize', FZ);
% same marker size as in figure
%legendMarkers = findobj(lgd, 'Type', 'patch');
%set(legendMarkers, 'MarkerSize', 2);

title('(b) WS', 'Interpreter', 'latex', 'FontSize', FZ, ...
    'FontWeight', 'bold');
%text(165, 22, '(b) WS', 'Interpreter', 'latex', 'FontSize', FZ, ...
%    'FontWeight', 'bold');
set(gca, 'Box', 'on');

% save figure
%if UseTikz
%    matlab2tikz(strcat(ofname, '.tikz'));
%else
%    saveas(gcf, strcat(ofname, '.png'), 'png');
%end

%saveas(gcf, strcat(outfname, '.png'), 'png');


% empty row
%nexttile([1 12]);
%axis off;


%==========
% YOH around particle - Coal
%==========

%====
% INPUTS
path = '~/NHR/Pooria/SINGLES/COL/AIR20-DP125/';
ofname = 'CoalBiomassFigures/COL_AIR20_DP125_5subfigures';
tign = 8.3; % [ms]
nfig = 5; % number of subfigures in plot
xcells = 15; % number of x-cells from particle
ycells = 15; % number of y-cells from particle
ulimit = 0.018; % colorbar
x_width = 12;
y_width = 3.5; % for 6 subplots use: 3;
%====

% read in data.out files
dirFiles = dir(fullfile(path, 'data.out_*'));
files = {dirFiles.name};

% sort files numerically
filenum = cellfun(@(x)sscanf(x, 'data.out_%e'), files);
[~,Sidx] = sort(filenum);
filenames_ = files(Sidx);

% clipp files
counter = 0;
filenames = {};
numfile = sort(filenum);
for i = 2:2:length(filenames_)
    %for i = 1:length(filenames_)
    if numfile(i) >= tign/1000
        counter = counter + 1;
        filenames{counter} = filenames_{i};
    end
end

% working directory
home = pwd;

% path directory
cd ( path );

% grid
grid  = CIAO_read_grid(filenames{1});
xm = grid.xm;
ym = grid.ym;
zm = grid.zm;
nx = size(xm,1);
ny = size(ym,1);
nz = size(zm,1);

% correction of xyplain
if ycells * 2 > ny
    ycells = int32(ny / 2) - 1;
    disp(ycells);
end

% font
%FZ = 20;
set(0, 'defaultAxesFontName', 'Times');
set(0, 'DefaultFigureRenderer', 'painters');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex'); 
set(groot, 'defaultLegendInterpreter', 'latex');
set(0, 'defaultAxesFontSize', FZ);
set(0, 'DefaultLineLineWidth', lw);
set(gca, 'TickLabelInterpreter', 'latex');
%set(0, 'defaultFigurePosition', [2 2 1200 380]);
%close

% create figure
%close all
%Fig3 = figure; %(1)

%subplot(2,10,3);
%set(gcf,'color','w');
globalOHmax = 0;
for fname = 1:nfig
    files = dir(fullfile(path, filenames{fname}));
    filename = files(1).name;

    % read data
    OH = CIAO_read_real(filename,'OH');
    ND_COAL = CIAO_read_real(filename,'ND_COAL');
    time(1) = CIAO_read_real(filename,'time');

    % particle must be in front!
    xplain = 1;
    yplain = 1;
    zplain = 1;
    % particle-plain
    for i = 1:nx
        for j = 1:ny
            for k = 1:nz
                if ND_COAL(i,j,k) == 1
                    xplain = i;
                    yplain = j;
                    zplain = k;
                    break
                end
            end
        end
    end
    
    OHmax = max(max(max(OH(xplain-xcells:xplain+xcells, ...
        yplain-ycells:yplain+ycells,zplain))));
    if globalOHmax < OHmax
        globalOHmax = OHmax;
    end
end

% generate plots for each file/time
for fname = 1:nfig
    fprintf('%s\n', filenames{fname});
    files = dir(fullfile(path, filenames{fname}));
    filename = files(1).name;

    % read data
    OH = CIAO_read_real(filename,'OH');
    ND_COAL = CIAO_read_real(filename,'ND_COAL');
    time(1) = CIAO_read_real(filename,'time');

    % particle must be in front!
    xplain = 1;
    yplain = 1;
    zplain = 1;
    % particle-plain
    for i = 1:nx
        for j = 1:ny
            for k = 1:nz
                if ND_COAL(i,j,k) == 1
                    xplain = i;
                    yplain = j;
                    zplain = k;
                    break
                end
            end
        end
    end

    % create figure
    ax = nexttile; %subplot(2,10,2+fname); %subplot(1,nfig,fname);
    if fname == 1
        cpos = ax.Position;
    end

    set(gcf,'color','w');
    s1=pcolor(OH(xplain-xcells:xplain+xcells, ...
        yplain-ycells:yplain+ycells,zplain));
    colormap(ax,jet);
    caxis(ax, [0 ulimit]); %1.1*globalOHmax]);
    %cb = colorbar;
    %cb.Ticks = [0, ulimit/2, ulimit];
    s1.FaceColor = 'interp';
    set(s1,'edgecolor','none');
    axis image
    set(gca,'xtick',[])
    set(gca,'ytick',[])
    set(gca,'TickLabelInterpreter','latex');
    camroll(-90);
    if fname == 1
        t = sprintf('t$_{ign}$');
    else
        t = sprintf('+%.0fms', (fname - 1));
    end
    title(t,'fontsize' ,FZ, 'interpreter', 'latex', 'FontName', ...
        'Times', 'FontWeight', 'bold')
    hold on
end

% colorbar poistion
h = colorbar('southoutside');
%set(h, 'FontName', 'Times', 'FontSize', FZ-5); %, 'FontWeight', 'bold');
h.Position = [cpos(1) cpos(2)+cpos(4)/4 cpos(3)*5 0.02];
h.Ticks = [0, ulimit/6, ulimit/3, ulimit/2, ulimit/3*2, ulimit/6*5, ...
    ulimit];
h.TickLabelInterpreter = 'latex';
h.FontName = 'Times';
h.FontSize = FZ - 4;
%h.FontName = ax.FontName;
%h.FontWeight = ax.FontWeight;
%h.FontSize = FZ-4;


% subfigure positions & make space for the colorbar
%for i = 1:nfig
%    subplot(1, nfig, i);
%    pos = get(gca, 'Position');
%    pos(2) = pos(2) - 0.05;
%    set(gca, 'Position', pos);
%end
ylabel(h,'Y$_\mathrm{OH} \mathrm{[-]}$', 'fontsize', FZ, ...
    'interpreter', 'latex', 'FontWeight', 'bold');
%annotation('textbox', [0.815, 0.92, 0.1, 0.1], 'String', '(c) Coal', ...
%           'FontSize', FZ, 'FontWeight', 'bold', 'EdgeColor', 'none', ...
%           'HorizontalAlignment', 'right', 'VerticalAlignment', ...
%           'top', 'Interpreter','latex');

% save figure
cd ( home );
%if UseTikz
%    matlab2tikz(strcat(ofname, '.tikz'));
%else
%    saveas(gcf, strcat(ofname, '.png'), 'png');
%end
%hold off
%saveas(gcf, strcat(outfname, '.png'), 'png');


nexttile([1 2]);
axis off;
%==========
% YOH around particle - Biomass
%==========


%====
% INPUTS
path = '~/NHR/Pooria/SINGLES/WS/AIR20-DP125/';
ofname = '~/NHR/Pooria/SINGLES/PostProcessing/OH_around_particle/figures/WS_AIR20_DP125_5subfigures';
tign = 7.4; % [ms]
nfig = 5; % number of subfigures in plot
xcells = 15; % number of x-cells from particle
ycells = 15; % number of y-cells from particle
ulimit = 0.018; % colorbar
x_width = 12;
y_width = 3.5; % for 6 subplots use: 3;
%====

% read in data.out files
dirFiles = dir(fullfile(path, 'data.out_*'));
files = {dirFiles.name};

% sort files numerically
filenum = cellfun(@(x)sscanf(x, 'data.out_%e'), files);
[~,Sidx] = sort(filenum);
filenames_ = files(Sidx);

% clipp files
counter = 0;
filenames = {};
numfile = sort(filenum);
for i = 2:2:length(filenames_)
    %for i = 1:length(filenames_)
    if numfile(i) >= tign/1000
        counter = counter + 1;
        filenames{counter} = filenames_{i};
    end
end

% working directory
home = pwd;

% path directory
cd ( path );

% grid
grid  = CIAO_read_grid(filenames{1});
xm = grid.xm;
ym = grid.ym;
zm = grid.zm;
nx = size(xm,1);
ny = size(ym,1);
nz = size(zm,1);

% correction of xyplain
if ycells * 2 > ny
    ycells = int32(ny / 2) - 1;
    disp(ycells);
end

% font
%FZ = 30;
set(0, 'defaultAxesFontName', 'Times');
set(0, 'DefaultFigureRenderer', 'painters');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex'); 
set(groot, 'defaultLegendInterpreter', 'latex');
set(0, 'defaultAxesFontSize', FZ);
set(0, 'DefaultLineLineWidth', lw);
set(gca, 'TickLabelInterpreter', 'latex');
%close

% create figure
%close all
%Fig4 = figure; %(1)

%subplot(2,2,4);
%set(gcf,'color','w');
globalOHmax = 0;
for fname = 1:nfig
    files = dir(fullfile(path, filenames{fname}));
    filename = files(1).name;

    % read data
    OH = CIAO_read_real(filename,'OH');
    ND_COAL = CIAO_read_real(filename,'ND_COAL');
    time(1) = CIAO_read_real(filename,'time');

    % particle must be in front!
    xplain = 1;
    yplain = 1;
    zplain = 1;
    % particle-plain
    for i = 1:nx
        for j = 1:ny
            for k = 1:nz
                if ND_COAL(i,j,k) == 1
                    xplain = i;
                    yplain = j;
                    zplain = k;
                    break
                end
            end
        end
    end
    
    OHmax = max(max(max(OH(xplain-xcells:xplain+xcells, ...
        yplain-ycells:yplain+ycells,zplain))));
    if globalOHmax < OHmax
        globalOHmax = OHmax;
    end
end

% generate plots for each file/time
for fname = 1:nfig
    fprintf('%s\n', filenames{fname});
    files = dir(fullfile(path, filenames{fname}));
    filename = files(1).name;

    % read data
    OH = CIAO_read_real(filename,'OH');
    ND_COAL = CIAO_read_real(filename,'ND_COAL');
    time(1) = CIAO_read_real(filename,'time');

    % particle must be in front!
    xplain = 1;
    yplain = 1;
    zplain = 1;
    % particle-plain
    for i = 1:nx
        for j = 1:ny
            for k = 1:nz
                if ND_COAL(i,j,k) == 1
                    xplain = i;
                    yplain = j;
                    zplain = k;
                    break
                end
            end
        end
    end

    % create figure
    ax = nexttile; %subplot(2,10,7+fname); %subplot(1,nfig,fname);
    if fname == 1
        cpos = ax.Position;
    end

    set(gcf,'color','w');
    s1=pcolor(OH(xplain-xcells:xplain+xcells, ...
        yplain-ycells:yplain+ycells,zplain));
    colormap(ax,jet);
    caxis(ax, [0 ulimit]); %1.1*globalOHmax]);
    %cb = colorbar;
    %cb.Ticks = [0, ulimit/2, ulimit];
    s1.FaceColor = 'interp';
    set(s1,'edgecolor','none');
    axis image
    set(gca,'xtick',[])
    set(gca,'ytick',[])
    set(gca,'TickLabelInterpreter','latex');
    set(gca, 'FontName', 'Times');
    camroll(-90);
    if fname == 1
        t = sprintf('t$_{ign}$');
    else
        t = sprintf('+%.0fms', (fname - 1));
    end
    title(t,'fontsize', FZ, 'interpreter', 'latex', 'FontName', ...
        'Times', 'FontWeight', 'bold')
    hold on
end

% colorbar position
h = colorbar('southoutside');
%set(h, 'FontName', 'Times', 'FontSize', FZ-5); %, 'FontWeight', 'bold');
%set(h, 'FontWeight', 'bold');
h.Position = [cpos(1) cpos(2)+cpos(4)/4 cpos(3)*5 0.02];
h.Ticks = [0, ulimit/6, ulimit/3, ulimit/2, ulimit/3*2, ulimit/6*5, ...
    ulimit];
h.TickLabelInterpreter = 'latex';
h.FontName = 'Times';
h.FontSize = FZ - 4;
%h.FontName = 'Times'; %ax.FontName;
%disp(ax.Fontname);
%h.FontWeight = 'bold'; %ax.FontWeight;
%h.FontSize = FZ-4;


% subfigure positions & make space for the colorbar
%for i = 1:nfig
%    subplot(1, nfig, i);
%    pos = get(gca, 'Position');
%    pos(2) = pos(2) - 0.05;
%    set(gca, 'Position', pos);
%end
ylabel(h,'Y$_\mathrm{OH} \mathrm{[-]}$', 'fontsize', FZ, ...
    'interpreter', 'latex', 'FontWeight', 'bold', 'FontName', 'Times');
%annotation('textbox', [0.815, 0.92, 0.1, 0.1], 'String', '(d) WS', ...
%           'FontSize', FZ, 'FontWeight', 'bold', 'EdgeColor', 'none', ...
%           'HorizontalAlignment', 'right', 'VerticalAlignment', ...
%           'top', 'Interpreter','latex');

% save figure
cd ( home );
%if UseTikz
%    matlab2tikz(strcat(ofname, '.tikz'));
%else
%    saveas(gcf, strcat(ofname, '.png'), 'png');
%end
%hold off
%close(Fig4);

%
%mainFig = figure;
%subplot(2,2,1);
%copyobj(allchild(get(Fig1, 'CurrentAxes')), gca);
%subplot(2,2,2);
%copyobj(allchild(get(Fig2, 'CurrentAxes')), gca);
%subplot(2,2,3);
%copyobj(allchild(get(Fig3, 'CurrentAxes')), gca);
%subplot(2,2,4);
%copyobj(allchild(get(Fig4, 'CurrentAxes')), gca);

if UseTikz
    matlab2tikz(strcat(outfname, '.tikz'));
else
    if strcmp(format, 'png')
        saveas(gca, strcat(outfname, '.png'), 'png');
    else
        saveas(gca, strcat(outfname, '.eps'), 'epsc');
        %exportgraphics(gca, strcat(outfname, '.pdf'), 'ContentType', 'vector');
    end
end
