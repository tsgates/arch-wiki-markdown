Broadcom wireless
=================

Contents
--------

-   1 Introduction
-   2 Determine which driver you need/can use
-   3 Getting the driver
    -   3.1 brcmsmac/brcmfmac
    -   3.2 b43/b43legacy
        -   3.2.1 Loading the b43/b43legacy kernel module
    -   3.3 broadcom-wl
        -   3.3.1 Loading the wl kernel module
-   4 Troubleshooting
    -   4.1 Wi-Fi card does not seem to even exist
    -   4.2 Wi-Fi card does not work or show up after kernel upgrade
        (brcmsmac)
    -   4.3 Wi-Fi card does not work/show up (broadcom-wl)
    -   4.4 Interfaces swapped (broadcom-wl)
    -   4.5 The b43 driver and Linux 3.8+
    -   4.6 Suppressing console messages
    -   4.7 Miscellaneous user notes

Introduction
------------

Broadcom has been notorious in its support for its Wi-Fi cards on
GNU/Linux. Until recently, most Broadcom chips were either entirely
unsupported or required the user to tinker with firmware. A limited set
of wireless chips were supported by various reverse-engineered drivers
(brcm4xxx, b43, etc.). The reverse-engineered b43 drivers have been in
the kernel since 2.6.24.

In August 2008, Broadcom released the 802.11 Linux STA driver officially
supporting Broadcom wireless hardware on GNU/Linux. These are
restrictively licensed drivers, but Broadcom promised to work towards a
more open approach in the future. Further, they do not work with hidden
ESSIDs.

In September 2010, Broadcom finally released fully open source drivers
for its hardware. This driver, brcm80211, has been included into the
kernel since 2.6.37. With the release of 2.6.39, these drivers have been
renamed to brcmsmac and brcmfmac.

At the time of writing, there are three choices for users with Broadcom
Wi-Fi chipsets:

  Driver              Description
  ------------------- ----------------------------------
  brcmsmac/brcmfmac   Open-source kernel driver
  b43                 Reverse-engineered kernel driver
  broadcom-wl         Proprietary Broadcom STA driver

Determine which driver you need/can use
---------------------------------------

First, determine your card's PCI-ID. Type the following (case-sensitive)
command into a console:

    $ lspci -vnn | grep 14e4:

Then check your card against this list of supported b43 devices and this
list of supported brcm80211 devices.

Getting the driver
------------------

> brcmsmac/brcmfmac

The brcm80211 drivers are included in the kernel. They are named
brcmsmac for PCI cards and brcmfmac for SDIO devices.

These drivers should be automatically loaded during start-up and no
further action should be required of the user. If the driver does not
load automatically, simply load it manually.

Note:Since linux>=3.3.1, the brcmsmac driver depends on the bcma module;
therefore, make sure the bcma module is not blacklisted.

Note:wireless.kernel.org states that brcm80211 does not support older
PCI/PCI-E chips with SSB backplane.

> b43/b43legacy

The drivers are included in the kernel since 2.6.24.

Loading the b43/b43legacy kernel module

Verify which module you need by looking up your device here. You can
also check by computer model here. Blacklist the other module (either
b43 or b43legacy) to prevent possible problems/confusion. For
instructions, see Kernel_modules#Blacklisting.

Install the appropriate b43-firmware or b43-firmware-legacy package from
the AUR.

You can now configure your device.

Note:If the b43 module appears to be loaded and functional but the
device is inaccessible, you may need to blacklist the bcma module. See
Section 4.1. If that does not help, you might have to recompile the
kernel with the CONFIG_B43_BCMA_EXTRA option set to use b43. This option
was introduced to avoid race conditions between the modules and is at
least needed for cards with the BCM4322, BCM43224 and BCM43225 chipsets.

> broadcom-wl

Warning:Even though this driver has matured a lot throughout the years
and works quite well now, its usage is recommended only when neither of
the two open-source drivers support your device. Please refer to project
b43's page for list of supported devices.

For users of the broadcom-wl driver, there is a PKGBUILD available in
the AUR named broadcom-wl. There is also a newer version available
(supporting more recent cards), see broadcom-wl-dkms.

Loading the wl kernel module

