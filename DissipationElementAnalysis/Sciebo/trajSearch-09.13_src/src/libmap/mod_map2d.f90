
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

MODULE map2d
        INTERFACE

                INTEGER*8 FUNCTION m2new()
                END FUNCTION m2new

                SUBROUTINE m2delete(map)
                INTEGER*8 map
                END SUBROUTINE m2delete

                INTEGER FUNCTION m2empty(map)
                INTEGER*8 map
                END FUNCTION m2empty

                INTEGER FUNCTION m2size(map)
                INTEGER*8 map
                END FUNCTION m2size

                INTEGER FUNCTION m2contains(map, x, y)
                INTEGER*8 map
                INTEGER x, y
                END FUNCTION m2contains

                SUBROUTINE m2set(map, x, y, v)
                INTEGER*8 map
                INTEGER x, y, v
                END SUBROUTINE m2set

                INTEGER FUNCTION m2get(map, x, y)
                INTEGER*8 map
                INTEGER x, y
                END FUNCTION m2get

        END INTERFACE
END MODULE map2d
