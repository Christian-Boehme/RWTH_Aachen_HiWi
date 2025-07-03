!
! Copyright (C) 2005-2010 by  Institute of Combustion Technology - RWTH Aachen University
! Lipo Wang, lwang@itv.rwth-aachen.de (2005-2006)
! Jens Henrik Goebbert, goebbert@itv.rwth-aachen.de (2007-2010)
! All rights reserved.
!

#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
#include "mod_psmb.h"
#endif

module mod_postp
    use mod_data
    implicit none
    save

    contains

!
!     --------------------------------------------------------
!
!     subroutine calcParing()
!
!     --------------------------------------------------------
!
    subroutine calcParing()
        use omp_lib
#if(_CALCPAIRING_==2)
        use map2d
#endif
        implicit none

        integer :: i,j,k,k0,alloc_err
        integer :: localMaxId,localMinId
        logical :: abort

        integer :: b, b_count
        double precision :: t_start, t_current, t_block, t_togo

#if(_CALCPAIRING_==3)
        ! for parallised version (global vars)
        integer(8) :: pairing_scaling(4)
        integer :: tt, t_maxpairs, num_t
        integer, dimension(:), allocatable :: t_numpairs
        integer, dimension(:,:,:), allocatable :: t_pairing
        integer, dimension(:), allocatable :: t_pairidstart, t_pairidend
        integer, dimension(:,:), allocatable :: pidtrans
        ! for parallised version (thread-private vars)
        logical :: found
        integer :: t,p,nextpair,my_t,pid
        integer(8) :: t_curpairid
        integer(8) :: t_pairing_scaling(4)
        integer, dimension(:,:,:), allocatable :: t_pairdomain
        integer, dimension(:), allocatable :: cached_numpairs
#elif(_CALCPAIRING_==2)
        integer*8 :: map
#endif

        call allocate_globals('note',alloc_err)
#if(_CALCPAIRING_==3)
        !$omp parallel                                          &
        !$omp default( shared )                                 &
        !$omp private( i,j,k )
        !$omp do schedule (static)
        do b=1, nblocks_all
          do k=bstart(b,3),bend(b,3)
            do j=bstart(b,2),bend(b,2)
              do i=bstart(b,1),bend(b,1)
        		note(i,j,k) = 0
              enddo
            enddo
          enddo
        enddo
        !$omp end do
        !$omp end parallel
#else
        note(:,:,:)=0
#endif

        call allocate_globals('pairing',alloc_err)
          pairing(:,:)=0

        call allocate_globals('pairdomain',alloc_err)
          pairdomain(:,:,:)=0

    ! minmax-pairing search => build of pairing,note,pairdomain
        numpairs=0
        write(*,*) 'search for dissipation elements...'

!	parallised version of loop - not finished yet (probably flush-command takes to much time)
!		!omp parallel                                                         &
!		!omp default( shared )
!		do i=subdomain(1,1),subdomain(1,2)
!            write(*,*) 'i, numpairs =',i, numpairs
!            do j=subdomain(2,1),subdomain(2,2)
!                do k=subdomain(3,1),subdomain(3,2)
!
!	      			if( numbering(i,j,k,1) .gt. 0 .and. numbering(i,j,k,2) .gt. 0) then	! traj has a min/max point
!
!	      				localMaxId = numbering(i,j,k,1)
!	      				localMinId = numbering(i,j,k,2)
!
!	      				abort = .false.
!
!	      				! search for an existing pair
!	      				!omp do schedule (static,1)
!	      				do k0 = numpairs,1,-1
!
!	      					! we are not allowed to break-out a loop in openmp - but this exits the loop quite fast
!	      					if(abort .eqv. .false.) then
!
!	      						! only none or one thread will enter this if-block (no critical-section needed)
!	      						if(localMinId .eq. pairing(k0,1) .and. localMaxId .eq. pairing(k0,2)) then
!	      							note(i,j,k) = k0
!
!	      							! found new grid-point for this pair
!	      							pairing(k0,3) = pairing(k0,3) +1
!	      							if(i .lt. pairdomain(k0,1,1)) pairdomain(k0,1,1) = i
!	      							if(i .gt. pairdomain(k0,2,1)) pairdomain(k0,2,1) = i
!	      							if(j .lt. pairdomain(k0,1,2)) pairdomain(k0,1,2) = j
!	      							if(j .gt. pairdomain(k0,2,2)) pairdomain(k0,2,2) = j
!	      							if(k .lt. pairdomain(k0,1,3)) pairdomain(k0,1,3) = k
!	      							if(k .gt. pairdomain(k0,2,3)) pairdomain(k0,2,3) = k
!
!	      							abort = .true.
!	      						endif
!
!	      						!omp flush(abort)
!	      					endif
!
!	     				enddo
!         				!omp end do
!
!          				if(abort .eqv. .false.) then
!
!	      					! no existing pair found - create a new one
!	      					numpairs = numpairs +1
!
!	      					pairing(numpairs,1) = localMinId
!	      					pairing(numpairs,2) = localMaxId
!	      					pairing(numpairs,3) = 1
!	      					note(i,j,k) = numpairs
!
!	      					pairdomain(numpairs,1,1) = i
!	      					pairdomain(numpairs,2,1) = i
!	      					pairdomain(numpairs,1,2) = j
!	      					pairdomain(numpairs,2,2) = j
!	      					pairdomain(numpairs,1,3) = k
!	      					pairdomain(numpairs,2,3) = k
!
!	      				endif
!
!	      			endif
!	      		enddo	! k-loop
!	      	enddo		! j-loop
!	    enddo			! i-loop
!        !omp end parallel
#if(_CALCPAIRING_==1)
        do k=subdomain(3,1),subdomain(3,2)
          write(*,*) 'k, numpairs =',k, numpairs
          do j=subdomain(2,1),subdomain(2,2)
            do i=subdomain(1,1),subdomain(1,2)

                      if( numbering(i,j,k,1) .gt. 0 .and. numbering(i,j,k,2) .gt. 0) then	! traj has a min/max point

                          localMaxId = numbering(i,j,k,1)
                          localMinId = numbering(i,j,k,2)

                          do k0 = numpairs,1,-1

                              if(localMinId .eq. pairing(k0,1) .and. localMaxId .eq. pairing(k0,2)) then
                                  note(i,j,k) = k0

                                  ! found new grid-point for this pair
                                  pairing(k0,3) = pairing(k0,3) +1
                                  if(i .lt. pairdomain(k0,1,1)) pairdomain(k0,1,1) = i
                                  if(i .gt. pairdomain(k0,2,1)) pairdomain(k0,2,1) = i
                                  if(j .lt. pairdomain(k0,1,2)) pairdomain(k0,1,2) = j
                                  if(j .gt. pairdomain(k0,2,2)) pairdomain(k0,2,2) = j
                                  if(k .lt. pairdomain(k0,1,3)) pairdomain(k0,1,3) = k
                                  if(k .gt. pairdomain(k0,2,3)) pairdomain(k0,2,3) = k

                                  goto 35
                              endif

                         enddo

                          ! no existing pair found - create a new one
                          numpairs = numpairs +1

                          pairing(numpairs,1) = localMinId
                          pairing(numpairs,2) = localMaxId
                          pairing(numpairs,3) = 1
                          note(i,j,k) = numpairs

                          pairdomain(numpairs,1,1) = i
                          pairdomain(numpairs,2,1) = i
                          pairdomain(numpairs,1,2) = j
                          pairdomain(numpairs,2,2) = j
                          pairdomain(numpairs,1,3) = k
                          pairdomain(numpairs,2,3) = k

                      endif
          35	enddo	! k-loop
              enddo		! j-loop
        enddo			! i-loop
