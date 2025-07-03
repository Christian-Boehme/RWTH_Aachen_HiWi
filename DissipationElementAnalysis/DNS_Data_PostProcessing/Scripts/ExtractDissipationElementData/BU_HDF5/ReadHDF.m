clc
clear all
close all

% ================================
% How to plot this? its a volume...
% ================================


%====
% INPUTS
%====
ofname = '../Figures/Data/';
hdf5FileName = '.h5';
Zst = 0.117;                                                               % correct ???
%====

% 
home = pwd;

% full path
hdf5FileName = strcat(home, '/', ofname, '/', hdf5FileName);


% Load the nested cell array
loadedCellArray = loadCellFromHDF5(hdf5FileName, '/SimulationCase_1');

disp('Loaded nested cell array:');
disp(loadedCellArray);



function loadedData = loadCellFromHDF5(hdf5FileName, path)

    info = h5info(hdf5FileName, path);
    if isempty(info.Datasets) && ~isempty(info.Groups)
        % path contains groups (sub-cells), recursively load each
        loadedData = cell(1, numel(info.Groups));
        for i = 1:numel(info.Groups)
            newPath = [path '/' info.Groups(i).Name];
            loadedData{i} = loadCellFromHDF5(hdf5FileName, newPath);
        end
    else
        % path contains datasets, load directly
        loadedData = h5read(hdf5FileName, path);
    end

end
