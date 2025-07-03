first: all

### File operations
COPY          = cp -f
COPY_FILE     = $(COPY)
COPY_DIR      = $(COPY) -r
INSTALL_FILE  = install -m 644 -p
INSTALL_DIR   = $(COPY_DIR)
INSTALL_PROGRAM = install -m 755 -p
DEL_FILE      = rm -f
SYMLINK       = ln -sf
DEL_DIR       = rmdir
MOVE          = mv -f
CHK_DIR_EXISTS= test -d
MKDIR         = mkdir -p

### Executable File Name
TARGET        = trajSearch_omp

####### Compiler, tools and options
#HDF5_BASE    = /home/itv/lib/hdf5/1.8.8_intel12/
#HDF5_BASE    = /home/itv/lib/hdf5/1.8.6_serial_intel/
#HDF5_BASE   = /usr/local/hdf5
HDF5_BASE   = /usr/local/software/jureca/Stages/2017a/software/HDF5/1.8.18-iccifort-2017.2.174-GCC-5.4.0-serial
#HDF5_BASE   = /usr/local/hdf5/parallel/default
HDF5_INCDIR = -I$(HDF5_BASE)/include
HDF5_LIBS   = -L$(HDF5_BASE)/lib \
              -lhdf5hl_fortran -lhdf5_hl -lhdf5 \
              -lhdf5_fortran -lhdf5 \
              -lz -lsz

LIBS    = -L. \
          $(HDF5_LIBS) \
          -L./libmap \
          -lm

INCS    = -I. \
          $(HDF5_INCDIR) \
          -I./libmap \
          -I./psmb

### COMPILER-STUFF (Intel)
FC      = ifort -fpp
AR      = xiar
ARFLAGS = -rcusv
LFLAGS  = -Wl, -Bstatic, -static-intel
#FFLAGS = -O0 -g -static -heap-arrays -openmp -check all -traceback -no-inline-factor -save-temps
#FFLAGS = -O3   -static -heap-arrays -openmp -ip -xsse4.1 -vec-report1
#FFLAGS = -O3   -static -heap-arrays -openmp -ipo -xhost -vec-report1
#FFLAGS = -fast -static -heap-arrays -openmp -ipo -xhost -vec-report1
#FFLAGS = -fast -static -heap-arrays -openmp -ipo -xhost
FFLAGS = -fast -static -heap-arrays -openmp -ip -axSSE4.2,SSE4.1,SSE3,SSE2
#FFLAGS = -fast -static -heap-arrays -openmp -ip
#FFLAGS = -g -check all -traceback -static -heap-arrays -openmp -save-temps

CC     = icc
#CFLAGS = -g    -static -heap-arrays -openmp -check-uninit -traceback -no-inline-factor -save-temps
#CFLAGS = -O3   -static -heap-arrays -openmp -ip -xsse4.1 -vec-report1
#CFLAGS = -O3   -static -heap-arrays -openmp -ipo -xhost -vec-report1
#CFLAGS = -fast -static -heap-arrays -openmp -ipo -xhost   -vec-report1
#CFLAGS = -fast -static -heap-arrays -openmp -ipo -xhost
CFLAGS = -fast -static -heap-arrays -openmp -ip -axSSE4.2,SSE4.1,SSE3,SSE2
#CFLAGS = -fast -static -heap-arrays -openmp -ip
#CFLAGS = -g -check all -traceback -static -heap-arrays -openmp -save-temps

### COMPILER-STUFF (AIX - Power6)
#FC      = xlf_r 
#AR      = ar
#ARFLAGS = -X 64 -q 
#LFLAGS  = -q64
#FFLAGS  = -O3 -q64 -qarch=pwr6 -qstrict -qsmp -qfree=f90 -qsuffix=f=f90:cpp=f90

### PREPROCESSOR-FLAGS
##  _TRAJCOUNT_ (default=0)
##                     => 0: no calc/save of trajcount
##                     => 1: calc/save trajcount using a global array (slow, but easy coding => only for debugging!)
##                     => 2: buffer/sync trajcounts for 8 divided, individually locked regions
##                     => 3: calc/save trajcount, each thread sync with global array after 1000 completed trajectories
##
## _CUBIC_CELLS_       => expects a grid with cubic cells and a Lx x Ly x Lz domain (faster)
##                        !!! MUST BE SET IN libmap/MAKEFILE, TOO !!
## _NUMBERFIND_ (default=3)
##                     => 0: no call of numberfind() in walkTraj()
##                     => 1: call slow critical numberfind() (but less memory)
##                     => 2: call fast critical numberfind() (but more memory)
##                     => 3: call threadprivate numberfind() with sync after parallel section
##                     => 4: like (3), but using libmap to speed up list-search (only supports _CUBIC_CELLS_)
## _CALCPAIRING_ (default=2)
##                     => 1: call slow serial calcPairing()
##                     => 2: call fast serial calcPairing()
##                     => 3: call slow parallel calcPairing()
##                     => 4: call fast parallel calcPairing() ??? (not implemented yet)
## _RANDOM_ (default=2)
##                     => 1: call intrinsic function random_number() (sync with all threads -> slow, but highly random)
##                     => 2: call self-defined simple thread_random() (no sync between threads -> fast, but less random)
## _PAGE_SIZED_MEMORY_BLOCKS_ (default=0)
##                     => 0: Off
##                     => 1: create 8x8x8 Data-Cubes (4kByte Blocks)
##                     => 2: as 1, but also use posix_memalign for perfect memorypage fit
## _SCHEDULE_ (default=1)
##                     => 0: static
##                     => 1: dynamic
##                     => 2: adaptive (_NUMA_TPN_ must be set!)
## _NUMA_TPN_ (default=8) 
##                       number of nodes located near to each other (fast memory access)
##                     => 8: setting for ScaleMP Aachen
##                     => 2 or 8: setting for HLRB-II Munich
##                      !!! MUST BE SET if _SCHEDULE_==2 !!!
##                      !!! MUST HAVE: export KMP_AFFINITY=compact !!!
###

