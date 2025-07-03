!
! Copyright (C) 2005-2010 by  Institute of Combustion Technology - RWTH Aachen University
! Jens Henrik Goebbert, goebbert@itv.rwth-aachen.de (2007-2010)
! All rights reserved.
!

program trajSearch
    use mod_io
    use mod_traj
    use mod_dele
    use mod_postp
    use mod_extras
    use mod_data
    use hdf5
    use h5lt
    use omp_lib
    implicit none

!
!    -----------------------------------------------------
!
!    program to find all trajectories in of a flow field
!
!    -----------------------------------------------------
!
    integer(kind=4) iargc
    integer(kind=4) :: arg_num
    character(len=255)	:: phase_in
    character(len=255) :: dumpTraj_pktsize_in, dumpTraj_minlen_in, dumpTraj_ptstride_in, z2dlayer_in
    integer :: l

    integer(HID_T):: file_id, group_id, data_id, dspace_id

    integer			    :: eid, error, ndims123(3), maxtrajs, v
    double precision	:: minptr(3), maxptr(3)
    double precision	:: t_start, t_start_1, t_current, t_eid, t_togo
    double precision    :: ct_start, ct_end, cp_start, cp_end
    character(len=32) :: numpairs_string
    integer, dimension(3,2) :: subdomain_orig

    integer :: z2dlayer
    integer :: subdomain_ptr(3)
    integer(HSIZE_T), dimension(1) :: dims1
    integer(HSIZE_T), dimension(3) :: dims3, maxdims3

    ! print settings
    write(*,*) 'Compile Settings:'
#ifdef _CUBIC_CELLS_
    write(*,*) '  defined _CUBIC_CELLS_'
#else
    write(*,*) '  NOT defined _CUBIC_CELLS_'
#endif
#ifdef _TRAJCOUNT_
    write(*,*) '  defined _TRAJCOUNT_                = ',int(_TRAJCOUNT_,4)
#else
    write(*,*) '  NOT defined _TRAJCOUNT_'
#endif
#ifdef _NUMBERFIND_
    write(*,*) '  defined _NUMBERFIND_               = ',int(_NUMBERFIND_,4)
#else
    write(*,*) '  NOT defined _NUMBERFIND_'
#endif
#ifdef _CALCPAIRING_
    write(*,*) '  defined _CALCPAIRING_              = ',int(_CALCPAIRING_,4)
#else
    write(*,*) '  NOT defined _CALCPAIRING_'
#endif
#ifdef _RANDOM_
    write(*,*) '  defined _RANDOM_                   = ',int(_RANDOM_,4)
#else
    write(*,*) '  NOT defined _RANDOM_'
#endif
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
    write(*,*) '  defined _PAGE_SIZED_MEMORY_BLOCKS_ = ',int(_PAGE_SIZED_MEMORY_BLOCKS_,4)
#else
    write(*,*) '  NOT defined _PAGE_SIZED_MEMORY_BLOCKS_'
#endif
#ifdef _SCHEDULE_
    write(*,*) '  defined _SCHEDULE_                 = ',int(_SCHEDULE_,4)
#else
    write(*,*) '  NOT defined _SCHEDULE_'
#endif
#ifdef _NUMA_TPN_
    write(*,*) '  defined _NUMA_TPN_                 = ',int(_NUMA_TPN_,4)
#else
    write(*,*) '  NOT defined _NUMA_TPN_'
#endif
    write(*,*) '  maximum number of extrempoints     = ',max_numends

    ! do not adjust number of threads in parallel region at runtime
    call omp_set_dynamic(.false.)

#if (_TRAJCOUNT_!=0 && _TRAJCOUNT_!=1 && _TRAJCOUNT_!=3)
    write(*,*) 'preprocessor-flag _TRAJCOUNT_ wrong or not set !!!'
    stop
#endif

#if (_NUMBERFIND_!=0 && _NUMBERFIND_!=1 && _NUMBERFIND_!=2 && _NUMBERFIND_!=3 && _NUMBERFIND_!=4)
    write(*,*) 'preprocessor-flag _NUMBERFIND_ wrong or not set !!!'
    stop
#endif

#if(_CALCPAIRING_!=1 && _CALCPAIRING_!=2 && _CALCPAIRING_!=3)
    write(*,*) 'preprocessor-flag _CALCPAIRING_ wrong or not set !!!'
    stop
#endif

#if(_RANDOM_!=1 && _RANDOM_!=2)
    write(*,*) 'preprocessor-flag _RANDOM_ wrong or not set !!!'
    stop
