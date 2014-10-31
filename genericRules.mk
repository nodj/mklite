#############################
# COMPILATION RULES FOR C++ #
#############################

$(obj)/%.o: $(src)/%$(srcExt) $(dep)/%.d
	$(call MKD,$(@D))
	$(CC) $(IFOLDERS) $(CFLAGS) -c $< -o $@
	
$(obj)/$(binFile): $(OBJECTS)
	@echo info: building $@
	$(CC) $(LFLAGS) $(LIBFOLDERS) $(OBJECTS) -o $@ $(LIBNAMES)
	@echo info: building $@ over
	

##########################
# DEPENDENCY COMPUTATION #
##########################
#This part aims to build dependency files from gcc built-in dep detection feature.
# The $(noDepInclude) var describe the make targets that should not generate dependency update (which could be quite long)

ifeq (0, $(words $(findstring $(MAKECMDGOALS), $(noDepInclude))))
sinclude $(DEPENDENCIES)
endif

genDep: $(DEPENDENCIES)
	@echo info: dependancies $(DEPENDENCIES)
	@echo info: dependancies generated

$(dep)/%.d : $(src)/%$(srcExt)
	@echo info: generation des dependances CPP pour $<
	$(call MKD,$(@D))
	$(CC) $(IFOLDERS) -MM -MF"$@" -MT"$@" $<


############################
# EXTERNAL DEPENDENCY MGMT #
############################

extInstall::extUninstall
	$(call MKD,$(ext))
	
extUninstall::
	$(call RMD,$(ext))


############################
# STANDARD PACKAGING RULES #
############################

ifdef sharedLib
pack:: $(obj)/$(binFile)
	@echo info: remove old pack
	$(call RMD,$(localRepoFolder))
	@echo info: packing...
	$(call MKD,$(binPackFolder))
	$(call MKD,$(libPackFolder))
	$(call MKD,$(includePackFolder))
	$(call CP,$(obj)/$(binFile),$(binPackFolder)/$(binFile))
	$(call CP,$(obj)/$(implibFile),$(libPackFolder)/$(implibFile))
	$(call CPD,$(inc),$(includePackFolder))
	@echo info: packing done in $(localRepoFolder)
else
pack:: $(obj)/$(binFile)
	@echo info: remove old pack and create new one
	$(call RMD,$(localRepoFolder))
	$(call MKD,$(localRepoFolder))
	@echo info: packing...
	$(call CP,$(obj)/$(binFile),$(localRepoFolder)/$(binFile))
	@echo info: packing done in $(localRepoFolder)
	
endif

packExport::pack
	@echo info: export...
	$(call RMD,$(repoFolder)/$(productName))
	$(call MKD,$(repoFolder))
	$(call CPD,$(localRepoFolder),$(repoFolder)/$(productName))
	@echo info: export done in $(repoFolder)


################
# tool targets #
################

#folders auto creation
./%:
	@echo info: creation du dossier $*
	$(call MKD,$*)

# many information about project, compilation, build...
info:
	@echo info:   ENVIRONNEMENT
	@echo working directory : %cd%
	@echo architecture      : $(arch)
	@echo info:   PROJECT
	@echo project name      : $(name)
	@echo project version   : $(version)
	@echo product name      : $(productName)
	@echo info:   COMPILER
	@echo used compiler     : $(C)
	@echo compiler path     : $(CPATH)
	@echo compiler version  : $(CVERS)
	@echo language standard : $(CSTANDARD)
	@echo info:   BUILD
	@echo tmp build folder  : $(localBuildFolder)
	@echo tmp local repo    : $(localRepoFolder)
	@echo packed repository : $(repoFolder)
	@echo info:   SOURCES 
	@echo external folder   : $(ext)
	@echo translation units : {$(TRANSLATUNIT)}
	@echo -I folders        : {$(IFOLDERS)}
	@echo -L folders        : {$(LIBFOLDERS)}
	@echo -l libraries      : {$(LIBNAMES)}
#	@echo info: source files:
#	@echo {$(CPP_FILES)}
#	@echo info: Object files:
#	@echo {$(OBJECTS)}
#	@echo info: Dependency files:
#	@echo {$(DEPENDENCIES)}

genObj: $(OBJECTS)
	@echo info: all objects created


#################
# CLEAN METHODS #
#################
cleanAll:
	$(call RMD,$(localBuildRoot))
	$(call RMD,$(localRepoRoot))
	@echo info: cleared
	
cleanBuildTemp:
	$(call RMD,$(obj))
	$(call RMD,$(dep))
	@echo info: obj cleared
	
cleandep:
	$(call RMD,$(dep))
	@echo info: dep cleared
	