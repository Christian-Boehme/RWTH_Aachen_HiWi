
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

#include <stdlib.h>
#include "map2d.h"
#include "memory.h"

#define mkLong(x,y) ((((unsigned long long) x) << 32) + y) 

Map2d map2dNew(void) {
	Map2d this = malloc(sizeof(struct Map2d_));
	this->map = mapNew();
	return this;
}

void map2dDelete(Map2d this) {
	mapDelete(this->map);
	free(this);
}

int map2dIsEmpty(Map2d this) {
	return mapIsEmpty(this->map);
}

int map2dSize(Map2d this) {
	return mapSize(this->map);
}

int map2dContains(Map2d this, unsigned int x, unsigned int y) {
	return mapContains(this->map, mkLong(x,y));
}

void map2dSet(Map2d this, unsigned int x, unsigned int y, unsigned int v) {
	mapSetValue(this->map, mkLong(x,y), (Value) v);
}

unsigned int map2dGet(Map2d this, unsigned int x, unsigned int y) {
	return (unsigned int) mapGetValue(this->map, mkLong(x,y));
}
