function [var]=CIAO_read_fluidCells(filename)

% disp('ATTENTION!!');
% disp('The routine CIAO_read_CVMask has only been tested for simple cases');
% disp('Please check if the output is reasonable before using it.');

fileopen = fopen(filename);

%skip those lines
fname = fread(fileopen,64,'int8=>char');
preamble = fread(fileopen,4,'int32');    

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
    while (id ~= 402)
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
    
dummy = fread(fileopen,idata8(1),'int64');
%%
coordinates_cvMask = nan(size(dummy,1),3);
nx = idata(6)-idata(5)+1;
ny = idata(8)-idata(7)+1;
nz = idata(10)-idata(9)+1;

tmpMask = nan(nx,ny,nz);
iorigin(1) = 1;
iorigin(2) = 1;
iorigin(3) = 1;

for n = 1:size(dummy)

    ijk8(3) = floor(dummy(n)/(nx*ny)) + iorigin(3);
    ijk8(2) = floor((dummy(n) - ((ijk8(3)-iorigin(3))*nx*ny))/nx) + iorigin(2);
    ijk8(1) = dummy(n) - (ijk8(3)-iorigin(3))*nx*ny - (ijk8(2)-iorigin(2))*nx + iorigin(1);

    tmpMask(ijk8(1),ijk8(2),ijk8(3)) = 1;

end    

var = tmpMask;

%     %%
%     while (id ~= 507)
% %         fseek(fileopen,skip-512,'cof');
%         name = (fread(fileopen,69,'int8=>char'))'
%         subname =  fread(fileopen,69,'int8=>char');
%         ctag1 = fread(fileopen,69,'int8=>char');
%         ctag2 =  fread(fileopen,69,'int8=>char');
%         id = fread(fileopen,1,'int32')
%         skip = fread(fileopen,1,'int64');
%         idata = fread(fileopen,16,'int32');
%         idata8 = fread(fileopen,4,'int64')
%         rdata = fread(fileopen,16,'real*8');
%     end
%     
%     %%
%     dummy = fread(fileopen,idata8(1),'int32');
%     min(dummy)
%     max(dummy)
    
