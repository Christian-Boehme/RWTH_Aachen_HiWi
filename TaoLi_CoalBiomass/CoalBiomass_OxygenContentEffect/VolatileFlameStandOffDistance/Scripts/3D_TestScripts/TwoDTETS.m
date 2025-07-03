clc
clear all
close all
addpath('/home/cb376114/master-thesis/ReadCIAOBinaryFiles');

% path to the simulation folder (data.out files)
loc= '~/p0021020/Pooria/SINGLES/WS/AIR20-DP125/TEST';

% input: particle diameter
dp = 160e-06; % [µm]

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

% name of output file
output_file = "VolatileFlameStandOffDistance.txt";

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
        return
    end
    fprintf('Particle position: x=%i, y=%i, and z=%i\n', ...
        CenterX, CenterY, CenterZ);
    % cell with Y_OH,max
    glob_max_OH = max(max(max(OH(:,:,CenterZ))));


    % Threshold for contour detection (75% of max value)
    threshold = 0.75 * max(OH(:));

    % Generate contour lines at the threshold
    contourData = contour(OH(:,:,CenterZ), [threshold, threshold], 'LineColor', 'k');

    % Extract contour lines data
    contourLines = getContourLines(contourData);

    % Initialize variables to store inner and outer contours
    innerContour = [];
    outerContour = [];

    % Check number of contour lines detected
    numContours = length(contourLines);
    disp(['Number of contour lines detected: ', num2str(numContours)]);

    % Determine inner and outer contours if there are two lines
    if numContours > 1
        % Calculate the centroid for both contours to determine inner and outer
        centroids = cellfun(@(c) mean(c, 1), contourLines, 'UniformOutput', false);
        centroidDistances = cellfun(@(c) norm(c - [0, 0]), centroids);  % Distance from origin or some central point

        % Inner contour is the one closer to the origin or central point
        [~, innerIndex] = min(centroidDistances);
        [~, outerIndex] = max(centroidDistances);

        innerContour = contourLines{innerIndex};
         outerContour = contourLines{outerIndex};
    elseif numContours == 1
        % Only one contour line detected
        innerContour = contourLines{1};
    end

    % Define a user-defined cell inside the inner contour (adjust as needed)
    userCell = [CenterX, CenterZ];  % Example: the center of the grid

    % Calculate distances from user cell to inner contour points
    if ~isempty(innerContour)
        distances = sqrt((innerContour(:, 1) - userCell(1)).^2 + (innerContour(:, 2) - userCell(2)).^2);
        [minDistance, minIndex] = min(distances);
        [maxDistance, maxIndex] = max(distances);

        % Output the distances
        fprintf('Minimum distance from user-defined cell to inner contour: %.2f\n', minDistance);
        fprintf('Maximum distance from user-defined cell to inner contour: %.2f\n', maxDistance);

        % Plot the contours and distances
        figure;
        hold on;
        title('2D Contour Lines with Distance to Inner Contour');
        xlabel('X');
        ylabel('Y');
        grid on;
        axis equal;
    
        % Plot contours
        plot(innerContour(:, 1), innerContour(:, 2), 'g', 'LineWidth', 2);  % Inner contour in green
        if ~isempty(outerContour)
            plot(outerContour(:, 1), outerContour(:, 2), 'b--', 'LineWidth', 2, 'DisplayName', 'Outer Contour');  % Outer contour in blue
        end
    
        % Plot user-defined cell
        scatter(userCell(1), userCell(2), 100, 'filled', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r');

        % Plot lines to the nearest and farthest points on the inner contour
        plot([userCell(1), innerContour(minIndex, 1)], [userCell(2), innerContour(minIndex, 2)], 'r-', 'LineWidth', 2);
        plot([userCell(1), innerContour(maxIndex, 1)], [userCell(2), innerContour(maxIndex, 2)], 'm-', 'LineWidth', 2);

        % Highlight the closest and farthest points on the inner contour
        scatter(innerContour(minIndex, 1), innerContour(minIndex, 2), 100, 'filled', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g');
        scatter(innerContour(maxIndex, 1), innerContour(maxIndex, 2), 100, 'filled', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'm');

        legend('Inner Contour', 'User-defined Cell', 'Min Distance', 'Max Distance', 'Location', 'Best');
        hold off;
    end
end

% Function to extract contour lines from contour matrix data
function contourLines = getContourLines(contourData)
    % Initialize variables
    contourLines = {};
    i = 1;
    while i < size(contourData, 2)
        level = contourData(1, i);  % The contour level (not used in this example)
        numPoints = contourData(2, i);  % Number of points in this contour
        contour = contourData(:, i + 1:i + numPoints)';  % Extract the contour points
        contourLines{end + 1} = contour;  % Store in the cell array
        i = i + numPoints + 1;  % Move to the next contour
    end
end