#endif

    ! check/create input/output path
    arg_num = iargc()
    if(arg_num .ge. 4) then
        call getarg(1,file_path); file_path = trim(file_path)
        call getarg(2,input_dataset_path); input_dataset_path = trim(input_dataset_path)
        call getarg(3,traj_group_path); traj_group_path = trim(traj_group_path)
        	l = len(trim(traj_group_path))
        	if(traj_group_path(l:l) == '/') then
        		traj_group_path = traj_group_path(1:l-1)
        	endif
        call getarg(4,phase_in)
        read(phase_in,*) phase
    else
        write(*,*) ''
        write(*,*) 'Usage:'
        write(*,*) ' trajSearch_omp [file_path] [input_dset_path] [traj_group_path] [phase] [opts]'
        write(*,*) ''
        write(*,*) '     file_path          - input/output HDF5-file'
        write(*,*) '     input_dataset_path - HDF5 dataset path (3d,8-byte,float)'
        write(*,*) '     traj_group_path    - HDF5 group path (inout of trajSearch)'
        write(*,*) '     phase          1: search for min-max-points'
        write(*,*) '                         reading from input_dataset_path'
        write(*,*) '                         writing to existing(!) traj_group_path'
        write(*,*) '                         [opts]: [dset1] [dset2] ... [dsetn]'
        write(*,*) '                    2: search for trajectories'
        write(*,*) '                         (expects phase 1 to be finished !)'
        write(*,*) '                         reading from input_dataset_path and traj_group_path'
        write(*,*) '                         writing to traj_group_path'
        write(*,*) '                         [opts]: [dset1] [dset2] ... [dsetn]'
        write(*,*) '                    3: search for minimum attached elements'
        write(*,*) '                         (expects phase 1 and 2 to be finished !)'
        write(*,*) '                         reading from traj_group_path'
        write(*,*) '                         writing to traj_group_path'
        write(*,*) '                         [opts]: none'
        write(*,*) '                    4: find neighbours of dissipation elements'
        write(*,*) '                         (expects phase 1 to be finished !)'
        write(*,*) '                         reading from traj_group_path'
        write(*,*) '                         [DEVELOPER-CODE]'
        write(*,*) '                         [opts]: none'
        write(*,*) '                    5: calc properties along trajectories'
        write(*,*) '                         (expects phase 1 using trajcount to be finished !)'
        write(*,*) '                         reading from traj_group_path'
        write(*,*) '                         writing to file trajdeltaU_cond.txt'
        write(*,*) '                         writing to file trajlength_hist.txt'
        write(*,*) '                         [needed opts]: u_dset_path v_dset_path w_dset_path'
        write(*,*) '                         [additional opts]: paths to dsets of type input_dset'
        write(*,*) '                    6: save min-max-points only (no search for diss-elements)'
        write(*,*) '                         reading from input_dataset_path'
        write(*,*) '                         writing to existing(!) traj_group_path'
        write(*,*) '                         [opts]: none'
        write(*,*) '                    7: dump trajectory paths only'
        write(*,*) '                         reading from input_dataset_path'
        write(*,*) '                         writing to existing(!) traj_group_path'
        write(*,*) '                         [opts]: [dumpTraj_minlen] [dumpTraj_ptstride] [dumpTraj_pktsize]'
        write(*,*) '                    8: search for min-max-points on a 2d z-slice'
        write(*,*) '                         reading from input_dataset_path'
        write(*,*) '                         writing to existing(!) traj_group_path'
        write(*,*) '                         [opts]: [zlayer] [dset1] [dset2] ... [dsetn]'
        write(*,*) ''
        write(*,*) '     examples:'
        write(*,*) '       trajSearch_omp dns512.h5 /flow/DNSdata/chi1 /flow/TRAJdata/chi1/ 1'
        write(*,*) '       trajSearch_omp dns512.h5 /flow/DNSdata/k /flow/TRAJdata/k/ 2'
        write(*,*) ''

        stop
    endif

    write(*,*)
    write(*,*) 'number of processors  : ', omp_get_num_procs()
    write(*,*) 'max. number of threads: ', omp_get_max_threads()
    write(*,*)

    ! open HDF interface
    call h5eset_auto_f(0, error)
    call h5open_f(error)
    if(error .ne. 0) then
        write(*,*) 'ERROR: Cannot initialise HDF5-library'
        stop
    endif

    if( phase .ne. -1) then
      call h5fopen_f(file_path, H5F_ACC_RDWR_F, file_id, error)
      if(error .ne. 0) then
        write(*,*) 'ERROR: no valid HDF5-file found at ',trim(file_path)
        stop
      endif

      if(phase .ne. 0) then
        call h5dopen_f(file_id, input_dataset_path, data_id, error)
        if(error .ne. 0) then
          write(*,*) 'ERROR ',error,': no input_dataset found at ',trim(file_path)//':'//trim(input_dataset_path)
          stop
        endif

        call h5gopen_f(file_id, trim(traj_group_path), group_id, error)
        if(error .ne. 0) then
          write(*,*) 'ERROR: no traj_group found at ',trim(file_path)//':'//trim(traj_group_path)
          stop
        endif

        call h5gclose_f(group_id, error)
        call h5dclose_f(data_id,error)

      endif

      call h5fclose_f(file_id, error)

    endif

    call h5eset_auto_f(1, error)

    call init_globals

