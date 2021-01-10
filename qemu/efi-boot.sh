#!/bin/sh
kvm -vnc 0.0.0.0:1 \
-m 1G -bios /usr/share/OVMF/OVMF_CODE.fd \
-cdrom ../../loongbian_*.iso \
-hda disk.qcow2
