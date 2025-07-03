Hello new user,

'trajSearch' is a shared-memory parallelized (OpenMP) application developed at the Institute for Combustion Technology.
It is a research code, which searches for trajectories and their paths in 2d/3d scalar fields
and groups these to dissipation elements.

The algorithm was developed by Lipo Wang (lwang@itv.rwth-aachen.de) in 2005 at the Institute of Combustion (RWTH Aachen University)
and feature development and parallelization was done 2006-2009 by Jens Henrik Göbbert (goebbert@itv.rwth-aachen.de).
Any suggestions/bugfixes are welcomed. Please do not hesitate.

'trajSearch' reads an input scalar double precision data set from an HDF5 file (www.hdfgroup.org) and writes its output to that same file again.
The code distinguish between different operations called 'phases' from which the most important are
	1: search for min-max-points
	2: search for trajectories

How to proceed:
	1. Install HDF5 and hdf5view from www.hdfgroup.org.
	2. Check src/Makefile and compile the trajSearch.
	3. Try to reproduce the results of example_3d.
		Copy turb_forced_k.h5 to new directory.
		Open file in hdf5view and create new subdirectory inside TRAJdata folder.
		Run trajSearch as described in run_trajSearch_omp.sh with that subdirectory.
	4. Compare results with output filed in example_3d (expect minor differences).
	5. Please read the following carefully and make sure you understand each line and comment to interpret the results.

------------
 Usage: trajSearch [file_path] [input_dataset_path] [traj_group_path] [phase] [optional phase-specific-arguments]

      file_path          - input/output HDF5-file
      input_dataset_path - HDF5 dataset path (3d,8-byte,float)
      traj_group_path    - HDF5 group path (inout of trajSearch)
      phase         -1: phase 1 with analytic test case
                          writing test case to input_dataset_path
                          writing to existing(!) traj_group_path
                          [optional]: none
                     0: transform 2d dataset to 3d dataset by extending with same data in Z
                          reading from input_dataset_path
                          writing to 'traj_group_path)/trans2D'
                          [optional]: none
                     1: search for min-max-points
                          reading from input_dataset_path
                          writing to existing(!) traj_group_path
                          [optional]: none
                     2: search for trajectories
                          (expects phase 1 to be finished !)
                          reading from input_dataset_path and traj_group_path
                          writing to traj_group_path
                          [optional]: [dset1] [dset2] ... [dsetn]
                            saves dataset values along trajectories in etraj_*_vars
                            saves dataset values along trajectories in etraj_*_int
                            saves dataset values along trajectories in etraj_*_dble
                     3: search for minimum/maximum attached elements
                          (expects phase 1 to be finished !)
                          reading from traj_group_path
                          writing to traj_group_path
                          [optional]: none
                     4: find neighbors of dissipation elements
                          (expects phase 1 to be finished !)
                          reading from traj_group_path'
                          [DEVELOPER-CODE]'
                          [opts]: none'
                     5: calc properties along trajectories
                          (expects phase 1 using trajcount to be finished !)
                          reading from traj_group_path
                          writing to files 'traj_cond.txt', 'traj_joined.txt' and 'trajlength_hist.txt'
                          [must have]: u_dataset_path v_dataset_path w_dataset_path
                          [opts]: additional datasets_paths

Compile-Settings (for Makefile):
   _TRAJCOUNT_         => 0: no calc/save of trajcount (counting of trajectories per cells)
                       => 1: calc/save trajcount using a global array (slow, but less memory)
                       => 3: calc/save trajcount, each thread sync with global array after each completed trajectory
   _CUBIC_2PI_         => expects a grid with cubic cells and a 2pi^3 domain (is faster) - ignores coordxyz-datasets
   _NUMBERFIND_        => 0: no call of numberfind() in walkTraj()
                       => 1: call slow numberfind() (but less memory)
                       => 2: call fast numberfind() (but more memory)
