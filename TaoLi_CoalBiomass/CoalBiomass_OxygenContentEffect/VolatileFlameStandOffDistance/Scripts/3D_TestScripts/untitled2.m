% Define or load your 3D data array (example data)
data = rand(50, 50, 50); % Replace with your actual 3D data

% Normalize the data to range [0, 1]
data = data - min(data(:));
data = data / max(data(:));

% Define the 70% threshold
threshold = 0.7;

% Generate the isosurface for the 70% contour
figure;
isosurf = isosurface(data, threshold);
p = patch(isosurf);
p.FaceColor = 'red';
p.EdgeColor = 'none';
camlight; lighting phong;
title('70% Contour of 3D Field');
xlabel('X'); ylabel('Y'); zlabel('Z');
view(3); axis vis3d;

% Extract vertices and faces from the isosurface
vertices = isosurf.vertices;

% Define the user-defined cell (convert to array indices if necessary)
% Example: select a point roughly at the center for demonstration
userCell = [25, 25, 25]; % Adjust as needed based on your 3D data

% Calculate distances from the user-defined cell to each vertex of the isosurface
distances = sqrt((vertices(:, 1) - userCell(1)).^2 + ...
                 (vertices(:, 2) - userCell(2)).^2 + ...
                 (vertices(:, 3) - userCell(3)).^2);

% Find the minimum and maximum distances
minDistance = min(distances);
maxDistance = max(distances);

% Output the results
fprintf('Minimum distance from user-defined cell to 70%% contour: %f\n', minDistance);
fprintf('Maximum distance from user-defined cell to 70%% contour: %f\n', maxDistance);

% Visualize the user-defined cell and isosurface vertices
hold on;
scatter3(userCell(1), userCell(2), userCell(3), 100, 'blue', 'filled'); % User-defined cell in blue
scatter3(vertices(:, 1), vertices(:, 2), vertices(:, 3), 10, 'green'); % 70% contour vertices in green
legend('70% Contour', 'User-defined Cell', '70% Contour Vertices');