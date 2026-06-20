THEOS_PACKAGE_SCHEME = rootless
THEOS_PACKAGE_INSTALL_PREFIX = /var/jb
TARGET = iphone:clang:latest:16.5:15.6
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = HackTool
HackTool_FILES = $(shell find . -name "*.swift")
HackTool_CODESIGN_FLAGS = -Sentitlements.plist

HackTool_LDFLAGS = -Xlinker -rpath -Xlinker /var/jb/usr/lib/swift -Xlinker -rpath -Xlinker /var/jb/usr/lib

include $(THEOS_MAKE_PATH)/application.mk
