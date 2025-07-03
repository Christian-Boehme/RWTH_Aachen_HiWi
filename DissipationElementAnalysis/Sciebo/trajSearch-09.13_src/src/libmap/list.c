
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

#include "list.h"
#include "memory.h"

#include <stdlib.h>
#include <assert.h>

List listNew(void) {
	List this = malloc(sizeof(struct List_));
	this->first = NULL;
	this->last = NULL;
	this->size = 0;
	return this;
}

void listDelete(List this) {
	listClear(this);
	free(this);
}

int listIsEmpty(List this) {
	return (this->size <= 0);
}

int listSize(List this) {
	return this->size;
}

void listClear(List this) {
	while(!listIsEmpty(this))
		listPopFront(this);
}

void listPushBack(List this, Value v){
	ListNode node = malloc(sizeof(struct ListNode_));
	node->v = v;
	node->next = NULL;

	if(this->last) {
		/* first != NULL && last != NULL !!! */
		this->last->next = node;
		this->last = node;
	}
	else { 
		/* first == last == NULL !!! */
		this->first = node;
		this->last = node;
	}

	this->size++;
}

void listPushFront(List this, Value v) {
	ListNode node = malloc(sizeof(struct ListNode_));
	node->v = v;
	node->next = this->first;
	
	this->first = node;
	if(this->last == NULL)
		this->last = node;

	this->size++;
}

Value listPopFront(List this) {
	Value ret;
	ListNode node;

	assert(this->first != NULL);

	node = this->first;
	this->first = node->next;

	ret = node->v;
	free(node);

	this->size--;
	return ret;
}

Value listGetFirst(List this) {
	assert(this->first != NULL);
	return this->first->v;
}

Value listGetLast(List this) {
	assert(this->last != NULL);
	return this->last->v;
}

ListIterator listIteratorBegin(List list) {
	return list->first;
}

ListIterator listIteratorEnd() {
	return NULL;
}

ListIterator listIteratorNext(ListIterator this) {
	assert(this != NULL);
	return this->next;		
	
}

Value listIteratorGetValue(ListIterator this) {
	assert(this != NULL);
	return this->v;
}

