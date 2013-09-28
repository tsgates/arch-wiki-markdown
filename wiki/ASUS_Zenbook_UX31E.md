ASUS Zenbook UX31E
==================

This page contains instructions, tips, pointers, and links for
installing and configuring Arch Linux on the ASUS Zenbook UX31E
Ultrabook. (There is probably little/no difference with his 11" little
brother, the UX21E)

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation issues                                                |
| -   2 Compatibility                                                      |
|     -   2.1 Touch Pad                                                    |
|         -   2.1.1 Elantec Touch pads                                     |
|         -   2.1.2 Sentelic Touchpads                                     |
|             -   2.1.2.1 ReubenBond                                       |
|             -   2.1.2.2 Saaros                                           |
|                                                                          |
|     -   2.2 Graphics                                                     |
|         -   2.2.1 HDMI Out                                               |
|         -   2.2.2 Colour Profiles                                        |
|                                                                          |
|     -   2.3 Networking                                                   |
|         -   2.3.1 Wireless                                               |
|             -   2.3.1.1 Unstable Wireless when using Network Manager     |
|                                                                          |
|         -   2.3.2 Ethernet - Asix AX88772 USB Ethernet                   |
|                                                                          |
|     -   2.4 Solid State Drive                                            |
|                                                                          |
| -   3 Power Management                                                   |
|     -   3.1 Suspend to RAM                                               |
|     -   3.2 PCIe ASPM                                                    |
|     -   3.3 i915                                                         |
|     -   3.4 Additional powersavings                                      |
|                                                                          |
| -   4 Additional resources                                               |
+--------------------------------------------------------------------------+

Installation issues
-------------------

If you get an error trying to format partitions when installing Arch try
adding this line to the kernel parameters

    libata.dma=0

Compatibility
-------------

> Touch Pad

There are different versions of the UX31, some have Sentelic and some
have Elantec - Touch pads.

Elantec Touch pads

Touch & Scroll works out of the box. Clickpad functionality does not.
(However, using two and three finger touches for right an middle click
works fine).

If higher pressure must be applied to your touchpad in order to function
properly, tweak the following properties according to your needs [1]

    synclient FingerLow=5
    synclient FingerHigh=15

Alternatively, edit your /etc/X11/xorg.conf.d/10-synaptics.conf

    Section "InputClass"
           Identifier "touchpad catchall"
           Driver "synaptics"
           MatchIsTouchpad "on"
           MatchDevicePath "/dev/input/event*"
           Option "TapButton1" "1"
           Option "TapButton2" "3"
           Option "TapButton3" "2"
           Option "VertTwoFingerScroll" "1"
           Option "HorizTwoFingerScroll" "1"
           Option "FingerLow" "5"
           Option "FingerHigh" "15"
    EndSection

Tip:Multifinger taps: Two finger for middle click; three fingers for
right click.

Sentelic Touchpads

The Sentelic Touchpad drivers have been added to the 3.2 kernel, so it
should work out of the box by now. Since 3.4 this supports scrolling and
multi-touch features. (In case of problems with the touchpad after
resume see Suspend to RAM.) However it seems that two finger tapping and
two finger scrolling are incompatible. To have both working you must use
one of the following two patches.

ReubenBond

ReubenBond has made contact with a sentelic representative who has
provided him with official documentation on putting the device into
absolute positioning mode. The latter can be accessed here:
http://fsp-lnxdrv.svn.sourceforge.net/viewvc/fsp-lnxdrv/trunk/doc/fsp_packet.txt?revision=43&view=markup

This looks very promising and ReubenBond is committed to developing a
driver in the next few weeks. This is all referenced in the forum
https://bbs.archlinux.org/viewtopic.php?id=125262&p=2

Saaros

Saaros's driver works well for two finger and side scrolling and is
fairly straight forward to apply and build. Unfortunately however, it
does slightly impede normal functionality, pointing does not seem quite
as accurate, tapping does not seem quite as sensitive and tapping and
dragging/selecting can be quite tricky. This code should eventually be
accepted into the official kernel:
https://github.com/saaros/sentelic/issues/2.

> Graphics

Works out of the box

HDMI Out

There seems to be an issue whereby having an HDMI device plugged in at
boot results in the screens being switched and also the laptop screen
not coming on. To make this more bearable you can automate switching
HDMI on with the following udev rule and script:

    ACTION=="change", SUBSYSTEM=="drm", RUN+="/usr/sbin/hdmi-plugged"

    #!/bin/bash

    export XAUTHORITY=/home/$USER/.Xauthority
    export DISPLAY=:0

    /usr/bin/xrandr -display :0 --output eDP1 --auto --output HDMI1 --auto --above eDP1

Colour Profiles

Colour accuracy on the Zenbook is not very good. There is a UX31E ICC
profile on the Noteboocheck review. However, I find that too green using
xcalib and so use the UX21E version.

> Networking

Warning:NetworkManager generally fails to work for one reason or another
on the UX31E. Consider using an alternative such as netctl.

Wireless

Works fine with the ath9k driver, included in the kernel since 2.6.27.

Warning:Do not forget to install the wireless_tools and wpa_supplicant
packages during the installation since you will get stuck with no
internet access if you do not!

Unstable Wireless when using Network Manager

Some users experience connection drops when using wireless. For some
users this can be fixed by setting the wireless connection's BSSID
(usually the router's MAC address). This only works if your wireless
connection only has one access point as the BSSID is unique for each
access point.

An alternative solution is to disable the ath9k driver ani feature, to
do this use the following :
echo 1 > /sys/kernel/debug/ieee80211/phy0/ath9k/disable_ani

Ethernet - Asix AX88772 USB Ethernet

The Asix AX887722 USB Ethernet drivers are included in the kernel, so it
should work out of the box.

> Solid State Drive

Check Solid_State_Drives

Power Management
----------------

> Suspend to RAM

The USB modules must be unloaded or the laptop will not come out of
sleep mode.

Put

    SUSPEND_MODULES="xhci_hcd ehci_hcd uhci_hcd"

in

    /etc/pm/config.d/unload_module

If you have patched the kernel to enable multitouch with the Sentelic
touchpad, the touchpad may stop working after resume. In this case add
the psmouse module to the list.

    SUSPEND_MODULES="xhci_hcd ehci_hcd uhci_hcd psmouse"

> PCIe ASPM

Do not add the following option to the kernel line

    pcie_aspm=force 

if

    dmesg | grep -i "acpi fadt"

outputs

    ACPI FADT declares the system does not support PCIe ASPM, so disable it.

> i915

Enabling i915_enable_rc6 will improve battery performance significantly.
To enable it, add the following option to your kernel line.

    i915.i915_enable_rc6=1

To check the current state of all i915 parameters execute as root (bash)

    for i in /sys/module/i915/parameters/*;do echo ${i}=`cat $i`;done

Module parameter details

    modinfo i915

> Additional powersavings

Configure Laptop_Mode_Tools and do not forget to check
CPU_Frequency_Scaling

Additional resources
--------------------

-   https://help.ubuntu.com/community/AsusZenbook
-   http://www.lesswatts.org/

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_Zenbook_UX31E&oldid=255786"

Category:

-   ASUS
