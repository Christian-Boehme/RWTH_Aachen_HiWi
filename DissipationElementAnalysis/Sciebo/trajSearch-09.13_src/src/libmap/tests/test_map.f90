
!  
! Copyright (c) 2011, Nicolas Berr, RWTH-Aachen
! All rights reserved.
!  
! Redistribution and use in source and binary forms, with or without
! modification, are permitted provided that the following conditions are met:
!     * Redistributions of source code must retain the above copyright
!       notice, this list of conditions and the following disclaimer.
!     * Redistributions in binary form must reproduce the above copyright
!       notice, this list of conditions and the following disclaimer in the
!       documentation and/or other materials provided with the distribution.
!     * Neither the name of the <organization> nor the
!       names of its contributors may be used to endorse or promote products
!       derived from this software without specific prior written permission.
! 
! THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
! ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
! WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
! DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
! DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
! (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
! LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
! ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
! (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
! SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
!

program test_map
use map2d
implicit none

integer*8 :: map
integer :: i,j
integer :: i0, j0, k0
integer, parameter :: elm = 256 * 256
integer, parameter :: fact = 256
integer, parameter :: search = elm * fact
integer, parameter :: check = 0
integer, parameter :: do_memio = 0
integer :: dummy
integer, dimension(256,256,256,2) :: numbering
integer, dimension(256,256,256) :: note, note2, note3

numbering = 1
note=1
note2=1
note3=1

map = m2new()

do i=1,elm
        call m2set(map, i*fact, 1, i)
enddo

do i=1,search
        i0 = mod(i, 256)
        j0 = mod((i / 256), 256)
        k0 = (i / 256) / 256
        if (m2get(map, i, 1) .gt. 0) then
                dummy = dummy + 1
        endif
        if (do_memio .gt. 0 ) then
                note(i0, j0, k0) = dummy
                note2(i0, j0, k0) = note2(i0, j0, k0)  + 1
                note3(i0, j0, k0) = note3(i0, j0, k0)  + 1
                if (numbering(i0, j0, k0,1) .gt. 1 .and. numbering(i0, j0, k0,2) .gt. 1) then
                        dummy = dummy + numbering(i0, j0, k0,1)
                endif
        endif
enddo

write (*,*) "elements, searches =", m2size(map), search

if (check .gt. 0) then
        do i=1,10
                do j=1,10
                        call m2set(map, i, j, i+j)
                enddo
        enddo
        write (*,*) m2get(map,1,2), m2get(map,5,5), m2get(map,10,10), m2get(map,11,11), m2size(map)
endif

call m2delete(map)

end program test_map

