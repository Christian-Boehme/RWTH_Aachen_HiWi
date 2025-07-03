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

    [nRows, nCols, ~] = size(OH(:,:,CenterZ));
    [X, Y] = meshgrid(1:nCols, 1:nRows);
    %contour(X, Y, OH(:,:,CenterZ), [threshold threshold], 'LineColor', 'k', 'LineWidth', lw);
    contourData = contour(X, Y, OH(:,:,CenterZ), [threshold threshold]);
    
    %file_time = sprintf("%02i", fname);
    %fig_name = "/Movie_Tgas_Frame_" + file_time;
    %saveas(gcf,fig_name,'png');
    %hold on

    % Extract contour lines data
    contourLines = getContourLines(contourData);

    % Example cell coordinates (replace with your specific cell of interest)
    userCell = [CenterY, CenterX];

    % Initialize variables to store distances
    minDistance = Inf;
    minPoint = [];

    % Calculate distances from the user-defined cell to each contour line
    for i = 1:length(contourLines)
        contourLine = contourLines{i};
    
        % Calculate Euclidean distances from the user cell to each point on the contour line
        distances = sqrt((contourLine(:, 1) - userCell(1)).^2 + ...
                         (contourLine(:, 2) - userCell(2)).^2);
    
        % Find the minimum distance and the corresponding point
        [currentMinDistance, minIndex] = min(distances);
    
        if currentMinDistance < minDistance
            minDistance = currentMinDistance;
            minPoint = contourLine(minIndex, :);
        end
    end

    % Output the minimum distance and the corresponding point
    fprintf('Minimum distance from user-defined cell to contour: %.2f\n', minDistance);
    fprintf('Closest point on the contour: [%.2f, %.2f]\n', minPoint);

    % Plot the contour lines and the minimum distance
    %figure;
    %hold on;
    %xlabel('X'); ylabel('Y');
    %title('2D Contour Line with Minimum Distance to User-Defined Cell');
    %grid on;
    %axis equal;

    % Plot contour lines
    %for i = 1:length(contourLines)
    %    plot(contourLines{i}(:, 1), contourLines{i}(:, 2), 'b-', 'LineWidth', 2);
    %end

    % Plot the user-defined cell
    %scatter(userCell(1), userCell(2), 100, 'filled', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r');

    % Highlight the closest point on the contour
    %scatter(minPoint(1), minPoint(2), 100, 'filled', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g');

    % Plot a line showing the minimum distance
    %plot([userCell(1), minPoint(1)], [userCell(2), minPoint(2)], 'r-', 'LineWidth', 2);

    %legend('Contour Line', 'User-Defined Cell', 'Closest Point', 'Minimum Distance');
    %hold off;
    %scatter(minPoint(1), minPoint(2), 200, 'p', 'filled', ...
    %'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r'); 
    %hold off
    %close all
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
    % Plot the 2D field using imagesc
    
    figure;
    imagesc(X(1,:), Y(:,1), OH(:,:,CenterZ));  % Display the field as an image
    set(gca, 'YDir', 'normal');  % Correct the y-axis direction
    colormap(jet);  % Apply a color map
    %%colorbar;  % Show a color bar
    axis image
    set(gca,'xtick',[])
    set(gca,'ytick',[])
    set(gca,'TickLabelInterpreter','latex');
    camroll(90);
    colorbar('southoutside');

    % Hold on to overlay additional plots
    hold on;

    % Re-plot the contour lines for better visualization
    for i = 1:length(contourLines)
        plot(contourLines{i}(:, 1), contourLines{i}(:, 2), 'b-', 'LineWidth', 2);
    end

    % Plot the highlighted cell
    scatter(userCell(1), userCell(2), 200, 'p', 'filled', ...
        'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'r');  % Use a pentagon marker

    % Optionally, plot a rectangle around the highlighted cell
    cellWidth = abs(X(1,2) - X(1,1));  % Assume uniform grid spacing in X
    cellHeight = abs(Y(2,1) - Y(1,1));  % Assume uniform grid spacing in Y
    rectangle('Position', [userCell(1) - cellWidth/2, userCell(2) - cellHeight/2, cellWidth, cellHeight], ...
            'EdgeColor', 'r', 'LineWidth', 2, 'LineStyle', '--');

    % Highlight the closest point on the contour
    scatter(minPoint(1), minPoint(2), 100, 'filled', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'g');

    % Plot a line showing the minimum distance
    plot([userCell(1), minPoint(1)], [userCell(2), minPoint(2)], 'r-', 'LineWidth', 2);

    % Label and grid
    %xlabel('X');
    %ylabel('Y');
    %xlim([CenterX-25:CenterX+25]);
    %title('2D Field Plot with Highlighted Cell and Distance to Contour Line');
    %grid on;
    %axis equal;
    %legend('Contour Line', 'Highlighted Cell', 'Closest Point', 'Minimum Distance');
    hold off;



    %figure(1)
    %set(gcf,'color','w','visible','off');
    %ax1 = nexttile(1);
    %s1=pcolor(OH(:,:,CenterZ));
    %colormap(ax1,jet)
    %s1.FaceColor = 'interp';
    %set(s1,'edgecolor','none');
    %axis image
    %set(gca,'xtick',[])
    %set(gca,'ytick',[])
    %set(gca,'TickLabelInterpreter','latex');
    %camroll(90);
    %cb1=colorbar('southoutside'); 
    %caxis(ax1, [0 glob_max_OH]);
    %ylabel(cb1, '$Y_{OH} [-]$','fontsize',FZ,'interpreter','latex')
    %%title(['t = ' plot_time 'ms'], 'FontSize', FZ, 'interpreter', 'latex')
    %hold on
    %contour(X, Y, OH(:,:,CenterZ), [threshold threshold], 'LineColor', 'k', 'LineWidth', lw);
    %set(gca, 'XDir','reverse');
    %hold off

    file_time = sprintf("%02i", fname);
    fig_name = "/Movie_Tgas_Frame_" + file_time;
    saveas(gcf,fig_name,'png');
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