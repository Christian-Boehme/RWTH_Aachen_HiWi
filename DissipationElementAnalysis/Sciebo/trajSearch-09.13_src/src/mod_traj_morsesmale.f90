!
! Copyright (C) 2005-2010 by  Institute of Combustion Technology - RWTH Aachen University
! Lipo Wang, lwang@itv.rwth-aachen.de (2005-2006)
! Jens Henrik Goebbert, goebbert@itv.rwth-aachen.de (2007-2010)
! All rights reserved.
!

#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
#include "mod_psmb.h"
#endif

#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
#define psi(i,j,k) psmb_arr_3d(psi_b,i,j,k)
#define numbering(i,j,k,v) psmb_arr_4d(numbering_b,i,j,k,v)
#define trajcount(i,j,k) psmb_arr_3d(trajcount_b,i,j,k)
#define vars(i,j,k,v) psmb_arr_4d(vars_b,i,j,k,v)
#endif

module mod_traj
    use mod_data

    implicit none
    !save

    ! global vars depending on input data
    double precision :: divergMax

    ! constants
    double precision :: jumpeps
    double precision :: pace
    double precision :: traj_err

    ! tuning parameters
    parameter(jumpeps=2.d-5)
    parameter(pace=0.02d0)
    parameter(traj_err=0.2d0)

    integer :: force0_count

    contains

!
!     --------------------
!
!     subroutine initGlobalTraj()
!
!     --------------------
!
    subroutine initGlobalTraj()
        use omp_lib
        implicit none

        integer :: alloc_err=0
        integer :: i,j,k,b

        if( do_numberfind ) then

        	! Initialization
        	call allocate_globals('signs',alloc_err)
        	signs = .true.

        	call allocate_globals('points',alloc_err)
        	points = 0.d0


#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
        	call allocate_globals('numbering_b',alloc_err)
        	call init_int4d(0, numbering_b, 1)
        	call init_int4d(0, numbering_b, 2)
#else
        	call allocate_globals('numbering',alloc_err)
        	call init_int4d(0, numbering, 1)
        	call init_int4d(0, numbering, 2)
#endif

#if (_NUMBERFIND_==2)
        	call allocate_globals('counter',alloc_err)
        	call allocate_globals('identity',alloc_err)
        	!$omp parallel                                          &
        	!$omp default( shared )                                 &
        	!$omp private( i,j,k )
        	!$omp do schedule (static)
        	do b=1, nblocks_all
        	  do k=bstart(b,3)-1,bend(b,3)+1
        	    do j=bstart(b,2)-1,bend(b,2)+1
        	      do i=bstart(b,1)-1,bend(b,1)+1
        			counter(i,j,k,:) = 0.d0
        			identity(i,j,k)= 0
        	      enddo
        	    enddo
        	  enddo
        	enddo
        	!$omp end do
        	!$omp end parallel
#endif

        endif

        if(do_trajcount) then
#if (_TRAJCOUNT_>0)
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
        	call allocate_globals('trajcount_b',alloc_err)
        	call init_int3d(0, trajcount_b)
#else
        	call allocate_globals('trajcount',alloc_err)
        	call init_int3d(0, trajcount)
#endif
#endif
        endif

        if(dumpGradDiv) then
            call allocate_globals('graddiv',alloc_err)
            call init_dble3d(-1.d100, graddiv)
        end if

        numends   = 0

        tattrs = dEleTrajVars_offset +novars

        ! set special values for 2D/3D
        if(spacedim .eq. 2) then
            divergMax = -2.5
        else if(spacedim .eq. 3) then
            divergMax = -3.5
        else
            write(*,*) 'ERROR: unsupported space dimension',spacedim
        endif

        return
    end subroutine initGlobalTraj

!
!     --------------------
!
!     subroutine finishGlobalTraj()
!		free temp. memory only needed for walkTraj()
!     --------------------
!
    subroutine finishGlobalTraj()
        use mod_data
        implicit none

        call deallocate_globals('counter')
        call deallocate_globals('identity')

#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
        call transform_results()
#endif

        return
    end subroutine finishGlobalTraj

!
!     --------------------
!
!     subroutine findTraj()
!
!     Walks along the trajectory of every grid point in positv and negativ direction
!     until the minimum and maximum (or boundary) is found.
!
!     --------------------
!
    subroutine findTraj(eid,verbose)
        use omp_lib
        use mod_dele
        use mod_postp
        use mod_schedl
#if(_NUMBERFIND_==4)
        use pmap
#endif

        ! function vars
        integer,intent(in) :: eid
        integer,intent(in) :: verbose

        double precision :: tcount

        ! OpenMP private variables
        integer, automatic :: i,j,k, b, b_count, b0
        integer, automatic :: traj_found

        integer, automatic :: pt, k0
        logical, automatic :: found
        double precision :: distance

        double precision :: t_start, t_current, t_block, t_togo
        integer, dimension(:), allocatable :: t_blocks
        integer :: t_max_numends

        double precision, dimension(:,:,:), allocatable :: traject_pool

        integer, dimension(:,:), allocatable, target :: traject_minmax
        integer :: traject_id, traject_pktid, traject_len

        !double precision, dimension(:,:), allocatable :: traject
        integer, automatic :: trajMaxMinIds(2), trajDir
        integer, automatic :: breakid(2)

#if (_TRAJCOUNT_==3)
        integer, dimension(:,:,:), allocatable :: trajcount_list
        integer, dimension(:), allocatable :: t_trajcount_count
        integer, automatic :: tlp, t_trajcount_cid, tid
#endif
        integer, automatic :: skiptrajcount_count

        double precision, dimension(:), allocatable :: trajLenPath
        double precision, dimension(:), allocatable :: trajV
        double precision, dimension(:,:), allocatable :: corr_omp
        integer(kind=8), dimension(:,:,:), allocatable :: jcorr_omp
        integer(kind=8), dimension(:,:), allocatable :: mhist_omp
        double precision, dimension(:,:), allocatable :: trajxyz_omp

        double precision, dimension(:,:), allocatable :: corr
        integer(kind=8), dimension(:,:,:), allocatable :: jcorr
        integer(kind=8), dimension(:,:), allocatable :: mhist
        double precision, dimension(:), allocatable :: scalevars
        integer :: corr_size3=0, jcorr_size3=0

        integer, automatic :: jumps

#if(_NUMBERFIND_==3 || _NUMBERFIND_==4)
        integer :: t_numends
        double precision,  dimension(:,:), allocatable :: t_points ! (pointNo,xyz) (grid-coordinates - no coordxyz used!)
        logical          , dimension(:),      allocatable  :: t_signs ! (+:true, -:false) minumum,maximum
        integer, dimension(:), allocatable :: t_idtrans
        double precision :: t_sync
		double precision :: varx,vary,varz
#endif
#if (_NUMBERFIND_==4)
        integer*8 map
        integer*8 t_map
#endif

        ! variables
        integer :: alloc_err=0
        double precision :: trajdist

#if (_NUMBERFIND_==4)
        if(verbose > 0) write(*,*) 'create map ...'
        map = pmnew(traj_err)
#endif

        if(analyTraj .gt. 0) then
            if(verbose > 0) write(*,*)
            if(verbose > 0) write(*,*) 'Allocating memory for trajectory analysis...'

            corr_size3 = 6+(novars)
            jcorr_size3= 1+(novars)

            allocate( corr(0:1000,-1:corr_size3), STAT=alloc_err)
            corr = 0.d0

            allocate( jcorr(0:1000,0:1000,jcorr_size3), STAT=alloc_err)
            jcorr = 0

            allocate( mhist(4,0:1000), STAT=alloc_err)
            mhist = 0
        endif

        jumps        = 0
        force0_count = 0
        skiptrajcount_count = 0
        t_start = omp_get_wtime()

        if(verbose > 0) write(*,*)
        if(verbose > 0) write(*,*) 'Entering parallel section...'
        if(verbose > 0) write(*,*) '    number of blocks to scan:', nblocks_sub

        !$omp parallel                                          &
        !$omp default( shared )                                 &
        !$omp private( i,j,k,b,b_count, b0 )                    &
        !$omp private( alloc_err, breakid )                     &
        !$omp private( trajMaxMinIds, trajDir)                  &
        !$omp private( traject_pool, traject_minmax )           &
        !$omp private( traject_id, traject_pktid )              &
        !$omp private( traject_len)                             &
        !$omp private( trajLenPath, trajV )                     &
        !$omp private( corr_omp, jcorr_omp, mhist_omp, scalevars)&
        !$omp private( t_current, t_block, t_togo, t_blocks, t_max_numends )   &
#if(_NUMBERFIND_==3 || _NUMBERFIND_==4)
        !$omp private( pt, found, t_numends )                   &
        !$omp private( k0, distance )                           &
        !$omp private( t_points, t_signs, t_idtrans )           &
        !$omp private( t_sync )                                 &
        !$omp private( varx,vary,varz )							&
#endif
#if(_NUMBERFIND_==4)
        !$omp private( t_map )                                  &
#endif
#ifndef _CUBIC_CELLS_
        !$omp private( trajxyz_omp )                            &
#endif
#if (_TRAJCOUNT_==3)
        !$omp private( tid, t_trajcount_cid)                    &
        !$omp private( trajcount_list )                         &
        !$omp private( tlp, t_trajcount_count, trajdist )       &
#endif
        !$omp reduction(+:jumps)                                &
        !$omp reduction(+:force0_count)                         &
        !$omp reduction(+:skiptrajcount_count)

        t_max_numends = max_numends/omp_get_num_threads()
        if(verbose > 0) write(*,*) '    thread, thread max numends: ',omp_get_thread_num(),t_max_numends

#if(_NUMBERFIND_==3 || _NUMBERFIND_==4)
        t_numends = 0
        ! allocate, but do not use all memory
        allocate(t_points(3,t_max_numends),STAT=alloc_err);  if(alloc_err.ne.0) write(*,*) ' allocate t_points failed for thread ', omp_get_thread_num()
        allocate(t_signs(t_max_numends),STAT=alloc_err);     if(alloc_err.ne.0) write(*,*) ' allocate t_signs failed for thread ', omp_get_thread_num()
        allocate(t_idtrans(0:t_max_numends),STAT=alloc_err); if(alloc_err.ne.0) write(*,*) ' allocate t_idtrans failed for thread ', omp_get_thread_num()
        !if(verbose > 0) write(*,*) ' allocate finished for thread ', omp_get_thread_num()
        t_idtrans(0) = 0
#endif
#if(_NUMBERFIND_==4)
        !if(verbose > 0) write(*,*) ' nfind4init for thread ', omp_get_thread_num()
        t_map = pmnew(traj_err)
#endif

#if (_TRAJCOUNT_==3)
        if(do_trajcount) then
          allocate(trajcount_list(3,-trajPtsMin:trajPtsMax,trajcount_size3),STAT=alloc_err)
            if(alloc_err.ne.0) write(*,*) ' allocate trajcount_list failed for thread ', omp_get_thread_num()
          allocate(t_trajcount_count(trajcount_size3), STAT=alloc_err)
            if(alloc_err.ne.0) write(*,*) ' allocate t_trajcount_count failed for thread ', omp_get_thread_num()
        else
          allocate(trajcount_list(3,-1:1,1),STAT=alloc_err) ! shut up debugger
            if(alloc_err.ne.0) write(*,*) ' allocate trajcount_list failed for thread ', omp_get_thread_num()
          allocate(t_trajcount_count(1), STAT=alloc_err) ! shut up debugger
            if(alloc_err.ne.0) write(*,*) ' allocate t_trajcount_count failed for thread ', omp_get_thread_num()
        endif
        t_trajcount_cid = 1
#endif
        ! init memory to analyse trajectories
        !if(verbose > 0) write(*,*) ' init traj-stuff for thread ', omp_get_thread_num()
        if(analyTraj .gt. 0) then
            !if(verbose > 0) write(*,*) ' init analyTraj for thread ', omp_get_thread_num()
            allocate( trajLenPath(-trajPtsMin:trajPtsMax), STAT=alloc_err )
              if(alloc_err.ne.0) write(*,*) ' allocate trajLenPath failed for thread ', omp_get_thread_num()

            allocate( trajV(-trajPtsMin:trajPtsMax), STAT=alloc_err )
              if(alloc_err.ne.0) write(*,*) ' allocate trajV failed for thread ', omp_get_thread_num()

            allocate( corr_omp(0:1000,-1:corr_size3), STAT=alloc_err)
              if(alloc_err.ne.0) write(*,*) ' allocate corr_omp failed for thread ', omp_get_thread_num()
            corr_omp = 0.d0

            allocate( jcorr_omp(0:1000,0:1000,jcorr_size3), STAT=alloc_err)
              if(alloc_err.ne.0) write(*,*) ' allocate jcorr_omp failed for thread ', omp_get_thread_num()
            jcorr_omp = 0

            allocate( mhist_omp(4,0:1000), STAT=alloc_err)
              if(alloc_err.ne.0) write(*,*) ' allocate mhist_omp failed for thread ', omp_get_thread_num()
            mhist_omp = 0

            allocate( scalevars(0:novars), STAT=alloc_err)
              if(alloc_err.ne.0) write(*,*) ' allocate scalevars failed for thread ', omp_get_thread_num()
            scalevars = 0.d0

