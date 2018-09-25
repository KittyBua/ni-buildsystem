# makefile for plugins

TARGET_DIR ?= $(DESTDIR)

# workaround make-warnings
T = $(TARGET_DIR)/T
$(T):
	mkdir -p $@
	cd $@ && rm -r T

# Some useful variables
BIN		= $(TARGET_DIR)/bin
ETCINIT		= $(TARGET_DIR)/etc/init.d
LIBPLUG		= $(TARGET_DIR)/lib/tuxbox/plugins
SBIN		= $(TARGET_DIR)/sbin
SHAREICONS	= $(TARGET_DIR)/share/tuxbox/neutrino/icons
SHAREFLEX	= $(TARGET_DIR)/share/tuxbox/neutrino/flex
SHAREPLUG	= $(TARGET_DIR)/share/tuxbox/neutrino/plugins
SHARETHEMES	= $(TARGET_DIR)/share/tuxbox/neutrino/themes
SHAREWEBRADIO	= $(TARGET_DIR)/share/tuxbox/neutrino/webradio
SHAREWEBTV	= $(TARGET_DIR)/share/tuxbox/neutrino/webtv
USRBIN		= $(TARGET_DIR)/usr/bin
VARINIT		= $(TARGET_DIR)/var/etc/init.d
VARPLUG		= $(TARGET_DIR)/var/tuxbox/plugins
VARCONF		= $(TARGET_DIR)/var/tuxbox/config

$(BIN) \
$(ETCINIT) \
$(LIBPLUG) \
$(SBIN) \
$(SHAREICONS) \
$(SHAREFLEX) \
$(SHAREPLUG) \
$(SHARETHEMES) \
$(SHAREWEBRADIO) \
$(SHAREWEBTV) \
$(USRBIN) \
$(VARINIT) \
$(VARPLUG) \
$(VARCONF) : | $(TARGET_DIR)
	mkdir -p $@

init-scripts: \
	init-camd

plugins-all: $(D)/neutrino \
	getrc \
	input \
	logomask \
	msgbox \
	tuxcal \
	tuxcom \
	tuxmail \
	tuxwetter \
	cooliTSclimax \
	emmrd \
	FritzCallMonitor \
	FritzInfoMonitor \
	FritzInfoMonitor_setup \
	vinfo \
	EPGscan \
	pr-auto-timer \
	logo-addon \
	smarthomeinfo \
	mountpointmanagement \
	EPGfilter \
	netzkino \
	mtv \
	autoreboot \
	dropbox_uploader \
	userbouquets \
	add-locale \
	favorites2bin \
	LocalTV \
	webradio \
	webtv \
	neutrino-mediathek \
	openvpn-setup \
	oscammon \
	lcd4linux-all \
	doscam-webif-skin \
	playlists \
	shellexec

plugins-hd1: # nothing to do
plugins-hd2: # nothing to do

plugins-hd51: \
	showiframe

################
### scripts  ###
################

scripts:
	install -m755 $(IMAGEFILES)/scripts/service $(SBIN)

#####################
### init-scripts  ###
#####################

init-camd: $(ETCINIT)
	install -m755 $(IMAGEFILES)/scripts/camd.init $(ETCINIT)/camd && \
	install -m755 $(IMAGEFILES)/scripts/camd_datefix.init $(ETCINIT)/camd_datefix
	cd $(ETCINIT) && \
	ln -sf camd S99camd && \
	ln -sf camd K01camd

################
### plugins  ###
################