!
!    --------------------
!
!    run a simple test-dataset
!
!    --------------------
!
#ifdef _CUBIC_CELLS_
    if( phase .eq. -1) then
        write(*,*) '--------------------------'
        write(*,*) '          Phase -1        '
        write(*,*) '    Using Analytic Test   '
        write(*,*) '--------------------------'
        t_start = omp_get_wtime()

        ! read input data
        call test_read(file_path, input_dataset_path, traj_group_path, error)

        ! search for trajectories
        t_start_1 = omp_get_wtime()
        call initGlobalTraj()
        call findTraj(0,2)
        call finishGlobalTraj()
        write(*,fmt='(a,f8.1,a)') 'finished findTraj() after ',(omp_get_wtime() -t_start_1),'[s].'

        ! calculate min-max-pairs
        t_start_1 = omp_get_wtime()
        call calcParing()
        write(*,fmt='(a,f8.1,a)') 'finished calcParing() after ',(omp_get_wtime() -t_start_1),'[s].'

        ! save data to hdf5
        call hdf5_write_edata(file_path, traj_group_path, error)
        call xdmf_write(file_path, input_dataset_path, traj_group_path, error)
        call xdmf_write_minmax(file_path, traj_group_path, error)

        write(*,*)
        write(*,fmt='(a,f8.1,a)') 'finished phase after ',(omp_get_wtime() -t_start),'[s].'
    endif
#endif

!
!    --------------------
!
!    run a simple test-dataset
!
!    --------------------
!
#ifdef _CUBIC_CELLS_
    if( phase .eq. 0) then
        write(*,*) '--------------------------'
        write(*,*) '          Phase 0        '
        write(*,*) '    Transform 2D data    '
        write(*,*) '--------------------------'
        t_start = omp_get_wtime()

        ! read input data
        call hdf5_trans2D(file_path, input_dataset_path, traj_group_path, error)

        write(*,*)
        write(*,fmt='(a,f8.1,a)') 'finished phase after ',(omp_get_wtime() -t_start),'[s].'
    endif
#endif

!
!    --------------------
!
!    find/save rough informations of _all_ dissip. elements
!
!    --------------------
!
    if( phase .eq. 1) then
        write(*,*) '--------------------------'
        write(*,*) '          Phase 1         '
        write(*,*) '    Saving all Elements   '
        write(*,*) '--------------------------'
        t_start = omp_get_wtime()

        ! get additional variable dataset paths
        novars = arg_num-4
        allocate(vars_dataset_paths(novars),STAT=error)
        do v=1, novars
          call getarg(4+v,vars_dataset_paths(v))
        enddo

        ! read input data
        call hdf5_read(file_path, input_dataset_path, traj_group_path, error)

        ct_start = omp_get_wtime()

        ! search for trajectories
        call initGlobalTraj()
        call findTraj(0,1)
        call finishGlobalTraj()

        ct_end = omp_get_wtime()

        ! calculate min-max-pairs
        cp_start = omp_get_wtime()
        call calcParing()
        cp_end = omp_get_wtime()

        ! save data to hdf5
        call hdf5_write_edata(file_path, traj_group_path, error)
        call xdmf_write(file_path, input_dataset_path, traj_group_path, error)
        call xdmf_write_minmax(file_path, traj_group_path, error)
        call xdmf_write_length(file_path, traj_group_path, error)

        write(*,*)
        write(*,fmt='(a,f8.1,a)') 'finished phase after ',(omp_get_wtime() -t_start),'[s].'
        write(*,fmt='(a,f8.1,a)') '   calc trajectories ',(ct_end -ct_start),'[s].'
        write(*,fmt='(a,f8.1,a)') '   calc pairing      ',(cp_end -cp_start),'[s].'
    endif

