function chemtableData = CIAO_read_chemtable(filename)

% This script reads the grid and variables of CIAO chemtable files
% The grid is saved in the variables ZMIX, ZMIX_VAR and PROG
% The chemtable is saved in a 4-D array, where the last index parameterizes
% the variable. The variables of the chemtable are listed in the array
% chemtable_index.
%

fileopen = fopen(filename);

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
% Read in number of gridpoints and number of variables of the chemtable
%

nx = fread(fileopen,1,'int32');
ny = fread(fileopen,1,'int32');
nz = fread(fileopen,1,'int32');
nVar = fread(fileopen,1,'int32');

%
% Read in coordinates of the grid
%

ZMIX = fread(fileopen,nx,'real*8');
ZMIX_VAR = fread(fileopen,ny,'real*8');
PROG = fread(fileopen,nz,'real*8');

%
% Skip some lines the chemtable file
% 

mask = reshape(fread(fileopen,nx*ny*nz,'int32'),nx,ny,nz);

premixedCombModel =  fread(fileopen,64,'int8=>char');
chemtable = [];

%
% Read in names of variables
%

for index = 1:nVar
    name = fread(fileopen,64,'int8=>char');
    list{index}=deblank(strtrim(name)');
end

list{index+1} = 'mask';
chemtable_index = list';

%
% Read in chemtable
%
for index = 1:nVar
    tmp_field  = reshape(fread(fileopen,nx*ny*nz,'real*8'),nx,ny,nz);
    chemtable(:,:,:,index) = tmp_field;
end
chemtable(:,:,:,index+1) = mask;


chemtableData.ZMIX = ZMIX;
chemtableData.ZMIX_VAR = ZMIX_VAR;
chemtableData.PROG = PROG;
chemtableData.chemtable_index = chemtable_index;
chemtableData.chemtable = chemtable;