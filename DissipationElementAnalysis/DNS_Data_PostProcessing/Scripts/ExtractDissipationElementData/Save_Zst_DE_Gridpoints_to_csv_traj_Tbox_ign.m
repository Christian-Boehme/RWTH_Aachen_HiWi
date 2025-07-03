clc
clear all
close all


% ================================
% saves grid points of DE to a csv file!
% ================================


%====
% INPUTS
%====
data_path = ['~/itv/OXYFLAME-B3/File_Transfer/DE_analysis_code/' ...
    'trajSearch/Dataset'];
cases= {'traj_Tbox_ign.h5', 'traj_Tbox_OHmax.h5', ...
    'traj_Tbox_fullComb.h5', 'traj_Tbox_finish.h5'};
ofname = '../../PostProcessedData/';
csvFileName = 'DEGridpointsZst_ign.csv';
Zst = 0.117;
%====


% 
home = pwd;


% full path
csvFileName = strcat(home, '/', ofname, '/', csvFileName);


% create output folder if not present
if ~exist(strcat(home, '/', ofname), 'dir')
    mkdir(strcat(home, '/', ofname));
end


% 
cd (data_path );


% read data
for i = 1:length(cases)
    % Zmix
    Zmix{i} = h5read(cases{i}, '/scalar/ZMIX');
    % total number of DE
    ecount{i} = h5read(cases{i}, '/traj_full/ecount');
    % element ID for each grid point
    eid{i} = h5read(cases{i}, '/traj_full/eid');

end


% get number of grid points in x, y, z
nx = 256;
ny = 256;
nz = 256;


% get grid points for each dissipation element
for i = 1:1 %length(cases)
    tot_ele = ecount{i};
    DE_gridpoints = {};
    DE_with_Zst_counter = 0;
    for j = 1:tot_ele
        ele_coords = [];
        LowerZst = false;
        UpperZst = false;
        counter = 0;
        for x = 1:nx
            for y = 1:ny
                for z = 1:nz
                    if eid{i}(x,y,z) == j
                        counter = counter + 1;
                        coords = [x, y, z];
                        if Zmix{i}(x, y, z) < Zst
                            LowerZst = true;
                        elseif Zmix{i}(x,y,z) >= Zst
                            UpperZst = true;
                        end
                        ele_coords = [ele_coords, coords];
                    end
                end
            end
        end
        fprintf("Case: %i  Element: %i => number of grid points " + ...
            "= %i    \t LowerZst = %i   UpperZst = %i\n", ...
            i, j, counter, LowerZst, UpperZst);
        % check if Zst in DE
        if LowerZst && UpperZst
            DE_with_Zst_counter = DE_with_Zst_counter + 1;
            % add DE-ID (number of DE) to coordinates array
            ele_coords = [j, ele_coords]';
            DE_gridpoints{end + 1} = ele_coords;
        end
    end
    % save in csv
    if ~isempty(DE_gridpoints)
        saveCellToCSV(DE_gridpoints, csvFileName);
        fprintf('\nNumber of DE with Zst: %i\n\n', DE_with_Zst_counter);
    end
end


% counter equals edata_dble!
% -> row 11 (README = grid-points of element ( ~ simplyfied "volume"))


% 
cd ( home );


function saveCellToCSV(data, csvFileName)

    % allocate memory
    matrix = [];

    % find the largest array
    for i = 1:length(data)
        array = data{i}(:);
        
        % current size of the matrix
        current_rows = size(matrix, 1);
        array_length = length(array);
        
        % new number of rows needed
        max_rows = max(current_rows, array_length);
        
        % pad the matrix and array to match the maximum number of rows
        if current_rows < max_rows
            matrix = [matrix; zeros(max_rows - current_rows, size(matrix, 2))];
        end
        if array_length < max_rows
            array = [array; zeros(max_rows - array_length, 1)];
        end
        % append as new column
        matrix = [matrix, array];
    end

    % write matrix to a csv-file
    writematrix(matrix, csvFileName);

end
