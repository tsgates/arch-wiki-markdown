Dell Latitude D600
==================

The Dell Latitude D600 was released on 3/12/2003. Despite its age, it
can prove to be quite a capable machine. With a couple exceptions, Linux
support for the D600 is outstanding. Most of its components work
automatically with Arch.

Contents
--------

-   1 Hardware
    -   1.1 Working
    -   1.2 Untested
-   2 Post-Installation
    -   2.1 Wireless
        -   2.1.1 Intel PRO Wireless 2200
        -   2.1.2 Broadcom BCM4306 rev 2
    -   2.2 Trackpad
    -   2.3 CPU Scaling
    -   2.4 Resuming from sleep
    -   2.5 Video Card

Hardware
========

> Working

-   Intel Pentium-M, with CPU frequency scaling
-   ATI Mobility Radeon 9000 (radeon driver)
-   Wireless card:
    -   Intel 2200 Pro/Wireless Lan card (ipw2200 driver)
    -   Broadcom BCM4306 rev2 Wireless card (b43legacy driver)
-   Sigmatel STAC9750 AC'97 audio
-   Fn key combos and audio buttons
-   Alps DualPoint trackpad and pointing stick (synaptics driver)
-   O2Media PCMCIA slot
-   CD/RW, DVD+/-RW
-   Broadcom BCM5702 gigabit ethernet (tg3 driver)
-   Hardware monitoring (i8k kernel module, hddtemp)
-   Sleep and resume (see Resuming from sleep section)

> Untested

-   IRDA
-   Conexant V.56 modem (probably works)

Post-Installation
=================

Wireless
--------

The D600 comes with either an Intel Pro Wireless 2200 or a Broadcom
BCM4306 rev 2. Both are supported natively.

> Intel PRO Wireless 2200

As the driver is already included in the kernel the only thing that
needs to be done is to install the firmware.

    # pacman -S ipw2200-fw

> Broadcom BCM4306 rev 2

The b43legacy driver is included in the kernel, so as with the Intel
card, we just need to get the firmware for it.

You'll need to download the following two firmware files:

-   http://mirror2.openwrt.org/sources/broadcom-wl-4.150.10.5.tar.bz2  
-   http://downloads.openwrt.org/sources/wl_apsta-3.130.20.0.o

And use b43-fwcutter to install the firmware files.

     $ tar xfvj broadcom-wl-4.150.10.5.tar.bz2
     # b43-fwcutter -w /lib/firmware wl_apsta-3.130.20.0.o
     # b43-fwcutter --unsupported -w /lib/firmware broadcom-wl-4.150.10.5/driver/wl_apsta_mimo.o

It would be bad if udev were to load the b43 driver, as it would
conflict with b43legacy, so let's go ahead and blacklist it:

     # modprobe -r b43
     # echo "blacklist b43" >> /etc/modprobe.d/modprobe.conf

Finally, load the b43legacy driver:

     # modprobe b43legacy

Trackpad
--------

The trackpad and pointing stick are supported out-of-the-box, but to
enable certain features, such as tap-to-click or edge scrolling, you'll
need to write some Xorg configuration files.

Open your favorite text editor to the following file:

     /etc/X11/xorg.conf.d/10-evdev.conf

Comment out every line in the section referring to touchpads. It should
look like this when you're done:

     #Section "InputClass"
     #        Identifier "evdev touchpad catchall"
     #        MatchIsTouchpad "on"
     #        MatchDevicePath "/dev/input/event*"
     #        Driver "evdev"
     #EndSection

Next, you'll want to create a configuration file for your trackpad. The
following is a good starting point. You can add more Synaptics config
options if you'd like.

    /etc/X11/xorg.conf.d/10-synaptics.conf

    Section "InputClass"
       Driver      "synaptics"
       Identifier  "touchpad catchall"
       MatchDevicePath      "/dev/input/event*"
       MatchIsTouchpad      "on"
       Option "VertEdgeScroll" "on"
       Option "HorizEdgeScroll" "on"
       Option "TapButton1"  "1"
    EndSection

Finally, restart X, and your trackpad should be fully functional!

CPU Scaling
-----------

See CPU Frequency Scaling. All Pentium-M CPUs support Enhanced Intel
SpeedStep, so you'll need the acpi-cpufreq driver.

Some BIOS revisions don't work properly with acpi-cpufreq, likely due to
the driver being buggy or incorrect DSDT tables. If you're experiencing
problems, flash your BIOS to A16 (the latest version.)

Resuming from sleep
-------------------

There is a serious problem with KMS in the radeon driver that prevents
normal resume from sleep mode with this laptop. This will remain unfixed
for the foreseeable future. (see: Redhat Bugzilla #531825) Setting
AGPMode=1 on the kernel boot line will workaround the issue. Another
workaround, which works with varying degrees of success, is to set a
primary password in the BIOS.

Video Card
----------

Use the open source xf86-video-ati radeon driver, available in the extra
repository. ATI dropped support for the Radeon (RV250) Mobility FireGL
9000 after catalyst driver version 8.28.8.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Latitude_D600&oldid=303165"

Category:

-   Dell

-   This page was last modified on 4 March 2014, at 20:28.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
