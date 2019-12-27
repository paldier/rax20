# By default, let make spawn 1 job per core.
# To set max jobs, specify on command line, BRCM_MAX_JOBS=8
# To also specify a max load, BRCM_MAX_JOBS="6 --max-load=3.0"
# To specify max load without max jobs, BRCM_MAX_JOBS=" --max-load=3.5"

#debug purpose
#BRCM_MAX_JOBS=1

ifneq ($(strip $(BRCM_MAX_JOBS)),)
ACTUAL_MAX_JOBS := $(BRCM_MAX_JOBS)
else
NUM_CORES := $(shell grep processor /proc/cpuinfo | wc -l)
ACTUAL_MAX_JOBS := $(NUM_CORES)
endif

# Since tms driver is called with -j1 and will call its sub-make with -j, 
# We want it to use this value. Although the jobserver is disabled for tms,
# at least tms is compiled with no more than this variable value jobs.
export ACTUAL_MAX_JOBS

FXCN_CMS_SUPPORT := 1
FXCN_FW_FEATURES := 1
export FXCN_FW_FEATURES FXCN_CMS_SUPPORT

default:
ifeq ($(FXCN_FW_FEATURES),1) 
	#$(MAKE) -f build/Makefile pre_build_gpl
	#$(MAKE) -f build/Makefile pre_build_acos
	rm -rf RAX20/fs.install RAX20/modules ;
	rm -rf targets/RAX20/fs.install targets/RAX20/modules;	
	$(MAKE) -f build/Makefile acos_link
	@echo copy target folder....
	tar zxvf ori_rax20_prebuild.tar.gz -C RAX20/
	tar zxvf ori_rax20_prebuild.tar.gz  -C targets/RAX20/
	@echo end  .................		
endif #FXCN_FW_FEATURES
	$(MAKE) -f build/Makefile -j$(ACTUAL_MAX_JOBS) $(MAKEOVERRIDES) $(MAKECMDGOALS)
ifeq ($(FXCN_FW_FEATURES),1) 
	$(MAKE) -f build/Makefile -j$(ACTUAL_MAX_JOBS) pre_buildimage 
	$(MAKE) -f build/Makefile gpl 
