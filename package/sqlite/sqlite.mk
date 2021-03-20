################################################################################
#
# sqlite
#
################################################################################

SQLITE_VERSION = 3330000
SQLITE_DIR = sqlite-autoconf-$(SQLITE_VERSION)
SQLITE_SOURCE = sqlite-autoconf-$(SQLITE_VERSION).tar.gz
SQLITE_SITE = http://www.sqlite.org/2020

SQLITE_CONF_OPTS = \
	--bindir=$(REMOVE_bindir)

sqlite: | $(TARGET_DIR)
	$(call autotools-package)
