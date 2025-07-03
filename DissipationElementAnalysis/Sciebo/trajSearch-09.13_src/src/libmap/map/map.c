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

#include "map.h"
#include "memory.h"

#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

static struct MapNode_ finalNode = { BLACK };

#define newNode() &finalNode
#define isEmpty(root) (root == &finalNode)

Map mapNew(void) 
{
	Map this = malloc(sizeof(struct Map_));
	this->root = newNode();
	this->size = 0;
	return this;
}

int mapIsEmpty(Map this) {
	return (this->size == 0);
}

int mapSize(Map this) {
	return this->size;
}

#define isBlackNode(node) ((node)->color == BLACK)
#define isRedNode(node) (!isBlackNode(node))

static void delete(MapNode root) {
	if(!isEmpty(root)) {
		delete(root->l);
		delete(root->r);
		free(root);
	}
}

void mapDelete(Map this) {
	delete(this->root);
	free(this);
}

static MapNode mkNewRedNode(Key k, Value v)
{
	MapNode node = malloc(sizeof(struct MapNode_));

	node->color = RED;
	node->k = k;
	node->v = v; 
	node->l = newNode();
	node->r = newNode();

	return node;
}

static MapNode getNode(MapNode node, Key k) {
	if (isEmpty(node))
		return NULL;

	switch (compare(k, node->k)) {
		case -1:
			return getNode(node->l, k);
		case 0:
			return node;
		case +1:
			return getNode(node->r, k);
	}

	return NULL;
}

Value mapGetValue(Map this, Key k) {
	MapNode node = getNode(this->root, k);
	return (node != NULL) ? node->v : NULL;
}

int mapContains(Map this, Key k)
{
	return (getNode(this->root, k) != NULL);
}

static void call(MapNode node,  void func(Value)) {
	if (!isEmpty(node)) {
		call (node->l, func);
		func(node->v);
		call (node->r, func);
	}
}

void mapCall(Map this, void func(Value)) {
	call(this->root, func);
}

static int hasRedChild(MapNode node)
{
	return !isEmpty(node) && (isRedNode(node->l) || isRedNode(node->r));
}

static MapNode balanceTrees(MapNode x, MapNode y, MapNode z, MapNode b, MapNode c)
{
	x->r = b;
	z->l = c;

	y->l = x;
	y->r = z;

	x->color = BLACK;
	z->color = BLACK;
	y->color = RED;

	return y;
}

static MapNode checkBalanceLeft(MapNode node)
{
	assert(!isEmpty(node));

	if (isRedNode(node))
    		return node;

	if (isRedNode(node->l) && isRedNode(node->l->l))
    		return balanceTrees(node->l->l,
			node->l,
			node,
			node->l->l->r,
			node->l->r);

	if (isRedNode(node->l) && isRedNode(node->l->r))
		return balanceTrees(node->l,
			node->l->r,
			node,
			node->l->r->l,
			node->l->r->r);
	return node;
}

static MapNode checkBalanceRight(MapNode node)
{
	assert(!isEmpty(node));

	if (isRedNode(node))
		return node;

	if (isRedNode(node->r) && isRedNode(node->r->l))
		return balanceTrees(node,
			node->r->l,
			node->r,
			node->r->l->l,
			node->r->l->r);

	if (isRedNode(node->r) && isRedNode(node->r->r))
		return balanceTrees(node,
			node->r,
			node->r->r,
			node->r->l,
			node->r->r->l);

	return node;
}

static MapNode insertElem1(MapNode node, Key k, Value v, Map map)
{
	if (isEmpty(node)) {
		map->size++;
		return mkNewRedNode(k, v);
	}

	switch (compare(k, node->k)) {
		case -1:
			node->l = insertElem1(node->l, k, v, map);
			return checkBalanceLeft(node);
		case 0:
			node->v = v;
			break;
		case +1:
      			node->r = insertElem1(node->r, k, v, map);
			return checkBalanceRight(node);
    	}

	return node;
}

void mapSetValue(Map this, Key k, Value v)
{
	MapNode root = insertElem1(this->root, k, v, this);
	root->color = BLACK;	/* the root is always black */
	this->root = root;
}

void mapIncValue(Map this, Key k, unsigned int increment) {
	MapNode node = getNode(this->root, k);
	if(node)
		((unsigned long long)(node->v)) += increment;
	else
		mapSetValue(this, k, (Value) increment);
}
