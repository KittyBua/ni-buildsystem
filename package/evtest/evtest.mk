################################################################################
#
# evtest
#
################################################################################

EVTEST_VERSION = 1.35
EVTEST_DIR = evtest-evtest-$(EVTEST_VERSION)
EVTEST_SOURCE = evtest-evtest-$(EVTEST_VERSION).tar.gz
EVTEST_SITE = https://gitlab.freedesktop.org/libevdev/evtest/-/archive/evtest-$(EVTEST_VERSION)

# needed because source package contains no generated files
EVTEST_AUTORECONF = YES

# asciidoc used to generate manpages, which we don't need, and if it's
# present on the build host, it ends getting called with our host-python
# which doesn't have all the needed modules enabled, breaking the build
EVTEST_CONF_ENV = ac_cv_path_ASCIIDOC=""

evtest: | $(TARGET_DIR)
	$(call autotools-package)
