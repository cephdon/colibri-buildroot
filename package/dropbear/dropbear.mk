################################################################################
#
# dropbear
#
################################################################################

DROPBEAR_VERSION = 2015.67
DROPBEAR_SITE = http://matt.ucc.asn.au/dropbear/releases
DROPBEAR_SOURCE = dropbear-$(DROPBEAR_VERSION).tar.bz2
DROPBEAR_LICENSE = MIT, BSD-2c-like, BSD-2c
DROPBEAR_LICENSE_FILES = LICENSE
DROPBEAR_TARGET_BINS = dropbearkey dropbearconvert scp
DROPBEAR_PROGRAMS = dropbear $(DROPBEAR_TARGET_BINS)

ifeq ($(BR2_PACKAGE_DROPBEAR_CLIENT),y)
# Build dbclient, and create a convenience symlink named ssh
DROPBEAR_PROGRAMS += dbclient
DROPBEAR_TARGET_BINS += dbclient ssh
endif

DROPBEAR_MAKE = \
	$(MAKE) MULTI=1 SCPPROGRESS=1 \
	PROGRAMS="$(DROPBEAR_PROGRAMS)"

ifeq ($(BR2_STATIC_LIBS),y)
DROPBEAR_MAKE += STATIC=1
endif

define DROPBEAR_FIX_XAUTH
	$(SED) 's,^#define XAUTH_COMMAND.*/xauth,#define XAUTH_COMMAND "/usr/bin/xauth,g' $(@D)/options.h
endef

DROPBEAR_POST_EXTRACT_HOOKS += DROPBEAR_FIX_XAUTH

define DROPBEAR_ENABLE_REVERSE_DNS
	$(SED) 's:.*\(#define DO_HOST_LOOKUP\).*:\1:' $(@D)/options.h
endef

define DROPBEAR_BUILD_SMALL
	$(SED) 's:.*\(#define NO_FAST_EXPTMOD\).*:\1:' $(@D)/options.h
endef

define DROPBEAR_BUILD_FEATURED
	$(SED) 's:^#define DROPBEAR_SMALL_CODE::' $(@D)/options.h
	$(SED) 's:.*\(#define DROPBEAR_BLOWFISH\).*:\1:' $(@D)/options.h
	$(SED) 's:.*\(#define DROPBEAR_TWOFISH128\).*:\1:' $(@D)/options.h
	$(SED) 's:.*\(#define DROPBEAR_TWOFISH256\).*:\1:' $(@D)/options.h
endef

define DROPBEAR_DISABLE_STANDALONE
	$(SED) 's:\(#define NON_INETD_MODE\):/*\1 */:' $(@D)/options.h
endef

define DROPBEAR_INSTALL_INIT_SYSTEMD
	$(DROPBEAR_FAKEROOT) $(DROPBEAR_FAKEROOT_ENV) $(INSTALL) -D -m 644 package/dropbear/dropbear.service \
		$(DROPBEAR_TARGET_DIR)/etc/systemd/system/dropbear.service
	$(DROPBEAR_FAKEROOT) $(DROPBEAR_FAKEROOT_ENV) mkdir -p $(DROPBEAR_TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	$(DROPBEAR_FAKEROOT) $(DROPBEAR_FAKEROOT_ENV) ln -fs ../dropbear.service \
		$(DROPBEAR_TARGET_DIR)/etc/systemd/system/multi-user.target.wants/dropbear.service
endef

ifeq ($(BR2_USE_MMU),y)
define DROPBEAR_INSTALL_INIT_SYSV
	$(DROPBEAR_FAKEROOT) $(DROPBEAR_FAKEROOT_ENV) $(INSTALL) -D -m 0755 package/dropbear/dropbear.init \
		$(DROPBEAR_TARGET_DIR)/etc/init.d/dropbear
	$(DROPBEAR_FAKEROOT) $(DROPBEAR_FAKEROOT_ENV) $(INSTALL) -D -m 0644 package/dropbear/dropbear.default \
		$(DROPBEAR_TARGET_DIR)/etc/default/dropbear
		
	$(DROPBEAR_FAKEROOT) $(DROPBEAR_FAKEROOT_ENV) $(INSTALL) -d -m 0755 $(DROPBEAR_TARGET_DIR)/etc/rc.d/rc.startup.d	
	$(DROPBEAR_FAKEROOT) $(DROPBEAR_FAKEROOT_ENV) $(INSTALL) -d -m 0755 $(DROPBEAR_TARGET_DIR)/etc/rc.d/rc.shutdown.d
	
	$(DROPBEAR_FAKEROOT) $(DROPBEAR_FAKEROOT_ENV) ln -fs ../../init.d/dropbear \
		$(DROPBEAR_TARGET_DIR)/etc/rc.d/rc.startup.d/S50dropbear
	$(DROPBEAR_FAKEROOT) $(DROPBEAR_FAKEROOT_ENV) ln -fs ../../init.d/dropbear \
		$(DROPBEAR_TARGET_DIR)/etc/rc.d/rc.shutdown.d/S50dropbear
endef
else
DROPBEAR_POST_EXTRACT_HOOKS += DROPBEAR_DISABLE_STANDALONE
endif

ifeq ($(BR2_PACKAGE_DROPBEAR_DISABLE_REVERSEDNS),)
DROPBEAR_POST_EXTRACT_HOOKS += DROPBEAR_ENABLE_REVERSE_DNS
endif

ifeq ($(BR2_PACKAGE_DROPBEAR_SMALL),y)
DROPBEAR_POST_EXTRACT_HOOKS += DROPBEAR_BUILD_SMALL
DROPBEAR_CONF_OPTS += --disable-zlib
else
DROPBEAR_POST_EXTRACT_HOOKS += DROPBEAR_BUILD_FEATURED
DROPBEAR_DEPENDENCIES += zlib
endif

ifneq ($(BR2_PACKAGE_DROPBEAR_WTMP),y)
DROPBEAR_CONF_OPTS += --disable-wtmp
endif

ifneq ($(BR2_PACKAGE_DROPBEAR_LASTLOG),y)
DROPBEAR_CONF_OPTS += --disable-lastlog
endif

define DROPBEAR_INSTALL_TARGET_CMDS
	$(DROPBEAR_FAKEROOT) $(DROPBEAR_FAKEROOT_ENV) $(INSTALL) -d -m 0755 $(DROPBEAR_TARGET_DIR)/usr/sbin
	$(DROPBEAR_FAKEROOT) $(DROPBEAR_FAKEROOT_ENV) $(INSTALL) -d -m 0755 $(DROPBEAR_TARGET_DIR)/usr/bin
	$(DROPBEAR_FAKEROOT) $(DROPBEAR_FAKEROOT_ENV) $(INSTALL) -m 755 $(@D)/dropbearmulti $(DROPBEAR_TARGET_DIR)/usr/sbin/dropbear
	for f in $(DROPBEAR_TARGET_BINS); do \
		$(DROPBEAR_FAKEROOT) $(DROPBEAR_FAKEROOT_ENV) ln -snf ../sbin/dropbear $(DROPBEAR_TARGET_DIR)/usr/bin/$$f ; \
	done
	$(DROPBEAR_FAKEROOT) $(DROPBEAR_FAKEROOT_ENV) mkdir -p $(DROPBEAR_TARGET_DIR)/etc/dropbear
endef

$(eval $(autotools-package))
