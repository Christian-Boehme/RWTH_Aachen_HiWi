function [] = VolumetricAveragedData(loc,ComputeAvg,xplain,use_max,output_file,SingleParSim,retime)


% read in mechanism dependend data
[n_species,SPEC,MM] = VolumetricAveragedDataTools();

% read in data.out files
dirFiles = dir(fullfile(loc, 'data.out_*'));
files = {dirFiles.name};

% sort files numerically
filenum = cellfun(@(x)sscanf(x, 'data.out_%e'), files);
[~,Sidx] = sort(filenum) ;
filenames = files(Sidx);

clipp = 1;
for i = 1:length(filenames)
    if strcmp(filenames{i},retime)
        clipp = i;
    end
end
if clipp > 1
    filenames = filenames(clipp:end);
end

if SingleParSim
    sd_loc = '/sd_base';
else
    sd_loc = '/sd_box';
end

% compute volumetric averaged mass/mole fractions
for fname=1:length(filenames)

    fprintf('%s\n', filenames{fname});
    files = dir(fullfile(loc, filenames{fname}));
    filename = files(1).name;

    nx = double(h5read(filename, strcat(sd_loc, '/geometry/sd_info/nx')));
    ny = double(h5read(filename, strcat(sd_loc, '/geometry/sd_info/ny')));
    nz = double(h5read(filename, strcat(sd_loc, '/geometry/sd_info/nz')));

    %
    time = h5read(filename, strcat(sd_loc, '/data/globals_r0/time'));
    RHO = h5read(filename, strcat(sd_loc, '/data/cv_data_real/RHO'));
    Pres = h5read(filename, strcat(sd_loc, '/data/cv_data_real/P'));
    WMIX = h5read(filename, strcat(sd_loc, '/data/cv_data_real/Wmix_field'));
    indexT = findScalarIndex(filename, strcat(sd_loc, '/data/scalars/SC'), 'T');
    T = h5read(filename, strcat(sd_loc, '/data/scalars/SC'), [1, 1, 1, indexT], [nx, ny, nz, 1]);
    
    % write column headers & define xrange
    if fname == 1
        ht = 'time[ms]';
        hT = 'T[K]';
        hR = 'density[kg/m^3]';
        hP = 'Pressure';
        % field width
        l_s = max(cellfun('length', SPEC)) + 5;
        if l_s < length(hT)
            l_s = length(hT);
        end
        l_s_str_spec = join(['  \t%',string(l_s),'s'], '');
        l_s_str_start = join(['%',string(l_s),'s  \t%',string(l_s), ...
            's  \t%',string(l_s),'s  \t%',string(l_s),'s'],'');
        l_s_str_sci1 = join(['\n%',string(l_s),'.5E'],'');
        l_s_str_sci  = join(['  \t%',string(l_s),'.5E'],'');
        if clipp == 1
            fid = fopen(output_file, 'w');
            fprintf(fid,l_s_str_start,ht,hT,hR,hP);
            for i_spec = 1:n_species
                if strcmp(ComputeAvg, 'X')
                    species_name = append('VolX_', string(SPEC(i_spec)));
                elseif strcmp(ComputeAvg, 'C')
                    species_name = append('VolC_', string(SPEC(i_spec)));
                else
                    species_name = append('VolY_', string(SPEC(i_spec)));
                end
                fprintf(fid,l_s_str_spec,species_name);
            end
            fclose(fid);
        end
   
    % define xrange
    if xplain == 0
        xstart = 1;
        xend = nx;
    else
        xstart = xplain;
        xend = xplain;
    end

    end

    % compute volumetric average temperture & density & pressure
    fid = fopen(output_file, 'a+');
    fprintf(fid, l_s_str_sci1, time);  
    if use_max
        Temp_tot_per_V = max(T(:), [], 'all');
        Density_tot_per_V = max(RHO(:), [], 'all');
        Pressure_tot_per_V = max(Pres(:), [], 'all');
    else
        if xplain == 0
            Temp_tot_per_V = sum(T, 'all') / (xend * ny * nz);
            Density_tot_per_V = sum(RHO, 'all') / (xend * ny * nz);
            Pressure_tot_per_V = sum(Pres, 'all') / (xend * ny * nz);
        else
            Temp_tot_per_V = sum(T(xplain,:,:), 'all') / (1 * ny * nz);
            Density_tot_per_V = sum(RHO(xplain,:,:), 'all') / (1 * ny * nz);
            Pressure_tot_per_V = sum(Pres(xplain,:,:), 'all') / (1 * ny * nz);
        end
    end
    fprintf(fid, l_s_str_sci, Temp_tot_per_V);
    fprintf(fid, l_s_str_sci, Density_tot_per_V);
    fprintf(fid, l_s_str_sci, Pressure_tot_per_V);
    fclose(fid);
    
    % compute volumetric average mass/mole fractions
    for i_spec = 1:n_species

        Fraction_vector = zeros(nx, ny, nz);

        indexYspec = findScalarIndex(filename, strcat(sd_loc, '/data/scalars/SC'), string(SPEC(i_spec)));
        Y_Spec = h5read(filename, strcat(sd_loc, '/data/scalars/SC'), [1, 1, 1, indexYspec], [nx, ny, nz, 1]);
        if strcmp(ComputeAvg, 'X')
            % mole fraction
            for i = xstart:xend
                for j = 1:ny
                    for k = 1:nz
                        Fraction_vector(i,j,k) = Y_Spec(i,j,k) ...
                            * WMIX(i,j,k) / MM(i_spec);
                    end
                end
            end
        elseif strcmp(ComputeAvg, 'C')
            % concentration
            for i = xstart:xend
                for j = 1:ny
                    for k = 1:nz
                        Fraction_vector(i,j,k) = RHO(i,j,k) * Y_Spec(i,j,k) / MM(i_spec);
                    end
                end
            end
        else
            % mass fraction
            for i = xstart:xend
                for j = 1:ny
                    for k = 1:nz
                        Fraction_vector(i,j,k) = Y_Spec(i,j,k);
                    end
                end
            end
        end

        % replace negative values with zeros
        Fraction_vector(Fraction_vector < 0) = 0;
        
        % volumetric averaged
        if use_max
            XY_tot_spec_per_V = max(Fraction_vector, [], 'all');
        else
            if xplain == 0
                XY_tot_spec_per_V = sum(Fraction_vector, 'all') / (xend * ny * nz);
            else
                %XY_tot_spec_per_V = sum(Fraction_vector, 'all') / (1 * ny * nz);
                XY_tot_spec_per_V = sum(Fraction_vector(xplain,:,:), 'all') / (1 * ny * nz);
            end
        end

        fid = fopen(output_file, 'a+');
        if XY_tot_spec_per_V <= 1E-100 && XY_tot_spec_per_V ~= 0.0
            fprintf(fid, join(['  \t%',string(l_s),'.4E'],''), ...
                XY_tot_spec_per_V);
        else
            fprintf(fid, l_s_str_sci, XY_tot_spec_per_V);
        end
        fclose(fid);
    end
    
end

end

function index = findScalarIndex(fileName, datasetPath, scalarName)
    % Get information about the dataset
    info = h5info(fileName, datasetPath);

    % Extract the attributes information
    attributes = info.Attributes;
    
    % Initialize the index to a negative number to indicate not found
    index = -1;

    % Loop through the attributes to find the match
    for i = 1:length(attributes)
        % Check if the attribute's value matches the scalar name
        if strcmp(h5readatt(fileName, datasetPath, attributes(i).Name), scalarName)
            % MATLAB attribute names follow the format 'Index N', where N is the index.
            % Extract 'N' as the index.
            indexStr = extractAfter(attributes(i).Name, 'Index ');
            index = str2double(indexStr);
            break; % Exit the loop once the match is found
        end
    end
    
    % Check if the scalar name was found
    if index == -1
        disp(['Scalar name "', scalarName, '" not found.']);
    end
end

