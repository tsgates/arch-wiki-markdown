Sony Vaio VGN-CR120E
====================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Installation
-   2 Video
-   3 Wireless
-   4 Sound
-   5 Media
-   6 Motioneye Inscreen Camera
-   7 Untested
-   8 lspci output

Installation
------------

See the Beginners' guide

Video
-----

    00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 0c)
    00:02.1 Display controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 0c)

You shouldn't need a xorg.conf to get into X.

The wide screen resolution, 1280x800 worked out of the box, no
hacks/patches/tricks needed.

Wireless
--------

    02:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or AGN Network Connection (rev 61)

Driver - Built into kernel, Firmware - iwlwifi-4965-ucode from
installation disk under 'Support'. Place 'iwl4965' in your modules array
in rc.conf.

Sound
-----

The module is snd_hda_intel. Use alsa, it just works. Mic/Recording -
Haven't tried.

Media
-----

CD burning - Works. DVD burning - Works. CD Ripping - Works.

Motioneye Inscreen Camera
-------------------------

lsusb will show

    05ca:1839 Ricoh Co., Ltd 

which has support provided by the r5u870 driver (depends on
kernel26<2.6.26).

download the latest trunk using svn, make, and make install as per the
normal build drill...

    svn co http://svn.mediati.org/svn/r5u870/trunk ~/r5u870
    cd ~/r5u870
    make
    make install

Note: One may forgo the last step in favor of being required to manually
load the driver and 'keep it simple' (information on manually loading
can be found in the README file that you get from the trunk. Note: A
package exists in AUR 'r5u870' and 'r5u870-svn' which still work with
depends kernel26<2.6.26 and kernel26>2.6.24, feel free to use those too.
All that's left now is

    modprobe r5u870

you can test your webcam with xawtv like so

    xawtv /dev/video0

kernel26>2.6.26: If you have a kernel that falls beyond the depends for
'r5u870' then you can try 'r5u87x' which is a user-space utility that
simply loads the camera's firmware into the device. unloading and
reloading uvcvideo module will give you your /dev/video* device. There
are certain problems with this as any request for a resolution change
below 640x480 will report successful by the camera, but actually fails.
I will be following developement closely. --OrionFyre 15:13, 14 November
2008 (EST)

flashcam note Flashcam project was a video loopback device that provided
a v4l device that worked with flash, this project is now obsolete as
flash10 supports v4l2 and as it too is subject to the same breakage that
occures to r5u870 with kernel26>2.6.26. My intention was to continue to
use flashcam to take vga video (which works with uvcvideo) and have
flashcam provide the proper resolution needed for the various
applications--OrionFyre 15:13, 14 November 2008 (EST)

Untested
--------

-   3D Support
-   Mic

lspci output
------------

    00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory Controller Hub (rev 0c)
    00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 0c)
    00:02.1 Display controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller (rev 0c)
    00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Contoller #4 (rev 03)
    00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #5 (rev 03)
    00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #2 (rev 03)
    00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 03)
    00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 03)
    00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 2 (rev 03)
    00:1c.2 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 3 (rev 03)
    00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 (rev 03)
    00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #2 (rev 03)
    00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #3 (rev 03)
    00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 03)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3)
    00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface Controller (rev 03)
    00:1f.2 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA IDE Controller (rev 03)
    00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 03)
    02:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or AGN Network Connection (rev 61)
    06:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8101E PCI Express Fast Ethernet controller (rev 01)
    08:07.0 CardBus bridge: Texas Instruments PCIxx12 Cardbus Controller
    08:07.1 FireWire (IEEE 1394): Texas Instruments PCIxx12 OHCI Compliant IEEE 1394 Host Controller
    08:07.2 Mass storage controller: Texas Instruments 5-in-1 Multimedia Card Reader (SD/MMC/MS/MS PRO/xD)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Sony_Vaio_VGN-CR120E&oldid=298029"

Category:

-   Sony

-   This page was last modified on 16 February 2014, at 07:06.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
