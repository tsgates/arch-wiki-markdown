MacBookPro Retina
=================

> Summary

This wiki page should help you in getting your MacBook Pro with Retina
Display to work with Arch Linux.

> Related

Official Arch Linux Install Guide

Beginners Guide

General Recommendations

MacBook

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Overview                                                           |
| -   2 Preparing for the Installation                                     |
|     -   2.1 Preparing the Hard drive                                     |
|     -   2.2 Using the Thunderbolt to Ethernet adapter                    |
|     -   2.3 Getting wireless firmware                                    |
|                                                                          |
| -   3 Installation                                                       |
|     -   3.1 Booting the live image                                       |
|     -   3.2 Connecting WiFi                                              |
|     -   3.3 The installation                                             |
|     -   3.4 Bootloader                                                   |
|         -   3.4.1 Direct EFI booting                                     |
|         -   3.4.2 GRUB                                                   |
|                                                                          |
| -   4 Post installation                                                  |
|     -   4.1 Graphics                                                     |
|     -   4.2 Sound                                                        |
|     -   4.3 Touchpad                                                     |
|                                                                          |
| -   5 What doesn't work (early September 2012, 3.6-rc6)                  |
| -   6 Discussions                                                        |
+--------------------------------------------------------------------------+

Overview
--------

This page should help you setting up ArchLinux on a MacBook Pro 10,1
with Retina display. Most of the steps are the same or very similar to
the regular ArchLinux installation. However, because this is very new
hardware, the setup requires a few different steps. The general
installation guidelines are descibed in MacBook.

Note: To have all hardware supported, you should run this Notebook with
Kernel 3.7 or newer.

Preparing for the Installation
------------------------------

> Preparing the Hard drive

Assuming you want to dual boot with OS X, you have to shrink its
partition with the Disk Utility. You can either create your Linux
partition directly here, or do that later in Linux during the
installation (using parted and mkfs).

> Using the Thunderbolt to Ethernet adapter

The adapter should work out of the box if connected before booting.
Thunderbolt hotplugging is not supported (yet?).

> Getting wireless firmware

In order for the WiFi chip to work, you need to get the firmware for it.
You can just copy it from another b43 enabled Arch, extract it from
Broadcom's driver using b43-fwcutter or get them through the
b43-firmware available in the AUR. In the end you should have a folder
called b43 with lots of .fw files in it.

Installation
------------

> Booting the live image

Now, download the latest Archboot iso, write it to USB and boot from it
by selecting it in the Apple boot loader. When it comes to the syslinux
boot loader, press Tab to edit the entry and append noapic or nointremap
to the end to prevent a kernel panic during bootup. Currently (Aug 4,
2012), you also have to add nomodeset.

> Connecting WiFi

Note: You can skip this if you use the Thunderbolt to ethernet adapter
for the installation.

After it has finished booting, enter a command line. Copy the entire
folder with the firmware for your wireless card to (/usr)/lib/firmware/.
Now you should be able to use wpa_supplicant to connect to your WiFi
network.

> The installation

Note:Refer to the MacBook page if you don't want to have a separate
partition for GRUB but rather prefer to use rEFInd (or rEFIt).

Run the installation wizard. When asked to partition your hard drive,
create a small HFS partition. This is where you put the standalone GRUB
package after the installation. The rest of the installation is pretty
much the same as usual. When choosing the bootloader, select GRUB and
install it. Don't worry about any errors, we will create the bootable
efi image on our own afterwards.

After the installation has completed, directly copy the WiFi firmware to
the installed system to /tmp/install/usr/lib/firmware/.

> Bootloader

Direct EFI booting

See: UEFI_Bootloaders

GRUB

Another solution is to install GRUB. Edit
/tmp/install/boot/grub/grub.cfg and edit the boot entry to load
linux-mainline instead of the normal one. Also append noapic to the
kernel line again.

