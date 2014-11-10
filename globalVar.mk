#################
# WINDOWS MACRO #
#################
# Macros for windows. A scripted or C version of this should be dev as a make toolkit...
# TODO 'ifdef unix' and implement counterpart
CP  		=@copy "$(subst /,\,$(1))" "$(subst /,\,$(2))"
CPD  		=@xcopy "$(subst /,\,$(1))" "$(subst /,\,$(2))" /Y /E /I
MKD 		=@if NOT exist $(subst /,\,$(1)) mkdir $(subst /,\,$(1))
RMD 		=@if exist $(1) FOR /D %%p IN ($(1)) DO rmdir "%%p" /s /q
MKJ 		=if exist $(subst /,\,$(1)) mklink /J $(subst /,\,$(2)) $(subst /,\,$(1))
RMJ 		=@if exist $(subst /,\,$(1)) rmdir $(subst /,\,$(1))
RWX 		=$(wildcard $(1)/*$(2)) $(if $(wildcard $(1)/*/),$(call RWX,$(1)/*,$(2)),)


####################### 
# DEFAULT COMPILATION #
####################### 
C	  		=g++
CSTANDARD	=-std=c++11
CC  		=$(C) $(CSTANDARD)

# default WARNING flags
WFLAGS		=-W -Wall -Wextra

# default LINKAGE flags
LFLAGS		=
ifdef sharedLib
LFLAGS		=-shared -Wl,--out-implib,$(obj)/$(implibFile)
endif

# default COMPILATION flags
CFLAGS		=$(WFLAGS) -Og -ggdb -DDEBUG=true
ifdef release
CFLAGS		=$(WFLAGS) -O3 -s -DNDEBUG=true
endif


##########################
# ARCHITECTURE DETECTION #
##########################
DUMPM 		:= $(shell $(C) -dumpmachine)
CVERS 		:= $(shell $(C) -dumpversion)
CPATH 		:= $(patsubst %\$(C).exe,%,$(shell where $(C)))
arch 		:=wtf
ifneq 		($(findstring i686, $(DUMPM)),)
arch 		:=x86
else 		ifneq ($(findstring x86_64, $(DUMPM)),)
arch 		:=x64
endif


########################
# REPO PROJECT PACKING #
########################
# a library has a repo folder in name-version-arch
productName			=$(name)-$(version)-$(arch)$(tag)
localRepoRoot 		=repo
localBuildRoot 		=.build
localBuildFolder	=$(localBuildRoot)/$(productName)
localRepoFolder		=$(localRepoRoot)/$(productName)
binPackFolder 		=$(localRepoFolder)/bin
libPackFolder		=$(localRepoFolder)/lib
includePackFolder	=$(localRepoFolder)/include
repoFolder			=$(STUDIO)/repo


#######################
# project description #
#######################
name    	=no-name
version		=0.0.0

# root folder of compilable ressources
src			=src
srcExt		=.cpp
# external dependencies root (ntfs junction, link...)
ext			=ext
# folder to be copied when exported. not used at compil-time
inc			=include

# folder added to -I parameters
includesDir	=include

CPP_FILES	=$(call RWX ,$(src),$(srcExt))
TRANSLATUNIT=$(patsubst $(src)/%$(srcExt),%,$(CPP_FILES))
OBJECTS 	=$(patsubst %,$(obj)/%.o,$(TRANSLATUNIT))
DEPENDENCIES=$(patsubst %,$(dep)/%.d,$(TRANSLATUNIT))

IFOLDERS	=$(addprefix -I,$(includesDir))
LIBFOLDERS	=$(addprefix -L,$(librariesDir))
LIBNAMES	=$(addprefix -l,$(libraries))


##############################
# DEFAULT TEMP FILE LOCATION #
##############################
# dependency *.d files will be here
dep			=$(localBuildFolder)/.dep
# native object *.o files will be here
obj			=$(localBuildFolder)/.obj


###########################
# DEFAULT PROJECT PRODUCT #
###########################
dllFile		=$(name).dll
implibFile	=lib$(name).dll.a
exeFile		=$(name).exe
ifdef sharedLib
binFile		=$(dllFile)
else
binFile		=$(exeFile)
endif


#################
# MISCELLANEOUS #
#################
#Don't create dependencies when we're cleaning, for instance
noDepInclude=clean info cleandep cleanAll extInstall extUninstall
.PHONY: test cleanAll extInstall extUninstall pack

