clc
clear all
close all
addpath('/home/cb376114/master-thesis/ReadCIAOBinaryFiles');

%%%%%
% INPUTS
path = '/home/cb376114/p0021020/Pooria/SINGLES/COL/AIR20-DP125/';
ofname = '~/p0021020/Pooria/SINGLES/PostProcessing/OH_around_particle/figures/COL_AIR20_DP125_5subfigures.eps';
tign = 8.3; % [ms]
nfig = 5; % number of subfigures in plot
xcells = 15; % number of x-cells from particle
ycells = 15; % number of y-cells from particle
ulimit = 0.018; % colorbar
x_width = 12;
y_width = 3.5; % for 6 subplots use: 3;
%%%%%

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

% read list of variables in CIAO file
varlist  = CIAO_read_varlist(filenames{1});

% correction of xyplain
if ycells * 2 > ny
    ycells = int32(ny / 2) - 1;
    disp(ycells);
end

% font
FZ = 30;
per = 0.1;
lw = 2;
set(0, 'defaultAxesFontName', 'Times');
set(0, 'DefaultFigureRenderer', 'painters');
set(groot, 'defaultAxesTickLabelInterpreter', 'latex'); 
set(groot, 'defaultLegendInterpreter', 'latex');
set(0, 'defaultAxesFontSize', FZ);
set(0, 'DefaultLineLineWidth', lw);
set(0, 'defaultFigurePosition', [2 2 1200 380]);
close

close all
figure(1)

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
    
    OHmax = max(max(max(OH(xplain-xcells:xplain+xcells,yplain-ycells:yplain+ycells,zplain))));
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
    ax = subplot(1,nfig,fname);

    set(gcf,'color','w');
    s1=pcolor(OH(xplain-xcells:xplain+xcells,yplain-ycells:yplain+ycells,zplain));
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
        t = sprintf('t$_{ign}$+%.0fms', (fname - 1));
    end
    title(t,'fontsize',FZ,'interpreter','latex', 'FontName','Times', 'FontWeight', 'bold')
    hold on
end

% colorbar poistion
h = colorbar('southoutside');
h.Position = [0.13 0.275 0.775 0.03];
h.Ticks = [0, ulimit/6, ulimit/3, ulimit/2, ulimit/3*2, ulimit/6*5, ulimit];
h.FontName = ax.FontName;
h.FontWeight = ax.FontWeight;
h.FontSize = FZ-4;


% subfigure positions & make space for the colorbar
%for i = 1:nfig
%    subplot(1, nfig, i);
%    pos = get(gca, 'Position');
%    pos(2) = pos(2) - 0.05;
%    set(gca, 'Position', pos);
%end
ylabel(h,'Y$_\mathrm{OH} \mathrm{[-]}$','fontsize',FZ,'interpreter','latex', 'FontWeight', 'bold');
annotation('textbox', [0.815, 0.92, 0.1, 0.1], 'String', '(c) Coal', ...
           'FontSize', FZ, 'FontWeight', 'bold', 'EdgeColor', 'none', ...
           'HorizontalAlignment', 'right', 'VerticalAlignment', 'top', 'Interpreter','latex');

% save figure
%set(gcf, 'PaperUnits', 'Inches');
%set(gcf, 'PaperPosition', [0 0 x_width y_width]);
saveas(gcf,ofname, 'epsc')
hold off

cd ( home );
