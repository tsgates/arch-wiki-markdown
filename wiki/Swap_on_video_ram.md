Swap on video ram
=================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

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

Warning: unless your X11 driver can be made to use less ram than exists
(can be detected) your X server will tend to crash when you try to use
the same section of RAM to store textures (even Qt does it) as swap.
Using a video driver that allows you to override videoram should
increase stability (vga and radeon (xf86-video-ati) do at least). Even
then, you or I might have made mistakes and you can still get crashes or
freezes (that do not listen to ctrl-alt-backspace; use the magic sysrq).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Why Do it                                                          |
| -   2 How To                                                             |
|     -   2.1 Kernel Stuff                                                 |
|     -   2.2 Post-Kernel Stuff                                            |
|     -   2.3 Xorg Driver Config                                           |
|                                                                          |
| -   3 Checking the Swap space being used                                 |
| -   4 External Links                                                     |
+--------------------------------------------------------------------------+

Why Do it
---------

The fast memory on your graphics card (if you have one) can be used as
general ram (actually swap) by using the MTD subsystem of the kernel. If
you have lots of videoram (256 MiB) this can increase system
responsiveness (if you have around 256 MiB main ram too :).

Agp has slow reads; ~8 M/s. Making this less desirable.

How To
------

> Kernel Stuff

MTD is now included in the kernel as of 2.6.23.1-6.

> Post-Kernel Stuff

When you are running a kernel with MTD modules, you have to load the
modules specifying the pci address ranges that correspond to the ram on
your video card.

check the ranges with

    lspci -vvv

Then you look for the sections that name your video card as an example
mine is here:

    01:00.0 VGA compatible controller: ATI Technologies Inc RV350 AR [Radeon 9600] (prog-if 00 [VGA controller])
    	Subsystem: PC Partner Limited Unknown device 0830
    	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
    	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    	Latency: 64 (2000ns min), Cache Line Size: 32 bytes
    	Interrupt: pin A routed to IRQ 11
    	Region 0: Memory at e0000000 (32-bit, prefetchable) [size=256M]
    	Region 1: I/O ports at c800 [size=256]
    	Region 2: Memory at ff8f0000 (32-bit, non-prefetchable) [size=64K]
    	Expansion ROM at ff8c0000 [disabled] [size=128K]
    	Capabilities: <access denied>

    01:00.1 Display controller: ATI Technologies Inc RV350 AR [Radeon 9600] (Secondary)
    	Subsystem: PC Partner Limited Unknown device 0831
    	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
    	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
    	Latency: 64 (2000ns min), Cache Line Size: 32 bytes
    	Region 0: Memory at d0000000 (32-bit, prefetchable) [size=256M]
    	Region 1: Memory at ff8e0000 (32-bit, non-prefetchable) [size=64K]
    	Capabilities: <access denied>

What's important is Region 0, (the biggest one)

Since the video card needs some ram to serve its normal purpose, so you
need to do some calculations. The offsets are easy to calculate as
powers of 2. The card should use the beginning of the address range as
framebuffer, textures etc. when limited (otherwise you get X11
crashing).

Example: total 2^28 bytes (256M) videoram, leaving 2^24 (32M) for the
normal function (less will work fine) The start range, is 2^24 bytes
more than the start of the pci address range shown by lspci -vvv.

The end is your total minus the amount you left for the card.

Load the modules in /etc/rc.conf

    MODULES=(otherModulesYouNeed slram mtdblock) 

In /etc/rc.local

    mkswap /dev/mtdblock0 && swapon /dev/mtdblock0 -p 10 #higher priority

Add this to /etc/modprobe.d/modprobe.conf

    options slram map=VRAM,0xStartRange,+0xUsedAmount

> Xorg Driver Config

To keep X stable, your video driver needs to be told to use less than
the detected videoram. In the Device section of your /etc/X11/xorg.conf
the declaration

    Section "Device"
        Driver "radeon" # or whichever other driver you use
        VideoRam 32768
    	#other stuff
    EndSection

specifies that you use 32 MiB of ram. Other drivers might take the
number for videoram as being in MiB (I think vga does), check manpages.

Checking the Swap space being used
----------------------------------

The following command may help you getting the used swap in the
different spaces like disk partitions, flash disks and possibly this
example of the swap on video ram

    swapon -s 

External Links
--------------

-   MTD website
-   Gentoo Wiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=Swap_on_video_ram&oldid=196301"

Category:

-   Graphics
