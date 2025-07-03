!
! Copyright (C) 2005-2010 by  Institute of Combustion Technology - RWTH Aachen University
! Jens Henrik Goebbert, goebbert@itv.rwth-aachen.de (2007-2010)
! All rights reserved.
!

#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
#include "mod_psmb.h"
#endif

module mod_io
    use hdf5
    use mod_data
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
    use mod_psmb
#endif

    implicit none
    save

    contains

!
!     ------------
!
!     read in hdf5 data
!
!     ------------
!
    subroutine hdf5_trans2D(fi_hdf5, input_dataset_path, traj_group_path, error)
        use hdf5
        use h5lt
        implicit none

        ! function vars
        character(len=*), intent(in)	:: fi_hdf5
        character(len=*), intent(in)	:: input_dataset_path
        character(len=*), intent(in)	:: traj_group_path
        integer,intent(out)			    :: error

        ! hd5 file vars
        integer(HID_T)	::	file_id, group_id

        ! hd5 dataset vars
        integer(HSIZE_T), dimension(2) :: dims2, maxdims2
        integer(HSIZE_T), dimension(3) :: dims3, maxdims3
        integer(HSIZE_T), dimension(3) :: dims3_new
        integer(HID_T) :: did, dspace_id
        integer :: dset_error

        ! usual stuff
        integer :: i,j,k
        integer :: tmpdims2(2), tmpdims3(3)
        double precision, dimension(:,:,:), allocatable :: trans_in, trans_out
        double precision, dimension(:,:), allocatable :: tmp_psi
        error=0

    !
    !     open hd5-file
    !
        write(*,*) 'open hdf5-file'
        call h5fopen_f(fi_hdf5, H5F_ACC_RDWR_F, file_id, error); if(error .ne. 0) goto 10

    !
    !     scalar data
    !
        write(*,*) 'reading hdf5-file'

            ! read original dimensions
            call h5dopen_f(file_id, trim(input_dataset_path), did, error); if(error .ne. 0) goto 10
            call h5dget_space_f(did, dspace_id, error); if(error .ne. 0) goto 10
            call h5sget_simple_extent_ndims_f(dspace_id, spacedim, error); if(error .ne. 0) goto 10

            if(spacedim .ne. 2 .and. spacedim .ne. 3) then
                write(*,*) 'ERROR: input dataset must be 3D or 2D (not ',spacedim,')'
                stop
            endif
            if(spacedim .eq. 3) then
              call h5sget_simple_extent_dims_f(dspace_id, dims3, maxdims3, error); if(error .lt. 3) goto 10
            endif
            if(spacedim .eq. 2) then
              call h5sget_simple_extent_dims_f(dspace_id, dims2, maxdims2, error); if(error .ne. 2) goto 10
            endif

            call h5dclose_f(did, error); if(error .ne. 0) goto 10

            ! transform wrong dimension-format
            !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            if(spacedim .eq. 2 .or. dims3(1) .eq. 1 .or. dims3(2) .eq. 1) then

                write(*,*) 'TRANSFORM: 2D-dataset has to be transformed'

                ! transform dataset from wrong 3D-format to (x,y,1)
                if(spacedim .eq. 3) then

                  allocate(trans_in(dims3(1), dims3(2), dims3(3)), STAT=error); if(error.ne.0) goto 20
                  trans_in =0.d0
                  call h5LTread_dataset_f(file_id, trim(input_dataset_path), H5T_NATIVE_DOUBLE, trans_in, dims3, error); if(error .ne. 0) goto 10

                  ! copy/transform data
                  if(dims3(1) .eq. 1) then
                    write(*,*) '           transform to (y,z,1)'
                    dims3_new = (/dims3(2),dims3(3),int(1,HSIZE_T)/)
                    allocate(trans_out(dims3_new(1), dims3_new(2), dims3_new(3)), STAT=error); if(error.ne.0) goto 20
                    do k=1, dims3(3)
                      do j=1, dims3(2)
                        trans_out(j,k,1) = trans_in(1,j,k)
                      enddo
                    enddo
                  else if(dims3(2) .eq. 1) then
                    write(*,*) '           transform to (x,z,1)'
                    dims3_new = (/dims3(1),dims3(3),int(1,HSIZE_T)/)
                    allocate(trans_out(dims3_new(1), dims3_new(2), dims3_new(3)), STAT=error); if(error.ne.0) goto 20
                    do k=1, dims3(3)
                      do i=1, dims3(1)
                        trans_out(i,k,1) = trans_in(i,1,k)
                      enddo
                    enddo
                  endif

                  deallocate(trans_in)

                ! transform dataset from wrong 2D-format to (x,y,1)
                else if(spacedim .eq. 2) then

                  allocate(tmp_psi(dims2(1), dims2(2)), STAT=error); if(error.ne.0) goto 20
                  trans_in =0.d0
                  call h5LTread_dataset_f(file_id, trim(input_dataset_path), H5T_NATIVE_DOUBLE, tmp_psi, dims2, error); if(error .ne. 0) goto 10

                  ! copy/transform data
                  write(*,*) '           transform to (x,y,1)'
                  dims3_new = (/dims3(1),dims3(2),int(1,HSIZE_T)/)
                  allocate(trans_out(dims3_new(1), dims3_new(2), dims3_new(3)), STAT=error); if(error.ne.0) goto 20
                  do j=1, dims2(2)
                    do i=1, dims2(1)
                      trans_out(i,j,1) = tmp_psi(i,j)
                    enddo
                  enddo

                  deallocate(tmp_psi)

                else
                  write(*,*) 'INTERNAL ERROR'
                  stop
                endif

                ! save transformed data and reset the input_dataset_path
                write(*,*) '           saving data to ',trim(traj_group_path)//'/trans2D'
                call h5gopen_f(file_id, trim(traj_group_path), group_id, error); if(error .ne. 0) goto 10
                call h5LTmake_dataset_f(group_id, 'trans2D', 3, dims3_new, H5T_NATIVE_DOUBLE, trans_out, error); if(error .ne. 0) goto 10
                call h5gclose_f(group_id, error); if(error .ne. 0) goto 10

                deallocate(trans_out)

            endif

        ! close file
        call h5fclose_f(file_id, error); if(error .ne. 0) goto 10

        return

    10	continue
        write(*,*) 'error transforming hdf5 dataset'
        stop

    20	continue
        write(*,*) 'error allocating memory'
        stop

    end subroutine hdf5_trans2D

