
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
#include <math.h>
#include "proximity_map.h"
#include "memory.h"

static void freelist(Value v) {
	if (v)
		listDelete((List) v);
}

ProximityMap proximityMapNew(double proximityRange){
	ProximityMap this = malloc(sizeof(struct ProximityMap_));
	this->map = map3dNew();
	this->elements = listNew();
	this->range = proximityRange;
	return this;
}

void proximityMapDelete(ProximityMap this) {
	map3dCall(this->map, freelist);
	map3dDelete(this->map);
	while(!listIsEmpty(this->elements)) {
		free(listPopFront(this->elements));
	}
	listDelete(this->elements);
	free(this);
}

int proximityMapIsEmpty(ProximityMap this) {
	return listIsEmpty(this->elements);
}

int proximityMapSize(ProximityMap this) {
	return (listSize(this->elements));
}

#define trans(x,range) ((int)(x/range))

static Element mkElement(double x, double y, double z, int v) {
	Element ret = malloc(sizeof(struct Element_));
	ret->x = x;
	ret->y = y;
	ret->z = z;
	ret->v = v;
	return ret;
}

int proximityMapContains(ProximityMap this, double x, double y, double z) {
	return (proximityMapGetElement(this, x, y, z) != NULL);
}

void proximityMapInsert(ProximityMap this, double x, double y, double z, unsigned int v) {
	int x0,y0,z0;
	Element element;
	List target;
	int i,j,k;

	x0 = trans(x,this->range);
	y0 = trans(y,this->range);
	z0 = trans(z,this->range);

	element = mkElement(x,y,z,v);
	listPushBack(this->elements, element);

	for(i=-1; i<2; i++) {
		for(j=-1; j<2; j++) {
			for(k=-1; k<2; k++) {
				if (x0+i >= 0 && y0+j >= 0 && z0+k >= 0) {
					target = map3dGetValue(this->map, x0+i, y0+j, z0+k);
					if (target == NULL) {
						target = listNew();
						map3dSetValue(this->map, x0+i, y0+j, z0+k, target);
					}
					listPushBack(target, element);
				}
			}
		}
	}
}

#define quad(x) ((x)*(x))

static int inProximity(double x, double y, double z, Element e, double range) {
#ifndef _CUBIC_CELLS_
	return (fabs(x - e->x) < range && fabs(y - e->y) < range && fabs(z - e->z) < range);
#else
	double distance;
	distance = sqrt(quad(x - e->x) + quad(y - e->y) + quad(z - e->z));
	return distance < range;
#endif
}

Element proximityMapGetElement(ProximityMap this, double x, double y, double z) {
	ListIterator itr; 
	List target = map3dGetValue(this->map, trans(x,this->range), trans(y,this->range), trans(z,this->range));
	if (target != NULL) {
		for(itr = listIteratorBegin(target); itr != listIteratorEnd(); itr=listIteratorNext(itr)) {
			if (inProximity(x, y, z, listIteratorGetValue(itr), this->range))
				return ((Element)listIteratorGetValue(itr));
		}
	}
	
	return NULL;
}

unsigned int proximityMapGet(ProximityMap this, double x, double y, double z) {
	Element e = proximityMapGetElement(this, x, y, z);
	return (e) ? e->v : 0;
}
