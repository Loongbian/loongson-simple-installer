#!/bin/sh
kvm -nographic -serial mon:stdio -append 'console=ttyS0 quiet' \
-kernel /vmlinuz -initrd ../installer.img -m 1G \
-hda disk.qcow2 -hdb media.img
# debug=vc
