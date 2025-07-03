!
! Copyright (C) 2005-2010 by  Institute of Combustion Technology - RWTH Aachen University
! Jens Henrik Goebbert, goebbert@itv.rwth-aachen.de (2007-2010)
! All rights reserved.
!

module mod_dele
      use mod_data
      implicit none
      save

!     settings from settings file
        integer :: dEleSets_noPtsPerTraj
        integer :: dEleSets_maxNoDETraj
    contains

!
!     --------------------
!
!     subroutine init_trajSave
!
!     --------------------
!
    subroutine initOneDEle(maxtrajs, minptr, maxptr, notraj)
        integer, intent(in) :: maxtrajs
        double precision, intent(in) :: minptr(3), maxptr(3)
        integer, intent(in) :: notraj

        integer :: dE, alloc_err
        integer :: maxtrajs_corrected

        saveTraj       = 1

        dEleSets_noPtsPerTraj   = 5000
        dEleSets_maxNoDETraj    = notraj+2
        maxtrajs_corrected      = maxtrajs+2

        ! dEleMinMax-array (subdomain of this delement)
        if(.not. allocated(dEleMinMax) )then
            allocate(dEleMinMax(2,3),STAT=alloc_err); if( (alloc_err.NE.0) ) goto 95
        endif
        dEleMinMax      = 0
        dEleMinMax(1,1) = minptr(1)
        dEleMinMax(1,2) = minptr(2)
        dEleMinMax(1,3) = minptr(3)
        dEleMinMax(2,1) = maxptr(1)
        dEleMinMax(2,2) = maxptr(2)
        dEleMinMax(2,3) = maxptr(3)

        ! dEleNoTraj-array (number of trajectories)
        dEleNoTraj = 0

        ! dEleTraj-array
        if(.not. allocated(dEleTraj) ) then
        	allocate(dEleTraj( maxtrajs_corrected, dEleSets_noPtsPerTraj, tattrs),STAT=alloc_err); if( (alloc_err.NE.0) ) goto 95
        else if( dEleSets_maxNoDETraj .gt. size(dEleTraj,1) )then
        	write(*,*) 'ERROR: realloc nessessary'
        	if(allocated(dEleTraj)) deallocate(dEleTraj)
        	allocate(dEleTraj( dEleSets_maxNoDETraj, dEleSets_noPtsPerTraj, tattrs),STAT=alloc_err); if( (alloc_err.NE.0) ) goto 95
        endif
        !dEleTraj = 0 not nessessary (just takes a lot of time)

        ! dEleTrajSize-array
        if( .not. allocated(dEleTrajSize) ) then
        	allocate(dEleTrajSize( maxtrajs_corrected ),STAT=alloc_err); if( (alloc_err.NE.0) ) goto 95
        else if( dEleSets_maxNoDETraj .gt. size(dEleTrajSize,1) ) then
        	write(*,*) 'ERROR: realloc nessessary'
        	if(allocated(dEleTrajSize)) deallocate(dEleTrajSize)
        	allocate(dEleTrajSize( dEleSets_maxNoDETraj ),STAT=alloc_err); if( (alloc_err.NE.0) ) goto 95
        endif
        dEleTrajSize(1:dEleSets_maxNoDETraj) = 0

        write(*,*) 'min: ',dEleMinMax(1,1),dEleMinMax(1,2),dEleMinMax(1,3)
        write(*,*) 'max: ',dEleMinMax(2,1),dEleMinMax(2,2),dEleMinMax(2,3)

        return

    95  write(*,*) 'Could not allocate enough memory... exiting'
        stop

    end subroutine initOneDEle

!
!     --------------------------------------------------------
!
!     subroutine storeDEleTraj()
!          must be thread-safe !
!
!     --------------------------------------------------------
!
    subroutine storeDEleTraj(i,j,k, traject, trajMaxMinIds, traj_err)
        use omp_lib

        ! function arguments
        integer,               intent(in) :: i,j,k
        double precision, dimension(-trajPtsMin:trajPtsMax,tattrs), intent(inout) :: traject
        integer,               intent(in) :: trajMaxMinIds(2)
        double precision,      intent(in) :: traj_err

