#!/bin/sh

HOST="root@loongson64"
TARGET_DIR=installer
rsync -av --delete --exclude-from .gitignore . "$HOST:$TARGET_DIR" && \
ssh "$HOST" "cd $TARGET_DIR && ./build_installer_initrd.sh && cp -f installer.img /boot"
