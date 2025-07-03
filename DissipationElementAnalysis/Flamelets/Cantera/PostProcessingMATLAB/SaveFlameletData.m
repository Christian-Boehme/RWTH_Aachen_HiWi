clc
clear
close all
addpath('../../../MatlabFunctions/')


% ================================
% save the following flamelet specific data to a csv-file
% 1. Tinlet
% 2. StrainRate
% 3. dZr
% 4. DSt
% 5. ChiSt
% 6. ChiQu
% 7. ChiSt/ChiSt
% -> read this file & avoid duplicated calculations in other scripts!
% ================================


%====
% INPUTS
%====
Zst = 0.117;
%DataInpPath = ['../OutputData/' ...
%    'Flamelet_preheated_PassiveScalarMixtureFraction/Data/'];
%DataOutPath = '../OutputData/FlameletData/';
%ofname = 'PostProcessedFlameletData.csv';
DataInpPath = '../OutputData/Flamelet_Simulation/';
DataOutPath = '../OutputData/FlameletData_Simulation/';
ofname = 'PostProcessedFlameletData.csv';
%====


% create output directory
if DataOutPath(end) ~= '/'
    DataOutPath = [DataOutPath, '/'];
end
if ~exist(DataOutPath, 'dir')
    mkdir(DataOutPath);                                                                                                                                                                                                               
end


% get all flamelet-files/csv-files
Flamelets = dir(fullfile(DataInpPath, '*.csv'));


% allocate memory
chi_qu = 0;
chi_quench = [];
matrix = [];
fname = split(Flamelets(1).name, '.');
Tinlet_ = fname{2};


% get data
for i = 1:length(Flamelets)

    % read data
    flamelet = readtable(strcat(DataInpPath, ...
        Flamelets(i).name), 'Delimiter', '\t', ...
        'PreserveVariableNames', true);
    fname = split(Flamelets(i).name, '.');
    chi = flamelet.chi;
    d = flamelet.D;
    w = flamelet.HeatRelease;
    z = flamelet.Z;

    % inlet temperature data
    Tinlet = str2double(fname(2));
    
    % strain rate
    a = str2double(fname(3));

    % reaction zone thickness
    dZr = ComputeReactionZoneThickness(w, z);

    % stoichiometric dissipation rate
    [~, idx] = min(abs(z - Zst));
    chi_st = chi(idx);

    % diffusion coefficient @ stoichiometric mixture fraction
    d_st = d(idx);

    if Tinlet ~= Tinlet_
        % save quenching dissipation rate
        chi_quench = [chi_quench; chi_qu];
        % reset variables
        Tinlet_ = Tinlet;
        chi_qu = chi_st;
    end

    % add to matrix
    matrix = [matrix, [Tinlet, a, dZr, d_st, chi_st]'];

    % quenching dissipation rate (@ stoichiometric conditions!)
    if chi_st > chi_qu
         chi_qu = chi_st;
    end

end
% update quenching dissipation rate
chi_quench(1) = [];
chi_quench = [chi_quench; chi_qu];


% column format
matrix =  matrix';


% add quenching dissipation rate and "chi_st / chi_qu" to matrix
counter = 0;
Tinlet_ = 0;
mat = [];
for i = 1:length(Flamelets)
    fname = split(Flamelets(i).name, '.');
    if str2double(fname(2)) ~= Tinlet_
        Tinlet_ = str2double(fname(2));
        counter = counter + 1;
    end
    mat = [mat; [chi_quench(counter), matrix(i,5) / chi_quench(counter)]];
end
matrix = [matrix, mat];
fprintf('Write to file...\n');


% write to output file
filename = strcat(DataOutPath, ofname);
header = sprintf('%-13s\t%-13s\t%-13s\t%-13s\t%-13s\t%-13s\t%-13s', ...
    'Tinlet', 'StrainRate', 'dZr', 'DSt', 'ChiSt', 'ChiQu', 'ChiStQu');
DataFormat = '%-13E\t%-13E\t%-13E\t%-13E\t%-13E\t%-13E\t%-13E\n';
fid = fopen(filename, 'w');
fprintf(fid, '%s\n', header);
for i = 1:length(Flamelets)
    fprintf(fid, DataFormat, matrix(i,:));
end
fclose(fid);
