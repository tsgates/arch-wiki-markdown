Dell Inspiron 6400
==================

The goal of this article is to provide a comprehensive guide for Dell
Inspiron 6400 owners seeking to install Arch Linux. It will attempt to
cover all facets of hardware management, including wireless networking
and hotkey support. Although this guide has been written specifically
for the Inspiron 6400, many of the sub-sections can be applied to other
Dell Inspiron models, including:

-   Dell Inspiron 640m
-   Dell Inspiron e1405
-   Dell Inspiron e1505
-   Dell Inspiron e1705

Contents
--------

-   1 Hardware Specifications
    -   1.1 Base Components
    -   1.2 Video Options
    -   1.3 Wireless Options
-   2 Hardware
    -   2.1 Audio
        -   2.1.1 Sigmatel/Intel Chipset
            -   2.1.1.1 ALSA Audio Drivers
            -   2.1.1.2 OSS Audio Drivers
    -   2.2 Video
        -   2.2.1 ATI X1300/X1400 Radeon Mobility
            -   2.2.1.1 Proprietary Driver (catalyst/fglrx)
            -   2.2.1.2 Open Source ATI Driver
        -   2.2.2 Intel Graphics Media Accelerator 950
            -   2.2.2.1 Open Source Intel Driver
        -   2.2.3 nVidia GeForce Go 7300
    -   2.3 Networking
        -   2.3.1 Broadcom 440x 10/100 Ethernet
        -   2.3.2 Wireless
    -   2.4 Conexant HDA D110 MDC V.92 modem (winmodem)
    -   2.5 Ricoh R5C822 SD/SDIO/MMC/MS/MSPro Card Reader
    -   2.6 Synaptics Touchpad
-   3 Power Management
    -   3.1 ACPI Hibernation/Suspend with pm-utils
    -   3.2 CPU Frequency Scaling with cpufrequtils
-   4 Multimedia Buttons & Fn Hotkeys
    -   4.1 Multimedia Buttons
        -   4.1.1 GNOME
        -   4.1.2 Openbox and other Window Managers
    -   4.2 Function (Fn) Hotkeys
-   5 Other Resources

Hardware Specifications
-----------------------

The 6400 series laptop is currently available in a number of
configurations and this guide will attempt to cover them all. Refer to
the list below to determine whether your configuration has been
documented.

-   Red items have yet to be covered in detail and require a Wiki entry

> Base Components

-   Intel Core Duo and Core 2 Duo processors
    -   T2500 (2GHz/667MHz FSB/2MB Cache)
    -   T5600 (1.83GHz/667MHz FSB/2MB Cache)
    -   T2050 (1.66GHz/667MHz FSB/2MB Cache)
    -   T1350 (1.66GHz/667MHz FSB/2MB Cache)
    -   T5200 (1.60GHz/667MHz FSB/2MB Cache)
-   512MB/1GB/2GB 533MHz/667MHz DDR2 SDRAM Memory
-   15.4" Widescreen Display
    -   WXGA (1280 x 800)
    -   WSXGA 1280x800 with TrueLife™
    -   WSXGA+ 1680x1050 with TrueLife™
-   80GB/100GB/120GB/160GB 5400/7200 RPM SATA Hard Drive
-   8x CD/DVD+/-RW/DL+R
-   Broadcom 440x 10/100 Ethernet
-   Conexant HDA D110 MDC V.92 modem (winmodem)
-   Sigmatel STAC 92xx Audio
-   Ricoh R5C822 SD/SDIO/MMC/MS/MSPro Card Reader
-   4 USB 2.0 Ports
-   Firewire port (IEEE 1394)
-   1 ExpressCard Slot
-   Synaptics touchpad with scroll zones

> Video Options

-   128MB ATI Mobility Radeon X1300 with HyperMemory
-   256MB ATI Mobility Radeon X1400 with Hypermemory
-   256MB nVidia GeForce Go 7300 with TurboCache
-   128MB Intel Graphics Media Accelerator 950

> Wireless Options

-   Intel Pro/Wireless 3945ABG (802.11a/b/g)
-   Dell Wireless 1390
-   Dell Wireless 1500 Draft 802.11n Wireless (Intel 4965AGN)
-   Dell Wireless 350 Bluetooth Module
-   Dell Wireless 355 Bluetooth Module

