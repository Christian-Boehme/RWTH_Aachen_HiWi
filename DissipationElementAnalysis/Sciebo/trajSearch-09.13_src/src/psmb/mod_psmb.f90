!
! Copyright (C) 2010 by Institute of Combustion Technology - RWTH Aachen University
! Nicolas Berr
! All rights reserved.
!
module mod_psmb
    use iso_c_binding

    type(c_ptr) :: cptr

    interface
        subroutine posix_memalign(mem,align,size) bind(c,name='posix_memalign')
            use iso_c_binding
            type(c_ptr), intent(out) :: mem
            integer(c_size_t), intent(in), value :: align, size
        end subroutine

        subroutine free(mem) bind(c,name='free')
            use iso_c_binding
            type(c_ptr), intent(in), value :: mem
        end subroutine
    end interface

end module mod_psmb