#ifndef _CUBIC_CELLS_
        integer, automatic :: ni,nj,nk
        double precision, automatic :: endx, endy, endz
        double precision, automatic :: varx,vary,varz
#endif

        integer, automatic :: eleId,pT,curPt,v
        double precision, automatic :: distance

        ! skip this function if initDEle() was not successfull
        if(.not. allocated(dEleTrajSize)) return

 			! check minimum
            !!!!!!!!!!!!!!!!!!!
            pT = trajMaxMinIds(2)

#ifndef _CUBIC_CELLS_
            varx= abs(traject(pT,1)-dEleMinMax(1,1))
            vary= abs(traject(pT,2)-dEleMinMax(1,2))
            varz= abs(traject(pT,3)-dEleMinMax(1,3))

            if( varx.lt.traj_err .and.  &
                vary.lt.traj_err .and.  &
                varz.lt.traj_err) then
#else
            distance = dsqrt( (  traject(pT,1)-dEleMinMax(1,1))**2     &
                              +( traject(pT,2)-dEleMinMax(1,2))**2     &
                              +( traject(pT,3)-dEleMinMax(1,3))**2 )
            !write(*,*) traject(pT,1:3)
            !write(*,*) dEleMinMax(1,1:3)
            !write(*,*) ''
            if(distance .lt. traj_err) then
#endif

                ! check maximum
                !!!!!!!!!!!!!!!!!!!
                pT = trajMaxMinIds(1)

#ifndef _CUBIC_CELLS_
                varx= abs(traject(pT,1)-dEleMinMax(2,1))
                vary= abs(traject(pT,2)-dEleMinMax(2,2))
                varz= abs(traject(pT,3)-dEleMinMax(2,3))

                if( varx.lt.traj_err .and.  &
                    vary.lt.traj_err .and.  &
                    varz.lt.traj_err) then
#else
                distance = dsqrt( (  traject(pT,1)-dEleMinMax(2,1))**2     &
                                  +( traject(pT,2)-dEleMinMax(2,2))**2     &
                                  +( traject(pT,3)-dEleMinMax(2,3))**2 )
                !write(*,*) traject(pT,1:3)
                !write(*,*) dEleMinMax(1,1:3)
                !write(*,*) ''
                if(distance .lt. traj_err) then
#endif

                    !$omp critical
                    ! found a trajectory belonging to a dissipation element which shall be saved
                    if(dEleNoTraj+1 .le. dEleSets_maxNoDETraj) then

                      curPt = 0
                      dEleNoTraj = dEleNoTraj+1
                      do pT=trajMaxMinIds(2), trajMaxMinIds(1)

                        ! only save points which have a distance to last saved one of 0.3*cellsize
                        if(curPt .gt. 0) then
                            distance = dsqrt(	 ( traject(pT,1)-dEleTraj( dEleNoTraj, curPt, 1))**2     &
                                                +( traject(pT,2)-dEleTraj( dEleNoTraj, curPt, 2))**2     &
                                                +( traject(pT,3)-dEleTraj( dEleNoTraj, curPt, 3))**2 )
                            if(distance .lt. 0.3) cycle
                        endif

                        ! remember how many points we had to skip, because of too much points
                        if(curPt+1 .gt. dEleSets_noPtsPerTraj) then
                        	dEleTrajError = dEleTrajError+1
                        	exit
                        endif
                        curPt = curPt+1
#ifndef _CUBIC_CELLS_
                        ni   = int(traject(pT,1))
                        endx =     traject(pT,1)-ni

                        nj   = int(traject(pT,2))
                        endy =     traject(pT,2)-nj

                        nk   = int(traject(pT,3))
                        endz =     traject(pT,3)-nk

                        dEleTraj( dEleNoTraj, curPt, 1) = coordx(ni) +endx*(coordx(ni+1)-coordx(ni))
                        dEleTraj( dEleNoTraj, curPt, 2) = coordy(nj) +endy*(coordy(nj+1)-coordy(nj))
                        dEleTraj( dEleNoTraj, curPt, 3) = coordz(nk) +endz*(coordz(nk+1)-coordz(nk))
#else
                        dEleTraj( dEleNoTraj, curPt, 1) = traject(pT,1) !*Lx/dble(origdims(1))	! x
                        dEleTraj( dEleNoTraj, curPt, 2) = traject(pT,2) !*Ly/dble(origdims(2))	! y
                        dEleTraj( dEleNoTraj, curPt, 3) = traject(pT,3) !*Lz/dble(origdims(3))	! z
#endif
                        dEleTraj( dEleNoTraj, curPt, 4) = traject(pT,4)	! scalar

                        dEleTraj( dEleNoTraj, curPt, 5) = traject(pT,5)	! normal vector x
                        dEleTraj( dEleNoTraj, curPt, 6) = traject(pT,6)	! normal vector y
                        dEleTraj( dEleNoTraj, curPt, 7) = traject(pT,7)	! normal vector z
                        dEleTraj( dEleNoTraj, curPt, 8) = traject(pT,8)	! gradient psi

                        dEleTraj( dEleNoTraj, curPt, 9) = traject(pT,9)	! trajectory density

                        ! additional vars
                        do v=1, novars
                          dEleTraj( dEleNoTraj, curPt, v+dEleTrajVars_offset) = traject(pT,v+dEleTrajVars_offset)
                        enddo

!                        if(novars .eq. 3) then
!                          dEleTraj( dEleNoTraj, curPt, v+dEleTrajVars_offset+1) = traject(pT,v+dEleTrajVars_offset+1)
!                          dEleTraj( dEleNoTraj, curPt, v+dEleTrajVars_offset+2) = traject(pT,v+dEleTrajVars_offset+2)
!                          dEleTraj( dEleNoTraj, curPt, v+dEleTrajVars_offset+3) = traject(pT,v+dEleTrajVars_offset+3)
!                          dEleTraj( dEleNoTraj, curPt, v+dEleTrajVars_offset+4) = traject(pT,v+dEleTrajVars_offset+4)
!                        endif

                      enddo
                        dEleTrajSize(dEleNoTraj) = curPt

                    endif
                !$omp end critical

                else
                  write(*,fmt='(a,i5,i5,i5)') '?? found traj does not end at element minimum', i,j,k
                  write(*,*) '   ',traject(trajMaxMinIds(2),1),traject(trajMaxMinIds(2),2),traject(trajMaxMinIds(2),3)
                  write(*,*) '   ',dEleMinMax(2,1),dEleMinMax(2,2),dEleMinMax(2,3)
                endif
            else
              write(*,fmt='(a,i5,i5,i5)') '?? found traj does not end at element maximum', i,j,k
              write(*,*) '   ',traject(trajMaxMinIds(1),1),traject(trajMaxMinIds(1),2),traject(trajMaxMinIds(1),3)
              write(*,*) '   ',dEleMinMax(1,1),dEleMinMax(1,2),dEleMinMax(1,3)
            endif

    end subroutine storeDEleTraj

