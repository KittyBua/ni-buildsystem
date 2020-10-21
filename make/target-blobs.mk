#
# makefile to add binary large objects
#
# -----------------------------------------------------------------------------

#BLOBS_DEPS = kernel # because of depmod

blobs: $(BLOBS_DEPS)
	$(MAKE) firmware
	$(MAKE) $(BOXMODEL)-drivers
ifeq ($(BOXMODEL), $(filter $(BOXMODEL), hd51 bre2ze4k h7 hd60 hd61 vusolo4k vuduo4k vuduo4kse vuultimo4k vuzero4k vuuno4k vuuno4kse))
	$(MAKE) $(BOXMODEL)-libgles
  ifeq ($(BOXMODEL), $(filter $(BOXMODEL), hd60 hd61))
	$(MAKE) $(BOXMODEL)-libs
  endif
endif
ifeq ($(BOXMODEL), $(filter $(BOXMODEL), vusolo4k vuduo4k vuduo4kse vuultimo4k vuzero4k vuuno4k vuuno4kse))
	$(MAKE) vuplus-platform-util
endif

# -----------------------------------------------------------------------------

firmware: firmware-boxmodel firmware-wireless

firmware-boxmodel: $(SOURCE_DIR)/$(NI-DRIVERS-BIN) | $(TARGET_DIR)
	$(call INSTALL_EXIST,$(SOURCE_DIR)/$(NI-DRIVERS-BIN)/$(DRIVERS-BIN_DIR)/lib-firmware/.,$(TARGET_LIB_DIR)/firmware)
	$(call INSTALL_EXIST,$(SOURCE_DIR)/$(NI-DRIVERS-BIN)/$(DRIVERS-BIN_DIR)/lib-firmware-dvb/.,$(TARGET_LIB_DIR)/firmware)

ifeq ($(BOXMODEL), nevis)
  FIRMWARE-WIRELESS  = rt2870.bin
  FIRMWARE-WIRELESS += rt3070.bin
  FIRMWARE-WIRELESS += rt3071.bin
  FIRMWARE-WIRELESS += rtlwifi/rtl8192cufw.bin
  FIRMWARE-WIRELESS += rtlwifi/rtl8712u.bin
else
  FIRMWARE-WIRELESS  = $(shell cd $(SOURCE_DIR)/$(NI-DRIVERS-BIN)/general/firmware-wireless; find * -type f)
endif

firmware-wireless: $(SOURCE_DIR)/$(NI-DRIVERS-BIN) | $(TARGET_DIR)
	for firmware in $(FIRMWARE-WIRELESS); do \
		$(INSTALL_DATA) -D $(SOURCE_DIR)/$(NI-DRIVERS-BIN)/general/firmware-wireless/$$firmware $(TARGET_LIB_DIR)/firmware/$$firmware; \
	done

# -----------------------------------------------------------------------------

HD51-DRIVERS_VER    = 20191120
HD51-DRIVERS_SOURCE = hd51-drivers-$(KERNEL_VER)-$(HD51-DRIVERS_VER).zip
HD51-DRIVERS_SITE   = http://source.mynonpublic.com/gfutures

BRE2ZE4K-DRIVERS_VER    = 20191120
BRE2ZE4K-DRIVERS_SOURCE = bre2ze4k-drivers-$(KERNEL_VER)-$(BRE2ZE4K-DRIVERS_VER).zip
BRE2ZE4K-DRIVERS_SITE   = http://source.mynonpublic.com/gfutures

H7-DRIVERS_VER    = 20191123
H7-DRIVERS_SOURCE = h7-drivers-$(KERNEL_VER)-$(H7-DRIVERS_VER).zip
H7-DRIVERS_SITE   = http://source.mynonpublic.com/zgemma

HD60-DRIVERS_VER    = 20190319
HD60-DRIVERS_SOURCE = hd60-drivers-$(KERNEL_VER)-$(HD60-DRIVERS_VER).zip
HD60-DRIVERS_SITE   = http://downloads.mutant-digital.net/hd60

HD61-DRIVERS_VER    = 20190711
HD61-DRIVERS_SOURCE = hd61-drivers-$(KERNEL_VER)-$(HD61-DRIVERS_VER).zip
HD61-DRIVERS_SITE   = http://downloads.mutant-digital.net/hd61

