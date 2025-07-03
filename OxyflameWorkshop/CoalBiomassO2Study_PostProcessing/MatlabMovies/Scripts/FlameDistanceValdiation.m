clc
clear all
close all
addpath('/home/cb376114/master-thesis/ReadCIAOBinaryFiles');
addpath('/home/cb376114/master-thesis/CIAO_PostProcessingScripts/MATLAB_scripts');

%=====
% INPUTS
%=====
% name of the output directory
subdir = "Movie_FixedParticlePostion_Contour_FlameDistanceValidation";
% initial conditions
Tpini = 300; % Initial particle temperature
%=====

home = pwd;

% path to the simulation folder (data.out files)
loc= {'~/p0021020/Pooria/SINGLES/WS/AIR20-DP125'};
loc = loc';
dp = 125e-06;

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

        CIAOgrid  = CIAO_read_grid(filename);
        xm = CIAOgrid.xm;
        ym = CIAOgrid.ym;
        zm = CIAOgrid.zm;
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
                        xplain = i;
                        yplain = j;
                        break
                    end
                end
            end
        end

        %
        xrange = 2 * 10; %ny;
        %if rem(xrange, 2) ~= 0
        %    xrange = xrange -1;
        %end
        xrange_min = xplain - xrange/2;
        xrange_max = xplain + xrange/2;
        if xrange_min < 1
            xrange_min = 1;
            xrange_max = 2*10;
        elseif xrange_max > nx
            xrange_min = nx - 2*10; % !
            xrange_max = nx;
        end

        % flame distance
        if max(OH(xplain:end,yplain,plain)) > (0.50)*YOH_abs_max
            maxOH_loc=find(OH(xplain:end,yplain,plain)==max(OH(xplain:end,yplain,plain)));
            mid_fl_loc = (xm(xplain+maxOH_loc)-xm(xplain))/dp;

            if mid_fl_loc > 10
                fl_loc = [maxOH_loc,maxOH_loc];
            elseif ((max(OH(xplain:end,yplain,plain)) - OH(xplain,yplain,plain)) < 0.001) && ((max(OH(xplain:end,yplain,plain)) - OH(end,yplain,plain)) < 0.001)
                fl_loc = [maxOH_loc,maxOH_loc];
            else
                fl_loc=find(OH(xplain:end,yplain,plain)>0.7*max(OH(xplain:end,yplain,plain)));
            end
            
            if fl_loc(end) >= 10
                fl_loc = [maxOH_loc,maxOH_loc];
            end
            min_fl_loc = (xm(xplain+fl_loc(1))-xm(xplain))/dp;
            max_fl_loc = (xm(xplain+fl_loc(end))-xm(xplain))/dp;
        else
            mid_fl_loc = 0;
            max_fl_loc = 0;
            min_fl_loc = 0;
        end

        %=====
        % Y_OH
        %=====
        FZ = 22;
        lw = 1.5;
        set(0, 'defaultAxesFontName','Times');
        set(0, 'DefaultFigureRenderer', 'painters');
        set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
        set(groot, 'defaultLegendInterpreter','latex');
        set(0, 'defaultAxesFontSize', FZ);
        set(0, 'DefaultLineLineWidth', lw);
        close

        figure(1)
        threshold = 0.7 * YOH_abs_max;
        set(gcf,'color','w','visible','off');
        hold on;
        ax1 = nexttile(1);
        s1=pcolor(OH(xrange_min:xrange_max,:,plain));
        shading flat;
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
        [nRows, nCols, ~] = size(OH(xrange_min:xrange_max,:,plain));
        [X, Y] = meshgrid(1:nCols, 1:nRows);
        hold on
        contour(X, Y, OH(xrange_min:xrange_max,:,plain), [threshold threshold], 'LineColor', 'k', 'LineWidth', lw);
        hold on
        % particle position
        %rectangle('Position', [yplain, xplain-xrange_min+1, 1, 1], 'EdgeColor', 'black');
        plot(yplain, xplain-xrange_min+1, 'ks', 'MarkerSize', 5, 'LineWidth', 2);
        hold on
        % min
        if min_fl_loc ~= 0
            r = min_fl_loc;
            z_plain_data = OH(xrange_min:xrange_max,:,plain);
            theta = linspace(0, 2*pi, 25);
            circ_x = yplain + r * cos(theta);
            circ_y = xplain-xrange_min+1 + r * sin(theta);
            circ_z = z_plain_data(xplain-xrange_min+1, yplain) * ones(size(circ_x));
            plot3(circ_x, circ_y, circ_z, 'Color', 'white', 'LineWidth', 1);
            hold on
        end
        %mid
        if mid_fl_loc ~= 0
            r = mid_fl_loc;
            z_plain_data = OH(xrange_min:xrange_max,:,plain);
            theta = linspace(0, 2*pi, 25);
            circ_x = yplain + r * cos(theta);
            circ_y = xplain-xrange_min+1 + r * sin(theta);
            circ_z = z_plain_data(xplain-xrange_min+1, yplain) * ones(size(circ_x));
            plot3(circ_x, circ_y, circ_z, 'Color', 'white', 'LineWidth', 1);
            hold on
        end
        %max
        if max_fl_loc ~= 0
            r = max_fl_loc;
            z_plain_data = OH(xrange_min:xrange_max,:,plain);
            theta = linspace(0, 2*pi, 25);
            circ_x = yplain + r * cos(theta);
            circ_y = xplain-xrange_min+1 + r * sin(theta);
            circ_z = z_plain_data(xplain-xrange_min+1, yplain) * ones(size(circ_x));
            plot3(circ_x, circ_y, circ_z, 'Color', 'white', 'LineWidth', 1);
        end
        set(gca, 'XDir','reverse');
        hold off
    
        file_time = sprintf('%02i', fname);
        fig_name = subdir + "/Movie_YOH_Frame_" + file_time;
        saveas(gcf,fig_name,'png');
    
        %=====
        % Tgas
        %=====
        FZ = 22;
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
        %threshold = 0.7 * max(max(max(Tgas(xrange_min:xrange_max,:,plain))));
        threshold = 0.7 * Tgas_abs_max;
        set(gcf,'color','w','visible','off');
        ax2 = nexttile(1);
        s1=pcolor(Tgas(xrange_min:xrange_max,:,plain));
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
        [nRows, nCols, ~] = size(Tgas(xrange_min:xrange_max,:,plain));
        [X, Y] = meshgrid(1:nCols, 1:nRows);
        hold on
        contour(X, Y, Tgas(xrange_min:xrange_max,:,plain), [threshold threshold], 'LineColor', 'k', 'LineWidth', lw);
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
