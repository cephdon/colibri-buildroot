################################################################################
#
# blktrace
#
################################################################################

BLKTRACE_VERSION = 1.1.0
BLKTRACE_SITE = http://brick.kernel.dk/snaps
BLKTRACE_DEPENDENCIES = libaio
BLKTRACE_LICENSE = GPLv2+
BLKTRACE_LICENSE_FILES = COPYING

define BLKTRACE_BUILD_CMDS
	$(MAKE1) -C $(@D) $(TARGET_CONFIGURE_OPTS)
endef

define BLKTRACE_INSTALL_TARGET_CMDS
	$(MAKE1) -C $(@D) $(TARGET_CONFIGURE_OPTS) install \
		DESTDIR=$(BLKTRACE_TARGET_DIR) prefix=/usr
endef

$(eval $(generic-package))
