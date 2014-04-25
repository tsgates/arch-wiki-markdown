Lenovo IdeaPad U330p
====================

  

Contents
--------

-   1 Overview
-   2 Hardware
-   3 Installation
    -   3.1 Preparing the installation medium
    -   3.2 BIOS setup
    -   3.3 Disable KMS
    -   3.4 Disk partitions
    -   3.5 Sound card
    -   3.6 Video driver
    -   3.7 Touchpad
    -   3.8 Desktop environment
-   4 Troubleshooting
    -   4.1 Use of headphones
    -   4.2 Network connectivity/latency

Overview
--------

There are no major issues with Lenovo U330p. Everything works.

This page contains just some comments that may be useful during
installation or troubleshooting.

Hardware
--------

The unit used for testing contained the following hardware:

-   Intel Core i5-4200U Processor

-   Intel HD Graphics 4400

-   Atheros AR9462 Wireless Network Adapter

-   A thin Seagate 500GB hybrid drive (i.e. 500GB HDD + 8GB SSD).

Installation
------------

The best way to ensure that Arch Linux is correctly installed is to
follow the Beginners' guide step by step.

> Preparing the installation medium

Use another machine to download the latest image from the Download page
and burn the ISO image into a USB stick by following the instructions in
USB Installation Media.

> BIOS setup

Before booting with the USB stick, enter the BIOS in order to prepare
the machine for the new OS. For that purpose, press the small button on
the side panel next to the HDMI port. A boot menu will appear. Select
"BIOS Setup", and then:

-   In the "Security" menu, disable "Secure Boot" (although Arch Linux
    can be configured to work with secure boot, this will probably spare
    you a few issues during installation).

-   In the "Boot" menu, leave "Boot Mode" set to "UEFI", and "USB Boot"
    enabled.

-   In the "Exit" menu, set "OS Optimized Defaults" to "Other OS". Exit
    by saving changes.

> Disable KMS

To avoid getting a blank screen during installation, you should disable
KMS (Kernel mode setting). This can be done as follows: when booting
from the USB stick, on the Arch Linux boot menu, press e and then type
nomodeset. Finally, press enter to boot without KMS.

> Disk partitions

Use cgdisk to create the disk partitions, as explained in the Beginners'
guide.

If the machine will be running Arch Linux only, then:

-   Create a first partition of at least 100MB (specify size: 100M) for
    UEFI. The partition should be of type ef00.

-   Create a second partition that takes up all of the remaining disk
    space. The partition should be of type 8300.

-   There is no need for a separate swap partition. Instead, create a
    swap file as explained in Swap.

Format the partitions as explained in the Beginners' guide.

> Sound card

Set the default sound card by creating an alsa-base.conf file in
/etc/modprobe.d/:

    # nano /etc/modprobe.d/alsa-base.conf

    options snd_hda_intel index=1

and then reboot.

Install alsa-utils and run alsamixer to unmute the channels, as
described here.

> Video driver

Use xf86-video-intel. This is the correct driver for the hardware and it
is being developed with the support of Intel.

At the time of this writing (Dec. 2013), Intel has just released
extensive information about this graphics hardware.

> Touchpad

Install xf86-input-synaptics as explained in the Beginners' guide.

This will make sure that the touchpad works correctly and will also
provide two-finger scrolling.

> Desktop environment

Despite general criticism, GNOME 3 is an excellent choice. It can be
installed smoothly (see GNOME) and provides a very productive work
environment.

For example, the Windows key takes you to the dashboard, where you can
type to search for applications and use scrolling to move across
workspaces. You can also tile windows on the screen easily, either by
moving them to an edge of the screen or by using a combination of the
Windows key with an arrow key.

Useful GNOME extensions:

-   Audio Output Switcher

-   TaskBar

-   TopIcons

How to show date next to the clock:

-   Run dconf-editor and open org>gnome>desktop>interface. Select
    clock-show-date.

How to make thunderbird the default calendar:

-   Edit /usr/share/applications/thunderbird.desktop and append
    text/calendar;text/x-vcard; to MimeType. Then run
    sudo update-desktop-database. Finally, open GNOME Settings > Details
    > Default Applications and change Calendar.

Troubleshooting
---------------

> Use of headphones

If you use headphones often and you shutdown the machine with the
headphones plugged in, it may happen that in the next reboots the sound
is directed to the headphones by default, even when the headphones are
not plugged in.

To fix this issue:

-   Plug the headphones in and out. The sound should now be directed to
    the speakers.

-   Install and run pavucontrol once (you don't have to do anything,
    just open it, browse through the different tabs, and close it).

-   Reboot the machine (ensuring that the headphones are not plugged
    in). The sound should now be directed back to the speakers by
    default.

> Network connectivity/latency

When using NetworkManager, it appears that wireless networking is not as
responsive as it could or should be. For example, there is a noticeable
lag when trying to acess some websites that should open immediately
(e.g. Google, YouTube, etc.)

On the Web, there are several reports of connectivity/latency problems
with this particular hardware (Atheros AR9462). However, some testing
with Wicd seems to indicate that the network adapter is working fine.

There are some things that can be tried to alleviate this problem:

-   Disable IPv6 in NetworkManager. Go to Wi-Fi settings and turn off
    IPv6 for each wireless network that you connect to.

-   Create an ath9k.conf file to specify the option nohwcrypt=1:

    # sudo nano /etc/modprobe.d/ath9k.conf

    options ath9k nohwcrypt=1

and then reboot.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_IdeaPad_U330p&oldid=302205"

Category:

-   Lenovo

-   This page was last modified on 26 February 2014, at 13:26.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
