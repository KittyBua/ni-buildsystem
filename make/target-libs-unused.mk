#
# makefile to build system libs (currently unused in ni-image)
#
# -----------------------------------------------------------------------------

LIBID3TAG_VERSION = 0.15.1b
LIBID3TAG_DIR = libid3tag-$(LIBID3TAG_VERSION)
LIBID3TAG_SOURCE = libid3tag-$(LIBID3TAG_VERSION).tar.gz
LIBID3TAG_SITE = https://sourceforge.net/projects/mad/files/libid3tag/$(LIBID3TAG_VERSION)

$(DL_DIR)/$(LIBID3TAG_SOURCE):
	$(download) $(LIBID3TAG_SITE)/$(LIBID3TAG_SOURCE)

LIBID3TAG_DEPENDENCIES = zlib

LIBID3TAG_AUTORECONF = YES

LIBID3TAG_CONF_OPTS = \
	--enable-shared=yes

libid3tag: $(LIBID3TAG_DEPENDENCIES) $(DL_DIR)/$(LIBID3TAG_SOURCE) | $(TARGET_DIR)
	$(REMOVE)/$(PKG_DIR)
	$(UNTAR)/$(PKG_SOURCE)
	$(CHDIR)/$(PKG_DIR); \
		$(APPLY_PATCHES); \
		$(CONFIGURE); \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)
	$(REMOVE)/$(PKG_DIR)
	$(TOUCH)

# -----------------------------------------------------------------------------

FONTCONFIG_VERSION = 2.11.93
FONTCONFIG_DIR = fontconfig-$(FONTCONFIG_VERSION)
FONTCONFIG_SOURCE = fontconfig-$(FONTCONFIG_VERSION).tar.bz2
FONTCONFIG_SITE = https://www.freedesktop.org/software/fontconfig/release

$(DL_DIR)/$(FONTCONFIG_SOURCE):
	$(download) $(FONTCONFIG_SITE)/$(FONTCONFIG_SOURCE)

FONTCONFIG_DEPENDENCIES = freetype expat

FONTCONFIG_CONF_OPTS = \
	--with-freetype-config=$(HOST_DIR)/bin/freetype-config \
	--with-expat-includes=$(TARGET_includedir) \
	--with-expat-lib=$(TARGET_libdir) \
	--disable-docs

fontconfig: $(FONTCONFIG_DEPENDENCIES) $(DL_DIR)/$(FONTCONFIG_SOURCE) | $(TARGET_DIR)
	$(REMOVE)/$(PKG_DIR)
	$(UNTAR)/$(PKG_SOURCE)
	$(CHDIR)/$(PKG_DIR); \
		$(APPLY_PATCHES); \
		$(CONFIGURE); \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)
	$(REMOVE)/$(PKG_DIR)
	$(TOUCH)

# -----------------------------------------------------------------------------

PIXMAN_VERSION = 0.34.0
PIXMAN_DIR = pixman-$(PIXMAN_VERSION)
PIXMAN_SOURCE = pixman-$(PIXMAN_VERSION).tar.gz
PIXMAN_SITE = https://www.cairographics.org/releases

$(DL_DIR)/$(PIXMAN_SOURCE):
	$(download) $(PIXMAN_SITE)/$(PIXMAN_SOURCE)

PIXMAN_DEPENDENCIES = zlib libpng

PIXMAN_CONF_OPTS = \
	--disable-gtk \
	--disable-arm-simd \
	--disable-loongson-mmi \
	--disable-docs

pixman: $(PIXMAN_DEPENDENCIES) $(DL_DIR)/$(PIXMAN_SOURCE) | $(TARGET_DIR)
	$(REMOVE)/$(PKG_DIR)
	$(UNTAR)/$(PKG_SOURCE)
	$(CHDIR)/$(PKG_DIR); \
		$(APPLY_PATCHES); \
		$(CONFIGURE); \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)
	$(REMOVE)/$(PKG_DIR)
	$(TOUCH)

# -----------------------------------------------------------------------------

CAIRO_VERSION = 1.16.0
CAIRO_DIR = cairo-$(CAIRO_VERSION)
CAIRO_SOURCE = cairo-$(CAIRO_VERSION).tar.xz
CAIRO_SITE = https://www.cairographics.org/releases

$(DL_DIR)/$(CAIRO_SOURCE):
	$(download) $(CAIRO_SITE)/$(CAIRO_SOURCE)

CAIRO_DEPENDENCIES = fontconfig glib2 libpng pixman zlib

CAIRO_CONF_ENV = \
	ax_cv_c_float_words_bigendian="no"

CAIRO_CONF_OPTS = \
	--with-html-dir=$(REMOVE_htmldir) \
	--with-x=no \
	--disable-xlib \
	--disable-xcb \
	--disable-egl \
	--disable-glesv2 \
	--disable-gl \
	--enable-tee

cairo: $(CAIRO_DEPENDENCIES) $(DL_DIR)/$(CAIRO_SOURCE) | $(TARGET_DIR)
	$(REMOVE)/$(PKG_DIR)
	$(UNTAR)/$(PKG_SOURCE)
	$(CHDIR)/$(PKG_DIR); \
		$(APPLY_PATCHES); \
		$(CONFIGURE); \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	rm -rf $(TARGET_bindir)/cairo-sphinx
	rm -rf $(TARGET_libdir)/cairo/cairo-fdr*
	rm -rf $(TARGET_libdir)/cairo/cairo-sphinx*
	rm -rf $(TARGET_libdir)/cairo/.debug/cairo-fdr*
	rm -rf $(TARGET_libdir)/cairo/.debug/cairo-sphinx*
	$(REWRITE_LIBTOOL)
	$(REMOVE)/$(PKG_DIR)
	$(TOUCH)

# -----------------------------------------------------------------------------

HARFBUZZ_VERSION = 1.8.8
HARFBUZZ_DIR = harfbuzz-$(HARFBUZZ_VERSION)
HARFBUZZ_SOURCE = harfbuzz-$(HARFBUZZ_VERSION).tar.bz2
HARFBUZZ_SITE = https://www.freedesktop.org/software/harfbuzz/release

$(DL_DIR)/$(HARFBUZZ_SOURCE):
	$(download) $(HARFBUZZ_SITE)/$(HARFBUZZ_SOURCE)

HARFBUZZ_DEPENDENCIES = fontconfig glib2 cairo freetype

HARFBUZZ_AUTORECONF = YES

HARFBUZZ_CONF_OPTS = \
	--with-cairo \
	--with-fontconfig \
	--with-freetype \
	--with-glib \
	--without-graphite2 \
	--without-icu

harfbuzz: $(HARFBUZZ_DEPENDENCIES) $(DL_DIR)/$(HARFBUZZ_SOURCE) | $(TARGET_DIR)
	$(REMOVE)/$(PKG_DIR)
	$(UNTAR)/$(PKG_SOURCE)
	$(CHDIR)/$(PKG_DIR); \
		$(APPLY_PATCHES); \
		$(CONFIGURE); \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)
	$(REMOVE)/$(PKG_DIR)
	$(TOUCH)
