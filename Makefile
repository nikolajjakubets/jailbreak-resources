ARCHS ?= arm64 arm64e
TARGET ?= iphone:clang:latest
TARGET_CODESIGN = ldid2
include $(THEOS)/makefiles/common.mk

TOOL_NAME = extrainst_ ldid_wrapper
extrainst__FILES = extrainst_.m
extrainst__INSTALL_PATH = /DEBIAN
extrainst__CODESIGN_FLAGS = -Sentitlements.xml
extrainst__CFLAGS = -Wno-deprecated-declarations

ldid_wrapper_FILES = ldid_wrapper.c
ldid_wrapper_CODESIGN_FLAGS = -Sentitlements.xml
ldid_wrapper_INSTALL_PATH = /usr/libexec

DESTDIR = $(THEOS_OBJ_DIR)/ext

MERIDIAN_CC = xcrun -sdk iphoneos gcc -arch arm64 -arch arm64e
MERIDIAN_LDID = ldid2

after-all::
	make -C unrestrict DESTDIR="$(DESTDIR)" install
	make -C MeridianJB/Meridian/pspawn_hook PREFIX=/usr/lib LDID="$(MERIDIAN_LDID)" CC="$(MERIDIAN_CC)" DESTDIR="$(DESTDIR)" install
	make -C libjailbreak PREFIX=/usr/lib LDID="$(MERIDIAN_LDID)" CC="$(MERIDIAN_CC)" DESTDIR="$(DESTDIR)" install
	make -C MeridianJB/Meridian/amfid PREFIX=/usr/lib LDID="$(MERIDIAN_LDID)" CC="$(MERIDIAN_CC)" DESTDIR="$(DESTDIR)" install
	make -C MeridianJB/Meridian/jailbreakd PREFIX=/usr/libexec LDID="$(MERIDIAN_LDID)" CC="$(MERIDIAN_CC)" DESTDIR="$(DESTDIR)" install

after-stage::
	rsync -a $(THEOS_OBJ_DIR)/ext/. $(THEOS_STAGING_DIR)

after-clean::
	make -C MeridianJB/Meridian/pspawn_hook clean
	make -C libjailbreak clean
	make -C MeridianJB/Meridian/amfid clean
	make -C MeridianJB/Meridian/jailbreakd clean

stage::
	cp -a layout/DEBIAN/postinst $(THEOS_STAGING_DIR)/DEBIAN/postinst
	cp -a layout/DEBIAN/prerm $(THEOS_STAGING_DIR)/DEBIAN/prerm

include $(THEOS_MAKE_PATH)/tool.mk
