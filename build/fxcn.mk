# Foxconn added Makefile
ifndef PROFILE
#export PROFILE=MR60
export PROFILE=RAX20
#export PROFILE=MS60
endif



#other define
ifndef FW_TYPE
FW_TYPE = WW
endif
export FW_TYPE

ifeq ($(PROFILE),RAX20)
BOARDID_FILE=compatible_rax20.txt
FW_NAME=RAX20
CFLAGS += -DRAX20
FXCN_GUI=ROUTER_AX_GUI
WLANLIB_SUPPORT=y
endif

ifeq ($(PROFILE),MR60)
BOARDID_FILE=compatible_mr60.txt
FW_NAME=MR60
CFLAGS += -DMR60
FXCN_GUI=ORBI_GUI
WLANLIB_SUPPORT=y
LED_CUSTOMIZE=y
FXCN_USE_128MB_FLASH := 1
export FXCN_USE_128MB_FLASH
endif

ifeq ($(PROFILE),MS60)
BOARDID_FILE=compatible_ms60.txt
FW_NAME=MS60
CFLAGS += -DMS60
FXCN_USE_128MB_FLASH := 1
WLANLIB_SUPPORT=y
LED_CUSTOMIZE=y
#FXCN_NO_TREND_IQOS := 1
export FXCN_USE_128MB_FLASH
#export FXCN_NO_TREND_IQOS
endif

ifeq ($(PROFILE),EAX20)
BOARDID_FILE=compatible_eax20.txt
FW_NAME=EAX20
CFLAGS += -DEAX20
FXCN_GUI=REPEATER_GUI
WLANLIB_SUPPORT=y
FXCN_USE_128MB_FLASH := 1
WLAN_REPEATER := 1
export WLAN_REPEATER
export FXCN_USE_128MB_FLASH
endif

ifeq ($(PROFILE),RAX50)
BOARDID_FILE=compatible_rax50.txt
FW_NAME=RAX50
CFLAGS += -DRAX50
FXCN_GUI=ROUTER_AX_GUI
WLANLIB_SUPPORT=y
endif

#
# Paths
#

CPU ?=
LINUX_VERSION ?= 4_1_27
MAKE_ARGS ?=
ARCH = arm64
PLT ?= arm64

# Get ARCH from PLT argument
ifneq ($(findstring arm,$(PLT)),)
ARCH := arm64
endif

# uClibc wrapper
ifeq ($(CONFIG_UCLIBC),y)
PLATFORM := $(PLT)-uclibc
else ifeq ($(CONFIG_GLIBC),y)
PLATFORM := $(PLT)-glibc
else
PLATFORM := $(PLT)
endif

export FXCN_PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig:/usr/lib/i386-linux-gnu/pkgconfig
#export PATH := /opt/toolchains/crosstools-arm-gcc-5.3-linux-4.1-glibc-2.24-binutils-2.25/usr/bin:/opt/toolchains/crosstools-aarch64-gcc-5.3-linux-4.1-glibc-2.24-binutils-2.25/usr/bin::$(PATH)
export FXCN_PATH := /opt/toolchains/crosstools-arm-gcc-5.5-linux-4.1-glibc-2.26-binutils-2.28.1/usr/bin/:/opt/toolchains/crosstools-aarch64-gcc-5.5-linux-4.1-glibc-2.26-binutils-2.28.1/usr/bin/::$(PATH)

# Source bases
export PLATFORM LIBDIR USRLIBDIR LINUX_VERSION
export BCM_KVERSIONSTRING := $(subst _,.,$(LINUX_VERSION))

#WLAN_ComponentsInUse := bcmwifi clm ppr olpc
#include ../makefiles/WLAN_Common.mk
#export SRCBASE := $(WLAN_SrcBaseA)
#export BASEDIR := $(WLAN_TreeBaseA)
export TOP := $(shell pwd)
export SRCBASE := $(TOP)/bcmdrivers/broadcom/net/wl/impl61/main/src
export BASEDIR := $(TOP)
export BUILDDIR:= $(TOP)

