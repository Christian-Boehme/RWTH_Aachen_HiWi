clc
clear all
close all
addpath('/home/cb376114/master-thesis/ReadCIAOBinaryFiles');

% input: path
loc = '~/p0021020/Pooria/SINGLES/WS/CHRISTIAN_AIR20-DP125';
% input: particle diameter
dp = 125-06; % [µm]


% name of output file
output_file = "FlameThickness.txt";

% change directory
home = pwd;
cd ( loc );

% read in data.out files
dirFiles = dir(fullfile(loc, 'data.out_*'));
files = {dirFiles.name};

% sort files numerically
filenum = cellfun(@(x)sscanf(x, 'data.out_%e'), files);
[~,Sidx] = sort(filenum);
filenames = files(Sidx);

% data format
headers = {'time', 'Dpar', 'tmin_flame', 'tmid_flame', 'tmax_flame'};
num_col = numel(headers);
col_width = max(cellfun(@length, headers)) + 2;
if col_width <= 12
    col_width = 12;
end

header_format = '';
data_format = '';
for col = 1:num_col
    header_format = [header_format, '%', num2str(col_width), 's'];
    data_format = [data_format, repmat(' ', 1, col_width - 12), '%6E'];
    if col ~= num_col
        header_format = [header_format, '\t'];
        data_format = [data_format, '\t'];
    else
        header_format = [header_format, '\n'];
        data_format = [data_format, '\n'];
    end
end

% Plot settings
%FZ = 22;
%per = 0.1;
%lw = 1.5;
%set(0,'defaultAxesFontName','Times');
%set(0, 'DefaultFigureRenderer', 'painters');
%
%set(groot, 'defaultAxesTickLabelInterpreter','latex'); 
%set(groot, 'defaultLegendInterpreter','latex');
%set(0,'defaultAxesFontSize',FZ);
%set(0, 'DefaultLineLineWidth', lw);
%set(0,'defaultFigurePosition', [2 2 1400, 400])
%close

% calculate flame thickness
for fname=1:length(filenames)
    fprintf('%s\n', filenames{fname});
    files = dir(fullfile(pwd, filenames{fname}));

    n_f = size(files,1);
    filename = files(1).name;

    % grid
    grid  = CIAO_read_grid(filename);
    xm = grid.xm;
    ym = grid.ym;
    zm = grid.zm;
    nx = size(xm,1);
    ny = size(ym,1);
    nz = size(zm,1);

    % determine grid lenght (x-direction)
    grid_length = xm(nx) / nx;

    % read data
    time    = CIAO_read_real(filename,'time');
    OH      = CIAO_read_real(filename, 'OH');
    ND_COAL = CIAO_read_real(filename, 'ND_COAL');

    % get time
    [time_1,ii] = sort(time);
    time = time_1;
    clear time_1

    % write header
    if fname == 1
        fid = fopen(output_file, 'a+');
        fprintf(fid, header_format, headers{:});
        fclose(fid);
    end

    % determine particle position
    particle_num = 0;
    for i = 1:nz
       if sum(sum(ND_COAL(:,:,i))) >= 1
           particle_num = particle_num + sum(sum(ND_COAL(:,:,i)));
           break
       end
    end

    if particle_num == 1
        for i = 1:nz
            matrix = ND_COAL(:,:,i);
            for j = 1:ny
                for k = 1:nx
                    if matrix(k,j) == 1
                        CenterX = k;
                        CenterY = j;
                        CenterZ = i;
                        break
                    end
                end
            end
        end
    else
        fprintf(['\n\n===\nParticle number != 1!\nZero' ...
            ' or more than one particle in domain!\n===\n\n']);
        cd  ( home );
        return
    end
    %fprintf('Particle position: x=%i, y=%i, and z=%i\n', ...
    %    CenterX, CenterY, CenterZ);

    %
    max_OH = max(max(max(OH)));

    % 
    if max(OH(CenterX:end,CenterY,CenterZ)) > (0.70)*max_OH
                
        maxOH_loc=find(OH(CenterX:end,CenterY,CenterZ)==max(OH(CenterX:end,CenterY,CenterZ)));
        if maxOH_loc >= 10
            maxOH_loc = 0;
        end
                
        if maxOH_loc == 0
            mid_fl_loc = 0;
        else
            mid_fl_loc = (xm(CenterX+maxOH_loc)-xm(CenterX))/dp;
        end
            
        if mid_fl_loc <= 1 
            mid_fl_loc = 0;
        end
            
        if mid_fl_loc > 10
            fl_loc = [maxOH_loc,maxOH_loc];
        elseif  ((max(OH(CenterX:end,CenterY,CenterZ)) - OH(CenterX,CenterY,CenterZ)) <0.001) && ((max(OH(CenterX:end,CenterY,CenterZ)) - OH(end,CenterY,CenterZ)) <0.001)
            fl_loc = [maxOH_loc,maxOH_loc];
        else
            fl_loc=find(OH(CenterX:end,CenterY,CenterZ)>0.7*max(OH(CenterX:end,CenterY,CenterZ)));
        end
            
        if fl_loc(end) >= 10
            fl_loc = [maxOH_loc,maxOH_loc];
        end
                  
        min_fl_loc = (xm(CenterX+fl_loc(1))-xm(CenterX))/dp;
        max_fl_loc = (xm(CenterX+fl_loc(end))-xm(CenterX))/dp;
            
        if min_fl_loc <= 1 
            min_fl_loc = 0;
        end
        if max_fl_loc <= 1
            max_fl_loc = 0;
        end
    else
        mid_fl_loc = 0;
        max_fl_loc = 0;
        min_fl_loc = 0;
    end
     
    %figT = figure(1);
    %subplot(1,2,1)
    %set(gcf,'color','w');
    %box on
    %%hold on
    %plot((xm(CenterX:end)-xm(CenterX))/dp+1,T(CenterX:end,CenterY,CenterZ))
            
    %xline(mid_fl_loc,'r--','LineWidth',lw)
    %xline(max ????
    %xline(min_fl_loc,'r:','LineWidth',lw)
    %ylabel('$T_{g}[K]$','Interpreter','latex','fontsize',FZ)
    %xlabel('$r_f/r_p$ ','Interpreter','latex','fontsize',FZ)
    %%xlim([0 10])
    %%xticks(0:2:10)
    %%ylim([1000 2600])
    %title(strcat('$t=$',num2str(time*1000),'ms'),'Interpreter','latex','fontsize',FZ)
            
    %subplot(1,2,2)
    %set(gcf,'color','w');
    %box on
    %%hold on
    %plot((xm(CenterX:end)-xm(CenterX))/dp+1,OH(CenterX:end,CenterY,CenterZ))
    %xline(mid_fl_loc,'r--','LineWidth',lw)
    %xline(max_fl_loc,'r:','LineWidth',lw)
    %xline(min_fl_loc,'r:','LineWidth',lw)
    %ylabel('$Y_{OH}[-]$','Interpreter','latex','fontsize',FZ)
    %xlabel('$r_f/r_p$ ','Interpreter','latex','fontsize',FZ)
    %%xlim([0 10])
    %%xticks(0:2:10)
    %%ylim([0 0.016])
    %title(strcat('$t=$',num2str(time*1000),'ms'),'Interpreter','latex','fontsize',FZ)
            
    %anim(iii)=getframe(figT);
   
    % write to file
    data = {time, dp, min_fl_loc, mid_fl_loc, max_fl_loc};
    fid = fopen(output_file, 'a+');
    fprintf(fid, data_format, data{:});
    fclose(fid);
end

cd  ( home );
