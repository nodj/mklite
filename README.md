mklite
======

Minimalist build system for personnal C/C++ projects

the goal is to write painful make rules only once.
The two .mk files contains everything needed to build a simple project.
Currently, this only works on Windows platforms, and actualy on W7 only...

All you have to do
Create a folder which will contain these makefile and your 'repository',
Create a STUDIO envvar which points to the brand new folder, (I'll call it the 'STUDIO' folder.)
git clone this project in that STUDIO folder.
All is ready.

Now, for every project you want to build with mklite:
Create an empty makefile,
From this makefile, include the two mklite .mk files.
Ex:
    include $(STUDIO)/mklite/globalVar.mk
    include $(STUDIO)/mklite/genericRules.mk

This super basic settings allows you to build a project with a standard predefined file tree
	


Work to do
Edit current .mk's to detect the underlying system and adapt macros for unix like systems