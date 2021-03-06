################################################################################
#
# fb-test-app
#
################################################################################

FB_TEST_APP_VERSION = rosetta-1.1.0
FB_TEST_APP_SITE = $(call github,prpplague,fb-test-app,$(FB_TEST_APP_VERSION))
FB_TEST_APP_LICENSE = GPLv2
FB_TEST_APP_LICENSE_FILES = COPYING

define FB_TEST_APP_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) all
endef

define FB_TEST_APP_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/perf $(FB_TEST_APP_TARGET_DIR)/usr/bin/fb-test-perf
	$(INSTALL) -D -m 0755 $(@D)/rect $(FB_TEST_APP_TARGET_DIR)/usr/bin/fb-test-rect
	$(INSTALL) -D -m 0755 $(@D)/fb-test $(FB_TEST_APP_TARGET_DIR)/usr/bin/fb-test
	$(INSTALL) -D -m 0755 $(@D)/offset $(FB_TEST_APP_TARGET_DIR)/usr/bin/fb-test-offset
endef

$(eval $(generic-package))
