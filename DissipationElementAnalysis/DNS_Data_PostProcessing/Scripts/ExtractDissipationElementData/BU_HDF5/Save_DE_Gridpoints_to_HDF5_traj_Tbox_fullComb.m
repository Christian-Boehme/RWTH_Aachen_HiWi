clc
clear all
close all

% ================================
% saves grid points of DE to HDF5 file!
% possible to add this directely to hdf5 ?? (time consuming)
% ================================


%====
% INPUTS
%====
data_path = ['~/itv/OXYFLAME-B3/File_Transfer/DE_analysis_code/' ...
    'trajSearch/Dataset'];
cases= {'traj_Tbox_ign.h5', 'traj_Tbox_OHmax.h5', ...
    'traj_Tbox_fullComb.h5', 'traj_Tbox_finish.h5'};
ofname = '../PostProcessedData/';
hdf5FileName = 'DEGridpoints_traj_Tbox_fullComb.h5';
Zst = 0.117;                                                                    % correct ???
%====

% 
home = pwd;

% full path
hdf5FileName = strcat(home, '/', ofname, '/', hdf5FileName);

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
    % element grid points for each grid point                                   ???
    %egpts{i} = h5read(cases{i}, '/traj_full/egpts');
    % 
    %edata_dble{i} = h5read(cases{i}, '/traj_full/edata_dble');
    % 
    %edata_int{i} = h5read(cases{i}, '/traj_full/edata_int');
end

% TODO get number of grid points in x, y, z
nx = 256;
ny = 256;
nz = 256;

% get grid points for each dissipation element
for i = 3:3 %length(cases)
    tot_ele = ecount{i};
    DE_gridpoints = {};
    DE_with_Zst_counter = 0;
    for j = 1:tot_ele
        ele_coords = {};
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
                        ele_coords{end + 1} = coords;
                    end
                end
            end
        end
        fprintf("Case: %i  Element: %i => number of grid points " + ...
            "= %i    \t LowerZst = %i   UpperZst = %i\n", ...
            i, j, counter, LowerZst, UpperZst);
        % check if Zst in DE
        if LowerZst && UpperZst
            DE_gridpoints{end + 1} = ele_coords;
            DE_with_Zst_counter = DE_with_Zst_counter + 1;
        end
    end
    % save in HDF5
    if ~isempty(DE_gridpoints)
        CaseName = strcat('/SimulationCase', num2str(i));
        saveCellToHDF5(DE_gridpoints, hdf5FileName, CaseName);
        fprintf('\nNumber of DE with Zst: %i\n\n', DE_with_Zst_counter);
    end
end

% counter equals edata_dble!
% -> row 11 (README = grid-points of element ( ~ simplyfied "volume"))

% 
cd ( home );


function saveCellToHDF5(data, hdf5FileName, path)

    if iscell(data)
        % if the data is a cell, recursively save each element
        for i = 1:numel(data)
            % create unique path for each cell
            newPath = sprintf('%s/Cell_%d', path, i);
            saveCellToHDF5(data{i}, hdf5FileName, newPath);
        end
    elseif isnumeric(data)
        h5create(hdf5FileName, path, size(data));
        h5write(hdf5FileName, path, data);
    elseif ischar(data)
        h5create(hdf5FileName, path, length(data));
        h5write(hdf5FileName, path, data);
    elseif isstring(data)
        h5create(hdf5FileName, path, size(data));
        h5write(hdf5FileName, path, char(data));
    else
        error('Unsupported data type in the cell array.');
    end

end
