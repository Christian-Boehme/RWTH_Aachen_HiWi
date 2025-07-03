clc
clear all
close all
addpath('/home/cb376114/master-thesis/ReadCIAOBinaryFiles');
addpath('/home/cb376114/master-thesis/CIAO_PostProcessingScripts/MATLAB_scripts');

%=====
% INPUTS
%=====
% name of the output directory
subdir = "Movie_FullDomain";
% initial conditions
Tpini = 300; % Initial particle temperature
%=====

home = pwd;

% path to the simulation folder (data.out files)
loc= {'~/p0021020/Pooria/SINGLES/COL/AIR10-DP125'; 
    '~/p0021020/Pooria/SINGLES/COL/AIR20-DP90'; 
    '~/p0021020/Pooria/SINGLES/COL/AIR20-DP90-GRID125'; 
    '~/p0021020/Pooria/SINGLES/COL/AIR20-DP125'; 
    '~/p0021020/Pooria/SINGLES/COL/AIR20-DP160'; 
    '~/p0021020/Pooria/SINGLES/COL/AIR20-DP160-GRID125'; 
    '~/p0021020/Pooria/SINGLES/COL/AIR40-DP125'; 
    '~/p0021020/Pooria/SINGLES/COL/OXY20-DP90'; 
    '~/p0021020/Pooria/SINGLES/COL/OXY20-DP125'; 
    '~/p0021020/Pooria/SINGLES/COL/OXY20-DP160'; 
    '~/p0021020/Pooria/SINGLES/WS/AIR10-DP125'; 
    '~/p0021020/Pooria/SINGLES/WS/AIR20-DP90'; 
    '~/p0021020/Pooria/SINGLES/WS/AIR20-DP90-GRID125'; 
    '~/p0021020/Pooria/SINGLES/WS/AIR20-DP125'; 
    '~/p0021020/Pooria/SINGLES/WS/AIR20-DP160'; 
    '~/p0021020/Pooria/SINGLES/WS/AIR20-DP160-GRID125'; 
    '~/p0021020/Pooria/SINGLES/WS/AIR40-DP125'; 
    '~/p0021020/Pooria/SINGLES/WS/OXY20-DP90'; 
    '~/p0021020/Pooria/SINGLES/WS/OXY20-DP125'; 
    '~/p0021020/Pooria/SINGLES/WS/OXY20-DP160'};

loc = loc';

