!
! Copyright (C) 2005-2010 by  Institute of Combustion Technology - RWTH Aachen University
! Lipo Wang, lwang@itv.rwth-aachen.de (2005-2006)
! Jens Henrik Goebbert, goebbert@itv.rwth-aachen.de (2007-2010)
! All rights reserved.
!

module mod_traj
    use mod_data

    implicit none
    save

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

    integer :: numends

    contains

!
!     --------------------
!
!     subroutine initGlobalTraj()
!
!     --------------------
!
    subroutine initGlobalTraj()
        implicit none

        integer :: alloc_err=0

        ! Initialization
        call allocate_globals('signs',alloc_err)
        signs = .true.

        call allocate_globals('points',alloc_err)
        points = 0.d0

        call allocate_globals('numbering',alloc_err)
        numbering = 0

        call allocate_globals('counter',alloc_err)
        counter = 0.d0

        call allocate_globals('identity',alloc_err)
        identity = 0

        call allocate_globals('trajcount',alloc_err)
        trajcount = 0

        numends   = 0

        tattrs = 4 +novars
        if(novars .eq. 3) tattrs = tattrs +5

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

        ! function vars
        integer,intent(in) :: eid
        integer,intent(in) :: verbose

        integer           :: id1, id2

        ! OpenMP private variables
        double precision, automatic :: switch
        integer, automatic           :: i,j,k, ni,nj,nk, i0,j0,k0, px,py,pz
        integer, automatic           :: istart, jstart, kstart, iend, jend, kend
        integer, automatic           :: force0, endfind, traj_found

        double precision, automatic :: subdvx(-1:0,-1:1,-1:1)
        double precision, automatic :: subdvy(-1:1,-1:0,-1:1)
        double precision, automatic :: subdvz(-1:1,-1:1,-1:0)

        double precision, automatic :: endx,endy,endz
        double precision, automatic :: posx,posy,posz
        double precision, automatic :: vecn(3), vecl

        double precision, automatic :: dxp,dxm, dyp,dym, dzp,dzm

#ifdef _FAST_TRAJCOUNT_
        integer, dimension(:,:,:),  allocatable :: trajcount_omp
#endif
        double precision, dimension(:,:), allocatable :: traject
        integer, automatic :: trajPtId, trajDir, trajStep
        integer, automatic :: trajMaxMinIds(2)

        double precision, dimension(:), allocatable :: trajLenPath
        double precision, dimension(:), allocatable :: trajV
        double precision, dimension(:,:), allocatable :: corr_omp
        double precision, dimension(:), allocatable :: mpdf_omp

        integer, automatic :: jumps

        ! variables
        integer :: alloc_err=0

        double precision, dimension(0:1000,4) :: corr
        double precision, dimension(0:1000) :: mpdf

        jumps     = 0

!        open(unit=77,file='directout')
!        write(77,*) psi
!        close(77)

        istart = subdomain(1,1)+1
        jstart = subdomain(2,1)+1
        kstart = subdomain(3,1)+1
        iend = subdomain(1,2)-1
        jend = subdomain(2,2)-1
        kend = subdomain(3,2)-1

        write(*,*)
        if(verbose .gt. 1) write(*,*) 'Entering parallel section...'
        !$omp parallel                                                         &
        !$omp default( shared )                                                &
        !$omp firstprivate( switch, alloc_err )                                &
        !$omp firstprivate( i, j, k, ni, nj, nk, i0, j0, k0, px, py, pz )      &
        !$omp firstprivate( force0, endfind, traj_found, vecn, vecl )          &
        !$omp firstprivate( subdvx, subdvy, subdvz )                           &
        !$omp firstprivate( endx, endy, endz)                                  &
        !$omp firstprivate( posx, posy, posz )                                 &
        !$omp firstprivate( dxp,dxm, dyp,dym, dzp,dzm )                        &
        !$omp firstprivate( trajPtId, trajDir, trajMaxMinIds, trajStep )       &
        !$omp private( traject, trajLenPath, trajV, corr_omp, mpdf_omp )       &
#ifdef _FAST_TRAJCOUNT_
        !$omp private( trajcount_omp )                                         &
#endif
        !$omp reduction(+:jumps)

#ifdef _FAST_TRAJCOUNT_
        allocate(trajcount_omp(ndims(1),ndims(2),ndims(3)),STAT=alloc_err)
        trajcount_omp = 0
#endif

        if(saveTraj .eq. 1 .or. analyTraj .gt. 0) then
          allocate(traject(-10*ndims(1):10*ndims(1),tattrs),STAT=alloc_err)
          if(analyTraj .gt. 0) then

            allocate( trajLenPath(-10*ndims(1):10*ndims(1)), STAT=alloc_err )
            allocate( trajV(-10*ndims(1):10*ndims(1)), STAT=alloc_err )
            allocate( corr_omp(0:1000,4), STAT=alloc_err)
            corr_omp = 0.d0
            allocate( mpdf_omp(0:1000), STAT=alloc_err)
            mpdf_omp = 0.d0

          endif
        endif

        !$omp do schedule (dynamic,1)
        do i=istart,iend
            if(verbose .gt. 1) write(*,*) 'i,numends, jumps=',i,numends, jumps
            do j=jstart,jend
                do k=kstart,kend

                    ! only scan special grid-points
                    if( eid .gt. 0 )  then
                        if( allocated(note) ) then
                            if( eid .ne. note(i,j,k) ) cycle
                        endif
                    endif

                    trajMaxMinIds(1) = 0        ! found points in positiv direction
                    trajMaxMinIds(2) = 0        ! found points in negativ direction

                    ! save values at grid-point as traject(0,:)
                    endx = 0.d0
                    endy = 0.d0
                    endz = 0.d0

                    if(saveTraj .eq. 1 .or. analyTraj .gt. 0) then
                      vecn(1) = (psi(i+1,j  ,k  ) -psi(i-1,j  ,k  )) /(2.d0 *pi2 /dble(origdims(1)))
                      vecn(2) = (psi(i  ,j+1,k  ) -psi(i  ,j-1,k  )) /(2.d0 *pi2 /dble(origdims(2)))
                      vecn(3) = (psi(i  ,j  ,k+1) -psi(i  ,j  ,k-1)) /(2.d0 *pi2 /dble(origdims(3)))
                      vecl  = sqrt(vecn(1)**2 +vecn(2)**2 +vecn(3)**2) +1.d-20
                      call calcTrajPtValues(traject,0,       &
                                            endx,endy,endz,   &
                                            i,j,k,            &
                                            vecn,vecl)
                    endif

#ifdef _FAST_TRAJCOUNT_
                    trajcount_omp(i,j,k) = trajcount_omp(i,j,k) +1
