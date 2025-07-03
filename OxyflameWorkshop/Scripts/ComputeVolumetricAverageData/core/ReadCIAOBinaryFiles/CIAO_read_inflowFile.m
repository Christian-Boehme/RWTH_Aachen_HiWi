function [ inflowData ] = CIAO_read_inflowFile( filename )

% Read in inflow File

fileopen = fopen(filename);
disp(['Open file: ' filename]);

% Check for file version
preamble1 = fread(fileopen,16,'int8=>char');
if( strcmp(strtrim(preamble1(1:13)'), 'NGA_IO STARTS') )
    usePreamble = 1;
else
    usePreamble = 0;
end

fseek(fileopen, 0, 'bof');

if(usePreamble)
    preamble1 = fread(fileopen,16,'int8=>char');
    preamble2 = fread(fileopen,48,'int8=>char');
    header  = fread(fileopen,4,'int32');
end

%
inflowData.inflow_ntime    = fread(fileopen,1,'int32');
inflowData.inflow_ny       = fread(fileopen,1,'int32');
inflowData.inflow_nz       = fread(fileopen,1,'int32');
inflowData.inflow_nvar     = fread(fileopen,1,'int32');

inflowData.inflow_freq     = fread(fileopen,1,'real*8');
inflowData.inflow_time     = fread(fileopen,1,'real*8');
%
for nvar = 1:inflowData.inflow_nvar
    inflowData.inflow_varlist(nvar) = {fread(fileopen,64,'int8=>char')};
end
%
inflowData.inflow_icyl     = fread(fileopen,1,'int32');
inflowData.inflow_grid_y   = fread(fileopen,inflowData.inflow_ny+1,'real*8');
inflowData.inflow_grid_z   = fread(fileopen,inflowData.inflow_nz+1,'real*8');

% inflow_data     = NaN(inflowData.inflow_ny, inflowData.inflow_nz, inflowData.inflow_nvar, inflowData.inflow_ntime);
% for ntime = 1:inflowData.inflow_ntime
%     for nvar = 1:inflowData.inflow_nvar
%         inflow_tmp                    = fread(fileopen,inflowData.inflow_ny*inflowData.inflow_nz,'real*8');
%         inflow_data(:,:,nvar,ntime)   = reshape( inflow_tmp, inflowData.inflow_ny, inflowData.inflow_nz );
%     end
% end
% 
% inflowData.inflow_data = inflow_data;

fclose all;
disp(['Close file - Finish Reading: ' filename]);