Standard Settings should be _TRAJCOUNT_=3 + _CUBIC_2PI_ + _NUMBERFIND_=2

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!! VERY IMPORTANT - VERY IMPORTANT !!!
!!!
!!! IDs definition
!!! --------------
!!! IDs always start from 1 (ID=0 does NOT exist!)
!!! =>using IDs as array-position:
!!!      id=1 <=> 1st element in array
!!!      1st element index in C/C++  = 0 : array[0]
!!!      1st element index in Fortran= 1 : array[1]
!!!      => 1st element index depends on the application you use to read the hdf5-file
!!!         make sure you know how your applications sets indices of array !
!!!
!!! global xyz-coordinates
!!! ----------------------
!!! global xyz-coordinates start at 0.0, 0.0, 0.0 for cubic-cases
!!!
!!! XYZ or ZYX
!!! ----------
!!! your application may read 3d-arrays in reverse order => not XYZ but ZYX
!!! 	eg. Fortran apps read XYZ, C/C++ apps read ZYX
!!! THIS HELP IS WRITTEN FROM FORTRAN_POINT_OF_VIEW !!!
!!!
!!! Pitfalls
!!! --------
!!! hdfview presents the data in C/C++ style with 1st element index =0
!!! and reverse 3d-array-order = ZYX
!!!
!!! VERY IMPORTANT - VERY IMPORTANT !!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

HDF5-Input
  /input_dataset_path              - (8-byte-float-3d)                - eg. /DNSdata/u
  /traj_group_path/                - (hdf5-group)                     - eg. /TRAJdata/u/
    subdomain_minptr(3)            - (optional, 3*integer-1d, XYZ-grid-node-id) - eg. (1,1,1)    - 1st element in all dimensions is minimum!
    subdomain_maxptr(3)            - (optional, 3*integer-1d, XYZ-grid-node-id) - eg. (20,10,15) - last element in all dimensions is maximum!
    coordx(x-dim of input_dataset) - (MUST HAVE if NONE_CUBIC_CELLS, xdim *8-byte-float-1d)									!! read "VERY-IMPORTANT-Section" => xdim=FORTRAN_POINT_OF_VIEW
    coordy(y-dim of input_dataset) - (MUST HAVE if NONE_CUBIC_CELLS, ydim *8-byte-float-1d)
    coordz(z-dim of input_dataset) - (MUST HAVE if NONE_CUBIC_CELLS, zdim *8-byte-float-1d)									!! read "VERY-IMPORTANT-Section" => zdim=FORTRAN_POINT_OF_VIEW
    Lx                             - (optional if CUBIC_CELLS, integer-1d, domain x-size - NOT subdomain size) 
    Ly                             - (optional if CUBIC_CELLS, integer-1d, domain y-size - NOT subdomain size)   
    Lz                             - (optional if CUBIC_CELLS, integer-1d, domain z-size - NOT subdomain size)

HDF5-Output
  (phase 1):
    ecount                   - number of elements
    eid(x,y,z)               - element ID for each grid point
    egpts(x,y,z)             - element grid points for each grid point
    maxcount                 - number of maxima
    mincount                 - number of minima
    minmax_pos(extrId,xyz)   - grid position -1.0 of extram (minima and maxima)
    minmax_type(extrId,type) - type of local extrema (-1=minimum, +1=maximum) 					!! read "VERY-IMPORTANT-Section"
    minmax_val(extrId,value) - value at local extrema 											!! read "VERY-IMPORTANT-Section"

    edata_int(eid,012)       - min-grid-ptr of bounding-box of element "eid" 					!! read "VERY-IMPORTANT-Section"
    edata_int(eid,345)       - max-grid-ptr of bounding-box of element "eid" 					!! read "VERY-IMPORTANT-Section"
    edata_int(eid,6)         - extrId of minimum of element "eid" 								!! read "VERY-IMPORTANT-Section"
    edata_int(eid,7)         - extrId of maximum of element "eid" 								!! read "VERY-IMPORTANT-Section"
    edata_int(eid,8)         - number of grid-points of element "eid" 							!! read "VERY-IMPORTANT-Section"

    edata_dble(eid, 012)     - grid position -1.0 of mimimum of element "eid"					!! read "VERY-IMPORTANT-Section"
    edata_dble(eid, 345)     - grid position -1.0 of maximum of element "eid"					!! read "VERY-IMPORTANT-Section"
    edata_dble(eid, 6)       - grid-distance between minimum and maximum of element "eid"		!! read "VERY-IMPORTANT-Section"
    edata_dble(eid, 7)       - value of minimum of element "eid"								!! read "VERY-IMPORTANT-Section"
    edata_dble(eid, 8)       - value of maximum of element "eid"								!! read "VERY-IMPORTANT-Section"
    edata_dble(eid, 9)       - value of delta=(maximum-minimum) of element "eid"				!! read "VERY-IMPORTANT-Section"
    edata_dble(eid, 10)      - grid-points of element ( ~ simplyfied "volume")					!! read "VERY-IMPORTANT-Section"

  (phase 2):
    etraj/etraj_[eid](ptrId,012)         - grid position -1.0 of all points of all trajectories of element "eid"
    etraj/etraj_[eid](ptrId,3)           - interpolated value psi at ptrId
    etraj/etraj_[eid](ptrId,3)           - distance to ptrId-1

    etraj/etraj_[eid]_int(trajId,1)      - ptrId-start of trajectory with "trajId"
    etraj/etraj_[eid]_int(trajId,2)      - ptrId-end of trajectory with "trajId"
    etraj/etraj_[eid]_int(trajId,3)      - number of ptr of trajectory with "trajId"

    etraj/etraj_[eid]_dble(trajId,1)     - lenght of trajectory with "trajId"

    etraj/etraj_[eid]_vars(ptrId,novars) - interpolated values of optional datasets in phase 2 along trajectories at ptrId
    etraj/etraj_[eid]_vars(ptrId,novars+1) - normal vectors x of gradient field psi at ptrId
    etraj/etraj_[eid]_vars(ptrId,novars+2) - normal vectors y of gradient field psi at ptrId
    etraj/etraj_[eid]_vars(ptrId,novars+3) - normal vectors z of gradient field psi at ptrId
    etraj/etraj_[eid]_vars(ptrId,novars+4) - gradient psi at ptrId
    etraj/etraj_[eid]_vars(ptrId,novars+5) - trajectory density at ptrId

    etraj/etraj_[eid]_bounds(ptrId,xyz)  - grid position -1.0 of all points of boundary-trajectories of element "eid"
                                          (this algorithmn leads in some cases to _WRONG_ results - only use for visualisation)
  (phase 3):
    minattid(x,y,z)          - minimum-attached-element (all elements attached to one minimum) id for each grid point
    maxattid(x,y,z)          - maximum-attached-element (all elements attached to one maximum) id for each grid point
    minattgpts(x,y,z)        - minimum-attached-element (all elements attached to one minimum) grid points for each grid point
    maxattgpts(x,y,z)        - maximum-attached-element (all elements attached to one maximum) grid points for each grid point

