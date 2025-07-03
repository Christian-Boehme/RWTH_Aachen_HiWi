function [varlist]=CIAO_read_varlist(filename)
%
% This script reads 1d data of CIAO data files
%
fileopen = fopen(filename);
%
%skip those lines
fname = fread(fileopen,64,'int8=>char');
preamble = fread(fileopen,4,'int32');
%
i=1;
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
    list{i}=strtrim(name);
    %
    while (strcmp(strtrim(name),'LAST')==0)
        i=i+1;
        fseek(fileopen,skip-512,'cof');
        name = (fread(fileopen,77,'int8=>char'))';
        subname =  fread(fileopen,77,'int8=>char');
        ctag1 = fread(fileopen,77,'int8=>char');
        ctag2 =  fread(fileopen,77,'int8=>char');
        id = fread(fileopen,1,'int32');
        skip = fread(fileopen,1,'int64');
        idata = fread(fileopen,16,'int32');
        rdata = fread(fileopen,16,'real*8');
        list{i}=strtrim(name);       
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
    list{i}=strtrim(name);
    %
    while (strcmp(strtrim(name),'LAST')==0)
        i=i+1;
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
        list{i}=strtrim(name);
    end
    
    elseif(preamble(2)==0)

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
    list{i}=strtrim(name);
    %
    while (strcmp(strtrim(name),'LAST')==0)
        i=i+1;
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
        list{i}=strtrim(name);
    end
    
end
varlist=list';
fclose(fileopen);
