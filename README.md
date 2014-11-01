mklite
======

# Minimalist build system for personnal C/C++ projects #

## mklite ? ##

I don't realy enjoy the makefile system, especialy when several projects require a different one, yet often very similar. Mklite provides a super simple way to avoid that, while keeping all the liberty gnu make offers.
About mklite:
- fully editable default project configuration,
- support for executable (.exe),
- support for shared libraries (.dll + .dll.a),
- robust incremental build (a TU or .cpp file is recompiled iff necessary),
- temporary files of one version/architecture of the project does not conflict with other temp files,
- clean managment of temp files, keep everything pretty!
- local repository shared amongst projects in order to keep things organized and clean,
- standard packaging and export rules to populate that repository,
- standard product name in the repo (Maven-like product names) for easy access,
- mklite is free!

## How it works ? ##

Mklite is composed of two makefiles which define classic variables with default values, plus generic build rules based on these variables. Several useful targets are exported, ready to use.
Currently, this only works on Windows platforms (some macros are platform specific and portage is not done yet), and actually tested on W7 only. Feel free to test mklite on other platforms, adapt the macros, etc.

## How to use it ? ##
mklite repository functionnality require a location. Furthermore, it is handy to keep mklite files in a centralized location. mklite internaly uses the `STUDIO` environement variable and create the repository there. Your configuration job consist in creating a folder where mklite will create the repo, and set the STUDIO env var on this folder. You may also put mklite in this studio folder for an easy access from anywhere (you may git clone this project in that STUDIO folder). Well done, configuration is over !

### hello world ###
Now, for each project you want to build with mklite, create a blank makefile in which you simply `include` the two mklite .mk files

```
include $(STUDIO)/mklite/globalVar.mk
include $(STUDIO)/mklite/genericRules.mk
```
With this first makefile, you should are able to build a project with default parameters. This means that the project name is `noname`, the version number is `0.0.0`, and it is not a shared lib. The folder recursively searched for source is `src`, folder 'include' is added to -I, the compiler is g++, standard used is `-std=c++11`, and the source files must end in `.cpp` to be compiled. if you launch make packExport, the $(STUDIO)/repo/ folder will be created and the project product will be packaged there. By the way, in this configuration, you can find the packaged product there: `$(STUDIO)/repo/noname-0.0.0-[x64|x86]`
Note that the build folder is named `.build`, you may not see it because of the dot.

### A more realistic project exemple ###
Your project is a C library
```
sharedLib=1
include $(STUDIO)/mklite/globalVar.mk
name    =MyLib
version =2.0.1
C       =gcc
ext     =.c

include $(STUDIO)/mklite/genericRules.mk
```


### Work to do ###
Edit current .mk's to detect the underlying system and adapt macros for unix like systems,