!
!    --------------------
!
!    find/save every trajectory
!
!    --------------------
!
    if( phase .eq. 2) then
#ifdef _CUBIC_CELLS_
        write(*,*) '-----------------------------'
        write(*,*) '         Phase 2             '
        write(*,*) '   Saving all Trajektories   '
        write(*,*) '-----------------------------'
        t_start = omp_get_wtime()

        do_numberfind=0

        ! get additional variable dataset paths
        novars = arg_num-4
        allocate(vars_dataset_paths(novars),STAT=error)
        do v=1, novars
          call getarg(4+v,vars_dataset_paths(v))
        enddo

        ! read data to hdf5
        call hdf5_read(file_path, input_dataset_path, traj_group_path, error)
        call initGlobalTraj()
        call hdf5_read_edata(file_path, traj_group_path, error)

        ! create 'etraj' group - and save change to disk
        call h5fopen_f(file_path, H5F_ACC_RDWR_F, file_id, error)
        write(*,*) 'create ', trim(traj_group_path)//'/etraj'
        call h5gcreate_f(file_id, trim(traj_group_path)//'/etraj', group_id, error)
        call h5gclose_f(group_id, error)
        call h5fclose_f(file_id, error)

        ! open 'etraj' group
        call h5fopen_f(file_path, H5F_ACC_RDWR_F, file_id, error)
        write(*,*) 'open ', trim(traj_group_path)//'/etraj'
        call h5gopen_f(file_id, trim(traj_group_path)//'/etraj', group_id, error)

        write(numpairs_string, *) numpairs
        maxtrajs = maxval(pairing(1:numpairs,3))
        numpairs_string = trim(adjustl(numpairs_string))

        t_start = omp_get_wtime()

        subdomain_orig = subdomain
        do eid=1, numpairs

            t_current = omp_get_wtime()
            t_eid = (t_current -t_start) / eid
            t_togo = (numpairs *t_eid) -(t_current -t_start)

            write(*,*)
            write(*,fmt='(a,i,a,a,a,f8.4)') 'scanning element ',eid,'/ ',numpairs_string,' finish in [h]=', t_togo/3600.d0
            ! set min_ptr
            subdomain(1,1) = pairdomain(eid,1,1) -1
            subdomain(2,1) = pairdomain(eid,1,2) -1
            subdomain(3,1) = pairdomain(eid,1,3) -1
            if(subdomain(1,1) .lt. subdomain_orig(1,1)) subdomain(1,1) = subdomain_orig(1,1)
            if(subdomain(2,1) .lt. subdomain_orig(2,1)) subdomain(2,1) = subdomain_orig(2,1)
            if(subdomain(3,1) .lt. subdomain_orig(3,1)) subdomain(3,1) = subdomain_orig(3,1)

            ! set max_ptr
            subdomain(1,2) = pairdomain(eid,2,1) +1
            subdomain(2,2) = pairdomain(eid,2,2) +1
            subdomain(3,2) = pairdomain(eid,2,3) +1
            if(subdomain(1,2) .gt. subdomain_orig(1,2)) subdomain(1,2) = subdomain_orig(1,2)
            if(subdomain(2,2) .gt. subdomain_orig(2,2)) subdomain(2,2) = subdomain_orig(2,2)
            if(subdomain(3,2) .gt. subdomain_orig(3,2)) subdomain(3,2) = subdomain_orig(3,2)

            ! init memory to save dissipation elements
            minptr(1) = readin_points(pairing(eid,1),1)
            minptr(2) = readin_points(pairing(eid,1),2)
            minptr(3) = readin_points(pairing(eid,1),3)
            maxptr(1) = readin_points(pairing(eid,2),1)
            maxptr(2) = readin_points(pairing(eid,2),2)
            maxptr(3) = readin_points(pairing(eid,2),3)
            !write(*,*) minptr
            !write(*,*) maxptr

            call initOneDEle(maxtrajs, minptr, maxptr, pairing(eid,3))

            ! search for trajectories with a certain element id
            !!!! will overwrite points, signs, numbering !!!!
            call findTraj(eid,0)

            ! save trajectories of element
            call hdf5_write_etraj(group_id, eid, error)

            ! save boundary trajectories of element if 2d
            call hdf5_write_etraj_bounds(group_id, eid, error)

        end do

        call h5gclose_f(group_id, error)
        call h5fclose_f(file_id, error)

        ! reload points, signs
        call hdf5_read_edata(file_path, traj_group_path, error)
        ! write xmf-files
        call xdmf_write_etraj(file_path, traj_group_path, error)

        write(*,*)
        if(dEleTrajError .gt. 0) &
        	write(*,fmt='(a,i,a)') 'ATTENTION trunc of traj. after ',dEleSets_noPtsPerTraj,' steps:', dEleTrajError
        write(*,fmt='(a,f8.1,a)') 'finished phase after ',(omp_get_wtime() -t_start),'[s].'
#else
        write(*,*) '--------------------------------------------'
        write(*,*) '                   Phase 2                  '
        write(*,*) '      only equidistant grids supported      '
        write(*,*) '--------------------------------------------'
#endif
    endif

!    --------------------
!
!    write xdmf file and mae-infos
!
!    --------------------
    if( phase .eq. 3) then
#ifdef _CUBIC_CELLS_
        write(*,*) '-------------------------------------'
        write(*,*) '               Phase 3               '
        write(*,*) '  Minimum/Maximum Attached Elements  '
        write(*,*) '-------------------------------------'
        t_start = omp_get_wtime()

        ! read data to hdf5
        call hdf5_read(file_path, input_dataset_path, traj_group_path, error)
        call hdf5_read_edata(file_path, traj_group_path, error)
        call hdf5_write_maedata(file_path, traj_group_path, error)

        write(*,*)
        write(*,fmt='(a,f8.1,a)') 'finished phase after ',(omp_get_wtime() -t_start),'[s].'
#else
        write(*,*) '--------------------------------------------'
        write(*,*) '                   Phase 3                  '
        write(*,*) '      only equidistant grids supported      '
        write(*,*) '--------------------------------------------'
#endif
    endif


!    --------------------
!
!    write grouped elements
!
!    --------------------
    if( phase .eq. 4) then
#ifdef _CUBIC_CELLS_
        write(*,*) '--------------------------------------------'
        write(*,*) '                   Phase 4                  '
        write(*,*) '  Find neighbours of Dissipation  Elements  '
        write(*,*) '--------------------------------------------'
        t_start = omp_get_wtime()

        call group_elements(file_path, input_dataset_path, traj_group_path, error)

        write(*,*)
        write(*,fmt='(a,f8.1,a)') 'finished phase after ',(omp_get_wtime() -t_start),'[s].'
#else
        write(*,*) '--------------------------------------------'
        write(*,*) '                   Phase 4                  '
        write(*,*) '      only equidistant grids supported      '
        write(*,*) '--------------------------------------------'
#endif
    endif

!
!    --------------------
!
!    calc properties along trajektories
!   (considering the trajectory density)
!
!    --------------------
!
    if( phase .eq. 5) then
        write(*,*) '----------------------------------------'
        write(*,*) '         Phase 5                        '
        write(*,*) '   Calc Properties along Trajektories   '
        write(*,*) '----------------------------------------'
        t_start = omp_get_wtime()

        ! check vor u,v,w
        if(arg_num-4 .lt. 3) then
        	write(*,*) 'ERROR: uvw-dsets missing.'
        	write(*,*) '...EXIT.'
        	stop
        endif

        ! get additional variable dataset paths
        novars = arg_num-4
        allocate(vars_dataset_paths(novars),STAT=error)
        do v=1, novars
          call getarg(4+v,vars_dataset_paths(v))
        enddo

        do_numberfind = .false.
        do_trajcount  = .false.

        ! read input data
        call hdf5_read(file_path, input_dataset_path, traj_group_path, error)
        call initGlobalTraj()
        if(do_trajcount) then
          call hdf5_read_trajcount(file_path, traj_group_path, error)
        end if

        ! search for trajectories
        analyTraj = 1
        call findTraj(0,2)

        write(*,*)
        write(*,fmt='(a,f8.1,a)') 'finished phase after ',(omp_get_wtime() -t_start),'[s].'
    endif

!
!    --------------------
!
!    find/save rough informations of _all_ dissip. elements
!
!    --------------------
!
    if( phase .eq. 6) then
        write(*,*) '--------------------------'
        write(*,*) '          Phase 6         '
        write(*,*) '    Saving all MinMax     '
        write(*,*) '--------------------------'
        t_start = omp_get_wtime()

        ! read input data
        call hdf5_read(file_path, input_dataset_path, traj_group_path, error)

        ct_start = omp_get_wtime()
        ! search for trajectories
        call initGlobalTraj()
        call findTraj(0,2)
        call finishGlobalTraj()
        ct_end = omp_get_wtime()

        ! save data to hdf5
        call hdf5_write_edata(file_path, traj_group_path, error)

        write(*,*)
        write(*,fmt='(a,f8.1,a)') 'finished phase after ',(omp_get_wtime() -t_start),'[s].'
        write(*,fmt='(a,f8.1,a)') '   calc trajectories ',(ct_end -ct_start),'[s].'
    endif

!
!    --------------------
!
!    find/save rough informations of _all_ dissip. elements
!
!    --------------------
!
    if( phase .eq. 7) then
        write(*,*) '--------------------------'
        write(*,*) '          Phase 7         '
        write(*,*) '    Dump trajectories     '
        write(*,*) '--------------------------'
        t_start = omp_get_wtime()

        if(arg_num .ne. 7) then
          write(*,*) 'ERROR - seven arguments are needed: '
          write(*,*) '   [file_path] [input_dset_path] [traj_group_path] [phase] [dumpTraj_minlen] [dumpTraj_ptstride] [dumpTraj_pktsize]'
          stop
        endif

        call getarg(5,dumpTraj_minlen_in)
        read(dumpTraj_minlen_in,*) dumpTraj_minlen

        call getarg(6,dumpTraj_ptstride_in)
        read(dumpTraj_ptstride_in,*) dumpTraj_ptstride

        call getarg(7,dumpTraj_pktsize_in)
        read(dumpTraj_pktsize_in,*) dumpTraj_pktsize

        ! read input data
        call hdf5_read(file_path, input_dataset_path, traj_group_path, error)

        ct_start = omp_get_wtime()
        ! search for trajectories
        dumpTraj = 1
        call initGlobalTraj()
        call findTraj(0,2)
        call finishGlobalTraj()
        ct_end = omp_get_wtime()

        write(*,*)
        write(*,fmt='(a,f8.1,a)') 'finished phase after ',(omp_get_wtime() -t_start),'[s].'
        write(*,fmt='(a,f8.1,a)') '   calc trajectories ',(ct_end -ct_start),'[s].'
    endif

    if( phase .eq. 8) then
        write(*,*) '-----------------------------------------'
        write(*,*) '          Phase 8                        '
        write(*,*) '    Saving all Elements on a 2d z-slice  '
        write(*,*) '-----------------------------------------'
        t_start = omp_get_wtime()

        ! get z-layer
        call getarg(5, z2dlayer_in)
        read(z2dlayer_in,*) z2dlayer
        write(*,*) 'z2dlayer             : ', z2dlayer

        ! get additional variable dataset paths
        novars = arg_num-5
        allocate(vars_dataset_paths(novars),STAT=error)
        do v=1, novars
          call getarg(5+v,vars_dataset_paths(v))
        enddo

        ! calc subdomain with z-layer for 2D-calc
        call h5fopen_f(trim(file_path), H5F_ACC_RDWR_F, file_id, error)

        call h5dopen_f(file_id, trim(input_dataset_path), data_id, error)
        call h5dget_space_f(data_id, dspace_id, error)
        call h5sget_simple_extent_dims_f(dspace_id, dims3, maxdims3, error)
        call h5dclose_f(data_id, error)
        ndims = dims3

        if( z2dlayer .eq. 1) then
           subdomain(:,1) = (/1, 1, 1/)
           subdomain(:,2) = (/ndims(1), ndims(2), 3/)
        else if( z2dlayer .eq. ndims(3)) then
           subdomain(:,1) = (/1, 1, ndims(3)-2/)
           subdomain(:,2) = (/ndims(1), ndims(2),ndims(3)/)
        else
           subdomain(:,1) = (/1, 1, z2dlayer-1/)
           subdomain(:,2) = (/ndims(1), ndims(2), z2dlayer+1/)
        end if

        ! write subdomain_min/maxptr
        call h5gopen_f(file_id, trim(traj_group_path), group_id, error)
        dims1 =(/3/)
        subdomain_ptr = (/subdomain(1,1),subdomain(2,1),subdomain(3,1)/)
        call h5LTmake_dataset_f(group_id, 'subdomain_minptr', 1, dims1, H5T_NATIVE_INTEGER, subdomain_ptr, error)
        subdomain_ptr = (/subdomain(1,2),subdomain(2,2),subdomain(3,2)/)
        call h5LTmake_dataset_f(group_id, 'subdomain_maxptr', 1, dims1, H5T_NATIVE_INTEGER, subdomain_ptr, error)

        call h5gclose_f(group_id, error)
        call h5fclose_f(file_id, error)

        ! read input data
        call hdf5_read(file_path, input_dataset_path, traj_group_path, error)

        ! copy z-layer for 2D-calc
        if( z2dlayer .eq. 1) then
           psi(:,:,2) = psi(:,:,1)
           psi(:,:,3) = psi(:,:,1)
           coordz(3)  = coordz(1)+0.1d0
           coordz(2)  = coordz(1)
           coordz(1)  = coordz(1)-0.1d0
        else if( z2dlayer .eq. ndims(3)) then
           psi(:,:,ndims(3)-1) = psi(:,:,ndims(3))
           psi(:,:,ndims(3)-2) = psi(:,:,ndims(3))
           coordz(ndims(3)-2)  = coordz(ndims(3))-0.1d0
           coordz(ndims(3)-1)  = coordz(ndims(3))
           coordz(ndims(3))    = coordz(ndims(3))+0.1d0
        else
           psi(:,:,z2dlayer-1) = psi(:,:,z2dlayer)
           psi(:,:,z2dlayer+1) = psi(:,:,z2dlayer)
           coordz(z2dlayer-1)  = coordz(z2dlayer)-0.1d0
           !coordz(z2dlayer)   = coordz(z2dlayer)
           coordz(z2dlayer+1)  = coordz(z2dlayer)+0.1d0
        end if

        ! setting divergMax=-2.5 instead of -3.5(for 3d)
        spacedim = 2

        ct_start = omp_get_wtime()

        ! search for trajectories
        dumpGradDiv = 1
        call initGlobalTraj()
        call findTraj(0,1)
        call finishGlobalTraj()

        ct_end = omp_get_wtime()

        ! dump data as 3d data
        spacedim = 3

        ! calculate min-max-pairs
        cp_start = omp_get_wtime()
        call calcParing()
        cp_end = omp_get_wtime()

        ! save data to hdf5
        call hdf5_write_edata(file_path, traj_group_path, error)
        call hdf5_write_rand_eid(file_path, traj_group_path, error)

        call xdmf_write(file_path, input_dataset_path, traj_group_path, error)
        call xdmf_write_minmax(file_path, traj_group_path, error)
        call xdmf_write_length(file_path, traj_group_path, error)

        write(*,*)
        write(*,fmt='(a,f8.1,a)') 'finished phase after ',(omp_get_wtime() -t_start),'[s].'
        write(*,fmt='(a,f8.1,a)') '   calc trajectories ',(ct_end -ct_start),'[s].'
        write(*,fmt='(a,f8.1,a)') '   calc pairing      ',(cp_end -cp_start),'[s].'

    endif
!
!    --------------------
!
!    find/save every trajectory
!
!    --------------------
!
    if( phase .eq. 9) then

        write(*,*) '-----------------------------------------'
        write(*,*) '          Phase 9                        '
        write(*,*) '    Saving Trajectories on a 2d z-slice  '
        write(*,*) '-----------------------------------------'
        do_numberfind=0

        ! get z-layer
        call getarg(5, z2dlayer_in)
        read(z2dlayer_in,*) z2dlayer
        write(*,*) 'z2dlayer             : ', z2dlayer

        ! get additional variable dataset paths
        novars = arg_num-5
        allocate(vars_dataset_paths(novars),STAT=error)
        do v=1, novars
          call getarg(5+v,vars_dataset_paths(v))
        enddo
        t_start = omp_get_wtime()

        ! read input data
        call hdf5_read(file_path, input_dataset_path, traj_group_path, error)

        ! copy z-layer for 2D-calc
        if( z2dlayer .eq. 1) then
           psi(:,:,2) = psi(:,:,1)
           psi(:,:,3) = psi(:,:,1)
           coordz(3)  = coordz(1)+0.1d0
           coordz(2)  = coordz(1)
           coordz(1)  = coordz(1)-0.1d0
        else if( z2dlayer .eq. ndims(3)) then
           psi(:,:,ndims(3)-1) = psi(:,:,ndims(3))
           psi(:,:,ndims(3)-2) = psi(:,:,ndims(3))
           coordz(ndims(3)-2)  = coordz(ndims(3))-0.1d0
           coordz(ndims(3)-1)  = coordz(ndims(3))
           coordz(ndims(3))    = coordz(ndims(3))+0.1d0
        else
           psi(:,:,z2dlayer-1) = psi(:,:,z2dlayer)
           psi(:,:,z2dlayer+1) = psi(:,:,z2dlayer)
           coordz(z2dlayer-1)  = coordz(z2dlayer)-0.1d0
           !coordz(z2dlayer)   = coordz(z2dlayer)
           coordz(z2dlayer+1)  = coordz(z2dlayer)+0.1d0
        end if

        call initGlobalTraj()
        call hdf5_read_edata(file_path, traj_group_path, error)

        ! create 'etraj' group - and save change to disk
        call h5fopen_f(file_path, H5F_ACC_RDWR_F, file_id, error)
        call h5gcreate_f(file_id, trim(traj_group_path)//'/etraj', group_id, error)
        call h5gclose_f(group_id, error)
        call h5fclose_f(file_id, error)

        ! open 'etraj' group
        call h5fopen_f(file_path, H5F_ACC_RDWR_F, file_id, error)
        call h5gopen_f(file_id, trim(traj_group_path)//'/etraj', group_id, error)

        write(numpairs_string, *) numpairs
        maxtrajs = maxval(pairing(1:numpairs,3))
        numpairs_string = trim(adjustl(numpairs_string))

        t_start = omp_get_wtime()

        subdomain_orig = subdomain
        do eid=1, numpairs

            t_current = omp_get_wtime()
            t_eid = (t_current -t_start) / eid
            t_togo = (numpairs *t_eid) -(t_current -t_start)

            write(*,*)
            write(*,fmt='(a,i,a,a,a,f8.4)') 'scanning element ',eid,'/ ',numpairs_string,' finish in [h]=', t_togo/3600.d0
            ! set min_ptr
            subdomain(1,1) = pairdomain(eid,1,1) -1
            subdomain(2,1) = pairdomain(eid,1,2) -1
            subdomain(3,1) = pairdomain(eid,1,3) -1
            if(subdomain(1,1) .lt. subdomain_orig(1,1)) subdomain(1,1) = subdomain_orig(1,1)
            if(subdomain(2,1) .lt. subdomain_orig(2,1)) subdomain(2,1) = subdomain_orig(2,1)
            if(subdomain(3,1) .lt. subdomain_orig(3,1)) subdomain(3,1) = subdomain_orig(3,1)

            ! set max_ptr
            subdomain(1,2) = pairdomain(eid,2,1) +1
            subdomain(2,2) = pairdomain(eid,2,2) +1
            subdomain(3,2) = pairdomain(eid,2,3) +1
            if(subdomain(1,2) .gt. subdomain_orig(1,2)) subdomain(1,2) = subdomain_orig(1,2)
            if(subdomain(2,2) .gt. subdomain_orig(2,2)) subdomain(2,2) = subdomain_orig(2,2)
            if(subdomain(3,2) .gt. subdomain_orig(3,2)) subdomain(3,2) = subdomain_orig(3,2)

            ! init memory to save dissipation elements
            minptr(1) = readin_points(pairing(eid,1),1)
            minptr(2) = readin_points(pairing(eid,1),2)
            minptr(3) = readin_points(pairing(eid,1),3)
            maxptr(1) = readin_points(pairing(eid,2),1)
            maxptr(2) = readin_points(pairing(eid,2),2)
            maxptr(3) = readin_points(pairing(eid,2),3)

            write(*,*) 'min-subd: ', subdomain(1:3,1)
            write(*,*) 'max-subd: ', subdomain(1:3,2)
            write(*,*) 'min-extid: ', pairing(eid,1)
            write(*,*) 'max-extid: ', pairing(eid,2)

            call initOneDEle(maxtrajs, minptr, maxptr, pairing(eid,3))

            ! search for trajectories with a certain element id
            !!!! will overwrite points, signs, numbering !!!!
            spacedim = 2
            call findTraj(eid,0)
            spacedim = 3

            ! save trajectories of element
            call hdf5_write_etraj(group_id, eid, error)

            ! save boundary trajectories of element if 2d
            spacedim = 2
            call hdf5_write_etraj_bounds(group_id, eid, error)
            spacedim = 3

        end do

        call h5gclose_f(group_id, error)
        call h5fclose_f(file_id, error)

        ! reload points, signs
        call hdf5_read_edata(file_path, traj_group_path, error)
        ! write xmf-files
        call xdmf_write_etraj(file_path, traj_group_path, error)
        call xdmf_write_etraj_bounds(file_path, traj_group_path, error)

        write(*,*)
        if(dEleTrajError .gt. 0) &
            write(*,fmt='(a,i,a)') 'ATTENTION trunc of traj. after ',dEleSets_noPtsPerTraj,' steps:', dEleTrajError
        write(*,fmt='(a,f8.1,a)') 'finished phase after ',(omp_get_wtime() -t_start),'[s].'

    endif

    ! close HDF interface
    call h5close_f(error)

end