#ifndef _CUBIC_CELLS_
            allocate( trajxyz_omp(-trajPtsMin:trajPtsMax,3), stat=alloc_err)
              if(alloc_err.ne.0) write(*,*) ' allocate trajxyz_omp failed for thread ', omp_get_thread_num()
#endif
        endif

        ! save memory if detailed data of trajectories are of no interest
        if(dumpTraj  .eq. 0 .and. &
           analyTraj .eq. 0 ) then
          dumpTraj_pktsize = 1
        end if

        ! init memory to dump or analyse trajectories
        allocate(traject_pool(-trajPtsMin:trajPtsMax,tattrs,dumpTraj_pktsize),STAT=alloc_err)
              if(alloc_err.ne.0) write(*,*) ' allocate traject_pool failed for thread ', omp_get_thread_num()

        allocate(traject_minmax(2,dumpTraj_pktsize),STAT=alloc_err)
              if(alloc_err.ne.0) write(*,*) ' allocate traject_minmax failed for thread ', omp_get_thread_num()

        traject_id = 1
        traject_pktid = 0
        b_count = 0

        ! allocate memory to save block-ids processed by each thread
        allocate( t_blocks(nblocks_sub), stat=alloc_err )
          if(alloc_err.ne.0) write(*,*) ' allocate t_blocks failed for thread ', omp_get_thread_num()

        !if(verbose > 0) write(*,*) ' start loop in thread ', omp_get_thread_num()
#if(_SCHEDULE_==0)
        !$omp do schedule (static)
        do b=1, nblocks_sub
#elif(_SCHEDULE_==1)
        !$omp do schedule (dynamic,1)
        do b=1, nblocks_sub
#elif(_SCHEDULE_==2)
        call sched_init(1,nblocks_sub,_NUMA_TPN_)
        do while (.true.)
          b = sched_next()
          if (b .gt. nblocks_sub) exit
#endif
          b_count = b_count +1
          t_blocks(b_count) = b
          if( mod(b,100) .eq. 0 ) then
            t_current = omp_get_wtime()
            t_block = (t_current -t_start) / b_count
            t_togo = (nblocks_sub/omp_get_num_threads() *t_block) -(t_current -t_start)
          	if(do_numberfind) then
#if(_NUMBERFIND_!=3 && _NUMBERFIND_!=4)
          		if(verbose > 0) write(*,fmt='(a,i8,i8,i8,i8)') 'thread, blocks, numends, jumps=', 		&
          				omp_get_thread_num(), (nblocks_sub/omp_get_num_threads())-b_count, numends, jumps
#else
          		if(verbose > 0) write(*,fmt='(a,i8,i8,i8,i8)') 'thread, blocks, t_numends, jumps=', 	&
          				omp_get_thread_num(), (nblocks_sub/omp_get_num_threads())-b_count, t_numends, jumps
#endif
          	else
          		if(verbose > 0) write(*,fmt='(a,i8,i8,i8)') 'thread, blocks, jumps=',		&
          				omp_get_thread_num(), (nblocks_sub/omp_get_num_threads())-b_count, jumps
          	endif
          	if(verbose > 0) write(*,fmt='(a,f8.4)') '        finish in [h]=', t_togo/3600.d0
          endif

        !if(verbose > 0) write(*,*) omp_get_thread_num(), b

        do k=bstart_sub(b,3),bend_sub(b,3)
          if(k == 1 .or. k == ndims(3)) cycle

          !if(verbose > 0) write(*,*) omp_get_thread_num(), k

          do j=bstart_sub(b,2),bend_sub(b,2)
            if(j == 1 .or. j == ndims(2)) cycle

            do i=bstart_sub(b,1),bend_sub(b,1)
              if(i == 1 .or. i == ndims(1)) cycle

              !if(verbose > 0) write(*,*) omp_get_thread_num(), b,i,j,k

                    ! only scan special grid-points
                    if( eid .gt. 0 )  then
                        if( allocated(note) ) then
                            if( eid .ne. note(i,j,k) ) cycle
                        endif
                    endif

                    trajMaxMinIds = 0        ! found points eq. 0

                    !! increase no. trajectories per grid-cell
                    !!!!!!!!!!
                    if(do_trajcount) then
#if (_TRAJCOUNT_==1)
                      !$omp critical
                    	trajcount(i,j,k) = trajcount(i,j,k) +1
                      !$omp end critical
#elif (_TRAJCOUNT_==3)
                      t_trajcount_count(t_trajcount_cid) = -trajPtsMin
                      trajcount_list(1,t_trajcount_count(t_trajcount_cid),t_trajcount_cid) = i
                      trajcount_list(2,t_trajcount_count(t_trajcount_cid),t_trajcount_cid) = j
                      trajcount_list(3,t_trajcount_count(t_trajcount_cid),t_trajcount_cid) = k
#endif
                    endif

                    !! Trajectory - Calculation in positiv direction
                    !!!!!!!!!!
                    trajDir = 1
                    call walkTraj(i,j,k, trajDir, traject_pool, traject_id, jumps, trajMaxMinIds(1), breakid(1)	&
#if (_TRAJCOUNT_==3)
                         ,t_trajcount_count, t_trajcount_cid                       &
                         ,trajcount_list                                           &
#endif
#if (_NUMBERFIND_==3 || _NUMBERFIND_==4)
                         ,t_numends, t_points, t_signs                             &
#endif
#if (_NUMBERFIND_==4)
                         ,t_map                                                    &
#endif
                         )

                    !! Trajectory - Calculation in negative direction
                    !!!!!!!!!!
                    trajDir = 2
                    call walkTraj(i,j,k, trajDir, traject_pool, traject_id, jumps, trajMaxMinIds(2), breakid(2)	&
#if (_TRAJCOUNT_==3)
                         ,t_trajcount_count, t_trajcount_cid                       &
                         ,trajcount_list                                           &
#endif
#if (_NUMBERFIND_==3 || _NUMBERFIND_==4)
                         ,t_numends, t_points, t_signs                             &
#endif
#if (_NUMBERFIND_==4)
                         ,t_map                                                    &
#endif
                         )

                    !if(k == 384 .and. j == 3 .and. i == 22) then
                     !  write(*,*) 'i,j,k: ', i,j,k
#if (_NUMBERFIND_==3 || _NUMBERFIND_==4)
                       !write(*,*) 'max:     ', t_points(:,numbering(i,j,k,1))
                       !write(*,*) 'trajmax: ', traject_pool(trajMaxMinIds(1),1:3,traject_id)
                       !write(*,*) 'min:     ', t_points(:,numbering(i,j,k,2))
                       !write(*,*) 'trajmin: ', traject_pool(trajMaxMinIds(2),1:3,traject_id)