!
!     ------------
!
!     read in hdf5 data
!
!     ------------
!
    subroutine hdf5_read(fi_hdf5, input_dataset_path, traj_group_path, error)
        use hdf5
        use h5lt
        implicit none

        ! function vars
        character(len=*), intent(in)	:: fi_hdf5
        character(len=*), intent(in)	:: input_dataset_path
        character(len=*), intent(in)	:: traj_group_path
        integer,intent(out)			:: error

        ! hd5 file vars
        integer(HID_T)	::	file_id

        ! hd5 dataset vars
        integer(HSIZE_T), dimension(1) :: dims1, maxdims1
        integer(HSIZE_T), dimension(2) :: dims2, maxdims2
        integer(HSIZE_T), dimension(3) :: dims3, maxdims3
        integer(HID_T) :: did, dspace_id
        integer :: dset_error

        ! usual stuff
        integer :: i,j,k,v
        double precision :: tmpdble1(1)
        integer :: tmpdims2(2), tmpdims3(3)
        double precision, dimension(:,:,:), allocatable :: tmp_var3d
        double precision, dimension(:,:), allocatable :: tmp_var2d
        error=0

    !
    !     open hd5-file
    !
        write(*,*) 'open hdf5-file'
        call h5fopen_f(fi_hdf5, H5F_ACC_RDONLY_F, file_id, error); if(error .ne. 0) goto 10

    !
    !     scalar data
    !
        write(*,*) 'reading hdf5-file'

        ! read settings data

            ! read original dimensions
            call h5dopen_f(file_id, trim(input_dataset_path), did, error); if(error .ne. 0) goto 10
            call h5dget_space_f(did, dspace_id, error); if(error .ne. 0) goto 10
            call h5sget_simple_extent_ndims_f(dspace_id, spacedim, error); if(error .ne. 0) goto 10

            if(spacedim .ne. 3) then
                write(*,*) 'ERROR: input dataset must be 3D. 2D must get saved as (x,y,1).'
                write(*,*) '       Use phase 0 to transform.'
                stop
            endif

            call h5sget_simple_extent_dims_f(dspace_id, dims3, maxdims3, error); if(error .lt. 3) goto 10
            if(dims3(3) .eq. 1) spacedim = 2

            if(spacedim .eq. 3) then
                origdims(1) = dims3(1)
                origdims(2) = dims3(2)
                origdims(3) = dims3(3)
                ndims(1) = origdims(1)
                ndims(2) = origdims(2)
                ndims(3) = origdims(3)
                call h5dclose_f(did, error); if(error .ne. 0) goto 10

                ! read field dimensions
                call h5eset_auto_f(0, error)
                call h5dopen_f(file_id, trim(traj_group_path)//'/subdomain_minptr', did, dset_error)
                call h5eset_auto_f(1, error)
                if( dset_error .eq. 0) then
                    call h5dclose_f(did, error); if(error .ne. 0) goto 10
                    dims1 = (/3/)
                    call h5LTread_dataset_f(file_id, trim(traj_group_path)//'/subdomain_minptr', H5T_NATIVE_INTEGER, tmpdims3, dims1, error); if(error .ne. 0) goto 10
                    if(error .ne. 0) tmpdims3 = (/1,1,1/) !tmpdims =(/2,23,11/)
                    write(*,fmt='(A,A,A,3(i5))') '  reading "',trim(traj_group_path),'/subdomain_minptr" = ',tmpdims3
                else
                    tmpdims3 = (/1,1,1/)
                endif
                subdomain(1,1) = tmpdims3(1)
                subdomain(2,1) = tmpdims3(2)
                subdomain(3,1) = tmpdims3(3)

                call h5eset_auto_f(0, error)
                call h5dopen_f(file_id, trim(traj_group_path)//'/subdomain_maxptr', did, dset_error)
                call h5eset_auto_f(1, error)
                if( dset_error .eq. 0) then
                    call h5dclose_f(did, error); if(error .ne. 0) goto 10
                    dims1 = (/3/)
                    call h5LTread_dataset_f(file_id, trim(traj_group_path)//'/subdomain_maxptr', H5T_NATIVE_INTEGER, tmpdims3, dims1, error); if(error .ne. 0) goto 10
                    if(error .ne. 0) tmpdims3 = ndims !tmpdims=(/7,40,14/)
                    write(*,fmt='(A,A,A,3(i5))') '  reading "',trim(traj_group_path),'/subdomain_maxptr" = ',tmpdims3
                else
                    tmpdims3 = origdims
                endif
                subdomain(1,2) = tmpdims3(1)
                subdomain(2,2) = tmpdims3(2)
                subdomain(3,2) = tmpdims3(3)

                write(*,*) 'subdomain topLeft    : ', subdomain(1,1), subdomain(2,1), subdomain(3,1)
                write(*,*) 'subdomain bottomRight: ', subdomain(1,2), subdomain(2,2), subdomain(3,2)
                write(*,*) 'domain               : ', ndims(:)
                write(*,*) 'original domain      : ', origdims(:)
                write(*,*)

            else if(spacedim .eq. 2) then
                origdims(1) = dims3(1)
                origdims(2) = dims3(2)
                origdims(3) = 3
                ndims(1) = origdims(1)
                ndims(2) = origdims(2)
                ndims(3) = 3
                call h5dclose_f(did, error); if(error .ne. 0) goto 10

                ! read field dimensions
                call h5eset_auto_f(0, error)
                call h5dopen_f(file_id, trim(traj_group_path)//'/subdomain_minptr', did, dset_error)
                call h5eset_auto_f(1, error)
                if( dset_error .eq. 0) then
                    call h5dclose_f(did, error); if(error .ne. 0) goto 10
                    dims1 = (/2/)
                    call h5LTread_dataset_f(file_id, trim(traj_group_path)//'/subdomain_minptr', H5T_NATIVE_INTEGER, tmpdims2, dims1, error); if(error .ne. 0) goto 10
                    if(error .ne. 0) tmpdims2 = (/1,1/) !tmpdims =(/2,23/)
                    write(*,fmt='(A,A,A,2(i4))') '  reading "',trim(traj_group_path),'/subdomain_minptr" = ',tmpdims2
                else
                    tmpdims2 = (/1,1/)
                endif
                subdomain(1,1) = tmpdims2(1)
                subdomain(2,1) = tmpdims2(2)
                subdomain(3,1) = 1

                call h5eset_auto_f(0, error)
                call h5dopen_f(file_id, trim(traj_group_path)//'/subdomain_maxptr', did, dset_error)
                call h5eset_auto_f(1, error)
                if( dset_error .eq. 0) then
                    call h5dclose_f(did, error); if(error .ne. 0) goto 10
                    dims1 = (/2/)
                    call h5LTread_dataset_f(file_id, trim(traj_group_path)//'/subdomain_maxptr', H5T_NATIVE_INTEGER, tmpdims2, dims1, error); if(error .ne. 0) goto 10
                    if(error .ne. 0)then; tmpdims2(1) = ndims(1); tmpdims2(2) =ndims(2); endif!tmpdims=(/7,40/)
                    write(*,fmt='(A,A,A,2(i4))') '  reading "',trim(traj_group_path),'/subdomain_maxptr" = ',tmpdims2
                else
                    tmpdims2(1) = origdims(1)
                    tmpdims2(2) = origdims(2)
                endif
                subdomain(1,2) = tmpdims2(1)
                subdomain(2,2) = tmpdims2(2)
                subdomain(3,2) = 3

                write(*,*) 'subdomain topLeft    : ', subdomain(1,1), subdomain(2,1)
                write(*,*) 'subdomain bottomRight: ', subdomain(1,2), subdomain(2,2)
                write(*,*) 'domain               : ', ndims(1:2)
                write(*,*) 'original domain      : ', origdims(1:2)
                write(*,*)

            endif

            ! check subdomain
            if(subdomain(1,1)<1 .or. subdomain(1,2)>origdims(1) .or. (subdomain(1,1)+1)>(subdomain(1,2)-1)) goto 30
            if(subdomain(2,1)<1 .or. subdomain(2,2)>origdims(2) .or. (subdomain(2,1)+1)>(subdomain(2,2)-1)) goto 30
            if(subdomain(3,1)<1 .or. subdomain(3,2)>origdims(3) .or. (subdomain(3,1)+1)>(subdomain(3,2)-1)) goto 30

            call calc_memoryblocks(error)

        ! read field data

          ! read grid data
#ifndef _CUBIC_CELLS_
            dims1(1)=origdims(1)
            if(.not. allocated(coordx)) then
            	allocate(coordx(ndims(1)),STAT=error); if(error.ne.0) goto 20
            endif
            coordx(:)=0.d0
            call h5eset_auto_f(0, error)
            call h5dopen_f(file_id, trim(traj_group_path)//'/coordx', did, dset_error)
            call h5eset_auto_f(1, error)
            if( dset_error .ne. 0) then
               write(*,*) '  creating coordx'
               open(60,file='coordx.txt', action='write')
               do i=1,ndims(2)
                 coordx(i)= (i-0.5d0) *pi2/(ndims(1))
                 write(60,*) coordx(i)
               enddo
               close(60)
            else
               write(*,*) '  reading  ',trim(traj_group_path)//'/coordx'
               call h5dget_space_f(did, dspace_id, error); if(error .ne. 0) goto 10
               call h5sget_simple_extent_dims_f(dspace_id, dims1, maxdims1, error); if(error .ne. 1) goto 10
               if(dims1(1) .ne. ndims(1)) then
                  write(*,*) 'size(=',dims1(1),') of coordx does not fit to data-arrays(=',ndims(1),')'
                   stop
               endif
               call h5LTread_dataset_f(file_id, trim(traj_group_path)//'/coordx', H5T_NATIVE_DOUBLE, coordx, dims1, error); if(error .ne. 0) goto 10
               call h5dclose_f(did, error); if(error .ne. 0) goto 10
            endif
            do i=2, dims1(1)
              if(coordx(i) .le. coordx(i-1)) then
              	write(*,*) 'ERROR: coordx NOT in ascending order at id ',i
              	stop
              endif
            enddo

            dims1(1)=origdims(2)
            if(.not. allocated(coordy)) then
            	allocate(coordy(ndims(2)),STAT=error); if(error.ne.0) goto 20
            endif
            coordy(:)=0.d0
            call h5eset_auto_f(0, error)
            call h5dopen_f(file_id, trim(traj_group_path)//'/coordy', did, dset_error)
            call h5eset_auto_f(1, error)
            if( dset_error .ne. 0) then
               write(*,*) '  creating coordy'
               open(60,file='coordy.txt', action='write')
               do i=1,ndims(2)
                 coordy(i)=(i-0.5d0) *pi2 /ndims(2)
                 write(60,*) coordy(i)
               enddo
               close(60)
            else
               write(*,*) '  reading  ',trim(traj_group_path)//'/coordy'
               call h5dget_space_f(did, dspace_id, error); if(error .ne. 0) goto 10
               call h5sget_simple_extent_dims_f(dspace_id, dims1, maxdims1, error); if(error .ne. 1) goto 10
               if(dims1(1) .ne. ndims(2)) then
                   write(*,*) 'size(=',dims1(1),') of coordy does not fit to data-arrays(=',ndims(2),')'
                   stop
               endif
               call h5LTread_dataset_f(file_id, trim(traj_group_path)//'/coordy', H5T_NATIVE_DOUBLE, coordy, dims1, error); if(error .ne. 0) goto 10
               call h5dclose_f(did, error); if(error .ne. 0) goto 10
            endif
            do j=2, dims1(1)
              if(coordy(j) .le. coordy(j-1)) then
              	write(*,*) 'ERROR: coordy NOT in ascending order at id ', j
              	stop
              endif
            enddo

            dims1(1)=origdims(3)
            if(.not. allocated(coordz)) then
            	allocate(coordz(ndims(3)),STAT=error); if(error.ne.0) goto 20
            endif
            coordz(:)=0.d0
            call h5eset_auto_f(0, error)
            call h5dopen_f(file_id, trim(traj_group_path)//'/coordz', did, dset_error)
            call h5eset_auto_f(1, error)
            if( dset_error .ne. 0) then
               write(*,*) '  creating coordz'
               open(60,file='coordz.txt', action='write')
               do i=1,ndims(3)
                 coordz(i)=(i-0.5d0) *pi2 /ndims(3)
                 write(60,*) coordz(i)
               enddo
               close(60)
            else
               write(*,*) '  reading  ',trim(traj_group_path)//'/coordz'
               call h5dget_space_f(did, dspace_id, error); if(error .ne. 0) goto 10
               call h5sget_simple_extent_dims_f(dspace_id, dims1, maxdims1, error); if(error .ne. 1) goto 10
               if(dims1(1) .ne. ndims(3)) then
                   write(*,*) 'size(=',dims1(1),') of coordz does not fit to data-arrays(=',ndims(3),')'
                   stop
               endif
               call h5LTread_dataset_f(file_id, trim(traj_group_path)//'/coordz', H5T_NATIVE_DOUBLE, coordz, dims1, error); if(error .ne. 0) goto 10
               call h5dclose_f(did, error); if(error .ne. 0) goto 10
            endif
            if(coordz(1) .gt. coordz(2)) then
               write(*,*) 'ERROR: coordz NOT in ascending order.'
               do k=1, ndims(3)
                  coordz(k) = coordz(k) *(-1.d0)
                  write(*,*) '  coordz(',k,') = ',coordz(k)
                  coordz_switch = .true.
               enddo
            endif
#else
                ! read Lx dimensions
                call h5eset_auto_f(0, error)
                call h5dopen_f(file_id, trim(traj_group_path)//'/Lx', did, dset_error)
                call h5eset_auto_f(1, error)
                if( dset_error .eq. 0) then
                    call h5dclose_f(did, error); if(error .ne. 0) goto 10
                    dims1 = (/1/)
                    call h5LTread_dataset_f(file_id, trim(traj_group_path)//'/Lx', H5T_NATIVE_DOUBLE, tmpdble1, dims1, error); if(error .ne. 0) goto 10
                    if(error .ne. 0) tmpdble1 = (/pi2/)
                    write(*,*) '  reading "',trim(traj_group_path),'/Lx" = ',tmpdble1(1)
                else
                    tmpdble1 = (/pi2/)
                endif
                Lx = tmpdble1(1)
                ! read Lx,Ly,Lz dimensions
                call h5eset_auto_f(0, error)
                call h5dopen_f(file_id, trim(traj_group_path)//'/Ly', did, dset_error)
                call h5eset_auto_f(1, error)
                if( dset_error .eq. 0) then
                    call h5dclose_f(did, error); if(error .ne. 0) goto 10
                    dims1 = (/1/)
                    call h5LTread_dataset_f(file_id, trim(traj_group_path)//'/Ly', H5T_NATIVE_DOUBLE, tmpdble1, dims1, error); if(error .ne. 0) goto 10
                    if(error .ne. 0) tmpdble1 = (/pi2/)
                    write(*,*) '  reading "',trim(traj_group_path),'/Ly" = ',tmpdble1(1)
                else
                    tmpdble1 = (/pi2/)
                endif
                Ly = tmpdble1(1)
                ! read Lx,Ly,Lz dimensions
                call h5eset_auto_f(0, error)
                call h5dopen_f(file_id, trim(traj_group_path)//'/Lz', did, dset_error)
                call h5eset_auto_f(1, error)
                if( dset_error .eq. 0) then
                    call h5dclose_f(did, error); if(error .ne. 0) goto 10
                    dims1 = (/1/)
                    call h5LTread_dataset_f(file_id, trim(traj_group_path)//'/Lz', H5T_NATIVE_DOUBLE, tmpdble1, dims1, error); if(error .ne. 0) goto 10
                    if(error .ne. 0) tmpdble1 = (/pi2/)
                    write(*,*) '  reading "',trim(traj_group_path),'/Lz" = ',tmpdble1(1)
                else
                    tmpdble1 = (/pi2/)
                endif
                Lz = tmpdble1(1)
#endif
!		  ! read scalar data field
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
            call allocate_globals('psi_b',error); if(error.ne.0) goto 20
#else
            if(associated(psi)) deallocate(psi)
            call allocate_globals('psi',error); if(error.ne.0) goto 20
#endif
            write(*,*) '  reading  ',trim(input_dataset_path)
            if(spacedim .eq. 3) then
                allocate(tmp_var3d(ndims(1), ndims(2), ndims(3)), STAT=error); if(error.ne.0) goto 20
                dims3 =(/ndims(1),ndims(2),ndims(3)/)
                call h5LTread_dataset_f(file_id, trim(input_dataset_path), H5T_NATIVE_DOUBLE, tmp_var3d, dims3, error); if(error .ne. 0) goto 10
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
                call spread_dble3dto3d(tmp_var3d, psi_b)
#else
                call spread_dble3dto3d(tmp_var3d, psi) ! psi must not be touched yet !
#endif
                deallocate(tmp_var3d)
            else if(spacedim .eq. 2) then
                allocate(tmp_var3d(ndims(1), ndims(2), ndims(3)), STAT=error); if(error.ne.0) goto 20
                dims2 =(/ndims(1),ndims(2)/)
                allocate(tmp_var2d(ndims(1), ndims(2)), STAT=error); if(error.ne.0) goto 20
                call h5LTread_dataset_f(file_id, trim(input_dataset_path), H5T_NATIVE_DOUBLE, tmp_var2d, dims2, error); if(error .ne. 0) goto 10
                tmp_var3d =0.d0
                do k=1, 3
                    tmp_var3d(:,:,k) = tmp_var2d(:,:)
                enddo
                deallocate(tmp_var2d)
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
                call spread_dble3dto3d(tmp_var3d, psi_b)
#else
                call spread_dble3dto3d(tmp_var3d, psi) ! psi must not be touched yet !
#endif
                deallocate(tmp_var3d)
            endif

            ! read additional data field
              if(spacedim .eq. 3) then
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
                  psmb_alloc_4d(vars_b,ndims(1),ndims(2),ndims(3),novars,8_8)
#else
                  if(associated(vars)) deallocate(vars)
                  allocate(vars(ndims(1),ndims(2),ndims(3),novars),STAT=error); if(error.ne.0) goto 20
#endif
                  dims3 =(/ndims(1),ndims(2),ndims(3)/)
                  if(allocated(tmp_var3d)) deallocate(vars)
                  allocate(tmp_var3d(ndims(1), ndims(2), ndims(3)), STAT=error); if(error.ne.0) goto 20
                  allocate(vars_max(novars), STAT=error); if(error.ne.0) goto 20
                  allocate(vars_min(novars), STAT=error); if(error.ne.0) goto 20
                  do v=1, novars
                    write(*,*) '  reading  ',trim(vars_dataset_paths(v))
                    call h5LTread_dataset_f(file_id, trim(vars_dataset_paths(v)), H5T_NATIVE_DOUBLE, tmp_var3d, dims3, error); if(error .ne. 0) goto 10
                    vars_max(v) = maxval(tmp_var3d)
                    vars_min(v) = minval(tmp_var3d)
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
                    call spread_dble3dto4d( tmp_var3d, vars_b, v) ! vars must not be touched yet !
                    !write(*,*) 'test var ',v,': 1,1,1 -- ',psmb_arr_4d(vars_b,1,1,1,v)
#else
                    call spread_dble3dto4d( tmp_var3d, vars, v) ! vars must not be touched yet !
#endif
                  enddo
                  deallocate(tmp_var3d)
              else if(spacedim .eq. 2) then
                  if(associated(vars)) deallocate(vars)
                  allocate(vars(ndims(1),ndims(2),3,novars),STAT=error); if(error.ne.0) goto 20
                  dims2 =(/ndims(1),ndims(2)/)
                  allocate(tmp_var2d(ndims(1), ndims(2)), STAT=error); if(error.ne.0) goto 20
                  allocate(tmp_var3d(ndims(1), ndims(2), ndims(3)), STAT=error); if(error.ne.0) goto 20
                  do v=1, novars
                    write(*,*) '  reading  ',trim(vars_dataset_paths(v))
                    call h5LTread_dataset_f(file_id, trim(vars_dataset_paths(v)), H5T_NATIVE_DOUBLE, tmp_var2d, dims2, error); if(error .ne. 0) goto 10
                    vars_max(v) = maxval(tmp_var2d)
                    vars_min(v) = minval(tmp_var2d)
                    tmp_var3d = 0.d0
                    do k=1, 3
                      tmp_var3d(:,:,k) = tmp_var2d(:,:)
                    enddo
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
                    call spread_dble3dto4d( tmp_var3d, vars_b, v) ! vars must not be touched yet !
#else
                    call spread_dble3dto4d( tmp_var3d, vars, v) ! vars must not be touched yet !
#endif
                  enddo
                  deallocate(tmp_var3d)
                  deallocate(tmp_var2d)
              endif

        ! close file
        call h5fclose_f(file_id, error); if(error .ne. 0) goto 10

        return

    10	continue
        write(*,*) 'error reading hdf5 file'
        stop

    20	continue
        write(*,*) 'error allocating memory'
        stop

    30	continue
        write(*,*) 'subdomain error'
        stop

    end subroutine hdf5_read

!
!     -----------
!
!     read trajcount-informations in hd5 format
!
!     -----------
!
    subroutine hdf5_read_trajcount(fi_hdf5, traj_group_path, error)
        use hdf5
        use h5lt
        implicit none

        ! function vars
        character(len=*), intent(in)	:: fi_hdf5, traj_group_path
        integer,intent(out)			:: error

        ! hd5 file vars
        integer(HID_T)		::	file_id
        integer(HID_T)		::	group0_id
        integer(HSIZE_T), dimension(3) :: dims3

        integer, dimension(:,:,:), allocatable :: tmp_int3d

    !
    !     open hd5-file
    !
        call h5fopen_f(fi_hdf5, H5F_ACC_RDONLY_F, file_id, error); if(error .ne. 0) goto 10
        call h5gopen_f(file_id, trim(traj_group_path), group0_id, error); if(error .ne. 0) goto 10

!		  ! read scalar data field 'trajcount'
            write(*,*) '  reading ',trim(traj_group_path),'/trajcount'
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
            call allocate_globals('trajcount_b',error); if(error.ne.0) goto 20
#else
            if(allocated(trajcount)) deallocate(trajcount)
            call allocate_globals('trajcount',error); if(error.ne.0) goto 20
#endif
            write(*,*) '  reading ',trim(traj_group_path),'/trajcount'
            allocate(tmp_int3d(ndims(1), ndims(2), ndims(3)), STAT=error); if(error.ne.0) goto 20
            if(spacedim .eq. 3) then
                dims3 =(/ndims(1),ndims(2),ndims(3)/)
                call h5LTread_dataset_f(group0_id, 'trajcount', H5T_NATIVE_INTEGER, tmp_int3d, dims3, error); if(error .ne. 0) goto 10
            else if(spacedim .eq. 2) then
                tmp_int3d = 0
                dims3 = (/ndims(1),ndims(2),1/)
                call h5LTread_dataset_f(group0_id, 'trajcount', H5T_NATIVE_INTEGER, tmp_int3d(:,:,2), dims3, error); if(error .ne. 0) goto 10
            endif
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
            call spread_int3dto3d(tmp_int3d, trajcount_b) ! trajcount_b must not be touched yet !
#else
            call spread_int3dto3d(tmp_int3d, trajcount) ! trajcount must not be touched yet !
#endif
            deallocate(tmp_int3d)

        call h5gclose_f(group0_id, error); if(error .ne. 0) goto 10
        call h5fclose_f(file_id, error); if(error .ne. 0) goto 10

        return

    10	continue
        write(*,*) 'error reading hdf5 file'
        stop

    20	continue
        write(*,*) 'error allocating memory'
        stop

    end subroutine hdf5_read_trajcount

!
!     -----------
!
!     write trajcount-informations in hd5 format
!
!     -----------
!
    subroutine hdf5_write_trajcount(fo_hdf5,traj_group_path, error)
        use hdf5
        use h5lt
        implicit none

        ! function vars
        character(len=*), intent(in)	:: fo_hdf5, traj_group_path
        integer,intent(out)			:: error

        ! hd5 file vars
        integer(HID_T)		::	file_id
        integer(HID_T)		::	group0_id

!		! hd5 dataset vars
        integer(HSIZE_T), dimension(3) :: dims3

        call h5fopen_f(fo_hdf5, H5F_ACC_RDWR_F, file_id, error); if(error .ne. 0) goto 10
        call h5gopen_f(file_id, trim(traj_group_path), group0_id, error); if(error .ne. 0) goto 10

        if(.not. allocated(trajcount)) then
        	write(*,*) 'ERROR in hdf5_write_trajcount(..)'
        	write(*,*) '        no trajcount[] available '
        	return
        endif

        ! write number of trajectories crossing a staggered grid-cell
            write(*,*) '  writing ',trim(traj_group_path),'/trajcount'
            if(spacedim .eq. 3) then
                dims3 =(/ndims(1),ndims(2),ndims(3)/)
                call h5LTmake_dataset_f(group0_id, 'trajcount', 3, dims3, H5T_NATIVE_INTEGER, trajcount, error)
                if(error .ne. 0) goto 10
            else if(spacedim .eq. 2) then
                dims3 = (/ndims(1),ndims(2),1/)
                call h5LTmake_dataset_f(group0_id, 'trajcount', 3, dims3, H5T_NATIVE_INTEGER, trajcount(:,:,2), error)
                if(error .ne. 0) goto 10
            endif

        call h5gclose_f(group0_id, error); if(error .ne. 0) goto 10
        call h5fclose_f(file_id, error); if(error .ne. 0) goto 10

        return

    10	continue
        write(*,*) 'error writing hdf5 file'
        return

    20	continue
        write(*,*) 'error allocating memory'
        stop

    end subroutine hdf5_write_trajcount

!
!     -----------
!
!     read element-informations in hd5 format
!			ecount    -> numpairs
!			eid       -> note
!			edata_int   -> pairdomain
!			edata_int   -> pairing
!			emin/emax -> points
!
!     -----------
!
    subroutine hdf5_read_edata(fi_hdf5, traj_group_path, error)
        use hdf5
        use h5lt
        implicit none

        ! function vars
        character(len=*), intent(in)	:: fi_hdf5, traj_group_path
        integer,intent(out)			:: error

        ! usual stuff
        integer :: i,j,k, eid, mms, mmid
        integer, dimension(1)	:: int1_buf
        integer, dimension(:,:), allocatable :: edata_int
        double precision, dimension(:,:), allocatable :: tmp_minmax_pos
        integer, dimension(:), allocatable            :: tmp_minmax_type

        integer, dimension(:,:,:), allocatable :: tmp_int3d

        ! hd5 file vars
        integer(HID_T)		::	file_id
        integer(HID_T)		::	group0_id
        integer(HSIZE_T), dimension(1) :: dims1
        integer(HSIZE_T), dimension(2) :: dims2
        integer(HSIZE_T), dimension(3) :: dims3
        integer(HSIZE_T), dimension(3) :: maxdims2
        integer(HID_T) :: did, dspace_id

    !
    !     open hd5-file
    !
        call h5fopen_f(fi_hdf5, H5F_ACC_RDONLY_F, file_id, error); if(error .ne. 0) goto 10
        call h5gopen_f(file_id, trim(traj_group_path), group0_id, error); if(error .ne. 0) goto 10

!		  ! read scalar data field 'ecount' to 'numpairs'
            write(*,*) '  reading ',trim(traj_group_path),'/ecount'
            dims1 = (1)
            call h5LTread_dataset_f(group0_id, 'ecount', H5T_NATIVE_INTEGER, int1_buf, dims1, error); if(error .ne. 0) goto 10
            numpairs = int1_buf(1)

!		  ! read scalar data field 'eid' to 'note'
            write(*,*) '  reading ',trim(traj_group_path),'/eid'
            call allocate_globals('note',error)
            note = 0
            if(spacedim .eq. 3) then
                dims3 =(/ndims(1),ndims(2),ndims(3)/)
                call h5LTread_dataset_f(group0_id, 'eid', H5T_NATIVE_INTEGER, note, dims3, error); if(error .ne. 0) goto 10
            else if(spacedim .eq. 2) then
                dims3 = (/ndims(1),ndims(2),1/)
                call h5LTread_dataset_f(group0_id, 'eid', H5T_NATIVE_INTEGER, note(:,:,2), dims3, error); if(error .ne. 0) goto 10
                if(error .ne. 0) goto 10
            endif

!		  ! read scalar data field 'edata_int' and copy infos to 'pairing' and 'pairdomain'
            write(*,*) '  reading ',trim(traj_group_path),'/edata_int'
            call allocate_globals('pairing',error)
            pairing = 0
            call allocate_globals('pairdomain',error)
            pairdomain = 0
            allocate( edata_int(9,numpairs),stat=error ); if(error.ne.0) goto 20
            dims2 = (/9,numpairs/)
            call h5LTread_dataset_f(group0_id, 'edata_int', H5T_NATIVE_INTEGER, edata_int, dims2, error); if(error .ne. 0) goto 10
            do eid=1, numpairs
                pairdomain(eid,1,1) = edata_int(1, eid)
                pairdomain(eid,1,2) = edata_int(2, eid)
                if(spacedim .eq. 2) then; pairdomain(eid,1,3) = 2
                else;                      pairdomain(eid,1,3) = edata_int(3, eid)
                endif
                pairdomain(eid,2,1) = edata_int(4, eid)
                pairdomain(eid,2,2) = edata_int(5, eid)
                if(spacedim .eq. 2) then; pairdomain(eid,2,3) = 2
                else;                      pairdomain(eid,2,3) = edata_int(6, eid)
                endif
                pairing(eid,1)      = edata_int(7, eid)
                pairing(eid,2)      = edata_int(8, eid)
                pairing(eid,3)      = edata_int(9, eid)
            enddo
            deallocate( edata_int )

          ! read scalar data field 'minmax_pos' to 'points'
            write(*,*) '  reading ',trim(traj_group_path),'/minmax_pos'
            call h5dopen_f(file_id, trim(traj_group_path)//'/minmax_pos', did, error); if(error .ne. 0) goto 10
            call h5dget_space_f(did, dspace_id, error); if(error .ne. 0) goto 10
            call h5sget_simple_extent_dims_f(dspace_id, dims2, maxdims2, error); if(error .ne. 2) goto 10
            mms = dims2(2)
            numends = mms
            call allocate_globals('readin_points',error)
            readin_points = 0
            allocate( tmp_minmax_pos(3,mms),stat=error ); if(error.ne.0) goto 20
            call h5LTread_dataset_f(group0_id, 'minmax_pos', H5T_NATIVE_DOUBLE, tmp_minmax_pos, dims2, error); if(error .ne. 0) goto 10
            do mmid=1, mms
                readin_points(mmid,1) = tmp_minmax_pos(1,mmid)
                readin_points(mmid,2) = tmp_minmax_pos(2,mmid)
                readin_points(mmid,3) = tmp_minmax_pos(3,mmid)
                if(spacedim .eq. 2) readin_points(mmid,3) = 2.d0
            enddo
            deallocate( tmp_minmax_pos )
            call h5dclose_f(did,error)

!		  ! read scalar data field 'minmax_type' to 'signs'
            write(*,*) '  reading ',trim(traj_group_path),'/minmax_type'
            dims1 = (/mms/)
            call allocate_globals('signs',error)
            signs = .false.
            allocate( tmp_minmax_type(mms),stat=error ); if(error.ne.0) goto 20
            call h5LTread_dataset_f(group0_id, 'minmax_type', H5T_NATIVE_INTEGER, tmp_minmax_type, dims1, error); if(error .ne. 0) goto 10
            do mmid=1,mms
                if(tmp_minmax_type(mmid) .eq. +1 ) signs(mmid) = .true.
                if(tmp_minmax_type(mmid) .eq. -1 ) signs(mmid) = .false.
            enddo
            deallocate( tmp_minmax_type )

#if (_TRAJCOUNT_>0)
!		  ! read scalar data field
            write(*,*) '  reading ',trim(traj_group_path),'/trajcount'
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
            call allocate_globals('trajcount_b',error); if(error.ne.0) goto 20
#else
            if(allocated(trajcount)) deallocate(trajcount)
            call allocate_globals('trajcount',error); if(error.ne.0) goto 20
#endif
            allocate(tmp_int3d(ndims(1), ndims(2), ndims(3)), STAT=error); if(error.ne.0) goto 20
            if(spacedim .eq. 3) then
                dims3 =(/ndims(1),ndims(2),ndims(3)/)
                call h5LTread_dataset_f(group0_id, 'trajcount', H5T_NATIVE_INTEGER, tmp_int3d, dims3, error); if(error .ne. 0) goto 10
            else if(spacedim .eq. 2) then
                tmp_int3d = 0
                dims3 = (/ndims(1),ndims(2),1/)
                call h5LTread_dataset_f(group0_id, 'trajcount', H5T_NATIVE_INTEGER, tmp_int3d(:,:,2), dims3, error); if(error .ne. 0) goto 10
            endif
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
            call spread_int3dto3d(tmp_int3d, trajcount_b) ! trajcount_b must not be touched yet !
#else
            call spread_int3dto3d(tmp_int3d, trajcount) ! trajcount must not be touched yet !
#endif
            deallocate(tmp_int3d)

#endif

        call h5gclose_f(group0_id, error); if(error .ne. 0) goto 10
        call h5fclose_f(file_id, error); if(error .ne. 0) goto 10

        return

    10	continue
        write(*,*) 'error reading hdf5 file'
        stop

    20	continue
        write(*,*) 'error allocating memory'
        stop

    end subroutine hdf5_read_edata

!
!     -----------
!
!     write element-informations in hd5 format
!			numpairs    -> ecount
!			note        -> eid
!			pairdomain  -> edata_int(1-6)
!			pairing(1/2)-> edata_int(7,8)
!			points      -> emin/emax
!			pairing(3)  -> ecells
!
!     -----------
!
    subroutine hdf5_write_edata(fo_hdf5,traj_group_path, error)
        use hdf5
        use h5lt
        implicit none

        ! function vars
        character(len=*), intent(in)	:: fo_hdf5, traj_group_path
        integer,intent(out)			:: error

        ! hd5 file vars
        integer(HID_T)		::	file_id
        integer(HID_T)		::	group0_id
        integer(HID_T)		::	did
!
!		! hd5 attribute vars
!		double precision, dimension(1)	:: double_buf(1)
        integer, dimension(1)	:: int1_buf

!		! hd5 dataset vars
        integer(HSIZE_T), dimension(1) :: dims1
        integer(HSIZE_T), dimension(2) :: dims2
        integer(HSIZE_T), dimension(3) :: dims3

!		! usual stuff
        integer :: i,j,k, eid, mins, maxs, mms, mmid, dset_error
        double precision :: maxvalue, minvalue
        integer, dimension(:,:), allocatable :: edata_int
        double precision, dimension(:,:), allocatable :: edata_dble
        double precision, dimension(:,:,:), allocatable :: egpts, edelta
        double precision, dimension(:,:), allocatable :: tmp_minmax_pos
        double precision, dimension(:), allocatable   :: tmp_minmax_val
        integer, dimension(:), allocatable             :: tmp_minmax_type

        double precision :: posx, posy, posz

        call h5fopen_f(fo_hdf5, H5F_ACC_RDWR_F, file_id, error); if(error .ne. 0) goto 10
        call h5gopen_f(file_id, trim(traj_group_path), group0_id, error); if(error .ne. 0) goto 10

        allocate( edata_int(9,numpairs),stat=error ); if(error.ne.0) goto 20
        allocate( edata_dble(11,numpairs),stat=error ); if(error.ne.0) goto 20

#ifndef _CUBIC_CELLS_
!		  ! write 'coordxyz' if non existant
           call h5eset_auto_f(0, error)
           call h5dopen_f(file_id, trim(traj_group_path)//'/coordx', did, dset_error)
           call h5eset_auto_f(1, error)
           if( dset_error .ne. 0) then
             write(*,*) '  writing ',trim(traj_group_path),'/coordx'
             dims1 = (size(coordx,1))
             call h5LTmake_dataset_f(group0_id, 'coordx', 1, dims1, H5T_NATIVE_DOUBLE, coordx, error); if(error .ne. 0) goto 10
           endif
           call h5eset_auto_f(0, error)
           call h5dopen_f(file_id, trim(traj_group_path)//'/coordy', did, dset_error)
           call h5eset_auto_f(1, error)
           if( dset_error .ne. 0) then
             write(*,*) '  writing ',trim(traj_group_path),'/coordy'
             dims1 = (size(coordy,1))
             call h5LTmake_dataset_f(group0_id, 'coordy', 1, dims1, H5T_NATIVE_DOUBLE, coordy, error); if(error .ne. 0) goto 10
           endif
           call h5eset_auto_f(0, error)
           call h5dopen_f(file_id, trim(traj_group_path)//'/coordz', did, dset_error)
           call h5eset_auto_f(1, error)
           if( dset_error .ne. 0) then
             write(*,*) '  writing ',trim(traj_group_path),'/coordz'
             dims1 = (size(coordz,1))
             call h5LTmake_dataset_f(group0_id, 'coordz', 1, dims1, H5T_NATIVE_DOUBLE, coordy, error); if(error .ne. 0) goto 10
           endif
#endif

!		  ! write 'numpairs' to scalar data field 'ecount'
            write(*,*) '  writing ',trim(traj_group_path),'/ecount =', numpairs
            dims1 = (1)
            int1_buf(1) = numpairs
            call h5LTmake_dataset_f(group0_id, 'ecount', 1, dims1, H5T_NATIVE_INTEGER, int1_buf, error)
            if(error .ne. 0) goto 10

!		  ! write 'note' to scalar data field 'eid'
            if(allocated(note)) then
                write(*,*) '  writing ',trim(traj_group_path),'/eid'
                if(spacedim .eq. 3) then
                    dims3 = (/ndims(1),ndims(2),ndims(3)/)
                    call h5LTmake_dataset_f(group0_id, 'eid', 3, dims3, H5T_NATIVE_INTEGER, note, error)
                    if(error .ne. 0) goto 10
                else if(spacedim .eq. 2) then
                    dims3 = (/ndims(1),ndims(2),1/)
                    call h5LTmake_dataset_f(group0_id, 'eid', 3, dims3, H5T_NATIVE_INTEGER, note(:,:,2), error)
                    if(error .ne. 0) goto 10
                endif
            endif

!		  ! write 'pairdomain'/'pairing' to 'edata_int'
            if(allocated(pairdomain) .and. allocated(pairing)) then
                do eid=1, numpairs
                    edata_int(1, eid) = pairdomain(eid,1,1)
                    edata_int(2, eid) = pairdomain(eid,1,2)
                    if(spacedim .eq. 2) then; edata_int(3, eid) = 1
                    else;                      edata_int(3, eid) = pairdomain(eid,1,3)
                    endif
                    edata_int(4, eid) = pairdomain(eid,2,1)
                    edata_int(5, eid) = pairdomain(eid,2,2)
                    if(spacedim .eq. 2) then; edata_int(6, eid) = 1
                    else;                      edata_int(6, eid) = pairdomain(eid,2,3)
                    endif
                    edata_int(7, eid) = pairing(eid,1)	    ! localMinId-1
                    edata_int(8, eid) = pairing(eid,2)  	! localMaxId-1
                    edata_int(9, eid) = pairing(eid,3)  	! number of grid-points
                enddo
            endif

!		  ! write 'points' to 'minmax_pos'
            mms = numends
            if(allocated(points)) then
                write(*,*) '  writing ',trim(traj_group_path),'/minmax_pos'
!                mms = 0
!                do eid=1, numpairs
!                    if(pairing(eid,1) .gt. mms) mms = pairing(eid,1)
!                    if(pairing(eid,2) .gt. mms) mms = pairing(eid,2)
!                end do
!                if(mms .ne. numends) then
!                  write(*,*) 'ERROR'
!                  write(*,*) 'ERROR calc no. minmax points in hdf5_write_edata()'
!                  write(*,*) 'ERROR mms != numends:',mms,numends
!                  write(*,*) 'ERROR'
!                endif
                if(mms .gt. 0) then
                  dims2 = (/3,mms/)
                  allocate( tmp_minmax_pos(3,mms),stat=error ); if(error.ne.0) goto 20
                  do mmid=1,mms
                    tmp_minmax_pos(1,mmid) = points(mmid,1)
                    tmp_minmax_pos(2,mmid) = points(mmid,2)
                    tmp_minmax_pos(3,mmid) = points(mmid,3)
                  enddo
                  do eid=1, numpairs
                    edata_dble(1, eid) = tmp_minmax_pos(1, pairing(eid,1))
                    edata_dble(2, eid) = tmp_minmax_pos(2, pairing(eid,1))
                    edata_dble(3, eid) = tmp_minmax_pos(3, pairing(eid,1))
                    edata_dble(4, eid) = tmp_minmax_pos(1, pairing(eid,2))
                    edata_dble(5, eid) = tmp_minmax_pos(2, pairing(eid,2))
                    edata_dble(6, eid) = tmp_minmax_pos(3, pairing(eid,2))
                    edata_dble(7, eid) = dsqrt( ( edata_dble(1, eid) -edata_dble(4, eid))**2     &
                                               +( edata_dble(2, eid) -edata_dble(5, eid))**2     &
                                               +( edata_dble(3, eid) -edata_dble(6, eid))**2 )
                  enddo
                  call h5LTmake_dataset_f(group0_id, 'minmax_pos', 2, dims2, H5T_NATIVE_DOUBLE, tmp_minmax_pos, error); if(error .ne. 0) goto 10

                  write(*,*) '  writing ',trim(traj_group_path),'/minmax_coords'
                  do mmid=1,mms

#ifndef _CUBIC_CELLS_
                    i = int(tmp_minmax_pos(1, mmid))
                    j = int(tmp_minmax_pos(2, mmid))
                    k = int(tmp_minmax_pos(3, mmid))
                    posx =  tmp_minmax_pos(1, mmid) -i
                    posy =  tmp_minmax_pos(2, mmid) -j
                    posz =  tmp_minmax_pos(3, mmid) -k

                    tmp_minmax_pos(1, mmid) = coordx(i) + posx*(coordx(i+1)-coordx(i))
                    tmp_minmax_pos(2, mmid) = coordy(j) + posy*(coordy(j+1)-coordy(j))
                    tmp_minmax_pos(3, mmid) = coordz(k) + posz*(coordz(k+1)-coordz(k))
                    if(coordz_switch) then
                      tmp_minmax_pos(3, mmid) = -1.d0 * tmp_minmax_pos(3, mmid)
                    end if
#else
                    tmp_minmax_pos(1,mmid) = tmp_minmax_pos(1,mmid) -1.d0
                    tmp_minmax_pos(2,mmid) = tmp_minmax_pos(2,mmid) -1.d0
                    tmp_minmax_pos(3,mmid) = tmp_minmax_pos(3,mmid) -1.d0
#endif
                  enddo
                  call h5LTmake_dataset_f(group0_id, 'minmax_coords', 2, dims2, H5T_NATIVE_DOUBLE, tmp_minmax_pos, error); if(error .ne. 0) goto 10

                  deallocate(tmp_minmax_pos)
                endif

              ! write psi of 'minmax_val'
                write(*,*) '  writing ',trim(traj_group_path),'/minmax_val'
                if(mms .gt. 0) then
                  dims1 = (/mms/)
                  allocate( tmp_minmax_val(mms),stat=error ); if(error.ne.0) goto 20
                  do mmid=1,mms
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
                    tmp_minmax_val(mmid) = interp_b(points(mmid,1), &
                                                    points(mmid,2), &
                                                    points(mmid,3),psi_b)
#else
                    tmp_minmax_val(mmid) = interp(points(mmid,1), &
                                                  points(mmid,2), &
                                                  points(mmid,3),psi)
#endif
                  enddo
                  do eid=1, numpairs
                    edata_dble(8, eid) = tmp_minmax_val(pairing(eid,1))
                    edata_dble(9, eid) = tmp_minmax_val(pairing(eid,2))
                    edata_dble(10, eid) = tmp_minmax_val(pairing(eid,2)) -tmp_minmax_val(pairing(eid,1))
                  enddo
                  call h5LTmake_dataset_f(group0_id, 'minmax_val', 1, dims1, H5T_NATIVE_DOUBLE, tmp_minmax_val, error); if(error .ne. 0) goto 10
                  deallocate( tmp_minmax_val )
                endif
            endif

            if(allocated(signs)) then
              ! write psi of 'minmax_type'
                write(*,*) '  writing ',trim(traj_group_path),'/minmax_type'
                if(mms .gt. 0) then
                  dims1 = (/mms/)
                  allocate( tmp_minmax_type(mms),stat=error ); if(error.ne.0) goto 20
                  do mmid=1,mms
                    if(signs(mmid) .eqv. .true.)  tmp_minmax_type(mmid) = +1
                    if(signs(mmid) .eqv. .false.) tmp_minmax_type(mmid) = -1
                  enddo
                  call h5LTmake_dataset_f(group0_id, 'minmax_type', 1, dims1, H5T_NATIVE_INTEGER, tmp_minmax_type, error); if(error .ne. 0) goto 10

                  mins =0; maxs=0
                  do mmid=1, mms
                    if(signs(mmid) .eqv. .true.)  maxs = maxs +1
                    if(signs(mmid) .eqv. .false.) mins = mins +1
                  enddo
                  write(*,*) '  writing ',trim(traj_group_path),'/mincount =',mins
                  write(*,*) '  writing ',trim(traj_group_path),'/maxcount =',maxs
                  dims1 = (/1/)
                  int1_buf(1) =mins
                  call h5LTmake_dataset_f(group0_id, 'mincount', 1, dims1, H5T_NATIVE_INTEGER, int1_buf, error)
                  int1_buf(1) =maxs
                  call h5LTmake_dataset_f(group0_id, 'maxcount', 1, dims1, H5T_NATIVE_INTEGER, int1_buf, error)
                endif
            endif

!		  ! write element-grid-points)
            if(allocated(note)) then
              allocate(egpts(ndims(1),ndims(2),ndims(3)),STAT=error); if(error.ne.0) goto 20	! note(i,j,k) 128^3=> 8MByte; 256^3 => 64MByte; 512^3 => 512MByte
              write(*,*) '  writing ',trim(traj_group_path),'/egpts'
              if( error .NE. 0 ) write(*,*) 'Could not allocate enough memory for *egpts*. ERROR', error
              egpts = 0
              do i=subdomain(1,1),subdomain(1,2)
                do j=subdomain(2,1),subdomain(2,2)
                    do k=subdomain(3,1),subdomain(3,2)
                        if(note(i,j,k) .ne. 0) egpts(i,j,k) = dble(pairing( note(i,j,k),3 ))
                    enddo
                enddo
              enddo
              do eid=1, numpairs
                edata_dble(11, eid) = dble(pairing(eid,3))
              enddo
              if(spacedim .eq. 3) then
                dims3 =(/ndims(1),ndims(2),ndims(3)/)
                call h5LTmake_dataset_f(group0_id, 'egpts', 3, dims3, H5T_NATIVE_DOUBLE, egpts, error)
                if(error .ne. 0) goto 10
              else if(spacedim .eq. 2) then
                dims3 = (/ndims(1),ndims(2),1/)
                call h5LTmake_dataset_f(group0_id, 'egpts', 3, dims3, H5T_NATIVE_DOUBLE, egpts(:,:,2), error)
                if(error .ne. 0) goto 10
              endif
              deallocate(egpts)
            endif

            if(numpairs .gt. 0) then
              dims2 = (/9,numpairs/)
              write(*,*) '  writing ',trim(traj_group_path),'/edata_int'
              call h5LTmake_dataset_f(group0_id, 'edata_int', 2, dims2, H5T_NATIVE_INTEGER, edata_int, error); if(error .ne. 0) goto 10
            endif
            deallocate(edata_int)

            if(numpairs .gt. 0) then
              dims2 = (/11,numpairs/)
              write(*,*) '  writing ',trim(traj_group_path),'/edata_dble'
              call h5LTmake_dataset_f(group0_id, 'edata_dble', 2, dims2, H5T_NATIVE_DOUBLE, edata_dble, error); if(error .ne. 0) goto 10
            endif
            deallocate(edata_dble)

#if (_TRAJCOUNT_>0)
!		  ! write number of trajectories crossing a staggered grid-cell
            write(*,*) '  writing ',trim(traj_group_path),'/trajcount' ! ,maxval=', maxval(trajcount)
            if(spacedim .eq. 3) then
                dims3 =(/ndims(1),ndims(2),ndims(3)/)
                call h5LTmake_dataset_f(group0_id, 'trajcount', 3, dims3, H5T_NATIVE_INTEGER, trajcount, error)
                if(error .ne. 0) goto 10
            else if(spacedim .eq. 2) then
                dims3 = (/ndims(1),ndims(2),1/)
                call h5LTmake_dataset_f(group0_id, 'trajcount', 3, dims3, H5T_NATIVE_INTEGER, trajcount(:,:,2), error)
                if(error .ne. 0) goto 10
            endif
#endif

            if(dumpGradDiv .gt. 0) then
                 write(*,*) '  writing ',trim(traj_group_path),'/graddiv'
!                if(spacedim .eq. 3) then
                    dims3 =(/ndims(1),ndims(2),ndims(3)/)
                    call h5LTmake_dataset_f(group0_id, 'graddiv', 3, dims3, H5T_NATIVE_DOUBLE, graddiv, error)
                    if(error .ne. 0) goto 10
!                else if(spacedim .eq. 2) then
!                    dims3 = (/ndims(1),ndims(2),1/)
!                    call h5LTmake_dataset_f(group0_id, 'graddiv', 3, dims3, H5T_NATIVE_DOUBLE, graddiv(:,:,2), error)
!                    if(error .ne. 0) goto 10
!                endif
            end if

        call h5gclose_f(group0_id, error); if(error .ne. 0) goto 10
        call h5fclose_f(file_id, error); if(error .ne. 0) goto 10

        return

    10	continue
        write(*,*) 'error writing hdf5 file'
        return

    20	continue
        write(*,*) 'error allocating memory'
        stop

    end subroutine hdf5_write_edata

!
!     -----------
!
!     write element-informations in hd5 format
!           note        -> eid randomized
!
!     -----------
!
    subroutine hdf5_write_rand_eid(fo_hdf5,traj_group_path, error)
        use hdf5
        use h5lt
        implicit none

        ! function vars
        character(len=*), intent(in)    :: fo_hdf5, traj_group_path
        integer,intent(out)         :: error

        ! hd5 file vars
        integer(HID_T)      ::  file_id
        integer(HID_T)      ::  group0_id
        integer(HID_T)      ::  did

!       ! hd5 attribute vars
        integer, dimension(1)   :: int1_buf

!       ! hd5 dataset vars
        integer(HSIZE_T), dimension(3) :: dims3

!       ! usual stuff
        integer :: i,j,k,l,t, ierr
        double precision :: r

        integer, dimension(:,:,:), allocatable :: eid_rand
        integer, dimension(:), allocatable :: randvec

        allocate(eid_rand(ndims(1),ndims(2),ndims(3)), stat=ierr)


        ! create elementId-vector and shuffle it
        allocate(randvec(0:numpairs), stat=ierr)
        do i=0, numpairs
          randvec(i) = i
        end do
        do l=1, 10 ! shuffle 10 times
            do i=1, numpairs ! switch pairs, but skip 0
              call random_number(r)
              j = int( r*numpairs +0.5 )
              t = randvec(j)
              randvec(j) = randvec(i)
              randvec(i) = t
            end do
        end do

        do k=1,ndims(3)
          do j=1,ndims(2)
            do i=1,ndims(1)
              eid_rand(i,j,k) = randvec(note(i,j,k))
            end do
          end do
        end do

        call h5fopen_f(fo_hdf5, H5F_ACC_RDWR_F, file_id, error); if(error .ne. 0) goto 10
        call h5gopen_f(file_id, trim(traj_group_path), group0_id, error); if(error .ne. 0) goto 10

!         ! write 'note' to scalar data field 'eid'
            if(allocated(note)) then
                write(*,*) '  writing randomized ',trim(traj_group_path),'/eid_rand'
                if(spacedim .eq. 3) then
                    dims3 = (/ndims(1),ndims(2),ndims(3)/)
                    call h5LTmake_dataset_f(group0_id, 'eid_rand', 3, dims3, H5T_NATIVE_INTEGER, eid_rand, error)
                    if(error .ne. 0) goto 10
                else if(spacedim .eq. 2) then
                    dims3 = (/ndims(1),ndims(2),1/)
                    call h5LTmake_dataset_f(group0_id, 'eid_rand', 3, dims3, H5T_NATIVE_INTEGER, eid_rand(:,:,2), error)
                    if(error .ne. 0) goto 10
                endif
            endif

        call h5gclose_f(group0_id, error); if(error .ne. 0) goto 10
        call h5fclose_f(file_id, error); if(error .ne. 0) goto 10

        return

    10  continue
        write(*,*) 'error writing hdf5 file'
        return

    20  continue
        write(*,*) 'error allocating memory'
        stop

    end subroutine hdf5_write_rand_eid

!
!     -----------
!
!     write element-informations in hd5 format
!
!     -----------
!
    subroutine hdf5_write_etraj(group_id, eid_in, error)
        use hdf5
        use h5lt
        implicit none

        ! function vars
        integer(HID_T)			::	group_id
        integer,intent(in)		:: eid_in
        integer,intent(out)	:: error

        ! hd5 file vars
        integer(HID_T)		::	file_id

!		! hd5 dataset vars
        integer(HSIZE_T), dimension(2) :: dims2

!		! usual stuff
        integer :: ptId, trajId, ptStep, trajcounts,v
        integer :: curPt, ptId_start, ptId_end
        character(len=16) :: eid_string
        double precision, dimension(:,:), allocatable :: etraj, etraj_dble, etraj_vars
        integer, dimension(:,:), allocatable :: etraj_int
        double precision :: etraj_length

        curPt = 0
        do trajId=1, dEleNoTraj
            !if(trajId .ne. outtraj1id .and. trajId .ne. outtraj2id) cycle
            curPt = curPt +dEleTrajSize(trajId)
        enddo
        if(curPt .gt. 0) then
            write(*,*) '  writing trajectory of element ',eid_in
            allocate(etraj(5,curPt),stat=error); if(error.ne.0) goto 20
            !if(novars .gt. 0) then
              allocate(etraj_vars(novars +tattrs -4,curPt),stat=error); if(error.ne.0) goto 20
            !endif
            allocate(etraj_int(3,dEleNoTraj),stat=error); if(error.ne.0) goto 20
            allocate(etraj_dble(1,dEleNoTraj),stat=error); if(error.ne.0) goto 20
            curPt = 0
            trajcounts = 0
            do trajId=1, dEleNoTraj ! loop over trajectories
                !if(trajId .ne. outtraj1id .and. trajId .ne. outtraj2id) cycle
                trajcounts = trajcounts +1
                if( trajcounts .eq. 1) then
                    ptId_start = 1
                    ptId_end   = dEleTrajSize(trajId)
                    ptStep     = 1
                else if( mod(trajcounts,2) .ne. 0) then
                    ptId_start = 2					    ! skip coincident points at max
                    ptId_end   = dEleTrajSize(trajId)
                    ptStep     = 1
                else
                    ptId_start = dEleTrajSize(trajId)-1	! skip coincident points at min
                    ptId_end   = 1
                    ptStep     =-1
                endif

                etraj_int(1,trajId) = curPt+1 ! start of traj
                etraj_length = 0.d0
                do ptId=ptId_start, ptId_end, ptStep ! loop over points on trajectory
                    curPt = curPt +1
                    etraj(1, curPt) =  dEleTraj(trajId, ptId, 1)
                    etraj(2, curPt) =  dEleTraj(trajId, ptId, 2)
                    if(spacedim .eq. 2) then; etraj(3, curPt) = 1.d0
                    else;                     etraj(3, curPt) = dEleTraj(trajId, ptId, 3)
                    endif

                    etraj(4, curPt) = dEleTraj(trajId, ptId, 4)
                    if(ptId .ne. ptId_start) then
                      etraj(5, curPt) =   &
                        sqrt( (etraj(1, curPt-1)-etraj(1, curPt))**2 &
                             +(etraj(2, curPt-1)-etraj(2, curPt))**2 &
                             +(etraj(3, curPt-1)-etraj(3, curPt))**2)
                    else
                      etraj(5, curPt) = 0.d0
                    endif

                    do v=1, novars
                    	etraj_vars(v, curPt) = dEleTraj(trajId, ptId, v+dEleTrajVars_offset)
                    enddo

                    etraj_vars(novars+1, curPt) = dEleTraj(trajId, ptId, 5) ! normal vector x
                    etraj_vars(novars+2, curPt) = dEleTraj(trajId, ptId, 6) ! normal vector y
                    etraj_vars(novars+3, curPt) = dEleTraj(trajId, ptId, 7) ! normal vector z
                    etraj_vars(novars+4, curPt) = dEleTraj(trajId, ptId, 8) ! gradient psi
                    etraj_vars(novars+5, curPt) = dEleTraj(trajId, ptId, 9) ! trajectory density

	                etraj_length = etraj_length +etraj(5, curPt)
                enddo

                etraj_dble(1,trajId) = etraj_length
                etraj_int(2,trajId) = curPt ! end of traj
                etraj_int(3,trajId) = ptStep !min->max or max->min-direction
            enddo


#ifndef _CUBIC_CELLS_
            ! do not correct traj-coordinates for paraview
#else
            ! correct traj-coordinates for paraview
            do ptId=1, curPt
                etraj(1, ptId) = etraj(1, ptId) -1.d0
                etraj(2, ptId) = etraj(2, ptId) -1.d0
                etraj(3, ptId) = etraj(3, ptId) -1.d0
            enddo
#endif
            dims2 = (/5,curPt/)
            write(eid_string,*) eid_in
            call h5LTmake_dataset_f(group_id, 'etraj_'//trim(adjustl(eid_string)), 2, dims2, H5T_NATIVE_DOUBLE, etraj, error); if(error .ne. 0) goto 10
            deallocate(etraj)

            if(novars .gt. 0) then
            	dims2 = (/tattrs-4,curPt/)
            	write(eid_string,*) eid_in
            	call h5LTmake_dataset_f(group_id, 'etraj_'//trim(adjustl(eid_string))//'_vars', 2, dims2, H5T_NATIVE_DOUBLE, etraj_vars, error); if(error .ne. 0) goto 10
            	deallocate(etraj_vars)
            endif

            dims2 = (/3,dEleNoTraj/)
            call h5LTmake_dataset_f(group_id, 'etraj_'//trim(adjustl(eid_string))//'_int', 2, dims2, H5T_NATIVE_INTEGER, etraj_int, error); if(error .ne. 0) goto 10
            deallocate(etraj_int)

            dims2 = (/1,dEleNoTraj/)
            call h5LTmake_dataset_f(group_id, 'etraj_'//trim(adjustl(eid_string))//'_dble', 2, dims2, H5T_NATIVE_DOUBLE, etraj_dble, error); if(error .ne. 0) goto 10
            deallocate(etraj_dble)

        else
            write(*,*) '  _NOT_ writing trajectory of element ',eid_in
            write(*,*) '  all of its ', dEleNoTraj, ' trajectories have 0 points.'
        endif

        return

    10	continue
        write(*,*) 'error writing hdf5 file'
        return

    20	continue
        write(*,*) 'error allocating memory'
        stop

    end subroutine hdf5_write_etraj

!
!     -----------
!
!     write element-boundary-trajectories in hd5 format (if 2d!)
!
!     -----------
!
    subroutine hdf5_write_etraj_bounds(group_id, eid_in, error)
        use hdf5
        use h5lt
        implicit none

        ! function vars
        integer(HID_T)			:: group_id
        integer,intent(in)		:: eid_in
        integer,intent(out)	:: error

        ! hd5 file vars
        integer(HID_T)		::	file_id

!		! hd5 dataset vars
        integer(HSIZE_T), dimension(2) :: dims2

!		! usual stuff
        integer :: ptId, trajId, ptStep, trajcounts, id
        integer :: curPt, ptId_start, ptId_end
        character(len=16) :: eid_string
        double precision, dimension(:,:), allocatable :: etraj

        double precision, dimension(:), allocatable :: distance
        double precision :: x_traj, y_traj, dist_proj,perp_dist,perp_dist_max
        double precision :: dx_el, dy_el, l_lin
        integer          :: pt_id_max
        integer          :: outtrajid(2), locarr(1)

        if(spacedim .ne. 2) return

        allocate(distance(dEleNoTraj),stat=error); if(error.ne.0) goto 20

            !Verbindungsgerade der Extrempunkte
            if(dEleNoTraj>0) then
               dx_el = dEleTraj(1, dEleTrajSize(1), 1)-(dEleTraj(1, 1, 1))
               dy_el = dEleTraj(1, dEleTrajSize(1), 2)-(dEleTraj(1, 1, 2))
               l_lin = sqrt(dx_el**2+dy_el**2)
               dx_el = dx_el/l_lin
               dy_el = dy_el/l_lin
            end if

            do trajId=1, dEleNoTraj ! loop over trajectories
                perp_dist_max=0.d0
                pt_Id_max=1
                do ptId=1,dEleTrajSize(trajId) ! loop over points on trajectory

                   x_traj=dEleTraj(trajId, ptId, 1)-(dEleTraj(1, 1, 1))
                   y_traj=dEleTraj(trajId, ptId, 2)-(dEleTraj(1, 1, 2))
                   dist_proj=dx_el*x_traj+dy_el*y_traj
                   if(x_traj**2+y_traj**2-dist_proj**2<0.d0) cycle
                   perp_dist=sqrt((x_traj**2+y_traj**2)-dist_proj**2)

                   ! found more outer trajectory
                   if(perp_dist>perp_dist_max) then
                      perp_dist_max=perp_dist
                      pt_id_max=ptId
                   end if
                end do

                if(dx_el*(dEleTraj(trajId, pt_id_max, 2)-dEleTraj(1, 1, 2))- dy_el*(dEleTraj(trajId, pt_id_max, 1)-dEleTraj(1, 1, 1))<0.d0) then
                      distance(trajid)=-perp_dist_max
                   else
                      distance(trajid)=perp_dist_max
                end if
             enddo

             locarr = maxloc(distance); outtrajid(1) = locarr(1)
             locarr = minloc(distance); outtrajid(2) = locarr(1)

       deallocate(distance)
!
        curPt = 0
        do id=1, 2
            trajId = outtrajid(id)
            curPt = curPt +dEleTrajSize(trajId)
        enddo
        if(curPt .gt. 0) then
            write(*,*) '  writing boundary-trajectory of element ',eid_in
            allocate(etraj(5,curPt),stat=error); if(error.ne.0) goto 20

            curPt = 0
            trajcounts = 0
            do id=1, 2
                trajId = outtrajid(id)
                trajcounts = trajcounts +1
                if( trajcounts .eq. 1) then
                    ptId_start = 1
                    ptId_end   = dEleTrajSize(trajId)
                    ptStep     = 1
                else if( mod(trajcounts,2) .ne. 0) then
                    ptId_start = 2							! skip coincident points at max
                    ptId_end   = dEleTrajSize(trajId)
                    ptStep     = 1
                else
                    ptId_start = dEleTrajSize(trajId)-1	! skip coincident points at min
                    ptId_end   = 1
                    ptStep     =-1
                endif

                do ptId=ptId_start, ptId_end, ptStep ! loop over points on trajectory
                    curPt = curPt +1

                    etraj(1, curPt) =  dEleTraj(trajId, ptId, 1)
                    etraj(2, curPt) =  dEleTraj(trajId, ptId, 2)
                    etraj(3, curPt) =  dEleTraj(trajId, ptId, 3)
                    if(coordz_switch) then
                      etraj(3, curPt) = -1.d0 * etraj(3, curPt)
                    end if
!                    if(spacedim .eq. 2) then; etraj(3, curPt) = 1.d0
!                    else;                      etraj(3, curPt) =  dEleTraj(trajId, ptId, 3)
!                    endif

                    etraj(4, curPt) = dEleTraj(trajId, ptId, 4)
                    if(ptId .ne. ptId_start) then
                      etraj(5, curPt) =   &
                        sqrt( (etraj(1, curPt-1)-etraj(1, curPt))**2 &
                             +(etraj(2, curPt-1)-etraj(2, curPt))**2 &
                             +(etraj(3, curPt-1)-etraj(3, curPt))**2)
                    else
                      etraj(5, curPt) = 0.d0
                    endif

                enddo

            enddo

#ifndef _CUBIC_CELLS_
            ! do not correct traj-coordinates for paraview
#else
            ! correct traj-coordinates for paraview
            do ptId=1, curPt
            	etraj(1, ptId) = etraj(1, ptId) -1.d0
            	etraj(2, ptId) = etraj(2, ptId) -1.d0
            	etraj(3, ptId) = etraj(3, ptId) -1.d0
            enddo
#endif
            dims2 = (/5,curPt/)
            write(eid_string,*) eid_in
            call h5LTmake_dataset_f(group_id, 'etraj_'//trim(adjustl(eid_string))//'_bounds', 2, dims2, H5T_NATIVE_DOUBLE, etraj, error); if(error .ne. 0) goto 10
            deallocate(etraj)

        else
            write(*,*) '  _NOT_ writing trajectory of element ',eid_in
            write(*,*) '  all of its ', dEleNoTraj, ' trajectories have 0 points.'
        endif

        return

    10	continue
        write(*,*) 'error writing hdf5 file'
        return

    20	continue
        write(*,*) 'error allocating memory'
        stop

    end subroutine hdf5_write_etraj_bounds


!
!     -----------
!
!     write information of minimum-attached-elements to hdf5
!
!     -----------
!
    subroutine hdf5_write_maedata(fi_hdf5, traj_group_path, error)
        use hdf5
        use h5lt
        implicit none

        ! function vars
        character(len=*), intent(in)	:: fi_hdf5, traj_group_path
        integer,intent(out)			:: error

        ! usual stuff
        integer :: eid

        integer :: i,j,k, pos
        double precision, dimension(:,:,:), allocatable :: maegpts
        integer, dimension(:,:,:), allocatable :: maeid
        integer(HSIZE_T),dimension(3) :: dims3
        integer(HID_T):: file_id, group0_id

        integer :: mmid, all_mms, mms, mae, signs_type
        character(len=32) :: mae_string
        integer, dimension(:), allocatable   :: numLocalMMSEles
        integer, dimension(:,:), allocatable :: LocalMMSEles
        character(len=128) :: maegpts_string

    ! count number of minima+maxima
        mms = numends
!        do eid=1, numpairs
!            if(pairing(eid,1) .gt. mms) mms = pairing(eid,1)
!            if(pairing(eid,2) .gt. mms) mms = pairing(eid,2)
!        end do

    ! count number elements per minima/maxima
        allocate(numLocalMMSEles(mms),stat=error); if(error.ne.0) goto 20
        numLocalMMSEles = 0
        do eid=1, numpairs
            numLocalMMSEles(pairing(eid,1)) = numLocalMMSEles(pairing(eid,1)) +1
            numLocalMMSEles(pairing(eid,2)) = numLocalMMSEles(pairing(eid,2)) +1
        end do
        !write(*,*) '  found number of elements per minimum/maximum.'

    ! add elements to their minima/maxima
        allocate(LocalMMSEles(mms,0:maxval(numLocalMMSEles)),stat=error); if(error.ne.0) goto 20
        LocalMMSEles = 0
        do eid=1, numpairs
            LocalMMSEles( pairing(eid,1),0) = LocalMMSEles(pairing(eid,1),0) +1
            LocalMMSEles( pairing(eid,1), LocalMMSEles( pairing(eid,1),0 ) ) = eid
            LocalMMSEles( pairing(eid,2),0) = LocalMMSEles(pairing(eid,2),0) +1
            LocalMMSEles( pairing(eid,2), LocalMMSEles( pairing(eid,2),0 ) ) = eid
        end do
        !write(*,*) '  added diss.elements to their minima/maxima.'

!	! write element-volume (number of grid-points)
        call h5fopen_f(fi_hdf5, H5F_ACC_RDWR_F, file_id, error); if(error .ne. 0) goto 5
        call h5gopen_f(file_id, trim(traj_group_path), group0_id, error); if(error .ne. 0) goto 5

        allocate(maegpts(ndims(1),ndims(2),ndims(3)),stat=error) ! 128^3=> 16MByte; 256^3 => 128MByte; 512^3 => 1024MByte
        if( error .NE. 0 ) write(*,*) 'Could not allocate enough memory for *maegpts*. ERROR', error
        allocate(maeid(ndims(1),ndims(2),ndims(3)),STAT=error)
        if( error .NE. 0 ) write(*,*) 'Could not allocate enough memory for *maeid*. ERROR', error

        maegpts = 0.d0
        maeid  = 0
        write(*,*) '  calculate minimum-attached-element volume and id'
        do i=subdomain(1,1),subdomain(1,2)
            do j=subdomain(2,1),subdomain(2,2)
                do k=subdomain(3,1),subdomain(3,2)
                    if(note(i,j,k) .gt. 0) then
                        mae = pairing( note(i,j,k) ,1)
                        maeid(i,j,k) = mae
                        do pos=1, LocalMMSEles(mae,0)
                            maegpts(i,j,k) = maegpts(i,j,k) +dble(pairing( LocalMMSEles(mae,pos), 3))
                        enddo
                    endif
                enddo
            enddo
        enddo
        if(spacedim .eq. 3) then
            dims3 =(/ndims(1),ndims(2),ndims(3)/)
            call h5LTmake_dataset_f(group0_id, 'minattgpts', 3, dims3, H5T_NATIVE_DOUBLE, maegpts, error)
            if(error .ne. 0) goto 5
            call h5LTmake_dataset_f(group0_id, 'minattid', 3, dims3, H5T_NATIVE_INTEGER, maeid, error)
            if(error .ne. 0) goto 5
        else if(spacedim .eq. 2) then
            dims3 =(/ndims(1),ndims(2),1/)
            call h5LTmake_dataset_f(group0_id, 'minattgpts', 3, dims3, H5T_NATIVE_DOUBLE, maegpts(:,:,2), error)
            if(error .ne. 0) goto 5
            call h5LTmake_dataset_f(group0_id, 'minattid', 3, dims3, H5T_NATIVE_INTEGER, maeid(:,:,2), error)
            if(error .ne. 0) goto 5
        endif

        maegpts = 0.d0
        maeid  = 0
        write(*,*) '  calculate maximum-attached-element volume and id'
        do i=subdomain(1,1),subdomain(1,2)
            do j=subdomain(2,1),subdomain(2,2)
                do k=subdomain(3,1),subdomain(3,2)
                    if(note(i,j,k) .gt. 0) then
                        mae = pairing( note(i,j,k) ,2)
                        maeid(i,j,k) = mae
                        do pos=1, LocalMMSEles(mae,0)
                            maegpts(i,j,k) = maegpts(i,j,k) +dble(pairing( LocalMMSEles(mae,pos), 3))
                        enddo
                    endif
                enddo
            enddo
        enddo
        if(spacedim .eq. 3) then
            dims3 =(/ndims(1),ndims(2),ndims(3)/)
            call h5LTmake_dataset_f(group0_id, 'maxattvol', 3, dims3, H5T_NATIVE_INTEGER, maegpts, error)
            if(error .ne. 0) goto 5
            call h5LTmake_dataset_f(group0_id, 'maxattid', 3, dims3, H5T_NATIVE_INTEGER, maeid, error)
            if(error .ne. 0) goto 5
        else if(spacedim .eq. 2) then
            dims3 =(/ndims(1),ndims(2),1/)
            call h5LTmake_dataset_f(group0_id, 'maxattvol', 3, dims3, H5T_NATIVE_INTEGER, maegpts(:,:,2), error)
            if(error .ne. 0) goto 5
            call h5LTmake_dataset_f(group0_id, 'maxattid', 3, dims3, H5T_NATIVE_INTEGER, maeid(:,:,2), error)
            if(error .ne. 0) goto 5
        endif

        deallocate(maegpts)
        deallocate(maeid)

        call h5gclose_f(group0_id, error); if(error .ne. 0) goto 5
        call h5fclose_f(file_id, error); if(error .ne. 0) goto 5

        return

    5   write(*,*) 'HDF5 error ... exit'
        return

    20	continue
        write(*,*) 'error allocating memory'
        stop

    end subroutine hdf5_write_maedata

!
!     -----------
!
!     write trajectory-information in xdmf format
!
!     -----------
!
    subroutine xdmf_write(fi_hdf5, input_dataset_path, traj_group_path, error)
        use hdf5
        use h5lt
        implicit none

        ! function vars
        character(len=*), intent(in)	:: fi_hdf5, input_dataset_path, traj_group_path
        integer,intent(out)			:: error

        ! usual stuff
        character(len=64) :: origdims_str1, origdims_str2, origdims_str3
        character(len=64) :: subdomain_start_str1, subdomain_start_str2, subdomain_start_str3
        character(len=64) :: subdomain_count_str1, subdomain_count_str2, subdomain_count_str3
        error = 0

        open(unit=51, file=trim(fi_hdf5)//'.xmf', err=100, status='unknown', form='formatted', action='WRITE')
        rewind(51)

        if(spacedim .eq. 3) then
            write(origdims_str1,*) origdims(1)
            write(origdims_str2,*) origdims(2)
            write(origdims_str3,*) origdims(3)
            write(subdomain_start_str1,*) subdomain(1,1)-1
            write(subdomain_start_str2,*) subdomain(2,1)-1
            write(subdomain_start_str3,*) subdomain(3,1)-1
            write(subdomain_count_str1,*) subdomain(1,2) -subdomain(1,1)+1
            write(subdomain_count_str2,*) subdomain(2,2) -subdomain(2,1)+1
            write(subdomain_count_str3,*) subdomain(3,2) -subdomain(3,1)+1
        else if(spacedim .eq. 2) then
            write(origdims_str1,*) '1 '
            write(origdims_str2,*) origdims(2)
            write(origdims_str3,*) origdims(1)
            write(subdomain_start_str1,*) '0 '
            write(subdomain_start_str2,*) subdomain(2,1)-1
            write(subdomain_start_str3,*) subdomain(1,1)-1
            write(subdomain_count_str1,*) '1 '
            write(subdomain_count_str2,*) subdomain(2,2) -subdomain(2,1)+1
            write(subdomain_count_str3,*) subdomain(1,2) -subdomain(1,1)+1
        endif

        write(51,8) trim(fi_hdf5), trim(adjustl(origdims_str1)),        trim(adjustl(origdims_str2)),        trim(adjustl(origdims_str3)),			&
                                    trim(adjustl(subdomain_count_str1)), trim(adjustl(subdomain_count_str2)), trim(adjustl(subdomain_count_str3)),	&
                                    trim(adjustl(subdomain_start_str1)), trim(adjustl(subdomain_start_str2)), trim(adjustl(subdomain_start_str3)),	&
#ifndef _CUBIC_CELLS_
                     trim(fi_hdf5),&
                     'Float', 8, trim(traj_group_path)//'/coordx', &
                     'Float', 8, trim(traj_group_path)//'/coordy', &
                     'Float', 8, trim(traj_group_path)//'/coordz'
#else
                     trim(fi_hdf5)
#endif

        write(51,*) '                                <!-- u'
        write(51,10)'u', 'Float', 8, '/someHDF5path/u'
        write(51,*) ' -->'
        write(51,*)

        write(51,*) '                                <!-- v'
        write(51,10)'v', 'Float', 8, '/someHDF5path/v'
        write(51,*) ' -->'
        write(51,*)

        write(51,*) '                                <!-- w'
        write(51,10)'w', 'Float', 8, '/someHDF5path/w'
        write(51,*) ' -->'
        write(51,*)

        write(51,*) '                                <!-- ',trim(input_dataset_path),' -->'
        write(51,10)trim(input_dataset_path),       'Float', 8, trim(input_dataset_path)
        write(51,*)

        write(51,*) '                                <!-- ',trim(traj_group_path)//'/egpts',' -->'
        write(51,10)trim(traj_group_path)//'/egpts', 'Float', 8, trim(traj_group_path)//'/egpts'
        write(51,*)

        write(51,*) '                                <!-- ',trim(traj_group_path)//'/eid',' -->'
        write(51,10)trim(traj_group_path)//'/eid',  'Int',   4, trim(traj_group_path)//'/eid'
        write(51,*)

        write(51,*) '                                <!-- ',trim(traj_group_path)//'/minattid'
        write(51,10)trim(traj_group_path)//'/minattid',  'Int',   4, trim(traj_group_path)//'/minattid'
        write(51,*) ' -->'
        write(51,*)

        write(51,*) '                                <!-- ',trim(traj_group_path)//'/maxattid'
        write(51,10)trim(traj_group_path)//'/maxattid',  'Int',   4, trim(traj_group_path)//'/maxattid'
        write(51,*) ' -->'
        write(51,*)

        write(51,*) '                                <!-- ',trim(traj_group_path)//'/minattvol'
        write(51,10)trim(traj_group_path)//'/minattvol', 'Float', 8, trim(traj_group_path)//'/minattvol'
        write(51,*) ' -->'
        write(51,*)

        write(51,*) '                                <!-- ',trim(traj_group_path)//'/maxattvol'
        write(51,10)trim(traj_group_path)//'/maxattvol', 'Float', 8, trim(traj_group_path)//'/maxattvol'
        write(51,*) ' -->'
        write(51,*)

        write(51,80) ! write xdmf-footer'

        close(51)

        return

     8  format('<?xml version="1.0" ?>',/,&
               '',/,&
               '<!DOCTYPE Xdmf SYSTEM "Xdmf.dtd" [',/,&
               '        <!ENTITY DataFile  "',A,'">',/,&
               '        <!ENTITY DimsX   "',A,'">',/,&
               '        <!ENTITY DimsY   "',A,'">',/,&
               '        <!ENTITY DimsZ   "',A,'">',/,&
               '        <!ENTITY HSDimsX "',A,'">',/,&
               '        <!ENTITY HSDimsY "',A,'">',/,&
               '        <!ENTITY HSDimsZ "',A,'">',/,&
               '        <!ENTITY HSDimsX_Start "',A,'">',/,&
               '        <!ENTITY HSDimsY_Start "',A,'">',/,&
               '        <!ENTITY HSDimsZ_Start "',A,'">',/,&
               ']>',/,&
               '<Xdmf Version="2.0" xmlns:xi="http://www.w3.org/2001/XInclude" >',/,&
               '',/,&
               '  <Domain Name="',A,'">',/,&
               '',/,&
               '        <Grid Name="TemporalCollection" GridType="Collection" CollectionType="Temporal">',/,&
               '',/,&
               '                <!--spatial grid collection for time 0.0-->',/,&
               '                <Grid Name="SpatialCollection" GridType="Collection" CollectionType="Spatial">',/,&
               '                        <Time Type="Single" Value="0.00000000"/>',/,&
               '',/,&
               '                        <Grid Name="1-1-1_t0.0" Type="Uniform">',/,&
               '',/,&
#ifndef _CUBIC_CELLS_
               '                                <Topology TopologyType="3DRectMesh" Dimensions="&HSDimsZ; &HSDimsY; &HSDimsX;">  </Topology>',/,&
               '                                <Geometry GeometryType="VXVYVZ">',/,&
               '                                        <DataItem Name="Z" ItemType="HyperSlab" Dimensions="&HSDimsX;">'/,&
               '                                            <DataItem Dimensions="1 3" Format="XML">'/,&
               '                                                &HSDimsX_Start;'/,&
               '                                                1              '/,&
               '                                                &HSDimsX;'/,&
               '                                            </DataItem>'/,&
               '                                            <DataItem ItemType="Uniform" Format="HDF" NumberType="',A,'" Precision="',i2,'" Dimensions="&DimsX;">'/,&
               '                                                &DataFile;:',A/,&
               '                                            </DataItem>'/,&
               '                                        </DataItem>'/,&
               '                                        <DataItem Name="Y" ItemType="HyperSlab" Dimensions="&HSDimsY;">'/,&
               '                                            <DataItem Dimensions="1 3" Format="XML">'/,&
               '                                                &HSDimsY_Start;'/,&
               '                                                1              '/,&
               '                                                &HSDimsY;'/,&
               '                                            </DataItem>'/,&
               '                                            <DataItem ItemType="Uniform" Format="HDF" NumberType="',A,'" Precision="',i2,'" Dimensions="&DimsY;">'/,&
               '                                                &DataFile;:',A/,&
               '                                            </DataItem>'/,&
               '                                        </DataItem>'/,&
               '                                        <DataItem Name="X" ItemType="HyperSlab" Dimensions="&HSDimsZ;">'/,&
               '                                            <DataItem Dimensions="1 3" Format="XML">'/,&
               '                                                &HSDimsZ_Start;'/,&
               '                                                1              '/,&
               '                                                &HSDimsZ;'/,&
               '                                            </DataItem>'/,&
               '                                            <DataItem ItemType="Uniform" Format="HDF" NumberType="',A,'" Precision="',i2,'" Dimensions="&DimsZ;">'/,&
               '                                                &DataFile;:',A/,&
               '                                            </DataItem>'/,&
               '                                        </DataItem>'/,&
               '                                </Geometry>',/,&
#else
               '                                <Topology TopologyType="3DCORECTMESH" Dimensions="&HSDimsZ; &HSDimsY; &HSDimsX;">  </Topology>',/,&
               '                                <Geometry GeometryType="ORIGIN_DXDYDZ">',/,&
               '                                        <DataItem DataType="Float" Dimensions="3" Format="XML"> &HSDimsZ_Start; &HSDimsY_Start; &HSDimsX_Start; </DataItem>',/,&
               '                                        <DataItem DataType="Float" Dimensions="3" Format="XML"> 1.0 1.0 1.0 </DataItem>',/,&
               '                                </Geometry>',/,&
#endif
               '')

    10  format('                                <Attribute Active="1" Type="Scalar" Center="Node" Name="',A,'">'/,&
               '                                    <DataItem ItemType="HyperSlab" Dimensions="&HSDimsZ; &HSDimsY; &HSDimsX;">'/,&
               '                                        <DataItem Dimensions="3 3" Format="XML">'/,&
               '                                            &HSDimsZ_Start; &HSDimsY_Start; &HSDimsX_Start;'/,&
               '                                            1  1  1          '/,&
               '                                            &HSDimsZ; &HSDimsY; &HSDimsX;'/,&
               '                                        </DataItem>'/,&
               '                                        <DataItem ItemType="Uniform" Format="HDF" NumberType="',A,'" Precision="',i2,'" Dimensions="&DimsZ; &DimsY; &DimsX;">'/,&
               '                                            &DataFile;:',A/,&
               '                                        </DataItem>'/,&
               '                                    </DataItem>'/,&
               '                                </Attribute>')

    80  format(''/,&
               '                         </Grid>'/,&
               '                </Grid>'/,&
               '        </Grid>'/,&
               '    </Domain>'/,&
               '</Xdmf>'/,&
               '')

    100 write(*,*) 'Could not OPEN xdmf-file ... exiting'
        return

    end subroutine xdmf_write

!
!     -----------
!
!     write trajectory-length information in xdmf format
!
!     -----------
!
    subroutine xdmf_write_length(fi_hdf5, traj_group_path, error)
        use hdf5
        use h5lt
        implicit none

        ! function vars
        character(len=*), intent(in)    :: fi_hdf5, traj_group_path
        integer,intent(out)         :: error

        ! usual stuff
        integer(HID_T):: file_id, group0_id
        integer(HSIZE_T),dimension(2) :: edata_dims2, maxdims2
        integer(HSIZE_T),dimension(2) :: minmax_dims2
        integer(HID_T) :: did, dspace_id

        call h5fopen_f(fi_hdf5, H5F_ACC_RDWR_F, file_id, error); if(error .ne. 0) goto 5
        call h5gopen_f(file_id, trim(traj_group_path), group0_id, error); if(error .ne. 0) goto 5

    ! get dimensions of 'edata_int'
        call h5dopen_f(group0_id, 'edata_int', did, error)
        call h5dget_space_f(did, dspace_id, error)
        call h5sget_simple_extent_dims_f(dspace_id, edata_dims2, maxdims2, error)
        call h5dclose_f(did,error)

    ! get dimensions of 'minmax_coords'
        call h5dopen_f(group0_id, 'minmax_coords', did, error)
        call h5dget_space_f(did, dspace_id, error)
        call h5sget_simple_extent_dims_f(dspace_id, minmax_dims2, maxdims2, error)
        call h5dclose_f(did,error)

        call h5gclose_f(group0_id, error); if(error .ne. 0) goto 5
        call h5fclose_f(file_id, error); if(error .ne. 0) goto 5

    ! save xdmf-file

        open(unit=51, file=trim(fi_hdf5)//'_length.xmf', err=100, status='unknown', form='formatted', action='WRITE')
        rewind(51)
        ! write xdmf-header
        write(51,8)  trim(fi_hdf5)
        ! write topology and geomtry
        write(51,20) 'Length', &
                      edata_dims2(2), edata_dims2(2), edata_dims2(2), edata_dims2(2), edata_dims2(2), trim(traj_group_path)//'/edata_int',     &  ! topology
                      minmax_dims2(2),minmax_dims2(2),minmax_dims2(2),                trim(traj_group_path)//'/minmax_coords'     ! geometry
        ! write xdmf-footer
        write(51,80)
        close(51)

        return

    5   write(*,*) 'HDF5 error ... exit'
        return

    8  format('<?xml version="1.0" ?>'/,&
               '<!DOCTYPE Xdmf SYSTEM "Xdmf.dtd" ['/,&
               '<!ENTITY DataFile  "',A,'">'/,&
               ']>'/,&
               '<Xdmf Version="2.0" xmlns:xi="http://www.w3.org/2001/XInclude" >'/,&
               '    <Domain Name="Length">')

    20  format(' ',/,&
               '        <Grid Name="',A,'" Type="Uniform">'/,&
               '            '/,&
               '            <Topology TopologyType="POLYLINE" NodesPerElement="2" NumberOfElements="',i9,'">'/,&
               '             <DataItem ItemType="Function" Function="$0 - 1" Dimensions="',i9,' 2" >'/,&
               '                <DataItem ItemType="HyperSlab" Dimensions="',i9,' 2" Type="HyperSlab">'/,&
               '                    <DataItem Dimensions="2 3" Format="XML">'/,&
               '                        0      6        <!-- Start  -->'/,&
               '                        1      1        <!-- Stride -->'/,&
               '                        ',i9,' 2        <!-- Count  -->'/,&
               '                    </DataItem>'/,&
               '                    <DataItem ItemType="Uniform" Format="HDF" NumberType="int" Precision="4" Dimensions="',i9,' 9">'/,&
               '                        &DataFile;:',A,/,&
               '                    </DataItem>'/,&
               '                </DataItem>'/,&
               '              </DataItem>'/,&
               '            </Topology>'/,&
               '            '/,&
               '            <Geometry GeometryType="XYZ">'/,&
               '                <DataItem ItemType="HyperSlab" Dimensions="',i9,' 3" Type="HyperSlab">'/,&
               '                    <DataItem Dimensions="2 3" Format="XML">'/,&
               '                        0      0        <!-- Start  -->'/,&
               '                        1      1        <!-- Stride -->'/,&
               '                        ',i9,' 3        <!-- Count  -->'/,&
               '                    </DataItem>'/,&
               '                    <DataItem ItemType="Uniform" Format="HDF" NumberType="Float" Precision="8" Dimensions="',i9,' 3">'/,&
               '                        &DataFile;:',A,/,&
               '                    </DataItem>'/,&
               '                </DataItem>'/,&
               '            </Geometry>'/,&
               '            '/,&
               '        </Grid>')

    80  format(' ',/,&
               '    </Domain>'/,&
               '</Xdmf>')

    100 write(*,*) 'Could not OPEN xdmf-file ... exiting'
        return

    end subroutine xdmf_write_length

!
!     -----------
!
!     write trajectory-information in xdmf format
!
!     -----------
!
    subroutine xdmf_write_minmax(fi_hdf5, traj_group_path, error)
        use hdf5
        use h5lt
        implicit none

        ! function vars
        character(len=*), intent(in)	:: fi_hdf5, traj_group_path
        integer,intent(out)			:: error

        ! usual stuff
        integer(HID_T):: file_id, group0_id
        integer(HSIZE_T),dimension(2) :: minmax_dims2, maxdims2
        integer(HID_T) :: did, dspace_id

        call h5fopen_f(fi_hdf5, H5F_ACC_RDWR_F, file_id, error); if(error .ne. 0) goto 5
        call h5gopen_f(file_id, trim(traj_group_path), group0_id, error); if(error .ne. 0) goto 5

    ! get dimensions of 'minmax_coords'
        call h5dopen_f(group0_id, 'minmax_coords', did, error)
        call h5dget_space_f(did, dspace_id, error)
        call h5sget_simple_extent_dims_f(dspace_id, minmax_dims2, maxdims2, error)
        call h5dclose_f(did,error)

        call h5gclose_f(group0_id, error); if(error .ne. 0) goto 5
        call h5fclose_f(file_id, error); if(error .ne. 0) goto 5

    ! save xdmf-file

        open(unit=51, file=trim(fi_hdf5)//'_minmax.xmf', err=100, status='unknown', form='formatted', action='WRITE')
        rewind(51)
        write(51,8)  trim(fi_hdf5) ! write xdmf-header'
       ! write minimum-maximum-field
        write(51,20) 'Minimum_Maximum', minmax_dims2(2), minmax_dims2(2), minmax_dims2(2), minmax_dims2(2), trim(traj_group_path)//'/minmax_coords', &
                      'minmax_value', 'minmax_value', minmax_dims2(2),trim(traj_group_path)//'/minmax_val',	&
                      'minmax_type', 'minmax_type', minmax_dims2(2),trim(traj_group_path)//'/minmax_type'
        write(51,80) ! write xdmf-footer'
        close(51)

        return

    5   write(*,*) 'HDF5 error ... exit'
        return

    8  format('<?xml version="1.0" ?>'/,&
               '<!DOCTYPE Xdmf SYSTEM "Xdmf.dtd" ['/,&
               '<!ENTITY DataFile  "',A,'">'/,&
               ']>'/,&
               '<Xdmf Version="2.0" xmlns:xi="http://www.w3.org/2001/XInclude" >'/,&
               '    <Domain Name="Minimum_Maximum">')

    20  format(' ',/,&
               '        <Grid Name="',A,'" Type="Uniform">'/,&
               '            <Topology TopologyType="POLYVERTEX" NodesPerElement="1" NumberOfElements="',i9,'"> </Topology>'/,&
               '            <Geometry GeometryType="XYZ">'/,&
               '                <DataItem ItemType="HyperSlab" Dimensions="',i9,' 3" Type="HyperSlab">'/,&
               '                    <DataItem Dimensions="2 3" Format="XML">'/,&
               '                        0      0        <!-- Start  -->'/,&
               '                        1      1        <!-- Stride -->'/,&
               '                        ',i9,' 3        <!-- Count  -->'/,&
               '                    </DataItem>'/,&
               '                    <DataItem ItemType="Uniform" Format="HDF" NumberType="Float" Precision="8" Dimensions="',i9,' 3">'/,&
               '                        &DataFile;:',A,/,&
               '                    </DataItem>'/,&
               '                </DataItem>'/,&
               '            </Geometry>'/,&
               ' '/,&
               '            <!-- ',A,' -->'/,&
               '            <Attribute Active="1" Type="Scalar" Center="Node" Name="',A,'">'/,&
               '                <DataItem ItemType="Uniform" Format="HDF" NumberType="Float" Precision="8" Dimensions="',i9,'">'/,&
               '                    &DataFile;:',A,/,&
               '                </DataItem>'/,&
               '            </Attribute>'/,&
               ' '/,&
               '            <!-- ',A,' -->'/,&
               '            <Attribute Active="1" Type="Scalar" Center="Node" Name="',A,'">'/,&
               '                <DataItem ItemType="Uniform" Format="HDF" NumberType="Int" Precision="4" Dimensions="',i9,'">'/,&
               '                    &DataFile;:',A,/,&
               '                </DataItem>'/,&
               '            </Attribute>'/,&
               '        </Grid>')

    80  format(' ',/,&
               '    </Domain>'/,&
               '</Xdmf>')

    100 write(*,*) 'Could not OPEN xdmf-file ... exiting'
        return

    end subroutine xdmf_write_minmax

!
!     -----------
!
!     write trajectory-information in xdmf format
!
!     -----------
!
    subroutine xdmf_write_etraj(fi_hdf5, traj_group_path, error)
        use hdf5
        use h5lt
        implicit none

        ! function vars
        character(len=*), intent(in)	:: fi_hdf5, traj_group_path
        integer,intent(out)			:: error

        ! usual stuff
        integer :: eid, file_unit
        integer :: i,j,k
        logical :: mae_type
        integer :: all_mms, mms, mmid, signs_type

        integer(HID_T):: file_id, group0_id
        character(LEN=64) :: eid_string, mae_type_string
        integer(HSIZE_T),dimension(2) :: dims2, maxdims2
        integer         :: type_class
        integer(SIZE_T):: type_size
        integer(HID_T) :: did, dspace_id

        integer :: mae, pos
        character(len=32) :: mae_string
        integer, dimension(:), allocatable   :: numLocalMMSEles
        integer, dimension(:,:), allocatable :: LocalMMSEles

    ! count number of minima/maxima
        mms = numends
!        do eid=1, numpairs
!            if(pairing(eid,1) .gt. mms) mms = pairing(eid,1)
!            if(pairing(eid,2) .gt. mms) mms = pairing(eid,2)
!        end do

    ! count number elements per minima/maxima
        allocate(numLocalMMSEles(mms),stat=error); if(error.ne.0) goto 200
        numLocalMMSEles = 0
        do eid=1, numpairs
            numLocalMMSEles(pairing(eid,1)) = numLocalMMSEles(pairing(eid,1)) +1
            numLocalMMSEles(pairing(eid,2)) = numLocalMMSEles(pairing(eid,2)) +1
        end do
        !write(*,*) '  found number of elements per minimum/maximum.'

    ! add elements to their minima/maxima
        allocate(LocalMMSEles(mms,0:maxval(numLocalMMSEles)),stat=error); if(error.ne.0) goto 200
        LocalMMSEles = 0
        do eid=1, numpairs
            LocalMMSEles( pairing(eid,1),0) = LocalMMSEles(pairing(eid,1),0) +1
            LocalMMSEles( pairing(eid,1), LocalMMSEles( pairing(eid,1),0 ) ) = eid
            LocalMMSEles( pairing(eid,2),0) = LocalMMSEles(pairing(eid,2),0) +1
            LocalMMSEles( pairing(eid,2), LocalMMSEles( pairing(eid,2),0 ) ) = eid
        end do
        !write(*,*) '  added diss.elements to their minima/maxima.'

    ! save xdmf-file
        call h5fopen_f(fi_hdf5, H5F_ACC_RDWR_F, file_id, error); if(error .ne. 0) goto 5
        call h5gopen_f(file_id, trim(traj_group_path)//'/etraj', group0_id, error); if(error .ne. 0) goto 5
        call h5eset_auto_f(0, error)

        open(unit=51, file=trim(fi_hdf5)//'_etraj_minatt.xmf', err=100, status='unknown', form='formatted', action='WRITE')
        rewind(51)
        open(unit=61, file=trim(fi_hdf5)//'_etraj_maxatt.xmf', err=100, status='unknown', form='formatted', action='WRITE')
        rewind(61)
        write(51,8) trim(fi_hdf5), 'Minimum' ! write xdmf-header'
        write(61,8) trim(fi_hdf5), 'Maximum' ! write xdmf-header'
        do mae=1, mms
            if(LocalMMSEles(mae,0) .eq. 0) cycle

            if(signs(mae) .eqv. .true.) then
                file_unit =61
                mae_type_string ='Maximum'
            else if(signs(mae) .eqv. .false.) then
                file_unit =51
                mae_type_string ='Minimum'
            endif

            write(mae_string,*) mae
            write(file_unit,10) trim(mae_type_string), trim(adjustl(mae_string))

            do pos=1, LocalMMSEles(mae,0)

                write(eid_string,*) LocalMMSEles(mae,pos)

                call h5dopen_f(group0_id, 'etraj_'//trim(adjustl(eid_string)), did, error); if(error .ne. 0) cycle
                call h5dget_space_f(did, dspace_id, error); if(error .ne. 0) cycle
                call h5sget_simple_extent_dims_f(dspace_id, dims2, maxdims2, error); if(error .ne. 2) cycle

                write(file_unit,20) trim(adjustl(eid_string)), dims2(2), &
                                               dims2(2), dims2(2), dims2(2), trim(traj_group_path)//'/etraj/etraj_'//trim(adjustl(eid_string)), &
                                     'scalar', dims2(2), dims2(2), dims2(2), trim(traj_group_path)//'/etraj/etraj_'//trim(adjustl(eid_string))

             enddo
             write(file_unit,15)

        enddo
        write(51,80) ! write xdmf-footer'
        write(61,80) ! write xdmf-footer'
        close(51)
        close(61)

        call h5eset_auto_f(1, error)
        call h5gclose_f(group0_id, error); if(error .ne. 0) goto 5
        call h5fclose_f(file_id, error); if(error .ne. 0) goto 5

        return

    5   write(*,*) 'HDF5 error ... exit'
        return

    8  format('<?xml version="1.0" ?>'/,&
               '<!DOCTYPE Xdmf SYSTEM "Xdmf.dtd" ['/,&
               '<!ENTITY DataFile  "',A,'">'/,&
               ']>'/,&
               '<Xdmf Version="2.0" xmlns:xi="http://www.w3.org/2001/XInclude" >'/,&
               '    <Domain Name="Diss.Elements">'/,&
               '        <Grid Name="',A,' Attached Elements" GridType="Tree">')

    10  format('                        <Grid Name="',A,'_Attached_Element_',A,'" GridType="Collection" CollectionType="Spatial">')

    15  format('                        </Grid>')

    20  format(' ',/,&
               '                                <Grid Name="etraj_',A,'" Type="Uniform">',/,&
               '                                        <Topology TopologyType="POLYLINE" NodesPerElement="', i9, ' "> </Topology>',/,&
               '                                        <Geometry GeometryType="XYZ">',/,&
               '                                                <DataItem ItemType="HyperSlab" Dimensions="', i9, ' 3">',/,&
               '                                                        <DataItem Dimensions="2 3" Format="XML">',/,&
               '                                                                0      0        <!-- Start  -->',/,&
               '                                                                1      1        <!-- Stride -->',/,&
               '                                                               ', i9, '  3  <!-- Count  -->',/,&
               '                                                        </DataItem>',/,&
               '                                                        <DataItem ItemType="Uniform" Format="HDF" NumberType="Float" Precision="8" Dimensions="', i9, ' 5">',/,&
               '                                                                &DataFile;:',A,/,&
               '                                                        </DataItem>',/,&
               '                                                </DataItem>',/,&
               '                                        </Geometry>',/,&
               '                                        <Attribute Active="1" Type="Scalar" Center="Node" Name="',A,'">',/,&
               '                                                <DataItem ItemType="HyperSlab" Dimensions="', i9, ' 1">',/,&
               '                                                        <DataItem Dimensions="2 3" Format="XML">',/,&
               '                                                                0      3        <!-- Start  -->',/,&
               '                                                                1      1        <!-- Stride -->',/,&
               '                                                               ', i9, '  1  <!-- Count  -->',/,&
               '                                                        </DataItem>',/,&
               '                                                        <DataItem ItemType="Uniform" Format="HDF" NumberType="Float" Precision="8" Dimensions="', i9, ' 5">',/,&
               '                                                                &DataFile;:',A,/,&
               '                                                        </DataItem>',/,&
               '                                                </DataItem>',/,&
               '                                        </Attribute>',/,&
               '                                </Grid>')

    80  format('        </Grid>'/,&
               '    </Domain>'/,&
               '</Xdmf>'/,&
               '')

    100 write(*,*) 'Could not OPEN xdmf-file ... exiting'
        return

    200	continue
        write(*,*) 'error allocating memory'
        stop

    end subroutine xdmf_write_etraj

!
!     -----------
!
!     write trajectory-information in xdmf format
!
!     -----------
!
    subroutine xdmf_write_etraj_bounds(fi_hdf5, traj_group_path, error)
        use hdf5
        use h5lt
        implicit none

        ! function vars
        character(len=*), intent(in)    :: fi_hdf5, traj_group_path
        integer,intent(out)         :: error

        ! usual stuff
        integer :: eid, file_unit
        integer :: i,j,k
        logical :: mae_type
        integer :: all_mms, mms, mmid, signs_type

        integer(HID_T):: file_id, group0_id
        character(LEN=64) :: eid_string, mae_type_string
        integer(HSIZE_T),dimension(2) :: dims2, maxdims2
        integer         :: type_class
        integer(SIZE_T):: type_size
        integer(HID_T) :: did, dspace_id

        integer :: mae, pos
        character(len=32) :: mae_string
        integer, dimension(:), allocatable   :: numLocalMMSEles
        integer, dimension(:,:), allocatable :: LocalMMSEles

    ! count number of minima/maxima
        mms = numends
!        do eid=1, numpairs
!            if(pairing(eid,1) .gt. mms) mms = pairing(eid,1)
!            if(pairing(eid,2) .gt. mms) mms = pairing(eid,2)
!        end do

    ! count number elements per minima/maxima
        allocate(numLocalMMSEles(mms),stat=error); if(error.ne.0) goto 200
        numLocalMMSEles = 0
        do eid=1, numpairs
            numLocalMMSEles(pairing(eid,1)) = numLocalMMSEles(pairing(eid,1)) +1
            numLocalMMSEles(pairing(eid,2)) = numLocalMMSEles(pairing(eid,2)) +1
        end do
        !write(*,*) '  found number of elements per minimum/maximum.'

    ! add elements to their minima/maxima
        allocate(LocalMMSEles(mms,0:maxval(numLocalMMSEles)),stat=error); if(error.ne.0) goto 200
        LocalMMSEles = 0
        do eid=1, numpairs
            LocalMMSEles( pairing(eid,1),0) = LocalMMSEles(pairing(eid,1),0) +1
            LocalMMSEles( pairing(eid,1), LocalMMSEles( pairing(eid,1),0 ) ) = eid
            LocalMMSEles( pairing(eid,2),0) = LocalMMSEles(pairing(eid,2),0) +1
            LocalMMSEles( pairing(eid,2), LocalMMSEles( pairing(eid,2),0 ) ) = eid
        end do
        !write(*,*) '  added diss.elements to their minima/maxima.'

    ! save xdmf-file
        call h5fopen_f(fi_hdf5, H5F_ACC_RDWR_F, file_id, error); if(error .ne. 0) goto 5
        call h5gopen_f(file_id, trim(traj_group_path)//'/etraj', group0_id, error); if(error .ne. 0) goto 5
        call h5eset_auto_f(0, error)

        open(unit=51, file=trim(fi_hdf5)//'_etraj_bounds_minatt.xmf', err=100, status='unknown', form='formatted', action='WRITE')
        rewind(51)
        open(unit=61, file=trim(fi_hdf5)//'_etraj_bounds_maxatt.xmf', err=100, status='unknown', form='formatted', action='WRITE')
        rewind(61)
        write(51,8) trim(fi_hdf5), 'Minimum' ! write xdmf-header'
        write(61,8) trim(fi_hdf5), 'Maximum' ! write xdmf-header'
        do mae=1, mms
            if(LocalMMSEles(mae,0) .eq. 0) cycle

            if(signs(mae) .eqv. .true.) then
                file_unit =61
                mae_type_string ='Maximum'
            else if(signs(mae) .eqv. .false.) then
                file_unit =51
                mae_type_string ='Minimum'
            endif

            write(mae_string,*) mae
            write(file_unit,10) trim(mae_type_string), trim(adjustl(mae_string))

            do pos=1, LocalMMSEles(mae,0)

                write(eid_string,*) LocalMMSEles(mae,pos)

                call h5dopen_f(group0_id, 'etraj_'//trim(adjustl(eid_string))//'_bounds', did, error); if(error .ne. 0) cycle
                call h5dget_space_f(did, dspace_id, error); if(error .ne. 0) cycle
                call h5sget_simple_extent_dims_f(dspace_id, dims2, maxdims2, error); if(error .ne. 2) cycle

                write(file_unit,20) trim(adjustl(eid_string)), dims2(2), &
                                               dims2(2), dims2(2), dims2(2), trim(traj_group_path)//'/etraj/etraj_'//trim(adjustl(eid_string))//'_bounds', &
                                     'scalar', dims2(2), dims2(2), dims2(2), trim(traj_group_path)//'/etraj/etraj_'//trim(adjustl(eid_string))//'_bounds'

             enddo
             write(file_unit,15)

        enddo
        write(51,80) ! write xdmf-footer'
        write(61,80) ! write xdmf-footer'
        close(51)
        close(61)

        call h5eset_auto_f(1, error)
        call h5gclose_f(group0_id, error); if(error .ne. 0) goto 5
        call h5fclose_f(file_id, error); if(error .ne. 0) goto 5

        return

    5   write(*,*) 'HDF5 error ... exit'
        return

    8  format('<?xml version="1.0" ?>'/,&
               '<!DOCTYPE Xdmf SYSTEM "Xdmf.dtd" ['/,&
               '<!ENTITY DataFile  "',A,'">'/,&
               ']>'/,&
               '<Xdmf Version="2.0" xmlns:xi="http://www.w3.org/2001/XInclude" >'/,&
               '    <Domain Name="Diss.Elements">'/,&
               '        <Grid Name="',A,' Attached Elements" GridType="Tree">')

    10  format('                        <Grid Name="',A,'_Attached_Element_',A,'" GridType="Collection" CollectionType="Spatial">')

    15  format('                        </Grid>')

    20  format(' ',/,&
               '                                <Grid Name="etraj_',A,'" Type="Uniform">',/,&
               '                                        <Topology TopologyType="POLYLINE" NodesPerElement="', i9, ' "> </Topology>',/,&
               '                                        <Geometry GeometryType="XYZ">',/,&
               '                                                <DataItem ItemType="HyperSlab" Dimensions="', i9, ' 3">',/,&
               '                                                        <DataItem Dimensions="2 3" Format="XML">',/,&
               '                                                                0      0        <!-- Start  -->',/,&
               '                                                                1      1        <!-- Stride -->',/,&
               '                                                               ', i9, '  3  <!-- Count  -->',/,&
               '                                                        </DataItem>',/,&
               '                                                        <DataItem ItemType="Uniform" Format="HDF" NumberType="Float" Precision="8" Dimensions="', i9, ' 5">',/,&
               '                                                                &DataFile;:',A,/,&
               '                                                        </DataItem>',/,&
               '                                                </DataItem>',/,&
               '                                        </Geometry>',/,&
               '                                        <Attribute Active="1" Type="Scalar" Center="Node" Name="',A,'">',/,&
               '                                                <DataItem ItemType="HyperSlab" Dimensions="', i9, ' 1">',/,&
               '                                                        <DataItem Dimensions="2 3" Format="XML">',/,&
               '                                                                0      3        <!-- Start  -->',/,&
               '                                                                1      1        <!-- Stride -->',/,&
               '                                                               ', i9, '  1  <!-- Count  -->',/,&
               '                                                        </DataItem>',/,&
               '                                                        <DataItem ItemType="Uniform" Format="HDF" NumberType="Float" Precision="8" Dimensions="', i9, ' 5">',/,&
               '                                                                &DataFile;:',A,/,&
               '                                                        </DataItem>',/,&
               '                                                </DataItem>',/,&
               '                                        </Attribute>',/,&
               '                                </Grid>')

    80  format('        </Grid>'/,&
               '    </Domain>'/,&
               '</Xdmf>'/,&
               '')

    100 write(*,*) 'Could not OPEN xdmf-file ... exiting'
        return

    200 continue
        write(*,*) 'error allocating memory'
        stop

    end subroutine xdmf_write_etraj_bounds

!
!     ------------
!
!     read test data
!
!     ------------
!
    subroutine test_read(fi_hdf5, input_dataset_path, traj_group_path, error)
        use hdf5
        use h5lt
        implicit none

        ! function vars
        character(len=*), intent(in)	:: fi_hdf5, input_dataset_path, traj_group_path
        integer,intent(out)			:: error

        ! usual stuff
        integer :: i,j,k
        integer(HID_T):: file_id
        integer(HSIZE_T),dimension(3) :: dims3

        error=0

        ! set dimensions
        ndims(1)=128  ! z
        ndims(2)=128  ! y
        ndims(3)=128  ! x

        spacedim = 3

        origdims(1) = ndims(1)
        origdims(2) = ndims(2)
        origdims(3) = ndims(3)
        subdomain(1,1) = 1; subdomain(1,2) = ndims(1)
        subdomain(2,1) = 1; subdomain(2,2) = ndims(2)
        subdomain(3,1) = 1; subdomain(3,2) = ndims(3)

        write(*,*) 'Reading Test-Case ...'
          ! set grid data
#ifndef _CUBIC_CELLS_
        if(.not. allocated(coordx)) then
        	allocate(coordx(ndims(1)),STAT=error); if(error.ne.0) goto 20
        endif
        coordx(:)=0.d0;
        do i=1,origdims(1)
            coordx(i) = pi2/ndims(1)*(i-1)
        enddo
        if(.not. allocated(coordy)) then
        	allocate(coordy(ndims(2)),STAT=error); if(error.ne.0) goto 20
        endif
        coordy(:)=0.d0;
        do j=1,origdims(2)
            coordy(j) = pi2/ndims(2)*(j-1)
        enddo
        if(.not. allocated(coordz)) then
        	allocate(coordz(ndims(3)),STAT=error); if(error.ne.0) goto 20
        endif
        coordz(:)=0.d0;
        do k=1,origdims(3)
            coordz(k) = pi2/ndims(3)*(k-1)
        enddo
#endif
          ! set scalar data field
        if(.not. associated(psi)) then
            call allocate_globals('psi',error)
            if(error.ne.0) goto 20
        endif
        psi(:,:,:)=0.d0
        do i=1,origdims(1)
          do j=1,origdims(2)
            do k=1,origdims(3)
              psi(i,j,k)=sin((pi2/origdims(1))*i) *sin((pi2/origdims(2))*j) *sin((pi2/origdims(3))*k)
            enddo
          enddo
        enddo

        call h5fopen_f(fi_hdf5, H5F_ACC_RDWR_F, file_id, error); if(error .ne. 0) goto 10

            dims3 = (/origdims(1),origdims(2),origdims(3)/)
            call h5LTmake_dataset_f(file_id, trim(input_dataset_path), 3, dims3, H5T_NATIVE_DOUBLE, psi, error); if(error .ne. 0) goto 10

        call h5fclose_f(file_id, error); if(error .ne. 0) goto 10

        return

    10	continue
        write(*,*) 'error writing test-psi to hdf5-file'
        stop

    20	continue
        write(*,*) 'error allocating memory'
        stop

    end subroutine test_read

!
!     ------------
!
!     read test data
!
!     ------------
!
    subroutine lipo_read(fo_lipo,ndims123,error)
        implicit none

        ! function vars
        character(len=*), intent(in)	:: fo_lipo
        integer, intent(in)	:: ndims123(3)
        integer,intent(out)	:: error

        ! usual stuff
        integer :: i,j,k, status

        ! additional file-settings
        double precision :: rtime,dt,turnov0,rtimen,visc,xmach,sh,st,stime
        double precision :: turbk0,turbdis0,epsc0,epss0,cmpk0,pavg
        integer :: jrstart,imesh,mflag,nflag
        integer :: idimension,jiter
        double precision, dimension(:,:,:), allocatable :: psi1

        ! for shift
        double precision, dimension(:,:),   allocatable :: comp
        double precision, dimension(:,:,:), allocatable :: input
        double precision :: cfact
        integer :: startp

        error=0
        write(*,*) 'reading lipo-file'

#ifndef _CUBIC_CELLS_
        write(*,*) 'lipo_read() does not support non-cubic input data'
        stop
#endif

        ndims    = ndims123
        origdims = ndims123

        ! min-ptr
        subdomain(1,1) = 1
        subdomain(2,1) = 1
        subdomain(3,1) = 1
        ! max-ptr
        subdomain(1,2) = 128
        subdomain(2,2) = 128
        subdomain(3,2) = 128

        call allocate_globals('psi',error); if(error.ne.0) goto 20

        allocate(psi1(ndims(1)+2,ndims(2)+1,ndims(3)+1),stat=error); if(error.ne.0) goto 20
        open(unit=57,file=fo_lipo,form='unformatted')
          read(57) jiter
          read(57) rtime,dt,turnov0,rtimen,visc,xmach,sh,st,stime
          read(57) turbk0,turbdis0,epsc0,epss0,cmpk0,pavg
          read(57) jrstart,imesh,mflag,nflag
          read(57) idimension
          read(57) psi1(:,:,:) !           1: ut
          read(57) psi1(:,:,:) !           1: vt
          read(57) psi1(:,:,:) !           1: wt
          read(57) psi1(:,:,:) !           1: p
          read(57) psi1(:,:,:) !           1: rhot
          read(57) psi1(:,:,:) !           1: (z1')t
        !  read(57) psi1(:,:,:) !           1: (z2')t
        close(57)

        write(*,*)
        write(*,*) 'found following settings:'
          write(*,*) 'rtime', rtime
          write(*,*) 'dt', dt
          write(*,*) 'turnov0', turnov0
          write(*,*) 'rtimen', rtimen
          write(*,*) 'visc', visc
          write(*,*) 'xmach', xmach
          write(*,*) 'sh', sh
          write(*,*) 'st', st
          write(*,*) 'stime', stime
          write(*,*) 'turbk0', turbk0
          write(*,*) 'turbdis0', turbdis0
          write(*,*) 'epsc0', epsc0
          write(*,*) 'epss0', epss0
          write(*,*) 'cmpk0', cmpk0
          write(*,*) 'pavg', pavg
          write(*,*) 'jrstart', jrstart
          write(*,*) 'imesh', imesh
          write(*,*) 'mflag', mflag
          write(*,*) 'nflag', nflag

    !!	shift grid (psi) !!
        write(*,*)
        write(*,*) 'shifting data with st=',st
        allocate(comp(2*ndims123(1),2),stat=error); if(error.ne.0) goto 20
        allocate(input(ndims123(1)+2,ndims123(2)+1,ndims123(3)+1),stat=error); if(error.ne.0) goto 20
        do k=1,ndims(3)
          do j=1,ndims(2)

            if(st .ge. 0.d0) then
              do i=1,ndims(1)
    !			the meaning of comp is: (,1):coordinate of x,(,2):value of array
                comp(i,1)     = i-ndims(1)+j*st
                comp(i,2)     = psi1(i,j,k)
                comp(i+512,1) = i+j*st
                comp(i+512,2) = psi1(i,j,k)
              enddo
            else
              do i=1,ndims(1)
                comp(i,1)     = i+j*st
                comp(i,2)     = psi1(i,j,k)
                comp(i+512,1) = i+ndims(1)+j*st
                comp(i+512,2) = psi1(i,j,k)
              enddo
            endif

            do i=1,2*ndims(1)-1
              if(comp(i,1) .lt. 1 .and. comp(i+1,1) .ge. 1) then
                cfact=1.d0-comp(i,1)
                startp=i
              endif
            enddo

            do i=1,ndims(1)
              psi1(i,j,k)=(1.d0-cfact)*comp(startp+i-1,2) +cfact*comp(startp+i,2)
            enddo

          enddo
        enddo

        do k=1,ndims(3)
          do j=1,ndims(2)
              do i=1,ndims(1)
                psi(i,j,k) = psi1(i,j,k)
              enddo
          enddo
        enddo

        deallocate(psi1)
        deallocate(comp)
        deallocate(input)

        return

    20	continue
        write(*,*) 'error allocating memory'
        stop

    end subroutine lipo_read

!
!     ------------
!
!	interpolate grid value
!
!     ------------
!
    function interp(x,y,z, data)
        implicit none

    !	function arguments
        double precision              :: interp
        double precision, intent(in) :: x,y,z

        double precision, dimension(:,:,:), intent(in) :: data

    !	usual vars
        integer :: i,j,k
        double precision :: posx, posy, posz

        i = x
        j = y
        k = z
        posx = x -i
        posy = y -j
        posz = z -k

        interp =	( (     posx) *(     posy) *(     posz) ) *data(i+1, j+1, k+1) +		&
                    ( (1.d0-posx) *(     posy) *(     posz) ) *data(i  , j+1, k+1) +		&
                    ( (1.d0-posx) *(1.d0-posy) *(     posz) ) *data(i  , j  , k+1) +		&
                    ( (     posx) *(1.d0-posy) *(     posz) ) *data(i+1, j  , k+1) +		&
                    ( (     posx) *(     posy) *(1.d0-posz) ) *data(i+1, j+1, k  ) +		&
                    ( (1.d0-posx) *(     posy) *(1.d0-posz) ) *data(i  , j+1, k  ) +		&
                    ( (1.d0-posx) *(1.d0-posy) *(1.d0-posz) ) *data(i  , j  , k  ) +		&
                    ( (     posx) *(1.d0-posy) *(1.d0-posz) ) *data(i+1, j  , k  )

    end function interp

!
!     ------------
!
!	interpolate grid value
!
!     ------------
!
#ifdef _PAGE_SIZED_MEMORY_BLOCKS_
    function interp_b(x,y,z, data)
        implicit none

    !	function arguments
        double precision              :: interp_b
        double precision, intent(in) :: x,y,z

        double precision, dimension(:,:,:,:,:,:), intent(in) :: data

    !	usual vars
        integer :: i,j,k
        double precision :: posx, posy, posz

        i = x
        j = y
        k = z
        posx = x -i
        posy = y -j
        posz = z -k

        interp_b =	( (     posx) *(     posy) *(     posz) ) *psmb_arr_3d(data,i+1, j+1, k+1) +		&
                    ( (1.d0-posx) *(     posy) *(     posz) ) *psmb_arr_3d(data,i  , j+1, k+1) +		&
                    ( (1.d0-posx) *(1.d0-posy) *(     posz) ) *psmb_arr_3d(data,i  , j  , k+1) +		&
                    ( (     posx) *(1.d0-posy) *(     posz) ) *psmb_arr_3d(data,i+1, j  , k+1) +		&
                    ( (     posx) *(     posy) *(1.d0-posz) ) *psmb_arr_3d(data,i+1, j+1, k  ) +		&
                    ( (1.d0-posx) *(     posy) *(1.d0-posz) ) *psmb_arr_3d(data,i  , j+1, k  ) +		&
                    ( (1.d0-posx) *(1.d0-posy) *(1.d0-posz) ) *psmb_arr_3d(data,i  , j  , k  ) +		&
                    ( (     posx) *(1.d0-posy) *(1.d0-posz) ) *psmb_arr_3d(data,i+1, j  , k  )

    end function interp_b
#endif

end module mod_io