Now cd into /tmp/install/ and create the GRUB image by calling:

    grub-mkstandalone -o grub-standalone-x86_64.efi -d usr/lib/grub/x86_64-efi -O x86_64-efi -C xz boot/grub/grub.cfg

This will create file called grub-standalone-x86_64.efi which contains
GRUB and the config file. It is important to cd into the right directory
to make it pick up the config file and put it into the right place
within the image. Copy this file to the HFS partition you have created
earlier. Downside of this method is that you need to repeat this step
whenever you want to change the GRUB config.

Reboot the machine and boot into OS X. The HFS partition should be
mounted and the GRUB standalone image in there. Follow the steps on this
page to create the files needed to make the Apple boot loader pick up
GRUB: http://mjg59.dreamwidth.org/7468.html. After creating the files,
use bless on the GRUB image on the partition, if you want to boot
automatically to Arch, append --setBoot.

After another reboot, you should be able to select your installed Arch
Linux by keeping the alt button pressed while booting in case you
haven't used --setBoot while blessing.

Post installation
-----------------

> Graphics

The Laptop comes with an nVidia and an Intel chip. The Nouveau, the i915
(from 3.6-rc5) and proprietary nvidia (from 302.17) drivers work. You
can install the nvidia driver through nvidia or the AUR package
nvidia-beta-all.

Since this device comes with a Retina (HiDPI) display, things are really
small with native resolution. There are different ways to work around
this "issue":

1.  Increase the DPI value to get larger fonts (other things like icons
    may not look great that way)
2.  Some desktop managers like KDM offer fine grained control over the
    size of icons, fonts, window controls, panels, etc...
    -   KDM is a great choice because the stock UI elements are vectors
        (not rasters which look terrible on Retina and don't scale
        infinitely). In addition the KWin compositor does a remarkable
        job on the Retina display.

3.  Lower the screen resolution to 1680x1050 (works fine at least with
    nouveau drivers), but things look a little bit blurry, of course

> Sound

On the MacBookPro10,2 you must use the 'snd_hda_intel' driver with the
model option 'mbp101'. This model option goes in the modprobe
configuration and is undocumented in the list of models available
online, but it work admirably. (Until you do this, it will look it is
working because you'll be able to get sound out through HDMI, but /not/
the built-in speakers.)

> Touchpad

Because of the integrated button, the synaptics touchpad driver can
cause some issues. Adjusting xf86-input-mtrack-git should lead to a
better end result.

The following config uses a single touch for left, two for middle, three
for right:

    Section "InputClass"
        MatchIsTouchpad "on"
        Identifier      "Touchpads"
        Driver          "mtrack"
        Option          "Sensitivity" "0.65"
        Option          "IgnoreThumb" "true"
        Option          "IgnorePalm" "true"
        Option          "TapButton1" "1"  
        Option          "TapButton2" "2"
        Option          "TapButton3" "3"
        Option          "ClickFinger1" "1"
        Option          "ClickFinger2" "3"
        Option          "ClickFinger3" "2"
        Option          "BottomEdge" "25"
    EndSection

What doesn't work (early September 2012, 3.6-rc6)
-------------------------------------------------

-   Suspend mode on lid close with nouveau and i915 (does not come out
    of suspend; blank screen).
-   Thunderbolt ethernet controller is not hot pluggable as of the
    3.8.11-1 kernel. The controller cannot
    -   be connected and used after boot
    -   be used if the controller is logically or physically
        disconnected and reconnected during an active session
    -   survive suspend and resume states because the kernel is not able
        to successfully change the power state

Discussions
-----------

Here are a couple of interesting threads:

-   http://ubuntuforums.org/showthread.php?t=2006475
-   https://bbs.archlinux.org/viewtopic.php?id=144255&p=1

Retrieved from
"https://wiki.archlinux.org/index.php?title=MacBookPro_Retina&oldid=256102"

Category:

-   Apple