#endif
                      ! stop
                    !end if

#if (_TRAJCOUNT_==3)
                    if(do_trajcount) then
                      if( (breakid(1) .ne. 2 .and. breakid(2) .ne. 2) .and.	&		! do not count forced endings
                          (trajMaxMinIds(1) -trajMaxMinIds(2) .ge. 3) ) then			! skip too short trajectories
                        	if(t_trajcount_cid .eq. trajcount_size3) then
                        		!$omp critical
                        		do tid=1, t_trajcount_cid
                        		  do tlp=-trajPtsMin, t_trajcount_count(tid)
                        			trajcount( trajcount_list(1,tlp,tid), trajcount_list(2,tlp,tid), trajcount_list(3,tlp,tid)) = &
                        			trajcount( trajcount_list(1,tlp,tid), trajcount_list(2,tlp,tid), trajcount_list(3,tlp,tid)) +1
                        		  enddo
                        		enddo
                        		t_trajcount_cid = 1
                        		!$omp end critical
                        	else
                        		t_trajcount_cid = t_trajcount_cid +1
                        	endif
                      else
                    	skiptrajcount_count = skiptrajcount_count +1
                      endif
                    endif
#endif

                    ! store trajectory of dissipation elements if min and max was found
                    ! (only store trajectories with min-max-points; skip trajectories with forced ending or boundary-hits)
                    if( (saveTraj .eq. 1) .and.								&
                        (breakid(1) .eq. 0 .and. breakid(2) .eq. 0) )		&	! do not count forced or boundary endings
                    	call storeDEleTraj( i,j,k, traject_pool(:,:,traject_id), trajMaxMinIds, traj_err )

                    ! analyse found trajectory
                    ! (do not analyse trajectories with forced ending (force0))
                    if( (analyTraj .gt. 0) .and.							&
                        (breakid(1) .ne. 2 .and. breakid(2) .ne. 2) .and.	&	 ! do not count forced endings
                        (trajMaxMinIds(1) -trajMaxMinIds(2) .ge. 3) )		then ! skip too short trajectories
!                    	call analyTrajCond( i,j,k, traject_pool, traject_id, trajMaxMinIds, trajLenPath, trajV,	&
!                    						corr_size3, jcorr_size3, corr_omp, jcorr_omp, mhist_omp, scalevars	&
!#ifndef _CUBIC_CELLS_
!                                           ,trajxyz_omp	&
!#endif
!                        )

                        call analyTrajEndCond( i,j,k, traject_pool, traject_id, trajMaxMinIds, mhist_omp, jcorr_size3, jcorr_omp )

                    end if

                    !! dump trajectories to disk
                    if(dumpTraj .eq. 1) then

                      traject_minmax(1,traject_id) = trajMaxMinIds(2) ! no. points in minimum direction
                      traject_minmax(2,traject_id) = trajMaxMinIds(1) ! no. points in maximum direction
                      if(traject_id .eq. dumpTraj_pktsize) then
                        call write_trajects_omp(traject_pool, traject_minmax,	&
                                                 -trajPtsMin,trajPtsMax,		&
                                                 1,tattrs,						&
                                                 1,dumpTraj_pktsize,			&
                                                 1,dumpTraj_pktsize, traject_pktid)
                        traject_id = 1
                        traject_pktid = traject_pktid +1
                      else
                        traject_len = -traject_minmax(1,traject_id) +traject_minmax(2,traject_id) +1
                        if(traject_len .ge. dumpTraj_minlen) then ! skip short trajectories
                          traject_id = traject_id +1
                        endif

                      endif
                    endif

                enddo            ! ndimz
            enddo                ! ndimy

            ! save intermediate result
            !if(analyTraj .gt. 0)		&
            !	call saveTrajCond( corr_size3, jcorr_size3, corr, jcorr, mhist, corr_omp, jcorr_omp, mhist_omp, scalevars )

        enddo                    ! ndimx

        enddo
#if (_SCHEDULE_==2)
        call sched_fini()
#else
        !$omp end do
#endif

#if (_TRAJCOUNT_==3)
        if(do_trajcount) then
        	!$omp critical
        	do tid=1, t_trajcount_cid -1
        	  do tlp=-trajPtsMin, t_trajcount_count(tid)
        		trajcount( trajcount_list(1,tlp,tid), trajcount_list(2,tlp,tid), trajcount_list(3,tlp,tid)) = &
        		trajcount( trajcount_list(1,tlp,tid), trajcount_list(2,tlp,tid), trajcount_list(3,tlp,tid)) +1
        	  enddo
        	enddo
        	t_trajcount_cid = 0
        	!$omp end critical
        endif
        if(allocated(trajcount_list)) deallocate(trajcount_list)
#endif

        !! dump trajectories to disk
        if(dumpTraj .eq. 1) then
          call write_trajects_omp(traject_pool, traject_minmax,	&
                                 -trajPtsMin,trajPtsMax,		&
                                  1,tattrs,						&
                                  1,traject_id,					&
                                  1,traject_id, traject_pktid)
          traject_pktid = traject_pktid +1
        endif

        if(saveTraj .eq. 1 .or. analyTraj .gt. 0) then

          if(analyTraj .gt. 0) then
            !call saveTrajCond( corr_size3, jcorr_size3, corr, jcorr, mhist, corr_omp, jcorr_omp, mhist_omp, scalevars )
            call saveTrajEndCond( jcorr_size3, jcorr, mhist, jcorr_omp, mhist_omp )

            if(allocated(trajLenPath))  deallocate( trajLenPath )
            if(allocated(trajV))        deallocate( trajV )
            if(allocated(corr_omp))     deallocate( corr_omp )
            if(allocated(mhist_omp))    deallocate( mhist_omp )
          endif

          if(allocated(traject_pool))       deallocate(traject_pool)

        endif

        !!
        !! sync thread-private-data to global-data
        !!     points(),signs() and numends
        !!
#if(_NUMBERFIND_==3)
        !$omp critical
        t_sync = omp_get_wtime()
        t_idtrans(0) = 0 ! if no extrema found -> numbering(i,j,k,12) = 0
        found = .false.
        do pt=1, t_numends
          do k0=1,numends
        	found = .false.
#ifndef _CUBIC_CELLS_

        	! only check if point is near extrema related to grid-coordiantes
        	varx= abs(t_points(1,pt)-points(k0,1))
        	vary= abs(t_points(2,pt)-points(k0,2))
        	varz= abs(t_points(3,pt)-points(k0,3))

         	if( varx .lt. traj_err .and.  &
                vary .lt. traj_err .and.  &
                varz .lt. traj_err) then
#else
        	distance = dsqrt(    (t_points(1,pt) -points(k0,1))**2     &
                                +(t_points(2,pt) -points(k0,2))**2     &
                                +(t_points(3,pt) -points(k0,3))**2 )
        	if(distance .lt. traj_err) then
