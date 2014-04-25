IBM ThinkPad X60s
=================

Related articles

-   IBM ThinkPad X60
-   Lenovo Thinkpad X60 Tablet

The IBM Thinkpad X60s is a small light laptop with a Core Duo or Core 2
Duo processor and Intel Graphics. It has no internal optical drive. You
can see the specs at ThinkWiki, a wonderful resource with additional
information.

Contents
--------

-   1 Installation
-   2 Graphics
-   3 Ethernet
-   4 Wireless Networking
-   5 Special Keys
-   6 Suspend
    -   6.1 With pm-utils
    -   6.2 With uswsusp

Installation
------------

First note that this laptop is available with two different processors.

-   Core Duo

This processor requires the i686 (32-bit) version of Arch Linux. The two
RAM slots physically support 2x2GB=4GB RAM. However with a 32-bit kernel
only up to ~3GB will be accessible. Unfortunately due to a chipset
limitation, even compiling a kernel with the Physical Address Extension
(PAE) option (CONFIG_HIGHMEM64G) [1] will not allow access to more than
3GB.

-   Core 2 Duo

This processor can run the x86_64 (64-bit) version of Arch Linux, and
this is recommended in this case. The full 4GB RAM will be available
with the standard Arch x86_64 kernel.

A basic Arch Linux installation will do just fine for almost everything.
Select the i686 or x86_64 version as indicated above. Install from a USB
CD drive or a USB flash drive following the instructions in the
Beginners' guide.

It is easiest to do the initial installation with a wired ethernet
connection which you can set up in the installation menu. In the base
install package selection you can install the packages required for the
wireless networking

    [*] wireless-tools
    [*] iwlwifi-3945-ucode

Follow the Beginners' guide step by step to install sudo, add users, add
to groups, video card driver, then install Xorg, and a desktop
environment.

Graphics
--------

See Intel Graphics. The required driver is xf86-video-intel.

Ethernet
--------

Gigabit ethernet works out of the box with the e1000e kernel module.

Wireless Networking
-------------------

See Wireless network
configuration#iwl3945.2C_iwl4965_and_iwl5000-series.

Special Keys
------------

See http://www.thinkwiki.org/wiki/How_to_get_special_keys_to_work.

Suspend
-------

> With pm-utils

See the article on pm-utils. This works fine.

> With uswsusp

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Install s2ram (pacman -S uswsusp) and make these changes below. This set
of stuff is not well documented, but once I did this it was very smooth.

from
https://aur.archlinux.org/packages/uswsusp-fbsplash/uswsusp-fbsplash/uswsusp.install

If suspend to ram doesn't work, edit the whitelist.c.diff file to add
your machine to the s2ram whitelist with the appropriate methods, then
uncomment the line in the PKGBUILD where the patch is applied,
eventually add the md5sum of the resulting patch and finally rebuild the
package. Use 's2ram --identify' to identify your machine. Be sure to let
the suspend-devel list know!

The new Software Suspend does not use kernel parameters to determine the
suspend partition, instead it consults the /etc/suspend.conf file when
booting. You MUST edit this file before you update your initrd.

You will need to update your mkinitcpio.conf file to include the hook
uresume. Replace your 'resume' hook with 'uresume'. If you do not have a
resume hook the uresume hook must go before filesystems but after ide,
sata, and/or scsi. Do not get this wrong. Then rebuild the ramdisk with

    mkinitcpio -p linux

Note, when I do s2ram --identify This machine can be identified by:

       sys_vendor   = "LENOVO"
       sys_product  = "1702HFU"
       sys_version  = "ThinkPad X60s"
       bios_version = "7BETD3WW (2.14 )"

See http://suspend.sf.net/s2ram-support.html for details

It is highly reassuring to see that your system is recognised. If you do
not get recognised, there is a hal problem, and your earlier install is
not complete.

Next some file edits in policies.

1. As root edit /etc/acpi/actions/lm.lid.sh. Comment out everything, and
add:

    if grep closed /proc/acpi/button/lid/LID/state >/dev/null ; then
        # if the lid is now closed, save the network state and suspend to ram
        netcfg all-suspend
        pm-suspend
    else
        # if the lid is now open, restore the network state.
        # (if we are running, a wakeup has already occurred!)
        netcfg all-resume
    fi

You should now have suspend working.

Another quirky thing is a hal error on shutdown preventing linux from
turning the machine off. From
https://lists.ubuntu.com/archives/xubuntu-users/2009-June/001783.html I
got this patch to /etc/PolicyKit/PolicyKit.conf

    <config version="0.1">
    <match action="org.freedesktop.hal.storage.mount-removable">
    <return result="yes"/>
    </match>
    <match action="org.freedesktop.hal.power-management.shutdown">
    <return result="yes"/>
    </match>
    <match action="org.freedesktop.hal.power-management.reboot">
    <return result="yes"/>
    </match>
    </config>

This file was blank but by adding the above, shutdown is now down by
linux. I need to study policykit and hal. This is unclear, but my sense
is that PolicyKit.conf is no longer used and a better fix is required in
either /etc/acpi or /etc/hal.

Retrieved from
"https://wiki.archlinux.org/index.php?title=IBM_ThinkPad_X60s&oldid=298158"

Category:

-   IBM

-   This page was last modified on 16 February 2014, at 07:21.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