The wl module may need to be manually loaded if there are other usable
modules present. Before loading the wl module, remove the b43 or other
module that may have been automatically loaded instead:

    # rmmod b43

Also unload ssb, if loaded:

    # rmmod ssb

Note:Failure to unload ssb may result in the wireless interface not
being created.

Load the wl module

    # modprobe wl

The wl module should automatically load lib80211 or lib80211_crypt_tkip.
Check with lsmod to see if this is the case. If not, you may need to add
one of those two modules as well.

    # modprobe lib80211

or

    # modprobe lib80211_crypt_tkip

If you installed the driver directly from Broadcom, you may also need to
update the dependencies:

    # depmod -a

To make the module load at boot, refer to Kernel modules.

You can also blacklist other modules (to prevent them from interfering)
in /etc/modprobe.d/modprobe.conf. To blacklist a module, refer to Kernel
modules#Blacklisting.

Note:Broadcom Corporation BCM4311 802.11b/g WLAN [14e4:4311] does not
work with blacklisting b43 and ssb.

Troubleshooting
---------------

> Wi-Fi card does not seem to even exist

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: no solution      
                           provided (Discuss)       
  ------------------------ ------------------------ ------------------------

Some users with newer cards like the Broadcom BCM43241 will experience
an issue where lspci or lsusb will not show any trace of the card. A
solution to this will be posted when found.

> Wi-Fi card does not work or show up after kernel upgrade (brcmsmac)

This is caused by the kernel using the bcma module instead of the
brcmsmac module. The solution is to blacklist the bcma module. For
instructions, see Kernel_modules#Blacklisting.

Note:This affects only Linux kernels 3.0, 3.1, and 3.2. Since kernel
3.3, the brcmsmac module actually uses bcma, so bcma needs to be
unblacklisted or the Wi-Fi interface will not appear.

> Wi-Fi card does not work/show up (broadcom-wl)

Check if you are loading the correct modules. You may need to blacklist
the brcm80211, b43, and ssb kernel modules to prevent them from loading
automatically. For instructions, see Kernel_modules#Blacklisting.

Note:You may not have to blacklist the brcm80211 driver; although as of
2011-06-20, it will still default to loading the brcm80211 module before
the wl driver, which prevents wl from being used.

Check if you updated your module dependencies:

    # depmod -a

-   Verify that your wireless interface(s) appear using ip addr.
-   You may need to restart your machine to see the device appear in
    iwconfig or ip addr.
-   If you have recently upgraded your kernel, you need to rebuild the
    broadcom-wl package with the new kernel installed to update the
    module.

> Interfaces swapped (broadcom-wl)

Users of the broadcom-wl driver may find their Ethernet and Wi-Fi
interfaces have been swapped. See Network configuration#Device_names for
solution.

> The b43 driver and Linux 3.8+

The b43 driver has some major issues starting with the release of Linux
3.8+, namely that you are unable to see / connect to some access points.

Solution: Try the latest broadcom-wl driver (version 6+), see above.

> Suppressing console messages

You may continuously get some verbose and annoying messages during the
boot, similar to

    phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
    phy0: brcms_ops_bss_info_changed: qos enabled: false (implement)
    phy0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 1 (implement)
    enabled, active

These do not seem to be suppressible via normal means, such as setting
MaxLevelConsole in /etc/systemd/journald.conf. To hide them, you must
lower the level at which dmesg messages are printed to the console. This
can be done on start-up by creating a simple systemd service.

Create a file in /etc/systemd/system/ called brcms_suppression.service
or something similar:

    brcms_suppression.service


    [Unit]
    Description=Broadcom console message suppression script

    [Service]
    Type=oneshot
    RemainAfterExit=yes
    ExecStart=/bin/sh -c 'dmesg -n 3'

    [Install]
    WantedBy=multi-user.target

Like all other systemd services, you can then enable it with

    # systemctl enable brcms_suppression

> Miscellaneous user notes

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: This section     
                           must be rewritten        
                           impersonally, very       
                           likely as a FAQ or       
                           Troubleshooting section  
                           (also remove or update   
                           out-of-date              
                           information). See also   
                           Help:Style. (Discuss)    
  ------------------------ ------------------------ ------------------------

