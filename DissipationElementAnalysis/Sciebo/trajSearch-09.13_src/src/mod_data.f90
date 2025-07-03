!
! Copyright (C) 2005-2010 by  Institute of Combustion Technology - RWTH Aachen University
! Jens Henrik Goebbert, goebbert@itv.rwth-aachen.de (2007-2010)
! All rights reserved.
!

#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
#include "mod_psmb.h"
#endif

module mod_data

    implicit none
    save

!   command arguments
    character(len=255)	:: file_path, input_dataset_path, traj_group_path
    integer :: phase

!	settings from grid file
    integer :: ndims(3), origdims(3)
    integer :: spacedim
    double precision :: Lx=0.d0 , Ly=0.d0, Lz=0.d0

    logical :: do_numberfind=.true.

#if (_TRAJCOUNT_>0)
    logical :: do_trajcount=.true.
#else
    logical :: do_trajcount=.false.
#endif
#if (_TRAJCOUNT_==3)
    integer :: trajcount_size3; parameter(trajcount_size3 = 1000)
#endif

!	settings from settings file
    integer, dimension(3,2) :: subdomain

    integer :: bsize(3) =(/8,8,8/)
    integer :: nblocks(3), nblocks_all, nblocks_sub
    integer, dimension(:,:), allocatable :: bstart, bend
    integer, dimension(:,:), allocatable :: bstart_sub, bend_sub

    integer, dimension(:,:,:), allocatable :: t_bgrid

!	input data fields
    double precision, dimension(:,:,:), pointer      :: psi ! 256^3=>128MByte 512^3=>1GByte 1024^3=>8GByte
    double precision, dimension(:),     allocatable :: coordx,coordy,coordz
    logical :: coordz_switch = .false.

    double precision, dimension(:), pointer      :: psi_cached

    integer :: novars = 0, tattrs = 0
    character(len=255), dimension(:), allocatable :: vars_dataset_paths
    double precision, dimension(:), allocatable   :: vars_max, vars_min
    double precision, dimension(:,:,:,:), pointer :: vars

    double precision,  dimension(:,:),    allocatable :: readin_points       ! (pointNo,xyz)

!	working data fields (mod_Traj)
    integer,           dimension(:,:,:),allocatable :: identity   ! 256^3=>128MByte 512^3=>1GByte 1024^3=>8GByte
    double precision, dimension(:,:,:,:),allocatable :: counter   ! 256^3=>512MByte 512^3=>4GByte 1024^3=>32GByte

!	output data fields (mod_Traj)
    integer :: numends
    integer :: max_numends; parameter(max_numends = 25000000)
    logical          , dimension(:),      allocatable  :: signs        ! (+:true, -:false) minumum,maximum
    double precision,  dimension(:,:),    allocatable :: points       ! (pointNo,xyz) (grid-coordinates - no coordxyz used!)
    integer,           dimension(:,:,:,:),allocatable  :: numbering    ! (i,j,k,max(1)/min(2)-pointNo)
    integer,           dimension(:,:,:),allocatable    :: trajcount     ! 256^3=>128MByte 512^3=>1GByte 1024^3=>8GByte

!	data fields for page sized memory blocks
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
    double precision, dimension(:,:,:,:,:,:), pointer   :: psi_b
    integer,          dimension(:,:,:,:,:,:,:), pointer :: numbering_b
    integer,          dimension(:,:,:,:,:,:), pointer :: trajcount_b
    double precision, dimension(:,:,:,:,:,:,:), pointer :: vars_b
#endif

!     output data fields (mod_postp)
    integer :: numpairs
    integer, dimension(:,:),   allocatable	:: pairing	! pairing(elementId, minumumId/maximumId/number of gridpoints) => 1.14MByte
    integer, dimension(:,:,:), allocatable	:: note 	! the elementId a trajectory from ijk belongs to
    integer, dimension(:,:,:), allocatable	:: pairdomain ! stores the subdomain of each element(pair)

!   output data fields
    double precision, dimension(:,:,:), allocatable :: graddiv ! divergence of gradient field
    integer :: dumpGradDiv = 0

!	diss-ele-arrays
    integer :: trajPtsMin, trajPtsMax
    integer :: saveTraj = 0, analyTraj = 0, dumpTraj = 0
    integer :: dumpTraj_minlen = 1, dumpTraj_ptstride = 1, dumpTraj_pktsize= 1000
    integer :: dEleNoTraj, dEleTrajError=0
    integer :: dEleTrajVars_offset=9 ! details see mod_traj.f90:calcTrajPtValues()
    double precision, dimension(:,:,:), allocatable :: dEleTraj
    integer,          dimension(:),      allocatable :: dEleTrajSize
    double precision, dimension(:,:),   allocatable :: dEleMinMax

!     read pdf settings
    integer :: pdfSets_save=1

!    constants
    double precision :: pi, pi2
    !parameter(pi =3.1415926535897932)        ! pi = 4.*atan(1.)
    !parameter(pi2=6.2831853071795862)        ! 2pi= 2*4.*atan(1.)

    contains

