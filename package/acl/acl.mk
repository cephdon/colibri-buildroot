################################################################################
#
# acl
#
################################################################################

ACL_VERSION = 2.2.52
ACL_SOURCE = acl-$(ACL_VERSION).src.tar.gz
ACL_SITE = http://download.savannah.gnu.org/releases/acl
ACL_INSTALL_STAGING = YES
ACL_DEPENDENCIES = attr
ACL_CONF_OPTS = --enable-gettext=no
ACL_LICENSE = GPLv2+ (programs), LGPLv2.1+ (libraries)
ACL_LICENSE_FILES = doc/COPYING doc/COPYING.LGPL

HOST_ACL_DEPENDENCIES = host-attr

# While the configuration system uses autoconf, the Makefiles are
# hand-written and do not use automake. Therefore, we have to hack
# around their deficiencies by passing installation paths.
ACL_INSTALL_STAGING_OPTS = 			\
	prefix=$(STAGING_DIR)/usr 		\
	exec_prefix=$(STAGING_DIR)/usr 		\
	PKG_DEVLIB_DIR=$(STAGING_DIR)/usr/lib	\
	install-dev install-lib

ACL_INSTALL_TARGET_OPTS = 			\
	prefix=$(ACL_TARGET_DIR)/usr 		\
	exec_prefix=$(ACL_TARGET_DIR)/usr 		\
	install install-lib

HOST_ACL_INSTALL_OPTS = 	\
	prefix=$(HOST_DIR)/usr 		\
	exec_prefix=$(HOST_DIR)/usr		\
	PKG_DEVLIB_DIR=$(HOST_DIR)/usr/lib 	\
	install-dev install-lib

$(eval $(autotools-package))
$(eval $(host-autotools-package))
