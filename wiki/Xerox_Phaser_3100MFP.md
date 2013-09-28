Xerox Phaser 3100MFP
====================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Installation                                                       |
|     -   2.1 Grabbing drivers                                             |
|     -   2.2 Printer                                                      |
|         -   2.2.1 Identifying printer problem                            |
|         -   2.2.2 Installing missed libraries                            |
|                                                                          |
|     -   2.3 Scanner                                                      |
|         -   2.3.1 Installing scanner driver                              |
|         -   2.3.2 Installing necessary libraries and binaries            |
|                                                                          |
| -   3 Troubleshooting                                                    |
|     -   3.1 I can't download <filename>                                  |
|     -   3.2 I get "error while loading shared libraries"                 |
|     -   3.3 "Local Printers:" shows blank in CUPS "Add Printer" page.    |
+--------------------------------------------------------------------------+

Introduction
============

This article describes setup of Xerox Phaser 3100MFP on Arch Linux
x86_64. For this device Xerox provides only 32bit version of drivers and
no open-source drivers are available, it makes setup a bit tricky. On
x86 you should just install drivers from official site and configure as
usual.

Installation
============

Plug in your device and turn it on. You should see something like this:

    $ lsusb -v
    ...
    Bus 001 Device 006: ID 0924:3cef Xerox 
    Device Descriptor:
    ...
      idVendor           0x0924 Xerox
      idProduct          0x3cef 
      bcdDevice            1.00
      iManufacturer           1 XEROX
      iProduct                2  Phaser 3100MFP
      iSerial                 3 L508104LE514587

Grabbing drivers
----------------

It's easy, you can download drivers from official Xerox website using
you browser or just do the following:

    # mkdir scanner
    # mkdir printer
    # wget http://download.support.xerox.com/pub/drivers/3100MFP/drivers/linux/en/XeroxPhaser3100-1.0-linux-2.6Debian-intel.tar.gz
    # wget http://download.support.xerox.com/pub/drivers/3100MFP/drivers/linux/en/XeroxPhaser3100sc-1.0-linux-2.6Debian-intel.tar.gz
    # tar -xf XeroxPhaser3100-1.0-linux-2.6Debian-intel.tar.gz -C printer/
    # tar -xf XeroxPhaser3100sc-1.0-linux-2.6Debian-intel.tar.gz -C scanner/

On my system I use drivers for Debian, but i think there is really no
difference which drivers to download.

Printer
-------

OK, first of all we need to install CUPS:

    # pacman -S cups

Since 1.4.x version CUPS requires usblp kernel module to be unloaded, so
next step is to remove module:

    # rmmod usblp

If you do not want to do it every time you boot, just blacklist the
kernel module:

    /etc/modprobe.d/usblp.conf

    blacklist usblp

After this run:

    # mkinitcpio -p linux

Execute driver installer and accept licence:

    # cd printer
    # ./XeroxPhaser3100.install

Start CUPS:

    # systemctl start cups.service

Now open http://localhost:631 in your browser, add printer and try to
print test page. If it's ok, then you are really lucky, but most likely
you'll see this error message:

Error:/usr/lib/cups/filter/rastertoprinter failed

> Identifying printer problem

Well, let's debug a little. Change CUPS debug level:

    /etc/cups/cupsd.conf

    LogLevel debug

Restart CUPS:

    # systemctl restart cups.service                                                                                        

Then restart last job and take a look at error log again, you'll see
something like this:

Error:[Job 1] /usr/lib/cups/filter/rastertoprinter: line 14:
/usr/lib/cups/filter/rastertoprinterbin: No such file or directory

As you remember, Xerox told us, that drivers were 32bit only, so we have
to install necessary libraries. Use this to see, what libraries are
missed:

    # readelf -d  /usr/lib/cups/filter/rastertoprinterbin 

    Dynamic section at offset 0x10314 contains 25 entries:
      Tag        Type                         Name/Value
     0x00000001 (NEEDED)                     Shared library: [libcupsimage.so.2]
     0x00000001 (NEEDED)                     Shared library: [libstdc++.so.6]
     0x00000001 (NEEDED)                     Shared library: [libm.so.6]
     0x00000001 (NEEDED)                     Shared library: [libgcc_s.so.1]
     0x00000001 (NEEDED)                     Shared library: [libc.so.6]
     0x00000001 (NEEDED)                     Shared library: [libcups.so.2]

> Installing missed libraries

Let's install libraries:

    # pacman -S lib32-libcups lib32-libstdc++5 lib32-libtiff lib32-libpng
    # ln -s /usr/lib32/libc.so /usr/lib32/libc.so.2

Note:If you driver binary is linked against other libraries (or
versions) you need to install them and create proper symlinks. See this

So now try to print, it should work properly. Finally, to make sure CUPS
starts automatically during boot:

    # systemctl enable cups.service

For help with further problems refer to CUPS#Troubleshooting

Scanner
-------

> Installing scanner driver

Create /etc/sane.d directory if it doesn't exist, because it's need by
installer:

    # mkdir -p /etc/sane.d

Now install driver:

    # cd scanner/
    # ./XeroxPhaser3100sc.install

> Installing necessary libraries and binaries

Scanner's problem is similar to printer's one: 64bit SANE will not work
with 32bit back-end. We need to install 32bit SANE and libraries it
depends on.

Note:I've found installing 32bit xsane frontend so long and boring,
that's why I decided to use only CLI of scanimage, it works pretty and
we do not need to install a lot of libraries. But if you really need to
use xsane you may want to have a 32bit system in chroot.

