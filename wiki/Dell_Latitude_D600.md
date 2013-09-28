Dell Latitude D600
==================

The Dell Latitude D600 was released on 3/12/03. At the time of its
release it was met with great reviews. Despite being almost 5 years old
this business laptop is perfectly capable of delivering a satisfying
Linux experience.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Documentation                                                      |
| -   3 Hardware                                                           |
|     -   3.1 Working                                                      |
|     -   3.2 Untested                                                     |
|                                                                          |
| -   4 Post-Installation                                                  |
|     -   4.1 Wireless                                                     |
|         -   4.1.1 Intel PRO Wireless 2200                                |
|         -   4.1.2 Broadcom BCM4306 rev 2                                 |
|                                                                          |
|     -   4.2 CPU Scaling                                                  |
|     -   4.3 Suspend to Ram                                               |
|     -   4.4 Video Card                                                   |
+--------------------------------------------------------------------------+

Introduction
------------

This is not a guide on how to install Arch (for help with that see the
installation guide), but rather an attempt to cover the steps of how to
take full advantage of the laptop's hardware. Despite being an Arch-wiki
page, everything explained here should apply to other Linux
distributions as well.

Getting most of the hardware to work correctly under Linux, is not
overly difficult (in fact these days most things are auto-detected, and
"just work"TM. Keep in mind I am by no means an expert of hardware in
Linux so you may find better solutions than the ones presented here. If
you do please edit this guide so that other people may benefit as well.

Documentation
-------------

As always the documentation for a Dell laptop is almost non-existant.
The only documentation you are going to find for the d600 is the spec
sheet and some useless pdf files (although the service guide can be
useful if you need to take the laptop apart for some reason). So with
that being said the only way to find out useful information is to
inspect each individual hardware component.

Hardware
========

> Working

-   Pentium M, with CPU frequency scaling
-   ATI Mobility Radeon 9000, including framebuffer (open source radeon
    driver)
-   Wireless card:
    -   Intel 2200 Pro/Wireless Lan card (ipw2200 driver)
    -   Broadcom BCM4306 rev2 Wireless card (b43legacy driver)

-   Sigmatel STAC9750 audio (including mixing with alsa)
-   Function/audio keys
-   Alps Touchpad and pointing stick (synaptics driver)
-   O2Media PCMCIA slot
-   CD/RW, DVD+/-RW
-   Broadcom BCM5702 ethernet card
-   Hardware monitoring (i8k kernel module, hddtemp)

> Untested

-   IRDA
-   Modem
-   ACPI Sleep States

Post-Installation
=================

Wireless
--------

The D600 comes with either an Intel Pro Wireless 2200 or a Broadcom
BCM4306 rev 2. Both cards work flawlessly with their ipw2200 or
b43legacy drivers, respectively.

> Intel PRO Wireless 2200

As the driver is already included in the kernel the only thing that
needs to be done is to install the firmware.

    # pacman -S ipw2200-fw

Now add the entry ipw2200 in the modules section of /etc/rc.conf, and
add/change the line NET_PROFILES=(main). Now make a main network-profile
in /etc/network-profilefollowing the template in that directory. It will
look something like the following.

    /etc/network-profile/main

    # Network Profile
    DESCRIPTION="Default Network Profile"

    # Network Settings
    INTERFACE=eth1
    HOSTNAME=home

    # Wireless Settings (optional)
    ESSID=Router
    IWOPTS="dhcp $ESSID"
    #WIFI_INTERFACE=wlan0   # use this if you have a special wireless interface
                            # that is linked to the real $INTERFACE
    WIFI_WAIT=2            # seconds to wait for the wireless card to

If you run into the strange problem of your wireless interface switching
between eth0 and eth1 at boot then you may want to use nameif. Simply
put your network id followed by the mac address in /etc/mactab.

    eth0 00:0C:DB:E8:38:5A
    wlan0 00:1F:12:62:2E:CC

(Taken from here.) In addition, a small change to /etc/rc.d/network is
necessary to run the nameif command prior to configuring the interfaces.
The following excerpt from /etc/rc.d/network shows the lines that need
to be added. This change simply checks for the existance of the
/etc/mactab file and if it exists executes nameif to assign interface
names.

                  stat_busy "Starting Network"
                  error=0
                  ##### begin nameif change #####
                  # set names
                  if [ -n /etc/mactab ]; then
                    /sbin/nameif
                  fi
                  ##### end nameif change #####
                  # bring up bridge interfaces
                  bridge_up
                  # bring up ethernet interfaces

> Broadcom BCM4306 rev 2

Not long ago, Broadcom cards used to be a nightmare under Linux, until
the b43 drivers came along. The b43 and b43legacy drivers are included
in the kernel, so as with the Intel card, we just need to get the
firmware for it.

If you have an Ethernet connection, install b43-fwcutter from pacman,
like so:

     # pacman -S b43-fwcutter

If not, download the b43-fwcutter tarball and compile it:

     wget http://bu3sch.de/b43/fwcutter/b43-fwcutter-015.tar.bz2
     tar xjf b43-fwcutter-015.tar.bz2
     cd b43-fwcutter-015
     make
     sudo make install
     cd ..

Next, you'll need to download the following two files:

-   http://mirror2.openwrt.org/sources/broadcom-wl-4.150.10.5.tar.bz2  
-   http://downloads.openwrt.org/sources/wl_apsta-3.130.20.0.o

And use b43-fwcutter to install the firmware files. Note that the latter
two commands require a root shell.

     $ tar xfvj broadcom-wl-4.150.10.5.tar.bz2
     # b43-fwcutter -w /lib/firmware wl_apsta-3.130.20.0.o
     # b43-fwcutter --unsupported -w /lib/firmware broadcom-wl-4.150.10.5/driver/wl_apsta_mimo.o

Since this card uses the b43legacy driver, we'll blacklist and remove
the b43 driver just in case.

     # modprobe -r b43
     # echo "blacklist b43" >> /etc/modprobe.d/modprobe.conf

Finally, load the b43legacy driver:

     # modprobe b43legacy

Once the firmware is installed, NetworkManager and Wicd both handle the
card flawlessly. I haven't tested any other connection managers, but
those are the two most popular.

CPU Scaling
-----------

See CPU Frequency Scaling.

Some BIOS revisions don't work properly with acpi-cpufreq, likely due to
the driver being buggy or incorrect DSDT tables. There isn't a fix for
this that I know of yet.

Suspend to Ram
--------------

There is a serious problem with KMS in the radeon driver that prevents
normal wake-up from sleep mode with this laptop. Bug reports have been
filed at kernel.org, redhat.com, and launchpad.org. Currently, there are
no known fixes, but there is a workaround: set a primary password in the
BIOS. The BIOS will initialize the video card on wake-up to ask for the
password, and then Linux will resume normally.

This is easily accomplished by installing uswsusp from AUR. Contrary to
the ominous output from pacman no additional configuration is needed.
Additionally, s2ram will probably output an error message saying that
This machine can only suspend without framebuffer. but I have not
encountered problems with resuming from suspend.

    # s2ram -i

    This machine can be identified by:
         sys_vendor   = "Dell Computer Corporation"
         sys_product  = "Latitude D600                   "
         sys_version  = ""
         bios_version = "A16"

    # s2ram -f

Video Card
----------

Use the open source "xf86-video-ati" radeon driver. ATI dropped support
for the Radeon (RV250) Mobility FireGL 9000 after catalyst driver
version 8.28.8.

The xf86-video-ati package is available in the Extra repository.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Latitude_D600&oldid=238843"

Category:

-   Dell