!
!     --------------------
!
!     subroutine initDEle()
!
!     --------------------
!
!    subroutine initDEle()
!
!        integer :: dE, alloc_err
!        character(len=20)	:: settingsFile
!        settingsFile='saveEleSettings.txt'
!
!        ! read dissip. element settings file
!        write(*,*) 'reading dissipation element settings'
!
!        open(unit=51, file=settingsFile, err=96, status='unknown', form='formatted', action='read')
!            rewind(51)
!
!            ! read dissipation elements settings
!            read(51,*,err=97) dEleSets_saveTraj;       write(*,*) '  save trajectory  : ', dEleSets_saveTraj
!            if(dEleSets_saveTraj .eq. 0) goto 90
!
!            read(51,*,err=97) dEleSets_trajPtsPerCell; write(*,*) '  traj-pts per cell: ', dEleSets_trajPtsPerCell
!            read(51,*,err=97)
!            read(51,*,err=97) dEleSets_nodEles;      write(*,*) '  number of diss. elements   : ', dEleSets_nodEles
!            read(51,*,err=97) dEleSets_noPtsPerTraj; write(*,*) '  max number of pts per traj.: ', dEleSets_noPtsPerTraj
!
!            ! dEleMinMax-array
!            allocate(dEleMinMax( dEleSets_nodEles, 2, 3),STAT=alloc_err)
!            if( (alloc_err.NE.0) ) goto 95
!            dEleMinMax(:,:,:)=0
!
!            ! dEleNoTraj-array
!            allocate(dEleNoTraj( dEleSets_nodEles ),STAT=alloc_err)
!            if( (alloc_err.NE.0) ) goto 95
!            dEleNoTraj(:)=0
!
!            do dE=1,dEleSets_noDEles
!                read(51,*,err=97); write(*,*) '    dissipation element ',dE
!                read(51,*,err=97) dEleMinMax(dE,1,1), dEleMinMax(dE,1,2), dEleMinMax(dE,1,3); write(*,*) '    min:',dEleMinMax(dE,1,1), dEleMinMax(dE,1,2), dEleMinMax(dE,1,3)
!                read(51,*,err=97) dEleMinMax(dE,2,1), dEleMinMax(dE,2,2), dEleMinMax(dE,2,3); write(*,*) '    max:',dEleMinMax(dE,2,1), dEleMinMax(dE,2,2), dEleMinMax(dE,2,3)
!                read(51,*,err=97) dEleNoTraj(dE); write(*,*) '    number of trajectories: ', dEleNoTraj(dE)
!                if(dEleSets_maxNoDETraj < dEleNoTraj(dE)) dEleSets_maxNoDETraj = dEleNoTraj(dE)
!                write(*,*)
!            enddo
!
!            ! dEleTraj-array
!            allocate(dEleTraj( dEleSets_nodEles, dEleSets_maxNoDETraj, dEleSets_noPtsPerTraj, 6),STAT=alloc_err)
!            if( (alloc_err.NE.0) ) goto 95
!            dEleTraj(:,:,:,:)=0
!
!            ! dEleTrajSize-array
!            allocate(dEleTrajSize( dEleSets_nodEles, dEleSets_maxNoDETraj ),STAT=alloc_err)
!            if( (alloc_err.NE.0) ) goto 95
!            dEleTrajSize(:,:)=0
!
!    90  close(51)
!
!           return
!
!    95  write(*,*) 'Could not allocate enough memory... exiting'
!        stop
!
!    96  write(*,*) 'Could not OPEN ',settingsFile, ' => not saving any dis.elements trajectories'
!        return
!
!    97  write(*,*) 'Could not READ ',settingsFile, ' ... exiting'
!        stop
!
!    end subroutine initDEle