#elif(_CALCPAIRING_==2)
        map = m2new()

        do k=subdomain(3,1),subdomain(3,2)
          write(*,*) 'k, numpairs =',k, numpairs
          do j=subdomain(2,1),subdomain(2,2)
            do i=subdomain(1,1),subdomain(1,2)

                      if( numbering(i,j,k,1) .gt. 0 .and. numbering(i,j,k,2) .gt. 0) then       ! traj has a min/max point

                          localMaxId = numbering(i,j,k,1)
                          localMinId = numbering(i,j,k,2)
                          k0 = m2get(map, localMinId, localMaxId)
                          if(k0 .gt. 0) then
                                note(i,j,k) = k0

                                ! found new grid-point for this pair
                                pairing(k0,3) = pairing(k0,3) +1
                                if(i .lt. pairdomain(k0,1,1)) pairdomain(k0,1,1) = i
                                if(i .gt. pairdomain(k0,2,1)) pairdomain(k0,2,1) = i
                                if(j .lt. pairdomain(k0,1,2)) pairdomain(k0,1,2) = j
                                if(j .gt. pairdomain(k0,2,2)) pairdomain(k0,2,2) = j
                                if(k .lt. pairdomain(k0,1,3)) pairdomain(k0,1,3) = k
                                if(k .gt. pairdomain(k0,2,3)) pairdomain(k0,2,3) = k
                          else
                                ! no existing pair found - create a new one
                                numpairs = numpairs + 1

                                call m2set(map, localMinId, localMaxId, numpairs)
                                pairing(numpairs,1) = localMinId
                                pairing(numpairs,2) = localMaxId
                                pairing(numpairs,3) = 1
                                note(i,j,k) = numpairs

                                pairdomain(numpairs,1,1) = i
                                pairdomain(numpairs,2,1) = i
                                pairdomain(numpairs,1,2) = j
                                pairdomain(numpairs,2,2) = j
                                pairdomain(numpairs,1,3) = k
                                pairdomain(numpairs,2,3) = k
                          endif
                     endif
              enddo     ! k-loop
           enddo                ! j-loop
        enddo                   ! i-loop

	call m2delete(map)