VUSOLO4K-DRIVERS_VER    = 20190424
VUSOLO4K-DRIVERS_SOURCE = vuplus-dvb-proxy-vusolo4k-3.14.28-$(VUSOLO4K-DRIVERS_VER).r0.tar.gz
VUSOLO4K-DRIVERS_SITE   = http://archive.vuplus.com/download/build_support/vuplus

ifeq ($(VUPLUS-DRIVERS_LATEST), yes)
VUDUO4K-DRIVERS_VER    = 20191218
else
VUDUO4K-DRIVERS_VER    = 20190212
endif
VUDUO4K-DRIVERS_SOURCE = vuplus-dvb-proxy-vuduo4k-4.1.45-$(VUDUO4K-DRIVERS_VER).r0.tar.gz
VUDUO4K-DRIVERS_SITE   = http://archive.vuplus.com/download/build_support/vuplus

VUDUO4KSE-DRIVERS_VER    = 20200903
VUDUO4KSE-DRIVERS_SOURCE = vuplus-dvb-proxy-vuduo4kse-4.1.45-$(VUDUO4KSE-DRIVERS_VER).r0.tar.gz
VUDUO4KSE-DRIVERS_SITE   = http://archive.vuplus.com/download/build_support/vuplus

ifeq ($(VUPLUS-DRIVERS_LATEST), yes)
VUULTIMO4K-DRIVERS_VER    = 20190424
else
VUULTIMO4K-DRIVERS_VER    = 20190104
endif
VUULTIMO4K-DRIVERS_SOURCE = vuplus-dvb-proxy-vuultimo4k-3.14.28-$(VUULTIMO4K-DRIVERS_VER).r0.tar.gz
VUULTIMO4K-DRIVERS_SITE   = http://archive.vuplus.com/download/build_support/vuplus

VUZERO4K-DRIVERS_VER    = 20190424
VUZERO4K-DRIVERS_SOURCE = vuplus-dvb-proxy-vuzero4k-4.1.20-$(VUZERO4K-DRIVERS_VER).r0.tar.gz
VUZERO4K-DRIVERS_SITE   = http://archive.vuplus.com/download/build_support/vuplus

ifeq ($(VUPLUS-DRIVERS_LATEST), yes)
VUUNO4K-DRIVERS_VER    = 20190424
else
VUUNO4K-DRIVERS_VER    = 20190104
endif
VUUNO4K-DRIVERS_SOURCE = vuplus-dvb-proxy-vuuno4k-3.14.28-$(VUUNO4K-DRIVERS_VER).r0.tar.gz
VUUNO4K-DRIVERS_SITE   = http://archive.vuplus.com/download/build_support/vuplus

ifeq ($(VUPLUS-DRIVERS_LATEST), yes)
VUUNO4KSE-DRIVERS_VER    = 20190424
else
VUUNO4KSE-DRIVERS_VER    = 20190104
endif
VUUNO4KSE-DRIVERS_SOURCE = vuplus-dvb-proxy-vuuno4kse-4.1.20-$(VUUNO4KSE-DRIVERS_VER).r0.tar.gz
VUUNO4KSE-DRIVERS_SITE   = http://archive.vuplus.com/download/build_support/vuplus

VUDUO-DRIVERS_VER    = 20151124
VUDUO-DRIVERS_SOURCE = vuplus-dvb-modules-bm750-3.9.6-$(VUDUO-DRIVERS_VER).tar.gz
VUDUO-DRIVERS_SITE   = http://archive.vuplus.com/download/drivers

# -----------------------------------------------------------------------------

BOXMODEL-DRIVERS_VER    = $($(call UPPERCASE,$(BOXMODEL))-DRIVERS_VER)
BOXMODEL-DRIVERS_SOURCE = $($(call UPPERCASE,$(BOXMODEL))-DRIVERS_SOURCE)
BOXMODEL-DRIVERS_SITE   = $($(call UPPERCASE,$(BOXMODEL))-DRIVERS_SITE)

ifneq ($(BOXMODEL-DRIVERS_SOURCE),$(EMPTY))
$(ARCHIVE)/$(BOXMODEL-DRIVERS_SOURCE):
	$(DOWNLOAD) $(BOXMODEL-DRIVERS_SITE)/$(BOXMODEL-DRIVERS_SOURCE)
