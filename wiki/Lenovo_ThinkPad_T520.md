Lenovo ThinkPad T520
====================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: similar articles  
                           are generally more       
                           detailed. (Discuss)      
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Installation
-   2 Graphics
    -   2.1 Integrated Graphics
    -   2.2 Discrete Graphics
    -   2.3 NVidia Optimus
-   3 Troubleshooting
    -   3.1 Screen freezes before login prompt when using discrete
        graphics

Installation
------------

Installation worked without further setting adjustments.

Graphics
--------

The BIOS option Display->Graphics Device can be switched to these
settings:

> Integrated Graphics

Use this with the xf86-video-intel driver. The nvidia card will be
turned off, which means that the system will consume less power and you
will not have to worry about installing the nvidia drivers.

The integrated graphics is fast enough to run some older games. It is a
good option if you do not use demanding 3D applications

A major disadvantage of this mode is that the DisplayPort will not work,
because it is hardwired to the Nvidia card.

> Discrete Graphics

This will give you good consistent 3D performance in all applications,
without having to worry about the complexities of bumblebee. It is also
a good option if you want an easy way to connect and use a DisplayPort
monitor.

You will not get the power-savings of running from the intel-gfx and
turning the discrete nvidia card off. Another disadvantage is that you
cannot use this mode to run tripple-head with 2 external Monitors on VGA
and DP. This is a hardware limitation, the discrete-nvidia and
integrated-intel card can both only drive at most 2 different screens
each.

> NVidia Optimus

If you choose this option, set "OS Detection for NVIDIA Optimus" BIOS
Option to Disabled.

See the Bumblebee page for details on how to use both cards with linux.

Troubleshooting
---------------

> Screen freezes before login prompt when using discrete graphics

If you are using GRUB2 bootmanager, its framebuffer graphics mode can
cause problems later on in the boot process. See
GRUB2#Disable_framebuffer.

You might also try to set the nomodeset kernel commandline flags:

Kernel_Mode_Setting#Disabling_modesetting

Although, currently (Oct 2013, kernel 3.11.6), my T520 boots in
"Discrete Graphics" mode only when i disable the GRUB2 framebuffer, but
do not set any of the nomodeset kernel options.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_ThinkPad_T520&oldid=280375"

Category:

-   Lenovo

-   This page was last modified on 30 October 2013, at 10:24.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