!
!     ------------
!
!     init globals
!
!     ------------
!
    subroutine init_globals()
        implicit none

        pi2= 8.d0 *atan(1.d0)
        pi = 4.d0 *atan(1.d0)

        trajPtsMin = 2000
        trajPtsMax = 2000

    end subroutine init_globals
!
!     ------------
!
!     allocate global arrays
!
!     ------------
!
    subroutine allocate_globals(array_name,alloc_err)
        use omp_lib
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
    	use mod_psmb
#endif
        implicit none

        ! function vars
        character(len=*), intent(in)	:: array_name
        integer, intent(out) :: alloc_err

        ! other vars
        integer(kind=8) :: bytesize
        integer :: intsize; parameter(intsize = 4)
        integer :: dblesize;parameter(dblesize= 8)

        alloc_err= 0
        bytesize = 0

        if(trim(array_name) .eq. 'psi') then
            if(.not. associated(psi)) then
                allocate(psi(ndims(1),ndims(2),ndims(3)),STAT=alloc_err)
                bytesize = dble(ndims(1) *ndims(2)) *ndims(3) *dblesize
            endif

        else if(trim(array_name) .eq. 'signs') then
            if(.not. allocated(signs) ) then
                allocate(signs(max_numends),STAT=alloc_err)    ! 4 MByte
                bytesize = dble(max_numends) *intsize
            endif

        else if(trim(array_name) .eq. 'points') then
            if(.not. allocated(points) ) then
                allocate(points(max_numends,3),STAT=alloc_err)    ! 22MByte
                bytesize = dble(max_numends *3) *dblesize
            endif

        else if(trim(array_name) .eq. 'readin_points') then
            if(.not. allocated(readin_points) ) then
                allocate(readin_points(max_numends,3),STAT=alloc_err)    ! 22MByte
                bytesize = dble(max_numends *3) *dblesize
            endif

        else if(trim(array_name) .eq. 'numbering') then
            if(.not. allocated(numbering) ) then
                allocate(numbering(ndims(1),ndims(2),ndims(3),2),STAT=alloc_err)    ! 256^3=>128MByte 512^3=>1GByte 1024^3=>8GByte
                bytesize = dble(ndims(1) *ndims(2)) *ndims(3) *2 *intsize
            endif

        else if(trim(array_name) .eq. 'counter') then
            if(.not. allocated(counter) ) then
                allocate(counter(0:ndims(1)+1,0:ndims(2)+1,0:ndims(3)+1,4),STAT=alloc_err)  ! 256^3=>512MByte 512^3=>4GByte 1024^3=>32GByte
                bytesize = dble( (ndims(1)+2) *(ndims(2)+2) ) *(ndims(3)+2) *4 *dblesize
            endif

        else if(trim(array_name) .eq. 'identity') then
            if(.not. allocated(identity) ) then
                allocate(identity(0:ndims(1)+1,0:ndims(2)+1,0:ndims(3)+1),STAT=alloc_err)  ! 256^3=>64MByte 512^3=>512GByte 1024^3=>4GByte
                bytesize = dble( (ndims(1)+2) *(ndims(2)+2) ) *(ndims(3)+2) *intsize
            endif

        else if(trim(array_name) .eq. 'pairing') then
            if(.not. allocated(pairing)) then
                allocate(pairing(max_numends,3),STAT=alloc_err)	! => 115 MByte
                bytesize = dble(max_numends) *3 *intsize
            endif

        else if(trim(array_name) .eq. 'note') then
            if(.not. allocated(note)) then
                allocate(note(ndims(1),ndims(2),ndims(3)),STAT=alloc_err)	! note(i,j,k) 128^3=> 8MByte; 256^3 => 64MByte; 512^3 => 512MByte
                bytesize = dble(ndims(1) *ndims(2)) *ndims(3) *intsize
            endif

        else if(trim(array_name) .eq. 'pairdomain') then
            if(.not. allocated(pairdomain)) then
                allocate(pairdomain(max_numends,2,3),STAT=alloc_err)	! pairdomain(elementId,min/max,xyz)  => 230 MByte
                bytesize = dble(max_numends) *2 *3 *intsize
            endif

        else if(trim(array_name) .eq. 'trajcount') then
            if(.not. allocated(trajcount) ) then
                allocate(trajcount(ndims(1),ndims(2),ndims(3)),STAT=alloc_err) ! 256^3=>64MByte 512^3=>512MByte 1024^3=>4GByte
                bytesize = dble(ndims(1) *ndims(2)) *ndims(3) *intsize
            endif

        else if(trim(array_name) .eq. 'graddiv') then
            if(.not. allocated(graddiv) ) then
                allocate(graddiv(ndims(1),ndims(2),ndims(3)),STAT=alloc_err) ! 256^3=>64MByte 512^3=>512MByte 1024^3=>4GByte
                bytesize = dble(ndims(1) *ndims(2)) *ndims(3) *intsize
            endif

