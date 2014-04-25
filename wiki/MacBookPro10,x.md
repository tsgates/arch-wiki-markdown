MacBookPro10,x
==============

Summary help replacing me

This wiki page should help you in getting your MacBook Pro with Retina
Display to work with Arch Linux.

> Related

Installation guide

Beginners' guide

General Recommendations

MacBook

This page should help you setting up ArchLinux on a MacBook Pro 10,1
with Retina display. Most of the steps are the same or very similar to
the regular ArchLinux installation. However, because this is very new
hardware, the setup requires a few different steps. The general
installation guidelines are descibed in MacBook.

Note: To have all hardware supported, you should run this Notebook with
Kernel 3.7 or newer.

Contents
--------

-   1 Preparing for the Installation
    -   1.1 Preparing the Hard drive
    -   1.2 Using the Thunderbolt to Ethernet adapter
    -   1.3 Getting wireless firmware
-   2 Installation
    -   2.1 Booting the live image
    -   2.2 Connecting Wi-Fi
    -   2.3 The installation
    -   2.4 Bootloader
        -   2.4.1 Direct EFI booting
        -   2.4.2 GRUB
-   3 Post installation
    -   3.1 Graphics
    -   3.2 Sound
    -   3.3 Touchpad
-   4 What doesn't work (early August 2013, 3.10.3-1)
    -   4.1 General
    -   4.2 Graphics
    -   4.3 Wi-Fi
-   5 Discussions
-   6 See Also

Preparing for the Installation
------------------------------

> Preparing the Hard drive

Assuming you want to dual boot with OS X, you have to shrink its
partition with the Disk Utility. You can either create your Linux
partition directly here, or do that later in Linux during the
installation (using parted and mkfs).

> Using the Thunderbolt to Ethernet adapter

The adapter should work out of the box if connected before booting.
Thunderbolt hotplugging is not supported (there's a good description of
why on a RedHat developer's blog,
http://mjg59.dreamwidth.org/15948.html, circa August 2012); if you want
hotplug wired Ethernet, the USB adapter is your best bet.

Note:Thunderbolt is seen as a PCIe device to the kernel, all of it being
handled by the boot loader. In the case of the MacBook however, they
handle Thunderbolt as part of their OS. This means that hotplug support
isn't what's missing, a reimplementation of Thunderbolt->pcie interface
in Linux is missing. GKH was working on some thunderbolt support last
year, but if anyone has more recent information, please add it here.

> Getting wireless firmware

In order for the Wi-Fi chipset to work, you need to get the firmware for
it. You can just copy it from another b43-enabled Arch, extract it from
Broadcom's driver using b43-fwcutter, or get the firmware through the
b43-firmware package available in the AUR. In the end, you should have a
folder named b43 with a lot of .fw files in it.

Installation
------------

> Booting the live image

Now, download the latest Archboot iso, write it to USB and boot from it
by selecting it in the Apple boot loader. When it comes to the syslinux
boot loader, press Tab to edit the entry and append noapic or nointremap
to the end to prevent a kernel panic during bootup. Currently (Aug 4,
2012), you also have to add nomodeset.

> Connecting Wi-Fi

Note:You can skip this if you use the Thunderbolt or USB-to-Ethernet
adapter for the installation.

After it has finished booting, enter a command line. Copy the entire
folder with the firmware for your wireless card to /usr/lib/firmware/.
Now you should be able to use wpa_supplicant to connect to your Wi-Fi
network.

> The installation

Note:Refer to the MacBook page if you do not want to have a separate
partition for GRUB but rather prefer to use rEFInd (or rEFIt).

Run the installation wizard. When asked to partition your hard drive,
create a small HFS partition. This is where you put the standalone GRUB
package after the installation. The rest of the installation is pretty
much the same as usual. When choosing the bootloader, select GRUB, and
install it. Do not worry about any errors; we will create the bootable
EFI image on our own afterwards.

After the installation has completed, directly copy the Wi-Fi firmware
to the installed system to /tmp/install/usr/lib/firmware/.

Alternatively, install broadcom-wl-dkms from the AUR to improve Wi-Fi.

> Bootloader

Direct EFI booting

See: UEFI_Bootloaders

As of August 2013, refind can autodetect the Arch kernel, removing the
need for copying the kernel into the EFI partition. Simply install
refind and enable the "scan_all_linux_kernels" and "also_scan_dirs"
options in refind.conf (see link above for instructions.)

GRUB

Another solution is to install GRUB. Edit
/tmp/install/boot/grub/grub.cfg and edit the boot entry to load Linux
mainline instead of the normal one. Also append noapic to the kernel
line again.

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
use bless on the GRUB image on the partition. If you want to boot
automatically to Arch, append --setBoot.

After another reboot, you should be able to select your installed Arch
Linux by keeping the alt button pressed while booting in case you have
not used  --setBoot while blessing.

Post installation
-----------------

> Graphics

The Laptop comes with an nVidia and an Intel chip. The Nouveau, the i915
(from 3.6-rc5) and proprietary nvidia (from 302.17) drivers work. You
can install the nvidia driver through nvidia or the AUR package
nvidia-beta-all.

-   -   Note** that as of September, 2013 the current nvidia driver
        (325.15-5) does not work with the current 3.10 series kernels; X
        will die with an error about "Failed to allocate EVO core DMA
        push buffer" and leave you with a black screen (but able to SSH
        in to the machine). Your best current bet is to use a 3.9-series
        kernel and the older 319.32-series nvidia driver.

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
4.  Use xrandr scale option with nvidia driver to scale the resolution
    down to what you want. Take a look at:
    http://linuxmacbookproretina.blogspot.no/