ifeq (4_1_27,$(LINUX_VERSION))
export  LINUXDIR := $(TOP)/kernel/linux-4.1
export  KBUILD_VERBOSE := 1
export  BUILD_MFG := 0
else ifeq (2_6_36,$(LINUX_VERSION))
export  LINUXDIR := $(BASEDIR)/components/opensource/linux/linux-2.6.36
export  KBUILD_VERBOSE := 1
export  BUILD_MFG := 0
# for now, only suitable for 2.6.36 router platform
SUBMAKE_SETTINGS = SRCBASE=$(SRCBASE) BASEDIR=$(BASEDIR)
else ifeq (2_6,$(LINUX_VERSION))
export  LINUXDIR := $(SRCBASE)/linux/linux-2.6
export  KBUILD_VERBOSE := 1
export  BUILD_MFG := 0
SUBMAKE_SETTINGS  = SRCBASE=$(SRCBASE)
else
export  LINUXDIR := $(SRCBASE)/linux/linux
SUBMAKE_SETTINGS  = SRCBASE=$(SRCBASE)
endif


CFLAGS += -DREMOTE_SMB_CONF
CFLAGS += -DREMOTE_USER_CONF
CFLAGS += -DUSERSETUP_SUPPORT
CFLAGS += -DXAGENT_CLOUD_SUPPORT
ifeq ($(FW_TYPE),NA)
export CFLAGS += -DFW_VERSION_NA
endif

USERAPPS_DIR = $(BUILD_DIR)/userspace
export USERAPPS_DIR
ACOSTOPDIR=$(USERAPPS_DIR)/ap/acos
export ACOSTOPDIR
GPLTOPDIR=$(USERAPPS_DIR)/ap/gpl
export GPLTOPDIR

# Foxconn Add start 
acos_link:
ifneq ($(PROFILE),)
	cd $(USERAPPS_DIR)/project/acos/include; rm -f ambitCfg.h; ln -s ambitCfg_$(FW_TYPE)_$(PROFILE).h ambitCfg.h
	cd $(USERAPPS_DIR)/ap/acos/include; rm -f ambitCfg.h; ln -s $(USERAPPS_DIR)/project/acos/include/ambitCfg_$(FW_TYPE)_$(PROFILE).h ambitCfg.h
	cd $(USERAPPS_DIR)/ap/acos/include; rm -f projectConfig.h; ln -s $(USERAPPS_DIR)/project/acos/include/projectConfig_$(PROFILE).h projectConfig.h
	cd $(LINUXDIR)/include/net ; rm -f MultiSsidControl.h ; ln -s $(USERAPPS_DIR)/ap/acos/multissidcontrol/MultiSsidControl.h MultiSsidControl.h
	cd $(LINUXDIR)/include/net ; rm -f AccessControl.h ; ln -s $(USERAPPS_DIR)/ap/acos/access_control/AccessControl.h AccessControl.h
	# Don't build un-necessary modules
#	cd $(USERAPPS_DIR); rm -Rf gpl/apps/ppp/autodetect gpl/apps/accel-pptp/autodetect gpl/apps/atm2684/autodetect gpl/apps/ntfs-3g/autodetect gpl/apps/openl2tpd/autodetect gpl/apps/mmc-utils/autodetect gpl/apps/openvpn/autodetect gpl/apps/strongswan/autodetect; rm -Rf public/apps/dropbear/autodetect public/apps/radvd/autodetect public/apps/pppd/autodetect
ifeq ($(WLANLIB_SUPPORT),y)
	#rm $(USERAPPS_DIR)/ap/acos/wlanLib/rf_util.c; ln -s $(USERAPPS_DIR)/project/acos/wlanLib/rf_util_$(PROFILE).c $(USERAPPS_DIR)/ap/acos/wlanLib/rf_util.c
else
	#rm $(USERAPPS_DIR)/ap/acos/shared/rf_util.c; ln -s $(USERAPPS_DIR)/project/acos/shared/rf_util_$(PROFILE).c $(USERAPPS_DIR)/ap/acos/shared/rf_util.c