channellogos: $(SOURCE_DIR)/$(NI_LOGO-STUFF) $(SHAREICONS)
	rm -rf $(SHAREICONS)/logo
	mkdir -p $(SHAREICONS)/logo
	install -m644 $(SOURCE_DIR)/$(NI_LOGO-STUFF)/logos/* $(SHAREICONS)/logo
	pushd $(SOURCE_DIR)/$(NI_LOGO-STUFF)/ && \
	./logo_linker.sh complete.db $(SHAREICONS)/logo

lcd4linux-all: $(D)/lcd4linux | $(TARGET_DIR)
	cp -a $(IMAGEFILES)/lcd4linux/* $(TARGET_DIR)/

emmrd: $(SHAREICONS) $(BIN)/emmrd
$(BIN)/emmrd: $(BIN) $(VARCONF) $(ETCINIT)
	pushd $(SOURCES)/emmrd && \
	$(TARGET)-g++ -Wall $(TARGET_CFLAGS) $(TARGET_LDFLAGS) $(CORTEX-STRINGS) -o $@ emmremind.cpp  && \
	install -m755 emmrd.init $(ETCINIT)/emmrd && \
	install -m644 hint_emmrd.png $(SHAREICONS)/
	cd $(ETCINIT) && \
	ln -sf emmrd S99emmrd && \
	ln -sf emmrd K01emmrd

FritzCallMonitor: $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS) $(BIN)/FritzCallMonitor
$(BIN)/FritzCallMonitor: $(D)/openssl $(D)/libcurl $(BIN) $(VARCONF) $(ETCINIT) $(SHAREICONS)
	pushd $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/FritzCallMonitor && \
	$(TARGET)-gcc -Wall $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		\
		-lstdc++ -lcrypto -pthread -lcurl \
		\
		connect.cpp \
		FritzCallMonitor.cpp \
		\
		-o $@ && \
	install -m644 FritzCallMonitor.addr $(VARCONF)/ && \
	install -m644 FritzCallMonitor.cfg $(VARCONF)/ && \
	install -m755 fritzcallmonitor.init $(ETCINIT)/fritzcallmonitor && \
	install -m644 hint_FritzCallMonitor.png $(SHAREICONS)/
	cd $(ETCINIT) && \
	ln -sf fritzcallmonitor S99fritzcallmonitor && \
	ln -sf fritzcallmonitor K01fritzcallmonitor

FritzInfoMonitor: $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS) $(LIBPLUG)/FritzInfoMonitor.so
$(LIBPLUG)/FritzInfoMonitor.so: $(D)/freetype $(D)/openssl $(D)/libcurl $(LIBPLUG)
	pushd $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/FritzInfoMonitor && \
	$(TARGET)-gcc -Wall $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		-I$(N_OBJDIR) -I$(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/include \
		-I$(TARGET_INCLUDE_DIR)/freetype2 \
		\
		-lfreetype -lz -lstdc++ -lcrypto -lcurl \
		\
		connect.cpp \
		framebuffer.cpp \
		FritzInfoMonitor.cpp \
		icons.cpp \
		parser.cpp \
		phonebook.cpp \
		rc.cpp \
		submenu.cpp \
		\
		-o $@ && \
	install -m644 FritzInfoMonitor.cfg $(LIBPLUG)/ && \
	install -m644 FritzInfoMonitor_hint.png $(LIBPLUG)/

FritzInfoMonitor_setup: $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS) $(LIBPLUG)
	install -m755 $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/FritzInfoMonitor/FritzInfoMonitor_setup.lua $(LIBPLUG)/
	install -m644 $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/FritzInfoMonitor/FritzInfoMonitor_setup.cfg $(LIBPLUG)/
	install -m644 $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/FritzInfoMonitor/FritzInfoMonitor_setup_hint.png $(LIBPLUG)/

vinfo: $(BIN)/vinfo
$(BIN)/vinfo: $(BIN)
	pushd $(SOURCES)/vinfo && \
	$(TARGET)-gcc $(TARGET_CFLAGS) -o $@ vinfo.c md5.c

EPGscan: $(LIBPLUG) $(VARCONF)
	install -m755 $(SOURCES)/EPGscan/*.sh $(LIBPLUG)/
	install -m755 $(SOURCES)/EPGscan/*.lua $(LIBPLUG)/
	install -m644 $(SOURCES)/EPGscan/*.cfg $(LIBPLUG)/
	install -m644 $(SOURCES)/EPGscan/*_hint.png $(LIBPLUG)/
	install -m644 $(SOURCES)/EPGscan/*.conf $(VARCONF)/

pr-auto-timer: $(LIBPLUG) $(VARCONF)
	install -m755 $(SOURCES)/pr-auto-timer/auto-record-cleaner $(LIBPLUG)/
	install -m644 $(SOURCES)/pr-auto-timer/auto-record-cleaner.conf.template $(VARCONF)/auto-record-cleaner.conf
	install -m644 $(SOURCES)/pr-auto-timer/auto-record-cleaner.rules.template $(VARCONF)/auto-record-cleaner.rules
	install -m755 $(SOURCES)/pr-auto-timer/pr-auto-timer.sh $(LIBPLUG)/
	install -m644 $(SOURCES)/pr-auto-timer/pr-auto-timer.cfg $(LIBPLUG)/
	install -m755 $(SOURCES)/pr-auto-timer/pr-auto-timer $(LIBPLUG)/
	install -m644 $(SOURCES)/pr-auto-timer/pr-auto-timer_hint.png $(LIBPLUG)/
	install -m644 $(SOURCES)/pr-auto-timer/pr-auto-timer.conf.template $(VARCONF)/pr-auto-timer.conf
	install -m644 $(SOURCES)/pr-auto-timer/pr-auto-timer.rules.template $(VARCONF)/pr-auto-timer.rules

autoreboot: $(LIBPLUG)
	install -m755 $(SOURCES)/$@/*.sh $(LIBPLUG)/
	install -m644 $(SOURCES)/$@/*.cfg $(LIBPLUG)/

logo-addon: $(SOURCE_DIR)/$(NI_LOGO-STUFF) $(LIBPLUG)
	install -m755 $(SOURCE_DIR)/$(NI_LOGO-STUFF)/logo-addon/*.sh $(LIBPLUG)/
	install -m644 $(SOURCE_DIR)/$(NI_LOGO-STUFF)/logo-addon/*.cfg $(LIBPLUG)/
	install -m644 $(SOURCE_DIR)/$(NI_LOGO-STUFF)/logo-addon/*.png $(LIBPLUG)/

smarthomeinfo: $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS) $(LIBPLUG) $(VARCONF)
	cp -a $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/$@/plugin/tuxbox/plugins/* $(LIBPLUG)/
	cp -a $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/$@/plugin/tuxbox/config/* $(VARCONF)/

doscam-webif-skin: $(VARCONF)
	mkdir -p $(TARGET_DIR)/share/doscam/tpl/
	install -m644 $(SOURCES)/doscam-webif-skin/*.tpl $(TARGET_DIR)/share/doscam/tpl/
	mkdir -p $(TARGET_DIR)/share/doscam/skin/
	install -m644 $(SOURCES)/doscam-webif-skin/doscam_ni-dark.css $(TARGET_DIR)/share/doscam/skin

playlists:
	mkdir -p $(TARGET_DIR)/share/playlists/
	cp -a $(IMAGEFILES)/playlists/* $(TARGET_DIR)/share/playlists/

mountpointmanagement: $(LIBPLUG)
	install -m755 $(SOURCES)/mountpointmanagement/*.sh $(LIBPLUG)/
	install -m755 $(SOURCES)/mountpointmanagement/*.so $(LIBPLUG)/
	install -m644 $(SOURCES)/mountpointmanagement/*.cfg $(LIBPLUG)/

EPGfilter: $(LIBPLUG)
	install -m755 $(SOURCES)/EPGfilter/*.sri $(LIBPLUG)/
	install -m755 $(SOURCES)/EPGfilter/*.lua $(LIBPLUG)/
	install -m644 $(SOURCES)/EPGfilter/*.cfg $(LIBPLUG)/
	install -m644 $(SOURCES)/EPGfilter/*.png $(LIBPLUG)/

dropbox_uploader: $(USRBIN)
	install -m755 $(SOURCES)/$@/*.sh $(USRBIN)/

openvpn-setup: $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS) $(LIBPLUG) $(ETCINIT)
	cp -a $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/scripts-lua/plugins/$@/$@* $(LIBPLUG)/
	install -m755 $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/scripts-lua/plugins/$@/ovpn.init $(ETCINIT)/ovpn

neutrino-mediathek: $(LIBPLUG)
	$(REMOVE)/$@
	git clone https://github.com/neutrino-mediathek/mediathek.git $(BUILD_TMP)/$@
	$(CHDIR)/$@; \
		cp -a plugins/* $(LIBPLUG)/; \
		cp -a share $(TARGET_DIR)
	$(REMOVE)/$@

#scripts-lua
add-locale \
LocalTV \
userbouquets \
stb-startup \
netzkino \
mtv \
favorites2bin: $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS) $(LIBPLUG)
	install -m755 $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/scripts-lua/plugins/$@/* $(LIBPLUG)/

webradio: $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS) $(SHAREWEBRADIO)
	install -m755 $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/scripts-lua/plugins/webradio/* $(SHAREWEBRADIO)/

webtv: $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS) $(SHAREWEBTV)
	install -m755 $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/scripts-lua/plugins/webtv/* $(SHAREWEBTV)/

#getrc
getrc: $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS) $(BIN)/getrc
$(BIN)/getrc: $(BIN)
	pushd $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/getrc && \
	$(TARGET)-gcc $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		-I$(N_OBJDIR) -I$(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/include \
		\
		getrc.c \
		io.c \
		\
		-o $@

#input
input: $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS) $(BIN)/input
$(BIN)/input: $(D)/freetype $(BIN)
	pushd $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/input && \
	$(TARGET)-gcc $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		-I$(N_OBJDIR) -I$(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/include \
		-I$(TARGET_INCLUDE_DIR)/freetype2 \
		\
		-lfreetype -lz -lpng \
		\
		fb_display.c \
		gfx.c \
		input.c \
		inputd.c \
		io.c \
		png_helper.cpp \
		pngw.cpp \
		resize.c \
		text.c \
		\
		-o $@

#logomask
logomask: $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS) $(BIN)/logomask $(LIBPLUG)/logoset.so $(LIBPLUG)/logomask.so
$(BIN)/logomask: $(BIN)
	pushd $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/logomask && \
	$(TARGET)-gcc $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		-I$(N_OBJDIR) -I$(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/include \
		\
		gfx.c \
		logomask.c \
		\
		-o $@ && \
	install -m755 logomask.sh $(BIN)/
 
$(LIBPLUG)/logoset.so: $(D)/freetype $(LIBPLUG)
	pushd $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/logomask && \
	$(TARGET)-gcc $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		-I$(N_OBJDIR) -I$(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/include \
		-I$(TARGET_INCLUDE_DIR)/freetype2 \
		\
		-lfreetype -lz \
		\
		gfx.c \
		io.c \
		logoset.c \
		text.c \
		\
		-o $@ && \
	install -m644 logoset.cfg $(LIBPLUG)/ && \
	install -m644 logoset_hint.png $(LIBPLUG)/

$(LIBPLUG)/logomask.so: $(LIBPLUG) $(BIN)
	pushd $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/logomask && \
	$(TARGET)-gcc $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		-I$(N_OBJDIR) -I$(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/include \
		\
		starter_logomask.c \
		\
		-o $@ && \
	install -m644 logomask.cfg $(LIBPLUG)/ && \
	install -m644 logomask_hint.png $(LIBPLUG)/

#msgbox
msgbox: $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS) $(BIN)/msgbox
$(BIN)/msgbox: $(D)/freetype $(BIN)
	pushd $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/msgbox && \
	$(TARGET)-gcc $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		-I$(N_OBJDIR) -I$(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/include \
		-I$(TARGET_INCLUDE_DIR)/freetype2 \
		\
		-lfreetype -lz -lpng \
		\
		fb_display.c \
		gfx.c \
		io.c \
		msgbox.c \
		png_helper.cpp \
		pngw.cpp \
		resize.c \
		text.c \
		txtform.c \
		\
		-o $@

#tuxcal
tuxcal: $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS) $(BIN)/tuxcald $(LIBPLUG)/tuxcal.so
$(BIN)/tuxcald: $(D)/freetype $(BIN) $(ETCINIT) $(VARCONF)
	pushd $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/tuxcal/daemon && \
	$(TARGET)-gcc $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		-I$(N_OBJDIR) -I$(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/include \
		-I$(TARGET_INCLUDE_DIR)/freetype2 \
		\
		-lfreetype -lz -lpthread \
		\
		tuxcald.c \
		\
		-o $@ && \
	install -m755 $(IMAGEFILES)/scripts/tuxcald.init $(ETCINIT)/tuxcald && \
	cd $(ETCINIT) && \
	ln -sf tuxcald S99tuxcald && \
	ln -sf tuxcald K01tuxcald && \
	pushd $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/tuxcal && \
	mkdir -p $(VARCONF)/tuxcal && \
	install -m644 tuxcal.conf $(VARCONF)/tuxcal/

$(LIBPLUG)/tuxcal.so: $(LIBPLUG)
	pushd $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/tuxcal && \
	$(TARGET)-gcc $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		-I$(N_OBJDIR) -I$(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/include \
		-I$(TARGET_INCLUDE_DIR)/freetype2 \
		\
		-lfreetype -lz \
		\
		tuxcal.c \
		\
		-o $@ && \
	install -m644 tuxcal.cfg $(LIBPLUG)/ && \
	install -m644 tuxcal_hint.png $(LIBPLUG)/

#tuxcom
tuxcom: $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS) $(LIBPLUG)/tuxcom.so
$(LIBPLUG)/tuxcom.so: $(D)/freetype $(LIBPLUG)
	pushd $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/tuxcom && \
	$(TARGET)-gcc $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		-I$(N_OBJDIR) -I$(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/include \
		-I$(TARGET_INCLUDE_DIR)/freetype2 \
		\
		-lfreetype -lz \
		\
		tuxcom.c \
		\
		-o $@ && \
	install -m644 tuxcom.cfg $(LIBPLUG)/ && \
	install -m644 tuxcom_hint.png $(LIBPLUG)/

#tuxmail
tuxmail: $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS) $(BIN)/tuxmaild $(LIBPLUG)/tuxmail.so
$(BIN)/tuxmaild: $(D)/freetype $(D)/openssl $(BIN) $(ETCINIT) $(VARCONF)
	pushd $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/tuxmail/daemon && \
	$(TARGET)-gcc $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		-I$(N_OBJDIR) -I$(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/include \
		-I$(TARGET_INCLUDE_DIR)/freetype2 \
		\
		-lfreetype -lz -lcrypto -lssl -lpthread \
		\
		tuxmaild.c \
		\
		-o $@ && \
	install -m755 $(IMAGEFILES)/scripts/tuxmaild.init $(ETCINIT)/tuxmaild && \
	cd $(ETCINIT) && \
	ln -sf tuxmaild S99tuxmaild && \
	ln -sf tuxmaild K01tuxmaild && \
	pushd $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/tuxmail && \
	mkdir -p $(VARCONF)/tuxmail && \
	install -m644 tuxmail.conf $(VARCONF)/tuxmail/ && \
	pushd $(IMAGEFILES)/scripts && \
	install -m755 tuxmail.onreadmail $(VARCONF)/tuxmail/

$(LIBPLUG)/tuxmail.so: $(LIBPLUG)
	pushd $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/tuxmail && \
	$(TARGET)-gcc $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		-I$(N_OBJDIR) -I$(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/include \
		-I$(TARGET_INCLUDE_DIR)/freetype2 \
		\
		-lfreetype -lz \
		\
		tuxmail.c \
		\
		-o $@ && \
	install -m644 tuxmail.cfg $(LIBPLUG)/ && \
	install -m644 tuxmail_hint.png $(LIBPLUG)/

#tuxwetter
tuxwetter: $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS) $(LIBPLUG)/tuxwetter.so
$(LIBPLUG)/tuxwetter.so: $(D)/freetype $(D)/libcurl $(D)/giflib $(D)/libjpeg $(LIBPLUG) $(VARCONF)
	pushd $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/tuxwetter && \
	$(TARGET)-gcc $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		-I$(N_OBJDIR) -I$(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/include \
		-I$(TARGET_INCLUDE_DIR)/freetype2 \
		\
		-lfreetype -lz -lcrypto -lssl -lcurl -ljpeg -lpng -lgif \
		\
		-DWWEATHER \
		\
		fb_display.c \
		gfx.c \
		gif.c \
		gifdecomp.c \
		http.c \
		io.c \
		jpeg.c \
		parser.c \
		php.c \
		png_helper.cpp \
		pngw.cpp \
		resize.c \
		text.c \
		tuxwetter.c \
		\
		-o $@; \
	mkdir -p $(VARCONF)/tuxwetter/ && \
	install -m644 tuxwetter.mcfg $(VARCONF)/tuxwetter/ && \
	key=4cf30427c97b3bc5; \
	sed -i "s|^LicenseKey=.*|LicenseKey=$$key|" $(VARCONF)/tuxwetter/tuxwetter.mcfg && \
	install -m644 tuxwetter.conf $(VARCONF)/tuxwetter/ && \
	install -m644 tuxwetter.png $(VARCONF)/tuxwetter/ && \
	install -m644 convert.list $(VARCONF)/tuxwetter/ && \
	install -m644 tuxwetter.cfg $(LIBPLUG)/ && \
	install -m644 tuxwetter_hint.png $(LIBPLUG)/ && \
	ln -sf /lib/tuxbox/plugins/tuxwetter.so $(BIN)/tuxwetter

#cooliTSclimax
cooliTSclimax: $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS) $(BIN)/cooliTSclimax
$(BIN)/cooliTSclimax: $(D)/ffmpeg $(BIN)
	pushd $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/cooliTSclimax && \
	$(TARGET)-g++ $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		-lpthread -lavformat -lavcodec -lavutil \
		\
		-D__STDC_CONSTANT_MACROS \
		\
		cooliTSclimax.cpp \
		\
		-o $@

# oscammon
oscammon: $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS) $(D)/zlib $(D)/freetype $(D)/openssl $(LIBPLUG)/oscammon.so
$(LIBPLUG)/oscammon.so: $(LIBPLUG) $(VARCONF)
	pushd $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/oscammon && \
	$(TARGET)-gcc $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		-I$(N_OBJDIR) -I$(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/include \
		-I$(TARGET_INCLUDE_DIR)/freetype2 \
		\
		-lfreetype -lz -lcrypto \
		\
		oscammon.c \
		\
		-o $@ && \
	cp -f oscammon.conf $(VARCONF)/ && \
	cp -f oscammon.cfg $(LIBPLUG)/ && \
	cp -f oscammon_hint.png $(LIBPLUG)/

# showiframe
showiframe: $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS) $(BIN)/showiframe
$(BIN)/showiframe: $(BIN)
	pushd $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/showiframe && \
	$(TARGET)-gcc $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		\
		showiframe.c \
		\
		-o $@ && \
	install -m755 showiframe.sh $(BIN)/

# shellexec
shellexec: $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS) $(LIBPLUG)/shellexec.so
$(LIBPLUG)/shellexec.so: $(D)/freetype $(LIBPLUG) $(SHAREFLEX) $(VARCONF) $(BIN)
	pushd $(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/shellexec; \
	$(TARGET)-gcc $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		-I$(N_OBJDIR) -I$(SOURCE_DIR)/$(NI_NEUTRINO-PLUGINS)/include \
		-I$(TARGET_INCLUDE_DIR)/freetype2 \
		\
		-lfreetype -lz -lpng \
		\
		fb_display.c \
		gfx.c \
		io.c \
		png_helper.cpp \
		pngw.cpp \
		resize.c \
		shellexec.c \
		text.c \
		\
		-o $@ && \
	install -m644 shellexec.conf $(VARCONF)/ && \
	install -m644 shellexec.cfg $(LIBPLUG)/ && \
	install -m644 shellexec_hint.png $(LIBPLUG)/ && \
	install -m644 flex_plugins.conf $(SHAREFLEX)/ && \
	install -m644 flex_user.conf $(SHAREFLEX)/
	mv -f $(LIBPLUG)/shellexec.so  $(LIBPLUG)/00_shellexec.so
	mv -f $(LIBPLUG)/shellexec.cfg $(LIBPLUG)/00_shellexec.cfg
	mv -f $(LIBPLUG)/shellexec_hint.png $(LIBPLUG)/00_shellexec_hint.png
	ln -sf /lib/tuxbox/plugins/00_shellexec.so $(BIN)/shellexec