%
for path = 1:length(loc)

    location = loc{path};
    disp(location);
    cd ( location )

    % create subdir folder
    if not(isfolder(subdir))
        mkdir(subdir)
    end

    % read in data.out files
    dirFiles = dir(fullfile(location, 'data.out_*'));
    files = {dirFiles.name};

    % sort files numerically
    filenum = cellfun(@(x)sscanf(x, 'data.out_%e'), files);
    [~,Sidx] = sort(filenum) ;
    filenames = files(Sidx);

    % determine max variable (upper limit)
    for fname = 1:length(filenames)
        files = dir(fullfile(location, filenames{fname}));
        filename = files(1).name;

        % read data
        OH = CIAO_read_real(filename,'OH');
        Tgas = CIAO_read_real(filename,'T');
      
        %=====
        % Y_OH
        %=====
        if fname == 1
            YOH_abs_min = 0;
            YOH_abs_max = 0;
        end
        YOH_min = min(min(min(OH)));
        YOH_max = max(max(max(OH)));
        if YOH_min < YOH_abs_min
            YOH_abs_min = YOH_min;
        end
        if YOH_max > YOH_abs_max
            YOH_abs_max = YOH_max;
        end
    
        %=====
        % Tgas
        %=====
        if fname == 1
            Tgas_abs_min = Tpini;
            Tgas_abs_max = 0;
        end
        Tgas_min = min(min(min(Tgas)));
        Tgas_max = max(max(max(Tgas)));
        if Tgas_min < Tgas_abs_min
            Tgas_abs_min = Tgas_min;
        end
        if Tgas_max > Tgas_abs_max
            Tgas_abs_max = Tgas_max;
        end

    end

    fprintf('\nYOH_min  = %e and YOH_max  = %e', YOH_abs_min, YOH_abs_max);
    fprintf('\nTgas_min = %e and Tgas_max = %e\n', Tgas_abs_min, Tgas_abs_max);

    % generate plots for each file/time
    for fname = 1:length(filenames)
        fprintf('%s\n', filenames{fname});
        files = dir(fullfile(location, filenames{fname}));
        filename = files(1).name;

        grid  = CIAO_read_grid(filename);
        xm = grid.xm;
        ym = grid.ym;
        zm = grid.zm;
        nx = size(xm,1);
        ny = size(ym,1);
        nz = size(zm,1);

        % read data
        time(1) = CIAO_read_real(filename,'time');
        OH = CIAO_read_real(filename,'OH');
        Tgas = CIAO_read_real(filename,'T');
        ND_COAL = CIAO_read_real(filename,'ND_COAL');

        [time_1,ii] = sort(time);
        time = time_1;
        clear time_1

        plot_time = num2str(time * 1E+3, "%.2f");

        % particle must be in front!
        plain = 1;
        % particle-plain
        for i = 1:nx
            for j = 1:ny
                for k = 1:nz
                    if ND_COAL(i,j,k) == 1
                        plain = k;
                        break
                    end
                end
            end
        end    
    
        %=====
        % Y_OH
        %=====
        FZ = 22;
        per = 0.1;
        lw = 1.5;
        set(0, 'defaultAxesFontName','Times');
        set(0, 'DefaultFigureRenderer', 'painters');
        set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
        set(groot, 'defaultLegendInterpreter','latex');
        set(0, 'defaultAxesFontSize', FZ);
        set(0, 'DefaultLineLineWidth', lw);
        close
        % close all
        figure(1)
        set(gcf,'color','w','visible','off');
        ax1 = nexttile(1);
        s1=pcolor(OH(:,:,plain));
        colormap(ax1,jet)
        s1.FaceColor = 'interp';
        set(s1,'edgecolor','none');
        axis image
        set(gca,'xtick',[])
        set(gca,'ytick',[])
        set(gca,'TickLabelInterpreter','latex');
        camroll(90);
        cb1=colorbar('southoutside'); 
        caxis(ax1, [0 YOH_abs_max]);
        ylabel(cb1, '$Y_{OH} [-]$','fontsize',FZ,'interpreter','latex')
        title(['t = ' plot_time 'ms'], 'FontSize', FZ, 'interpreter', 'latex')
        set(gca, 'XDir','reverse');
        hold off
    
        file_time = sprintf('%02i', fname);
        fig_name = subdir + "/Movie_YOH_Frame_" + file_time;
        saveas(gcf,fig_name,'png');
    
        %=====
        % Tgas
        %=====
        FZ = 22;
        per = 0.1;
        lw = 1.5;
        set(0, 'defaultAxesFontName','Times');
        set(0, 'DefaultFigureRenderer', 'painters');
        set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
        set(groot, 'defaultLegendInterpreter','latex');
        set(0, 'defaultAxesFontSize', FZ);
        set(0, 'DefaultLineLineWidth', lw);
        close
        close all
        figure(1)
        set(gcf,'color','w','visible','off');
        ax2 = nexttile(1);
        s1=pcolor(Tgas(:,:,plain));
        colormap(ax2,hot)
        s1.FaceColor = 'interp';
        set(s1,'edgecolor','none');
        axis image
        set(gca,'xtick',[])
        set(gca,'ytick',[])
        set(gca,'TickLabelInterpreter','latex');
        camroll(90);
        cb2=colorbar('southoutside');
        caxis(ax2, [Tpini Tgas_abs_max]);
        ylabel(cb2,'$T_{gas} [K]$','fontsize',FZ,'interpreter','latex')
        title(['t = ' plot_time 'ms'], 'FontSize', FZ, 'interpreter', 'latex')
        set(gca, 'XDir','reverse');
        hold off
    
        file_time = sprintf("%02i", fname);
        fig_name = subdir + "/Movie_Tgas_Frame_" + file_time;
        saveas(gcf,fig_name,'png');
    
    end

    %=====
    % create movie
    %=====

    cd (subdir)
    YOH_files  = dir('Movie_YOH_Frame_*');
    Tgas_files = dir('Movie_Tgas_Frame_*');

    % create video - YOH
    v_YOH = VideoWriter('YOH.avi', 'Uncompressed AVI');
    v_YOH.FrameRate = 5;
    open(v_YOH);
    for YOH_file = 1:length(YOH_files)
        A = imread(YOH_files(YOH_file).name);
        writeVideo(v_YOH,A)
    end
    close(v_YOH);

    % create video - Tgas
    v_Tgas = VideoWriter('Tgas.avi', 'Uncompressed AVI');
    v_Tgas.FrameRate = 5;
    open(v_Tgas);
    for Tgas_file = 1:length(Tgas_files)
        A = imread(Tgas_files(Tgas_file).name);
        writeVideo(v_Tgas,A)
    end
    close(v_Tgas);

end

cd( home )