#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
        else if(trim(array_name) .eq. 'psi_b') then
            if(.not. associated(psi_b) ) then
                psmb_alloc_3d(psi_b,ndims(1),ndims(2),ndims(3),8_8)
                bytesize = dble( (ndims(1)+8) *(ndims(2)+8)) *(ndims(3)+8) *dblesize
        endif

        else if(trim(array_name) .eq. 'trajcount_b') then
            if(.not. associated(trajcount_b) ) then
                psmb_alloc_3d(trajcount_b,ndims(1),ndims(2),ndims(3),4_8)
                bytesize = dble( (ndims(1)+8) *(ndims(2)+8)) *(ndims(3)+8) *intsize
        endif

        else if(trim(array_name) .eq. 'numbering_b') then
            if(.not. associated(numbering_b) ) then
                psmb_alloc_4d(numbering_b,ndims(1),ndims(2),ndims(3),2,4_8)
                bytesize = dble( (ndims(1)+8) *(ndims(2)+8)) *(ndims(3)+8) *intsize
        endif
#endif

        else
            write(*,*) '----->>>> MEMORY ERROR <<<<<-----'
            write(*,*) 'Unkown array "',trim(array_name),'".'
            stop
        endif

        if(alloc_err .ne. 0) then
            write(*,*) '----->>>> MEMORY ERROR <<<<<-----'
            write(*,*) 'Error allocating ',bytesize/1024.0/1024.0,' [mbyte] memory for array "',trim(array_name),'".'
            stop
        else
            write(*,*) 'Allocating ',bytesize/1024.0/1024.0,' [mbyte] memory for array "',trim(array_name),'".'
        endif

    end subroutine allocate_globals

!
!     ------------
!
!     deallocate global arrays
!
!     ------------
!
    subroutine deallocate_globals(array_name)
        use omp_lib
        implicit none

        ! function vars
        character(len=*), intent(in)	:: array_name

        if(trim(array_name) .eq. 'signs') then
            if(allocated(signs) ) deallocate(signs)    ! 4 MByte

        else if(trim(array_name) .eq. 'points') then
            if(allocated(points) ) deallocate(points)    ! 22MByte

        else if(trim(array_name) .eq. 'readin_points') then
            if(allocated(readin_points) ) deallocate(readin_points)    ! 22MByte

        else if(trim(array_name) .eq. 'numbering') then
            if(allocated(numbering) ) deallocate(numbering)    ! 256^3=>128MByte 512^3=>1GByte 1024^3=>8GByte

        else if(trim(array_name) .eq. 'counter') then
            if(allocated(counter) ) deallocate(counter)  ! 256^3=>512MByte 512^3=>4GByte 1024^3=>32GByte

        else if(trim(array_name) .eq. 'identity') then
            if(allocated(identity) ) deallocate(identity)  ! 256^3=>128MByte 512^3=>1GByte 1024^3=>8GByte

        else if(trim(array_name) .eq. 'pairing') then
            if(allocated(pairing)) deallocate(pairing)	! => 115 MByte

        else if(trim(array_name) .eq. 'note') then
            if(allocated(note)) deallocate(note)	! note(i,j,k) 128^3=> 8MByte; 256^3 => 64MByte; 512^3 => 512MByte

        else if(trim(array_name) .eq. 'pairdomain') then
            if(allocated(pairdomain)) deallocate(pairdomain)	! pairdomain(elementId,min/max,xyz)  => 230 MByte

        else if(trim(array_name) .eq. 'trajcount') then
            if(allocated(trajcount) ) deallocate(trajcount) ! 256^3=>64MByte 512^3=>512MByte 1024^3=>4GByte

        else
            write(*,*) '----->>>> MEMORY ERROR <<<<<-----'
            write(*,*) 'Unkown array "',trim(array_name),'".'
            stop
        endif

    end subroutine deallocate_globals