-   In my Dell Inspiron Laptop, I have a Broadcom BCM4401 Ethernet card
    and a Broadcom BCM4328 wireless card. If I just remove b43, I can
    load the wl driver, but no wireless card shows up. However, if I
    first remove the b44 (and ssb) driver for my Ethernet card, and then
    load the wl driver, I get a wireless device using the name eth0.
    Afterwards, I can load b44 again, to have an Ethernet eth1 device.

-   I could not get the BCM4313 chip on a Lenovo B560 to work before
    following these steps:
    1.  "Load defaults" in the BIOS. After that, the wireless was
        working under MS Windows. There are not many options in there,
        so I do not know what the reset may have changed, but it did the
        trick.
    2.  Blacklist the acer_wmi module. For testing, you can add the
        following to the kernel line in GRUB: acer_wmi.disable=1

-   I have found that to get the wl drivers working for the Broadcom
    4313 chip, you need to blacklist brcm80211 along with b43 and ssb.

--Admiralspark, 20 June 2011

-   If you notice slow wireless speeds when your laptop/netbook is not
    connected to AC power, you may need to disable Wi-Fi power
    management by adding the following line (assuming wlan0 is your
    wireless device) iwconfig wlan0 power off to /etc/rc.local and
    create an empty file /etc/pm/power.d/wireless. In case you also
    experience interface swapping (discussed above), you might want to
    add another line for the second interface name as well. The command
    will have no effect on the wired interface.

--Tom.yan, 16 August 2011

-   In my case on a HP pavilion netbook DM1 with a BCM4313 chip, with
    the original kernel brcmsmac driver, the LED didn't work, the power
    was awful, and it kept loosing the signal all the time, unless very
    close to the Wi-Fi hotspot. The last Broadcom driver wl solved
    everything. So in some cases, it's actually better than the kernel
    driver. However, I had to install it in the initramfs image, along
    with lib80211 and lib80211_crypt_tkip to avoid a recurring kernel
    panic.

--Ivanoff, 18 March 2012 *Edit* It's all solved with the latest kernel
versions. --Ivanoff (talk) 14:19, 14 December 2013 (UTC)

-   On a similar HP DM1 netbook I found the brcmsmac driver did not work
    either. The kernel panic can also be solved by blacklisting the
    brcmsmac, b43 and wl drivers. In rc.local you can modprobe wl
    without problems. On a sidenote: I get hard lockups, without any way
    to debug because there is nothing in kernel.log. Not sure if related
    to the wl driver though.

--Wilco, 5 May 2012

-   Likewise, my HP Pavilion g7-1374ca also had problems with stock
    kernel drivers. I downloaded Broadcom tarball, but it wouldn't
    compile in 3.4.3. I removed the #include <asm/system.h> line and
    commented out a line referencing .ndo_set_multicast_list (there's
    only one). Then I was able to compile and load the module for a 100%
    strength signal, no lockups so far.

-   On a Dell Inspiron N5110 with BCM4313, when the wireless was
    hardware-off, the system would always hang at boot with the kernel
    brcmsmac driver. Using the broadcom-wl driver the problem was
    solved.

--Nplatis, 14 October 2012

-   On a Dell M4700 with BCM4313 got hideously slow "performance" with
    default driver -- switched to broadcom-wl and got near advertised
    link rate speed (65 to 72 Mb/sec)...until restarting, then was not
    able to associate with wireless access point. The solution was to
    blacklist the kernel modules dell_wmi and cfg80211.

--virtualeyes, 23 February 2013

-   On a Lenovo G580 mounting a BCM4313 the proprietary driver module
    kept crashing because some dependencies were unsatisfied (the same
    problem found by Ivanoff). What worked for me was to put a file in
    /etc/modprobe.d/ with the following content:

    /etc/modprobe.d/10_wl.conf

    blacklist brcmsmac
    blacklist bcma
    softdep wl pre: lib80211_crypt_tkip lib80211_crypt_ccmp lib80211_crypt_wep

--zarel, 21 June 2013

Retrieved from
"https://wiki.archlinux.org/index.php?title=Broadcom_wireless&oldid=304779"

Category:

-   Wireless Networking

-   This page was last modified on 16 March 2014, at 07:16.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
