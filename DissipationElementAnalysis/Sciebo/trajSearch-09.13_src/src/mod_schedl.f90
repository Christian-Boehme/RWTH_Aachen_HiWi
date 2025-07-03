!
! Copyright (C) 2010 by Institute of Combustion Technology - RWTH Aachen University
! Nicolas Berr
! All rights reserved.
!
#define VERBOSE 1

module mod_schedl
    implicit none
    save

    integer :: tpn, count, li
    integer, dimension(:), allocatable :: bfi,bli,bc

#ifdef VERBOSE
    integer :: count_all
    double precision :: tt_start
#endif

contains

!
!     ------------
!
!     init scheduler
!
!     ------------
!
    subroutine sched_init(firstindex, lastindex, threads_per_node)
      use omp_lib
      implicit none

      integer, intent(in) :: firstindex, lastindex, threads_per_node
      integer :: nodes
      integer :: bcount, bremain, bcount0
      integer :: i, ierr

      !$omp single
        nodes = omp_get_num_threads() /threads_per_node
        if (mod(omp_get_num_threads(),threads_per_node) .gt. 0) nodes = nodes +1

        allocate(bfi(nodes), stat=ierr)
        allocate(bli(0:nodes), stat=ierr)
        allocate(bc(nodes), stat=ierr)

        tpn = threads_per_node
        li = lastindex
        count = lastindex -firstindex +1
        bcount = count / nodes
        bremain = mod(count, nodes)
        bli(0) = firstindex -1

        do i=1, nodes
          bcount0 = bcount
          ! rest gleichmaessig verteilen
          if (bremain .gt. 0 ) then
            bcount0 = bcount0 +1
            bremain = bremain -1
          endif
          bfi(i) = bli(i-1) +1
          bli(i) = bfi(i) +bcount0 -1
          bc(i) = bcount0
        enddo

#ifdef VERBOSE
        call init_eta
#endif
      !$omp end single

  end subroutine

!
!     ------------
!
!     finish scheduler
!
!     ------------
!
  subroutine sched_fini()
      use omp_lib
      implicit none

      !$omp single
        deallocate(bfi)
        deallocate(bli)
        deallocate(bc)
      !$omp end single

  end subroutine sched_fini

!
!     ------------
!
!     next entry of scheduler
!
!     ------------
!
  integer function sched_next()
      use omp_lib
      implicit none

      integer :: target

      !$omp critical
        if (count .gt. 0 ) then

#ifdef VERBOSE
          if (mod(count_all - count + 1,512) .eq. 0) call print_eta
#endif
          target = omp_get_thread_num() / tpn +1
          ! can thread still work with thread-local blocks (kind of static-scheduling)?
          if (bc(target) .gt. 0) then
            ! take next block from the beginning
            sched_next = bfi(target)
            bfi(target) = bfi(target) +1
            bc(target) = bc(target) -1
          else
            ! sonst suche block mit den meissten unverteilten iterationen, dort von hinten bedienen
            target = maxloc(bc,1)
            sched_next = bli(target)
            bli(target) = bli(target) -1
            bc(target) = bc(target) -1
          endif
          count = count -1

        else
          sched_next = li +1
        endif
      !$omp end critical

      return
  end function sched_next

!
!     ------------
!
!     debugging functions
!
!     ------------
!
#ifdef VERBOSE
  subroutine init_eta
      use omp_lib
      implicit none

      tt_start = omp_get_wtime();
      count_all = count
  end subroutine init_eta

  subroutine print_eta()
      use omp_lib
      implicit none

      double precision :: tt_now, tt_togo
      integer h,m,s

      tt_now = omp_get_wtime() - tt_start
      tt_togo = tt_now * count / (count_all - count)
      s = mod(int(tt_togo), 60)
      tt_togo = tt_togo / 60
      m = mod(int(tt_togo), 60)
      h = tt_togo / 60
      write (*,*) "mod_schedl ETA [h,m,s]:", h, m, s
  end subroutine print_eta
#endif

end module mod_schedl