endif

nevis-drivers \
apollo-drivers \
shiner-drivers \
kronos-drivers \
kronos_v2-drivers \
coolstream-drivers: $(SOURCE_DIR)/$(NI-DRIVERS-BIN) | $(TARGET_DIR)
	mkdir -p $(TARGET_LIB_DIR)
	$(INSTALL_COPY) $(SOURCE_DIR)/$(NI-DRIVERS-BIN)/$(DRIVERS-BIN_DIR)/lib/. $(TARGET_LIB_DIR)
	$(INSTALL_COPY) $(SOURCE_DIR)/$(NI-DRIVERS-BIN)/$(DRIVERS-BIN_DIR)/libcoolstream/$(shell echo -n $(NI-FFMPEG_BRANCH) | sed 's,/,-,g')/. $(TARGET_LIB_DIR)
ifeq ($(BOXMODEL), nevis)
	ln -sf libnxp.so $(TARGET_LIB_DIR)/libconexant.so
endif
	mkdir -p $(TARGET_MODULES_DIR)
	$(INSTALL_COPY) $(SOURCE_DIR)/$(NI-DRIVERS-BIN)/$(DRIVERS-BIN_DIR)/lib-modules/$(KERNEL_VER)/. $(TARGET_MODULES_DIR)
ifeq ($(BOXMODEL), nevis)
	ln -sf $(KERNEL_VER) $(TARGET_MODULES_DIR)-$(BOXMODEL)
endif
	make depmod
	$(TOUCH)

hd51-drivers \
bre2ze4k-drivers \
h7-drivers: $(ARCHIVE)/$(BOXMODEL-DRIVERS_SOURCE) | $(TARGET_DIR)
	mkdir -p $(TARGET_MODULES_DIR)/extra
	unzip -o $(ARCHIVE)/$(BOXMODEL-DRIVERS_SOURCE) -d $(TARGET_MODULES_DIR)/extra
	make depmod
	$(TOUCH)

hd60-drivers \
hd61-drivers: $(ARCHIVE)/$(BOXMODEL-DRIVERS_SOURCE) | $(TARGET_DIR)
	mkdir -p $(TARGET_MODULES_DIR)/extra
	unzip -o $(ARCHIVE)/$(BOXMODEL-DRIVERS_SOURCE) -d $(TARGET_MODULES_DIR)/extra
	rm -f $(TARGET_MODULES_DIR)/extra/hi_play.ko
	mv $(TARGET_MODULES_DIR)/extra/turnoff_power $(TARGET_DIR)/bin
	make depmod
	$(TOUCH)

vusolo4k-drivers \
vuduo4k-drivers \
vuduo4kse-drivers \
vuultimo4k-drivers \
vuzero4k-drivers \
vuuno4k-drivers \
vuuno4kse-drivers \
vuduo-drivers \
vuplus-drivers: $(ARCHIVE)/$(BOXMODEL-DRIVERS_SOURCE) | $(TARGET_DIR)
	mkdir -p $(TARGET_MODULES_DIR)/extra
	tar -xf $(ARCHIVE)/$(BOXMODEL-DRIVERS_SOURCE) -C $(TARGET_MODULES_DIR)/extra
	make depmod
	$(TOUCH)

# -----------------------------------------------------------------------------

HD51-LIBGLES_VER    = 20191101
HD51-LIBGLES_TMP    = $(EMPTY)
HD51-LIBGLES_SOURCE = hd51-v3ddriver-$(HD51-LIBGLES_VER).zip
HD51-LIBGLES_SITE   = http://downloads.mutant-digital.net/v3ddriver

BRE2ZE4K-LIBGLES_VER    = 20191101
BRE2ZE4K-LIBGLES_TMP    = $(EMPTY)
BRE2ZE4K-LIBGLES_SOURCE = bre2ze4k-v3ddriver-$(BRE2ZE4K-LIBGLES_VER).zip
BRE2ZE4K-LIBGLES_SITE   = http://downloads.mutant-digital.net/v3ddriver

H7-LIBGLES_VER    = 20191110
H7-LIBGLES_TMP    = $(EMPTY)
H7-LIBGLES_SOURCE = h7-v3ddriver-$(H7-LIBGLES_VER).zip
H7-LIBGLES_SITE   = http://source.mynonpublic.com/zgemma