endif
	#rm -rf $(USERAPPS_DIR)/ap/acos/led_blinkd; ln -s $(USERAPPS_DIR)/project/acos/led_blinkd_$(PROFILE) $(USERAPPS_DIR)/ap/acos/led_blinkd
	#rm $(USERAPPS_DIR)/ap/acos/shared/lan_util.c; ln -s $(USERAPPS_DIR)/project/acos/shared/lan_util_$(PROFILE).c $(USERAPPS_DIR)/ap/acos/shared/lan_util.c
	#rm $(USERAPPS_DIR)/ap/acos/shared/led_util.c; ln -s $(USERAPPS_DIR)/project/acos/shared/led_util_$(PROFILE).c $(USERAPPS_DIR)/ap/acos/shared/led_util.c
	#rm $(USERAPPS_DIR)/ap/acos/shared/led_util.h; ln -s $(USERAPPS_DIR)/project/acos/shared/led_util_$(PROFILE).h $(USERAPPS_DIR)/ap/acos/shared/led_util.h
	#rm $(USERAPPS_DIR)/ap/acos/shared/i2c_util.c; ln -s $(USERAPPS_DIR)/project/acos/shared/i2c_util.c $(USERAPPS_DIR)/ap/acos/shared/i2c_util.c
	#rm $(USERAPPS_DIR)/ap/acos/shared/i2c_util.h; ln -s $(USERAPPS_DIR)/project/acos/shared/i2c_util.h $(USERAPPS_DIR)/ap/acos/shared/i2c_util.h
	#rm $(USERAPPS_DIR)/ap/acos/shared/thermal_util_PCT2075.c; ln -s $(USERAPPS_DIR)/project/acos/shared/thermal_util_PCT2075.c $(USERAPPS_DIR)/ap/acos/shared/thermal_util_PCT2075.c
	#rm $(USERAPPS_DIR)/ap/acos/shared/thermal_util_PCT2075.h; ln -s $(USERAPPS_DIR)/project/acos/shared/thermal_util_PCT2075.h $(USERAPPS_DIR)/ap/acos/shared/thermal_util_PCT2075.h
	#rm $(USERAPPS_DIR)/ap/acos/shared/thermal_util_m7533.c; ln -s $(USERAPPS_DIR)/project/acos/shared/thermal_util_m7533.c $(USERAPPS_DIR)/ap/acos/shared/thermal_util_m7533.c
	#rm $(USERAPPS_DIR)/ap/acos/shared/thermal_util_m7533.h; ln -s $(USERAPPS_DIR)/project/acos/shared/thermal_util_m7533.h $(USERAPPS_DIR)/ap/acos/shared/thermal_util_m7533.h
	#rm $(USERAPPS_DIR)/ap/acos/httpd/cgi/mnuCgi.c; ln -s $(USERAPPS_DIR)/project/acos/httpd/cgi/mnuCgi_$(PROFILE).c $(USERAPPS_DIR)/ap/acos/httpd/cgi/mnuCgi.c

ifeq ($(FXCN_GUI),ROUTER_AX_GUI)
	#rm $(USERAPPS_DIR)/ap/acos/www_router_ax/DashBoard.htm; ln -s $(USERAPPS_DIR)/project/acos/www_router_ax/DashBoard_$(PROFILE).htm $(USERAPPS_DIR)/ap/acos/www_router_ax/DashBoard.htm
	#rm $(USERAPPS_DIR)/ap/acos/www_router_ax/utility.js; ln -s $(USERAPPS_DIR)/project/acos/www_router_ax/utility_$(PROFILE).js $(USERAPPS_DIR)/ap/acos/www_router_ax/utility.js
	#rm $(USERAPPS_DIR)/ap/acos/www_router_ax/start.htm; ln -s $(USERAPPS_DIR)/project/acos/www_router_ax/start_$(PROFILE)_noDownloader.htm $(USERAPPS_DIR)/ap/acos/www_router_ax/start.htm
	#cp -f $(USERAPPS_DIR)/ap/acos/www_router_ax/UPNP_media_$(PROFILE).htm $(USERAPPS_DIR)/ap/acos/www_router_ax/UPNP_media.htm
