
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

! Laufzeittest zur Abschaetzung wie lange man braucht um eine Anzahl von Elementen mehrfach zu Durchlaufen
!
! Folgende Konfiguration simuliert 2048 * 2048 * 2048 suchvorgaenge in 1024*1024 (> 1000000) Elementen
! integer, parameter :: elm = 1024 * 1024
! integer, parameter :: fact = 1024
! integer, parameter :: runs = 8 
!
! Folgende Konfiguration simuliert 512 * 512 * 512 suchvorgaenge in 16*1024 (> 16000) Elementen
! integer, parameter :: elm = 16 * 1024
! integer, parameter :: fact = 512 * 16
! integer, parameter :: runs = 1


program test_map
use map2d
implicit none

integer*8 :: map
integer :: i,j,k
integer :: k0
integer, parameter :: elm = 16 * 1024
integer, parameter :: fact = 512 * 16
integer, parameter :: runs = 1 
integer, parameter :: search = elm * fact
integer, parameter :: verbose = 1

map = m2new()

! insert elm number of elements
do i=1,elm
        call m2set(map, i*fact, 1, i)
enddo

! simulate searches and check if stored value is correct
do k=1,runs
	j=2
	do i=1,search
		k0 = m2get(map, i, 1)
		if (k0 .gt. 0 .and. verbose .gt. 0 .and. mod(k0, 64) .eq. 0) write (*,*) "found ", k0
	
		if (j .eq. 1) then
			if (k0 .ne. i/fact) write (*,*) "problem k0 not i/fact: i,k0,i/fact=",i , k0,  i/fact
		else
			if (k0 .ne. 0) write (*,*) "problem k0 not 0: i,k0=",i , k0
		endif

		if (j .ge. fact) then
			j = 1
		else
			j = j + 1
		endif
	enddo
enddo

write (*,*) "elements, searches =", m2size(map), search

call m2delete(map)

end program test_map

