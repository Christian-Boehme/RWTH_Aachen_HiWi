function [] = VolumetricAveragedProductionRates(loc,xplain,use_max,output_file,retime)


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

% compute volumetric averaged mass/mole fractions
for fname=1:length(filenames)

    fprintf('%s\n', filenames{fname});
    files = dir(fullfile(loc, filenames{fname}));
    filename = files(1).name;

    grid  = CIAO_read_grid(filename);
    xm = grid.xm;
    ym = grid.ym;
    zm = grid.zm;
    nx = size(xm,1);
    ny = size(ym,1);
    nz = size(zm,1);

    % read list of variables in CIAO file
    %varlist  = CIAO_read_varlist(filename);

    %
    time = CIAO_read_real(filename,'time');
    % read variables
    T  = CIAO_read_real(filename, 'T');
    RHO = CIAO_read_real(filename, 'RHO');
    Pres = CIAO_read_real(filename, 'P');

    [time_1,~] = sort(time);
    time = time_1;
    clear time_1
    
    % write column headers & define xrange
    if fname == 1
        ht = 'time[ms]';
        % field width
        l_s = max(cellfun('length', SPEC)) + 1;
        l_s_str_spec = join(['  \t%',string(l_s),'s'], '');
        l_s_str_start = join(['%',string(l_s),'s  \t%',string(l_s), ...
            's  \t%',string(l_s),'s  \t%',string(l_s),'s'],'');
        l_s_str_sci1 = join(['\n%',string(l_s),'.5E'],'');
        l_s_str_sci  = join(['  \t%',string(l_s),'.5E'],'');
        if clipp == 1
            fid = fopen(output_file, 'w');
            fprintf(fid,l_s_str_start,ht);
            for i_spec = 1:n_species
                fprintf(fid,l_s_str_spec,string(append("VolCDOT_", string(SPEC(i_spec)))));
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

    % compute volumetric average species production rates
    Species = zeros(n_species, nx, ny, nz);
    for i_spec = 1:n_species
        Y_Spec = CIAO_read_real(filename, string(SPEC(i_spec)));
        Species(i_spec,:,:,:) = Y_Spec;
    end
    
    cdot = zeros(n_species, nx, ny, nz);
    for i = xstart:xend
        for j = 1:ny
            for k = 1:nz
                W = Compute_ReactionRates(Species(:,i,j,k), RHO(i,j,k), T(i,j,k), Pres(i,j,k));
                % net species production rate
                [CDOTp, CDOTd, CDOT] = Compute_ProductionRate(W);
                cdot(:,i,j,k) = CDOT;
            end
        end
    end

    % averaged
    for i_spec = 1:n_species
        Fraction_vector = cdot(i_spec,:,:,:);

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
