#!/bin/sh
kvm -nographic -serial mon:stdio -append 'console=ttyS0' \
-kernel /vmlinuz -initrd ../installer.img -m 1G \
-hda ../../debian_*.iso -hdb disk.qcow2
# debug=vc