#else
                    !$omp critical
                    trajcount(i,j,k) = trajcount(i,j,k) +1
                    !$omp end critical
#endif
                    ! Trajectory - Calculation in positiv and negativ direction
                    traj_found = 1
                    do trajDir=1,2

                        if(trajDir.eq.1) then    ! positiv direction
                            switch  =1.d0
                            trajStep=1
                        else                     ! negativ direction
                            switch  =-1.d0
                            trajStep=-1
                        endif

                        force0=0
                        endfind=0

                        posx=0
                        posy=0
                        posz=0

                        ni=i
                        nj=j
                        nk=k

                        trajPtId=0

                        ! walk along the trajectory until a max/min is found
                        do while(endfind.eq.0)

                            ! have we reached the boundary ?? exit loop if so
                            if(     (ni.eq.1).or.(ni.eq.ndims(1))            &
                                .or.(nj.eq.1).or.(nj.eq.ndims(2))            &
                                .or.(nk.eq.1).or.(nk.eq.ndims(3))) then
                                    exit
                            endif

                            ! interpolation of derivative
                            do i0=-1,0
                                do j0=-1,1
                                    do k0=-1,1
                                        subdvx(i0,j0,k0)= (  psi(ni+i0+1,nj+j0,nk+k0)        &
                                                            -psi(ni+i0,nj+j0,nk+k0)   )      &
#ifndef _CUBIC_2PI_
                                                            /(coordx(ni+i0+1)-coordx(ni+i0))
#else
                                                            /(2*pi/dble(origdims(1)) )
#endif
                                    enddo
                                enddo
                            enddo

                            do i0=-1,1
                                do j0=-1,0
                                    do k0=-1,1
                                        subdvy(i0,j0,k0)= (  psi(ni+i0,nj+j0+1,nk+k0)        &
                                                            -psi(ni+i0,nj+j0,nk+k0)   )      &
#ifndef _CUBIC_2PI_
                                                            /(coordy(nj+j0+1)-coordy(nj+j0))
#else
                                                            /(2*pi/dble(origdims(2)) )
#endif
                                    enddo
                                enddo
                            enddo

                            do i0=-1,1
                                do j0=-1,1
                                    do k0=-1,0
                                        subdvz(i0,j0,k0)= (  psi(ni+i0,nj+j0,nk+k0+1)        &
                                                            -psi(ni+i0,nj+j0,nk+k0)   )      &
#ifndef _CUBIC_2PI_
                                                            /(coordz(nk+k0+1)-coordz(nk+k0))
#else
                                                            /(2*pi/dble(origdims(3)) )
#endif
                                    enddo
                                enddo
                            enddo

#ifndef _CUBIC_2PI_
                            dxp= coordx(ni+1)-coordx(ni)
                            dxm= coordx(ni)  -coordx(ni-1)
                            dyp= coordy(nj+1)-coordy(nj)
                            dym= coordy(nj)  -coordy(nj-1)
                            dzp= coordz(nk+1)-coordz(nk)
                            dzm= coordz(nk)  -coordz(nk-1)
#endif

                            ! what is the path of trajectory through the staggered-grid-cell?
                            call endpoint(  posx,posy,posz,             &
                                            endx,endy,endz, switch,      &
                                            subdvx,subdvy,subdvz,        &
#ifndef _CUBIC_2PI_
                                            dxp,dxm, dyp,dym, dzp,dzm,   &
#endif
                                            endfind,jumps,               &
                                            vecn,vecl)

                            ! see thesise - stop infinitiv loop
                            force0=force0+1
                            if(force0 .gt. 1000) then
                                endfind=1
                                traj_found = 0
                                exit
                            endif

                            ! last step to endpoint ?
                            if(endfind.eq.1) then
                                !$omp critical
                                    ! Nummer des Endpunktes finden und speichern in numbering,points
                                    call numberfind(trajDir, i,j,k,                      &
                                                    numends, signs, points, numbering,   &
                                                    ni+endx, nj+endy, nk+endz )
                                !$omp end critical
                            endif

                            ! calculate values on current trajectory-point
                            trajPtId = trajPtId+trajStep
                            if(saveTraj .eq. 1 .or. analyTraj .gt. 0) then
                              call calcTrajPtValues(traject,trajPtId,      &
                                                   endx,endy,endz,          &
                                                   ni,nj,nk,                &
                                                   vecn,vecl)
                            endif

                            ! increase density of trajectories at px,py,pz
                              px=ni+endx
                              py=nj+endy
                              pz=nk+endz
#ifdef _FAST_TRAJCOUNT_
                              trajcount_omp(px,py,pz) = trajcount_omp(px,py,pz) +1
#else
                              !$omp critical
                              trajcount(px,py,pz) = trajcount(px,py,pz) +1
                              !$omp end critical
#endif

                            ! check if trajectory left current staggered grid cell
                            call tellnew(    ni,nj,nk,        &
                                            endx,endy,endz,    &
                                            posx,posy,posz )

                        enddo    ! endfind.eq.0

                        ! save number of trajectory-points in negativ and positiv direction
                        trajMaxMinIds(trajDir) = trajPtId

                    enddo        ! trajDir

                    ! store trajectory of dissipation elements if min and max was found
                    if( saveTraj .eq. 1 .and. traj_found .eq. 1)		&
                    	call storeDEleTraj( i,j,k, traject, trajMaxMinIds, traj_err )

                    ! analyse found trajectory
                    if(analyTraj .gt. 0) then
                    	call analyDEleTraj( i,j,k, traject, trajMaxMinIds, trajLenPath, trajV, corr_omp, mpdf_omp )
                    endif

                enddo            ! ndimz
            enddo                ! ndimy

            if(analyTraj .gt. 0) then
              call saveDEleTrajAnalysis( i, corr, mpdf, corr_omp, mpdf_omp )
            endif

        enddo                    ! ndimx
        !$omp end do
        if(verbose .gt. 1) write(*,*) 'thread: jumps =', jumps

#ifdef _FAST_TRAJCOUNT_
        !$omp critical
          trajcount = trajcount +trajcount_omp
        !$omp end critical
#endif

#ifdef _FAST_TRAJCOUNT_
        if(allocated(trajcount_omp)) deallocate(trajcount_omp)
#endif
        if(saveTraj .eq. 1 .or. analyTraj .gt. 0) then
          if(allocated(traject))       deallocate(traject)
          if(analyTraj .gt. 0) then
            if(allocated(trajLenPath))  deallocate( trajLenPath )
            if(allocated(trajV))        deallocate( trajV )
            if(allocated(corr_omp))     deallocate( corr_omp )
            if(allocated(mpdf_omp))     deallocate( mpdf_omp )
          endif
        endif

        !$omp end parallel

        if(verbose .gt. 0) write(*,*) 'numends,jumpratio =',numends,DBLE(jumps)/dble(ndims(1) *ndims(2)*ndims(3))

        return
    end subroutine findTraj

