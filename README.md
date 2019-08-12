# Alpine Linux on Kindle
Here you find a set of utilities to get [Alpine Linux](https://alpinelinux.org/) running on Kindles. So far this has been tested on Paperwhite 3 only, but it should work on any Kindle (not Kindle Fire though) that has a touchscreen and enough Flash/RAM (At least enough space beside your books/documents to save a >=1.5GB file and at least 512MiB RAM).

![alt text](https://github.com/schuhumi/alpine_kindle/raw/master/images/Kindle_Alpine_Chromium.jpg)

## Overview
Kindles run a Linux operating system with X11 and everything on board already. To make better use of that one can utilize a full blown Linux distro including a proper desktop environment through chroot. Your Kindle stays fully functional to buy & read books. There's a number of things you need to get started though:
1. A rooted Kindle, you should have Kual, Kterm and USBNetwork working
2. An image file with Alpine Linux in it. You can either use the script provided here to quicky create a fresh and up-to-date one, or just download a snapshot from [TODO]
3. A two more scripts found in here to start Alpine on the kindle

## Step-by-Step
### 1. Root your Kindle
How that exactly works depends on your model of Kindle as well as the firmware version. You can find more information in the [mobileread forums](https://www.mobileread.com/forums/forumdisplay.php?f=150) and [mobileread wiki](https://wiki.mobileread.com/wiki/Kindle_Touch_Hacking). You'll also need [KUAL](https://www.mobileread.com/forums/showthread.php?t=203326) as application launcher, [Kterm](https://www.fabiszewski.net/kindle-terminal/) to start Alpine on the go without a computer, and [USBNetworking](https://wiki.mobileread.com/wiki/Kindle_Touch_Hacking#USB_Networking) for SSH access during installation.

### 2. Get an Alpine image
Here Alpine is saved within a file. You can either download an image at [TODO RELEASES], or create your own fresh and possibly customized one with the help of a script. Creating your own doesn't take long either, and if you have a linux computer it's pretty easy. All you need to install is qemu-user-static to execute arm software, but that should be in the repositories of your distro in most cases. Then have a look at [the script](https://github.com/schuhumi/alpine_kindle/blob/master/create_kindle_alpine_image.sh) especially at the configuration part (top). Finally you can execute it, and after a very short while you should be dropped into a shell inside Alpine. You can have a look around and tweak whatever you want, and with "exit" the script unmounts your fresh image and terminates.

### 3. Put it on your Kindle
You need to put the Alpine image (must be named "alpine.ext3"), the alpine.sh script and alpine.conf upstart-script on to the kindle. You can copy them on there like you do with other documents (USB mass storage, just put them in to root folder), or via scp in the following fashion (You need to have USBNetwork enabled obviously):
```
scp -C alpine.ext3 root@192.168.15.244:/mnt/us/
```
To save on RAM the Kindle GUI can be stopped before Alpine gets started. That must be done through upstart though, because when you stop the Kindle GUI, so does Kterm and Alpine itself when you start it from there. "alpine.conf" is a script to allow for that, it must be copied to the appropriate place though, e.g. assuming you have put it into /mnt/us:
```
mntroot rw
cp /mnt/us/alpine.conf /etc/upstart/
mntroot r
```