else ifeq ($(FXCN_GUI),ORBI_GUI)
	#rm $(USERAPPS_DIR)/ap/acos/www_orbi/DashBoard.htm; ln -s $(USERAPPS_DIR)/project/acos/www_orbi/DashBoard_$(PROFILE).htm $(USERAPPS_DIR)/ap/acos/www_orbi/DashBoard.htm
	#rm $(USERAPPS_DIR)/ap/acos/www_orbi/utility.js; ln -s $(USERAPPS_DIR)/project/acos/www_orbi/utility_$(PROFILE).js $(USERAPPS_DIR)/ap/acos/www_orbi/utility.js
	#rm $(USERAPPS_DIR)/ap/acos/www_orbi/start.htm; ln -s $(USERAPPS_DIR)/project/acos/www_orbi/start_$(PROFILE)_noDownloader.htm $(USERAPPS_DIR)/ap/acos/www_orbi/start.htm
	#cp -f $(USERAPPS_DIR)/ap/acos/www_orbi/UPNP_media_$(PROFILE).htm $(USERAPPS_DIR)/ap/acos/www_orbi/UPNP_media.htm
else ifeq ($(FXCN_GUI),REPEATER_GUI)

else
	#cp -f $(USERAPPS_DIR)/ap/acos/www/UPNP_media_$(PROFILE).htm $(USERAPPS_DIR)/ap/acos/www/UPNP_media.htm
	#rm $(USERAPPS_DIR)/ap/acos/www/start.htm; ln -s $(USERAPPS_DIR)/project/acos/www/start_$(PROFILE)_noDownloader.htm $(USERAPPS_DIR)/ap/acos/www/start.htm
endif

ifeq ($(PROFILE),RAX20) 
	#rm $(USERAPPS_DIR)/ap/acos/www_router_ax/LED_settings.htm; ln -s $(USERAPPS_DIR)/project/acos/www_router_ax/LED_settings_RAX20.htm $(USERAPPS_DIR)/ap/acos/www_router_ax/LED_settings.htm
endif

#TODO for IQOS  
#	ln -fs ../../../src/include/bcmIqosDef.h $(BASEDIR)/ap/acos/include/bcmIqosDef.h
	#cp $(USERAPPS_DIR)/project/acos/config_$(PROFILE).in $(USERAPPS_DIR)/project/acos/config.in
	#cp $(USERAPPS_DIR)/project/acos/config_$(PROFILE).mk $(USERAPPS_DIR)/project/acos/config.mk
	#cp $(USERAPPS_DIR)/project/acos/Makefile_$(PROFILE) $(USERAPPS_DIR)/project/acos/Makefile
# Foxconn edit, Laider Lai
	#rm -fr $(USERAPPS_DIR)/ap/acos/www/string_table
	#cp -r $(USERAPPS_DIR)/project/acos/strings/$(PROFILE) $(USERAPPS_DIR)/ap/acos/www/string_table
# Foxconn
#	cp $(USERAPPS_DIR)/project/acos/usbprinter/NetUSB.ko $(USERAPPS_DIR)/ap/acos/usbprinter/NetUSB.ko
#	cp $(USERAPPS_DIR)/project/acos/usbprinter/GPL_NetUSB.ko $(USERAPPS_DIR)/ap/acos/usbprinter/GPL_NetUSB.ko
#	cp $(USERAPPS_DIR)/project/acos/usbprinter/KC_PRINT $(USERAPPS_DIR)/ap/acos/usbprinter/KC_PRINT
#	cp $(USERAPPS_DIR)/project/acos/usbprinter/KC_BONJOUR $(USERAPPS_DIR)/ap/acos/usbprinter/KC_BONJOUR
#	cp $(USERAPPS_DIR)/project/acos/ufsd/ufsd.ko $(USERAPPS_DIR)/ap/acos/ufsd/ufsd.ko
#	cp $(USERAPPS_DIR)/project/acos/ufsd/jnl.ko $(USERAPPS_DIR)/ap/acos/ufsd/jnl.ko
#	cp $(USERAPPS_DIR)/project/acos/ufsd/ufsd $(USERAPPS_DIR)/ap/acos/ufsd/ufsd
#	cp $(USERAPPS_DIR)/project/acos/Ookla/ookla $(USERAPPS_DIR)/ap/acos/Ookla/ookla
	#cp $(LINUXDIR)/.config_$(PROFILE) $(LINUXDIR)/.config