## !!! _CUBIC_CELLS MUST BE SET IN libmap/MAKEFILE, TOO !!
PPFLAGS =             -D_TRAJCOUNT_=0 \
                      -D_NUMBERFIND_=3 \
                      -D_CALCPAIRING_=2 \
                      -D_RANDOM_=2 \
                      -D_PAGE_SIZED_MEMORY_BLOCKS_=0 \
                      -D_SCHEDULE_=1 \
                      -D_CUBIC_CELLS_
#                      -D_NUMA_TPN_=6

####### 
OBJECTS_DIR   = .obj
OBJECT_FILES_LIB = \
		$(OBJECTS_DIR)/psmb/mod_psmb.o \
		$(OBJECTS_DIR)/mod_schedl.o \
		$(OBJECTS_DIR)/mod_data.o \
		$(OBJECTS_DIR)/mod_dele.o \
		$(OBJECTS_DIR)/mod_postp.o \
		$(OBJECTS_DIR)/mod_traj.o


OBJECT_FILES_HDF5 = \
		$(OBJECTS_DIR)/mod_io.o \
		$(OBJECTS_DIR)/mod_extras.o

## hilbert-caching
#		$(OBJECTS_DIR)/hilbert.o
#		$(OBJECTS_DIR)/mod_hilbert.o

mkobj:
	@$(CHK_DIR_EXISTS) $(OBJECTS_DIR)/ || $(MKDIR) $(OBJECTS_DIR)/
	@$(CHK_DIR_EXISTS) $(OBJECTS_DIR)/psmb/ || $(MKDIR) $(OBJECTS_DIR)/psmb/

####### Compile Rules

$(TARGET): Makefile libmap psmb lib$(TARGET) $(OBJECT_FILES_HDF5) trajSearch.f90
	@$(CHK_DIR_EXISTS) $(OBJECTS_DIR)/ || $(MKDIR) $(OBJECTS_DIR)/ 
	$(FC) $(FFLAGS) $(LFLAGS) $(PPFLAGS) $(INCS) -o $(TARGET) trajSearch.f90 $(OBJECT_FILES_HDF5) -l$(TARGET) $(LIBS) -lmap

libmap: Makefile
	-bash -c 'cd libmap && make && exit'

lib$(TARGET): $(OBJECT_FILES_LIB) Makefile
	$(AR) $(ARFLAGS) lib$(TARGET).a $(OBJECT_FILES_LIB)
	ranlib lib$(TARGET).a

$(OBJECTS_DIR)/%.o: %.f90 Makefile
	@$(CHK_DIR_EXISTS) $(OBJECTS_DIR)/ || $(MKDIR) $(OBJECTS_DIR)/
	@$(CHK_DIR_EXISTS) $(OBJECTS_DIR)/psmb/ || $(MKDIR) $(OBJECTS_DIR)/psmb/
	$(FC) $(FFLAGS) $(PPFLAGS) $(INCS) -c $< -o $@

$(OBJECTS_DIR)/%.o: %.c Makefile
	@$(CHK_DIR_EXISTS) $(OBJECTS_DIR)/ || $(MKDIR) $(OBJECTS_DIR)/
	$(CC) $(CFLAGS) $(PPFLAGS) $(INCS) -c $< -o $@

all: mkobj $(TARGET)
	-$(COPY_FILE) $(TARGET) ../run/

lib: lib$(TARGET)

clean:
	-$(DEL_FILE) -r $(OBJECTS_DIR)
	-$(DEL_FILE) *~ core *.core *.mod *.o *.a *.i90
	-bash -c 'cd libmap && make clean && exit'

distclean: clean 
	-$(DEL_FILE) $(TARGET)
	-$(DEL_FILE) $(TARGET_BASE)_*
	-bash -c 'cd libmap && make distclean && exit'

####### Install

install_scripts: first FORCE
	@$(CHK_DIR_EXISTS) $(INSTALL_DIR) || $(MKDIR) $(INSTALL_DIR)
	-$(INSTALL_FILE) $(TARGET) $(INSTALL_ROOT)

uninstall_scripts:  FORCE
	-$(DEL_FILE) -r $(INSTALL_DIR)/$(TARGET)
	-$(DEL_DIR) $(INSTALL_DIR)

install:  install_scripts  FORCE

uninstall: uninstall_scripts   FORCE

.PHONY: all clean libmap

FORCE:

