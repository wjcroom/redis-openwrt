include $(TOPDIR)/rules.mk

PKG_NAME:=redis
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk


define Package/redis
	SECTION:=utils
	CATEGORY:=Utilities
	TITLE:=redis
	DEPENDS:=+libpthread
	DEPENDS:=+libatomic
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Build/Compile

	$(MAKE) -C $(PKG_BUILD_DIR)    $(TARGET_CONFIGURE_OPTS)  CC="mips-openwrt-linux-musl-gcc  -latomic "   CFLAGS="$(TARGET_CFLAGS)  -I$(LINUX_DIR)/include" MALLOC=libc 

endef

define Package/redis/install
	$(INSTALL_DIR) $(1)/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/redis-server  $(1)/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/redis-cli  $(1)/bin/


endef

$(eval $(call BuildPackage,redis))
