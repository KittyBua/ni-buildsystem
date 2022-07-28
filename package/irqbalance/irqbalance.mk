################################################################################
#
# irqbalance
#
################################################################################

IRQBALANCE_VERSION = 1.9.0
IRQBALANCE_DIR = irqbalance-$(IRQBALANCE_VERSION)
IRQBALANCE_SOURCE = irqbalance-$(IRQBALANCE_VERSION).tar.gz
IRQBALANCE_SITE = $(call github,irqbalance,irqbalance,v$(IRQBALANCE_VERSION))

IRQBALANCE_DEPENDENCIES = glib2 ncurses

# Autoreconf needed because package is distributed without a configure script
IRQBALANCE_AUTORECONF = YES

IRQBALANCE_CONF_OPTS = \
	--with-irqbalance-ui

define IRQBALANCE_INSTALL_INIT_SCRIPT
	$(INSTALL_EXEC) -D $(PKG_FILES_DIR)/irqbalance.init $(TARGET_sysconfdir)/init.d/irqbalance
	$(UPDATE-RC.D) irqbalance defaults 75 25
endef
IRQBALANCE_TARGET_FINALIZE_HOOKS += IRQBALANCE_INSTALL_INIT_SCRIPT

irqbalance: | $(TARGET_DIR)
	$(call autotools-package)