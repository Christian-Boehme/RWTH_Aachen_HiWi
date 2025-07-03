!
! Copyright (C) 2005-2010 by  Institute of Combustion Technology - RWTH Aachen University
! Jens Henrik Goebbert, goebbert@itv.rwth-aachen.de (2007-2010)
! All rights reserved.
!

module mod_extras
    use mod_data
    implicit none
    save

    integer, allocatable :: eneighb(:)
    integer, allocatable :: eneighb_mpos(:)
    integer, allocatable :: eneighb_group(:)
    integer, allocatable :: edata(:,:)

    contains

!
!     --------------------------------------------------------
!
!     subroutine group_elements()
!
!     --------------------------------------------------------
!
subroutine group_elements(file_path_in, input_dataset_path_in, traj_group_path_in, error)
        use mod_io
        use hdf5
        use h5lt
        implicit none

        ! function vars
        character(len=*), intent(in)	:: file_path_in
        character(len=*), intent(inout)	:: input_dataset_path_in
        character(len=*), intent(in)	:: traj_group_path_in
        integer,intent(out)			:: error

        ! hd5 file vars
        integer(HID_T)		::	file_id
        integer(HID_T)		::	group0_id
        integer(HSIZE_T), dimension(2) :: dims2

        integer :: eneighb_pos, eneighb_size
        integer :: mpos, eid, gid, nid
        integer :: edomain(2,3)

        ! read data from hdf5
        call hdf5_read(file_path_in, input_dataset_path_in, traj_group_path_in, error)
        call hdf5_read_edata(file_path_in, traj_group_path_in, error)

        call h5fopen_f(file_path_in, H5F_ACC_RDONLY_F, file_id, error); if(error .ne. 0) goto 10
        call h5gopen_f(file_id, trim(traj_group_path_in), group0_id, error); if(error .ne. 0) goto 10
        allocate( edata(9,numpairs), stat=error ); if (error .ne. 0) goto 20
        dims2 = (/11,numpairs/)
        call h5LTread_dataset_f(group0_id, 'edata_dble', H5T_NATIVE_DOUBLE, edata, dims2, error); if(error .ne. 0) goto 10

        ! find neighbours of all elements
        write(*,*) ' find neighbours of all elements'
        eneighb_size = 100 *numpairs
        allocate( eneighb(eneighb_size), stat=error ); if (error .ne. 0) goto 20
        eneighb = 0
        allocate( eneighb_mpos(numpairs+1), stat=error ); if (error .ne. 0) goto 20
        eneighb_mpos(1) = 0
        mpos = 1
        do eid=1, numpairs
          edomain = pairdomain(eid,:,:)
          do nid=1, numpairs
            if(nid .eq. eid) cycle
            if( edomain(1,1) .gt. pairdomain(nid,1,1) .and.		&
                edomain(1,2) .gt. pairdomain(nid,1,2) .and.		&
                edomain(1,3) .gt. pairdomain(nid,1,3) .and.		&
                edomain(2,1) .lt. pairdomain(nid,2,1) .and.		&
                edomain(2,2) .lt. pairdomain(nid,2,2) .and.		&
                edomain(2,3) .lt. pairdomain(nid,2,3) ) then
                  eneighb( mpos ) = nid
                  mpos = mpos +1
            endif
            if(mpos .gt. eneighb_size) then
            	write(*,*) 'ERROR: eneighb() too small. eneighb() should be approximatly ',1.2 *(eneighb_size/eid*numpairs)
            	exit
            endif
          enddo
        enddo

        ! find groups of elements
        write(*,*) ' find groups of elements'
        allocate( eneighb_group(numpairs), stat=error ); if (error .ne. 0) goto 20
        eneighb_group = 0
        gid = 1
        do eid=1, numpairs
          if(eneighb_group(eid) .eq. 0) then
            eneighb_group(eid) = gid
            call group_neighb(eid,gid)
            gid = gid +1
          endif
        enddo

        write(*,*) 'number of groups: ',gid

        return

    10	continue
        write(*,*) 'error reading hdf5 file'
        stop

    20	continue
        write(*,*) 'error allocating memory'
        stop

end subroutine group_elements

!
!     --------------------------------------------------------
!
!     subroutine group_neighb()
!
!     --------------------------------------------------------
!
recursive subroutine group_neighb(eid,gid)
   implicit none

   integer,intent(in) :: eid, gid

   integer :: n, n_count, nid
   double precision :: emin, emax, nmin, nmax

   n_count = eneighb_mpos(eid+1) -eneighb_mpos(eid)
   emin    = edata(eid, 8)
   emax    = edata(eid, 9)
   do n=1, n_count
     nid = eneighb_mpos(eid+nid-1)
     nmin= edata(nid, 8)
     nmax= edata(nid, 9)
     if( abs(emin-nmin) .lt. (0.1 *abs(emin)) ) then
       eneighb_group(nid) = gid
       call group_neighb(nid,gid)
     endif
   enddo

end subroutine group_neighb

end module mod_extras