#elif(_CALCPAIRING_==3)

        b_count = 0
        t_maxpairs = 1000000
        num_t = omp_get_max_threads()
        allocate(t_numpairs(0:num_t-1), STAT=alloc_err)
        allocate(t_pairing(t_maxpairs,4,0:num_t-1), STAT=alloc_err)
        allocate(t_pairdomain(t_maxpairs,7,0:num_t-1), STAT=alloc_err)
        allocate(t_pairidstart(0:num_t-1), STAT=alloc_err)
        allocate(t_pairidend(0:num_t-1), STAT=alloc_err)
        pairing_scaling(:) = 0
        t_start = omp_get_wtime()
        !$omp parallel                                          &
        !$omp default( shared )                                 &
        !$omp private( i,j,k,b,b_count  )                       &
        !$omp private( t_current, t_block, t_togo )             &
        !$omp private( localMaxId, localMinId )              &
        !$omp private( found, p, pid, t, nextpair, t_curpairid) &
        !$omp private( cached_numpairs )                        &
        !$omp private( t_pairing_scaling )                      &
        !$omp private( my_t )
        my_t    = omp_get_thread_num()

        t_curpairid = my_t *t_maxpairs
        t_pairidstart(my_t) = my_t *t_maxpairs
        t_pairidend(my_t)   = (my_t+1) *t_maxpairs-1

        t_pairing_scaling(:) = 0

        t_pairdomain(:,:,my_t) = 0
        t_pairing(:,:,my_t) = 0

        t_numpairs(my_t) = 0 !! values of threads are not seperated by 4KB-pagesize => this is not saved locally !!

        allocate(cached_numpairs(0:num_t-1), STAT=alloc_err)

        !$omp flush
        !$omp barrier
        !$omp do schedule (static)
        do b=1, nblocks_sub
          b_count = b_count +1
          if( mod(b,10) .eq. 0 ) then
            t_current = omp_get_wtime()
            t_block = (t_current -t_start) /(b_count *omp_get_num_threads())
            t_togo = ((nblocks_sub *t_block) -(t_current-t_start))
            write(*,fmt='(a,f6.2)') '   finish  pairing in [h]=', t_togo/3600.d0
          endif

          do k=bstart_sub(b,3),bend_sub(b,3)
            do j=bstart_sub(b,2),bend_sub(b,2)
              do i=bstart_sub(b,1),bend_sub(b,1)

                      if( numbering(i,j,k,1) .gt. 0 .and. numbering(i,j,k,2) .gt. 0) then	! traj has a min/max point

                          found = .false.
                          localMaxId = numbering(i,j,k,1)
                          localMinId = numbering(i,j,k,2)

                          !!!!!!!!!!
                          ! 1. check local t_pairing for known pair (local == no lock)
                          !!!!!!!!!!
                          t_pairing_scaling(1) = t_pairing_scaling(1) +1
                          do p = t_numpairs(my_t),1,-1
                          	if(localMinId .eq. t_pairing(p,1,my_t) .and. localMaxId .eq. t_pairing(p,2,my_t)) then

                         		! change private data never accessed by other threads
                         		!---

                          		! save pairing-id to grid-cell
                          		note(i,j,k) = t_pairing(p, 4, my_t)

                          		! found new grid-point for this pair (saved locally)
                          		t_pairing(p, 3, my_t) = t_pairing(p, 3, my_t) +1
                          		if(i .lt. t_pairdomain(p,1,my_t)) t_pairdomain(p,1,my_t) = i
                          		if(i .gt. t_pairdomain(p,2,my_t)) t_pairdomain(p,2,my_t) = i
                          		if(j .lt. t_pairdomain(p,3,my_t)) t_pairdomain(p,3,my_t) = j
                          		if(j .gt. t_pairdomain(p,4,my_t)) t_pairdomain(p,4,my_t) = j
                          		if(k .lt. t_pairdomain(p,5,my_t)) t_pairdomain(p,5,my_t) = k
                          		if(k .gt. t_pairdomain(p,6,my_t)) t_pairdomain(p,6,my_t) = k

                          		found = .true.
                          		exit
                          	endif
                         enddo
                         if(found) cycle

                         !!!!!!!!!!
                         ! 2. check pairing of other threads (asyncron == no lock)
                         !		no pair in local t_pairing found (local == no lock)
                         !!!!!!!!!!
                         t_pairing_scaling(2) = t_pairing_scaling(2) +1

                         ! check pairing of other threads until their numpair
                         do t=0, num_t-1
                         	if(t .eq. my_t) cycle		! skip thread-part of pairing (already checked in 1.)
                         	cached_numpairs(t) = t_numpairs(t)	! remember to know what to check in 3.
                         	do p=cached_numpairs(t),1,-1
                         	  if(localMinId .eq. t_pairing(p,1,t) .and. localMaxId .eq. t_pairing(p,2,t)) then

                         		nextpair = t_numpairs(my_t)+1

                         		! A) change private data accessed by other threads
                         		!---

                         		! copy pair to local pairing-list (using same id)
                         		t_pairing(nextpair, 1,my_t) = t_pairing(p, 1, t)	! minId
                         		t_pairing(nextpair, 2,my_t) = t_pairing(p, 2, t)	! maxId
                         		t_pairing(nextpair, 4,my_t) = t_pairing(p, 4, t)	! pairId

                         		! change in t_pairing finished - tell this new length every thread
                         		! but(!) this happens at the next omp-flush
                         		! attention: this is not a _globaly_new_ entry - we do not have to be in sync,
                         		!             because other threads would find the entry through thread "t"
                         		!            the critical section 3. does not have to know about this entry
                         		t_numpairs(my_t) = nextpair

                         		! B) change private data never accessed by other threads
                         		!---

                         		! save pair-id to grid-cell
                         		note(i,j,k) = t_pairing(nextpair, 4, my_t)

                         		! found new local grid-point for this pair
                         		t_pairing(nextpair, 3, my_t) = 1
                         		t_pairdomain(nextpair,1,my_t) = i
                         		t_pairdomain(nextpair,2,my_t) = i
                         		t_pairdomain(nextpair,3,my_t) = j
                         		t_pairdomain(nextpair,4,my_t) = j
                         		t_pairdomain(nextpair,5,my_t) = k
                         		t_pairdomain(nextpair,6,my_t) = k
                         		t_pairdomain(nextpair,7,my_t) = t_pairing(nextpair, 4,my_t)

                         		found = .true.
                         		exit
                         	  endif
                         	enddo
                         	if(found) exit
                         enddo
                         if(found) cycle

                         !!!!!!!!!!
                         ! 3a. check remaining pairing of other threads found while doing 2. (syncron == big lock)
                         !		1. no pair in local t_pairing found (local == no lock)
                         !		2. no pair in other threads found (asyncron == no lock)
                         !	but (!) other threads maid have found new pairs meanwhile
                         !	make sure no thread adds new pairs to their pairing, while checking
                         !!!!!!!!!!
                         t_pairing_scaling(3) = t_pairing_scaling(3) +1

                         !!! make sure the FLUSH directive is implied for the critical section
                         !omp critical
                         ! check pairing of other threads until their numpair
                         do t=0, num_t-1
                           if(t .eq. my_t) cycle
                         	do p=t_numpairs(t), cached_numpairs(t)+1,-1
                         	  if(localMinId .eq. t_pairing(p,1,t) .and. localMaxId .eq. t_pairing(p,2,t)) then

                         		nextpair = t_numpairs(my_t)+1

                         		! A) change private data accessed by other threads
                         		!---

                         		! copy pair to local pairing-list (using same id)
                         		t_pairing(nextpair, 1, my_t) = t_pairing(p, 1, t)	! minId
                         		t_pairing(nextpair, 2, my_t) = t_pairing(p, 2, t)	! maxId
                         		t_pairing(nextpair, 4, my_t) = t_pairing(p, 4, t)	! pairId

                         		! let others know about the longer t_pairing (at least at the next flush)
                         		t_numpairs(my_t) = nextpair

                         		! B) change private data never accessed by other threads
                         		!---

                         		! save pair-id to grid-cell
                         		note(i,j,k) = t_pairing(nextpair, 4, my_t)

                         		! found new localc grid-point for this pair
                         		t_pairing(nextpair, 3, my_t) = 1
                         		t_pairdomain(nextpair,1,my_t) = i
                         		t_pairdomain(nextpair,2,my_t) = i
                         		t_pairdomain(nextpair,3,my_t) = j
                         		t_pairdomain(nextpair,4,my_t) = j
                         		t_pairdomain(nextpair,5,my_t) = k
                         		t_pairdomain(nextpair,6,my_t) = k
                         		t_pairdomain(nextpair,7,my_t) = t_pairing(nextpair, 4, my_t)

                         		found = .true.
                         		exit

                         	  endif
                         	enddo
                         	if(found) exit
                         enddo

                         if(.not. found) then
                         	!!!!!!!!!!
                         	! 3b. no existing pair found - create a new one
                         	!		1. no pair in local t_pairing found (local == no lock)
                         	!		2. no pair in other threads found (asyncron == no lock)
                         	!		3a. no pair in other threads found (syncron == big lock)
                         	!!!!!!!!!!
                         	t_pairing_scaling(4) = t_pairing_scaling(4) +1

                         	nextpair = t_numpairs(my_t)+1

                         	! A) change private data accessed by other threads
                         	!---

                         	! create new pair in local pairing-list
                         	t_curpairid = t_curpairid +1
                         	t_pairing(nextpair,1, my_t) = localMinId
                         	t_pairing(nextpair,2, my_t) = localMaxId
                         	t_pairing(nextpair,4, my_t) = t_curpairid

                         	! let others know about the longer t_pairing (at least at the next flush)
                         	t_numpairs(my_t) = nextpair

                         	! B) change private data never accessed by other threads
                         	!---

                         	! save pair-id to grid-cell
                         	note(i,j,k) = t_pairing(nextpair,4, my_t)

                         	! found new local grid-point for this pair
                         	t_pairing(t_numpairs(my_t),3, my_t) = 1
                         	t_pairdomain(nextpair,1,my_t) = i
                         	t_pairdomain(nextpair,2,my_t) = i
                         	t_pairdomain(nextpair,3,my_t) = j
                         	t_pairdomain(nextpair,4,my_t) = j
                         	t_pairdomain(nextpair,5,my_t) = k
                         	t_pairdomain(nextpair,6,my_t) = k
                         	t_pairdomain(nextpair,7,my_t) = t_pairing(nextpair, 4, my_t)
                         endif
                         !omp end critical

                      endif
            	enddo
              enddo
          enddo

        enddo
        !$omp end do

        ! sum counters
        !omp critical
        	pairing_scaling(:) = pairing_scaling(:) +t_pairing_scaling(:)
        !omp end critical

        !$omp end parallel

        ! syncronize pairing(:12) and calc numpairs
        write(*,*) '... sync pairing(:,12)'
        numpairs = 0
        pairing(:,:) = 0
        allocate(pidtrans(0:maxval(t_numpairs),0:num_t-1), STAT=alloc_err)
        pidtrans(:,:) = 0
        do t=0, num_t-1
          do p=1, t_numpairs(t)
        	pid = t_pairing(p,4,t)
        	!only collect pid's with local thread-ids (found in 4.) - no cached pid's(found in 3.)
        	if(pid .ge. t_pairidstart(t) .and. pid .le. t_pairidend(t) ) then
        		numpairs = numpairs +1
        		pairing(numpairs,1) = t_pairing(p,1,t)
        		pairing(numpairs,2) = t_pairing(p,2,t)
        		pidtrans(pid-t_pairidstart(t),t) = numpairs
        	endif
          enddo
        enddo

        ! syncronize pairing(3)
        write(*,*) '... sync+trans pairing(:,3)'
        do t=0, num_t-1
          do p=1, t_numpairs(t)
        	tt = t_pairing(p,4,t)/t_maxpairs			!! get owner-thread-id
        	pid = t_pairing(p,4,t) -t_pairidstart(tt)	!! get thread-relative pairID
        	!write(*,*) tt, t_pairidstart(tt), t_pairing(p,4,t), pid
        	pairing( pidtrans(pid,tt), 3) = pairing( pidtrans(pid,tt), 3) +t_pairing(p,3,t)
          enddo
        enddo

        ! translate pairdomain
        write(*,*) '... sync+trans pairdomain'
        do t=0, num_t-1
          do p=1, t_numpairs(t)
        	tt = t_pairdomain(p,7,t)/t_maxpairs				!! get owner-thread-id
        	pid = t_pairdomain(p,7,t) -t_pairidstart(tt)	! local pid
        	pid = pidtrans(pid,tt)		! global pid
        	if(pairdomain(pid,1,1) .eq. 0) then
        		pairdomain(pid,1,1) = t_pairdomain(p,1,t)
        		pairdomain(pid,2,1) = t_pairdomain(p,2,t)
        		pairdomain(pid,1,2) = t_pairdomain(p,3,t)
        		pairdomain(pid,2,2) = t_pairdomain(p,4,t)
        		pairdomain(pid,1,3) = t_pairdomain(p,5,t)
        		pairdomain(pid,2,3) = t_pairdomain(p,6,t)
        	else
        		if(t_pairdomain(p,1,t) .lt. pairdomain(pid,1,1)) pairdomain(pid,1,1) = t_pairdomain(p,1,t)
        		if(t_pairdomain(p,2,t) .gt. pairdomain(pid,2,1)) pairdomain(pid,2,1) = t_pairdomain(p,2,t)
        		if(t_pairdomain(p,3,t) .lt. pairdomain(pid,1,2)) pairdomain(pid,1,2) = t_pairdomain(p,3,t)
        		if(t_pairdomain(p,4,t) .gt. pairdomain(pid,2,2)) pairdomain(pid,2,2) = t_pairdomain(p,4,t)
        		if(t_pairdomain(p,5,t) .lt. pairdomain(pid,1,3)) pairdomain(pid,1,3) = t_pairdomain(p,5,t)
        		if(t_pairdomain(p,6,t) .gt. pairdomain(pid,2,3)) pairdomain(pid,2,3) = t_pairdomain(p,6,t)
        	endif
          enddo
        enddo

        ! translate note()
        write(*,*) '... sync+trans note(i,j,k)'
        !$omp parallel                                          &
        !$omp default( shared )                                 &
        !$omp private( i,j,k,tt,b )
        !$omp do schedule (static)
        do b=1, nblocks_sub
         do k=bstart_sub(b,3),bend_sub(b,3)
           do j=bstart_sub(b,2),bend_sub(b,2)
             do i=bstart_sub(b,1),bend_sub(b,1)
                tt = note(i,j,k)/t_maxpairs				!! get owner-thread-id
                note(i,j,k) = pidtrans( note(i,j,k)-t_pairidstart(tt), tt)
             enddo
           enddo
         enddo
        enddo
        !$omp end do
        !$omp end parallel
