clc
clear all
close all
addpath('/home/cb376114/master-thesis/ReadCIAOBinaryFiles');

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

% input: particle diameter
diameter = {125e-06; 90e-06; 90e-06; 125e-06; 160e-06; 160e-06; 
    125e-06; 90e-06; 125e-06; 160e-06; 125e-06; 90e-06; 90e-06; 
    125e-06; 160e-06; 160e-06; 125e-06; 90e-06; 125e-06; 160e-06}; % [µm]
diameter = diameter';

% name of output file
output_file = "VolatileFlameStandOffDistance_FlameThicknessApproach.txt";

% data format
headers = {'time', 'Dpar', 'Min', 'Mid', 'Max'};
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

%
for path = 1:length(loc)

    location = loc{path};
    dp = diameter{path};
    disp(location);
    cd ( location )

    % change directory
    home = pwd;
    cd ( location );

    % read in data.out files
    dirFiles = dir(fullfile(location, 'data.out_*'));
    files = {dirFiles.name};

    % sort files numerically
    filenum = cellfun(@(x)sscanf(x, 'data.out_%e'), files);
    [~,Sidx] = sort(filenum);
    filenames = files(Sidx);

    % determine max variable (upper limit)
    for fname = 1:length(filenames)
        files = dir(fullfile(location, filenames{fname}));
        filename = files(1).name;

        % read data
        OH = CIAO_read_real(filename,'OH');
        Tgas = CIAO_read_real(filename,'T');
      
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
    end

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
            cd ( home );
            break
            %return
        end
        %fprintf('Particle position: x=%i, y=%i, and z=%i\n', ...
        %    CenterX, CenterY, CenterZ);
        
        if max(OH(CenterX:end,CenterY,CenterZ)) > (0.5)*YOH_abs_max
                
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
            elseif  ((max(OH(CenterX:end,CenterY,CenterZ)) - OH(CenterX,CenterY,CenterZ)) <0.001) & ((max(OH(CenterX:end,CenterY,CenterZ)) - OH(end,CenterY,CenterZ)) <0.001)
                 fl_loc = [maxOH_loc,maxOH_loc];
            else
                fl_loc=find(OH(CenterX:end,CenterY,CenterZ)>0.75*max(OH(CenterX:end,CenterY,CenterZ)));
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
    
        % write to file
        data = {time, dp, min_fl_loc, mid_fl_loc, max_fl_loc};
        fid = fopen(output_file, 'a+');
        fprintf(fid, data_format, data{:});
        fclose(fid);
    end
end
