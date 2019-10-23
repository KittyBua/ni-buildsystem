#
# makefile to build neutrino-plugins
#
# -----------------------------------------------------------------------------

plugins:
	$(MAKE) neutrino-plugins
	$(MAKE) logo-addon
	$(MAKE) neutrino-mediathek
	$(MAKE) doscam-webif-skin
ifneq ($(BOXSERIES), hd1)
	$(MAKE) channellogos
  ifneq ($(BOXMODEL), kronos_v2)
	$(MAKE) links
  endif
endif

# -----------------------------------------------------------------------------

NP_OBJ_DIR = $(BUILD_TMP)/$(NI-NEUTRINO-PLUGINS)

NP_DEPS  = ffmpeg
NP_DEPS += libcurl
NP_DEPS += libpng
NP_DEPS += libjpeg
NP_DEPS += giflib
NP_DEPS += freetype
NP_DEPS += luaexpat
NP_DEPS += luajson
NP_DEPS += luacurl
NP_DEPS += luaposix
NP_DEPS += lua-feedparser

NP_CONFIGURE_ADDITIONS = \
		--disable-logoupdater \
		--disable-logoview \
		--disable-mountpointmanagement \
		--disable-stbup

ifeq ($(BOXSERIES), $(filter $(BOXSERIES), hd1 hd2))
  NP_CONFIGURE_ADDITIONS += \
		--disable-showiframe \
		--disable-stb_startup \
		--disable-imgbackup
endif

$(NP_OBJ_DIR)/config.status: $(NP_DEPS)
	test -d $(NP_OBJ_DIR) || mkdir -p $(NP_OBJ_DIR)
	$(SOURCE_DIR)/$(NI-NEUTRINO-PLUGINS)/autogen.sh
	$(CD) $(NP_OBJ_DIR); \
		$(BUILD_ENV) \
		$(SOURCE_DIR)/$(NI-NEUTRINO-PLUGINS)/configure \
			--host=$(TARGET) \
			--build=$(BUILD) \
			--prefix= \
			--enable-maintainer-mode \
			--enable-silent-rules \
			\
			--with-neutrino-source=$(SOURCE_DIR)/$(NI-NEUTRINO) \
			--with-neutrino-build=$(N_OBJ_DIR) \
			\
			$(NP_CONFIGURE_ADDITIONS) \
			\
			--with-target=cdk \
			--with-targetprefix= \
			--with-boxtype=$(BOXTYPE) \
			--with-boxmodel=$(BOXSERIES)

# -----------------------------------------------------------------------------

neutrino-plugins: neutrino $(NP_OBJ_DIR)/config.status
	PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
	$(MAKE) -C $(NP_OBJ_DIR) all     DESTDIR=$(TARGET_DIR)
	$(MAKE) -C $(NP_OBJ_DIR) install DESTDIR=$(TARGET_DIR)
	$(TOUCH)

# -----------------------------------------------------------------------------

neutrino-plugins-uninstall:
	-make -C $(NP_OBJ_DIR) uninstall DESTDIR=$(TARGET_DIR)

neutrino-plugins-distclean:
	-make -C $(NP_OBJ_DIR) distclean

neutrino-plugins-clean: neutrino-plugins-uninstall neutrino-plugins-distclean
	rm -f $(NP_OBJ_DIR)/config.status
	rm -f $(D)/neutrino-plugins

neutrino-plugins-clean-all: neutrino-plugins-clean
	rm -rf $(NP_OBJ_DIR)

# -----------------------------------------------------------------------------

# To build single plugins from neutrino-plugins repository call
# make neutrino-plugin-<subdir>; e.g. make neutrino-plugin-tuxwetter

neutrino-plugin-%: $(NP_OBJ_DIR)/config.status
	PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
	$(MAKE) -C $(NP_OBJ_DIR)/$(subst neutrino-plugin-,,$(@)) all install DESTDIR=$(TARGET_DIR)

# -----------------------------------------------------------------------------