!
!     --------------------------------------------------------
!
!     subroutine calcTrajPtValues()
!
!     Interpolates values on the trajectory at location nijk+endxyz and stores them
!     in the the array 'traject(direction,stepNo,value)'
!
!     --------------------------------------------------------
!
    subroutine calcTrajPtValues(traject, trajPtId, endx,endy,endz, ni,nj,nk, vecn, vecl)

        ! function arguments
        double precision, intent(inout)  :: traject(-10*ndims(1):10*ndims(1),tattrs)
        integer,          intent(in)      :: trajPtId
        double precision, intent(in)     :: endx,endy,endz
        integer,          intent(in)      :: ni,nj,nk
        double precision, intent(in)      :: vecn(3), vecl

        integer, automatic :: px,py,pz
        double precision, automatic :: dx,dy,dz
        integer, automatic :: v

        ! example 3.251431=>3    (-0.5<=endx=>0.5)
        px=ni+endx
        py=nj+endy
        pz=nk+endz

        dx=ni+endx-px
        dy=nj+endy-py
        dz=nk+endz-pz

        traject(trajPtId,1)=ni+endx
        traject(trajPtId,2)=nj+endy
        traject(trajPtId,3)=nk+endz

        ! double check --> debug infos
        if(px+1.gt.ndims(1) .or. py+1.gt.ndims(2) .or. pz+1.gt.ndims(3)) then
            write(*,*) 'about to segfault in "calcTrajPtValues()": probably coord-arrays not correct...'
            write(*,*) 'ni,nj,nk:'			,ni,nj,nk
            write(*,*) 'endx, endy, endz:'	,endx, endy, endz
            write(*,*) 'px,py,pz:'			,px,py,pz
        endif

        ! scalar
        if(allocated(psi))  traject(trajPtId,4) =                        &
                 (1.d0-dx) *(1.d0-dy) *(1.d0-dz) *psi(px,  py,  pz)      &
                +dx        *(1.d0-dy) *(1.d0-dz) *psi(px+1,py,  pz)      &
                +(1.d0-dx) *dy        *(1.d0-dz) *psi(px,  py+1,pz)      &
                +(1.d0-dx) *(1.d0-dy) *dz        *psi(px,  py,  pz+1)    &
                +(1.d0-dx) *dy        *dz        *psi(px,  py+1,pz+1)    &
                +dx        *(1.d0-dy) *dz        *psi(px+1,py,  pz+1)    &
                +dx        *dy        *(1.d0-dz) *psi(px+1,py+1,pz)      &
                +dx        *dy        *dz        *psi(px+1,py+1,pz+1)

        ! additional datasets ratio
        if(allocated(vars)) then
          do v=1, novars
                traject(trajPtId,v+dEleTrajVars_offset) =                     &
                 (1.d0-dx) *(1.d0-dy) *(1.d0-dz) *vars(px,  py,  pz, v)       &
                +dx        *(1.d0-dy) *(1.d0-dz) *vars(px+1,py,  pz, v)       &
                +(1.d0-dx) *dy        *(1.d0-dz) *vars(px,  py+1,pz, v)       &
                +(1.d0-dx) *(1.d0-dy) *dz        *vars(px,  py,  pz+1, v)     &
                +(1.d0-dx) *dy        *dz        *vars(px,  py+1,pz+1, v)     &
                +dx        *(1.d0-dy) *dz        *vars(px+1,py,  pz+1, v)     &
                +dx        *dy        *(1.d0-dz) *vars(px+1,py+1,pz, v)       &
                +dx        *dy        *dz        *vars(px+1,py+1,pz+1, v)
          enddo
          if(novars .eq. 3) then
                traject(trajPtId,novars+dEleTrajVars_offset+1)=vecn(1)
                traject(trajPtId,novars+dEleTrajVars_offset+2)=vecn(2)
                traject(trajPtId,novars+dEleTrajVars_offset+3)=vecn(3)
                traject(trajPtId,novars+dEleTrajVars_offset+4)=vecl
                if( trajcount(px,py,pz) .le. 0) then
                  write(*,*) 'ERROR: trajcount < 1 at ',px,py,pz
                  trajcount(px,py,pz) = 1
                endif
                traject(trajPtId,novars+dEleTrajVars_offset+5)=1.d0/dble(trajcount(px,py,pz))
          endif
        endif

        return
    end subroutine calcTrajPtValues

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
      subroutine numberfind(idmm,i,j,k,numends,signs, points, numbering, tx,ty,tz)

        ! function arguments
        integer,                                                intent(in)       :: idmm,i,j,k
        integer,                                                intent(inout)    :: numends
        logical,           dimension(:),      allocatable,   intent(inout)    :: signs
        double precision, dimension(:,:),    allocatable,   intent(inout)    :: points
        integer,           dimension(:,:,:,:),allocatable,   intent(inout)    :: numbering
        double precision,                                      intent(in)       :: tx,ty,tz


        ! variables
#ifndef _CUBIC_2PI_
		integer, automatic :: idp
		double precision, automatic :: varx,vary,varz,factor
#endif

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!        double precision, automatic :: distance
!        integer, automatic           :: k0
!
!        ! meaning of numbering(,,,2) is: 1.id of max point 2.id of min point
!
!        numbering(i,j,k,idmm)=0
!
!        if(numends.eq.0) then
!
!            numends=numends+1
!
!            numbering(i,j,k,idmm)=numends
!            points(numends,1)=tx
!            points(numends,2)=ty
!            points(numends,3)=tz
!            if(idmm.eq.1) then; signs(numends)=.true.
!            else;               signs(numends)=.false.; endif
!        else
!            do k0=1,numends
!#ifndef _CUBIC_2PI_
!             	idp = tx
!        		idp = min(ndims(1)-1,idp)
!        		idp = max(1,idp)
!        		varx= (tx-points(k0,1))
!
!        		idp = ty
!        		idp = min(ndims(2)-1,idp)
!        		idp = max(1,idp)
!        		vary= (ty-points(k0,2))
!
!        		idp = tz
!        		idp = min(ndims(3)-1,idp)
!        		idp = max(1,idp)
!        		varz= (tz-points(k0,3))
!
!        		distance = dsqrt(varx**2+vary**2+varz**2)
!#else
!                distance = dsqrt(    (tx-points(k0,1))**2     &
!                                    +(ty-points(k0,2))**2     &
!                                    +(tz-points(k0,3))**2 )
!#endif
!               if(distance.lt.traj_err) then
!
!                    numbering(i,j,k,idmm)=k0
!
!                    return
!                endif
!            enddo
!
!                numends=numends+1
!
!                numbering(i,j,k,idmm)=numends
!                points(numends,1)=tx
!                points(numends,2)=ty
!                points(numends,3)=tz
!                if(idmm.eq.1) then; signs(numends)=.true.
!                else;               signs(numends)=.false.; endif
!        endif
!
!        return

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
          double precision, automatic :: corx,cory,corz, tep(4)
          integer, automatic :: i0,j0,k0, i1,j1,k1, itp(2)
          integer, automatic :: idx,idy,idz, idx1,idx2, idy1,idy2, idz1,idz2
          double precision, automatic :: distance

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
          do i0=idx1,idx2
            do j0=idy1,idy2
              do k0=idz1,idz2
                if(counter(i0,j0,k0,4) .ge. 1) then
                  corx = counter(i0,j0,k0,1)/counter(i0,j0,k0,4)
                  cory = counter(i0,j0,k0,2)/counter(i0,j0,k0,4)
                  corz = counter(i0,j0,k0,3)/counter(i0,j0,k0,4)
