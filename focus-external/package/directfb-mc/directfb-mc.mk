################################################################################
#
# directfb
#
################################################################################

DIRECTFB_MC_VERSION_MAJOR = 1.7
DIRECTFB_MC_VERSION = $(DIRECTFB_MC_VERSION_MAJOR).7
DIRECTFB_MC_SITE = http://www.directfb.org/downloads/Core/DirectFB-$(DIRECTFB_MC_VERSION_MAJOR)
DIRECTFB_MC_SOURCE = DirectFB-$(DIRECTFB_MC_VERSION).tar.gz
DIRECTFB_MC_LICENSE = LGPL-2.1+
DIRECTFB_MC_LICENSE_FILES = COPYING
DIRECTFB_MC_INSTALL_STAGING = YES
DIRECTFB_MC_AUTORECONF = YES

DIRECTFB_MC_CONF_ENV += EGL_LIBS="-lEGL -lGLESv2 -lbcm_host -lvchostif -L$(STAGING_DIR)/usr/lib"
DIRECTFB_MC_CONF_ENV += EGL_CFLAGS="-I$(STAGING_DIR)/usr/include/ -I$(STAGING_DIR)/usr/include/interface/vcos/pthreads/ -I$(STAGING_DIR)/usr/include/interface/vmcs_host/linux"

DIRECTFB_MC_CONF_OPTS = \
	--enable-zlib \
	--enable-freetype \
	--enable-fbdev \
	--disable-sdl \
	--disable-vnc \
	--disable-osx \
	--disable-video4linux \
	--disable-video4linux2 \
	--without-tools \
	--disable-x11

ifeq ($(BR2_STATIC_LIBS),y)
DIRECTFB_MC_CONF_OPTS += --disable-dynload
endif

DIRECTFB_MC_CONFIG_SCRIPTS = directfb-config

DIRECTFB_MC_DEPENDENCIES = freetype zlib

ifeq ($(BR2_PACKAGE_DIRECTFB_MC_MULTI),y)
DIRECTFB_MC_CONF_OPTS += --enable-multi --enable-multi-kernel
DIRECTFB_MC_DEPENDENCIES += linux-fusion
else
DIRECTFB_MC_CONF_OPTS += --disable-multi --disable-multi-kernel
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_MC_DEBUG_SUPPORT),y)
DIRECTFB_MC_CONF_OPTS += --enable-debug-support
ifeq ($(BR2_PACKAGE_DIRECTFB_MC_DEBUG),y)
DIRECTFB_MC_CONF_OPTS += --enable-debug
endif
else
DIRECTFB_MC_CONF_OPTS += --disable-debug-support
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_MC_TRACE),y)
DIRECTFB_MC_CONF_OPTS += --enable-trace
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_MC_DIVINE),y)
DIRECTFB_MC_CONF_OPTS += --enable-divine
else
DIRECTFB_MC_CONF_OPTS += --disable-divine
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_MC_SAWMAN),y)
DIRECTFB_MC_CONF_OPTS += --enable-sawman
else
DIRECTFB_MC_CONF_OPTS += --disable-sawman
endif

DIRECTFB_MC_GFX = \
	$(if $(BR2_PACKAGE_DIRECTFB_MC_ATI128),ati128) \
	$(if $(BR2_PACKAGE_DIRECTFB_MC_CYBER5K),cyber5k) \
	$(if $(BR2_PACKAGE_DIRECTFB_MC_MATROX),matrox) \
	$(if $(BR2_PACKAGE_DIRECTFB_MC_PXA3XX),pxa3xx) \
	$(if $(BR2_PACKAGE_DIRECTFB_MC_I830),i830) \
	$(if $(BR2_PACKAGE_DIRECTFB_MC_EP9X),ep9x) \
	$(if $(BR2_PACKAGE_DIRECTFB_MC_GLES2),gles2)

ifeq ($(strip $(DIRECTFB_MC_GFX)),)
DIRECTFB_MC_CONF_OPTS += --with-gfxdrivers=none
else
DIRECTFB_MC_CONF_OPTS += \
	--with-gfxdrivers=$(subst $(space),$(comma),$(strip $(DIRECTFB_MC_GFX))) --enable-egl
endif