!
!     --------------------------------------------------------
!
!     subroutine saveDEleTraj_ensight()
!
!     --------------------------------------------------------
!
!    subroutine saveDEleTraj_ensight()
!        use mod_io
!
!        integer :: eleId, trajId, ptId
!        integer :: noPts, noTrajs
!        integer :: trajSkip, ptSkip
!        logical :: txt_format, ensight_format
!
!        integer :: lastPtId
!        character(len=30) :: fo_dEleTraj
!
!        txt_format     = .true.
!        ensight_format = .true.
!
!        write(*,*) 'writing diss.elements'
!
!        ! private txt-format
!        if(txt_format .eqv. .true.) then
!            fo_dEleTraj = 'dEleTraj.txt'
!            write(*,*) '   in private txt-output to ',fo_dEleTraj
!            open(unit=61, file=fo_dEleTraj, err=108, status='unknown', form='formatted', action='WRITE')
!                rewind(61)
!
!                write(61,*,err=109) dEleSets_nodEles, ' ! number of diss. elements'
!                write(61,*,err=109)
!
!                do eleId=1, dEleSets_nodEles ! loop over elements
!                    write(61,*,err=109) eleId, ' ! diss. element id'
!                    write(61,*,err=109) dEleNoTraj(eleId), ' ! number of trajectories'
!                    write(61,*)
!
!                    do trajId=1, dEleNoTraj(eleId) ! loop over trajectories
!                        write(61,*,err=109) trajId, ' ! trajectory id'
!                        write(61,*,err=109)  dEleTrajSize(eleId,trajId), ' ! number of points'
!                        write(61,*,err=109) '              ! x     y     z     u     v     w'
!                        do ptId=1, dEleTrajSize(eleId,trajId) ! loop over points on trajectory
!                            write(61,fmt='(f,f,f,f,f,f)',err=109) 	               &
!                                                    dEleTraj( eleId, trajId, ptId, 1), & ! x
!                                                    dEleTraj( eleId, trajId, ptId, 2), & ! y
!                                                    dEleTraj( eleId, trajId, ptId, 3), & ! z
!                                                    dEleTraj( eleId, trajId, ptId, 4), & ! u
!                                                    dEleTraj( eleId, trajId, ptId, 5), & ! v
!                                                    dEleTraj( eleId, trajId, ptId, 6)    ! w
!                        enddo
!                    enddo
!                enddo
!            close(61)
!        endif
!
!        ! ENSIGHT-format
!        if(ensight_format .eqv. .true.) then
!            ! write case file
!            fo_dEleTraj = 'dEleTraj.case'
!             write(*,*) '   in ENSIGHT-format to '
!             write(*,*) '             ',fo_dEleTraj
!            trajSkip = 1
!            ptSkip   = 1
!            open(unit=61, file=fo_dEleTraj, err=108, status='unknown', form='formatted', action='WRITE')
!                rewind(61)
!                write(61,fmt='(A)',err=109) '# Description: dissipation elements'
!                write(61,fmt='(A)',err=109) '# Date       :'
!                write(61,fmt='(A)',err=109) '# Case File  : dissipEle.case'
!                write(61,fmt='(A)',err=109)
!                write(61,fmt='(A)',err=109) 'FORMAT'
!                write(61,fmt='(A)',err=109) 'type: ensight gold'
!                write(61,fmt='(A)',err=109)
!                write(61,fmt='(A)',err=109) 'GEOMETRY'
!                write(61,fmt='(A)',err=109) 'model: dEleTraj.geo_001'
!                write(61,fmt='(A)',err=109)
!                write(61,fmt='(A)',err=109) 'VARIABLE'
!                write(61,fmt='(A)',err=109) 'vector per node:  velocity dEleTraj.velocity_001'
!                !write(61,fmt='(A)',err=109) 'scalar per node:  uvw dEleTraj.var_001'
!                !write(61,fmt='(A)',err=109)
!                !write(61,fmt='(A)',err=109) 'TIME'
!                !write(61,fmt='(A)',err=109) 'time set:          1'
!                !write(61,fmt='(A)',err=109) 'number of steps:  1'
!                !write(61,fmt='(A)',err=109) 'filename numbers:'
!                !write(61,fmt='(A)',err=109) '001'
!                !write(61,fmt='(A)',err=109) 'time values:'
!                !write(61,fmt='(A)',err=109) '0.0'
!                !write(61,fmt='(A)',err=109)
!            close(61)
!
!            ! write geometry file
!            fo_dEleTraj = 'dEleTraj.geo_001'
!            write(*,*) '             ',fo_dEleTraj
!            open(unit=62, file=fo_dEleTraj, err=108, status='unknown', form='formatted', action='WRITE')
!                rewind(62)
!                write(62,fmt='(A)',err=109) 'This is the 1st description line of the EnSight Gold geometry example'
!                write(62,fmt='(A)',err=109) 'This is the 2nd description line of the EnSight Gold geometry example'
!                write(62,fmt='(A)',err=109) 'node id off'
!                write(62,fmt='(A)',err=109) 'element id off'
!                !write(62,fmt='(A)',err=109) 'extents'
!                !write(62,fmt='(2E12.5)',err=109) 0.0, 0.0, 0.0
!                !write(62,fmt='(2E12.5)',err=109) pi2, pi2, pi2
!
!                do eleId=1, dEleSets_nodEles ! loop over dissipation elements
!
!                    ! part header
!                    write(62,fmt='(A)',err=109) 'part'
!                    write(62,fmt='(I10)',err=109) eleId
!                    write(62,fmt='(A)',err=109) 'description line for part 1'
!                    write(62,fmt='(A)',err=109) 'coordinates'
!
!                    noPts   = 0
!                    noTrajs = 0
!                    do trajId=1, dEleNoTraj(eleId), trajSkip ! loop over trajectories for x-coordinate
!                        noTrajs = noTrajs + 1
!                        do ptId=1, dEleTrajSize(eleId,trajId), ptSkip ! loop over points on trajectory
!                            noPts = noPts + 1
!                        enddo
!                    enddo
!                    write(62,fmt='(I10)',err=109) noPts
!
!                    ! part coordinates
!                    do trajId=1, dEleNoTraj(eleId), trajSkip ! loop over trajectories for x-coordinate
!                        do ptId=1, dEleTrajSize(eleId,trajId), ptSkip ! loop over points on trajectory
!                            write(62,fmt='(E12.5)',err=109) dEleTraj( eleId, trajId, ptId, 1) ! x
!                        enddo
!                    enddo
!                    do trajId=1, dEleNoTraj(eleId), trajSkip ! loop over trajectories for y-coordinate
!                        do ptId=1, dEleTrajSize(eleId,trajId), ptSkip ! loop over points on trajectory
!                            write(62,fmt='(E12.5)',err=109) dEleTraj( eleId, trajId, ptId, 2) ! y
!                        enddo
!                    enddo
!                    do trajId=1, dEleNoTraj(eleId), trajSkip ! loop over trajectories for z-coordinate
!                        do ptId=1, dEleTrajSize(eleId,trajId), ptSkip ! loop over points on trajectory
!                            write(62,fmt='(E12.5)',err=109) dEleTraj( eleId, trajId, ptId, 3) ! z
!                        enddo
!                    enddo
!
!                    ! part cells
!                    write(62,fmt='(A)',err=109) 'bar2'	! cell type
!                    lastPtId = 0
!                    do trajId=1, dEleNoTraj(eleId), trajSkip ! loop over trajectories
!                        do ptId=1, dEleTrajSize(eleId,trajId)-ptSkip, ptSkip ! loop over points on trajectory
!                            lastPtId = lastPtId+1
!                        enddo
!                    enddo
!                    write(62,fmt='(I10)',err=109) lastPtId ! number of cells
!
!                    lastPtId = 0
!                    do trajId=1, dEleNoTraj(eleId), trajSkip ! loop over trajectories
!                        do ptId=1, dEleTrajSize(eleId,trajId)-ptSkip, ptSkip ! loop over points on trajectory
!                            lastPtId = lastPtId+1
!                            write(62,fmt='(I10,I10)',err=109) lastPtId, lastPtId+1
!                        enddo
!                    enddo
!
!                enddo
!            close(62)
!
!            ! write variable file
!            fo_dEleTraj = 'dEleTraj.velocity_001'
!            write(*,*) '             ',fo_dEleTraj
!            open(unit=62, file=fo_dEleTraj, err=108, status='unknown', form='formatted', action='WRITE')
!                rewind(62)
!                write(62,fmt='(A)',err=109) 'This is the 1st description line of the EnSight Gold variable example'
!
!                do eleId=1, dEleSets_nodEles ! loop over dissipation elements
!
!                    ! part header
!                    write(62,fmt='(A)',err=109) 'part'
!                    write(62,fmt='(I10)',err=109) eleId
!                    write(62,fmt='(A)',err=109) 'coordinates'
!
!                    ! part variables
!                    do trajId=1, dEleNoTraj(eleId), trajSkip ! loop over trajectories for x-coordinate
!                        do ptId=1, dEleTrajSize(eleId,trajId), ptSkip ! loop over points on trajectory
!                            write(62,fmt='(E12.5)',err=109) dEleTraj( eleId, trajId, ptId, 4) ! u
!                        enddo
!                    enddo
!                    do trajId=1, dEleNoTraj(eleId), trajSkip ! loop over trajectories for y-coordinate
!                        do ptId=1, dEleTrajSize(eleId,trajId), ptSkip ! loop over points on trajectory
!                            write(62,fmt='(E12.5)',err=109) dEleTraj( eleId, trajId, ptId, 5) ! v
!                        enddo
!                    enddo
!                    do trajId=1, dEleNoTraj(eleId), trajSkip ! loop over trajectories for z-coordinate
!                        do ptId=1, dEleTrajSize(eleId,trajId), ptSkip ! loop over points on trajectory
!                            write(62,fmt='(E12.5)',err=109) dEleTraj( eleId, trajId, ptId, 6) ! w
!                        enddo
!                    enddo
!
!                enddo
!            close(62)
!        endif
!
!        return
!
!    108 write(*,*) 'Could not OPEN ',fo_dEleTraj, ' ... exiting'
!        return
!
!    109 write(*,*) 'Could not WRITE ',fo_dEleTraj, ' ... exiting'
!        return
!
!    end subroutine saveDEleTraj_ensight