#ifndef _CUBIC_2PI_
                  varx=abs(tx-points(k0,1))
                  vary=abs(ty-points(k0,2))
                  varz=abs(tz-points(k0,3))
                  if(	(varx-corx) .lt. traj_err .and.	&
                     	(vary-cory) .lt. traj_err .and.	&
                     	(varz-corz) .lt. traj_err) then
#else
                  distance = dsqrt((tx-corx)**2+(ty-cory)**2+(tz-corz)**2)
                  if(distance .lt. traj_err) then
#endif
                    numbering(i,j,k,idmm) = identity(i0,j0,k0,2)

                    counter(i0,j0,k0,1) = counter(i0,j0,k0,1)+tx
                    counter(i0,j0,k0,2) = counter(i0,j0,k0,2)+ty
                    counter(i0,j0,k0,3) = counter(i0,j0,k0,3)+tz
                    counter(i0,j0,k0,4) = counter(i0,j0,k0,4)+1

                    points(identity(i0,j0,k0,2),1) = counter(i0,j0,k0,1)/counter(i0,j0,k0,4)
                    points(identity(i0,j0,k0,2),2) = counter(i0,j0,k0,2)/counter(i0,j0,k0,4)
                    points(identity(i0,j0,k0,2),3) = counter(i0,j0,k0,3)/counter(i0,j0,k0,4)

                    i1 = points(identity(i0,j0,k0,2),1)
                    j1 = points(identity(i0,j0,k0,2),2)
                    k1 = points(identity(i0,j0,k0,2),3)

                    tep(1) = counter(i0,j0,k0,1)
                    tep(2) = counter(i0,j0,k0,2)
                    tep(3) = counter(i0,j0,k0,3)
                    tep(4) = counter(i0,j0,k0,4)

                    itp(1)=identity(i0,j0,k0,1)
                    itp(2)=identity(i0,j0,k0,2)

                    counter(i0,j0,k0,1)  = 0.d0
                    counter(i0,j0,k0,2)  = 0.d0
                    counter(i0,j0,k0,3)  = 0.d0
                    counter(i0,j0,k0,4)  = 0.d0
                    identity(i0,j0,k0,1) = 0
                    identity(i0,j0,k0,2) = 0

                    counter(i1,j1,k1,1)  = counter(i1,j1,k1,1)+tep(1)
                    counter(i1,j1,k1,2)  = counter(i1,j1,k1,2)+tep(2)
                    counter(i1,j1,k1,3)  = counter(i1,j1,k1,3)+tep(3)
                    counter(i1,j1,k1,4)  = counter(i1,j1,k1,4)+tep(4)
                    identity(i1,j1,k1,1) = itp(1)
                    identity(i1,j1,k1,2) = itp(2)

                    return
                  endif

                endif
              enddo
            enddo
          enddo

      !	no extrem-point found
          if(counter(idx,idy,idz,4) .eq. 0) then
            numends=numends+1
            numbering(i,j,k,idmm) = numends

            counter(idx,idy,idz,1)  = counter(idx,idy,idz,1)+tx
            counter(idx,idy,idz,2)  = counter(idx,idy,idz,2)+ty
            counter(idx,idy,idz,3)  = counter(idx,idy,idz,3)+tz
            counter(idx,idy,idz,4)  = counter(idx,idy,idz,4)+1
            identity(idx,idy,idz,1) = idmm
            identity(idx,idy,idz,2) = numends

            points(numends,1) = counter(idx,idy,idz,1)/counter(idx,idy,idz,4)
            points(numends,2) = counter(idx,idy,idz,2)/counter(idx,idy,idz,4)
            points(numends,3) = counter(idx,idy,idz,3)/counter(idx,idy,idz,4)
            signs(numends) = idmm

      !	extrem-point found
          else if(counter(idx,idy,idz,4) .ge. 1) then

            numbering(i,j,k,idmm)  = identity(idx,idy,idz,2)
            counter(idx,idy,idz,1) = counter(idx,idy,idz,1)+tx
            counter(idx,idy,idz,2) = counter(idx,idy,idz,2)+ty
            counter(idx,idy,idz,3) = counter(idx,idy,idz,3)+tz
            counter(idx,idy,idz,4) = counter(idx,idy,idz,4)+1

            points(identity(idx,idy,idz,2),1) = counter(idx,idy,idz,1)/counter(idx,idy,idz,4)
            points(identity(idx,idy,idz,2),2) = counter(idx,idy,idz,2)/counter(idx,idy,idz,4)
            points(identity(idx,idy,idz,2),3) = counter(idx,idy,idz,3)/counter(idx,idy,idz,4)

          endif
      return

    end subroutine numberfind

!
!     --------------------------------------------------------
!
!     subroutine endpoint(posx,posy,posz,endx,endy,endz,switch,
!                         subdvx,subdvy,subdvz,endfind,jumps)
!
!     --------------------------------------------------------
!
    subroutine endpoint(posx,   posy,   posz,          &
                         endx,   endy,   endz, switch, &
                         subdvx, subdvy, subdvz,       &
#ifndef _CUBIC_2PI_
                         dxp,dxm, dyp,dym, dzp,dzm,    &
#endif
                         endfind,jumps,                &
                         vecn, totv)

!         function arguments
          double precision,    intent(in)      :: posx,posy,posz
          double precision,    intent(out)     :: endx,endy,endz
          double precision,    intent(in)      :: switch
          double precision,    intent(in)      :: subdvx(-1:0,-1:1,-1:1), subdvy(-1:1,-1:0,-1:1), subdvz(-1:1,-1:1,-1:0)
