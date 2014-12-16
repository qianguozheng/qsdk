#
# Copyright (c) 2013 Qualcomm Atheros, Inc..
#
# All Rights Reserved.
# Qualcomm Atheros Confidential and Proprietary.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=qca-legacy-uboot
PKG_VERSION:=10.1.389
PKG_RELEASE:=1

PKG_SOURCE:=u-boot-2006-04-06-1725.tar.bz2
PKG_SOURCE_URL:=ftp://ftp.denx.de/pub/u-boot/OLD
PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)-$(BUILD_VARIANT)/$(PKG_SOURCE:.tar.bz2=)

PKG_MD5SUM:=a54a91fc21854bffd927975579f77fdb

include $(INCLUDE_DIR)/package-version-override.mk
include $(INCLUDE_DIR)/package.mk

define qca-legacy-uboot/Default
  TITLE:=
  CONFIG:=
  IMAGE:=
endef

define qca-legacy-uboot/template
define qca-legacy-uboot/$(1)
  TITLE:=U-boot for the board $(1)
  DEPENDS:=@TARGET_ar71xx
endef
endef

UBOOTS:=ap121 ap135 ap136 db12x cus227

define Package/qca-legacy-uboot/template
define Package/qca-legacy-uboot-$(1)
  SECTION:=boot
  CATEGORY:=Boot Loaders
  TITLE:=$(2)
  DEPENDS:=$(3)
  URL:=http://www.denx.de/wiki/U-Boot
  VARIANT:=$(1)
endef
endef

define BuildQcaLegacyUbootPackage
	$(eval $(qca-legacy-uboot/Default))
	$(eval $(qca-legacy-uboot/$(1)))
	$(call Package/qca-legacy-uboot/template,$(1),$(TITLE),$(DEPENDS))
endef

UBOOT_MAKE_OPTS:= \
    LZMA=$(STAGING_DIR_HOST)/bin/lzma \
    ARCH=mips \
    CPU=mips \
    CROSS_COMPILE=$(TARGET_CROSS)

ifdef BUILD_VARIANT
UBOOT_CONFIG:=$(patsubst UBOOT_CONFIG_TARGET=%,%,\
        $(filter UBOOT_CONFIG_TARGET%,\
            $(shell cat ./configs/$(BUILD_VARIANT)-$(BOARD)$(if $(SUBTARGET),_$(SUBTARGET)).mk)))
UBOOT_IMAGE:=$(if $(IMAGE),$(IMAGE),openwrt-$(BOARD)-$(BUILD_VARIANT)-qca-legacy-uboot.bin)
UBOOT_MAKE_OPTS+=$(patsubst MAKEOPTS_%,%,\
        $(filter MAKEOPTS_%,\
            $(shell cat ./configs/$(BUILD_VARIANT)-$(BOARD)$(if $(SUBTARGET),_$(SUBTARGET)).mk)))
endif


define Build/Prepare
	$(call Build/Prepare/Default)
endef

define Build/Configure
	($(foreach var,$(strip $(UBOOT_MAKE_OPTS)), export $(var);) \
		$(MAKE) -C $(PKG_BUILD_DIR) mrproper);
	($(foreach var,$(strip $(UBOOT_MAKE_OPTS)), export $(var);) \
		$(MAKE) -C $(PKG_BUILD_DIR) $(UBOOT_CONFIG)_config \
			BUILDVERSION=$(PKG_VERSION)-$(PKG_RELEASE));
endef

define Build/Compile
	($(foreach var,$(strip $(UBOOT_MAKE_OPTS)), export $(var);) \
		$(MAKE) -C $(PKG_BUILD_DIR) all);
endef

define Build/InstallDev
	$(CP) $(PKG_BUILD_DIR)/u-boot.bin $(BIN_DIR)/$(UBOOT_IMAGE)
endef

define Package/qca-legacy-uboot/config/template
define Package/qca-legacy-uboot-$(1)/config
  $(call Package/$(PKG_NAME)-$$(1)/override_version,$(PKG_NAME)-$$(1))
  $(call Package/$(PKG_NAME)-$$(1)/override_source_path,$(PKG_NAME)-$$(1))
endef
endef

define Package/qca-legacy-uboot/install/template
define Package/qca-legacy-uboot-$(1)/install
  true
endef
endef

$(foreach u,$(UBOOTS), \
	$(eval $(call qca-legacy-uboot/template,$(u))) \
	$(eval $(call Package/qca-legacy-uboot/install/template,$(u))) \
	$(eval $(call Package/qca-legacy-uboot/config/template,$(u))) \
	$(eval $(call BuildQcaLegacyUbootPackage,$(u))) \
	$(eval $(call BuildPackage,qca-legacy-uboot-$(u))) \
)