!
!     ------------
!
!     calculate memory block structure
!
!     ------------
    subroutine calc_memoryblocks(error)
        implicit none

        ! function vars
        integer,intent(out)			:: error

        ! block memory structure
        integer :: i,j,k, b, bb, bi, bj, bk
        integer, dimension(:,:), allocatable :: bstart_tmp, bend_tmp
        integer, dimension(3,2) :: testdomain

        error = 0

            ! set memory block structure
            nblocks(1) = ndims(1)/bsize(1)
            nblocks(2) = ndims(2)/bsize(2)
            nblocks(3) = ndims(3)/bsize(3)
            if (mod(ndims(1),bsize(1)) .gt. 0) nblocks(1) = nblocks(1) + 1
            if (mod(ndims(2),bsize(2)) .gt. 0) nblocks(2) = nblocks(2) + 1
            if (mod(ndims(3),bsize(3)) .gt. 0) nblocks(3) = nblocks(3) + 1

            nblocks_all = nblocks(1)*nblocks(2)*nblocks(3)
            allocate(bstart_tmp(nblocks_all, 3), stat=error); if(error.ne.0) goto 20
            	bstart_tmp = 0
            allocate(bend_tmp(nblocks_all, 3), stat=error); if(error.ne.0) goto 20
            	bend_tmp = 0
            b= 1
            do bk=1, nblocks(3)
              do bj=1, nblocks(2)
                do bi=1, nblocks(1)
                  bstart_tmp(b,1) = (bi-1)*bsize(1)+1
                  bstart_tmp(b,2) = (bj-1)*bsize(2)+1
                  bstart_tmp(b,3) = (bk-1)*bsize(3)+1
                  bend_tmp(b,1) = bi*bsize(1)
                  if(bi .eq. nblocks(1)) bend_tmp(b,1) = ndims(1)
                  bend_tmp(b,2) = bj*bsize(2)
                  if(bj .eq. nblocks(2)) bend_tmp(b,2) = ndims(2)
                  bend_tmp(b,3) = bk*bsize(3)
                  if(bk .eq. nblocks(3)) bend_tmp(b,3) = ndims(3)
                  b = b +1
                enddo
              enddo
            enddo

            ! resort memory block structure to have blocks of subdomain at the beginning
            bb = 0
            allocate(bstart(nblocks_all, 3), stat=error); if(error.ne.0) goto 20
            	bstart = 0
            allocate(bend(nblocks_all, 3), stat=error); if(error.ne.0) goto 20
            	bend = 0
            nblocks_sub = 0
            allocate(bstart_sub(nblocks_all, 3), stat=error); if(error.ne.0) goto 20
            	bstart_sub = 0
            allocate(bend_sub(nblocks_all, 3), stat=error); if(error.ne.0) goto 20
            	bend_sub = 0
            do b = 1, nblocks_all ! add blocks of subdomains
              if( (bstart_tmp(b,1) .le. subdomain(1,1) .and. bend_tmp(b,1) .ge. subdomain(1,1) .or.	&
                   bstart_tmp(b,1) .le. subdomain(1,2) .and. bend_tmp(b,1) .ge. subdomain(1,2) .or.	&
                   bstart_tmp(b,1) .ge. subdomain(1,1) .and. bend_tmp(b,1) .le. subdomain(1,2) ) .and.	&
                  (bstart_tmp(b,2) .le. subdomain(2,1) .and. bend_tmp(b,2) .ge. subdomain(2,1) .or.	&
                   bstart_tmp(b,2) .le. subdomain(2,2) .and. bend_tmp(b,2) .ge. subdomain(2,2) .or.	&
                   bstart_tmp(b,2) .ge. subdomain(2,1) .and. bend_tmp(b,2) .le. subdomain(2,2) ) .and.	&
                  (bstart_tmp(b,3) .le. subdomain(3,1) .and. bend_tmp(b,3) .ge. subdomain(3,1) .or.	&
                   bstart_tmp(b,3) .le. subdomain(3,2) .and. bend_tmp(b,3) .ge. subdomain(3,2) .or.	&
                   bstart_tmp(b,3) .ge. subdomain(3,1) .and. bend_tmp(b,3) .le. subdomain(3,2) ) ) then
                 bb = bb+1
                 bstart(bb,1) = bstart_tmp(b,1);	bstart_tmp(b,1) = 0
                 bstart(bb,2) = bstart_tmp(b,2);	bstart_tmp(b,2) = 0
                 bstart(bb,3) = bstart_tmp(b,3);	bstart_tmp(b,3) = 0
                 bend(bb,1) = bend_tmp(b,1);		bend_tmp(b,1) = 0
                 bend(bb,2) = bend_tmp(b,2);		bend_tmp(b,2) = 0
                 bend(bb,3) = bend_tmp(b,3);		bend_tmp(b,3) = 0
                 nblocks_sub = bb

                 ! store subdomain-corrected blocksize
                 bstart_sub(bb,1) = bstart(bb,1)
                 bstart_sub(bb,2) = bstart(bb,2)
                 bstart_sub(bb,3) = bstart(bb,3)
                 bend_sub(bb,1) = bend(bb,1)
                 bend_sub(bb,2) = bend(bb,2)
                 bend_sub(bb,3) = bend(bb,3)
                 if( bstart(bb,1) .le. subdomain(1,1) ) bstart_sub(bb,1) = subdomain(1,1)+1
                 if( bstart(bb,2) .le. subdomain(2,1) ) bstart_sub(bb,2) = subdomain(2,1)+1
                 if( bstart(bb,3) .le. subdomain(3,1) ) bstart_sub(bb,3) = subdomain(3,1)+1
                 if( bend(bb,1) .ge. subdomain(1,2) ) bend_sub(bb,1) = subdomain(1,2)-1
                 if( bend(bb,2) .ge. subdomain(2,2) ) bend_sub(bb,2) = subdomain(2,2)-1
                 if( bend(bb,3) .ge. subdomain(3,2) ) bend_sub(bb,3) = subdomain(3,2)-1
              endif
            enddo
            do b = 1, nblocks_all ! add blocks not part of subdomain
              if(bstart_tmp(b,1) .ne. 0) then
                 bb = bb+1
                 bstart(bb,1) = bstart_tmp(b,1);	bstart_tmp(b,1) = 0
                 bstart(bb,2) = bstart_tmp(b,2);	bstart_tmp(b,2) = 0
                 bstart(bb,3) = bstart_tmp(b,3);	bstart_tmp(b,3) = 0
                 bend(bb,1) = bend_tmp(b,1);		bend_tmp(b,1) = 0
                 bend(bb,2) = bend_tmp(b,2);		bend_tmp(b,2) = 0
                 bend(bb,3) = bend_tmp(b,3);		bend_tmp(b,3) = 0
              endif
            enddo
            deallocate(bstart_tmp)
            deallocate(bend_tmp)

