Hybrid graphics
===============

Hybrid-graphics is a concept involving two graphics cards on same
computer, it was first designed to control power consumption in laptops
and is extending to desktop computers as well

Contents
--------

-   1 About Hybrid-graphics Technologies
-   2 The "Old" Hybrid Model (Basic Switching)
-   3 The New Dynamic Switching Model
    -   3.1 Nvidia Optimus
        -   3.1.1 Current Problems
        -   3.1.2 Software Solutions So Far
    -   3.2 ATI Dynamic Switchable Graphics
        -   3.2.1 Current Problems
        -   3.2.2 Solution for kernels < 3.12 or without radeon dynamic
            power management enabled
    -   3.3 Fully Power Down Discrete GPU
-   4 See Also

About Hybrid-graphics Technologies
----------------------------------

The laptop manufacturers developed new technologies involving two
graphic cards in an single computer, enabling both high performance and
power saving usages. This technology is well supported on Windows but
it's still quite experimental with Linux distributions.

We call hybrid graphics a set of two graphic cards with different
abilities and power consumptions. There are a variety of technologies
and each manufacturer developed its own solution to this problem. Here
we try to explain a little about each approach and models and some
community solutions to the lack of GNU/Linux systems support.

The "Old" Hybrid Model (Basic Switching)
----------------------------------------

This approach involves a two graphic card setup with a hardware
multiplexer (MUX). It allows power save and low-end 3D rendering by
using an Integrated Graphics Processor (IGP); or a major power
consumption with 3D rendering performance using a Dedicated Graphics
Processor (DGP). This model makes the user choose (at boot time or at
login time) within the two power/graphics profiles and is almost fixed
through all the user session. The switch is done by a similar workflow:

-   Turn off the display
-   Turn on the DGP
-   Switch the multiplexer
-   Turn off the IGP
-   Turn on again the display

This switch is somewhat rough and adds some blinks and black screens in
laptops that could do it "on the fly". Later approaches made the
transition a little more user-friendly.

The New Dynamic Switching Model
-------------------------------

Most of the new Hybrid-graphics technologies involves two graphic cards
as the basic switching but now the DGP and IGP are plugged to a
framebuffer and there is no hardware multiplexer. The IGP is always on
and the DGP is switched on/off when there is a need in power-save or
performance-rendering. In most cases there is no way to use only the DGP
and all the switching and rendering is controlled by software. At
startup, the Linux kernel starts using a video mode and setting up
low-level graphic drivers which will be used by the applications. Most
of the Linux distributions then use X.org to create a graphical
environment. Finally, a few other softwares are launched, first a login
manager and then a window manager, and so on. This hierarchical system
has been designed to be used in most of cases on a single graphic card.

> Nvidia Optimus

Nvidia Optimus Whitepaper

Current Problems

-   Switching between cards when possible.
-   Switching on/off the discrete card.
-   Be able to use the discrete card for 3D render.
-   Be able to use both cards for 3D render (problem arised in this
    post).

Software Solutions So Far

-   asus_switcheroo -- a solution for Intel/Nvidia switching on ASUS and
    other laptops with a similar hardware mux -- by Alex Williamson
-   byo_switcheroo -- a solution to build your own handler (like
    acpi_call) to switch between cards with vga_switcheroo -- by Alex
    Williamson
-   vga_switcheroo -- the original GPU switching solution primarily for
    Intel/ATI notebooks -- by David Airlie
-   acpi_call -- allows you to switch off discrete graphics card to
    improve battery life -- by Michal Kottman
-   PRIME -- long-term Optimus solution in progress -- by David Airlie
-   Bumblebee -- allows you to run specific programs on the discrete
    graphic card, inside of an X session using the integrated graphic
    card. Works on Nvidia Optimus cards -- by Martin Juhl
-   hybrid-windump -- dump window using Nvidia onto Intel display -- by
    Florian Berger and Joakim Gebart

