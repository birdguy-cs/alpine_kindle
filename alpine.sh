#!/bin/sh
mkdir -p /tmp/alpine
mount -o loop,noatime -t ext3 /mnt/base-us/alpine.ext3 /tmp/alpine
mount -o bind /dev /tmp/alpine/dev
mount -o bind /dev/pts /tmp/alpine/dev/pts
mount -o bind /proc /tmp/alpine/proc
mount -o bind /sys /tmp/alpine/sys
cp /etc/hosts /tmp/alpine/etc/hosts
chmod a+w /dev/shm

chroot /tmp/alpine /bin/sh

kill $(pgrep Xephyr)
kill -9 $(lsof -t /var/tmp/alpine/)

umount /tmp/alpine/sys
sleep 1
umount /tmp/alpine/proc
umount /tmp/alpine/dev/pts
umount /tmp/alpine/dev
# Sync beforehand so umount doesn't fail due to the device being busy still
sync
umount /tmp/alpine || true
# Sometimes it fails still and only works by trying again
while [ "$(mount | grep /tmp/alpine)" ]
do
	echo "Alpine is still mounted, trying again shortly.."
	sleep 3
	umount /tmp/alpine || true
done
echo "Alpine unmounted"