HD60-LIBGLES_VER    = 20181201
HD60-LIBGLES_TMP    = $(EMPTY)
HD60-LIBGLES_SOURCE = hd60-mali-$(HD60-LIBGLES_VER).zip
HD60-LIBGLES_SITE   = http://downloads.mutant-digital.net/hd60

HD61-LIBGLES_VER    = 20181201
HD61-LIBGLES_TMP    = $(EMPTY)
HD61-LIBGLES_SOURCE = hd61-mali-$(HD61-LIBGLES_VER).zip
HD61-LIBGLES_SITE   = http://downloads.mutant-digital.net/hd61

HD6x-LIBGLES-HEADERS_SOURCE = libgles-mali-utgard-headers.zip
HD6x-LIBGLES-HEADERS_SITE   = https://github.com/HD-Digital/meta-gfutures/raw/release-6.2/recipes-bsp/mali/files

VUSOLO4K-LIBGLES_VER    = $(VUSOLO4K-DRIVERS_VER)
VUSOLO4K-LIBGLES_TMP    = libgles-vusolo4k
VUSOLO4K-LIBGLES_SOURCE = libgles-vusolo4k-17.1-$(VUSOLO4K-LIBGLES_VER).r0.tar.gz
VUSOLO4K-LIBGLES_SITE   = http://archive.vuplus.com/download/build_support/vuplus

VUDUO4K-LIBGLES_VER    = $(VUDUO4K-DRIVERS_VER)
VUDUO4K-LIBGLES_TMP    = libgles-vuduo4k
VUDUO4K-LIBGLES_SOURCE = libgles-vuduo4k-18.1-$(VUDUO4K-LIBGLES_VER).r0.tar.gz
VUDUO4K-LIBGLES_SITE   = http://archive.vuplus.com/download/build_support/vuplus

VUDUO4KSE-LIBGLES_VER    = $(VUDUO4KSE-DRIVERS_VER)
VUDUO4KSE-LIBGLES_TMP    = libgles-vuduo4kse
VUDUO4KSE-LIBGLES_SOURCE = libgles-vuduo4kse-17.1-$(VUDUO4KSE-LIBGLES_VER).r0.tar.gz
VUDUO4KSE-LIBGLES_SITE   = http://archive.vuplus.com/download/build_support/vuplus

VUULTIMO4K-LIBGLES_VER    = $(VUULTIMO4K-DRIVERS_VER)
VUULTIMO4K-LIBGLES_TMP    = libgles-vuultimo4k
VUULTIMO4K-LIBGLES_SOURCE = libgles-vuultimo4k-17.1-$(VUULTIMO4K-LIBGLES_VER).r0.tar.gz
VUULTIMO4K-LIBGLES_SITE   = http://archive.vuplus.com/download/build_support/vuplus

VUZERO4K-LIBGLES_VER    = $(VUZERO4K-DRIVERS_VER)
VUZERO4K-LIBGLES_TMP    = libgles-vuzero4k
VUZERO4K-LIBGLES_SOURCE = libgles-vuzero4k-17.1-$(VUZERO4K-LIBGLES_VER).r0.tar.gz
VUZERO4K-LIBGLES_SITE   = http://archive.vuplus.com/download/build_support/vuplus

VUUNO4K-LIBGLES_VER    = $(VUUNO4K-DRIVERS_VER)
VUUNO4K-LIBGLES_TMP    = libgles-vuuno4k
VUUNO4K-LIBGLES_SOURCE = libgles-vuuno4k-17.1-$(VUUNO4K-LIBGLES_VER).r0.tar.gz
VUUNO4K-LIBGLES_SITE   = http://archive.vuplus.com/download/build_support/vuplus

VUUNO4KSE-LIBGLES_VER    = $(VUUNO4KSE-DRIVERS_VER)
VUUNO4KSE-LIBGLES_TMP    = libgles-vuuno4kse
VUUNO4KSE-LIBGLES_SOURCE = libgles-vuuno4kse-17.1-$(VUUNO4KSE-LIBGLES_VER).r0.tar.gz
VUUNO4KSE-LIBGLES_SITE   = http://archive.vuplus.com/download/build_support/vuplus

# -----------------------------------------------------------------------------