> ATI Dynamic Switchable Graphics

This is a new technology similar to the one of Nvidia as it uses no
hardware multiplexer.

Current Problems

The Dynamic Switch needs Xorg support for the discrete videocard
assigned for rendering to work [1]. So, rendering on the discrete gpu
will not work until the Xorg team adds support for it.

This means that with a muxless intel+ati design, you cannot use your
discrete card by simply modprobing the radeon module.

As of now, there are 3 choices:

- Disable the discrete card and use only the intel igpu. This is not
needed for kernels version >= 3.12 with radeon DPM enabled; the open
source graphics driver manages the card automatically. For kernels older
than 3.12, see the solution below.

- Test and improve some virtualGL based program to make the switch, like
the common-amd branch of bumblebee project. Check the project repository
and this useful post.

- Use the proprietary driver with powerxpress (a.k.a. pxp) support
maintained by Vi0l0 (remember to check for xorg compatibility).

Solution for kernels < 3.12 or without radeon dynamic power management enabled

Warning: This method, on a mux-less system, works only to shutdown the
radeon card. This will not enable rendering on the radeon gpu. See
Current Problems section above for detail.

This solution is not needed on kernel version >= 3.12 because the
opensource driver automatically manages the power of the radeon gpu, so
there is no need to manage the cards from userspace.

This means that on kernels >= 3.12, vgaswitcheroo is not needed anymore
to turn off the discrete gpu, only if you wish to verify the power
state.

If you have kernel >= 3.12 with vgaswitcheroo enabled, you can verify if
the driver automatically shut down the discrete gpu

    # cat /sys/kernel/debug/vgaswitcheroo/switch

The output should be similar to this, where DIS is the radeon discrete
gpu and IGD the intel gpu. DynOff means the radeon driver automatically
powered off the discrete gpu.

    0:DIS: :DynOff:0000:01:00.0
    1:IGD:+:Pwr:0000:00:02.0

If you are using kernels older than 3.12 then you can use vga_switcheroo
with a combination of opensource drivers to disable the radeon card from
userspace at boot.

To do this, follow the instructions below.

-   Preliminaries

Make sure you have installed the drivers. Run in terminal:

    $ pacman -Q | grep -E "xf86-video-ati|xf86-video-intel"

In case you get output similar to this:

    xf86-video-ati 6.14.1-1
    xf86-video-intel 2.15.0-2

you are good to go. In other case install drivers:

    # pacman -S xf86-video-ati xf86-video-intel

In order to be able to access vgaswitcheroo add this line to your fstab:

    none            /sys/kernel/debug debugfs defaults 0 0

Note:KMS must be activated for both cards, otherwise there will be no
vgaswitcheroo in /sys/kernel/debug/

-   Automatic radeon shutdown

Systemd can use tmpfiles to shutdown the discrete gpu at boot.

Important: Make sure the video drivers are loaded in initramfs before
systemd calls vga_switcheroo, otherwise a kernel oops/panic may occur.

First add the drivers to MODULES array in /etc/mkinitcpio.conf. Adding
radeon and i915 yields

    /etc/mkinitcpio.conf

    MODULES="radeon i915"

Next rebuild initramfs (details at initramfs)

    # mkinitcpio -p linux

Then create the systemd tmpfile at /etc/tmpfiles.d/vgaswitcheroo.conf

    /etc/tmpfiles.d/vgaswitcheroo.conf

    w /sys/kernel/debug/vgaswitcheroo/switch - - - - OFF

Reboot and the discrete gpu should be off by default. It can be powered
back on using the manual method described below.

-   Manual method

To verify the state of the dgpu

    # cat /sys/kernel/debug/vgaswitcheroo/switch

Power off the dgpu

    # echo OFF > /sys/kernel/debug/vgaswitcheroo/switch

Power on

    # echo ON > /sys/kernel/debug/vgaswitcheroo/switch

