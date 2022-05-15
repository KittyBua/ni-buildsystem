################################################################################
#
# CMake packages
#
################################################################################

define cmake-package
	$(call PREPARE)
	$(CHDIR)/$($(PKG)_DIR); \
		$(TARGET_CMAKE); \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	@rm -rf $(TARGET_libdir)/cmake
	$(call TARGET_FOLLOWUP)
endef

define host-cmake-package
	$(call PREPARE)
	$(CHDIR)/$($(PKG)_DIR); \
		$(HOST_CMAKE); \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(call HOST_FOLLOWUP)
endef