Directory
|
|--3rdparty: libraries trajSearch
|    |--hdf5 - must have
|    |--fftw - for refinement of periodic grids (probably disabled)
|    |--libz - needed by hdf5, but installed on standard systems anyway
|
|--src: source directory of trajSearch
|
|--tools:
|    |--any2hdf5  - tool to translate an file format to hdf5-format needed by trajSearch
|    |--lipo2hdf5 - tool to translate the special file format of Lipo Wang to hdf5
|
|--run: run directory to execute trajSearch


Parallel Hints:
---------------
* To compile parallel code make sure you have "-openmp" activated in src/Makefile
* use "export OMP_NUM_THREADS=4" before running the executable to set the number of threads used by openmp to 4 (or even more)


Programming Hints:
------------------
important input-arrays:
set by hdf5_read()
        double precision psi
        double precision u,v,w
      (if unstructured grid):
        double precision coordx,coordy,coordz
        coordxyz(i) _must_ be greater than coordxyz(i+1) !!!

important output-arrays:
calculated by mod_Traj->findTraj()
    logical signs        			! (+:true, -:false) minumum,maximum
    double precision points       	! (pointNo,xyz)
    integer numbering   		! (i,j,k,max(1)/min(2)-pointNo)

    example:
        input: i,j,k
        output: min/max-coord
            numbering(i,j,k,1) => maximumId
            numbering(i,j,k,2) => minimumId
            points(maximumId,1) => maxPtrX
            points(maximumId,2) => maxPtrY
            points(maximumId,3) => maxPtrZ
        input: points-array-id
        output: min/max
            Minimum oder Maximum? -> signs(id) => true=max / false=min

calucated by mod_postp->calcPairing()
    integer numpairs	! number of dissipation elements
    integer pairing	! pairing(elementId<=numpairs, maxId/minId/number of gridpoints)
    integer note 	! the elementId a trajectory from ijk belongs to
    integer pairdomain ! stores the subdomain of each element(pair)(elementId,min/max,xyz)

    example:
        input: i,j,k
            note(i,j,k) => elementId
            pairing(elementId,1) => maximumId =>points(maximumId,1) => x-coord
            pairing(elementId,2) => minimumId
            pairing(elementId,3)=> number of gridpoints=number of trajectories
            pairdomain(elementId,1,1) => min x
            pairdomain(elementId,1,2) => min y
            pairdomain(elementId,1,3) => min z
            pairdomain(elementId,2,1) => max x
            pairdomain(elementId,2,2) => max y
            pairdomain(elementId,2,3) => max z
