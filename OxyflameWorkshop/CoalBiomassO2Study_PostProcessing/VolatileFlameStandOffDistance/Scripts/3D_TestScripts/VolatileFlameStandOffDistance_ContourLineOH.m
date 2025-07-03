clc
clear all
close all
addpath('/home/cb376114/master-thesis/ReadCIAOBinaryFiles');

% path to the simulation folder (data.out files)
loc= '~/p0021020/Pooria/SINGLES/WS/AIR20-DP125/TEST';

% input: particle diameter
dp = 125e-06; % [µm]

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
output_file = "VolatileFlameStandOffDistance_ContourLine.txt";

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
    particle_loc = [CenterX, CenterY, CenterZ];

    % threshold based on Y_OH,max
    glob_max_OH = max(max(max(OH)));
    threshold = 0.75 * glob_max_OH;

    % Generate the isosurface for the threshold contour
    isosurf = isosurface(OH, threshold);

    % Check if the isosurface has vertices
    if isempty(isosurf.vertices)
        disp('No contour present at the specified threshold.');
    else
        % Extract vertices and faces
        vertices = isosurf.vertices;
        faces = isosurf.faces;
    
        % Identify connected components of the isosurface
        [components, numComponents] = conncomp(triangulation(faces, vertices));
        disp(numComponents);
        % Handle cases based on the number of components
        if numComponents == 1
            % Only one contour present
            fprintf('One contour detected.\n');
        
            % Visualize the single contour with transparency
            figure;
            p = patch(isosurf);
            p.FaceColor = 'red';
            p.EdgeColor = 'none';
            p.FaceAlpha = 0.3; % Set transparency
            camlight; lighting phong;
            title('Single 70% Contour of 3D Field');
            xlabel('X'); ylabel('Y'); zlabel('Z');
            view(3); axis vis3d;

            % Define the user-defined cell (convert to array indices if necessary)
            userCell = [25, 25, 25]; % Adjust as needed based on your 3D data

            % Calculate distances from the user-defined cell to each vertex of the contour
            distances = sqrt((vertices(:, 1) - userCell(1)).^2 + ...
                             (vertices(:, 2) - userCell(2)).^2 + ...
                             (vertices(:, 3) - userCell(3)).^2);

            % Find the minimum and maximum distances
            minDistance = min(distances);
            maxDistance = max(distances);

            % Output the results
            fprintf('Minimum distance from user-defined cell to contour: %f\n', minDistance);
            fprintf('Maximum distance from user-defined cell to contour: %f\n', maxDistance);

            % Visualize the user-defined cell and contour vertices
            hold on;
            scatter3(userCell(1), userCell(2), userCell(3), 100, 'blue', 'filled'); % User-defined cell in blue
            scatter3(vertices(:, 1), vertices(:, 2), vertices(:, 3), 10, 'green'); % Contour vertices in green
            legend('70% Contour', 'User-defined Cell', 'Contour Vertices');

        elseif numComponents == 2
            % Two nested contours detected
            fprintf('Two nested contours detected.\n');

            % Calculate the volume enclosed by each component
            volumes = zeros(1, numComponents);
            for i = 1:numComponents
                compVertices = vertices(components == i, :);
                hullIndices = convhull(compVertices);
                volumes(i) = volumeHull(compVertices(hullIndices, :));
            end

            % Find the index of the component with the smallest volume
            [~, innerComponentIndex] = min(volumes);

            % Extract the vertices and faces of the inner contour
            innerVertices = vertices(components == innerComponentIndex, :);

            % Visualize the inner contour with transparency
            figure;
            innerPatch = patch('Vertices', innerVertices, 'Faces', isosurf.faces(isosurf.faces(:, 1) == innerComponentIndex, :), ...
                               'FaceColor', 'red', 'EdgeColor', 'none', ...
                               'FaceAlpha', 0.3);
            camlight; lighting phong;
            title('Inner 70% Contour of 3D Field');
            xlabel('X'); ylabel('Y'); zlabel('Z');
            view(3); axis vis3d;

            % Define the user-defined cell (convert to array indices if necessary)
            userCell = [25, 25, 25]; % Adjust as needed based on your 3D data

            % Calculate distances from the user-defined cell to each vertex of the inner contour
            distances = sqrt((innerVertices(:, 1) - userCell(1)).^2 + ...
                             (innerVertices(:, 2) - userCell(2)).^2 + ...
                             (innerVertices(:, 3) - userCell(3)).^2);

            % Find the minimum and maximum distances
            minDistance = min(distances);
            maxDistance = max(distances);

            % Output the results
            fprintf('Minimum distance from user-defined cell to inner contour: %f\n', minDistance);
            fprintf('Maximum distance from user-defined cell to inner contour: %f\n', maxDistance);

            % Visualize the user-defined cell and the inner contour vertices
            hold on;
            scatter3(userCell(1), userCell(2), userCell(3), 100, 'blue', 'filled'); % User-defined cell in blue
            scatter3(innerVertices(:, 1), innerVertices(:, 2), innerVertices(:, 3), 10, 'green'); % Inner contour vertices in green
            legend('Inner 70% Contour', 'User-defined Cell', 'Inner Contour Vertices');
        else
            % More complex handling for more than two components can be added here
            fprintf('More than two components detected. Please check the data.\n');
        end
    end
end

cd ( home );

% Function to calculate the volume of a convex hull defined by the vertices
function vol = volumeHull(vertices)
    K = convhull(vertices);
    vol = 0;
    for i = 1:size(K, 1)
        tri = vertices(K(i, :), :);
        vol = vol + abs(det([tri, ones(3, 1)]) / 6);
    end
end

% Function to find connected components in the triangulation
function [components, numComponents] = conncomp(TR)
    numVertices = size(TR.Points, 1);
    adjMatrix = zeros(numVertices);
    for i = 1:size(TR.ConnectivityList, 1)
        adjMatrix(TR.ConnectivityList(i, :), TR.ConnectivityList(i, :)) = 1;
    end
    disp('...');
    adjGraph = graph(adjMatrix);
    components = conncomp(adjGraph);
    numComponents = max(components);
end