!
!     -----------
!
!     write trajectory-information of omp task
!
!     -----------
!
    subroutine write_trajects_omp(traject_pool, traject_minmax, lb1,ub1, lb2,ub2, lb3,ub3, dump_lb3, dump_ub3, traject_pktid)
        use omp_lib
        use mod_data
        implicit none

        ! function vars
        integer, intent(in) :: lb1, ub1
        integer, intent(in) :: lb2, ub2
        integer, intent(in) :: lb3, ub3
        integer, intent(in) :: dump_lb3, dump_ub3
        double precision, dimension(lb1:ub1, lb2:ub2, lb3:ub3), intent(in) :: traject_pool
        integer, dimension(2,lb3:ub3), intent(in) :: traject_minmax
        integer, intent(in) :: traject_pktid

        ! other vars
        character(len=1024) :: filepath1,   filepath2
        character(len=1024) :: filepath1txt,filepath2txt
        integer :: filebytes
        integer :: intbytes, dblebytes; parameter(intbytes=4); parameter(dblebytes=8)
        integer :: t, p
        integer :: uid_bin, uid_txt

        ! create filenames
        write(filepath1   ,'(a,i4.4,a,i9.9,''.bin'')') '~trajects_ompid', omp_get_thread_num(), '_pktid', traject_pktid
        write(filepath1txt,'(a,i4.4,a,i9.9,''.txt'')') '~trajects_ompid', omp_get_thread_num(), '_pktid', traject_pktid
        filepath1    = trim(filepath1)
        filepath1txt = trim(filepath1txt)
        write(filepath2,   '(a,i4.4,a,i9.9,''.bin'')')  'trajects_ompid', omp_get_thread_num(), '_pktid', traject_pktid
        write(filepath2txt,'(a,i4.4,a,i9.9,''.txt'')')  'trajects_ompid', omp_get_thread_num(), '_pktid', traject_pktid
        filepath2    = trim(filepath2)
        filepath2txt = trim(filepath2txt)

        ! dump data to disk
        uid_bin = 70 +omp_get_thread_num()
        uid_txt = 71 +omp_get_thread_num()
        !write(*,*) 'dumping trajectories as ',filepath1
        open(unit=uid_bin, file=filepath1, form='binary', access='stream')
        open(unit=uid_txt, file=filepath1txt)
          ! write header
          write(uid_bin)   dump_ub3-dump_lb3+1
          write(uid_txt,*) dump_ub3-dump_lb3+1

          ! write data
          do t=dump_lb3, dump_ub3 ! loop over all trajectories in this packet
            write(uid_bin)   ceiling((-traject_minmax(1,t) +traject_minmax(2,t) +1) / dble(dumpTraj_ptstride))
            write(uid_txt,*) ceiling((-traject_minmax(1,t) +traject_minmax(2,t) +1) / dble(dumpTraj_ptstride))
            do p=traject_minmax(1,t), traject_minmax(2,t), dumpTraj_ptstride
              write(uid_bin)   traject_pool(p,1,t), traject_pool(p,2,t), traject_pool(p,3,t), traject_pool(p,4,t)
              write(uid_txt,*) traject_pool(p,1,t), traject_pool(p,2,t), traject_pool(p,3,t), traject_pool(p,4,t)
            enddo
          enddo
        close(uid_bin)
        close(uid_txt)

        ! rename data
        call rename(filepath1, filepath2)
        call rename(filepath1txt,filepath2txt)

    end subroutine

end module mod_dele
