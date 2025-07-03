function [grid]=CIAO_read_grid(filename)
%
% This script reads the grid of CIAO data files
%
fileopen = fopen(filename);
%
%skip those lines
fname = fread(fileopen,64,'int8=>char');
preamble = fread(fileopen,4,'int32');
%
if(preamble(2)==2)
    %Read the first block
    name = (fread(fileopen,77,'int8=>char'))';
    subname =  fread(fileopen,77,'int8=>char');
    ctag1 = fread(fileopen,77,'int8=>char');
    ctag2 =  fread(fileopen,77,'int8=>char');
    id = fread(fileopen,1,'int32');
    skip = fread(fileopen,1,'int64');
    idata = fread(fileopen,16,'int32');
    rdata = fread(fileopen,16,'real*8');
    
    %
    while (id~=3)
        fseek(fileopen,skip-512,'cof');
        
        name = (fread(fileopen,77,'int8=>char'))';
        subname =  fread(fileopen,77,'int8=>char');
        ctag1 = fread(fileopen,77,'int8=>char');
        ctag2 =  fread(fileopen,77,'int8=>char');
        id = fread(fileopen,1,'int32');
        skip = fread(fileopen,1,'int64');
        idata = fread(fileopen,16,'int32');
        rdata = fread(fileopen,16,'real*8');        
    end
    
elseif(preamble(2)==4)
    %Read the first block
    name = (fread(fileopen,69,'int8=>char'))';
    subname =  fread(fileopen,69,'int8=>char');
    ctag1 = fread(fileopen,69,'int8=>char');
    ctag2 =  fread(fileopen,69,'int8=>char');
    id = fread(fileopen,1,'int32');
    skip = fread(fileopen,1,'int64');
    idata = fread(fileopen,16,'int32');
    idata8 = fread(fileopen,4,'int64');
    rdata = fread(fileopen,16,'real*8');
    %
    while (id~=103)
        fseek(fileopen,skip-512,'cof');
        name = (fread(fileopen,69,'int8=>char'))';
        subname =  fread(fileopen,69,'int8=>char');
        ctag1 = fread(fileopen,69,'int8=>char');
        ctag2 =  fread(fileopen,69,'int8=>char');
        id = fread(fileopen,1,'int32');
        skip = fread(fileopen,1,'int64');
        idata = fread(fileopen,16,'int32');
        idata8 = fread(fileopen,4,'int64');
        rdata = fread(fileopen,16,'real*8');
    end
    
end
% Here right position is found
% Read the face grid
x_grid = fread(fileopen,idata(1),'real*8');
y_grid = fread(fileopen,idata(2),'real*8');
z_grid = fread(fileopen,idata(3),'real*8');
%
%Create the cell centered grid
xm_grid=zeros((idata(1)-1),1);
for i=1:(idata(1)-1)
    xm_grid(i)=0.5*(x_grid(i)+x_grid(i+1));
end
ym_grid=zeros((idata(2)-1),1);
for j=1:(idata(2)-1)
    ym_grid(j)=0.5*(y_grid(j)+y_grid(j+1));
end
zm_grid=zeros((idata(3)-1),1);
for k=1:(idata(3)-1)
    zm_grid(k)=0.5*(z_grid(k)+z_grid(k+1));
end
fclose(fileopen);

grid.x  = x_grid;
grid.y  = y_grid;
grid.z  = z_grid;
grid.xm = xm_grid;
grid.ym = ym_grid;
grid.zm = zm_grid;