Let's install 32bit SANE and necessary libraries:

    # wget http://mirror.yandex.ru/archlinux/extra/os/i686/sane-1.0.21-3-i686.pkg.tar.xz
    # wget http://mirror.yandex.ru/archlinux/core/os/i686/libusb-0.1.12-4-i686.pkg.tar.gz
    # wget http://mirror.yandex.ru/archlinux/extra/os/i686/libieee1284-0.2.11-2-i686.pkg.tar.gz
    # wget http://mirror.yandex.ru/archlinux/extra/os/i686/libgphoto2-2.4.9-1-i686.pkg.tar.xz
    # wget http://mirror.yandex.ru/archlinux/extra/os/i686/libexif-0.6.19-1-i686.pkg.tar.gz
    # wget http://mirror.yandex.ru/archlinux/extra/os/i686/avahi-0.6.27-2-i686.pkg.tar.xz
    # mkdir -p  /usr/local/bin/
    # mkdir -p  /usr/local/lib32
    # mkdir sane
    # mkdir libusb
    # mkdir libgphoto
    # mkdir libexif
    # mdkir libieee1284
    # mkdir avahi
    # tar -xf sane-1.0.21-3-i686.pkg.tar.xz  -C sane
    # tar -xf libusb-0.1.12-4-i686.pkg.tar.gz -C libusb/
    # tar -xf libieee1284-0.2.11-2-i686.pkg.tar.gz -C libieee1284
    # tar -xf avahi-0.6.27-2-i686.pkg.tar.xz -C avahi
    # cp -r ./sane/usr/lib/* /usr/local/lib32/ 
    # cp ./sane/usr/bin/* /usr/local/bin/
    # cp ./libusb/usr/lib/libusb.so /usr/local/lib32/
    # cp ./libieee1284/usr/lib/libieee1284.a /usr/local/lib32/
    # cp ./libieee1284/usr/lib/libieee1284.so /usr/local/lib32/
    # cp ./libgphoto/usr/lib/libgphoto2.so /usr/local/lib32/
    # cp ./libgphoto/usr/lib/libgphoto2_port.so /usr/local/lib32/
    # cp ./libexif/usr/lib/libexif.so /usr/local/lib32/
    # cp ./avahi/usr/lib/libavahi-common.so /usr/local/lib32/
    # cp ./avahi/usr/lib/libavahi-client.so /usr/local/lib32/
    # ln -s /usr/local/lib32/libusb.so /usr/local/lib32/libusb.so.4
    # ln -s /usr/local/lib32/libieee1284.so /usr/local/lib32/libieee1284.so.3
    # ln -s /usr/local/lib32/libieee1284.so /usr/local/lib32/libieee1284.so.3.2.2
    # ln -s /usr/local/lib32/libgphoto2.so /usr/local/lib32/libgphoto2.so.2
    # ln -s /usr/local/lib32/libgphoto2_port.so /usr/local/lib32/libgphoto2_port.so.0
    # ln -s /usr/local/lib32/libexif.so  /usr/local/lib32/libexif.so.12 
    # ln -s /usr/local/lib32/libavahi-common.so /usr/local/lib32/libavahi-common.so.3
    # ln -s /usr/local/lib32/libavahi-client.so /usr/local/lib32/libavahi-client.so.12
    # pacman -S multilib/lib32-v4l-utils multilib/lib32-libtool multilib/lib32-dbus-core

We placed 32bit libraries and binaries to /usr/local, because do not
want to mix "tricky" installed stuff with one installed by package
manager. Last step is to tell ld where libraries are located:

    /etc/ld.so.conf.d/lib32-sane.conf

    /usr/local/lib32

Check that your ld.so.conf includes just created file. It may looks like
this:

    /etc/ld.so.conf

    include /etc/ld.so.conf.d/*.conf

Now try to run scanimage, it should work:

    $ /usr/local/bin/scanimage -L
    device `XeroxPhaser3100:usb:001:006' is a XEROX 3100MFP Feeder/Flatbed Scanner

You may want to run scanimage without specifying a full path. Then edit
you bashrc (system-wide or just for local user):

    /etc/bash.bashrc

    PATH="/usr/local/bin:$PATH"
    export PATH

Troubleshooting
===============

I can't download <filename>
---------------------------

I use direct links for drivers and packages downloads, but they may
change, so if you can't download something, first what you should is to
try to correct link or find new version of package.

I get "error while loading shared libraries"
--------------------------------------------

This means that you didn't install library that running application
depends on. Try to find it with pacman or just download corresponding
package and extract library. Also this error message may be caused by
lack of correct symlink, in this case you should create/fix symlink. For
example, when rastertoprinterbin fails to load shared library in CUPS
error log it looks like:

Error:[Job 1] /usr/lib/cups/filter/watermarkfilter: error while loading
shared libraries: libpng14.so.14: cannot open shared object file: No
such file or directory

First of all, check if this library is installed properly. Then check
symlinks. Also you may need to run ldconfig after symlinks creation.

"Local Printers:" shows blank in CUPS "Add Printer" page.
---------------------------------------------------------

It is possible, that the Xerox Phaser 3100MFP still requires the usblp
module to be loaded. In this case you should follow the instructions at
CUPS#Printer_is_not_recognized_by_CUPS and undo the blacklisting step
implemented earlier by removing

    #/etc/modprobe.d/usblp.conf

After finishing the last step and restarting CUPS, retry "Add Printer"
in the CUPS web interface. Note, you may see two identical entries in
the "Model" list when adding the printer, if selecting one does not
work, try repeat adding the printer and try selecting the other.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xerox_Phaser_3100MFP&oldid=252069"

Category:

-   Printers
