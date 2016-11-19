######################################
#
# sonoptik-utilities
#
######################################

SONO_VERSION = cc26bf91d24e2da634c1426f6a02ce88ee4b4757
SONO_SITE = $(call github,sonoptik,sono,$(SONO_VERSION))
SONO_BUNDLES = zzz.lv2

SONO_TARGET_MAKE = $(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) NOOPT=true -C $(@D)

# needed for git submodules
define SONO_EXTRACT_CMDS
	rm -rf $(@D)
	git clone --recursive git://github.com/sonoptik/sono $(@D)
	(cd $(@D) && \
		git reset --hard $(SONO_VERSION) && \
		git submodule update)
	touch $(@D)/.stamp_downloaded
endef


define SONO_BUILD_CMDS
	$(SONO_TARGET_MAKE)
endef

define SONO_INSTALL_TARGET_CMDS
	$(SONO_TARGET_MAKE) install DESTDIR=$(TARGET_DIR) INSTALL_PATH=/usr/lib/lv2
	cp -rL $($(PKG)_PKGDIR)/zzz.lv2/*            $(TARGET_DIR)/usr/lib/lv2/zzz.lv2/

endef

$(eval $(generic-package))
