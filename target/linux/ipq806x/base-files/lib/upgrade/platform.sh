#
# Copyright (c) 2013 Qualcomm Atheros, Inc.
# Copyright (C) 2011 OpenWrt.org
#

. /lib/ipq806x.sh

CI_BLKSZ=2048
RAMFS_COPY_DATA=/lib/ipq806x.sh

# get the first 4 bytes (magic) of a given file starting at offset in hex format
get_magic_long_at() {
	dd if="$1" skip=$(( $CI_BLKSZ / 4 * $2 )) bs=4 count=1 2>/dev/null | hexdump -v -n 4 -e '1/1 "%02x"'
}

# scan through the update image pages until matching a magic
platform_get_offset() {
	offsetcount=0
	magiclong="x"
	if [ -n "$3" ]; then
		offsetcount=$3
	fi
	while magiclong=$( get_magic_long_at "$1" "$offsetcount" ) && [ -n "$magiclong" ]; do
		case "$magiclong" in
			"27051956")
				# U-Boot image magic
				if [ "$2" = "uImage" ]; then
					echo $offsetcount
					return
				fi
			;;
			"55424923")
				# ubi header
				if [ "$2" = "rootfs" ]; then
					echo $offsetcount
					return
				fi
			;;
		esac
		offsetcount=$(( $offsetcount + 1 ))
	done
}

platform_check_image() {
	local board=$(ipq806x_board_name)

	[ "$ARGC" -gt 1 ] && return 1

	case "$board" in
	db149 | ap148 | ap145)
		uImage_blockoffset=$( platform_get_offset "$1" uImage "0" )
		[ -z $uImage_blockoffset ] && {
			echo "uImage not found"
			return 1
		}
		rootfs_blockoffset=$( platform_get_offset "$1" rootfs "uImage_blockoffset" )
		[ -z $rootfs_blockoffset ] && {
			echo "missing rootfs"
			return 1
		}
		echo $uImage_blockoffset > /tmp/kernel-addr
		echo $rootfs_blockoffset > /tmp/rootfs-addr
		return 0
		;;
	esac

	echo "Sysupgrade is not yet supported on $board."
	return 1
}

platform_do_upgrade() {
	local board=$(ipq806x_board_name)

	kern_size=$(cat /tmp/kernel-addr)
	rootfs_size=$(cat /tmp/rootfs-addr)

	# verify some things exist before erasing
	if [ ! -e $1 ]; then
		echo "sysupgrade not present after switching to ramfs, aborting upgrade!"
		reboot
	fi

	case "$board" in
	db149 | ap148 | ap145)
		dd if=$1 of=/tmp/kernel \
			bs=$CI_BLKSZ count=$(( $rootfs_size - $kern_size )) \
			skip=$(( $kern_size ))
		mtd erase kernel
		mtd write /tmp/kernel kernel
		rm /tmp/kernel

		dd if=$1 of=/tmp/rootfs \
			bs=$CI_BLKSZ skip=$(( $rootfs_size ))
		mtd erase rootfs
		mtd write /tmp/rootfs rootfs
		rm /tmp/rootfs

		# TODO restore overlay and config
		return 0;
		;;
	esac

	echo "Upgrade failed!"
	return 1;
}
