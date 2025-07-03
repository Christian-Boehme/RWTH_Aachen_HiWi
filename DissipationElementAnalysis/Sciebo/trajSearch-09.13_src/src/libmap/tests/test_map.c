
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

#include <stdio.h>

#include "map.h"
#include "map2d.h"

#define TEST2D 0

int main(int argc, char *argv[])
{
	unsigned int noOfElems = 256*256;
	unsigned int fact = 256;
	unsigned int noOfSearches = noOfElems * fact;
	unsigned int i,j,k;
	Map m = mapNew();
	Map2d m2 = map2dNew();

	if (argc == 2)	
		sscanf(argv[1], "%u", &noOfElems);

	for (i = 1; i <= noOfElems; ++i)
        	mapSetValue(m, i*fact, (Value) i);

	for (i = 1; i <= noOfSearches; ++i)
        	mapContains(m, i);


	printf("size: %d\n", mapSize(m));

#if TEST2D
	for(i=0; i<10; i++)
		for(j=0; j<10; j++)
			map2dSet(m2,i,j,i+j);
	printf("%d %d %d\n", map2dSize(m2), map2dGet(m2,1,9), map2dGet(m2,12,15));
#endif

	mapDelete(m);
	map2dDelete(m2);

  return 0;
}



