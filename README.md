# Loongson Simple Installer

## Files

* `conf/installer/main`: actual installer script
* `conf/hooks/installer-essentials`: initramfs-tools hook to include dependencies of the installer
* `conf/scripts/init-premount/installer`: bootstrapper for the installer script

## Prerequisites

As root, 

```
$ apt install whiptail parted squashfs-tools
```

## Building `installer.img`

```
$ ./build_installer_initrd.sh
```

## Building the installation media

The installer expects 

* `filesystem.sqfs`: the squashfs image to be extracted by the installer. 
* `filesystem.md5sum`: the md5sum of `filesystem.sqfs`, checked by the installer before installation.
  * To compute the md5sum, run `md5sum filesystem.sqfs > filesystem.md5sum`.

to be present in a FAT32 filesystem on the target machine.

## Testing with QEMU

```
$ cd qemu
$ qemu-img create -f qcow2 disk.qcow2 5G
$ # copy/move your installation media to `./media.img`
$ ./boot.sh
```
## TODO and BUGS

* Incomplete (and untested) post-installation procedure.
* Lock the target hard disk before partitioning / formatting.
