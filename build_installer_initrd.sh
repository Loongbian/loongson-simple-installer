#!/bin/sh

ORIG_CONF_DIR=/usr/share/initramfs-tools
MASK_CONF_DIR=conf
DUMMY_CONF_DIR=dummy-conf
OUTPUT_FILE=installer.img

cleanup()
{
  umount -q $ORIG_CONF_DIR
}

check_directory_or_fail()
{
  if [ ! -d $1 ]; then
    echo "Error: Could not find $1 directory."
    exit 1
  fi
}

check_directory_or_fail $MASK_CONF_DIR
check_directory_or_fail $DUMMY_CONF_DIR

trap cleanup EXIT INT TERM
mount -t overlay overlay -o lowerdir=$MASK_CONF_DIR:$ORIG_CONF_DIR $ORIG_CONF_DIR

if [ ! $? -eq 0 ]; then
  echo "Error: Failed to create merged configuration directory. Is overlayfs support enabled?"
  exit 1
fi

echo "Building $OUTPUT_FILE"
mkinitramfs -d $DUMMY_CONF_DIR -o $OUTPUT_FILE