#	if [ -e $(USERAPPS_DIR)/project/acos/nvram/project_defaults_$(PROFILE).h ] ; then ln -sf $(USERAPPS_DIR)/project/acos/nvram/project_defaults_$(PROFILE).h $(USERAPPS_DIR)/ap/acos/nvram/project_defaults.h; fi
#ifeq ($(USERAPPS_DIR)/project/acos/nvram/project_defaults_$(PROFILE).h, $(wildcard $(wildcard $(USERAPPS_DIR)/project/acos/nvram/project_defaults_$(PROFILE).h)))
#	cp -f $(USERAPPS_DIR)/project/acos/nvram/project_defaults_$(PROFILE).h $(USERAPPS_DIR)/ap/acos/nvram/project_defaults.h
#endif
endif

ifeq ($(PROFILE),RAX20)
# Preload string_table - Spanish, Chinese, French, Germany, Italian, Dutch, Korea, Swedish, Russian, Portuguese, Japanese,
	#$(shell) $(USERAPPS_DIR)/project/acos/strings/gen_stringtable.sh $(USERAPPS_DIR)/project/acos/strings $(PROFILE)
	#cd $(TARGETS_DIR)/fs.src/etc; rm -f string_table*;
	#cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*Eng-Language-table $(TARGETS_DIR)/fs.src/etc/Eng_string_table;
	#cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*SP-Language-table $(TARGETS_DIR)/fs.src/etc/SP_string_table;
	#cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*PR-Language-table $(TARGETS_DIR)/fs.src/etc/PR_string_table;
	#cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*FR-Language-table $(TARGETS_DIR)/fs.src/etc/FR_string_table;
	#cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*GR-Language-table $(TARGETS_DIR)/fs.src/etc/GR_string_table;
	#cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*IT-Language-table $(TARGETS_DIR)/fs.src/etc/IT_string_table;
	#cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*NL-Language-table $(TARGETS_DIR)/fs.src/etc/NL_string_table;
	#cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*KO-Language-table $(TARGETS_DIR)/fs.src/etc/KO_string_table;
	#cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*SV-Language-table $(TARGETS_DIR)/fs.src/etc/SV_string_table;
	#cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*RU-Language-table $(TARGETS_DIR)/fs.src/etc/RU_string_table;
	#cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*PT-Language-table $(TARGETS_DIR)/fs.src/etc/PT_string_table;
	#cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*JP-Language-table $(TARGETS_DIR)/fs.src/etc/JP_string_table;
endif	
ifeq ($(PROFILE),MR60)
# Preload string_table - Spanish, Chinese, French, Germany, Italian, Dutch, Korea, Swedish, Russian, Portuguese, Japanese,
	$(shell) $(USERAPPS_DIR)/project/acos/strings/gen_stringtable.sh $(USERAPPS_DIR)/project/acos/strings $(PROFILE)
	cd $(TARGETS_DIR)/fs.src/etc; rm -f string_table*;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*Eng-Language-table $(TARGETS_DIR)/fs.src/etc/Eng_string_table;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*SP-Language-table $(TARGETS_DIR)/fs.src/etc/SP_string_table;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*PR-Language-table $(TARGETS_DIR)/fs.src/etc/PR_string_table;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*FR-Language-table $(TARGETS_DIR)/fs.src/etc/FR_string_table;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*GR-Language-table $(TARGETS_DIR)/fs.src/etc/GR_string_table;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*IT-Language-table $(TARGETS_DIR)/fs.src/etc/IT_string_table;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*NL-Language-table $(TARGETS_DIR)/fs.src/etc/NL_string_table;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*KO-Language-table $(TARGETS_DIR)/fs.src/etc/KO_string_table;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*SV-Language-table $(TARGETS_DIR)/fs.src/etc/SV_string_table;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*RU-Language-table $(TARGETS_DIR)/fs.src/etc/RU_string_table;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*PT-Language-table $(TARGETS_DIR)/fs.src/etc/PT_string_table;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*JP-Language-table $(TARGETS_DIR)/fs.src/etc/JP_string_table;
