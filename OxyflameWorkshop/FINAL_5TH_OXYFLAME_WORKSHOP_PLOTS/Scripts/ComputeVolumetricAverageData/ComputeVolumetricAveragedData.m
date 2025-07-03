clc
clear all
close all
addpath('core/MatlabFunctionsUtils');

%----------
% INPUT
%----------
% Employed kinetic model
mechanism = 'ITVBio';
% Caluclate species mole/mass/concentration ('SpeciesFraction'),
% reaction rates ('ReactionRates'), or production rate ('ProductionRates')
VolData = 'ReactionRates';
% Calculate volumetric average mole fractions ('X'), mass fractions ('Y'),
% or concentrations ('C')
% NOTE: only used if VolData is set to SpeciesFractions
VolAvX = 'X';
% Calculate volumetric average data in which x-plain [0 = total domain]?
VolAv_xplain = 0;
% simulation folder => loc contains data.out files
loc = '~/p0021020/Pooria/SINGLES/WS/AIR20-DP90';
% First data file for the calculation
InitialDataFile = '0';
% Use the maximum value of your plain instead of the volumetric average value
max_value = false;
% Define name of directory and file => will be created in loc
output_dir = 'VolumetricAverageData/TotalDomain';
output_file = 'VolumetricAverageReactionRates.txt';
%----------

switch(mechanism)
case 'ITVBio'
    addpath('core/MatlabFunctions_ITVBio');
case 'ITVCoal'
    addpath('core/MatlabFunctions_ITVCoal');
end

home = pwd;
cd  ( loc )

% Create subdir
if ~exist(output_dir, 'dir')
    mkdir(output_dir)
end

% Create output_file
output_file = join([pwd,'/',output_dir,'/',output_file],'');

if strcmp(VolData, 'SpeciesFractions')
    % Compute volumetric averaged mole fractions + mass fractions + concentrations
    VolumetricAveragedData(loc,VolAvX,VolAv_xplain,max_value,output_file,InitialDataFile);
elseif strcmp(VolData, 'ReactionRates')
    % Compute volumetric averaged reaction rates
    VolumetricAveragedReactionRates(loc,VolAv_xplain,max_value,output_file,InitialDataFile);
elseif strcmp(VolData, 'ProductionRates')
    % Compute volumetric averaged production rates
    VolumetricAveragedProductionRates(loc,VolAv_xplain,max_value,output_file,InitialDataFile);
end

cd (home)