#endif

        write(*,*) '   found ',numpairs,'min-max-pairs'

    end subroutine calcParing

!
!     --------------------------------------------------------
!
!     subroutine analyTrajCond()
!          must be thread-safe !
!
!     --------------------------------------------------------
!
    subroutine analyTrajCond( i,j,k,  traject_pool, traject_id, trajMaxMinIds, trajLenPath, trajV,		&
                               corr_size3, jcorr_size3, corr_omp, jcorr_omp, mhist_omp, scalevars	&
#ifndef _CUBIC_CELLS_
                               ,trajxyz_omp	&
#endif
)
        implicit none

        integer,           intent(in) :: i,j,k
        double precision, dimension(-trajPtsMin:trajPtsMax,tattrs,dumpTraj_pktsize), intent(inout) :: traject_pool
        integer, intent(in) :: traject_id
        integer,           intent(in) :: trajMaxMinIds(2)
        double precision, intent(out) :: trajLenPath(-trajPtsMin:trajPtsMax)
        double precision, intent(out) :: trajV(-trajPtsMin:trajPtsMax)
        integer, intent(in) :: corr_size3, jcorr_size3
        double precision, intent(inout) :: corr_omp(0:1000,-1:corr_size3)
        integer(kind=8), intent(inout)  :: jcorr_omp(0:1000,0:1000,jcorr_size3)
        integer(kind=8), intent(inout)  :: mhist_omp(4,0:1000)
        double precision, intent(inout) :: scalevars(0:novars)
#ifndef _CUBIC_CELLS_
        double precision, intent(out) ::trajxyz_omp(-trajPtsMin:trajPtsMax,3)
#endif

        double precision, automatic :: trajLenTotal
        integer, automatic :: pT, pT1, pT2, c, v
        integer, automatic :: mflag1, mflag2

#ifndef _CUBIC_CELLS_
        integer, automatic :: ni, nj, nk
        double precision, automatic :: endx, endy, endz
#endif

        ! could have attribute 'save' - no, must be thread-safe?
        logical, save :: init_done = .false.
        integer, save :: vecn1_id
        integer, save :: vecn2_id
        integer, save :: vecn3_id
        integer, save :: vecl_id
        integer, save :: tdens_id
        integer, save :: u_id
        integer, save :: v_id
        integer, save :: w_id
        double precision, save :: scalef

        !$omp threadprivate(init_done)
        !$omp threadprivate(vecn1_id)
        !$omp threadprivate(vecn2_id)
        !$omp threadprivate(vecn3_id)
        !$omp threadprivate(vecl_id)
        !$omp threadprivate(tdens_id)
        !$omp threadprivate(u_id)
        !$omp threadprivate(v_id)
        !$omp threadprivate(w_id)
        !$omp threadprivate(scalef)

        ! trajectory must have 4 points minimum !
        if(trajMaxMinIds(1) -trajMaxMinIds(2) .lt. 3) return

!        ! DEBUG
!        do pT=trajMaxMinIds(2), trajMaxMinIds(1)
!          do c=1, dEleTrajVars_offset +novars
!        	if(traject_pool(pT,c,traject_id) .ne. traject_pool(pT,c,traject_id)) then
!        		write(*,*) 'traject-error at ',i,j,k,' component ',c
!        	endif
!          enddo
!        enddo

       if( .not. init_done ) then

        	! set pseudo-constants
        	vecn1_id = 5	! traj-direction-vector (component 1)
        	vecn2_id = 6	! traj-direction-vector (component 2)
        	vecn3_id = 7	! traj-direction-vector (component 3)
        	vecl_id  = 8	! traj-direction-vector (length)
        	tdens_id = 9
        	u_id = dEleTrajVars_offset +1
        	v_id = dEleTrajVars_offset +2
        	w_id = dEleTrajVars_offset +3

#ifndef _CUBIC_CELLS_
        	scalef = 1000.d0/( (abs( coordx(1)-coordx(ndims(1)) ) +	&
                            abs( coordy(1)-coordy(ndims(2)) ) +	&
                            abs( coordz(1)-coordz(ndims(3)) ) )/3.d0)
#else
        	scalef = 1000.d0/ ((origdims(1) +origdims(2) +origdims(3))/3.d0)
#endif

#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
        	scalevars(0) = 1000.d0/(maxval(psi_b) -minval(psi_b))
#else
        	scalevars(0) = 1000.d0/(maxval(psi) -minval(psi))
#endif
        	do v=1, novars
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
         	  scalevars(v) = 1000.d0/( maxval(vars_b(:,:,:,v,:,:,:)) -minval(vars_b(:,:,:,v,:,:,:)) )/2.d0
#else
         	  scalevars(v) = 1000.d0/( maxval(vars(:,:,:,v)) -minval(vars(:,:,:,v)) )/2.d0
#endif
        	enddo
        	init_done = .true.
       endif

        ! calc trajectory lenghts and velocity
        trajLenPath(trajMaxMinIds(2)) = 0.d0

