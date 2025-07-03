LIB = ../libmap.a

TARGETS = test_map test_map_f test_map_f2 test_map_f3 test_list test_proximity_map test_proximity_map_f

CC = icc 
FC = ifort
INCLUDE = -I.. -I../map

OPT =  -fast -O3
# OPT = -O3 -g

CFLAGS = -DNDEBUG=1 -D_CUBIC_CELLS_

default: $(TARGETS)

test_map: $(LIB_TARGETS) Makefile
	$(CC) $(OPT) -o test_map test_map.c $(LIB) $(INCLUDE)
	
test_map_f: $(LIB) Makefile
	$(FC) $(OPT) test_map.f90 -o test_map_f $(LIB) $(INCLUDE)

test_map_f2: $(LIB) test_map2.f90 Makefile 
	$(FC) $(OPT) test_map2.f90 -o test_map_f2 $(LIB) $(INCLUDE)

test_map_f3: $(LIB) test_map3.f90 Makefile
	$(FC) $(OPT) test_map3.f90 -o test_map_f3 $(INCLUDE)

test_list: $(LIB) test_list.c Makefile
	$(CC) $(OPT) test_list.c -o test_list $(LIB) $(INCLUDE)

test_proximity_map: $(LIB) test_proximity_map.c Makefile
	$(CC) $(OPT) test_proximity_map.c -o test_proximity_map $(LIB) $(INCLUDE)

test_proximity_map_f: $(LIB) test_proximity_map.f90 Makefile
	$(FC) $(OPT) test_proximity_map.f90 -o test_proximity_map_f $(LIB) $(INCLUDE)

clean: 
	rm -f *.o *~ $(TARGETS)
