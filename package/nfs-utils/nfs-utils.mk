################################################################################
#
# nfs-utils
#
################################################################################

NFS_UTILS_VERSION = 1.2.6
NFS_UTILS_SOURCE = nfs-utils-$(NFS_UTILS_VERSION).tar.bz2
NFS_UTILS_SITE = http://downloads.sourceforge.net/project/nfs/nfs-utils/$(NFS_UTILS_VERSION)
NFS_UTILS_LICENSE = GPLv2+
NFS_UTILS_LICENSE_FILES = COPYING
NFS_UTILS_AUTORECONF = YES
NFS_UTILS_DEPENDENCIES = host-pkgconf

NFS_UTILS_CONF_ENV = knfsd_cv_bsd_signals=no

NFS_UTILS_CONF_OPTS = \
	--disable-nfsv4 \
	--disable-nfsv41 \
	--disable-gss \
	--disable-uuid \
	--disable-ipv6 \
	--without-tcp-wrappers \
	--with-rpcgen=internal

NFS_UTILS_TARGETS_$(BR2_PACKAGE_NFS_UTILS_RPCDEBUG) += usr/sbin/rpcdebug
NFS_UTILS_TARGETS_$(BR2_PACKAGE_NFS_UTILS_RPC_LOCKD) += usr/sbin/rpc.lockd
NFS_UTILS_TARGETS_$(BR2_PACKAGE_NFS_UTILS_RPC_RQUOTAD) += usr/sbin/rpc.rquotad

ifeq ($(BR2_PACKAGE_LIBTIRPC),y)
NFS_UTILS_CONF_OPTS += --enable-tirpc
NFS_UTILS_DEPENDENCIES += libtirpc
else
NFS_UTILS_CONF_OPTS += --disable-tirpc
endif

define NFS_UTILS_INSTALL_FIXUP
	$(NFS_UTILS_FAKEROOT) rm -f $(NFS_UTILS_TARGETS_)
endef

NFS_UTILS_POST_INSTALL_TARGET_HOOKS += NFS_UTILS_INSTALL_FIXUP

define NFS_UTILS_INSTALL_INIT_SYSV
	$(NFS_UTILS_FAKEROOT) $(INSTALL) -D -m 0755 package/nfs-utils/S60nfs \
		$(NFS_UTILS_TARGET_DIR)/etc/init.d/S60nfs
endef

define NFS_UTILS_REMOVE_NFSIOSTAT
	$(NFS_UTILS_FAKEROOT) rm -f $(NFS_UTILS_TARGET_DIR)/usr/sbin/nfsiostat
endef

# nfsiostat is interpreted python, so remove it unless it's in the target
NFS_UTILS_POST_INSTALL_TARGET_HOOKS += $(if $(BR2_PACKAGE_PYTHON),,NFS_UTILS_REMOVE_NFSIOSTAT)

$(eval $(autotools-package))
