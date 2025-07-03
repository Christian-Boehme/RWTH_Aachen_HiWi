clc
clear all
close all
addpath('../../core/MatlabFunctionsUtils_HDF5');

%----------
% INPUT
%----------
mechanism = 'ITVBioNOx';
% Calculate data?
VolAvX = 'X';
% Calculate the maximum value of your plain [false = volumetric average]
max_value = false;
% Calculate volumetric average data in which x-plain [0 = total domain]?
VolAv_xplain = 0;
% loc contains data.out files
loc = '~/NHR/NOx_JETS_ICNC24/RUNS/SINGLE_NOX_RUNS/DYN_WS_OXY20_SINGLE/';
SingleParticleSim = true;
% Define name of directory and file => will be created in loc
output_dir = 'VolumetricAverageData/TotalDomain';
output_file = 'VolumetricAverageMoleFractions.txt';
%----------

switch(mechanism)
case 'ITVCoalNOx'
    addpath('../../core/MatlabFunctions_ITVCoalNOx');
case 'ITVBioNOx'
    addpath('../../core/MatlabFunctions_ITVBioNOx');
end

home = pwd;

cd (loc)

% Create subdir
if ~exist(output_dir, 'dir')
    mkdir(output_dir)
end

% Create output_file
output_file = join([pwd,'/',output_dir,'/',output_file],'');

% Compute volumetric averaged mole fractions
VolumetricAveragedData(loc,VolAvX,VolAv_xplain,max_value,output_file, ...
    SingleParticleSim,0);

VolAvX = 'Y';
output_file = 'VolumetricAverageMassFractions.txt';

% Create output_file
output_file = join([pwd,'/',output_dir,'/',output_file],'');

% Compute volumetric averaged mass fractions
VolumetricAveragedData(loc,VolAvX,VolAv_xplain,max_value,output_file, ...
    SingleParticleSim,0);

VolAvX = 'C';
output_file = 'VolumetricAverageConcentrations.txt';

% Create output_file
output_file = join([pwd,'/',output_dir,'/',output_file],'');

% Compute volumetric averaged concentration
VolumetricAveragedData(loc,VolAvX,VolAv_xplain,max_value,output_file, ...
    SingleParticleSim,0);

cd (home)
