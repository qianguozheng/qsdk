#! /bin/sh
#
# Copyright (c) 2013 The Linux Foundation. All rights reserved.
#

. /lib/functions.sh
include /lib/upgrade

kill_remaining TERM
sleep 3
kill_remaining KILL

ROOTFS_PART=$(grep rootfs_data /proc/mtd |cut -f4 -d' ')

run_ramfs ". /lib/functions.sh; include /lib/upgrade; sync; mtd -r erase ${ROOTFS_PART}"
