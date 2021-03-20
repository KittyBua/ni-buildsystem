################################################################################
#
# rpcbind
#
################################################################################

RPCBIND_VERSION = 1.2.5
RPCBIND_DIR = rpcbind-$(RPCBIND_VERSION)
RPCBIND_SOURCE = rpcbind-$(RPCBIND_VERSION).tar.bz2
RPCBIND_SITE = https://sourceforge.net/projects/rpcbind/files/rpcbind/$(RPCBIND_VERSION)

RPCBIND_DEPENDENCIES = libtirpc

RPCBIND_AUTORECONF = YES

RPCBIND_CONF_OPTS = \
	--enable-silent-rules \
	--with-rpcuser=root \
	--with-systemdsystemunitdir=no

define RPCBIND_TARGET_CLEANUP
	-rm $(TARGET_bindir)/rpcgen
endef
RPCBIND_TARGET_FINALIZE_HOOKS += RPCBIND_TARGET_CLEANUP

rpcbind: | $(TARGET_DIR)
	$(call autotools-package)