#	$(MAKE) -f build/Makefile acos
	cp RAX20/fs.install/lib/libbcm_boardctl.so targets/RAX20/fs.install/lib/libbcm_boardctl.so
	cp RAX20/fs.install/lib/libbcm_flashutil.so targets/RAX20/fs.install/lib/libbcm_flashutil.so
	cp RAX20/fs.install/lib/libbcm_sslconf.so targets/RAX20/fs.install/lib/libbcm_sslconf.so
	cp RAX20/fs.install/lib/libbcm_util.so targets/RAX20/fs.install/lib/libbcm_util.so
	cp RAX20/fs.install/lib/libbcmmcast.so targets/RAX20/fs.install/lib/libbcmmcast.so
	cp RAX20/fs.install/lib/libblogctl.so targets/RAX20/fs.install/lib/libblogctl.so
	cp RAX20/fs.install/lib/libbridgeutil.so targets/RAX20/fs.install/lib/libbridgeutil.so
	cp RAX20/fs.install/lib/libcms_cli.so targets/RAX20/fs.install/lib/libcms_cli.so
	cp RAX20/fs.install/lib/libcms_core.so targets/RAX20/fs.install/lib/libcms_core.so	
	cp RAX20/fs.install/lib/libcms_dal.so targets/RAX20/fs.install/lib/libcms_dal.so
	cp RAX20/fs.install/lib/libcms_msg.so targets/RAX20/fs.install/lib/libcms_msg.so
	cp RAX20/fs.install/lib/libcms_qdm.so targets/RAX20/fs.install/lib/libcms_qdm.so
	cp RAX20/fs.install/lib/libcms_util.so targets/RAX20/fs.install/lib/libcms_util.so	
	cp RAX20/fs.install/lib/libcrypto.so targets/RAX20/fs.install/lib/libcrypto.so
	cp RAX20/fs.install/lib/libcrypto.so.1.1 targets/RAX20/fs.install/lib/libcrypto.so.1.1
	cp RAX20/fs.install/lib/libethctl.so targets/RAX20/fs.install/lib/libethctl.so	
	cp RAX20/fs.install/lib/libethswctl.so targets/RAX20/fs.install/lib/libethswctl.so	
	cp RAX20/fs.install/lib/libfcctl.so targets/RAX20/fs.install/lib/libfcctl.so	
	cp RAX20/fs.install/lib/libFLAC.so.8 targets/RAX20/fs.install/lib/libFLAC.so.8	
	cp RAX20/fs.install/lib/libgen_util.so targets/RAX20/fs.install/lib/libgen_util.so	
	cp RAX20/fs.install/lib/libhttpdshared.so targets/RAX20/fs.install/lib/libhttpdshared.so
	cp RAX20/fs.install/lib/libiqctl.so targets/RAX20/fs.install/lib/libiqctl.so
	cp RAX20/fs.install/lib/libjpeg.so.9 targets/RAX20/fs.install/lib/libjpeg.so.9
	cp RAX20/fs.install/lib/libkrb5-samba4.so.26 targets/RAX20/fs.install/lib/libkrb5-samba4.so.26
	cp RAX20/fs.install/lib/libldb.so.1 targets/RAX20/fs.install/lib/libldb.so.1
	cp RAX20/fs.install/lib/libmdm2.so targets/RAX20/fs.install/lib/libmdm2.so	
	cp RAX20/fs.install/lib/libnanoxml.so targets/RAX20/fs.install/lib/libnanoxml.so	
	cp RAX20/fs.install/lib/libpcap.so targets/RAX20/fs.install/lib/libpcap.so	
	cp RAX20/fs.install/lib/libpcap.so.1 targets/RAX20/fs.install/lib/libpcap.so.1
	cp RAX20/fs.install/lib/libpcap.so.1.8.1 targets/RAX20/fs.install/lib/libpcap.so.1.8.1
	cp RAX20/fs.install/lib/libpwrctl.so targets/RAX20/fs.install/lib/libpwrctl.so	
	cp RAX20/fs.install/lib/libsamba-util.so.0 targets/RAX20/fs.install/lib/libsamba-util.so.0
	cp RAX20/fs.install/lib/libsmbd-base-samba4.so targets/RAX20/fs.install/lib/libsmbd-base-samba4.so		
	cp RAX20/fs.install/lib/libsys_util.so targets/RAX20/fs.install/lib/libsys_util.so
	cp RAX20/fs.install/lib/libvlanctl.so targets/RAX20/fs.install/lib/libvlanctl.so	
	cp RAX20/fs.install/lib/libvorbis.so.0 targets/RAX20/fs.install/lib/libvorbis.so.0
	cp RAX20/fs.install/lib/libwlmdm.so targets/RAX20/fs.install/lib/libwlmdm.so
	cp RAX20/fs.install/lib/libwlsysutil.so targets/RAX20/fs.install/lib/libwlsysutil.so	
	cp RAX20/fs.install/lib/libxml2.so targets/RAX20/fs.install/lib/libxml2.so	
	cp RAX20/fs.install/lib/libxml2.so.2 targets/RAX20/fs.install/lib/libxml2.so.2
	cp RAX20/fs.install/lib/libxml2.so.2.9.0 targets/RAX20/fs.install/lib/libxml2.so.2.9.0
	cp RAX20/fs.install/lib/pptp.so targets/RAX20/fs.install/lib/pptp.so	
	cp RAX20/fs.install/lib/pptp.so.0 targets/RAX20/fs.install/lib/pptp.so.0
	cp RAX20/fs.install/lib/pptp.so.0.0.0 targets/RAX20/fs.install/lib/pptp.so.0.0.0			
	cp RAX20/fs.install/bin/smd targets/RAX20/fs.install/bin/smd
	cp RAX20/fs.install/bin/ssk targets/RAX20/fs.install/bin/ssk
	$(MAKE) -f build/Makefile -j$(ACTUAL_MAX_JOBS) just_buildimage 
#	$(MAKE) -f build/Makefile -j$(ACTUAL_MAX_JOBS) buildimage 
endif #FXCN_FW_FEATURES

$(MAKECMDGOALS):
	$(MAKE) -f build/Makefile -j$(ACTUAL_MAX_JOBS) $(MAKEOVERRIDES) $(MAKECMDGOALS)



.PHONY: $(MAKECMDGOALS)