#ifndef _CUBIC_2PI_
          double precision,    intent(in)      :: dxp,dxm, dyp,dym, dzp,dzm
#endif
          integer,             intent(inout)   :: endfind, jumps
          double precision,   intent(out)     :: vecn(3), totv

!         variables
          double precision, automatic :: temp,temp1,temp2,temp3
          double precision, automatic :: nposx,nposy,nposz
          double precision, automatic :: normx,normy,normz,normt,jump
          integer, automatic           :: ix,iy,iz,inner,force
          double precision, automatic :: xp,xm,yp,ym,zp,zm
          double precision, automatic :: vxp(3),vxm(3),vyp(3),vym(3),vzp(3),vzm(3)
          double precision, automatic :: diverg,vsum(3),angle(3)
#ifndef _CUBIC_2PI_
          double precision, automatic :: factx,facty,factz,factor
#endif

          inner=1
          force=0

          nposx=posx
          nposy=posy
          nposz=posz

          normx=0.d0
          normy=0.d0
          normz=0.d0

          do ix=-1,0
              do iy=-1,1
                  do iz=-1,1
                      normx=max(dabs(subdvx(ix,iy,iz)),normx)
                  enddo
              enddo
          enddo

          do ix=-1,1
              do iy=-1,0
                  do iz=-1,1
                    normy=max(dabs(subdvy(ix,iy,iz)),normy)
                  enddo
              enddo
          enddo

          do ix=-1,1
              do iy=-1,1
                  do iz=-1,0
                      normz=max(dabs(subdvz(ix,iy,iz)),normz)
                  enddo
              enddo
          enddo

          normt=dsqrt( normx*normx +normy*normy +normz*normz)+1.d-20

          do while(inner.eq.1)

              if((abs(nposx).gt.0.5d0).or.(abs(nposy).gt.0.5d0).or. (abs(nposz).gt.0.5d0)) then
                  inner=0
                  endx=nposx
                  endy=nposy
                  endz=nposz
                  goto 54
              endif

#ifndef _CUBIC_2PI_
              if(nposx.ge.0.d0) then; factx=dxp; else; factx=dxm; endif
              if(nposy.ge.0.d0) then; facty=dyp; else; facty=dym; endif
              if(nposz.ge.0.d0) then; factz=dzp; else; factz=dzm; endif
              temp=0.d0
              temp=max(temp,factx)
              temp=max(temp,facty)
              temp=max(temp,factz)
              factx=factx/temp
              facty=facty/temp
              factz=factz/temp

              call findangle(nposx,nposy,nposz, switch, dxp,dxm,dyp,dym,dzp,dzm, subdvx,subdvy,subdvz, angle,totv)

              factor=min(factx,facty)
              factor=min(factor,factz)
              jump=factor*min(pace,totv/normt/4.d0)
              if(jump.lt.factor*jumpeps) then
                   xp=nposx+factor*pace/factx
                   xm=nposx-factor*pace/factx
                   yp=nposy+factor*pace/facty
                   ym=nposy-factor*pace/facty
                   zp=nposz+factor*pace/factz
                   zm=nposz-factor*pace/factz
                   call findangle(xp,nposy,nposz, switch, dxp,dxm,dyp,dym,dzp,dzm, subdvx,subdvy,subdvz, vxp,temp)
                   call findangle(xm,nposy,nposz, switch, dxp,dxm,dyp,dym,dzp,dzm, subdvx,subdvy,subdvz, vxm,temp)
                   call findangle(nposx,yp,nposz, switch, dxp,dxm,dyp,dym,dzp,dzm, subdvx,subdvy,subdvz, vyp,temp)
                   call findangle(nposx,ym,nposz, switch, dxp,dxm,dyp,dym,dzp,dzm, subdvx,subdvy,subdvz, vym,temp)
                   call findangle(nposx,nposy,zp, switch, dxp,dxm,dyp,dym,dzp,dzm, subdvx,subdvy,subdvz, vzp,temp)
                   call findangle(nposx,nposy,zm, switch, dxp,dxm,dyp,dym,dzp,dzm, subdvx,subdvy,subdvz, vzm,temp)
#else
              call findangle(nposx,nposy,nposz, switch, subdvx,subdvy,subdvz, angle,totv)

              jump=min(pace,totv/normt/4.d0)
              if(jump.lt.jumpeps) then
                   xp=nposx+pace
                   xm=nposx-pace
                   yp=nposy+pace
                   ym=nposy-pace
                   zp=nposz+pace
                   zm=nposz-pace
                   call findangle(xp,nposy,nposz, switch, subdvx,subdvy,subdvz, vxp,temp)
                   call findangle(xm,nposy,nposz, switch, subdvx,subdvy,subdvz, vxm,temp)
                   call findangle(nposx,yp,nposz, switch, subdvx,subdvy,subdvz, vyp,temp)
                   call findangle(nposx,ym,nposz, switch, subdvx,subdvy,subdvz, vym,temp)
                   call findangle(nposx,nposy,zp, switch, subdvx,subdvy,subdvz, vzp,temp)
                   call findangle(nposx,nposy,zm, switch, subdvx,subdvy,subdvz, vzm,temp)
#endif

               diverg=vxp(1)-vxm(1)+vyp(2)-vym(2)+vzp(3)-vzm(3)
               if(diverg.gt.divergMax) then
               call random_number(vsum(1))
               call random_number(vsum(2))
               call random_number(vsum(3))

                if(abs(angle(1)).ge.abs(angle(2)).and.abs(angle(1)).ge.abs(angle(3))) then
                    temp2=vsum(2)**2*angle(2)
                    temp3=vsum(3)**2*angle(3)
                    temp1=10*(temp2*angle(2)+temp3*angle(3))/(angle(1)+1.d-20)
                    temp=1.d-20+dsqrt(temp1**2+temp2**2+temp3**2)
#ifndef _CUBIC_2PI_
                    nposx=nposx-temp1/temp*factor*pace/factx
                    nposy=nposy+temp2/temp*factor*pace/facty
                    nposz=nposz+temp3/temp*factor*pace/factz
                    goto 55
#else
                    nposx=nposx-temp1/temp*pace
                    nposy=nposy+temp2/temp*pace
                    nposz=nposz+temp3/temp*pace
                    goto 55
#endif

                else if(abs(angle(2)).ge.abs(angle(1)).and.abs(angle(2)).ge.abs(angle(3))) then
                    temp1=vsum(1)**2*angle(1)
                    temp3=vsum(3)**2*angle(3)
                    temp2=10*(temp1*angle(1)+temp3*angle(3))/(angle(2)+1.d-20)
                    temp=1.d-20+dsqrt(temp1**2+temp2**2+temp3**2)
