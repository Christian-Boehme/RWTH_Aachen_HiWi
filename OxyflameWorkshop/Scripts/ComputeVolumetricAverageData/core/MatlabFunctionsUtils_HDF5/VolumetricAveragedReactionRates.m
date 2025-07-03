function [] = VolumetricAveragedReactionRates(loc,xplain,use_max,output_file,SingleParSim,retime)


% read in mechanism dependend data
[n_species,SPEC,MM] = VolumetricAveragedDataTools();
[n_species, n_reactions, reactions] = Get_Reactions();

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
        % field width
        l_s = 13; %max(cellfun('length', reactions)) + 5;
        l_s_str_spec = join(['  \t%',string(l_s),'s'], '');
        l_s_str_start = join(['%',string(l_s),'s  \t%',string(l_s), ...
            's  \t%',string(l_s),'s  \t%',string(l_s),'s'],'');
        l_s_str_sci1 = join(['\n%',string(l_s),'.5E'],'');
        l_s_str_sci  = join(['  \t%',string(l_s),'.5E'],'');
        if clipp == 1
            fid = fopen(output_file, 'w');
            fprintf(fid,l_s_str_start,ht);
            for i_reac = 1:n_reactions
                r_name = split(string(reactions(i_reac)),": ");
                fprintf(fid,l_s_str_spec,string(append("Vol_",r_name(1))));
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
    
    % time
    fid = fopen(output_file, 'a+');
    fprintf(fid, l_s_str_sci1, time);
    fclose(fid);

    % compute volumetric average reaction rates
    Species = zeros(n_species, nx, ny, nz);
    for i_spec = 1:n_species
        indexYspec = findScalarIndex(filename, strcat(sd_loc, '/data/scalars/SC'), string(SPEC(i_spec)));
        Y_Spec = h5read(filename, strcat(sd_loc, '/data/scalars/SC'), [1, 1, 1, indexYspec], [nx, ny, nz, 1]);
        Species(i_spec,:,:,:) = Y_Spec;
    end
    
    omega = zeros(n_reactions, nx, ny, nz);
    for i = xstart:xend
        for j = 1:ny
            for k = 1:nz
                W = Compute_ReactionRates(Species(:,i,j,k), RHO(i,j,k), T(i,j,k), Pres(i,j,k));
                omega(:,i,j,k) = W;
            end
        end
    end

    % averaged
    for i_reac = 1:n_reactions
        Fraction_vector = omega(i_reac,:,:,:);

        if use_max
            XY_tot_spec_per_V = max(Fraction_vector, [], 'all');
        else
            if xplain == 0
                XY_tot_spec_per_V = sum(Fraction_vector, 'all') / (xend * ny * nz);
            else
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