#endif
        		found = .true.
        		t_idtrans(pt) = k0
        		exit
        	endif
          enddo

          if(.not. found) then
            numends=numends+1
            t_idtrans(pt) = numends

            points(numends,1)=t_points(1,pt)
            points(numends,2)=t_points(2,pt)
            points(numends,3)=t_points(3,pt)
            signs(numends)=t_signs(pt)
          endif

        enddo
        !$omp end critical

        ! translate numbering-blocks by responsible thread and its translation-table "t_idtrans"
        if( do_numberfind ) then
        do b=1, b_count
          b0 = t_blocks(b)
          do k=bstart_sub(b0,3),bend_sub(b0,3)
        	do j=bstart_sub(b0,2),bend_sub(b0,2)
        	  do i=bstart_sub(b0,1),bend_sub(b0,1)
        		numbering(i,j,k,1) = t_idtrans( numbering(i,j,k,1) )
        		numbering(i,j,k,2) = t_idtrans( numbering(i,j,k,2) )
        	  enddo
        	enddo
          enddo
        enddo
        endif


        t_sync = omp_get_wtime() -t_sync
        if(verbose > 0) write(*,*) '    ... syncing thread in [s]',omp_get_thread_num(), t_sync, t_numends

        if(allocated(t_points) ) deallocate(t_points)
        if(allocated(t_signs) ) deallocate(t_signs)
        if(allocated(t_idtrans) ) deallocate(t_idtrans)

#elif(_NUMBERFIND_==4)
        !$omp critical

#ifndef _CUBIC_CELLS_
        write(*,*) 'ERROR: _NUMBERFIND_==4 does _ONLY_ support _CUBIC_CELLS_'
        stop
#endif

        t_sync = omp_get_wtime()
        t_idtrans(0) = 0 ! if no extrema found -> numbering(i,j,k,12) = 0
        do pt=1, t_numends
        	k0 = pmget(map, t_points(1,pt), t_points(2,pt), t_points(3,pt))
        	if (k0 .gt. 0) then
        		found = .true.
        		t_idtrans(pt) = k0
        	else
        		found = .false.
        	endif

        	if(.not. found) then
        	  numends=numends+1
        	  t_idtrans(pt) = numends

        	call pminsert(map, t_points(1,pt), t_points(2,pt), t_points(3,pt), numends)

            points(numends,1)=t_points(1,pt)
            points(numends,2)=t_points(2,pt)
            points(numends,3)=t_points(3,pt)
            signs(numends)=t_signs(pt)
          endif

        enddo
        !$omp end critical

        ! translate numbering-blocks by responsible thread and its translation-table "t_idtrans"
        if( do_numberfind ) then
        do b=1, b_count
          b0 = t_blocks(b)
          do k=bstart_sub(b0,3),bend_sub(b0,3)
        	do j=bstart_sub(b0,2),bend_sub(b0,2)
        	  do i=bstart_sub(b0,1),bend_sub(b0,1)
        		numbering(i,j,k,1) = t_idtrans( numbering(i,j,k,1) )
        		numbering(i,j,k,2) = t_idtrans( numbering(i,j,k,2) )
        	  enddo
        	enddo
          enddo
        enddo
        endif

        t_sync = omp_get_wtime() -t_sync
        if(verbose > 0) write(*,*) '    ... syncing thread in [s]',omp_get_thread_num(), t_sync

        if(allocated(t_points) ) deallocate(t_points)
        if(allocated(t_signs) ) deallocate(t_signs)
        if(allocated(t_idtrans) ) deallocate(t_idtrans)
        if(allocated(t_blocks) ) deallocate(t_blocks)

        call pmdelete(t_map)
#endif

        !$omp end parallel

#if(_NUMBERFIND_==4)
        call pmdelete(map)
#endif

        if(verbose .gt. 0) then
        	tcount = dble(subdomain(1,2)-subdomain(1,1)+1) *dble(subdomain(2,2)-subdomain(2,1)+1) *dble(subdomain(3,2)-subdomain(3,1)+1)
        	write(*,*)
        	write(*,*) 'Finished parallel section in [s]', (omp_get_wtime() -t_start)
        	write(*,*) '   numends            = ',numends
        	write(*,*) '   jumps  [abs,%] = ', jumps, (jumps/tcount)*100.d0
        	write(*,*) '   force0 [abs,%] = ', force0_count, (force0_count/tcount)*100.d0
        	if(do_trajcount) &
        		write(*,*) '   skip trajcount [abs,%] = ', skiptrajcount_count, (skiptrajcount_count/tcount)*100.d0
        endif

        return
    end subroutine findTraj

!
!     --------------------
!
!     subroutine walkTraj()
!
!     Walks along the trajectory of every grid point in positv or negativ direction
!     until the minimum and maximum (or boundary) is found.
!
!     --------------------
!
    subroutine walkTraj(i,j,k, trajDir, traject_pool, traject_id, jumps, trajPtIds, breakid       &
#if (_TRAJCOUNT_==3)
                         ,t_trajcount_count, t_trajcount_cid                       &
                         ,trajcount_list                                           &
#endif
#if (_NUMBERFIND_==3 || _NUMBERFIND_==4)
                         ,t_numends, t_points, t_signs                             &
#endif
#if (_NUMBERFIND_==4)
                         ,t_map                                                    &
#endif
                         )
        use omp_lib
        implicit none

        ! function arguments
        integer, intent(in)   :: i,j,k
        integer, intent(in)   :: trajDir

        double precision, dimension(-trajPtsMin:trajPtsMax,tattrs,dumpTraj_pktsize), intent(inout) :: traject_pool
        integer, intent(in) :: traject_id
        
        integer, intent(inout)            :: jumps

        integer, intent(out)  :: trajPtIds
        integer, intent(out)  :: breakid

        double precision :: divsum
        integer :: divcount

#if (_TRAJCOUNT_==3)
        integer, intent(inout)            :: t_trajcount_cid
        integer, dimension(trajcount_size3), intent(inout) :: t_trajcount_count
        integer, dimension(3,-trajPtsMin:trajPtsMax,trajcount_size3), intent(inout) :: trajcount_list
#endif
#if (_NUMBERFIND_==3 || _NUMBERFIND_==4)
        integer, intent(inout)      :: t_numends
        double precision,  dimension(:,:), intent(inout), allocatable :: t_points
        logical          , dimension(:), intent(inout),    allocatable  :: t_signs
#endif
#if (_NUMBERFIND_==4)
        integer*8, intent(inout) :: t_map
