Dell Latitude C600
==================

In an attempt to give back to the Arch community I decided to write a
wiki page about my laptop the Dell Latitude C600 and what I've found out
about it, it's treated me well and plays fairly nicely with Linux. I
would recommend it.

Much of this information has been based off of the wiki page for the
Dell Latitude C600 at the Gentoo wiki and the linux-dell-laptops faq
page which although old is still very good, I suggest you also read both
of these if you do not find answers here.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Known Hardware                                                     |
| -   2 PCMCIA Cardbus                                                     |
| -   3 Audio                                                              |
| -   4 Video                                                              |
|     -   4.1 Framebuffer                                                  |
|     -   4.2 Xorg                                                         |
|                                                                          |
| -   5 Network                                                            |
|     -   5.1 Ethernet                                                     |
|     -   5.2 Winmodem                                                     |
|                                                                          |
| -   6 Touchpad                                                           |
| -   7 Battery and Power Saving                                           |
|     -   7.1 APM                                                          |
|     -   7.2 ACPI                                                         |
|                                                                          |
| -   8 Volume Keys and Fans                                               |
| -   9 External Links                                                     |
+--------------------------------------------------------------------------+

Known Hardware
==============

Cardbus: 2 slots, Texas Instruments PCI1420  
 Audio: 3Com Corporation 3c556 Hurricane CardBus [Cyclone] (rev 10)  
 Video: ATI Technologies Inc Rage Mobility M3 AGP 2x (rev 02)  
 Ethernet: 3Com Corporation 3c556 Hurricane CardBus [Cyclone] (rev 10)  
 Modem: 3Com Corporation Mini PCI 56k Winmodem (rev 10)

PCMCIA Cardbus
==============

After some configuration changes I know personally that this cardbus
works perfectly.

First install pcmciautils as root with

    pacman -S pcmciautils

Once installed to stop boot freezes you have to edit
/etc/pcmcia/config.opts and find the line

    include port 0x820-0x8ff

and comment it out. Dell likes to be special for some reason and if that
range is probed at boot it will usually result in the laptop dying, I
think this configuration change can be applied to most Dell laptops.

If you're compiling your own kernel remember that this is a
yenta-compatible cardbus and that should be enabled in the pccard
section of the kernel config.

    <M>   CardBus yenta-compatible bridge support 

Audio
=====

I've had absolutely no problems with audio for this laptop, if you're
using the Arch stock kernel it should work straight out of the box after
it is enabled like a regular sound card.

If you're compiling your own kernel you should enable this card in the
sound pci device section

    <*> ESS Allegro/Maestro3

Video
=====

Framebuffer
-----------

If you're using a stock kernel I can confirm that you can get a high
resolution framebuffer by simply adding

    vga=791

to your kernel's boot options for a good 1024x768 resolution. I'll leave
you to find out other values to use for other resolutions but this one
workd for me and is a good guideline.

Using the beyond kernel it is also quite easy to achieve extras like a
background or progress bar on boot using other articles in this wiki.

If you're compiling your own kernel then you're out of luck with getting
a framebuffer to work with this guide, I've not been able to find the
right options and the rage128 driver causes a freeze, that being said it
has to be possible some how and feel free to add your solution here.

Xorg
----

I always use xorgconfig to generate my xorg config and it's quite easy
to get xorg going at first, a general rule is to use the ati and rage128
drivers for it. The Gentoo wiki article has links to this xorg.conf
which has some great additions you can add for your video sections. One
thing to add is that contrary what the config says this laptop can get a
top resolution of 1400x1050 for me at least.

Network
=======

Ethernet
--------

This works perfectly straight out of the box without any configuration
using any of the stock kernels. Not much to say about it.

If you're compiling your own kernel remember to enable this card in the
net device section

    <*>   3c590/3c900 series (592/595/597) "Vortex/Boomerang" support

Winmodem
--------

Apparently this laptop has a 3Com Corporation Mini PCI 56k Winmodem but
I'm yet to get it working and doubt it would. I also have no need or
desire to get it working anyway.

Please anyone feel free to add to this section how you got it working if
you have.

Touchpad
========

This laptop has a great touchpad and has lots of features if used in
conjunction with the synaptics driver for xorg. You can install it with

    pacman -S synaptics

and use this in your xorg config's mouse section

    Driver          "synaptics"
    Option          "Protocol"              "auto-dev"
    Option          "Device"                "/dev/psaux"
    Option          "Emulate3Buttons"
    Option          "HorizScrollDelta"      "0"

This adds all sorts neat features like a "scroll wheel" on the right,
tap-to-click, tapping in corners for right-clicking, middle-clicking
etc. and using the bottom as another scroll wheel for things like back
and forward buttons in Firefox. I have this disabled with the
HorizScrollDelta line as it gets really annoying.

The little joystick in the center of the keyboard also works perfectly.

Battery and Power Saving
========================

APM
---

I would suggest using APM instead of ACPI as it's easier, provides a
longer battery time and most importantly works out of the box and even
gives you a working suspend.

Enabling APM with a stock kernel is very easy, you can turn it off by
adding

    acpi=off

to the kernel boot options and next boot you should have working APM.

If your APM happens to be buggy or causes crashes you may need to update
your BIOS which can be done using this section of the Gentoo guide.

You will also probably need apmd which you can install with

    pacman -S apmd

and then adding "apmd" to your daemons list in rc.conf

ACPI
----

I know this laptop is perfectly capable of using ACPI but I prefer to
use APM so I do not have any information to give. If you want to test it
out yourself install acpid and try looking around for some guides for
it. Please add any working scripts you might find to this guide.

Volume Keys and Fans
====================

If you've wondered how you can get those volume keys working or even how
to control the fans you're in luck, the i8k module and utils are
perfectly compatible with the laptop. Make sure i8k is loaded with

    modprobe i8k

and if you use your own kernel make sure you compile in "Dell Laptop
Support".

Next install i8kutils with

    pacman -S i8kutils

and you're set to go. You can refer to the documentation for i8kutils on
how to script the volume keys and control the fans.

External Links
==============

-   This document is listed at the TuxMobil Linux laptop and notebook
    installation guides survey (DELL).

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Latitude_C600&oldid=196572"

Category:

-   Dell
