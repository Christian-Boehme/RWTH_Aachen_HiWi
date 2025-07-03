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
output_file = "VolatileFlameStandOffDistance_ParticleMaxOHCell.txt";

% data format
headers = {'time', 'Dpar', 'rf_plus_rp', 'rfrp', 'rf_minus_rp'};
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
        fprintf('Particle position: x=%i, y=%i, and z=%i\n', ...
            CenterX, CenterY, CenterZ);

        % cell with Y_OH,max
        glob_max_OH = max(max(max(OH)));

        % calculate volatile flame distance
        for i_max=1:nx
            for j_max=1:ny
                for k_max=1:nz
                    if OH(i_max,j_max,k_max) == glob_max_OH
                        fprintf('MAX(OH)          : x=%i, y=%i, and z=%i\n', ...
                            [i_max,j_max,k_max]);
                        rf = sqrt((i_max - CenterX)^2 + (j_max - CenterY)^2 ...
                            + (k_max - CenterZ)^2) * grid_length;
                        rf_plus_rp = (rf + (dp/2)) / (dp/2);
                        rfrp = rf / (dp/2);
                        rf_minus_rp = (rf - (dp/2)) / (dp/2);
                        fprintf(['Volatile flame stand-off distance: ' ...
                            '%e\n\n'], rfrp);
                        break
                    end
                end
            end
        end
    
        % write to file
        data = {time, dp, rf_plus_rp, rfrp, rf_minus_rp};
        fid = fopen(output_file, 'a+');
        fprintf(fid, data_format, data{:});
        fclose(fid);
    end
end

cd ( home );

