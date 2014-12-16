#
# Copyright (c) 2013 The Linux Foundation. All rights reserved.
#

define Profile/QSDK_Base
	PACKAGES:=luci uhttpd kmod-ipt-nathelper-extra luci-app-upnp kmod-fs-ext4 \
	  kmod-usb-storage kmod-usb2 kmod-fs-msdos kmod-fs-ntfs kmod-fs-vfat \
	  ntfs-3g dosfsck e2fsprogs fdisk mkdosfs \
	  kmod-nls-cp437 kmod-nls-iso8859-1 tftp-hpa sysstat igmpproxy kmod-ipt-nathelper-rtsp \
	  kmod-ipv6 iperf devmem2 ip ethtool ip6tables \
	  quagga quagga-ripd quagga-zebra quagga-watchquagga rp-pppoe-relay \
	  -dnsmasq dnsmasq-dhcpv6 radvd wide-dhcpv6-client bridge \
	  luci-app-ddns ddns-scripts \
	  iputils-tracepath iputils-tracepath6
endef

define Profile/QSDK_Open_Router
	$(Profile/QSDK_Base)
	NAME:=Qualcomm-Atheros SDK Open Router Profile
	PACKAGES+= -kmod-ath9k -kmod-ath5k -kmod-ath -wpad-mini alljoyn \
	  hostapd hostapd-utils iwinfo kmod-qca-ath10k kmod-qca-ath9k kmod-qca-ath \
	  kmod-fast-classifier kmod-usb2 luci-app-qos wireless-tools \
	  wpa-supplicant wpa-cli qca-legacy-uboot-ap121
endef

define Profile/QSDK_Open_Router/Description
  QSDK Open Router package set configuration.
  This profile includes only open source packages and is designed to fit in a 16M flash. It supports:
  - Bridging and routing networking
  - LuCI web configuration interface
  - USB hard drive support
  - Samba
  - IPv4/IPv6
  - DynDns
  - Integrated 11abgn support using the ath9k driver
endef
$(eval $(call Profile,QSDK_Open_Router))

define Profile/QSDK_Wired_Router
	$(Profile/QSDK_Base)
	NAME:=Qualcomm-Atheros SDK Wired Router Profile
	PACKAGES+=-kmod-ath9k -kmod-ath5k -kmod-ath -wpad-mini luci-app-qos \
	  qca-legacy-uboot-ap136 kmod-qca-ssdk-nohnat qca-ssdk-shell kmod-shortcut-fe-cm
endef

define Profile/QSDK_Wired_Router/Description
  QSDK Wired Router package set configuration.
  This profile is designed to fit in a 8M flash and supports the following features:
  - Bridging and routing networking
  - LuCI web configuration interface
  - USB hard drive support
  - Samba
  - IPv4/IPv6
  - DynDns
  It doens't provide any WiFi driver.
endef
$(eval $(call Profile,QSDK_Wired_Router))

define Profile/QSDK_Premium_Router
	$(Profile/QSDK_Base)
	NAME:=Qualcomm-Atheros SDK Premium Router Profile
	PACKAGES+= -kmod-ath9k -kmod-ath5k -kmod-ath -wpad-mini \
	  streamboost hyfi alljoyn kmod-fast-classifier \
	  kmod-qca-wifi-perf qca-hostap qca-spectral qca-hostapd-cli qca-wpa-cli \
	  qca-wpa-supplicant qca-legacy-uboot-ap135 kmod-art2 sigma-dut \
	  kmod-qca-ssdk-nohnat qca-ssdk-shell
endef

define Profile/QSDK_Premium_Router/Description
  QSDK Premium Router package set configuration.
  This profile is designed to fit in a 16M flash and supports the following features:
  - Bridging and routing networking
  - QCA-WiFi driver configuration
  - LuCI web configuration interface
  - Streamboost
  - USB hard drive support
  - Samba
  - IPv4/IPv6
  - DynDns
endef
$(eval $(call Profile,QSDK_Premium_Router))