!            ! fill bgrid for function find_block(i,j,k)
!            allocate( t_bgrid(nblocks(1), nblocks(2), nblocks(3)), stat=error); if(error.ne.0) goto 20
!            do b = 1, nblocks_all ! add blocks not part of subdomain
!           !DOUBLE CHECK this part  - probably error !!!!!!!
!              bi = (bstart(b,1) / bsize(1)) +1
!              bj = (bstart(b,2) / bsize(2)) +1
!              bk = (bstart(b,3) / bsize(3)) +1
!              t_bgrid(bi,bj,bk) = b
!            enddo

        return ! skip test

            ! print memory block structure
            write(*,*)
            write(*,*) 'memory block structure (all) ',nblocks_all
            do b = 1, nblocks_all
              write(*,fmt='(a,i4,a,6(i4))') '      ',b,' block: ',	&
                bstart(b,1), bstart(b,2), bstart(b,3), 	&
                bend(b,1),   bend(b,2),   bend(b,3)
            enddo
            write(*,*) 'memory block structure (subdomain) ', nblocks_sub
            do b = 1, nblocks_sub
              write(*,fmt='(a,i4,a,6(i4))') '      ',b,' subblock: ',	&
                bstart_sub(b,1), bstart_sub(b,2), bstart_sub(b,3), 	&
                bend_sub(b,1),   bend_sub(b,2),   bend_sub(b,3)
            enddo

            ! check memory block structure
            allocate(psi(ndims(1),ndims(2),ndims(3)),STAT=error); if(error.ne.0) goto 20
            psi = -1.0
            do b=1, nblocks_all
              do k=bstart(b,3),bend(b,3)
                do j=bstart(b,2),bend(b,2)
                  do i=bstart(b,1),bend(b,1)
                    if( psi(i,j,k) .lt. 0) then
                      psi(i,j,k) = b
                    else
                      write(*,*) 'error at block memory structure (overlap)'
                    endif
                  enddo
                enddo
              enddo
            enddo
            if( minval(psi) .lt. 0) write(*,*) 'error at block memory structure (part missed)'
            ! check subdomain memory block structure
            psi = -1.0
            do b=1, nblocks_sub
              do k=bstart_sub(b,3),bend_sub(b,3)
                do j=bstart_sub(b,2),bend_sub(b,2)
                  do i=bstart_sub(b,1),bend_sub(b,1)
                    if( psi(i,j,k) .lt. 0) then
                      psi(i,j,k) = b
                    else
                      write(*,*) 'error at subblock memory structure (overlap)'
                    endif
                  enddo
                enddo
              enddo
            enddo
            testdomain(:,1) = (/ndims(1),ndims(2),ndims(3)/)
            testdomain(:,2) = (/0,0,0/)
              do k=1,ndims(3)
                do j=1,ndims(2)
                  do i=1,ndims(1)
                    if(psi(i,j,k) .gt. 0) then
                      if(i .lt. testdomain(1,1)) testdomain(1,1) = i
                      if(j .lt. testdomain(2,1)) testdomain(2,1) = j
                      if(k .lt. testdomain(3,1)) testdomain(3,1) = k
                      if(i .gt. testdomain(1,2)) testdomain(1,2) = i
                      if(j .gt. testdomain(2,2)) testdomain(2,2) = j
                      if(k .gt. testdomain(3,2)) testdomain(3,2) = k
                    endif
                  enddo
                enddo
              enddo
            write(*,*) testdomain(:,1)
            write(*,*) testdomain(:,2)
            if( minval(psi( testdomain(1,1):testdomain(1,2),	&
                            testdomain(2,1):testdomain(2,2),	&
                            testdomain(3,1):testdomain(3,2) )) .lt. 0) &
            	write(*,*) 'error at subblock memory structure (part missed)'

!            !$omp do schedule (static,1)
!            do b=1, nblocks_all
!              do k=bstart(b,3),bend(b,3)
!                do j=bstart(b,2),bend(b,2)
!                  do i=bstart(b,1),bend(b,1)
!                    psi(i,j,k) = omp_get_thread_num()
!                  enddo
!                enddo
!              enddo
!            enddo
!            !$omp end do

            deallocate(psi)

        return

    20	continue
        write(*,*) 'error allocating memory'
        stop

    end subroutine calc_memoryblocks

