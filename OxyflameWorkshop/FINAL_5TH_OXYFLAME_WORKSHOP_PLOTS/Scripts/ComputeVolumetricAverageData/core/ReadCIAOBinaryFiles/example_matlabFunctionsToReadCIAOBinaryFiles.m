data_CIAO.filename = '1_lf_dx_3_2ndOrder_weno3/data.init_fromFlameMaster';

% read grid file ( gives back data_CIAO.grid.x, data_CIAO.grid.y, data_CIAO.grid.z, 
%                             data_CIAO.grid.xm, data_CIAO.grid.ym, data_CIAO.grid.zm) 
data_CIAO.grid  = CIAO_read_grid(data_CIAO.filename);

% read list of variables in CIAO file
data_CIAO.varlist  = CIAO_read_varlist(data_CIAO.filename);

% read mask field - return field is 1 where cells are solved/fluid, NAN everywhere else
% can be used to multiply with field for easy plotting (non-plotting) of
% walls)
data_CIAO.fluidcells  = CIAO_read_fluidCells(data_CIAO.filename);

% read specific real
data_CIAO.T     = CIAO_read_real(data_CIAO.filename,'T');

% just read first plane of real
data_CIAO.T_firstPlane =CIAO_read_real_plane(filename,'T')

% read in velocity (from faces and interpolate to cell center
data_CIAO.U     = CIAO_read_VelCenter(caseData.filename, 'U');

% read specific int
data_CIAO.integer = CIAO_read_int(data_CIAO.filename,'tempInt');

% calc rms values from CIAO statistics - first read in AVG and RMS from CIAO file 
Output_rmsDataSet = CIAO_calcRMS(Input_rmsDataSet, avgDataSet);

% read inflow file
inflowData = CIAO_read_inflowFile(inflowFileName);

% read chemtable
chemtableData = CIAO_read_chemtable(chemtableFileName);
