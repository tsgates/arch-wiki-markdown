Lenovo ThinkPad X1
==================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Model description                                                  |
| -   2 Drive space customization                                          |
| -   3 Installation method                                                |
|     -   3.1 UEFI                                                         |
|                                                                          |
| -   4 Hardware                                                           |
|     -   4.1 Fingerprint Reader                                           |
|                                                                          |
| -   5 Power management                                                   |
| -   6 ACPI                                                               |
+--------------------------------------------------------------------------+

Model description
-----------------

Lenovo ThinkPad X1, Sandy Bridge (Core i5, 2,5 GHz), NWG2MRT This model
has SSD 80/HDD 320 pair. Comes without optical drive. Has UEFI BIOS with
BIOS-legacy fallback mode. Has Windows 7 Pro pre-installed, with tons of
bloatware (bing toolbar, big Lenovo superbar button et all)
pre-installed, too.

Drive space customization
-------------------------

By default:

    - SSD: two WinRE partitions and one Windows system partition
    - HDD: blank

I've chosen to:

    - leave WinRE untouched (there are two such partitions)
    - use SSD for my root partition
    - use HDD for swap, /home, /var (~30 Gb, pacman cache goes here), /tmp

Installation method
-------------------

Note:If you'd like to create Windows recovery flash drive, do it before
Arch installation with the help of autorun located at recovery
partition, from your installed Windows system.

Due to the fact that there is no optical drive, you need to install Arch
from USB stick.

The lazy way to install is just default installation, works flawlessly.
Installed system will boot in legacy-BIOS mode.

> UEFI

Note:This procedure reflects a single user's experience, and no attempt
was made to experiment with different settings.

Download the official ISO or create your own using something like
Archiso. Follow the instructions for creating a UEFI bootable USB from
the ISO. Note that the default bootloader works fine so there's no need
to replace it with an alternative like rEFInd. In the BIOS under
Startup, set "UEFI/Legacy Boot" to UEFI only and turn off CSM support
(this step might not be necessary, try skipping it first if you like).

Upon saving your changes and restarting, the UEFI boot options from the
USB stick should come up and you can proceed to installing Arch.

It appears that the default partition table (and Windows installation)
uses MBR. To use UEFI, you should reformat the disk as GPT (wiping the
drive in the process). Follow the instructions for creating the EFI
system partition. gdisk recommends a size of 300M. Follow the Beginner's
Guide to see how to correctly generate (and then fix) the fstab entry
for the ESP.

Booting using an efibootmgr entry is quite simple (and doesn't require
any extra packages). Simply follow the instructions for creating the
EFISTUB and adding the efibootmgr entry. The note about Lenovo Thinkpads
truncating the UEFI options doesn't apply to the X1: the recommended
efibootmgr entry works fine. The note about escaping the backslashes in
the initrd path does apply, verify with efibootmgr -v that the boot
entry doesn't have any missing characters.

Hardware
--------

Almost everything works out of the box. Install synaptics and
video-intel drivers.

> Fingerprint Reader

fingerprint-gui from the AUR is already patched to work with the X1's
newer fingerprint reader. Note that the dropdown entry for the
fingerprint device will be blank.

Power management
----------------

Just consult Laptop page to read about tp_smapi, pm-utils, uswsusp and
acpid.

Tp_smapi does not seem to work at all.

Suspend works fine, even with status indicator.

ACPI
----

The only special keys that seems to work out of the box are the sleep,
wifi, and keyboard backlight keys. All of the others (volume,
brightness, etc.) need to be mapped using something like acpid. Here are
the relevant acpi events

    ac_adapter ACPI0003:00 00000080 00000000 # adapter unplugged
    ac_adapter ACPI0003:00 00000080 00000001 # adapter plugged-in
    battery PNP0C0A:00 00000080 00000001 # battery present
    button/mute MUTE 00000080 00000000 K
    button/volumedown VOLDN 00000080 00000000 K
    button/volumeup VOLUP 00000080 00000000 K
    video/switchmode VMOD 00000080 00000000 K
    button/prog1 PROG1 00000080 00000000 K # the thin button above F6
    video/brightnessdown BRTDN 00000087 00000000
    video/brightnessup BRTUP 00000086 00000000
    cd/prev CDPREV 00000080 00000000 K
    cd/play CDPLAY 00000080 00000000 K
    cd/next CDNEXT 00000080 00000000 K

I had no luck getting an acpi event for the microphone mute button.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lenovo_ThinkPad_X1&oldid=255356"

Category:

-   Lenovo