#ifndef _CUBIC_CELLS_
        do pT=trajMaxMinIds(2), trajMaxMinIds(1)
            ni   = int(traject_pool(pT,1,traject_id))
            nj   = int(traject_pool(pT,2,traject_id))
            nk   = int(traject_pool(pT,3,traject_id))
            endx = traject_pool(pT,1,traject_id) -ni
            endy = traject_pool(pT,2,traject_id) -nj
            endz = traject_pool(pT,3,traject_id) -nk
            trajxyz_omp(pT,1) = coordx(ni) +endx*(coordx(ni+1)-coordx(ni))
            trajxyz_omp(pT,2) = coordy(nj) +endy*(coordy(nj+1)-coordy(nj))
            trajxyz_omp(pT,3) = coordz(nk) +endz*(coordz(nk+1)-coordz(nk))
        enddo

        ! calc length between trajectory-datapoints
        trajLenPath(trajMaxMinIds(2)) = 0.d0
        do pT=trajMaxMinIds(2)+1, trajMaxMinIds(1)
          trajLenPath(pT)   = trajLenPath(pT-1)                                           &
                               +dsqrt(   ( trajxyz_omp(pT-1,1) -trajxyz_omp(pT,1) )**2    &
                                        +( trajxyz_omp(pT-1,2) -trajxyz_omp(pT,2) )**2    &
                                        +( trajxyz_omp(pT-1,3) -trajxyz_omp(pT,3) )**2 )
        enddo

        ! calc velocity projected on trajectory-datapoints
        do pT=trajMaxMinIds(2)+1, trajMaxMinIds(1)-1
          trajV(pT) = traject_pool(pT,u_id,traject_id) *traject_pool(pT,vecn1_id,traject_id)	&
                     +traject_pool(pT,v_id,traject_id) *traject_pool(pT,vecn2_id,traject_id)	&
                     +traject_pool(pT,w_id,traject_id) *traject_pool(pT,vecn3_id,traject_id)
        enddo

#else
        ! calc length between trajectory-datapoints
        trajLenPath(trajMaxMinIds(2)) = 0.d0
        do pT=trajMaxMinIds(2)+1, trajMaxMinIds(1)
          trajLenPath(pT)   = trajLenPath(pT-1)                                          &
                               +dsqrt(   ( traject_pool(pT-1,1,traject_id) -traject_pool(pT,1,traject_id) )**2           &
                                        +( traject_pool(pT-1,2,traject_id) -traject_pool(pT,2,traject_id) )**2           &
                                        +( traject_pool(pT-1,3,traject_id) -traject_pool(pT,3,traject_id) )**2 )
        enddo

        ! calc velocity projected on trajectory-datapoints
        do pT=trajMaxMinIds(2)+1, trajMaxMinIds(1)-1
          trajV(pT) = traject_pool(pT,u_id,traject_id) *traject_pool(pT,vecn1_id,traject_id)	&
                     +traject_pool(pT,v_id,traject_id) *traject_pool(pT,vecn2_id,traject_id)	&
                     +traject_pool(pT,w_id,traject_id) *traject_pool(pT,vecn3_id,traject_id)
        enddo

#endif

        ! walk over trajectory (from last before minimum to last before maximum)
        do pT1 = trajMaxMinIds(2)+1, trajMaxMinIds(1)-1

          ! skip pT1 data outside of subdomain
          if( traject_pool(pT1,1,traject_id) .lt. subdomain(1,1) .or. traject_pool(pT1,1,traject_id) .gt. subdomain(1,2)  .or.	&
              traject_pool(pT1,2,traject_id) .lt. subdomain(2,1) .or. traject_pool(pT1,2,traject_id) .gt. subdomain(2,2)  .or.	&
              traject_pool(pT1,3,traject_id) .lt. subdomain(3,1) .or. traject_pool(pT1,3,traject_id) .gt. subdomain(3,2) ) cycle

          do pT2 =pT1+1, trajMaxMinIds(1)-1

           ! skip pT2 data outside of subdomain
           if( traject_pool(pT2,1,traject_id) .lt. subdomain(1,1) .or. traject_pool(pT2,1,traject_id) .gt. subdomain(1,2) .or.	&
               traject_pool(pT2,2,traject_id) .lt. subdomain(2,1) .or. traject_pool(pT2,2,traject_id) .gt. subdomain(2,2) .or.	&
               traject_pool(pT2,3,traject_id) .lt. subdomain(3,1) .or. traject_pool(pT2,3,traject_id) .gt. subdomain(3,2) ) cycle

           ! calc bucket-id, which corresponds to length
           mflag1 = (trajLenPath(pT2) -trajLenPath(pT1)) *scalef +0.5d0
           mflag1 = max(mflag1,0)
           mflag1 = min(mflag1,1000)

           !For weighting more than one box
           mhist_omp(2,mflag1) = mhist_omp(2,mflag1) +1
