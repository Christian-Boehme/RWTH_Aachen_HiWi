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

% save home directory
home = pwd;

% name of output file
output_file = "VolatileFlameStandOffDistance_ContourLineMinimum.txt";

% data format
headers = {'time', 'rfrp'};
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
    disp(location);
    cd ( location )

    % change directory
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

    % threshold based on Y_OH,max
    threshold = 0.75 * YOH_abs_max;

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
        end
        %fprintf('Particle position: x=%i, y=%i, and z=%i\n', ...
        %    CenterX, CenterY, CenterZ);
        particle_loc = [CenterY, CenterX, CenterZ]; % contour has switched X and Y coordinates

        [nRows, nCols, ~] = size(OH(:,:,CenterZ));
        [X, Y] = meshgrid(1:nCols, 1:nRows);
        contourData = contour(X, Y, OH(:,:,CenterZ), [threshold threshold]);
    
        % Extract contour lines data
        contourLines = getContourLines(contourData);

        % allocate memory
        minDistance = Inf;
        minPoint = [];

        % Calculate distances from the user-defined cell to each contour line
        for i = 1:length(contourLines)
            contourLine = contourLines{i};
    
            % Calculate Euclidean distances from the user cell to each point on the contour line
            distances = sqrt((contourLine(:, 1) - particle_loc(1)).^2 + ...
                             (contourLine(:, 2) - particle_loc(2)).^2);
    
            % Find the minimum distance and the corresponding point
            [currentMinDistance, minIndex] = min(distances);
    
            if currentMinDistance < minDistance
                minDistance = currentMinDistance;
                minPoint = contourLine(minIndex, :);
            end
        end

        % Output the minimum distance and the corresponding point
        %fprintf('Minimum distance from particle location to contour: %.2f\n', minDistance);
        %fprintf('Closest point on the contour: [%.2f, %.2f]\n', minPoint);


        % write to file
        if minDistance == inf
            minDistance = 0;
        end
        data = {time, minDistance};
        fid = fopen(output_file, 'a+');
        fprintf(fid, data_format, data{:});
        fclose(fid);
    end

end

cd ( home );

% Function to extract contour lines from contour matrix data
function contourLines = getContourLines(contourData)
    % Initialize variables
    contourLines = {};
    i = 1;
    while i < size(contourData, 2)
        numPoints = contourData(2, i);  % Number of points in this contour
        contour = contourData(:, i + 1:i + numPoints)';  % Extract the contour points
        contourLines{end + 1} = contour;  % Store in the cell array
        i = i + numPoints + 1;  % Move to the next contour
    end
end
