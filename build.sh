#!/bin/bash

## Simple Debian Installer
## Copyright (C) 2020 Peter Zhang <mbyzhang@outlook.com>
##
## This program comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
## This is free software, and you are welcome to redistribute it
## under certain conditions; see COPYING for details.

ORIG_CONF_DIR=/usr/share/initramfs-tools
MASK_CONF_DIR=conf
OUTPUT_FILE=installer.img
DUMMY_CONF_DIR="$(mktemp -d)"
INST_CONF_OVERLAY_DIR="$(mktemp -d)"

KERNEL_VERSION="${INSTALLER_MKINITRAMFS_KERNEL_VERSION:-auto}"
BOOTLOADER="${INSTALLER_BOOTLOADER:-pmon}"
GRUB_TARGET="${INSTALLER_GRUB_TARGET:-mips64el-efi}"

trap cleanup EXIT INT TERM

if [ "$1" != "" ]; then
  KERNEL_VERSION="$1"
fi

cleanup()
{
  rm -rf "$DUMMY_CONF_DIR"
  rm -rf "$INST_CONF_OVERLAY_DIR"
  umount -q "$ORIG_CONF_DIR"
}

check_directory_or_fail()
{
  if [ ! -d $1 ]; then
    echo "Error: Could not find $1 directory."
    exit 1
  fi
}

if [ $EUID -ne 0 ]; then
   echo "Error: This script must be run as root"
   exit 1
fi

cd $(dirname $0)

cat << EOF > "$DUMMY_CONF_DIR/initramfs.conf"
MODULES=most
BUSYBOX=y
KEYMAP=n
COMPRESS=gzip
DEVICE=
NFSROOT=auto
RUNSIZE=10%
EOF

touch "$DUMMY_CONF_DIR/modules"
mkdir "$DUMMY_CONF_DIR/"{conf.d,hook,scripts}

check_directory_or_fail "$MASK_CONF_DIR"
check_directory_or_fail "$DUMMY_CONF_DIR"
check_directory_or_fail "$INST_CONF_OVERLAY_DIR"

mkdir -p "$INST_CONF_OVERLAY_DIR/installer"
cat << EOF > "$INST_CONF_OVERLAY_DIR/installer/config"
CONFIG_BOOTLOADER=$BOOTLOADER
CONFIG_GRUB_TARGET=$GRUB_TARGET
EOF

mount -t overlay overlay -o "lowerdir=$INST_CONF_OVERLAY_DIR:$MASK_CONF_DIR:$ORIG_CONF_DIR" "$ORIG_CONF_DIR"

if [ $? -ne 0 ]; then
  echo "Error: Failed to create merged configuration directory. Is overlayfs support enabled?"
  exit 1
fi

echo "Building $OUTPUT_FILE"
mkinitramfs -d "$DUMMY_CONF_DIR" -o "$OUTPUT_FILE" "$KERNEL_VERSION"