Hardware
--------

> Audio

Sigmatel/Intel Chipset

The Sigmatel audio chipset should be detected automatically during
installation, requiring no input from the user.

ALSA Audio Drivers

Refer to the ALSA wiki for general assistance with volume settings,
group permissions, etc.

OSS Audio Drivers

See the OSS wiki for more information.

> Video

ATI X1300/X1400 Radeon Mobility

Proprietary Driver (catalyst/fglrx)

See ATI wiki.

Open Source ATI Driver

Please refer to the ATI wiki for more information.

Intel Graphics Media Accelerator 950

Open Source Intel Driver

Install the driver:

    # pacman -S xf86-video-intel

Use gft to generate the Xorg Modeline values and then edit
/etc/X11/xorg.conf and add these values to the Monitor section, for
example:

    Section "Monitor"
     Identifier "Monitor0"
     VendorName "unknown"
     Modeline "800x600" 40.12 800 848 968 1056 600 601 605 628 #60Hz
    EndSection

Lastly, add the following to the "Device" section, replacing the
existing Driver value if present:

    VideoRam       229376
    Option "CacheLines" "1980"
    Driver      "intel"

nVidia GeForce Go 7300

The NVIDIA Driver Wiki works fine. A side note: When running
Beryl/Compiz-Fusion, while opening multiple instances of FireFox, the
entire window went black. Forcing AIGLX solved this.

> Networking

Broadcom 440x 10/100 Ethernet

The Broadcom Ethernet card should have out-of-the-box support. No
configuration necessary.

Wireless

See Wireless network configuration.

> Conexant HDA D110 MDC V.92 modem (winmodem)

The Conexant modem requires the proprietary hsfmodem driver. Dell offers
a debian package hsfmodem_7.60.00.06oem_i386.deb at their support site
that works at full speed unlike the trial version from Linuxant which
works at 14.4kbps.

The following PKGBUILD can be used to create an archlinux hsfmodem
package from the debian package:

    pkgname=hsfmodem
    pkgver=7.60.00.06oem
    pkgrel=1
    pkgdesc="Conexant modem driver by Dell"
    url="http://support.dell.com/"
    license=("unknown")
    arch=('i686')
    source=(${pkgname}_${pkgver}_i386.deb)
    md5sums=('80d38fccab347638fa7a2237b458b428')

    build() {
      cd $startdir/src/
      ar x ${pkgname}_${pkgver}_i386.deb
      tar xzf data.tar.gz
      cp -a usr etc $startdir/pkg/
    }

1.  Download and place hsfmodem_7.60.00.06oem_i386.deb and the PKGBUILD
    in a new folder, and run makepkg to create the package. See ABS for
    details on building packages.
2.  Run hsfconfig as root to build the module and initialise the modem.
    A reboot is required before the modem can be initialised. Run
    hsfconfig again after reboot.
3.  The modules are automatically loaded and a /dev/modem symlink is
    setup for use with the modem. Now use wvdial or other dialer
    programs to connect to the internet.

> Ricoh R5C822 SD/SDIO/MMC/MS/MSPro Card Reader

The Ricoh card reader should work out of the box, as long as
MOD_AUTOLOAD is set to yes in /etc/rc.conf. Assuming you use a HAL-aware
desktop (GNOME, KDE, etc.), when a memory card is inserted, the kernel
should automatically load the mmc_core/mmc_block modules and mount the
new filesystem according to your desktop's automount settings.

This has been confirmed with the following card types:

-   SD Card

> Synaptics Touchpad

The Synaptics touchpad should provide basic functions out-of-the-box,
however if you would like to use the scroll zones and enable other
advanced features, please refer to the Synaptics Touchpad wiki.

Power Management
----------------

> ACPI Hibernation/Suspend with pm-utils

The powersave scripts have been officially replaced by pm-utils. Refer
to the Pm-utils wiki for detailed instructions.

ATI video card owners might need to add vga=0 to the kernel options in
kernel parameters in order to resume from suspend2ram. This behavior
seems to change from version to version of catalyst, so your mileage may
vary. Try it without vga=0 first, and if it doesn't work then add it.

> CPU Frequency Scaling with cpufrequtils

Refer to the Cpufrequtils wiki for step-by-step instructions.