!
!           ! deltaU on trajectory
!           corr_omp(mflag1, 0) = corr_omp(mflag1, 0) + traject_pool(pT1,tdens_id,traject_id) *traject_pool(pT2,tdens_id,traject_id)		! correlation of traj_density(p12)
!           corr_omp(mflag1,-1) = corr_omp(mflag1,-1) +( traject_pool(pT1,vecl_id,traject_id) *traject_pool(pT1,tdens_id,traject_id)	&	! correlation of traj_density(p12)* grad(psi12)
!                                                     *traject_pool(pT2,vecl_id,traject_id) *traject_pool(pT2,tdens_id,traject_id) )
!
!           ! deltaU on trajectory
!           corr_omp(mflag1,1) = corr_omp(mflag1,1)							&
!                             + (trajV(pT2) -trajV(pT1))						&	! sum(delta(v12) *traj_density(p12)
!                              *traject_pool(pT1,tdens_id,traject_id)						&
!                              *traject_pool(pT2,tdens_id,traject_id)
!
!           ! deltaPsi on trajectory
!           corr_omp(mflag1,2) = corr_omp(mflag1,2)							&
!                             + (traject_pool(pT2,4,traject_id) -traject_pool(pT1,4,traject_id))				&	! sum(delta(psi12)*traj_density(p12)
!                              *traject_pool(pT1,tdens_id,traject_id)						&
!                              *traject_pool(pT2,tdens_id,traject_id)
!
!           ! deltaU*psi on trajectory
!           corr_omp(mflag1,3) = corr_omp(mflag1,3)							&
!                             + ( trajV(pT2)*traject_pool(pT2,4,traject_id) -trajV(pT1)*traject_pool(pT1,4,traject_id) )	&	! sum(delta(v12*k12)*traj_density(p12)
!                              *traject_pool(pT1,tdens_id,traject_id)						&
!                              *traject_pool(pT2,tdens_id,traject_id)
!
!           ! deltaU *grad(psi12) on trajectory
!           corr_omp(mflag1,4) = corr_omp(mflag1,4)							&
!                             + (trajV(pT2) -trajV(pT1))						&	! sum(delta(v12)*grad(psi12) *traj_density(p12)
!                              *traject_pool(pT1,vecl_id,traject_id)							&
!                              *traject_pool(pT2,vecl_id,traject_id)							&
!                              *traject_pool(pT1,tdens_id,traject_id)						&
!                              *traject_pool(pT2,tdens_id,traject_id)
!
!           ! sum(U *grad(psi)) on trajectory
!           corr_omp(mflag1,5) = corr_omp(mflag1,5)							&
!                             +(  (trajV(pT1) *traject_pool(pT1,vecl_id,traject_id))			&
!                                +(trajV(pT2) *traject_pool(pT2,vecl_id,traject_id)) )		&	! sum(v1*grad1 +v2*grad2) *traj_density12
!                              *traject_pool(pT1,tdens_id,traject_id)						&
!                              *traject_pool(pT2,tdens_id,traject_id)
!
!           ! sum(v1*(-var1) +v2*(-var2) ) on trajectory
!           corr_omp(mflag1,6) = corr_omp(mflag1,6)												&
!                             +(  (trajV(pT1) *(-traject_pool(pT1, dEleTrajVars_offset +novars,traject_id)) )			&
!                                +(trajV(pT2) *(-traject_pool(pT2, dEleTrajVars_offset +novars,traject_id)) ) )		&	! sum(v1*grad1 +v2*grad2) *traj_density12
!                              *traject_pool(pT1,tdens_id,traject_id)											&
!                              *traject_pool(pT2,tdens_id,traject_id)
!
!           ! deltaVar on trajectory
!           do v=1, novars
!             corr_omp(mflag1,6+v) = corr_omp(mflag1,6+v)															&
!                             + (traject_pool(pT2, (dEleTrajVars_offset +v,traject_id) ) -traject_pool(pT1, (dEleTrajVars_offset +v),traject_id ))	&
!                              *traject_pool(pT1,tdens_id,traject_id)																&
!                              *traject_pool(pT2,tdens_id,traject_id)
!
!           enddo
!
!           ! joined deltaPsi<->deltaVar on trajectory
!           mflag1 = (traject_pool(pT2,4,traject_id) -traject_pool(pT1,4,traject_id)) *scalevars(0) +0.5d0
!           mflag1 = max(mflag1,1000)
!           mflag1 = min(mflag1,0)
!           do v=1, novars
!             mflag2 = (traject_pool(pT2, (dEleTrajVars_offset +v),traject_id ) -traject_pool(pT1, (dEleTrajVars_offset +v),traject_id )) *scalevars(v) +0.5d0
!             mflag2 = max(mflag2,-500)
!             mflag2 = min(mflag2,+500)
!             mflag2 = mflag2 +500
!             jcorr_omp(mflag1,mflag2,v) = jcorr_omp(mflag1,mflag2,v) +1
!           enddo
!
          enddo
        enddo

        !! save histogram for MinMaxLength
        !!!!!!!!!!!!!!!!!!!!!!!!!!
        ! calc bucketid in histograms
        mflag1 = trajLenPath(trajMaxMinIds(1)) *scalef*5.d0 +0.5d0
        mflag1 = max(mflag1,0)
        mflag1 = min(mflag1,1000)

        ! histogramm of all traj-lengths
        mhist_omp(1,mflag1) = mhist_omp(1,mflag1) +1

        !! save joint histogram (2d) for trajArcLength to MinMaxLength
        !!!!!!!!!!!!!!!!!!!!!!!!!!
        ! calc bucketid in histograms
#ifndef _CUBIC_CELLS_
        mflag2 =  dsqrt(   ( trajxyz_omp(trajMaxMinIds(1),1) -trajxyz_omp(trajMaxMinIds(2),1) )**2    &
                          +( trajxyz_omp(trajMaxMinIds(1),2) -trajxyz_omp(trajMaxMinIds(2),2) )**2    &
                          +( trajxyz_omp(trajMaxMinIds(1),3) -trajxyz_omp(trajMaxMinIds(2),3) )**2 ) *scalef*5.d0 +0.5d0
#else
        mflag2 =  dsqrt(   ( traject_pool(trajMaxMinIds(1),1,traject_id) -traject_pool(trajMaxMinIds(2),1,traject_id) )**2           &
                          +( traject_pool(trajMaxMinIds(1),2,traject_id) -traject_pool(trajMaxMinIds(2),2,traject_id) )**2           &
                          +( traject_pool(trajMaxMinIds(1),3,traject_id) -traject_pool(trajMaxMinIds(2),3,traject_id) )**2 ) *scalef*5.d0 +0.5d0
#endif
        ! save joined histogram
        mflag2 = max(mflag2,0)
        mflag2 = min(mflag2,1000)
        jcorr_omp(mflag1,mflag2,novars+1) = jcorr_omp(mflag1,mflag2,novars+1) +1

    end subroutine analyTrajCond

!
!     --------------------------------------------------------
!
!     subroutine analyTrajEndCond()
!          must be thread-safe !
!          calc Trajectory End Point Statistics
!
!     --------------------------------------------------------
!
    subroutine analyTrajEndCond( i,j,k, traject_pool, traject_id, trajMaxMinIds, mhist_omp, jcorr_size3, jcorr_omp )
        implicit none

        integer,           intent(in) :: i,j,k
        double precision, dimension(-trajPtsMin:trajPtsMax,tattrs,dumpTraj_pktsize), intent(inout) :: traject_pool
        integer, intent(in) :: traject_id
        integer,           intent(in) :: trajMaxMinIds(2)
        integer(kind=8), intent(inout) :: mhist_omp(4,0:1000)
        integer :: jcorr_size3
        integer(kind=8), intent(inout) :: jcorr_omp(0:1000,0:1000,jcorr_size3)

        integer, automatic :: mflag1, mflag2
        double precision :: delta

        double precision, automatic :: trajMaxMinVec(3)
        double precision, automatic :: trajMaxMinVecLen
        double precision, automatic :: trajMaxMinVmm(2)
        double precision :: uvwmin, uvwmax

#ifndef _CUBIC_CELLS_
        integer, automatic :: ni, nj, nk
        double precision, automatic :: endx, endy, endz
        double precision ::trajxyz(2,3)
#endif

        ! could have attribute 'save' - no, must be thread-safe?
        logical, save :: init_done = .false.
        integer, save :: u_id
        integer, save :: v_id
        integer, save :: w_id
        double precision, save :: uvwscale
        double precision, save :: lenscale

        !$omp threadprivate(init_done)
        !$omp threadprivate(u_id)
        !$omp threadprivate(v_id)
        !$omp threadprivate(w_id)
        !$omp threadprivate(uvwscale)
        !$omp threadprivate(lenscale)

        ! trajectory must have 4 points minimum !
        if(trajMaxMinIds(1) -trajMaxMinIds(2) .lt. 3) return

        if( .not. init_done ) then

            ! calc histogram-scaling for delta(u)'s
            uvwmax =            vars_max(1)
            uvwmax = max(uvwmax,vars_max(2))
            uvwmax = max(uvwmax,vars_max(3))
            uvwmin =            vars_min(1)
            uvwmin = max(uvwmin,vars_min(2))
            uvwmin = max(uvwmin,vars_min(3))
            uvwscale = 1000.d0/(uvwmax -uvwmin)

            ! calc histogram-scaling for element lengths
#ifndef _CUBIC_CELLS_
            lenscale = 1000.d0/( (abs( coordx(1)-coordx(ndims(1)) ) + &
                                  abs( coordy(1)-coordy(ndims(2)) ) + &
                                  abs( coordz(1)-coordz(ndims(3)) ) )/3.d0)
#else
            lenscale = 1000.d0/ ((origdims(1) +origdims(2) +origdims(3))/3.d0)
#endif

            u_id = dEleTrajVars_offset +1
            v_id = dEleTrajVars_offset +2
            w_id = dEleTrajVars_offset +3

            init_done = .true.
       endif

#ifndef _CUBIC_CELLS_

        ! trajMaxEnd
            ni   = int(traject_pool(trajMaxMinIds(1),1,traject_id))
            nj   = int(traject_pool(trajMaxMinIds(1),2,traject_id))
            nk   = int(traject_pool(trajMaxMinIds(1),3,traject_id))
            endx = traject_pool(trajMaxMinIds(1),1,traject_id) -ni
            endy = traject_pool(trajMaxMinIds(1),2,traject_id) -nj
            endz = traject_pool(trajMaxMinIds(1),3,traject_id) -nk
            trajxyz(1,1) = coordx(ni) +endx*(coordx(ni+1)-coordx(ni))
            trajxyz(1,2) = coordy(nj) +endy*(coordy(nj+1)-coordy(nj))
            trajxyz(1,3) = coordz(nk) +endz*(coordz(nk+1)-coordz(nk))

        ! trajMinEnd
            ni   = int(traject_pool(trajMaxMinIds(2),1,traject_id))
            nj   = int(traject_pool(trajMaxMinIds(2),2,traject_id))
            nk   = int(traject_pool(trajMaxMinIds(2),3,traject_id))
            endx = traject_pool(trajMaxMinIds(2),1,traject_id) -ni
            endy = traject_pool(trajMaxMinIds(2),2,traject_id) -nj
            endz = traject_pool(trajMaxMinIds(2),3,traject_id) -nk
            trajxyz(2,1) = coordx(ni) +endx*(coordx(ni+1)-coordx(ni))
            trajxyz(2,2) = coordy(nj) +endy*(coordy(nj+1)-coordy(nj))
            trajxyz(2,3) = coordz(nk) +endz*(coordz(nk+1)-coordz(nk))

        ! calc unit-vector between min-max-extrempoints
        trajMaxMinVec(1) = trajxyz(2,1) -trajxyz(1,1)
        trajMaxMinVec(2) = trajxyz(2,2) -trajxyz(1,2)
        trajMaxMinVec(3) = trajxyz(2,3) -trajxyz(1,3)
#else

        ! calc unit-vector between max-min-extrempoints
        trajMaxMinVec(1) = traject_pool(trajMaxMinIds(2),1,traject_id) -traject_pool(trajMaxMinIds(1),1,traject_id)
        trajMaxMinVec(2) = traject_pool(trajMaxMinIds(2),2,traject_id) -traject_pool(trajMaxMinIds(1),2,traject_id)
        trajMaxMinVec(3) = traject_pool(trajMaxMinIds(2),3,traject_id) -traject_pool(trajMaxMinIds(1),3,traject_id)
#endif
        trajMaxMinVecLen = dsqrt(   trajMaxMinVec(1)**2    &
                                   +trajMaxMinVec(2)**2    &
                                   +trajMaxMinVec(3)**2 )
        if(abs(trajMaxMinVecLen) > 1.d-20) then
          trajMaxMinVec(1) = trajMaxMinVec(1) /trajMaxMinVecLen
          trajMaxMinVec(2) = trajMaxMinVec(2) /trajMaxMinVecLen
          trajMaxMinVec(3) = trajMaxMinVec(3) /trajMaxMinVecLen
        else
          trajMaxMinVec(1) = 0.d0
          trajMaxMinVec(2) = 0.d0
          trajMaxMinVec(3) = 0.d0
        end if

        ! calc velocity projected in min-max-extrempoint-direction
        trajMaxMinVmm(1) = traject_pool(trajMaxMinIds(1),u_id,traject_id) *trajMaxMinVec(1)   &
                          +traject_pool(trajMaxMinIds(1),v_id,traject_id) *trajMaxMinVec(2)   &
                          +traject_pool(trajMaxMinIds(1),w_id,traject_id) *trajMaxMinVec(3)
        trajMaxMinVmm(2) = traject_pool(trajMaxMinIds(2),u_id,traject_id) *trajMaxMinVec(1)   &
                          +traject_pool(trajMaxMinIds(2),v_id,traject_id) *trajMaxMinVec(2)   &
                          +traject_pool(trajMaxMinIds(2),w_id,traject_id) *trajMaxMinVec(3)

        !! save histograms for delta(umaxmin) = trajMaxMinVmm(1)-trajMaxMinVmm(2)
        !! save joined histogram for delta(umaxmin) and length
        !!!!!!!!!!!!!!!!!!!!!!!!!!
        delta = trajMaxMinVmm(2) -trajMaxMinVmm(1)

        mflag2 = trajMaxMinVecLen * lenscale + 0.5d0
        mflag2 = max(mflag2,0)
        mflag2 = min(mflag2,1000)

        if(delta >= 0.d0) then

          ! calc bucketid in histograms
          mflag1 = delta * uvwscale
          mflag1 = max(mflag1,0)
          mflag1 = min(mflag1,1000)

          ! histogram of plus-delta
          mhist_omp(3,mflag1) = mhist_omp(3,mflag1) +1

          ! joined histogram
          jcorr_omp(mflag1,mflag2,1) = jcorr_omp(mflag1,mflag2,1)
        else

          ! calc bucketid in histograms
          mflag1 = delta * uvwscale *-1
          mflag1 = max(mflag1,0)
          mflag1 = min(mflag1,1000)

          ! histogram of neg-delta
          mhist_omp(4,mflag1) = mhist_omp(4,mflag1) +1

          ! joined histogram
          jcorr_omp(mflag1,mflag2,2) = jcorr_omp(mflag1,mflag2,2)
        end if

    end subroutine analyTrajEndCond

!
!     --------------------------------------------------------
!
!     subroutine saveTrajCond()
!
!     --------------------------------------------------------
!
    subroutine saveTrajCond( corr_size3, jcorr_size3, corr, jcorr, mhist, corr_omp, jcorr_omp, mhist_omp, scalevars )
        use omp_lib
        implicit none

        integer, intent(in) :: corr_size3, jcorr_size3
        double precision, intent(inout) ::corr_omp(0:1000,-1:corr_size3), corr(0:1000,-1:corr_size3)
        integer(kind=8), intent(inout)  ::jcorr_omp(0:1000,0:1000,jcorr_size3), jcorr(0:1000,0:1000,jcorr_size3)
        integer(kind=8), intent(inout)  :: mhist_omp(4,0:1000), mhist(4,0:1000)
        double precision, intent(inout) :: scalevars(0:novars)

        integer :: i0, j0, c0, v
        double precision :: scalef
        character(len=128) :: filename
        character(len=1024) :: dataline, tmpline

        ! calc histogram-scaling for lengths
#ifndef _CUBIC_CELLS_
        scalef = 1000.d0/( (abs( coordx(1)-coordx(ndims(1)) ) +	&
                            abs( coordy(1)-coordy(ndims(2)) ) +	&
                            abs( coordz(1)-coordz(ndims(3)) ) )/3.d0)
#else
        scalef = 1000.d0/ ((origdims(1) +origdims(2) +origdims(3))/3.d0)
#endif

        ! only master thread ($omp master not allowed in parallel-section)
        if(OMP_get_thread_num() .eq. 0) then
          corr = 0.d0
          jcorr= 0.d0
          mhist = 0
        endif
        !$omp barrier

        !$omp critical
        corr = corr + corr_omp
        jcorr= jcorr +jcorr_omp
        mhist(1,:) = mhist(1,:) + mhist_omp(1,:)
        mhist(2,:) = mhist(2,:) + mhist_omp(2,:)
        !$omp end critical
        !$omp barrier

         ! only master thread ($omp master not allowed in parallel-section)
         if(OMP_get_thread_num() .eq. 0) then
            write(*,*) 'save traj_conds to disk ...'
!           c0 = 1
!           do i0=1, len(trim(input_dataset_path))
!         	if(input_dataset_path(i0:i0) == "/" .or. input_dataset_path(i0:i0) == "\") c0 = i0+1
!          enddo
!           write(filename, '(''res_'',i4.4,''_'',a,''.txt'')') fileid, input_dataset_path(c0:len(trim(input_dataset_path)))
           filename = 'traj_cond.txt'
           open(60,file=trim(filename), action='write')

           write(60,*) 'columns ',6+novars
           write(60,*) 'rows    ',1000+1
           write(60,*) 'column ',1,' = l'
           write(60,*) 'column ',2,' = delta12(v)'
           write(60,*) 'column ',3,' = delta12(psi)'
           write(60,*) 'column ',4,' = delta12(v*psi)'
           write(60,*) 'column ',5,' = delta12(v)*grad(psi1)*grad(psi2)'
           write(60,*) 'column ',6,' = sum12(v*grad(psi))'
           write(60,*) 'column ',7,' = sum12(v*(-varA))'
           do v=1, novars
             write(60,*) 'column ',7 +v, ' = delta12(', trim(vars_dataset_paths(v)),')'
           enddo

           do i0=0,1000
             write(dataline,'(7(es22.13))') i0/scalef,					&
                              corr(i0,1)/(corr(i0, 0)+1.d-20),	&	! sum(delta(v12))
                              corr(i0,2)/(corr(i0, 0)+1.d-20),	&	! sum(delta(psi12))
                              corr(i0,3)/(corr(i0, 0)+1.d-20),	&	! sum(delta(v12*psi12))
                              corr(i0,4)/(corr(i0, 0)+1.d-20),	&	! sum(delta(v12*grad(psi)))
                              corr(i0,5)/(corr(i0, 0)+1.d-20),	&	! sum(v1*grad1 +v2*grad2)
                              corr(i0,6)/(corr(i0, 0)+1.d-20)		! sum(v1*(-varA1) +v2*(-varA2) )
             do v=1, novars
                write(tmpline, '(es22.13)')  corr(i0,6+v)/(corr(i0,0)+1.d-20)
                dataline = trim(dataline)//'    '//tmpline 			! sum(delta(var12))
             enddo
             write(60,'(a)') trim(dataline)
           enddo
           close(60)

           filename = 'traj_joined.txt'
           open(61,file=trim(filename), action='write')
             write(61,*) 'i=0:1000, j=0:1000, vars=1:',novars
             write(61,*) 'x=i/',scalevars(0)
             do v = 1, novars
               write(61,*) 'v=',v,',  y=j/',scalevars(v)
             enddo
             do i0=0,1000
               do j0 = 0,1000
                 do v = 1, novars
                   write(61,'(i16)') jcorr(i0,j0,v)
                 enddo
               enddo
             enddo
           close(61)

!          write(filename, '(''pdf_'',i4.4,''_'',a,''.txt'')') fileid, input_dataset_path(c0:len(trim(input_dataset_path)))
           filename = 'trajlength_hist.txt'
           open(62,file=trim(filename),action='write')
           do i0=0,1000
            write(62,'(es22.13,i16,i16)') i0/scalef, mhist(1,i0), mhist(2,i0)
           enddo
           close(62)
           write(*,*) '...finished trajlength_hist.txt'

           filename = 'traj_arc.vs.short.txt'
           open(63,file=trim(filename), action='write')
            write(63,*) '% i = 0:1000, j = 0:1000'
            write(63,*) '% x=i/',scalef*5.d0
            write(63,*) '% y=j/',scalef*5.d0
             do i0=0,1000
               do j0 =0,1000
                 write(63,'(i16)') jcorr(i0,j0,novars+1)
               enddo
             enddo
           close(63)
           write(*,*) '...traj_arc.vs.short.txt'

         endif
        !$omp barrier

    end subroutine saveTrajCond

!
!     --------------------------------------------------------
!
!     subroutine saveTrajEndCond()
!
!     --------------------------------------------------------
!
    subroutine saveTrajEndCond( jcorr_size3, jcorr, mhist, jcorr_omp, mhist_omp)
        use omp_lib
        implicit none

        integer, intent(in) :: jcorr_size3
        integer(kind=8), intent(inout) :: jcorr(0:1000,0:1000,jcorr_size3), mhist(4,0:1000)
        integer(kind=8), intent(inout) :: jcorr_omp(0:1000,0:1000,jcorr_size3), mhist_omp(4,0:1000)

        integer :: i0, j0
        character(len=128) :: filename
        character(len=1024) :: dataline

        double precision :: uvwmin, uvwmax, uvwscale, lenscale

        ! calc histogram-scaling for delta(u)'s
            uvwmax =            vars_max(1)
            uvwmax = max(uvwmax,vars_max(2))
            uvwmax = max(uvwmax,vars_max(3))
            uvwmin =            vars_min(1)
            uvwmin = max(uvwmin,vars_min(2))
            uvwmin = max(uvwmin,vars_min(3))
            uvwscale = 1000.d0/(uvwmax -uvwmin)

        ! calc histogram-scaling for element lengths
#ifndef _CUBIC_CELLS_
            lenscale = 1000.d0/( (abs( coordx(1)-coordx(ndims(1)) ) + &
                                  abs( coordy(1)-coordy(ndims(2)) ) + &
                                  abs( coordz(1)-coordz(ndims(3)) ) )/3.d0)
#else
            lenscale = 1000.d0/ ((origdims(1) +origdims(2) +origdims(3))/3.d0)
#endif

        ! only master thread ($omp master not allowed in parallel-section)
        if(OMP_get_thread_num() .eq. 0) then
          mhist = 0
        endif
        !$omp barrier

        !$omp critical
         jcorr = jcorr + jcorr_omp
         mhist(3,:) = mhist(3,:) + mhist_omp(3,:)
         mhist(4,:) = mhist(4,:) + mhist_omp(4,:)
        !$omp end critical
        !$omp barrier

         ! only master thread ($omp master not allowed in parallel-section)
         if(OMP_get_thread_num() .eq. 0) then

           write(*,*) 'save traj_end_conds to disk ...'

           filename = 'traj_end_hist.txt'
           open(60,file=trim(filename), action='write')

           write(60,*) 'columns ',2
           write(60,*) 'rows    ',1000+1
           write(60,*) 'column  ',1,' = delta_u (positiv)'
           write(60,*) 'column  ',2,' = delta_u (negativ)'
           write(60,*) 'uvwmin  ',uvwmin
           write(60,*) 'uvwmax  ',uvwmax

           do i0=0,1000
             write(dataline,'(es22.13,i16,i16)') i0/uvwscale, &
                                                 mhist(3,i0), &    ! delta_u (positiv)
                                                 mhist(4,i0)       ! delta_u (negativ)

             write(60,'(a)') trim(dataline)
           enddo
           close(60)

           filename = 'traj_end_histjoined.txt'
           open(61,file=trim(filename), action='write')

           write(60,*) 'columns ',2
           write(60,*) 'rows    ',1000+1
           write(60,*) 'column  ',1,' = delta_u (positiv)'
           write(60,*) 'column  ',2,' = delta_u (negativ)'
           write(61,*) 'loop: i=0:1000, j=0:1000'
           write(61,*) 'x=i/',uvwscale
           write(61,*) 'y=j/',lenscale

           do i0=0,1000
             do j0 = 0,1000
                write(dataline,'(es22.13,es22.13,i16,i16)') i0/uvwscale, j0/lenscale, &
                                                            jcorr(i0,j0,1),           & ! delta_u (positiv)
                                                            jcorr(i0,j0,2)              ! delta_u (negativ)
                write(61,'(a)') trim(dataline)
             enddo
           enddo
           close(61)

         end if
        !$omp barrier

    end subroutine saveTrajEndCond

end module mod_postp