channellogos: $(SOURCE_DIR)/$(NI-LOGO-STUFF) $(SHAREICONS)
	rm -rf $(SHAREICONS)/logo
	mkdir -p $(SHAREICONS)/logo
	$(INSTALL_DATA) $(SOURCE_DIR)/$(NI-LOGO-STUFF)/logos/* $(SHAREICONS)/logo
	mkdir -p $(SHAREICONS)/logo/events
	$(INSTALL_DATA) $(SOURCE_DIR)/$(NI-LOGO-STUFF)/logos-events/* $(SHAREICONS)/logo/events
	$(CD) $(SOURCE_DIR)/$(NI-LOGO-STUFF)/logo-links; \
		./logo-linker.sh logo-links.db $(SHAREICONS)/logo
	$(TOUCH)

# -----------------------------------------------------------------------------

logo-addon: $(SOURCE_DIR)/$(NI-LOGO-STUFF) $(SHAREPLUGINS)
	$(INSTALL_EXEC) $(SOURCE_DIR)/$(NI-LOGO-STUFF)/logo-addon/*.sh $(SHAREPLUGINS)/
	$(INSTALL_DATA) $(SOURCE_DIR)/$(NI-LOGO-STUFF)/logo-addon/*.cfg $(SHAREPLUGINS)/
	$(INSTALL_DATA) $(SOURCE_DIR)/$(NI-LOGO-STUFF)/logo-addon/*.png $(SHAREPLUGINS)/
	$(TOUCH)

# -----------------------------------------------------------------------------

doscam-webif-skin:
	$(INSTALL_DATA) -D $(IMAGEFILES)/doscam-webif-skin/doscam_ni-dark.css $(TARGET_SHARE_DIR)/doscam/skin/doscam_ni-dark.css
	$(INSTALL_DATA) -D $(IMAGEFILES)/doscam-webif-skin/IC_doscam_ni.tpl $(TARGET_SHARE_DIR)/doscam/tpl/IC_doscam_ni.tpl
	$(TOUCH)

# -----------------------------------------------------------------------------

NEUTRINO-MEDIATHEK_VER    = git
NEUTRINO-MEDIATHEK_TMP    = mediathek.$(NEUTRINO-MEDIATHEK_VER)
NEUTRINO-MEDIATHEK_SOURCE = mediathek.$(NEUTRINO-MEDIATHEK_VER)
NEUTRINO-MEDIATHEK_URL    = https://github.com/neutrino-mediathek

neutrino-mediathek: $(SHAREPLUGINS) | $(TARGET_DIR)
	$(REMOVE)/$(NEUTRINO-MEDIATHEK_TMP)
	$(GET-GIT-SOURCE) $(NEUTRINO-MEDIATHEK_URL)/$(NEUTRINO-MEDIATHEK_SOURCE) $(ARCHIVE)/$(NEUTRINO-MEDIATHEK_SOURCE)
	$(CPDIR)/$(NEUTRINO-MEDIATHEK_SOURCE)
	$(CHDIR)/$(NEUTRINO-MEDIATHEK_TMP); \
		cp -a plugins/* $(SHAREPLUGINS)/; \
		cp -a share $(TARGET_DIR)
	$(REMOVE)/$(NEUTRINO-MEDIATHEK_TMP)
	$(TOUCH)

# -----------------------------------------------------------------------------

LINKS_VER    = 2.20.2
LINKS_TMP    = links-$(LINKS_VER)
LINKS_SOURCE = links-$(LINKS_VER).tar.bz2
LINKS_URL    = http://links.twibright.com/download

$(ARCHIVE)/$(LINKS_SOURCE):
	$(DOWNLOAD) $(LINKS_URL)/$(LINKS_SOURCE)

LINKS_DEPS   = libpng libjpeg openssl

LINKS_PATCH  = links.patch
LINKS_PATCH += links-ac-prog-cxx.patch
LINKS_PATCH += links-input-$(BOXTYPE).patch
LINKS_PATCH += links-accept_https_play.patch

links: $(LINKS_DEPS) $(ARCHIVE)/$(LINKS_SOURCE) $(SHAREPLUGINS) | $(TARGET_DIR)
	$(REMOVE)/$(LINKS_TMP)
	$(UNTAR)/$(LINKS_SOURCE)
	$(CHDIR)/$(LINKS_TMP)/intl; \
		sed -i -e 's|^T_SAVE_HTML_OPTIONS,.*|T_SAVE_HTML_OPTIONS, "HTML-Optionen speichern",|' german.lng; \
		echo "english" > index.txt; \
		echo "german" >> index.txt; \
		./gen-intl
	$(CHDIR)/$(LINKS_TMP); \
		$(call apply_patches, $(LINKS_PATCH)); \
		autoreconf -vfi; \
		$(CONFIGURE) \
			--prefix= \
			--mandir=$(remove-mandir) \
			--enable-graphics \
			--with-fb \
			--with-libjpeg \
			--with-ssl=$(TARGET_DIR) \
			--without-atheos \
			--without-directfb \
			--without-libtiff \
			--without-lzma \
			--without-pmshell \
			--without-svgalib \
			--without-x \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	mv -f $(TARGET_BIN_DIR)/links $(SHAREPLUGINS)/links.so
	cp -a $(IMAGEFILES)/links/* $(TARGET_DIR)/
	$(REMOVE)/$(LINKS_TMP)
	$(TOUCH)

# -----------------------------------------------------------------------------

PHONY += plugins

PHONY += neutrino-plugins-uninstall neutrino-plugins-distclean
PHONY += neutrino-plugins-clean neutrino-plugins-clean-all
PHONY += neutrino-plugin-%
