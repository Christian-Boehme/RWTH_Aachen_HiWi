
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

MODULE map3d
        INTERFACE

                INTEGER*8 FUNCTION m3new()
                END FUNCTION m3new

                SUBROUTINE m3delete(map)
                INTEGER*8 map
                END SUBROUTINE m3delete

                INTEGER FUNCTION m3empty(map)
                INTEGER*8 map
                END FUNCTION m3empty

                INTEGER FUNCTION m3size(map)
                INTEGER*8 map
                END FUNCTION m3size

                INTEGER FUNCTION m3contains(map, x, y, z)
                INTEGER*8 map
                INTEGER x, y, z
                END FUNCTION m3contains

                SUBROUTINE m3set(map, x, y, z, v)
                INTEGER*8 map
                INTEGER x, y, z, v
                END SUBROUTINE m3set

                INTEGER FUNCTION m3get(map, x, y, z)
                INTEGER*8 map
                INTEGER x, y, z
                END FUNCTION m3get

        END INTERFACE
END MODULE map3d
