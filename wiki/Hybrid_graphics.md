Hybrid graphics
===============

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Hybrid-graphics is a concept involving two graphics cards on same
computer, it was first designed to control power consumption in laptops
and is extending to desktop computers as well

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 About Hybrid-graphics Technologies                                 |
| -   2 The "Old" Hybrid Model (Basic Switching)                           |
| -   3 The New Dynamic Switching Model                                    |
|     -   3.1 Nvidia Optimus                                               |
|         -   3.1.1 Current Problems                                       |
|         -   3.1.2 Software Solutions So Far                              |
|                                                                          |
|     -   3.2 ATI Dynamic Switchable Graphics                              |
|         -   3.2.1 Current Problems                                       |
|         -   3.2.2 Solutions So Far                                       |
|                                                                          |
|     -   3.3 Fully Power Down Discrete GPU                                |
|                                                                          |
| -   4 See Also                                                           |
+--------------------------------------------------------------------------+

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

This is a new technology similar to the one of Nvidia. There is no
hardware multiplexer and gone into the market a few weeks/months ago.

Current Problems

The Dynamic Switch needs Xorg support for the discrete videocard
assigned to rendering [1].

So, the method listed here (and the AUR package related) will not work
until Xorg team add support for the redering on a second card not
attached to video. See here for more info.

This means that with a muxless intel+ati design, you can't use your
discrete card simply modprobing the module as listed down here.

As of now, there are 3 choices:

- Disable the discrete card and use only the intel one. In this case you
can folow the instructions below to disable the radeon card.

- Test and improve some virtualGL based program to make the switch, like
the common-amd branch of bumblebee project. Check the project repository
and this useful post.

- Use the proprietary driver with powerxpress (a.k.a. pxp) support
maintained by Vi0l0 (remember to check for xorg compatibility).

Solutions So Far

Warning: This method, on a mux-less system, works only to shutdown the
radeon card. This will not enable rendering on the radeon. See Current
Problems section above for detail.

Right now, the best solution is vga_switcheroo with combination of
opensource drivers for your ATi and Intel graphics.

-   Manual method

Make sure you have installed drivers. Run in terminal:

    $ pacman -Q | grep -E "xf86-video-ati|xf86-video-intel"

In case you get output similar to this:

    xf86-video-ati 6.14.1-1
    xf86-video-intel 2.15.0-2

you're good to go. In other case install drivers:

    # pacman -S xf86-video-ati xf86-video-intel

DO NOT reboot your computer! In most cases system will not boot with
both drivers installed. Blacklist radeon module:

    # echo > /etc/modprobe.d/radeon.conf blacklist\ radeon

This will prevent system from hanging during boot. vga_switcheroo works
only with radeon module loaded. To load radeon automatically on system
startup open /etc/rc.local and add line:

    modprobe radeon

optionally, you can turn off radeon right after system boot to save some
battery energy and cool down your laptop. To do this, add following line
to /etc/rc.local:

    # echo OFF > /sys/kernel/debug/vgaswitcheroo/switch

In order to be able to access vgaswitcheroo add this line to your fstab:

    none            /sys/kernel/debug debugfs defaults 0 0

  

Note:KMS must be activated for both cards, otherwise there will be no
vgaswitcheroo in /sys/kernel/debug/

-   AUR method

Get it from: hybrid-video-ati-intel AUR package

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
"https://wiki.archlinux.org/index.php?title=Hybrid_graphics&oldid=252739"

Category:

-   Graphics
