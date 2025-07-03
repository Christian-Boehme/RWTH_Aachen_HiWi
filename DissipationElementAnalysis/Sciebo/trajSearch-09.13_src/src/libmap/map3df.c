
/*
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
*/

#include "map3d.h"

Map3d m3new_(void) {
	return map3dNew();
}

void m3delete_(Map3d* map) {
	map3dDelete(*map);
}

int m3empty_(Map3d* map) {
	return map3dIsEmpty(*map);
}

int m3size_(Map3d* map) {
	return map3dSize(*map);	
}

int m3contains_(Map3d* map, unsigned int* x, unsigned int* y, unsigned int* z) {
	return map3dContains(*map, *x, *y, *z);
}

void m3set_(Map3d* map, unsigned int* x, unsigned int* y, unsigned int* z, unsigned int* v) {
	map3dSet(*map, *x, *y, *z, *v);
}

unsigned int m3get_(Map3d* map, unsigned int* x, unsigned int* y, unsigned int* z) {
	return map3dGet(*map, *x, *y, *z);
}