DIRECTFB_MC_INPUT = \
	$(if $(BR2_PACKAGE_DIRECTFB_MC_LINUXINPUT),linuxinput) \
	$(if $(BR2_PACKAGE_DIRECTFB_MC_KEYBOARD),keyboard) \
	$(if $(BR2_PACKAGE_DIRECTFB_MC_PS2MOUSE),ps2mouse) \
	$(if $(BR2_PACKAGE_DIRECTFB_MC_SERIALMOUSE),serialmouse) \
	$(if $(BR2_PACKAGE_DIRECTFB_MC_TSLIB),tslib) \
	$(if $(BR2_PACKAGE_LIRC_TOOLS),lirc)

ifeq ($(BR2_PACKAGE_DIRECTFB_MC_TSLIB),y)
DIRECTFB_MC_DEPENDENCIES += tslib
endif

ifeq ($(strip $(DIRECTFB_MC_INPUT)),)
DIRECTFB_MC_CONF_OPTS += --with-inputdrivers=none
else
DIRECTFB_MC_CONF_OPTS += \
	--with-inputdrivers=$(subst $(space),$(comma),$(strip $(DIRECTFB_MC_INPUT)))
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_MC_GIF),y)
DIRECTFB_MC_CONF_OPTS += --enable-gif
else
DIRECTFB_MC_CONF_OPTS += --disable-gif
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_MC_TIFF),y)
DIRECTFB_MC_CONF_OPTS += --enable-tiff
DIRECTFB_MC_DEPENDENCIES += tiff
else
DIRECTFB_MC_CONF_OPTS += --disable-tiff
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_MC_PNG),y)
DIRECTFB_MC_CONF_OPTS += --enable-png
DIRECTFB_MC_DEPENDENCIES += libpng
DIRECTFB_MC_CONF_ENV += ac_cv_path_LIBPNG_CONFIG=$(STAGING_DIR)/usr/bin/libpng-config
else
DIRECTFB_MC_CONF_OPTS += --disable-png
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_MC_JPEG),y)
DIRECTFB_MC_CONF_OPTS += --enable-jpeg
DIRECTFB_MC_DEPENDENCIES += jpeg
else
DIRECTFB_MC_CONF_OPTS += --disable-jpeg
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_MC_SVG),y)
DIRECTFB_MC_CONF_OPTS += --enable-svg
# needs some help to find cairo includes
DIRECTFB_MC_CONF_ENV += CPPFLAGS="$(TARGET_CPPFLAGS) -I$(STAGING_DIR)/usr/include/cairo"
DIRECTFB_MC_DEPENDENCIES += libsvg-cairo
else
DIRECTFB_MC_CONF_OPTS += --disable-svg
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_MC_IMLIB2),y)
DIRECTFB_MC_CONF_OPTS += --enable-imlib2
DIRECTFB_MC_DEPENDENCIES += imlib2
DIRECTFB_MC_CONF_ENV += ac_cv_path_IMLIB2_CONFIG=$(STAGING_DIR)/usr/bin/imlib2-config
else
DIRECTFB_MC_CONF_OPTS += --disable-imlib2
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_MC_DITHER_RGB16),y)
DIRECTFB_MC_CONF_OPTS += --with-dither-rgb16=advanced
else
DIRECTFB_MC_CONF_OPTS += --with-dither-rgb16=none
endif

ifeq ($(BR2_PACKAGE_DIRECTFB_MC_TESTS),y)
DIRECTFB_MC_CONF_OPTS += --with-tests
endif

HOST_DIRECTFB_MC_DEPENDENCIES = host-pkgconf host-libpng
HOST_DIRECTFB_MC_CONF_OPTS = \
	--disable-multi \
	--enable-png \
	--with-gfxdrivers=none \
	--with-inputdrivers=none

HOST_DIRECTFB_MC_BUILD_CMDS = \
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)/tools directfb-csource

HOST_DIRECTFB_MC_INSTALL_CMDS = \
	$(INSTALL) -m 0755 $(@D)/tools/directfb-csource $(HOST_DIR)/bin

$(eval $(autotools-package))
$(eval $(host-autotools-package))

# directfb-csource for the host
DIRECTFB_MC_HOST_BINARY = $(HOST_DIR)/bin/directfb-csource
