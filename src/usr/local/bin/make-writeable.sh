#!/bin/bash

make_writable() {
        local dir size
        dir="${1%/}"
        size=$2
        [ -n "$size" ] && size=",size=$size"

        echo -n "Binding $dir to ramdisk:"
        echo -n " mount" && mount -n -t tmpfs -o mode=755${size+$size} none /mnt &&
        echo -n " rsync" && rsync --numeric-ids -arz $dir/ /mnt/ &&
        echo -n " bind" && mount -n --bind /mnt $dir &&
        echo " umount" && umount /mnt 2>/dev/null
}

make_writable /etc 100m
make_writable /var
make_writable /boot
#mount -n -t tmpfs -o mode=1777,size=32g none /tmp
