#!/bin/sh
kvm -nographic -serial mon:stdio -append 'console=ttyS0 root=/dev/sda2 ro' \
-kernel /vmlinuz -initrd /initrd.img -m 1G \
-hda disk.qcow2
# debug=vc
