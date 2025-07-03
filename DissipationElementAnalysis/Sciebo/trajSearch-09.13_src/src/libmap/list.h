
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

#ifndef __LIST_H__
#define __LIST_H__

#include "value.h"

typedef struct ListNode_ *ListNode;

struct ListNode_
{
	Value v; 
	ListNode next;
};

typedef struct List_ *List;

struct List_ {
	ListNode first;
	ListNode last;
	int size;
};

typedef ListNode ListIterator;

List listNew(void);
void listDelete(List this);
int listIsEmpty(List this);
int listSize(List this);
void listClear(List this);
void listPushBack(List this, Value v);
void listPushFront(List this, Value v);
Value listPopFront(List this);
Value listGetFirst(List this);
Value listGetLast(List this);

ListIterator listIteratorBegin(List list);
ListIterator listIteratorEnd();
ListIterator listIteratorNext(ListIterator this);
Value listIteratorGetValue(ListIterator this);

#endif