#ifndef _CUBIC_2PI_
                    nposx=nposx+temp1/temp*factor*pace/factx
                    nposy=nposy-temp2/temp*factor*pace/facty
                    nposz=nposz+temp3/temp*factor*pace/factz
                    goto 55
#else
                    nposx=nposx+temp1/temp*pace
                    nposy=nposy-temp2/temp*pace
                    nposz=nposz+temp3/temp*pace
                    goto 55
#endif

                else if(abs(angle(3)).ge.abs(angle(1)).and.abs(angle(3)).ge.abs(angle(2))) then
                    temp1=vsum(1)**2*angle(1)
                    temp2=vsum(2)**2*angle(2)
                    temp3=10*(temp1*angle(1)+temp2*angle(2))/(angle(3)+1.d-20)
                    temp=1.d-20+dsqrt(temp1**2+temp2**2+temp3**2)
#ifndef _CUBIC_2PI_
                    nposx=nposx+temp1/temp*factor*pace/factx
                    nposy=nposy+temp2/temp*factor*pace/facty
                    nposz=nposz-temp3/temp*factor*pace/factz
                    goto 55
#else
                    nposx=nposx+temp1/temp*pace
                    nposy=nposy+temp2/temp*pace
                    nposz=nposz-temp3/temp*pace
                    goto 55
#endif

                endif
               endif

               endfind=1
               inner=0
               endx=nposx
               endy=nposy
               endz=nposz
               goto 54

              else
#ifndef _CUBIC_2PI_
               nposx=nposx+angle(1)*jump/factx
               nposy=nposy+angle(2)*jump/facty
               nposz=nposz+angle(3)*jump/factz
#else
               nposx=nposx+angle(1)*jump
               nposy=nposy+angle(2)*jump
               nposz=nposz+angle(3)*jump
#endif
              endif

55            force=force+1
              if(force.gt.10000) then
                  !write(*,*) 'this is a forced ending'
                  jumps=jumps+1
                  endfind=1
                  inner=0
                  endx=nposx
                  endy=nposy
                  endz=nposz
                  goto 54
              endif
          enddo

54        continue
          vecn(1) = angle(1) *switch
          vecn(2) = angle(2) *switch
          vecn(3) = angle(3) *switch
          return

      end subroutine endpoint

!
!     --------------------------------------------------------
!
!     subroutine findangle(nposx,nposy,nposz,switch,
!                          subdvx,subdvy,subdvz,angl,totv)
!
!     --------------------------------------------------------
!
      subroutine findangle( nposx, nposy, nposz, switch,    &
#ifndef _CUBIC_2PI_
                            dxp,dxm, dyp,dym, dzp,dzm,      &
#endif
                            subdvx,subdvy,subdvz, angl, totv)

!         function arguments
          double precision,    intent(in)    :: nposx,nposy,nposz,switch
#ifndef _CUBIC_2PI_
          double precision,    intent(in)    :: dxp,dxm, dyp,dym, dzp,dzm
#endif
          double precision,    intent(in)    :: subdvx(-1:0,-1:1,-1:1),subdvy(-1:1,-1:0,-1:1), subdvz(-1:1,-1:1,-1:0)
          double precision,    intent(out)   :: angl(3)
          double precision,    intent(out)   :: totv

!         variables
          double precision, automatic :: sx,sy,sz
          integer, automatic           :: ix,iy,iz
#ifndef _CUBIC_2PI_
          double precision, automatic :: factxp,factxm, factyp,factym, factzp,factzm
#endif

          ix=-1
          iy=0
          iz=0
#ifndef _CUBIC_2PI_
          sx=nposx
#else
          sx=nposx+0.5d0
#endif
          sy=nposy
          sz=nposz

          if(nposy.lt.0.d0) then
           sy=1.d0+nposy
           iy=-1
          endif

          if(nposz.lt.0.d0) then
           sz=1.d0+nposz
           iz=-1
          endif

#ifndef _CUBIC_2PI_
          if(nposx.lt.0.d0) then
            factxp= (nposx+0.5) *dxm     /(0.5*dxp+0.5*dxm)
            factxm= (0.5*dxp -nposx *dxm)/(0.5*dxp+0.5*dxm)
          else
            factxp= (0.5*dxm +nposx *dxp)/(0.5*dxp+0.5*dxm)
            factxm= (0.5-nposx)*dxp      /(0.5*dxp+0.5*dxm)
          endif
          angl(1)=  factxm *(1.d0-sy) *(1.d0-sz) *subdvx(ix,iy,iz)			&
                   +factxp *(1.d0-sy) *(1.d0-sz) *subdvx(ix+1,iy,iz)		&
                   +factxm *sy        *(1.d0-sz) *subdvx(ix,iy+1,iz)		&
                   +factxm *(1.d0-sy) *sz        *subdvx(ix,iy,iz+1)		&
                   +factxm *sy        *sz        *subdvx(ix,iy+1,iz+1)		&
                   +factxp *(1.d0-sy) *sz        *subdvx(ix+1,iy,iz+1)		&
                   +factxp *sy        *(1.d0-sz) *subdvx(ix+1,iy+1,iz)		&
                   +factxp *sy        *sz        *subdvx(ix+1,iy+1,iz+1)
#else
          angl(1)=    (1.d0-sx) *(1.d0-sy) *(1.d0-sz) *subdvx(ix,iy,iz)        &
                     +sx        *(1.d0-sy) *(1.d0-sz) *subdvx(ix+1,iy,iz)      &
                     +(1.d0-sx) *sy        *(1.d0-sz) *subdvx(ix,iy+1,iz)      &
                     +(1.d0-sx) *(1.d0-sy) *sz        *subdvx(ix,iy,iz+1)      &
                     +(1.d0-sx) *sy        *sz        *subdvx(ix,iy+1,iz+1)    &
                     +sx        *(1.d0-sy) *sz        *subdvx(ix+1,iy,iz+1)    &
                     +sx        *sy        *(1.d0-sz) *subdvx(ix+1,iy+1,iz)    &
                     +sx        *sy        *sz        *subdvx(ix+1,iy+1,iz+1)
#endif

          angl(1)=angl(1)*switch

          ix=0
          iy=-1
          iz=0
          sx=nposx
#ifndef _CUBIC_2PI_
          sy=nposy
#else
          sy=nposy+0.5d0
#endif
          sz=nposz

          if(nposx.lt.0.d0) then
           sx=1.d0+nposx
           ix=-1
          endif

          if(nposz.lt.0.d0) then
           sz=1.d0+nposz
           iz=-1
          endif