endif	
ifeq ($(PROFILE),RAX50)
# Preload string_table - Spanish, Chinese, French, Germany, Italian, Dutch, Korea, Swedish, Russian, Portuguese, Japanese,
	#$(shell) $(USERAPPS_DIR)/project/acos/strings/gen_stringtable.sh $(USERAPPS_DIR)/project/acos/strings $(PROFILE)
	#cd $(TARGETS_DIR)/fs.src/etc; rm -f string_table*;
	#cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*Eng-Language-table $(TARGETS_DIR)/fs.src/etc/Eng_string_table;
	#cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*SP-Language-table $(TARGETS_DIR)/fs.src/etc/SP_string_table;
	#cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*PR-Language-table $(TARGETS_DIR)/fs.src/etc/PR_string_table;
	#cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*FR-Language-table $(TARGETS_DIR)/fs.src/etc/FR_string_table;
	#cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*GR-Language-table $(TARGETS_DIR)/fs.src/etc/GR_string_table;
	#cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*IT-Language-table $(TARGETS_DIR)/fs.src/etc/IT_string_table;
	#cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*NL-Language-table $(TARGETS_DIR)/fs.src/etc/NL_string_table;
	#cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*KO-Language-table $(TARGETS_DIR)/fs.src/etc/KO_string_table;
	#cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*SV-Language-table $(TARGETS_DIR)/fs.src/etc/SV_string_table;
	#cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*RU-Language-table $(TARGETS_DIR)/fs.src/etc/RU_string_table;
	#cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*PT-Language-table $(TARGETS_DIR)/fs.src/etc/PT_string_table;
	#cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*JP-Language-table $(TARGETS_DIR)/fs.src/etc/JP_string_table;
endif	
ifeq ($(PROFILE),MS60)
# Preload string_table - Spanish, Chinese, French, Germany, Italian, Dutch, Korea, Swedish, Russian, Portuguese, Japanese,
	$(shell) $(USERAPPS_DIR)/project/acos/strings/gen_stringtable.sh $(USERAPPS_DIR)/project/acos/strings $(PROFILE)
	cd $(TARGETS_DIR)/fs.src/etc; rm -f string_table*;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*Eng-Language-table $(TARGETS_DIR)/fs.src/etc/Eng_string_table;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*SP-Language-table $(TARGETS_DIR)/fs.src/etc/SP_string_table;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*PR-Language-table $(TARGETS_DIR)/fs.src/etc/PR_string_table;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*FR-Language-table $(TARGETS_DIR)/fs.src/etc/FR_string_table;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*GR-Language-table $(TARGETS_DIR)/fs.src/etc/GR_string_table;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*IT-Language-table $(TARGETS_DIR)/fs.src/etc/IT_string_table;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*NL-Language-table $(TARGETS_DIR)/fs.src/etc/NL_string_table;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*KO-Language-table $(TARGETS_DIR)/fs.src/etc/KO_string_table;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*SV-Language-table $(TARGETS_DIR)/fs.src/etc/SV_string_table;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*RU-Language-table $(TARGETS_DIR)/fs.src/etc/RU_string_table;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*PT-Language-table $(TARGETS_DIR)/fs.src/etc/PT_string_table;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*JP-Language-table $(TARGETS_DIR)/fs.src/etc/JP_string_table;
endif	
ifeq ($(PROFILE),EAX20)
# Preload string_table - Spanish, Chinese, French, Germany, Italian, Dutch, Korea, Swedish, Russian, Portuguese, Japanese,
	$(shell) $(USERAPPS_DIR)/project/acos/strings/gen_stringtable.sh $(USERAPPS_DIR)/project/acos/strings $(PROFILE)
	cd $(TARGETS_DIR)/fs.src/etc; rm -f string_table*;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*Eng-Language-table $(TARGETS_DIR)/fs.src/etc/Eng_string_table;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*SP-Language-table $(TARGETS_DIR)/fs.src/etc/SP_string_table;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*PR-Language-table $(TARGETS_DIR)/fs.src/etc/PR_string_table;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*FR-Language-table $(TARGETS_DIR)/fs.src/etc/FR_string_table;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*GR-Language-table $(TARGETS_DIR)/fs.src/etc/GR_string_table;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*IT-Language-table $(TARGETS_DIR)/fs.src/etc/IT_string_table;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*NL-Language-table $(TARGETS_DIR)/fs.src/etc/NL_string_table;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*KO-Language-table $(TARGETS_DIR)/fs.src/etc/KO_string_table;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*SV-Language-table $(TARGETS_DIR)/fs.src/etc/SV_string_table;
	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*RU-Language-table $(TARGETS_DIR)/fs.src/etc/RU_string_table;
