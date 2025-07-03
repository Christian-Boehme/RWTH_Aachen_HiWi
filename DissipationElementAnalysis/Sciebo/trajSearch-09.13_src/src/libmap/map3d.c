
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
#include <assert.h>
#include "map3d.h"
#include "memory.h"

#define mkLong(x,y,z) ((((((unsigned long long) x) << 21) + y) << 21) + z) 

#define ASSERT_KEY_RANGE(x,y,z) \
	assert(x < (1 << 22));\
	assert(y < (1 << 22));\
	assert(z < (1 << 22));

Map3d map3dNew(void) {
	Map3d this = malloc(sizeof(struct Map3d_));
	this->map = mapNew();
	return this;
}

void map3dDelete(Map3d this) {
	mapDelete(this->map);
	free(this);
}

int map3dIsEmpty(Map3d this) {
	return mapIsEmpty(this->map);
}

int map3dSize(Map3d this) {
	return mapSize(this->map);
}

int map3dContains(Map3d this, unsigned int x, unsigned int y, unsigned int z) {
	ASSERT_KEY_RANGE(x,y,z);
	return mapContains(this->map, mkLong(x,y,z));
}

void map3dCall(Map3d this, void func(Value)) {
	mapCall(this->map, func);
}

void map3dSetValue(Map3d this, unsigned int x, unsigned int y, unsigned int z, Value v) {
	ASSERT_KEY_RANGE(x,y,z);
	mapSetValue(this->map, mkLong(x,y,z), v);
}

Value map3dGetValue(Map3d this, unsigned int x, unsigned int y, unsigned int z) {
	ASSERT_KEY_RANGE(x,y,z);
	return mapGetValue(this->map, mkLong(x,y,z));
}

void map3dSet(Map3d this, unsigned int x, unsigned int y, unsigned int z, unsigned int v) {
	map3dSetValue(this, y, y, z, (Value) v);
	
}

unsigned int map3dGet(Map3d this, unsigned int x, unsigned int y, unsigned int z) {
	return ((unsigned int) map3dGetValue(this, x, y, z));
}