#endif

    ! thread vars
    integer, automatic :: ii,jj,kk
    integer, automatic :: ni,nj,nk
    integer, automatic :: px,py,pz

    double precision, automatic :: posx,posy,posz
    double precision, automatic :: endx,endy,endz

    double precision, automatic :: switch
    integer, automatic :: force0, endfind
    integer, automatic :: trajStep

    double precision, automatic  :: vecn(3), vecl
    double precision, automatic :: mpsi

#ifndef _CUBIC_CELLS_
    double precision  :: dxp,dxm, dyp,dym, dzp,dzm
#endif

        breakid = 0

                        if(trajDir .eq. 1) then    ! positiv direction
                            switch  =1.d0
                            trajStep=1
                        else                     ! negativ direction
                            switch  =-1.d0
                            trajStep=-1
                        endif


                        endfind=0

                        ni=i
                        nj=j
                        nk=k

                        trajPtIds=0

                        endx = 0.d0
                        endy = 0.d0
                        endz = 0.d0

                        ! walk along the trajectory until a max/min is found
                        do while(endfind .eq. 0)

                            ! have we reached the boundary ?? exit loop if so
                            if(     (ni.eq.1).or.(ni.eq.ndims(1))            &
                                .or.(nj.eq.1).or.(nj.eq.ndims(2))            &
                                .or.(nk.eq.1).or.(nk.eq.ndims(3))) then
                                    breakid = 1
                                    return
                            endif

#ifndef _CUBIC_CELLS_
                            dxp= coordx(ni+1)-coordx(ni)
                            dxm= coordx(ni)  -coordx(ni-1)
                            dyp= coordy(nj+1)-coordy(nj)
                            dym= coordy(nj)  -coordy(nj-1)
                            dzp= coordz(nk+1)-coordz(nk)
                            dzm= coordz(nk)  -coordz(nk-1)
#endif
                            px = 0
                            py = 0
                            pz = 0
                            mpsi = psi(ni,nj,nk)
                            if(trajDir == 1 ) then ! positiv direction

                              do ii=-1,+1
                                do jj=-1,+1
                                  do kk=-1,+1
                                    if( mpsi < psi(ni+ii, nj+jj, nk+kk) ) then
                                      px=ii; py=jj; pz=kk
                                      mpsi = psi(ni+px, nj+py, nk+pz)
                                    end if
                                  end do
                                end do
                              end do
!                                if( mpsi < psi(ni +1, nj,    nk) ) then
!                                               px=+1; py=0;  pz=0
!                                  mpsi =   psi(ni +1, nj,    nk)
!                                end if
!                                ! -1,0,0
!                                if( mpsi < psi(ni -1, nj,    nk) ) then
!                                               px=-1; py=0; pz=0
!                                  mpsi =   psi(ni -1, nj,    nk)
!                                end if
!                                ! 0,+1,0
!                                if( mpsi < psi(ni,   nj +1, nk) ) then
!                                               px=0; py=+1; pz=0
!                                  mpsi =   psi(ni,   nj +1, nk)
!                                end if
!                                ! 0,-1,0
!                                if( mpsi < psi(ni,   nj -1, nk) ) then
!                                               px=0; py=-1; pz=0
!                                  mpsi =   psi(ni,   nj -1, nk)
!                                end if
!                                ! 0,0,+1
!                                if( mpsi < psi(ni,   nj,    nk +1) ) then
!                                               px=0; py=0;  pz=+1
!                                  mpsi =   psi(ni,   nj,    nk +1)
!                                end if
!                                ! 0,0,-1
!                                if( mpsi < psi(ni,   nj,    nk -1) ) then
!                                               px=0; py=0;  pz=-1
!                                  mpsi =   psi(ni,   nj,    nk -1)
!                                end if
                            else ! negativ direction

                              do ii=-1,+1
                                do jj=-1,+1
                                  do kk=-1,+1
                                    if( mpsi > psi(ni+ii, nj+jj, nk+kk) ) then
                                      px=ii; py=jj; pz=kk
                                      mpsi = psi(ni+px, nj+py, nk+pz)
                                    end if
                                  end do
                                end do
                              end do

!                                ! +1,0,0
!                                if( mpsi > psi(ni +1, nj,   nk) ) then
!                                               px=+1; py=0; pz=0
!                                  mpsi =   psi(ni +1, nj,   nk)
!                                end if
!                                ! -1,0,0
!                                if( mpsi > psi(ni -1, nj,   nk) ) then
!                                               px=-1; py=0; pz=0
!                                  mpsi =   psi(ni -1, nj,   nk)
!                                end if
!                                ! 0,+1,0
!                                if( mpsi > psi(ni,   nj  +1, nk) ) then
!                                               px=0; py= +1; pz=0
!                                  mpsi =   psi(ni,   nj  +1, nk)
!                                end if
!                                ! 0,-1,0
!                                if( mpsi > psi(ni,   nj  -1, nk) ) then
!                                               px=0; py= -1; pz=0
!                                  mpsi =   psi(ni,   nj  -1, nk)
!                                end if
!                                ! 0,0,+1
!                                if( mpsi > psi(ni,   nj,    nk +1) ) then
!                                               px=0; py=0;  pz=+1
!                                  mpsi =   psi(ni,   nj,    nk +1)
!                                end if
!                                ! 0,0,-1
!                                if( mpsi > psi(ni,   nj,    nk -1) ) then
!                                               px=0; py=0;  pz=-1
!                                  mpsi =   psi(ni,   nj,    nk -1)
!                                end if
                             end if
                             ni = ni+px
                             nj = nj+py
                             nk = nk+pz
#if (_NUMBERFIND_>0)
                             if(px == 0 .and. py==0 .and. pz==0 .and. do_numberfind) then
                                    endfind = 1
                                    ! Nummer des Endpunktes finden und speichern in numbering,points
                                    call numberfind(trajDir, i,j,k,                         &
                                                    numends, signs, points, numbering,      &
                                                    dble(ni), dble(nj), dble(nk)            &
#if (_NUMBERFIND_==3 || _NUMBERFIND_==4)
                                                   ,t_numends, t_points, t_signs            &
#endif
#if (_NUMBERFIND_==4)
                                                   ,t_map                                   &
#endif
                                                    )
                            endif
#endif

                        enddo    ! endfind.eq.0

        return
    end subroutine walkTraj

!
!     --------------------------------------------------------
!
!     subroutine numberfind(idmm,i,j,k,numends,signs,tx,ty,tz)
!
!     Stores information of minimum/maximum after trajectory-endpoint was found
!     in 'numends', 'signs', 'points'
!
!     --------------------------------------------------------
!
      subroutine numberfind(idmm,i,j,k,numends,signs, points, numbering, tx,ty,tz	&
#if (_NUMBERFIND_==3 || _NUMBERFIND_==4)
                         ,t_numends, t_points, t_signs                              &
#endif
#if (_NUMBERFIND_==4)
                         ,t_map                                                     &
#endif
      )
        use omp_lib
