ARCHS ?= arm64
TARGET ?= iphone:clang:latest
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

after-all::
	make -C unrestrict DESTDIR="$(DESTDIR)" install

after-stage::
	rsync -a $(THEOS_OBJ_DIR)/ext/. $(THEOS_STAGING_DIR)

after-clean::
	make -C unrestrict clean

stage::
	cp -a layout/DEBIAN/postinst $(THEOS_STAGING_DIR)/DEBIAN/postinst
	cp -a layout/DEBIAN/prerm $(THEOS_STAGING_DIR)/DEBIAN/prerm

include $(THEOS_MAKE_PATH)/tool.mk