#ifndef _CUBIC_2PI_
          if(nposy.lt.0.d0) then
            factyp= (nposy+0.5)   *dym  /(0.5*dyp+0.5*dym)
            factym= (0.5*dyp-nposy*dym) /(0.5*dyp+0.5*dym)
          else
            factyp= (0.5*dym+nposy*dyp) /(0.5*dyp+0.5*dym)
            factym= (0.5-nposy)   *dyp  /(0.5*dyp+0.5*dym)
          endif
          angl(2)= (1.d0-sx) *factym *(1.d0-sz) *subdvy(ix,iy,iz)			&
                  + sx       *factym *(1.d0-sz) *subdvy(ix+1,iy,iz)			&
                  +(1.d0-sx) *factyp *(1.d0-sz) *subdvy(ix,iy+1,iz)			&
                  +(1.d0-sx) *factym *sz        *subdvy(ix,iy,iz+1)			&
                  +(1.d0-sx) *factyp *sz        *subdvy(ix,iy+1,iz+1)		&
                  + sx       *factym *sz        *subdvy(ix+1,iy,iz+1)		&
                  + sx       *factyp *(1.d0-sz) *subdvy(ix+1,iy+1,iz)		&
                  + sx       *factyp *sz        *subdvy(ix+1,iy+1,iz+1)
#else
          angl(2)=     (1.d0-sx) *(1.d0-sy) *(1.d0-sz) *subdvy(ix,iy,iz)        &
                      +sx        *(1.d0-sy) *(1.d0-sz) *subdvy(ix+1,iy,iz)      &
                      +(1.d0-sx) *sy        *(1.d0-sz) *subdvy(ix,iy+1,iz)      &
                      +(1.d0-sx) *(1.d0-sy) *sz        *subdvy(ix,iy,iz+1)      &
                      +(1.d0-sx) *sy        *sz        *subdvy(ix,iy+1,iz+1)    &
                      +sx        *(1.d0-sy) *sz        *subdvy(ix+1,iy,iz+1)    &
                      +sx        *sy        *(1.d0-sz) *subdvy(ix+1,iy+1,iz)    &
                      +sx        *sy        *sz        *subdvy(ix+1,iy+1,iz+1)
#endif

          angl(2)=angl(2)*switch

          ix=0
          iy=0
          iz=-1
          sx=nposx
          sy=nposy
#ifndef _CUBIC_2PI_
          sz=nposz
#else
          sz=nposz+0.5d0
#endif

          if(nposx.lt.0.d0) then
           sx=1.d0+nposx
           ix=-1
          endif

          if(nposy.lt.0.d0) then
           sy=1.d0+nposy
           iy=-1
          endif

#ifndef _CUBIC_2PI_
      if(nposz.lt.0.d0) then
       factzp= (nposz+0.5)   *dzm  /(0.5*dzp+0.5*dzm)
       factzm= (0.5*dzp-nposz*dzm) /(0.5*dzp+0.5*dzm)
      else
       factzp= (0.5*dzm+nposz*dzp) /(0.5*dzp+0.5*dzm)
       factzm= (0.5-nposz)   *dzp  /(0.5*dzp+0.5*dzm)
      endif
      angl(3)= (1.d0-sx) *(1.d0-sy) *factzm *subdvz(ix,iy,iz)		&
              + sx       *(1.d0-sy) *factzm *subdvz(ix+1,iy,iz)		&
              +(1.d0-sx) *sy        *factzm *subdvz(ix,iy+1,iz)		&
              +(1.d0-sx) *(1.d0-sy) *factzp *subdvz(ix,iy,iz+1)		&
              +(1.d0-sx) *sy        *factzp *subdvz(ix,iy+1,iz+1)	&
              + sx       *(1.d0-sy) *factzp *subdvz(ix+1,iy,iz+1)	&
              + sx       *sy        *factzm *subdvz(ix+1,iy+1,iz)	&
              + sx       *sy        *factzp *subdvz(ix+1,iy+1,iz+1)
#else
          angl(3)=     (1.d0-sx) *(1.d0-sy) *(1.d0-sz) *subdvz(ix,iy,iz)        &
                      +sx        *(1.d0-sy) *(1.d0-sz) *subdvz(ix+1,iy,iz)      &
                      +(1.d0-sx) *sy        *(1.d0-sz) *subdvz(ix,iy+1,iz)      &
                      +(1.d0-sx) *(1.d0-sy) *sz        *subdvz(ix,iy,iz+1)      &
                      +(1.d0-sx) *sy        *sz        *subdvz(ix,iy+1,iz+1)    &
                      +sx        *(1.d0-sy) *sz        *subdvz(ix+1,iy,iz+1)    &
                      +sx        *sy        *(1.d0-sz) *subdvz(ix+1,iy+1,iz)    &
                      +sx        *sy        *sz        *subdvz(ix+1,iy+1,iz+1)
#endif

          angl(3)=angl(3)*switch

          totv=1.d-20+dsqrt(angl(1)**2+angl(2)**2+angl(3)**2)
          angl(1)=angl(1)/totv
          angl(2)=angl(2)/totv
          angl(3)=angl(3)/totv

          return
      end subroutine findangle

!
!     --------------------------------------------------------
!
!     subroutine tellnew(ni,nj,nk,endx,endy,endz,posx,posy,posz)
!
!     Check if the current staggerd grid cell is left (endxyz>0.5 or endxyz<-0.5)
!     and set nijk to new grid point
!
!     --------------------------------------------------------
!
      subroutine tellnew(ni,  nj,  nk,    &
                         endx,endy,endz,    &
                         posx,posy,posz )

