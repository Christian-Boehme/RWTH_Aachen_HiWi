
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

#ifndef __MEMORY_H__
#define __MEMORY_H__

#ifdef MALLOC_VARIANT
#if (MALLOC_VARIANT==1)
#define USE_KMP_MALLOC 1
#elif (MALLOC_VARIANT==2)
#define USE_MY_MALLOC 1
#endif
#endif

/* use Thread-Local memory when using OpenMP */

#ifdef _OPENMP

#include <omp.h>
#if USE_KMP_MALLOC
#define malloc(size) kmp_malloc(size)
#define free(ptr) kmp_free(ptr) 
#else
#if USE_MY_MALLOC
#define malloc(size) mymalloc(size)
#define free(ptr) myfree(ptr)
#endif
#endif

#endif

#include <stdlib.h>

void* mymalloc(size_t size);
void myfree(void* ptr);

#endif