#if (_NUMBERFIND_==4)
        use pmap
#endif
        implicit none

        ! function arguments
        integer,                                                intent(in)       :: idmm,i,j,k
        integer,                                                intent(inout)    :: numends
        logical,           dimension(:),      allocatable,   intent(inout)    :: signs
        double precision, dimension(:,:),    allocatable,   intent(inout)    :: points
        integer,           dimension(:,:,:,:),allocatable,   intent(inout)    :: numbering
        double precision,                                      intent(in)       :: tx,ty,tz

        ! variables
#ifndef _CUBIC_CELLS_
		integer, automatic :: idp
		double precision, automatic :: varx,vary,varz,factor
#endif

#if (_NUMBERFIND_==1)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        double precision, automatic :: distance
        integer, automatic  :: k0
        logical, automatic :: found

        ! meaning of numbering(,,,2) is: 1.id of max point 2.id of min point

        numbering(i,j,k,idmm)=0

        !$omp critical
        found = .false.
        do k0=1,numends
#ifndef _CUBIC_CELLS_

        	! only check if point is near extrema related to grid-coordiantes
        	varx= abs(tx-points(k0,1))
        	vary= abs(ty-points(k0,2))
        	varz= abs(tz-points(k0,3))

         	if( varx.lt.traj_err .and.  &
                vary.lt.traj_err .and.  &
                varz.lt.traj_err) then
#else
        	distance = dsqrt(    (tx-points(k0,1))**2     &
                                +(ty-points(k0,2))**2     &
                                +(tz-points(k0,3))**2 )
        	if(distance .lt. traj_err) then
#endif
        		numbering(i,j,k,idmm)=k0
        		found = .true.
        		exit
        	endif
        enddo

        if(.not. found) then

        	if(numends .eq. max_numends) then
        		write(*,*) 'ERROR: cannot store more than ',max_numends
        		stop
        	endif
        	numends=numends+1

        	numbering(i,j,k,idmm)=numends
        	points(numends,1)=tx
        	points(numends,2)=ty
        	points(numends,3)=tz
        	if(idmm.eq.1) then; signs(numends)=.true.
        	else;               signs(numends)=.false.; endif
        endif

        !$omp end critical

#elif(_NUMBERFIND_==2)
          double precision, automatic :: corx,cory,corz, tep(4)
          integer, automatic :: i0,j0,k0, i1,j1,k1, itp
          integer, automatic :: idx,idy,idz, idx1,idx2, idy1,idy2, idz1,idz2
          double precision, automatic :: distance
          logical, automatic :: found

          numbering(i,j,k,idmm) = 0

          idx=tx
          idy=ty
          idz=tz

      !	search for extrem-points in neighbourhood
          idx1=max(0,idx-1)
          idx2=min(ndims(1),idx+1)
          idy1=max(0,idy-1)
          idy2=min(ndims(2),idy+1)
          idz1=max(0,idz-1)
          idz2=min(ndims(3),idz+1)

          !$omp critical
          found = .false.
          do i0=idx1,idx2
            do j0=idy1,idy2
              do k0=idz1,idz2
                if(counter(i0,j0,k0,4) .ge. 1) then

                  ! calc coordinate of extremal point in grid-cell i0,j0,k0
                  corx = counter(i0,j0,k0,1)/counter(i0,j0,k0,4)
                  cory = counter(i0,j0,k0,2)/counter(i0,j0,k0,4)
                  corz = counter(i0,j0,k0,3)/counter(i0,j0,k0,4)

                  ! check if traj-endpoint is near extremal point of this grid-cell i0,j0,k0
#ifndef _CUBIC_CELLS_
                  varx=abs(tx-points(identity(i0,j0,k0),1))
                  vary=abs(ty-points(identity(i0,j0,k0),2))
                  varz=abs(tz-points(identity(i0,j0,k0),3))
!                  varx=abs(tx-points(k0,1))
!                  vary=abs(ty-points(k0,2))
!                  varz=abs(tz-points(k0,3))
                  if(	(varx-corx) .lt. traj_err .and.	&
                     	(vary-cory) .lt. traj_err .and.	&
                     	(varz-corz) .lt. traj_err) then
#else
                  distance = dsqrt((tx-corx)**2+(ty-cory)**2+(tz-corz)**2)
                  if(distance .lt. traj_err) then