BOXMODEL-LIBGLES_VER    = $($(call UPPERCASE,$(BOXMODEL))-LIBGLES_VER)
BOXMODEL-LIBGLES_TMP    = $($(call UPPERCASE,$(BOXMODEL))-LIBGLES_TMP)
BOXMODEL-LIBGLES_SOURCE = $($(call UPPERCASE,$(BOXMODEL))-LIBGLES_SOURCE)
BOXMODEL-LIBGLES_SITE   = $($(call UPPERCASE,$(BOXMODEL))-LIBGLES_SITE)

ifneq ($(BOXMODEL-LIBGLES_SOURCE),$(EMPTY))
$(ARCHIVE)/$(BOXMODEL-LIBGLES_SOURCE):
	$(DOWNLOAD) $(BOXMODEL-LIBGLES_SITE)/$(BOXMODEL-LIBGLES_SOURCE)
endif

hd51-libgles \
bre2ze4k-libgles \
h7-libgles: $(ARCHIVE)/$(BOXMODEL-LIBGLES_SOURCE) | $(TARGET_DIR)
	unzip -o $(ARCHIVE)/$(BOXMODEL-LIBGLES_SOURCE) -d $(TARGET_LIB_DIR)
	ln -sf libv3ddriver.so $(TARGET_LIB_DIR)/libEGL.so
	ln -sf libv3ddriver.so $(TARGET_LIB_DIR)/libGLESv2.so
	$(TOUCH)

$(ARCHIVE)/$(HD6x-LIBGLES-HEADERS_SOURCE):
	$(DOWNLOAD) $(HD6x-LIBGLES-HEADERS_SITE)/$(HD6x-LIBGLES-HEADERS_SOURCE)

hd6x-libgles-headers: $(ARCHIVE)/$(HD6x-LIBGLES-HEADERS_SOURCE) | $(TARGET_DIR)
	unzip -o $(ARCHIVE)/$(HD6x-LIBGLES-HEADERS_SOURCE) -d $(TARGET_INCLUDE_DIR)
	$(TOUCH)

hd60-libgles \
hd61-libgles: $(ARCHIVE)/$(BOXMODEL-LIBGLES_SOURCE) | $(TARGET_DIR)
	unzip -o $(ARCHIVE)/$(BOXMODEL-LIBGLES_SOURCE) -d $(TARGET_LIB_DIR)
	$(CD) $(TARGET_LIB_DIR); \
		ln -sf libMali.so libmali.so; \
		ln -sf libMali.so libEGL.so.1.4; ln -sf libEGL.so.1.4 libEGL.so.1; ln -sf libEGL.so.1 libEGL.so; \
		ln -sf libMali.so libGLESv1_CM.so.1.1; ln -sf libGLESv1_CM.so.1.1 libGLESv1_CM.so.1; ln -sf libGLESv1_CM.so.1 libGLESv1_CM.so; \
		ln -sf libMali.so libGLESv2.so.2.0; ln -sf libGLESv2.so.2.0 libGLESv2.so.2; ln -sf libGLESv2.so.2 libGLESv2.so; \
		ln -sf libMali.so libgbm.so
	$(REWRITE_PKGCONF_PC)
	$(TOUCH)