!         function arguments
          integer,             intent(inout)    :: ni,nj,nk
          double precision,    intent(in)       :: endx,endy,endz
          double precision,    intent(inout)    :: posx,posy,posz

          if(abs(endx).le.0.5.and.    &
             abs(endy).le.0.5.and.    &
             abs(endz).le.0.5) then
              ni=ni
              nj=nj
              nk=nk
              posx=endx
              posy=endy
              posz=endz
          else if(     endx.gt.0.5.and.    &
                  abs(endy).le.0.5.and.    &
                  abs(endz).le.0.5 ) then
              ni=ni+1
              nj=nj
              nk=nk
              posx=endx-1.d0
              posy=endy
              posz=endz
          else if(     (endx.lt.-0.5).and.    &
                  (abs(endy).le.0.5) .and.    &
                  (abs(endz).le.0.5) ) then
              ni=ni-1
              nj=nj
              nk=nk
              posx=endx+1.d0
              posy=endy
              posz=endz
          else if((abs(endx).le.0.5).and.    &
                       (endy.gt.0.5).and.    &
                  (abs(endz).le.0.5) ) then
              ni=ni
              nj=nj+1
              nk=nk
              posx=endx
              posy=endy-1.d0
              posz=endz
          else if((abs(endx).le.0.5).and.    &
                       (endy.lt.-0.5).and.    &
                  (abs(endz).le.0.5) ) then
              ni=ni
              nj=nj-1
              nk=nk
              posx=endx
              posy=endy+1.d0
              posz=endz
          else if(     (endx.gt.0.5).and.    &
                       (endy.gt.0.5).and.    &
                  (abs(endz).le.0.5) ) then
              ni=ni+1
              nj=nj+1
              nk=nk
              posx=endx-1.d0
              posy=endy-1.d0
              posz=endz
          else if(     (endx.lt.-0.5).and.    &
                       (endy.gt.0.5 ).and.    &
                  (abs(endz).le.0.5) ) then
              ni=ni-1
              nj=nj+1
              nk=nk
              posx=endx+1.d0
              posy=endy-1.d0
              posz=endz
          else if(      (endx.lt.-0.5).and.    &
                        (endy.lt.-0.5).and.    &
                   (abs(endz).le.0.5) ) then
              ni=ni-1
              nj=nj-1
              nk=nk
              posx=endx+1.d0
              posy=endy+1.d0
              posz=endz
          else if(     (endx.gt.0.5 ).and.    &
                       (endy.lt.-0.5).and.    &
                  (abs(endz).le.0.5) ) then
              ni=ni+1
              nj=nj-1
              nk=nk
              posx=endx-1.d0
              posy=endy+1.d0
              posz=endz
          else if((abs(endx).le.0.5).and.    &
                  (abs(endy).le.0.5).and.    &
                      (endz.gt.0.5)) then
              ni=ni
              nj=nj
              nk=nk+1
              posx=endx
              posy=endy
              posz=endz-1.d0
          else if(     (endx.gt.0.5).and.    &
                  (abs(endy).le.0.5).and.    &
                       (endz.gt.0.5)) then
              ni=ni+1
              nj=nj
              nk=nk+1
              posx=endx-1.d0
              posy=endy
              posz=endz-1.d0
          else if(     (endx.lt.-0.5).and.    &
                  (abs(endy).le.0.5).and.    &
                       (endz.gt.0.5)) then
              ni=ni-1
              nj=nj
              nk=nk+1
              posx=endx+1.d0
              posy=endy
              posz=endz-1.d0
          else if((abs(endx).le.0.5).and.    &
                       (endy.gt.0.5).and.    &
                       (endz.gt.0.5) ) then
              ni=ni
              nj=nj+1
              nk=nk+1
              posx=endx
              posy=endy-1.d0
              posz=endz-1.d0
          else if((abs(endx).le.0.5).and.    &
                       (endy.lt.-0.5).and.    &
                       (endz.gt.0.5)) then
              ni=ni
              nj=nj-1
              nk=nk+1
              posx=endx
              posy=endy+1.d0
              posz=endz-1.d0
          else if((endx.gt.0.5).and.    &
                  (endy.gt.0.5).and.    &
                  (endz.gt.0.5)) then
              ni=ni+1
              nj=nj+1
              nk=nk+1
              posx=endx-1.d0
              posy=endy-1.d0
              posz=endz-1.d0
          else if((endx.lt.-0.5).and.    &
                  (endy.gt.0.5).and.    &
                  (endz.gt.0.5) ) then
              ni=ni-1
              nj=nj+1
              nk=nk+1
              posx=endx+1.d0
              posy=endy-1.d0
              posz=endz-1.d0
          else if((endx.lt.-0.5).and.    &
                  (endy.lt.-0.5).and.    &
                  (endz.gt.0.5) ) then
              ni=ni-1
              nj=nj-1
              nk=nk+1
              posx=endx+1.d0
              posy=endy+1.d0
              posz=endz-1.d0
          else if((endx.gt.0.5).and.    &
                  (endy.lt.-0.5).and.    &
                  (endz.gt.0.5)) then
              ni=ni+1
              nj=nj-1
              nk=nk+1
              posx=endx-1.d0
              posy=endy+1.d0
              posz=endz-1.d0
          else if((abs(endx).le.0.5).and.    &
                  (abs(endy).le.0.5).and.    &
                       (endz.lt.-0.5)) then
              ni=ni
              nj=nj
              nk=nk-1
              posx=endx
              posy=endy
              posz=endz+1.d0
          else if(     (endx.gt.0.5).and.    &
                  (abs(endy).le.0.5).and.    &
                       (endz.lt.-0.5)) then
              ni=ni+1
              nj=nj
              nk=nk-1
              posx=endx-1.d0
              posy=endy
              posz=endz+1.d0
          else if(      (endx.lt.-0.5).and.    &
                   (abs(endy).le.0.5).and.    &
                        (endz.lt.-0.5)) then
              ni=ni-1
              nj=nj
              nk=nk-1
              posx=endx+1.d0
              posy=endy
              posz=endz+1.d0
          else if( (abs(endx).le.0.5).and.    &
                        (endy.gt.0.5).and.    &
                        (endz.lt.-0.5)) then
              ni=ni
              nj=nj+1
              nk=nk-1
              posx=endx
              posy=endy-1.d0
              posz=endz+1.d0
          else if((abs(endx).le.0.5).and.    &
                       (endy.lt.-0.5).and.    &
                       (endz.lt.-0.5)) then
              ni=ni
              nj=nj-1
              nk=nk-1
              posx=endx
              posy=endy+1.d0
              posz=endz+1.d0
          else if((endx.gt.0.5).and.    &
                  (endy.gt.0.5).and.    &
                  (endz.lt.-0.5)) then
              ni=ni+1
              nj=nj+1
              nk=nk-1
              posx=endx-1.d0
              posy=endy-1.d0
              posz=endz+1.d0
          else if((endx.lt.-0.5).and.    &
                  (endy.gt.0.5).and.    &
                  (endz.lt.-0.5)) then
              ni=ni-1
              nj=nj+1
              nk=nk-1
              posx=endx+1.d0
              posy=endy-1.d0
              posz=endz+1.d0
          else if((endx.lt.-0.5).and.    &
                  (endy.lt.-0.5).and.    &
                  (endz.lt.-0.5)) then
              ni=ni-1
              nj=nj-1
              nk=nk-1
              posx=endx+1.d0
              posy=endy+1.d0
              posz=endz+1.d0
          else if((endx.gt.0.5).and.    &
                  (endy.lt.-0.5).and.    &
                  (endz.lt.-0.5)) then
              ni=ni+1
              nj=nj-1
              nk=nk-1
              posx=endx-1.d0
              posy=endy+1.d0
              posz=endz+1.d0
          endif

          return
      end subroutine tellnew

end module mod_traj
