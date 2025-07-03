function [var]=CIAO_read_int(filename,varname)
%
% This script reads 3d data of CIAO data files
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
    while (strcmp(strtrim(name),varname)==0)
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
    while (strcmp(strtrim(name),varname)==0)
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

if (skip==512)
    var=rdata(1);
else
    dummy = fread(fileopen,((idata(4)-idata(3)+1)*(idata(6)-idata(5)+1)*(idata(8)-idata(7)+1)*(idata(10)-idata(9)+1)),'int32');
    var_tmp=reshape(dummy,(idata(4)-idata(3)+1),(idata(6)-idata(5)+1),(idata(8)-idata(7)+1),(idata(10)-idata(9)+1));
    var=squeeze(var_tmp);
end
fclose(fileopen);
