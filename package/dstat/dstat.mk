################################################################################
#
# dstat
#
################################################################################

DSTAT_VERSION = 0.7.2
DSTAT_SOURCE = dstat-$(DSTAT_VERSION).tar.bz2
DSTAT_SITE = http://dag.wieers.com/home-made/dstat
DSTAT_LICENSE = GPLv2
DSTAT_LICENSE_FILES = COPYING

define DSTAT_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) DESTDIR=$(DSTAT_TARGET_DIR) install
endef

$(eval $(generic-package))