#	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*PT-Language-table $(TARGETS_DIR)/fs.src/etc/PT_string_table;
#	cp -f $(USERAPPS_DIR)/project/acos/strings/$(PROFILE)-preload-stringtable/*JP-Language-table $(TARGETS_DIR)/fs.src/etc/JP_string_table;
endif	



#acos: acos_link
#	$(MAKE) -C $(USERAPPS_DIR)/ap/acos CROSS=$(CROSS_COMPILE) STRIPTOOL=$(STRIP)
#	$(MAKE) -C $(USERAPPS_DIR)/ap/acos CROSS=$(CROSS_COMPILE) STRIPTOOL=$(STRIP) INSTALLDIR=$(INSTALLDIR) install

acos_httpd:
	$(MAKE) -C $(USERAPPS_DIR)/ap/acos/www_orbi CROSS=$(CROSS_COMPILE) STRIPTOOL=$(STRIP)
#	$(MAKE) -C $(USERAPPS_DIR)/ap/acos/www_orbi CROSS=$(CROSS_COMPILE) STRIPTOOL=$(STRIP) INSTALLDIR=$(INSTALLDIR) install
	$(MAKE) -C $(USERAPPS_DIR)/ap/acos/httpd CROSS=$(CROSS_COMPILE) STRIPTOOL=$(STRIP)
#	$(MAKE) -C $(USERAPPS_DIR)/ap/acos CROSS=$(CROSS_COMPILE) STRIPTOOL=$(STRIP) INSTALLDIR=$(INSTALLDIR) install
	
acos_gui: acos_link
	$(MAKE) -C $(USERAPPS_DIR)/ap/acos CROSS=$(CROSS_COMPILE) STRIPTOOL=$(STRIP) GUI
	$(MAKE) -C $(USERAPPS_DIR)/ap/acos CROSS=$(CROSS_COMPILE) STRIPTOOL=$(STRIP) INSTALLDIR=$(INSTALLDIR) GUI_install

#acos_clean: 
#	$(MAKE) -C $(USERAPPS_DIR)/ap/acos CROSS=$(CROSS_COMPILE) STRIPTOOL=$(STRIP) clean
#	$(MAKE) -C $(USERAPPS_DIR)/ap/acos CROSS=$(CROSS_COMPILE) STRIPTOOL=$(STRIP) modules_clean
    
gpl: 
	$(MAKE) -C $(USERAPPS_DIR)/ap/gpl CROSS=$(CROSS_COMPILE) STRIPTOOL=$(STRIP)
	$(MAKE) -C $(USERAPPS_DIR)/ap/gpl CROSS=$(CROSS_COMPILE) STRIPTOOL=$(STRIP) INSTALLDIR=$(INSTALLDIR) install

gpl_install:
	$(MAKE) -C $(USERAPPS_DIR)/ap/gpl install

pre_build_gpl:
	$(MAKE) -C $(USERAPPS_DIR)/ap/gpl CROSS=$(CROSS_COMPILE) STRIPTOOL=$(STRIP) openssl_make
	$(MAKE) -C $(USERAPPS_DIR)/ap/gpl/openssl CROSS=$(CROSS_COMPILE) STRIPTOOL=$(STRIP) INSTALLDIR=$(INSTALLDIR) install
	
pre_build_acos: acos_link
	$(MAKE) -C $(USERAPPS_DIR)/ap/acos CROSS=$(CROSS_COMPILE) STRIPTOOL=$(STRIP) pre_build
	$(MAKE) -C $(USERAPPS_DIR)/ap/acos CROSS=$(CROSS_COMPILE) STRIPTOOL=$(STRIP) INSTALLDIR=$(INSTALLDIR) pre_install
	
rc:
	$(MAKE) -C $(BUILDDIR)/bcmdrivers/broadcom/net/wl/impl51/main/src/router/rc
	
rc_clean:
	$(MAKE) -C $(BUILDDIR)/bcmdrivers/broadcom/net/wl/impl51/main/src/router/rc clean