> Fully Power Down Discrete GPU

You may want to turn off the high-performance graphics processor to save
battery power, this can be done by installing the the acpi_call-git
package from the AUR.

Once installed load the kernel module:

    modprobe acpi_call

With the kernel module loaded run the following (requires root):

    turn_off_gpu.sh

This script will go through all the known data buses and attempt to turn
them off. You will get an output similar to the following:

    Trying \_SB.PCI0.P0P1.VGA._OFF: failed
    Trying \_SB.PCI0.P0P2.VGA._OFF: failed
    Trying \_SB_.PCI0.OVGA.ATPX: failed
    Trying \_SB_.PCI0.OVGA.XTPX: failed
    Trying \_SB.PCI0.P0P3.PEGP._OFF: failed
    Trying \_SB.PCI0.P0P2.PEGP._OFF: failed
    Trying \_SB.PCI0.P0P1.PEGP._OFF: failed
    Trying \_SB.PCI0.MXR0.MXM0._OFF: failed
    Trying \_SB.PCI0.PEG1.GFX0._OFF: failed
    Trying \_SB.PCI0.PEG0.GFX0.DOFF: failed
    Trying \_SB.PCI0.PEG1.GFX0.DOFF: failed
    Trying \_SB.PCI0.PEG0.PEGP._OFF: works!
    Trying \_SB.PCI0.XVR0.Z01I.DGOF: failed
    Trying \_SB.PCI0.PEGR.GFX0._OFF: failed
    Trying \_SB.PCI0.PEG.VID._OFF: failed
    Trying \_SB.PCI0.PEG0.VID._OFF: failed
    Trying \_SB.PCI0.P0P2.DGPU._OFF: failed
    Trying \_SB.PCI0.P0P4.DGPU.DOFF: failed
    Trying \_SB.PCI0.IXVE.IGPU.DGOF: failed
    Trying \_SB.PCI0.RP00.VGA._PS3: failed
    Trying \_SB.PCI0.RP00.VGA.P3MO: failed
    Trying \_SB.PCI0.GFX0.DSM._T_0: failed
    Trying \_SB.PCI0.LPC.EC.PUBS._OFF: failed
    Trying \_SB.PCI0.P0P2.NVID._OFF: failed
    Trying \_SB.PCI0.P0P2.VGA.PX02: failed
    Trying \_SB_.PCI0.PEGP.DGFX._OFF: failed
    Trying \_SB_.PCI0.VGA.PX02: failed

See the "works"? This means the script found a bus which your GPU sits
on and it has now turned off the chip. To confirm this, your battery
time remaining should have increased. Currently, the chip will turn back
on with the next reboot to get around this we do the following:

Note: To turn the GPU back on just reboot.

Add the kernel module to the array of modules to load at boot:

    /etc/modules-load.d/acpi_call.conf

    #Load 'acpi_call.ko' at boot.

    acpi_call

To turn off the GPU at boot we could just run the above script but
honestly that is not very elegant so instead lets make use of systemd's
tmpfiles.

    /etc/tmpfiles.d/acpi_call.conf


    w /proc/acpi/call - - - - \_SB.PCI0.PEG0.PEGP._OFF

The above config will be loaded at boot by systemd. What it does is
write the specific OFF signal to the /proc/acpi/call file. Obviously,
replace the \_SB.PCI0.PEG0.PEGP._OFF with the one which works on your
system.

Note: After every kernel upgrade acpi_call-git will need to be
reinstalled.

See Also
--------

-   Linux Hybrid-Graphics Blog
-   Hybrid graphics on Linux Wiki
-   Nvidia Optimus commercial presentation
-   ATI commercial presentation
-   Bumblebee

Retrieved from
"https://wiki.archlinux.org/index.php?title=Hybrid_graphics&oldid=300210"

Category:

-   Graphics

-   This page was last modified on 23 February 2014, at 12:46.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
