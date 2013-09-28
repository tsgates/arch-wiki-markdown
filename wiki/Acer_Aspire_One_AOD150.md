Acer Aspire One AOD150
======================

This article pertains to the 10.1" Acer Aspire One D150 models made
available in February 2009. At this time, the AOD150 series feature
standard SATA hard drives only, therefore much of the information found
in the Acer Aspire One article does not apply. This article attempts to
trim the fat.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware Specifications                                            |
|     -   1.1 Base Components                                              |
|                                                                          |
| -   2 Arch Installation                                                  |
| -   3 Hardware Configuration                                             |
|     -   3.1 Kernel Drivers                                               |
|     -   3.2 Hotkeys                                                      |
|     -   3.3 Touchpad                                                     |
|                                                                          |
| -   4 Kernel Drivers for Aspire One D250                                 |
+--------------------------------------------------------------------------+

Hardware Specifications
-----------------------

The AOD150 series netbook is known to be available in the following
configuration:

> Base Components

-   Intel® Atom processor
    -   N270 (1.6GHz/533MHz FSB/512KB L2 Cache)

-   Mobile Intel® 945GSE Express Chipset
-   1GB 533MHz DDR2 SDRAM Memory
-   10.1" Widescreen Display
    -   WSVGA 1024x600 with CrystalBrite™

-   Intel® GMA 950 Graphics
-   160GB 5400RPM SATA Hard Disk
-   Microdia® Integrated Webcam
-   Attansic® L1E 10/100 Ethernet
-   Atheros® AR242x 802.11abg Wireless
-   Intel® 82801G (ICH7 Family) HD Audio
-   Multi-card Reader (SD/MMC/RS-MMC/MS/MS Pro/xD)
-   3 USB 2.0 Ports
-   Synaptics® touchpad with scroll zones
-   External VGA Port
-   Integrated Digital Microphone

-   Red items have yet to be covered in detail and require a wiki entry

Arch Installation
-----------------

There are plenty of resources available to help new users install and
configure a basic Arch Linux installation, including the Official
Installation Guide and the Beginners Guide.

The obvious consideration for netbooks in general is the lack of CD/DVD
drives. Unless you are using an external optical drive you will want to
stick to the USB image of the Arch snapshots.

The following tips are specific to the Acer Aspire One (also referred as
the AAO or AA1) and may be of some help during installation.

If a broadband Internet connection is available it is highly recommended
that Arch be installed with the smaller FTP image. If you plan to have a
desktop environment (KDE, GNOME, etc) then the majority of the packages
you require will come from the Internet repositories and not the Arch
USB itself. This method will get you up and running in the shortest
amount of time. Simply download the FTP USB image, write to a USB drive
and restart your computer.

The following steps assume you are connected to the Internet with a
wired Ethernet connection.

Hardware Configuration
----------------------

> Kernel Drivers

The following kernels drivers are necessary to get all of the various
hardware working. All of these modules should load automatically without
adding them to /etc/rc.conf:

-   atl1e - Ethernet
-   ath5k - Wireless
-   uvcvideo - Webcam
-   snd_hda_intel - Audio

> Hotkeys

Many of the Function hotkeys are controlled via hardware/BIOS and do not
require user configuration:

-   LCD Toggle (Fn+F6)
-   LCD Brightness (Fn+Left / Fn+Right)
-   Touchpad Toggle (Fn+F7)
-   Wireless Kill-switch (dedicated)

The remaining hotkeys can be configured easily with utilities (such as
xbindkeys):

-   Volume Up/Down (Fn+Up / Fn+Down)
-   Mute (Fn+F8)
-   Standby (Fn+F4)

> Touchpad

The Synaptics touchpad is sometimes disabled by default, following a
fresh installation. If unresponsive, try pressing the touchpad toggle
hotkeys (Fn+F7).

In all other respects, the touchpad can be configured using the standard
Touchpad Synaptics wiki.

Kernel Drivers for Aspire One D250
----------------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

The atl1e driver that ships with the kernel in 2009.02 does not work
with the Atheros/Attansic ethernet chip in this model. The chip in the
AAO D250 has device id 0x1062, and the default atl1e driver only
supports the 0x1026 device. In order to get the wired ethernet working
you have to compile another version of atl1e.

Go to http://partner.atheros.com/Drivers.aspx and fetch
[459]AR813X-linux-v1.0.0.9.tar.gz from there. This driver supports a
wide range of Atheros/Attansic devices. Do *not* fetch
AR81Family-linux-v1.0.1.0.tar.gz, because that is the one that supports
device id 0x1026 only.

Then compile and install the driver:

    $ tar -xz < [459]AR813X-linux-v1.0.0.9.tar.gz
    $ cd src
    $ make

    # cp atl1e.ko /lib/modules/*/kernel/drivers/net

The last step requires being logged in as root. Reboot and the wired
ethernet card should now be recognized on your D250.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Acer_Aspire_One_AOD150&oldid=206403"

Category:

-   Acer