5.  See HiDPI for more tweaks.

> Sound

On the MacBookPro10,2 you may need to use the 'snd_hda_intel' driver
with the model option 'mbp101'. This model option goes in the modprobe
configuration and is undocumented in the list of models available
online, but it work admirably. (Until you do this, it will look it is
working because you'll be able to get sound out through HDMI, but /not/
the built-in speakers.) (**As of September 2013** this no longer appears
to be required; this should work automatically.)

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
        Option          "TapButton2" "3"
        Option          "TapButton3" "2"
        Option          "ClickFinger1" "1"
        Option          "ClickFinger2" "3"
        Option          "ClickFinger3" "2"
        Option          "BottomEdge" "25"
    EndSection

What doesn't work (early August 2013, 3.10.3-1)
-----------------------------------------------

> General

-   Thunderbolt ethernet controller is not hot pluggable as of the
    3.10.3 kernel. The controller cannot
    -   be connected and used after boot
    -   be used if the controller is logically or physically
        disconnected and reconnected during an active session
    -   survive suspend and resume states because the kernel is not able
        to successfully change the power state
    -   This is caused by a non-compliant UEFI implementation by Apple.
        No known workarounds exist at this point.
-   see http://mjg59.dreamwidth.org/15948.html for further information
    (circa August 2012)

> Graphics

-   Using vgaswitcheroo to switch between iGPU / dGPU on the 15" version
    will result in a black screen. The system is still running and can
    be rebooted safely.
    -   The dGPU/nouveau is active on boot. As of 3.10.3-1, the only
        known way to switch to the iGPU/intel is to force this through
        gfxCardStatus v2.2.1 on MacOS (later versions of gfxCardStatus
        do *not* work.) This setting will survive reboots. To revert it,
        you must reboot into MacOS *twice* and/or reset the SMC (shutdow
        and press shift+control+alt+power at the same time. Press power
        again to boot.)
    -   "rmmod nouveau" will crash if the dGPU is manually powered off
        via vgaswitcheroo. Once this happens, it will be impossible to
        shutdown / reboot cleanly. Fresh patches (2 August) will
        hopefully fix this in the future. (Note: to enter this failure
        state, you must use gfxCardStatus to force the iGPU, then use
        vgaswitcheroo explicitly. This is rather uncommon.)
    -   The dGPU / iGPU issues do not affect the 13" rmbp, which only
        has an intel adapter. Much simpler!
-   Nvidia drivers 319.32 fail to suspend / resume or control the
    backlight out of the box.
    -   Nouveau and intel work fine.
-   If you are experiencing problems with Nvidia drivers, try using
    emulated BIOS boot instead of EFI boot.

> Wi-Fi

-   The default b43 driver works. Open issues (as of 3.10.3-1):
    -   You need proprietary firmware (see installation section above)
    -   Power management is not supported
    -   Connection may be unstable on some access points
    -   Performance is relatively low (I get double speed on the same
        network using an external ath9k chip)
-   broadcom-wl-dkms from the AUR offers a better experience.
    -   If you have a screen flickering issue when Wi-Fi is active, then
        switching to this driver should help.

Discussions
-----------

Here are a couple of interesting threads:

-   http://ubuntuforums.org/showthread.php?t=2006475
-   https://bbs.archlinux.org/viewtopic.php?id=144255&p=1

See Also
--------

-   A Puppet module for installing and configuring Arch (optionally with
    KDE) on the MBP Retina 10,2, along with initial install
    instructions, is available at
    https://github.com/jantman/puppet-archlinux-macbookretina. It's
    updated quite frequently, and run daily on its author's laptop.

Retrieved from
"https://wiki.archlinux.org/index.php?title=MacBookPro10,x&oldid=298327"

Category:

-   Apple

-   This page was last modified on 16 February 2014, at 07:59.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