Multimedia Buttons & Fn Hotkeys
-------------------------------

Unfortunately, configuring multimedia buttons and function keys on your
laptop can be complicated process. Factors that must be taken into
consideration include your choice of Desktop Environment (or lack
thereof) and the actions you wish to bind to the special buttons or
keys. For a detailed explanation of what is required, please refer to
the Hotkeys wiki.

The following tips may offer some assistance in getting started.

> Multimedia Buttons

For the most part, the Volume and Playback buttons should be recognized
as an unassigned key by the Linux kernel. In which case, all that is
necessary is to bind the button to an action.

It is also worth noting that the multimedia buttons and equivalent Fn
key shortcut (e.g. Fn+PgUp = Vol Up) will produce the same keycode, so
if you configure the button, the Fn hotkey combo will execute the same
action.

GNOME

The GNOME desktop provides an easy method for binding multimedia keys to
their appropriate action.

1.  Browse to System -> Preferences -> Keyboard Shortcuts and scroll
    down to the Sound section.
2.  Click on an item (e.g. Mute) and then press the corresponding
    multimedia button
3.  Repeat this process for all of the multimedia buttons

The volume buttons should now work system-wide, and the playback buttons
will now work in media players such as Rhythmbox and Exaile.

Openbox and other Window Managers

The xbindkeys utility is highly recommended for lightweight desktops
such as Openbox--refer to the Hotkeys wiki for information.

The following is an example ~/.xbindkeysrc config file, making use of
the multimedia buttons:

    # vol up
    "amixer set Master 2dB+ unmute"
      m:0x10 + c:176
    # vol dn
    "amixer set Master 2dB- unmute"
      m:0x10 + c:174
    # vol mute/unmute
    "amixer set Master toggle"
      m:0x10 + c:160
    # play/pause
    "audacious -t"
      m:0x10 + c:162
    # back
    "audacious -r"
      m:0x10 + c:144
    # forward
    "audacious -f"
      m:0x10 + c:153
    # stop
    "audacious -s"
      m:0x10 + c:164

> Function (Fn) Hotkeys

Function keys seem to be less standardized than the Volume/Playback
buttons, and therefore it can be difficult to get all of them working
properly. For example, the Standby shortcut (Fn+ESC) may be recognized
while at the same time the Hibernate shortcut (Fn+F1) is not. To make
matters more confusing, it appears that some Fn keys such as those that
adjust the LCD brightness are controlled by the BIOS, independent of the
Operating System. Again, the Hotkeys wiki is highly recommended reading.

The following example shows how one can configure the Dell Media Direct
button, Eject (Fn+F10) and Hibernate (Fn+F1) hotkeys to execute specific
commands:

First, assign kernel keycodes to the Media Direct button and Fn hotkeys,
using the /etc/rc.local script (which is executed before X loads):

    #!/bin/bash
    #
    # /etc/rc.local: Local multi-user startup script.
    #
    setkeycodes e009 122	# e009 eject fn
    setkeycodes e012 130	# e012 mediadirect
    setkeycodes e00a 123	# e00a hibernate fn

Then use the xbindkeys utility to bind the newly recognized keys to a
custom action. Here's an ~/.xbindkeysrc config file:

    # media direct button
    "streamtuner"
      m:0x10 + c:134
    # eject function hotkey
    "eject"
      m:0x10 + c:210 
    # hibernate function hotkey
    "sudo /usr/sbin/pm-hibernate"
      m:0x10 + c:209

Finally, execute xbindkeys at startup by placing it in your .xinitrc (or
appropriate startup file for your environment):

    xscreensaver -no-splash &
    eval `cat $HOME/.fehbg` &
    xbindkeys &
    pypanel &
    exec openbox-session

As stated previously, it can be a complicated process involving lots of
trial & error troubleshooting, but hopefully this will help you get
started.

Other Resources
---------------

TuxMobil: Linux Laptop & Notebook Installation Guides

TuxMobil: DELL Notebooks

Gentoo Wiki: HARDWARE Dell Inspiron 6400

Gentoo Wiki: HARDWARE Dell Inspiron 6400 Fixes for common problems

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Inspiron_6400&oldid=302854"

Category:

-   Dell

-   This page was last modified on 2 March 2014, at 08:41.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
