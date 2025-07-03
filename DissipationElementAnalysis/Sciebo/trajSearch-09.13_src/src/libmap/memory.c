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
#include <stdio.h>

#ifdef _OPENMP
#include <omp.h>
#endif

#define MAX_MEM 1024*1024*64

static char* base = NULL;
static size_t count = 0;

#pragma omp threadprivate(base, count)

void* mymalloc(size_t size) {
	void* ret;
	if (size % 8 > 0)
		size += 8 - (size % 8);
	if(base) {
		ret = base + count;
		count += size;
		if (count > MAX_MEM) {
			fprintf(stderr, "memory.c: memory limit reached\n");
			exit(-1);
		}
	}
	else {
		base = malloc(MAX_MEM);
		count = size;
		if (base == NULL) {
			fprintf(stderr, "memory.c: no memory left for heap-block\n");
			exit(-1);
		}	
		ret = base;
	}
	return ret;
}

void myfree(void* ptr) {
	/* free currently is not implemented */
	/* it simply does nothing */
}

