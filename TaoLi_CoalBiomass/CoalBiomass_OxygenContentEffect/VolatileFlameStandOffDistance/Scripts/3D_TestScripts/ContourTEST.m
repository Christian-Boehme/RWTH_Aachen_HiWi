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
    glob_max_OH = max(max(max(OH)));



    innerSphereVertices = [];

    % Example 3D data array (replace with your actual data)
    %data = randn(50, 50, 50);  % Example random 3D data
    %data = data - min(data(:));
    %data = data / max(data(:));

    % Threshold for contour detection (75% of max value)
    threshold = 0.75 * max(OH(:));

    % Generate isosurface at the threshold
    isosurf = isosurface(OH, threshold);

    % Check number of contour vertices
    if isempty(isosurf.vertices)
        numContours = 0;
        disp('No contour lines detected.');
    else
        numContours = 1; % For isosurface, there's typically one connected contour
        disp('One contour line detected.');
    end

    % Plotting the isosurface in a 3D figure
    figure;
    hold on;
    xlabel('X'); ylabel('Y'); zlabel('Z');
    title('Contour Line in 3D');
    view(3); % 3D view

    % Plot the contour
    if numContours > 0
        % Plot the contour surface
        %patch('Vertices', isosurf.vertices, 'Faces', isosurf.faces, ...
        %      'FaceColor', 'b', 'EdgeColor', 'none', 'FaceAlpha', 0.3);

        % Define a user-defined cell position (adjust as needed)
        userCell = [CenterY, CenterX, CenterZ];

        % Calculate distances if contour is present
        distances = sqrt((isosurf.vertices(:, 1) - userCell(1)).^2 + ...
                         (isosurf.vertices(:, 2) - userCell(2)).^2 + ...
                         (isosurf.vertices(:, 3) - userCell(3)).^2);

        % Find the minimum and maximum distances
        minDistance = min(distances);
        maxDistance = max(distances);
        
        % Find indices of vertices corresponding to minimum and maximum distances
        [~, minIndex] = min(distances);
        [~, maxIndex] = max(distances);
      
        % Get coordinates of the vertices belonging to the inner contour
        innerSphereVertices = isosurf.vertices(minIndex, :);

        % Plotting user-defined cell
        scatter3(userCell(1), userCell(2), userCell(3), 100, 'filled', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r');
        legend('Contours', 'User-defined Cell');

        % Highlight minimum and maximum distances
        scatter3(innerSphereVertices(1), innerSphereVertices(2), innerSphereVertices(3), ...
                 100, 'filled', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g');

        %scatter3(isosurf.vertices(minIndex, 1), isosurf.vertices(minIndex, 2), isosurf.vertices(minIndex, 3), ...
        %         100, 'filled', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g');
        %scatter3(isosurf.vertices(maxIndex, 1), isosurf.vertices(maxIndex, 2), isosurf.vertices(maxIndex, 3), ...
        %         100, 'filled', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'm');
        % Connect a line between user cell and inner sphere (cell)
        plot3([userCell(1), innerSphereVertices(1)], ...
             [userCell(2), innerSphereVertices(2)], ...
            [userCell(3), innerSphereVertices(3)], 'r-', 'LineWidth', 2);
        % Annotate distances near the points
        text(isosurf.vertices(minIndex, 1), isosurf.vertices(minIndex, 2), isosurf.vertices(minIndex, 3), ...
             sprintf(' Min: %.2f', minDistance), 'FontSize', 12, 'Color', 'g');
        text(isosurf.vertices(maxIndex, 1), isosurf.vertices(maxIndex, 2), isosurf.vertices(maxIndex, 3), ...
             sprintf(' Max: %.2f', maxDistance), 'FontSize', 12, 'Color', 'm');
        
        % Output results
        fprintf('Minimum distance from particle position to contour: %.2f\n', minDistance);
        fprintf('Maximum distance from particle position to contour: %.2f\n', maxDistance);

        % Plotting user-defined cell
        scatter3(userCell(1), userCell(2), userCell(3), 100, 'filled', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r');
        legend('Contours', 'User-defined Cell');
    end

    % Adjust axis limits if needed
    %axis equal;
    grid on;

    % Optionally, adjust the figure view angle as per your preference
end