#endif
                  ! add traj-endpoint to extremal point of this grid-cell i0,j0,k0

                    numbering(i,j,k,idmm) = identity(i0,j0,k0)  ! get extr.point minmax-id at i0,j0,k0

                    ! add traj-endpoint-coordinates and therefor move grid-cell extremal point (because it influences the mean xyz)
                    counter(i0,j0,k0,1) = counter(i0,j0,k0,1)+tx
                    counter(i0,j0,k0,2) = counter(i0,j0,k0,2)+ty
                    counter(i0,j0,k0,3) = counter(i0,j0,k0,3)+tz
                    counter(i0,j0,k0,4) = counter(i0,j0,k0,4)+1.d0

                    ! change grid-cell-extremal-position to new one
                    points(identity(i0,j0,k0),1) = counter(i0,j0,k0,1)/counter(i0,j0,k0,4)
                    points(identity(i0,j0,k0),2) = counter(i0,j0,k0,2)/counter(i0,j0,k0,4)
                    points(identity(i0,j0,k0),3) = counter(i0,j0,k0,3)/counter(i0,j0,k0,4)

                    ! if grid-cell extremal points new position moved to neighbour cell, change i0,j0,k0 to i1,j1,k1
                    !!!!!!!!

                    ! get new extremal point position as integer (to which grid-cell belongs the extramal point?)
                    i1 = points(identity(i0,j0,k0),1)
                    j1 = points(identity(i0,j0,k0),2)
                    k1 = points(identity(i0,j0,k0),3)

                    ! backup counter-data and identity-data of i0,j0,k0
                    tep(1) = counter(i0,j0,k0,1)
                    tep(2) = counter(i0,j0,k0,2)
                    tep(3) = counter(i0,j0,k0,3)
                    tep(4) = counter(i0,j0,k0,4)

                    itp=identity(i0,j0,k0)

                    ! clean extremal point of i0,j0,k0
                    counter(i0,j0,k0,1)  = 0.d0
                    counter(i0,j0,k0,2)  = 0.d0
                    counter(i0,j0,k0,3)  = 0.d0
                    counter(i0,j0,k0,4)  = 0.d0
                    identity(i0,j0,k0) = 0

                    ! add extremal point to grid-cell i1,j1,k1
                    counter(i1,j1,k1,1)  = counter(i1,j1,k1,1)+tep(1)
                    counter(i1,j1,k1,2)  = counter(i1,j1,k1,2)+tep(2)
                    counter(i1,j1,k1,3)  = counter(i1,j1,k1,3)+tep(3)
                    counter(i1,j1,k1,4)  = counter(i1,j1,k1,4)+tep(4)
                    identity(i1,j1,k1) = itp

                    ! exit loop and return if extremal point was found
                    found = .true.
                    exit

                  endif

                endif
              enddo
              if(found) exit
            enddo
            if(found) exit
          enddo

      !	no extrem-point found
          if(.not. found) then

            ! extrem-point not in near distance found, but in cell idx,idy,idz there is already an extrem-point set - join them
            if( counter(idx,idy,idz,4) .ge. 1.d0 ) then

              numbering(i,j,k,idmm)  = identity(idx,idy,idz)
              counter(idx,idy,idz,1) = counter(idx,idy,idz,1)+tx
              counter(idx,idy,idz,2) = counter(idx,idy,idz,2)+ty
              counter(idx,idy,idz,3) = counter(idx,idy,idz,3)+tz
              counter(idx,idy,idz,4) = counter(idx,idy,idz,4)+1

              points(identity(idx,idy,idz),1) = counter(idx,idy,idz,1)/counter(idx,idy,idz,4)
              points(identity(idx,idy,idz),2) = counter(idx,idy,idz,2)/counter(idx,idy,idz,4)
              points(identity(idx,idy,idz),3) = counter(idx,idy,idz,3)/counter(idx,idy,idz,4)

            ! create new extrem point entry
            else

              if(numends .eq. max_numends) then
             	write(*,*) 'ERROR: cannot store more than ',max_numends
             	stop
              endif
              numends=numends+1
              numbering(i,j,k,idmm) = numends

              counter(idx,idy,idz,1)  = counter(idx,idy,idz,1)+tx
              counter(idx,idy,idz,2)  = counter(idx,idy,idz,2)+ty
              counter(idx,idy,idz,3)  = counter(idx,idy,idz,3)+tz
              counter(idx,idy,idz,4)  = counter(idx,idy,idz,4)+1
              identity(idx,idy,idz) = numends	! extr.point id

              points(numends,1) = counter(idx,idy,idz,1)/counter(idx,idy,idz,4)
              points(numends,2) = counter(idx,idy,idz,2)/counter(idx,idy,idz,4)
              points(numends,3) = counter(idx,idy,idz,3)/counter(idx,idy,idz,4)
              if(idmm.eq.1) then; signs(numends)=.true.
              else;               signs(numends)=.false.; endif
            endif

          endif

          !$omp end critical

#elif(_NUMBERFIND_==3)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        integer, intent(inout)      :: t_numends
        double precision,  dimension(:,:), intent(inout), allocatable :: t_points
        logical          , dimension(:), intent(inout),    allocatable  :: t_signs

        double precision, automatic :: distance
        integer, automatic  :: k0

        ! meaning of numbering(,,,2) is: 1.id of max point 2.id of min point

        !numbering(i,j,k,idmm)=0

        do k0=1,t_numends
#ifndef _CUBIC_CELLS_

        	! only check if point is near extrema related to grid-coordiantes
        	varx= abs(tx-t_points(1,k0))
        	vary= abs(ty-t_points(2,k0))
        	varz= abs(tz-t_points(3,k0))

         	if( varx .lt. traj_err .and.  &
                vary .lt. traj_err .and.  &
                varz .lt. traj_err) then
#else
        	distance = dsqrt(    (tx-t_points(1,k0))**2     &
                                +(ty-t_points(2,k0))**2     &
                                +(tz-t_points(3,k0))**2 )
        	if(distance .lt. traj_err) then
#endif
        		numbering(i,j,k,idmm) = k0
        		return
        	endif
          enddo

        if(t_numends .eq. max_numends) then
        	write(*,*) 'ERROR: cannot store more than ',max_numends,' in thread.'
        	stop
        endif
        t_numends=t_numends+1

        numbering(i,j,k,idmm)=t_numends
        t_points(1,t_numends)=tx
        t_points(2,t_numends)=ty
        t_points(3,t_numends)=tz
        if(idmm .eq. 1) then; t_signs(t_numends)=.true.
        else;                  t_signs(t_numends)=.false.; endif

#elif(_NUMBERFIND_==4)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        integer, intent(inout)      :: t_numends
        double precision,  dimension(:,:), intent(inout), allocatable :: t_points
        logical          , dimension(:), intent(inout),    allocatable  :: t_signs
        integer*8, intent(inout) :: t_map

        double precision, automatic :: distance
        integer, automatic  :: k0

        ! meaning of numbering(,,,2) is: 1.id of max point 2.id of min point

#ifndef _CUBIC_CELLS_
        write(*,*) 'ERROR: _NUMBERFIND_==4 does only support _CUBIC_CELLS_'
        stop
#endif

        k0 = pmget(t_map, tx, ty, tz)
        if (k0 .gt. 0) then
        	numbering(i,j,k,idmm) = k0
        	return
        endif

        if(t_numends .eq. max_numends) then
        	write(*,*) 'ERROR: cannot store more than ',max_numends,' in thread.'
        	stop
        endif
        t_numends=t_numends+1

        call pminsert(t_map, tx, ty, tz, t_numends)

        numbering(i,j,k,idmm)=t_numends
        t_points(1,t_numends)=tx
        t_points(2,t_numends)=ty
        t_points(3,t_numends)=tz
        if(idmm .eq. 1) then; t_signs(t_numends)=.true.
        else;                  t_signs(t_numends)=.false.; endif

#else
        write(*,*) 'ERROR: _NUMBERFIND_ setting unknown or unset'
        stop
#endif

      return

    end subroutine numberfind

!
!     --------------------------------------------------------
!
!     subroutine thread_random(rnd, seed)
!
!     returns random value (without sync to other threads, like intrensic does)
!
!     --------------------------------------------------------
!
      subroutine thread_random(rnd)
          use omp_lib
          implicit none
          real(kind=8), intent(out) :: rnd

          logical, save :: init = .true.
          integer(kind=8), save :: seed
          !$OMP THREADPRIVATE( init, seed)

          ! Setup of parameters see http://de.wikipedia.org/wiki/Spektraltest
          integer(kind=8), parameter :: m = 10**10
          integer(kind=8), parameter :: c = 1
          integer(kind=8), parameter :: a = 3141592621

          if(init) then
          	init = .false.
          	seed = omp_get_thread_num() *13
          endif

          seed = kmod(seed *a +c, m)
          if(seed .lt. 0) seed = kmod(m +seed, m)

          rnd = dble(seed) /m

          return
      end subroutine thread_random

end module mod_traj
