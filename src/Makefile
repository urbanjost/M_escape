#@(#) make(1) rules for maintaining a FORTRAN90/C library. Makefile started by makeout(1) 2020-01-14 01:11:41
NULL=
PROGFILES = $(wildcard ../app/*.f90) $(wildcard ../example/*.f90) $(wildcard ../test/*.f90)
PROG = ${PROGFILES:.f90=}
SRCS = $(wildcard ./*.f90) $(wildcard ./*.c ) $(wildcard ./*.h )
LIBS := -Llib -lM_escape 

# create a list of corresponding object files
COBJS_FILES = $(wildcard ./*.c )
FOBJS_FILES = $(wildcard ./*.f90 )
OBJS = $(patsubst %.c,%.o,$(COBJS_FILES)) $(patsubst %.f90,%.o,$(FOBJS_FILES))
LIBOBJS = $(patsubst %.f90,$(LIBRARY)(%.o),$(SRCS)) $(patsubst %.c,$(LIBRARY)(%.o),$(SRCS))

INSTALL=./lib

# platform-specific values you will probably change
# 
CC := cc
CFLAGS := -O
FC := gfortran
FFLAGS := -O -J $(INSTALL)
LDFLAGS := -I $(INSTALL)
AR=ar
ARFLAGS=rU
RANLIB=ranlib

gfortran: F90=gfortran
gfortran: FFLAGS := -g -O -Wall -std=f2018 -Wextra -Wno-maybe-uninitialized -Wno-uninitialized
gfortran: all
	@echo built with $(F90)

nvfortran: F90=nvfortran
nvfortran: FFLAGS := -Minform=inform -Mbackslash -traceback
nvfortran: all
	@echo built with $(F90)

ifort: F90=ifort
ifort: FFLAGS := -warn all -traceback
ifort: all
	@echo built with $(F90)

nagfor: F90=nagfor
nagfor: FFLAGS := -C all
nagfor: all
	@echo built with $(F90)

# name of library to build of the form lib$NAME.a
LIBNAME=M_escape
# directory to place output files in
LIBRARY=$(INSTALL)/lib$(LIBNAME).a
# set the '.RECIPEPREFIX' variable to an alternate character
.RECIPEPREFIX = >

#-------------------------------------------------------------------------------
# list what to run and then do any teardown. Do not leave this empty
all: directorysetup $(LIBRARY) $(CPROG) $(PROG)
>   @echo "That's all Folks!"
#-------------------------------------------------------------------------------
# what to do before you start compiling
directorysetup:
>   @ echo "MAKING LIBRARY:   $(LIBRARY)" 
>   @ [ -d "$(INSTALL)" ] || \
>     (echo "making directory $(INSTALL)"; \
>     mkdir -p $(INSTALL))
#-------------------------------------------------------------------------------
# what to do after you have built the library
$(LIBRARY): $(LIBOBJS)
>   @ $(RANLIB) $(LIBRARY)
>   @ echo "TARGETS FOR $(LIBRARY) UP TO DATE"
#-------------------------------------------------------------------------------
$(PROG): $(LIBRARY)
>   -$(FC) $(LDFLAGS) $@.f90 -o $@ $(LIBS)||echo "ouch: $@.f90 "
#-------------------------------------------------------------------------------
.phony: clean
clean:
>   -rm -f $(PROG) $(CPROG) $(OBJS) *.mod *.o
>   -rm -f $(LIBRARY) $(INSTALL)/*.mod
#-------------------------------------------------------------------------------
$(OBJS): draw.h
#-------------------------------------------------------------------------------
.SUFFIXES: $(SUFFIXES) .f90 .F90 .c
.f90.a:
>   echo "LIBRARY is $(LIBRARY)"
>   $(FC) -c $(FFLAGS) $< -o $%
>   @ $(AR) $(ARFLAGS) $(LIBRARY) $% 
>   @ $(AR) $(ARFLAGS) $(LIBRARY) $<  # optionally store the source code too
>   @ /bin/rm -f ${?F:.f90=.o} $%
.c.a:
>   $(CC) -c $(CFLAGS) $< -o $%
>   @ $(AR) $(ARFLAGS) $(LIBRARY) $% 
>   @ $(AR) $(ARFLAGS) $(LIBRARY) $<  # optionally store the source code too
>   @ /bin/rm -f ${?F:.c=.o} $%
#-------------------------------------------------------------------------------
.PHONY: help
help:
>: all     '-- build M_escape module'
>: run     '-- run manpage demo programs'
>: man     '-- show all manpages as text'
>: clean   '-- clean directory of object files and executables'
>: doxygen '-- run doxygen(1) if you have it'
>: help    '-- display this text'
>
#-------------------------------------------------------------------------------
.PHONY: run
run: $(PROG)
># run everything
>echo $? |xargs -n 1|xargs -iXX time XX
#-------------------------------------------------------------------------------
.PHONY: doxygen
doxygen: 
>doxygen dox.in
#-------------------------------------------------------------------------------
.PHONY: man
man:
>@mandb ../man 1>&2
>: INDEX OF MANPAGES TOPICS
>@env MANPATH=../man MANWIDTH=256 man -k .|col -b
>: MANPAGES
>@env MANPATH=../man MANWIDTH=80  man --regex '.*'|col -b
>: SPELLING
>@env MANPATH=../man MANWIDTH=80  man --regex '.*'|col -b|spell|xargs -n 5|column -t
#=================================================================================
M_escape.o: M_list2.o 
#=================================================================================