!
!     ------------
!
!	spread data over all DIMMs
!
!     ------------
!
    subroutine spread_int3dto3d(imem, omem)
      implicit none

        ! function vars
        integer, dimension(:,:,:), intent(in) :: imem
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
        integer, dimension(:,:,:,:,:,:), intent(out) :: omem ! must not be touched yet (no init-value, simply an allocate) !
#else
        integer, dimension(:,:,:), intent(out) :: omem ! must not be touched yet (no init-value, simply an allocate) !
#endif

        ! other vars
        integer :: b,i,j,k

        !omem(:,:,:) = imem(:,:,:)
        !return

        !$omp parallel                                          &
        !$omp default( shared )                                 &
        !$omp private( i,j,k  )

        !$omp do schedule (static)
        do b=1, nblocks_sub
          do k=bstart(b,3),bend(b,3)
            do j=bstart(b,2),bend(b,2)
              do i=bstart(b,1),bend(b,1)
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
                psmb_arr_3d(omem,i,j,k) = imem(i,j,k)
#else
                omem(i,j,k) = imem(i,j,k)
#endif
              enddo
            enddo
          enddo
        enddo
        !$omp end do
        !$omp end parallel

        do b=nblocks_sub+1, nblocks_all
          do k=bstart(b,3),bend(b,3)
            do j=bstart(b,2),bend(b,2)
              do i=bstart(b,1),bend(b,1)
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
                psmb_arr_3d(omem,i,j,k) = imem(i,j,k)
#else
                omem(i,j,k) = imem(i,j,k)
#endif
              enddo
            enddo
          enddo
        enddo

    end subroutine spread_int3dto3d

    subroutine spread_dble3dto3d(imem, omem)
      implicit none

        ! function vars
        double precision, dimension(:,:,:), intent(in) :: imem
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
        double precision, dimension(:,:,:,:,:,:), intent(out) :: omem ! must not be touched yet (no init-value, simply an allocate) !
#else
        double precision, dimension(:,:,:), intent(out) :: omem ! must not be touched yet (no init-value, simply an allocate) !
#endif

        ! other vars
        integer :: b,i,j,k

        !omem(:,:,:) = imem(:,:,:)
        !return

        !$omp parallel                                          &
        !$omp default( shared )                                 &
        !$omp private( i,j,k  )

        !$omp do schedule (static)
        do b=1, nblocks_sub
          do k=bstart(b,3),bend(b,3)
            do j=bstart(b,2),bend(b,2)
              do i=bstart(b,1),bend(b,1)
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
                psmb_arr_3d(omem,i,j,k) = imem(i,j,k)
#else
                omem(i,j,k) = imem(i,j,k)
#endif
              enddo
            enddo
          enddo
        enddo
        !$omp end do
        !$omp end parallel

        do b=nblocks_sub+1, nblocks_all
          do k=bstart(b,3),bend(b,3)
            do j=bstart(b,2),bend(b,2)
              do i=bstart(b,1),bend(b,1)
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
                psmb_arr_3d(omem,i,j,k) = imem(i,j,k)
#else
                omem(i,j,k) = imem(i,j,k)
#endif
              enddo
            enddo
          enddo
        enddo

    end subroutine spread_dble3dto3d

    subroutine init_int3d(value, omem)
      implicit none

        ! function vars
        integer, intent(in) :: value
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
        integer, dimension(:,:,:,:,:,:), intent(out) :: omem ! must not be touched yet (no init-value, simply an allocate) !
#else
        integer, dimension(:,:,:), intent(out) :: omem ! must not be touched yet (no init-value, simply an allocate) !
#endif

        ! other vars
        integer :: b,i,j,k

        !$omp parallel                                          &
        !$omp default( shared )                                 &
        !$omp private( i,j,k  )

        !$omp do schedule (static)
        do b=1, nblocks_sub
          do k=bstart(b,3),bend(b,3)
            do j=bstart(b,2),bend(b,2)
              do i=bstart(b,1),bend(b,1)
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
                psmb_arr_3d(omem,i,j,k) = value
#else
                omem(i,j,k) = value
#endif
              enddo
            enddo
          enddo
        enddo
        !$omp end do
	!$omp end parallel

        do b=nblocks_sub+1, nblocks_all
          do k=bstart(b,3),bend(b,3)
            do j=bstart(b,2),bend(b,2)
              do i=bstart(b,1),bend(b,1)
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
                psmb_arr_3d(omem,i,j,k) = value
#else
                omem(i,j,k) = value
#endif
              enddo
            enddo
          enddo
        enddo

    end subroutine init_int3d

    subroutine init_dble3d(value, omem)
      implicit none

        ! function vars
        double precision, intent(in) :: value
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
        double precision, dimension(:,:,:,:,:,:), intent(out) :: omem ! must not be touched yet (no init-value, simply an allocate) !
#else
        double precision, dimension(:,:,:), intent(out) :: omem ! must not be touched yet (no init-value, simply an allocate) !
#endif

        ! other vars
        integer :: b,i,j,k

        !$omp parallel                                          &
        !$omp default( shared )                                 &
        !$omp private( i,j,k  )

        !$omp do schedule (static)
        do b=1, nblocks_sub
          do k=bstart(b,3),bend(b,3)
            do j=bstart(b,2),bend(b,2)
              do i=bstart(b,1),bend(b,1)
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
                psmb_arr_3d(omem,i,j,k) = value
#else
                omem(i,j,k) = value
#endif
              enddo
            enddo
          enddo
        enddo
        !$omp end do
    !$omp end parallel

        do b=nblocks_sub+1, nblocks_all
          do k=bstart(b,3),bend(b,3)
            do j=bstart(b,2),bend(b,2)
              do i=bstart(b,1),bend(b,1)
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
                psmb_arr_3d(omem,i,j,k) = value
#else
                omem(i,j,k) = value
#endif
              enddo
            enddo
          enddo
        enddo

    end subroutine init_dble3d

    subroutine spread_dble3dto4d(imem, omem, v)
      implicit none

        ! function vars
        double precision, dimension(:,:,:), intent(in) :: imem
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
        double precision, dimension(:,:,:,:,:,:,:), intent(out) :: omem ! must not be touched yet (no init-value, simply an allocate) !
#else
        double precision, dimension(:,:,:,:), intent(out) :: omem ! must not be touched yet (no init-value, simply an allocate) !
#endif

        integer, intent(in) :: v

        ! other vars
        integer :: b,i,j,k

        !omem(:,:,:,v) = imem(:,:,:)
        !return

        !$omp parallel                                          &
        !$omp default( shared )                                 &
        !$omp private( i,j,k  )

        !$omp do schedule (static)
        do b=1, nblocks_sub
          do k=bstart(b,3),bend(b,3)
            do j=bstart(b,2),bend(b,2)
              do i=bstart(b,1),bend(b,1)
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
                psmb_arr_4d(omem,i,j,k,v) = imem(i,j,k)
#else
                omem(i,j,k,v) = imem(i,j,k)
#endif
              enddo
            enddo
          enddo
        enddo
        !$omp end do
        !$omp end parallel

        do b=nblocks_sub+1, nblocks_all
          do k=bstart(b,3),bend(b,3)
            do j=bstart(b,2),bend(b,2)
              do i=bstart(b,1),bend(b,1)
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
                psmb_arr_4d(omem,i,j,k,v) = imem(i,j,k)
#else
                omem(i,j,k,v) = imem(i,j,k)
#endif
              enddo
            enddo
          enddo
        enddo

    end subroutine spread_dble3dto4d

    subroutine init_int4d(value, omem, v)
      implicit none

        ! function vars
        integer, intent(in) :: value
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
        integer, dimension(:,:,:,:,:,:,:), intent(out) :: omem ! must not be touched yet (no init-value, simply an allocate) !
#else
        integer, dimension(:,:,:,:), intent(out) :: omem ! must not be touched yet (no init-value, simply an allocate) !
#endif

        integer, intent(in) :: v

        ! other vars
        integer :: b,i,j,k

        !$omp parallel                                          &
        !$omp default( shared )                                 &
        !$omp private( i,j,k  )

        !$omp do schedule (static)
        do b=1, nblocks_sub
          do k=bstart(b,3),bend(b,3)
            do j=bstart(b,2),bend(b,2)
              do i=bstart(b,1),bend(b,1)
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
                psmb_arr_4d(omem,i,j,k,v) = value
#else
                omem(i,j,k,v) = value
#endif
              enddo
            enddo
          enddo
        enddo
        !$omp end do
	!$omp end parallel

        do b=nblocks_sub+1, nblocks_all
          do k=bstart(b,3),bend(b,3)
            do j=bstart(b,2),bend(b,2)
              do i=bstart(b,1),bend(b,1)
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
                psmb_arr_4d(omem,i,j,k,v) = value
#else
                omem(i,j,k,v) = value
#endif
              enddo
            enddo
          enddo
        enddo

    end subroutine init_int4d

#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
    subroutine collect_dble3dto3d(imem, omem)
      implicit none

        ! function vars
        double precision, dimension(:,:,:,:,:,:), intent(in) :: imem
        double precision, dimension(:,:,:), intent(out) :: omem
        integer :: i,j,k,b

        do k=1, ndims(3)
          do j=1, ndims(2)
            do i=1, ndims(1)
              omem(i,j,k) = psmb_arr_3d(imem,i,j,k)
            enddo
          enddo
        enddo

    end subroutine collect_dble3dto3d

    subroutine collect_int3dto3d(imem, omem)
      implicit none

        ! function vars
        integer, dimension(:,:,:,:,:,:), intent(in) :: imem
        integer, dimension(:,:,:), intent(out) :: omem
        integer :: i,j,k,b

        do k=1, ndims(3)
          do j=1, ndims(2)
            do i=1, ndims(1)
              omem(i,j,k) = psmb_arr_3d(imem,i,j,k)
            enddo
          enddo
        enddo

    end subroutine collect_int3dto3d

    subroutine collect_int4dto3d(imem, omem, v)
      implicit none

        ! function vars
        integer, dimension(:,:,:,:,:,:,:), intent(in) :: imem
        integer, dimension(:,:,:), intent(out) :: omem
        integer, intent(in) :: v
        integer :: i,j,k,b

        do k=1, ndims(3)
          do j=1, ndims(2)
            do i=1, ndims(1)
              omem(i,j,k) = psmb_arr_4d(imem,i,j,k,v)
            enddo
          enddo
        enddo

    end subroutine collect_int4dto3d

    subroutine transform_results()
      use mod_psmb
      implicit none
      integer :: error

      if(do_trajcount) then
#if (_TRAJCOUNT_>0)
        call allocate_globals('trajcount',error)
        call collect_int3dto3d(trajcount_b, trajcount)
        psmb_free(trajcount_b)
#endif
      endif

      call allocate_globals('numbering',error)
      call collect_int4dto3d(numbering_b, numbering(:,:,:,1), 1)
      call collect_int4dto3d(numbering_b, numbering(:,:,:,2), 2)
      psmb_free(numbering_b)

    end subroutine transform_results
#endif

!    function find_block(i,j,k)
!      implicit none
!
!      integer :: find_block
!      integer, intent(in) :: i,j,k
!
!      integer :: ii,jj,kk
!
!      do ii=1, nblocks(1)
!        if(bstart( bgrid(ii,1,1), 1 ) .le. i) exit
!      enddo
!
!      do jj=1, nblocks(2)
!        if(bstart( bgrid(ii,jj,1), 2 ) .le. j) exit
!      enddo
!
!      do kk=1, nblocks(3)
!        if(bstart( bgrid(ii,jj,kk), 3 ) .le. k) exit
!      enddo
!
!      find_block = bgrid(ii,jj,kk)
!
!    end function find_block

end module mod_data

!
!     --------------------------------------------------------
!
!     subroutine setPsi_extern()
!
!     Wrapper-Function to set psi from extern
!     ATTENTION:
!       This code expects the same implementation of pointer-sizes
!       of the Fortran-Compileer and C-Compiler
!         (more at
!
!     --------------------------------------------------------
!
subroutine trajSearch_init(psi_c, psi_shape,trajPtsMin_c, trajPtsMax_c, test_on) bind(c,name='trajSearch_init_')
        use mod_data
        use, intrinsic :: ISO_C_BINDING
        implicit none

        ! function arguments
        type(c_ptr), value, intent(in) :: psi_c
        integer(c_int), dimension(3), intent(in)  :: psi_shape
        integer(c_int), intent(in) :: trajPtsMin_c, trajPtsMax_c
        integer(c_int), intent(in) :: test_on

        ! other vars
        integer :: i,j,k, maxijk(3)
        double precision :: sinyz, delta, maxdelta

#if (_TRAJCOUNT_>0)
        write(*,*) 'ERROR: Only use trajSearch_init() if _TRAJCOUNT_==0 in Makefile !!!'
#endif
#if (_NUMBERFIND_>0)
        write(*,*) 'ERROR: Only use trajSearch_init() if _NUMBERFIND_==0 in Makefile !!!'
#endif

        call init_globals()
        trajPtsMin = trajPtsMin_c
        trajPtsMax = trajPtsMax_c

        call c_f_pointer(psi_c, psi, psi_shape)

        !	default settings
        ndims    = psi_shape
        origdims = psi_shape
        spacedim = 3
        subdomain(1,1) = 1
        subdomain(2,1) = 1
        subdomain(3,1) = 1
        subdomain(1,2) = ndims(1)
        subdomain(2,2) = ndims(2)
        subdomain(3,2) = ndims(3)

        tattrs = dEleTrajVars_offset
        analyTraj = 1

       !	check array (pencil) against sinus-wave
        if(test_on .gt. 0) then
        	maxdelta = 0.d0
        	do k=1,ndims(3)
        	   do j=1,ndims(2)
        	      sinyz = sin((j-1)*pi2/ndims(2)) *sin((k-1)*pi2/ndims(3))
        	      do i=1,ndims(1)
        	         delta = abs(psi(i,j,k) -sin((i-1)*pi2/ndims(1)) *sinyz )
        	         if( delta .gt. maxdelta) then
        	         	maxdelta = delta
        	         	maxijk = (/i,j,k/)
        	         endif
        	      enddo
        	   enddo
        	enddo
        	write(*,*) ' max delta: ', maxdelta
        	write(*,*) ' max i,j,k: ', maxijk
        endif
        return

end subroutine trajSearch_init

