HCL/Laptops/Lenovo
==================

  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Hardware Compatibility List (HCL)
  Full Systems
  Laptops - Desktops
  Components
  Video Cards - Sound Cards - Wired Net Adapters - Modems - Wireless Adapters - Printers - Scanners - TV Cards - Digital Cameras - CD and DVD Writer/Readers - Keyboards - Main Boards
  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

  ----------------------------------------------------------------------------------------------------------------------------------
  Hardware Compatibility List - Laptops main page
  Acer - Apple - Asus - Compaq - Dell - Siemens-Fujitsu - Gateway - HP - IBM/Lenovo - Panasonic - Samsung - Sony - Toshiba - Other
  ----------------------------------------------------------------------------------------------------------------------------------

  

Contents
--------

-   1 IBM/Lenovo
    -   1.1 ThinkPad
-   2 Special Notes (*):
    -   2.1 IBM ThinkPad T21
    -   2.2 Lenovo Thinkpad T61
    -   2.3 Lenovo 3000 N200
    -   2.4 IBM ThinkPad R50,R52
    -   2.5 IBM ThinkPad R52
    -   2.6 Lenovo IdeaPad S10
    -   2.7 Lenovo ThinkPad T420
    -   2.8 Lenovo ThinkPad T420s
    -   2.9 Lenovo ThinkPad E430

IBM/Lenovo
----------

> ThinkPad

Model Version

Arch Linux   
Install CD Version  

Hardware Support

Remark

Video

Sound

Ethernet

Wireless

Bluetooth

Power Management

Modem

Other

IBM ThinkPad 380ED

NA

NA

NA

NA

No

NA

NA

NA

IBM ThinkPad T21

Yes*

Yes

Yes

NA

NA

Yes*

NA

NA

See below

IBM ThinkPad T23

Yes

Yes

Yes

NA

NA

Yes

NA

NA

IBM ThinkPad T42

Yes

Yes

Yes

Yes

NA

Yes

NA

NA

IBM ThinkPad T60

Yes

Yes

Yes

Yes

Yes

Yes

 ?

NA

IBM ThinkPad T60p

Yes

Yes

Yes

Yes

Yes

Yes

 ?

ThinkFinger

IBM ThinkPad T61

Yes

Yes

Yes

Yes*

NA

Yes

NA

IBM ThinkPad T61p

Yes

Yes

Yes

Yes

Yes

Yes

NA

IBM ThinkPad X23

Yes

Yes

Yes

NA

NA

Yes

NA

NA

IBM ThinkPad X60s

Yes

Yes

Yes

Yes

Yes

Yes

NA

NA

Lenovo ThinkPad X61s

Yes

Yes

Yes

Yes

Yes

Yes

NA

SD slot

Lenovo ThinkPad R60

Yes

Yes

Yes

Yes

Yes

Yes

NA

NA

Lenovo 3000 N200

Yes

Yes*

Yes

Yes

Yes

Yes*

NA

NA

See below

IBM ThinkPad R50,R52

Yes

Yes

Yes

Yes

NA

Yes

Yes

Infrared*

Lenovo ThinkPad X100e

Yes

Yes

Yes

Yes

Yes

Yes

Not tested

SD card (Yes), Webcam (Yes)

Lenovo ThinkPad X200

Yes

Yes

Yes

Yes

Yes

Yes

NA

NA

Lenovo IdeaPad S10

Yes

Yes

Yes

Yes*

NA

Yes

NA

NA

Lenovo IdeaPad S400 Touch

Yes

Yes

Yes

Yes

Yes

Yes

Not tested

NA

Lenovo ThinkPad T400

Yes

Yes

Yes

Yes

Yes

Yes

NA

NA

Lenovo ThinkPad T400s

Yes

Yes

Yes

Yes

Yes

Yes

NA

NA

Lenovo ThinkPad T420

Yes

Yes

Yes

Yes

Not tested

Yes*

NA

NA

Lenovo ThinkPad T420s

Yes

Yes

Yes

Yes

Yes

Yes

NA

Card Reader

See below

Lenovo ThinkPad T500

Yes

Yes

Yes

Yes

Not tested

Yes

NA

NA

Lenovo ThinkPad T520

Yes

Yes

Yes

Yes

Yes

Yes

NA

NA

Lenovo ThinkPad T530

Yes

Yes

Yes

Not tested

Not tested

Not tested

NA

NA

Lenovo ThinkPad E420s

Yes

Yes

Yes

Yes

Not tested

Yes

NA

SDcard (Yes), Webcam (Yes), Trackpoint (No)

Lenovo ThinkPad L430

Yes

Yes

Yes

Yes

Yes

Yes

Yes

Lenovo ThinkPad Edge E430

Yes

Yes

Yes*

Yes*

Not tested

Yes

NA

SD card (yes)

Lenovo ThinkPad Edge E530

Yes

Yes

Yes*

Yes*

Yes

Yes

NA

SD card (yes), Finger Print (not tested)

Special Notes (*):
------------------

> IBM ThinkPad T21

-   Video:
    -   Incapable of running DRM at 1024x768 and 24-bit color due to 8
        MB VRAM. Must drop color or resolution to get DRM.
    -   For whatever reason, external VGA output (for an external
        monitor) was disabled. This was fixed by doing this:
        -   echo 1 > /proc/acpi/video/VID/DOS

> Lenovo Thinkpad T61

-   Wireless:
    -   While both the iwl3945 and ipw3956 drivers work, the iwl3956
        driver provides better transfer speeds and a working Wi-Fi LED
        activity light.

> Lenovo 3000 N200

-   Sound:
    -   You may have to append options snd_hda_intel model=lenovo to
        /etc/modprobe.d/modprobe.conf for sound to work.

> IBM ThinkPad R50,R52

-   Infrared:
    -   Still not tested

> IBM ThinkPad R52

-   USB network tethering
    -   Inbound networking via interface usb0 works.

> Lenovo IdeaPad S10

-   Wireless:
    -   Install broadcom-wl driver. See: Broadcom BCM4312

> Lenovo ThinkPad T420

-   Power Management
    -   TP_smapi is not currently supported.

> Lenovo ThinkPad T420s

Multi-touch trackpad works along with scrolling and gestures, just
install xf86-input-synaptics.

For more information on the installation process, refer to this page.

> Lenovo ThinkPad E430

See Lenovo ThinkPad Edge E430 for more information.

-   Ethernet:
    -   Default card is a Realtek RTL8111/8168B. Thus the r8168 module
        should be used.
-   Wireless:
    -   r8192ce can be moody. So far, the best fix is to disable the
        firmware low-power state with fwlps=0.
-   SD card:
    -   Device will be accessible at /dev/mmcX
-   Power management:
    -   tp_smapi is not supported, but normal power management may be
        achieved in the usual ways.

Retrieved from
"https://wiki.archlinux.org/index.php?title=HCL/Laptops/Lenovo&oldid=295014"

Category:

-   Hardware Compatibility List

-   This page was last modified on 30 January 2014, at 11:57.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