vusolo4k-libgles \
vuduo4k-libgles \
vuduo4kse-libgles \
vuultimo4k-libgles \
vuzero4k-libgles \
vuuno4k-libgles \
vuuno4kse-libgles \
vuplus-libgles: $(ARCHIVE)/$(BOXMODEL-LIBGLES_SOURCE) | $(TARGET_DIR)
	$(REMOVE)/$(BOXMODEL-LIBGLES_TMP)
	$(UNTAR)/$(BOXMODEL-LIBGLES_SOURCE)
	$(INSTALL_EXEC) $(BUILD_TMP)/$(BOXMODEL-LIBGLES_TMP)/lib/* $(TARGET_LIB_DIR)
	ln -sf libv3ddriver.so $(TARGET_LIB_DIR)/libEGL.so
	ln -sf libv3ddriver.so $(TARGET_LIB_DIR)/libGLESv2.so
	$(INSTALL_COPY) $(BUILD_TMP)/$(BOXMODEL-LIBGLES_TMP)/include/* $(TARGET_INCLUDE_DIR)
	$(REMOVE)/$(BOXMODEL-LIBGLES_TMP)
	$(TOUCH)

# -----------------------------------------------------------------------------

HD60-LIBS_VER    = 20200622
HD60-LIBS_TMP    = hiplay
HD60-LIBS_SOURCE = hd60-libs-$(HD60-LIBS_VER).zip
HD60-LIBS_SITE   = http://downloads.mutant-digital.net/hd60

HD61-LIBS_VER    = 20200622
HD61-LIBS_TMP    = hiplay
HD61-LIBS_SOURCE = hd61-libs-$(HD61-LIBS_VER).zip
HD61-LIBS_SITE   = http://downloads.mutant-digital.net/hd61

# -----------------------------------------------------------------------------

BOXMODEL-LIBS_VER    = $($(call UPPERCASE,$(BOXMODEL))-LIBS_VER)
BOXMODEL-LIBS_TMP    = $($(call UPPERCASE,$(BOXMODEL))-LIBS_TMP)
BOXMODEL-LIBS_SOURCE = $($(call UPPERCASE,$(BOXMODEL))-LIBS_SOURCE)
BOXMODEL-LIBS_SITE   = $($(call UPPERCASE,$(BOXMODEL))-LIBS_SITE)

ifneq ($(BOXMODEL-LIBS_SOURCE),$(EMPTY))
$(ARCHIVE)/$(BOXMODEL-LIBS_SOURCE):
	$(DOWNLOAD) $(BOXMODEL-LIBS_SITE)/$(BOXMODEL-LIBS_SOURCE)
endif

hd60-libs \
hd61-libs: $(ARCHIVE)/$(BOXMODEL-LIBS_SOURCE) | $(TARGET_DIR)
	$(REMOVE)/$(BOXMODEL-LIBS_TMP)
	unzip -o $(ARCHIVE)/$(BOXMODEL-LIBS_SOURCE) -d $(BUILD_TMP)/$(BOXMODEL-LIBS_TMP)
	mkdir -p $(TARGET_LIB_DIR)/hisilicon
	$(INSTALL_EXEC) $(BUILD_TMP)/$(BOXMODEL-LIBS_TMP)/hisilicon/* $(TARGET_LIB_DIR)/hisilicon
	$(INSTALL_EXEC) $(BUILD_TMP)/$(BOXMODEL-LIBS_TMP)/ffmpeg/* $(TARGET_LIB_DIR)/hisilicon
	ln -sf /lib/ld-linux-armhf.so.3 $(TARGET_LIB_DIR)/hisilicon/ld-linux.so
	$(REMOVE)/$(BOXMODEL-LIBS_TMP)
	$(TOUCH)

# -----------------------------------------------------------------------------

VUSOLO4K-PLATFORM-UTIL_VER    = $(VUSOLO4K-DRIVERS_VER)
VUSOLO4K-PLATFORM-UTIL_TMP    = platform-util-vusolo4k
VUSOLO4K-PLATFORM-UTIL_SOURCE = platform-util-vusolo4k-17.1-$(VUSOLO4K-PLATFORM-UTIL_VER).r0.tar.gz
VUSOLO4K-PLATFORM-UTIL_SITE   = http://archive.vuplus.com/download/build_support/vuplus

VUDUO4K-PLATFORM-UTIL_VER    = $(VUDUO4K-DRIVERS_VER)
VUDUO4K-PLATFORM-UTIL_TMP    = platform-util-vuduo4k
VUDUO4K-PLATFORM-UTIL_SOURCE = platform-util-vuduo4k-18.1-$(VUDUO4K-PLATFORM-UTIL_VER).r0.tar.gz
VUDUO4K-PLATFORM-UTIL_SITE   = http://archive.vuplus.com/download/build_support/vuplus

VUDUO4KSE-PLATFORM-UTIL_VER    = $(VUDUO4KSE-DRIVERS_VER)
VUDUO4KSE-PLATFORM-UTIL_TMP    = platform-util-vuduo4kse
VUDUO4KSE-PLATFORM-UTIL_SOURCE = platform-util-vuduo4kse-17.1-$(VUDUO4KSE-PLATFORM-UTIL_VER).r0.tar.gz
VUDUO4KSE-PLATFORM-UTIL_SITE   = http://archive.vuplus.com/download/build_support/vuplus

VUULTIMO4K-PLATFORM-UTIL_VER    = $(VUULTIMO4K-DRIVERS_VER)
VUULTIMO4K-PLATFORM-UTIL_TMP    = platform-util-vuultimo4k
VUULTIMO4K-PLATFORM-UTIL_SOURCE = platform-util-vuultimo4k-17.1-$(VUULTIMO4K-PLATFORM-UTIL_VER).r0.tar.gz
VUULTIMO4K-PLATFORM-UTIL_SITE   = http://archive.vuplus.com/download/build_support/vuplus

VUZERO4K-PLATFORM-UTIL_VER    = $(VUZERO4K-DRIVERS_VER)
VUZERO4K-PLATFORM-UTIL_TMP    = platform-util-vuzero4k
VUZERO4K-PLATFORM-UTIL_SOURCE = platform-util-vuzero4k-17.1-$(VUZERO4K-PLATFORM-UTIL_VER).r0.tar.gz
VUZERO4K-PLATFORM-UTIL_SITE   = http://archive.vuplus.com/download/build_support/vuplus

VUUNO4K-PLATFORM-UTIL_VER    = $(VUUNO4K-DRIVERS_VER)
VUUNO4K-PLATFORM-UTIL_TMP    = platform-util-vuuno4k
VUUNO4K-PLATFORM-UTIL_SOURCE = platform-util-vuuno4k-17.1-$(VUUNO4K-PLATFORM-UTIL_VER).r0.tar.gz
VUUNO4K-PLATFORM-UTIL_SITE   = http://archive.vuplus.com/download/build_support/vuplus

VUUNO4KSE-PLATFORM-UTIL_VER    = $(VUUNO4KSE-DRIVERS_VER)
VUUNO4KSE-PLATFORM-UTIL_TMP    = platform-util-vuuno4kse
VUUNO4KSE-PLATFORM-UTIL_SOURCE = platform-util-vuuno4kse-17.1-$(VUUNO4KSE-PLATFORM-UTIL_VER).r0.tar.gz
VUUNO4KSE-PLATFORM-UTIL_SITE   = http://archive.vuplus.com/download/build_support/vuplus

# -----------------------------------------------------------------------------

BOXMODEL-PLATFORM-UTIL_VER    = $($(call UPPERCASE,$(BOXMODEL))-PLATFORM-UTIL_VER)
BOXMODEL-PLATFORM-UTIL_TMP    = $($(call UPPERCASE,$(BOXMODEL))-PLATFORM-UTIL_TMP)
BOXMODEL-PLATFORM-UTIL_SOURCE = $($(call UPPERCASE,$(BOXMODEL))-PLATFORM-UTIL_SOURCE)
BOXMODEL-PLATFORM-UTIL_SITE   = $($(call UPPERCASE,$(BOXMODEL))-PLATFORM-UTIL_SITE)

ifneq ($(BOXMODEL-PLATFORM-UTIL_SOURCE),$(EMPTY))
$(ARCHIVE)/$(BOXMODEL-PLATFORM-UTIL_SOURCE):
	$(DOWNLOAD) $(BOXMODEL-PLATFORM-UTIL_SITE)/$(BOXMODEL-PLATFORM-UTIL_SOURCE)
endif

vuplus-platform-util: $(ARCHIVE)/$(BOXMODEL-PLATFORM-UTIL_SOURCE) | $(TARGET_DIR)
	$(REMOVE)/$(BOXMODEL-PLATFORM-UTIL_TMP)
	$(UNTAR)/$(BOXMODEL-PLATFORM-UTIL_SOURCE)
	$(INSTALL_EXEC) -D $(BUILD_TMP)/$(BOXMODEL-PLATFORM-UTIL_TMP)/* $(TARGET_DIR)/usr/bin
	$(INSTALL_EXEC) -D $(TARGET_FILES)/scripts/vuplus-platform-util.init $(TARGET_DIR)/etc/init.d/vuplus-platform-util
ifeq ($(BOXMODEL), $(filter $(BOXMODEL), vuduo4k))
	$(INSTALL_EXEC) -D $(TARGET_FILES)/scripts/bp3flash.sh $(TARGET_DIR)/usr/bin/bp3flash.sh
endif
	$(REMOVE)/$(BOXMODEL-PLATFORM-UTIL_TMP)
	$(TOUCH)
