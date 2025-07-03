/**
  * Copyright (c): Uwe Schmidt, FH Wedel
  *
  * You may study, modify and distribute this source code
  * FOR NON-COMMERCIAL PURPOSES ONLY.
  * This copyright message has to remain unchanged.
  *
  * Note that this document is provided 'as is',
  * WITHOUT WARRANTY of any kind either expressed or implied.
  */

/**
  * Map modifications and extensions by Nicolas Berr, RWTH-Aachen
  *
  * This code was derived from its original located at:
  * http://www.fh-wedel.de/~si/vorlesungen/c/beispiele/redblacktree/index.html
  */

#ifndef __MAP_H__
#define __MAP_H__

#include "key.h"
#include "value.h"

typedef struct MapNode_ *MapNode;

struct MapNode_
{
	enum { RED, BLACK } color;
	Key k;	
	Value v; 
	MapNode l;	
	MapNode r;
};

typedef struct Map_ *Map;

struct Map_ {
	MapNode root;
	int size;
};


Map mapNew(void);
void mapDelete(Map this);
int mapIsEmpty(Map this);
int mapSize(Map this);
int mapContains(Map this, Key k);
void mapCall(Map this, void func(Value));
void mapSetValue(Map this, Key k, Value v);
void mapIncValue(Map this, Key k, unsigned int increment);
Value mapGetValue(Map this, Key k);

#endif
