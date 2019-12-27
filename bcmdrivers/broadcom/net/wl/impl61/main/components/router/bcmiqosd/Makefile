#
# bcmiqosd Makefile
#
# $ Copyright Broadcom Corporation $
#
#
# <<Broadcom-WL-IPTag/Proprietary:>>
#
# $Id: $
#

CFLAGS += -I. -I$(TOP)/shared -I$(SRCBASE)/include -Wall

CFLAGS	+= -s
CFLAGS  += -O2

#ifneq ($(strip $(BUILD_BSTREAM_IQOS)),)
#	CFLAGS  += -DUSE_CURL_7_57
#endif

LDFLAGS	+= -L$(TOP)/nvram -L$(PLATFORMDIR)/install/nvram/usr/lib -lnvram -L$(TOP)/shared -L$(PLATFORMDIR)/install/shared/usr/lib -lshared \
	-L$(TOP)/libbcmcrypto -L$(INSTALLDIR)/libbcmcrypto/usr/lib -lbcmcrypto -lpthread
LDFLAGS += -L$(TOP)/libbcm -L$(INSTALLDIR)/libbcm/usr/lib -lbcm
LDFLAGS += $(EXTRA_LDFLAGS)
#LDFLAGS	+= -lpthread
# Foxconn added, Sinclair, 10/20/15
CFLAGS += -DFOXCONN_ADDED

all: bcmiqosd

clean:
	rm -f *.o bcmiqosd

install: all
	install -d $(INSTALLDIR)/usr/sbin
	install bcmiqosd $(INSTALLDIR)/usr/sbin
	$(STRIP) $(INSTALLDIR)/usr/sbin/bcmiqosd

bcmiqosd: bcmiqosd.o
