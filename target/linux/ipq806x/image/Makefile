# Copyright (c) 2013 The Linux Foundation. All rights reserved.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

UBIFS_OPTS = -m 2048 -e 124KiB -c 4096 -U -F
UBINIZE_OPTS = -m 2048 -p 128KiB

E2SIZE=$(shell echo $$(($(CONFIG_TARGET_ROOTFS_PARTSIZE)*1024)))

define Image/BuildKernel
	$(CP) $(LINUX_DIR)/vmlinux $(BIN_DIR)/$(IMG_PREFIX)-vmlinux.elf
	$(CP) $(LINUX_DIR)/arch/arm/boot/Image $(BIN_DIR)/$(IMG_PREFIX)-vmlinux.bin
	dd if=$(LINUX_DIR)/arch/arm/boot/uImage of=$(KERNEL_BUILD_DIR)/uImage bs=2k conv=sync
	$(CP) $(KERNEL_BUILD_DIR)/uImage $(BIN_DIR)/$(IMG_PREFIX)-$(KERNEL)-uImage
endef

define Image/Build
	$(call Image/Build/$(1),$(1))
	mkdir -p $(BIN_DIR)
	dd if=$(KDIR)/root.$(1) of=$(BIN_DIR)/$(IMG_PREFIX)-$(1)-root.img bs=2k conv=sync
	$(call Sysupgrade,$(1))

endef

define Sysupgrade
	cat $(BIN_DIR)/$(IMG_PREFIX)-$(KERNEL)-uImage \
	    $(BIN_DIR)/$(IMG_PREFIX)-$(1)-root.img > \
		$(BIN_DIR)/$(IMG_PREFIX)-sysupgrade.bin
endef

$(eval $(call BuildImage))
