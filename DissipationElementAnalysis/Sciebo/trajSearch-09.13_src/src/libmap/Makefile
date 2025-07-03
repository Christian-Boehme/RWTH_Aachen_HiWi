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

### Output-library File Name
TARGET        = libmap

####### Compiler, tools and options
LIBS    = -L. \
          -lm

INCS    = -I. \
          -Imap

### COMPILER-STUFF (Intel)
FC      = ifort -fpp
AR      = xiar
ARFLAGS = -rcusv
LFLAGS  = -Wl, -Bstatic, -static-intel
#FFLAGS = -g -openmp -static -heap-arrays -check all -traceback -no-inline-factor -save-temps
#FFLAGS = -O3 -openmp -static -heap-arrays -no-inline-factor
#FFLAGS = -openmp -O3   -static -heap-arrays -ip -xsse4.1 -vec-report1
#FFLAGS = -openmp -fast -static -heap-arrays -ipo -xhost -vec-report1
FFLAGS = -fast -static -heap-arrays -openmp -ip -axSSE4.2,SSE4.1,SSE3,SSE2
#FFLAGS = -openmp -O3   -static -heap-arrays -ip -xhost -vec-report1

CC     = icc
#CFLAGS = -g -openmp -static -heap-arrays -check-uninit -traceback -no-inline-factor -save-temps
#CFLAGS = -O3 -openmp -static -heap-arrays -no-inline-factor
#CFLAGS = -openmp -O3   -static -heap-arrays -ip -xsse4.1 -vec-report1
#CFLAGS = -openmp -fast -static -heap-arrays -ipo -xhost -vec-report1
CFLAGS = -fast -static -heap-arrays -openmp -ip -axSSE4.2,SSE4.1,SSE3,SSE2
#CFLAGS = -openmp -O3   -static -heap-arrays -ip -xhost -vec-report1

### COMPILER-STUFF (AIX - Power6)
#FC      = xlf_r 
#AR      = ar
#ARFLAGS = -X 64 -q 
#LFLAGS  = -q64
#FFLAGS  = -O3 -q64 -qarch=pwr6 -qstrict -qsmp -qfree=f90 -qsuffix=f=f90:cpp=f90

### PREPROCESSOR-FLAGS
##  _NDEBUG_        => 1: no debug/assertion
##                                      0: use debug/assertion
##  _CUBIC_CELLS_     => only with equal sized cells
##  _MALLOC_VARIANT => 0: use standard malloc
##                     1: use kmp_malloc (intel compiler only, needs openmp)
##                     2: use test implementation of lockless malloc
##                            (don't use in production code)
###
PPFLAGS = -DNDEBUG=1 \
          -DMALLOC_VARIANT=1 \
          -D_CUBIC_CELLS_

####### 
OBJECTS_DIR   = .obj
OBJECT_FILES_LIB = \
		$(OBJECTS_DIR)/map.o \
		$(OBJECTS_DIR)/key.o \
		$(OBJECTS_DIR)/map2d.o \
		$(OBJECTS_DIR)/map2df.o \
		$(OBJECTS_DIR)/map3d.o \
		$(OBJECTS_DIR)/map3df.o \
		$(OBJECTS_DIR)/mod_map2d.o \
		$(OBJECTS_DIR)/mod_map3d.o \
		$(OBJECTS_DIR)/mod_pmap.o \
		$(OBJECTS_DIR)/list.o \
		$(OBJECTS_DIR)/proximity_map.o \
		$(OBJECTS_DIR)/pmapf.o \
		$(OBJECTS_DIR)/memory.o

####### Compile Rules

all: $(TARGET) $(OBJECT_FILES_F90)

$(TARGET): $(OBJECT_FILES_LIB) Makefile
	$(AR) $(ARFLAGS) $(TARGET).a $(OBJECT_FILES_LIB)
	ranlib $(TARGET).a

$(OBJECTS_DIR)/%.o: %.f90 Makefile
	@$(CHK_DIR_EXISTS) $(OBJECTS_DIR)/ || $(MKDIR) $(OBJECTS_DIR)/
	$(FC) $(FFLAGS) $(PPFLAGS) $(INCS) -c $< -o $@

$(OBJECTS_DIR)/%.o: %.c Makefile
	@$(CHK_DIR_EXISTS) $(OBJECTS_DIR)/ || $(MKDIR) $(OBJECTS_DIR)/
	$(CC) $(CFLAGS) $(PPFLAGS) $(INCS) -c $< -o $@

$(OBJECTS_DIR)/map.o: map/map.c Makefile
	@$(CHK_DIR_EXISTS) $(OBJECTS_DIR)/ || $(MKDIR) $(OBJECTS_DIR)/
	$(CC) $(CFLAGS) $(PPFLAGS) $(INCS) -c map/map.c -o $(OBJECTS_DIR)/map.o

clean:
	-$(DEL_FILE) $(OBJECTS_DIR)/*
	-$(DEL_FILE) *~ core *.core *.mod *.o *.a *.i90

distclean: clean 
	-$(DEL_FILE) $(TARGET).*
	-$(DEL_FILE) $(TARGET_BASE)_*

####### Install

install_scripts: first FORCE
	@$(CHK_DIR_EXISTS) $(INSTALL_DIR) || $(MKDIR) $(INSTALL_DIR)
	-$(INSTALL_FILE) $(TARGET) $(INSTALL_ROOT)

uninstall_scripts:  FORCE
	-$(DEL_FILE) -r $(INSTALL_DIR)/$(TARGET)
	-$(DEL_DIR) $(INSTALL_DIR)

install:  install_scripts  FORCE

uninstall: uninstall_scripts   FORCE

FORCE:
