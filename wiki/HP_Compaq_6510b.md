HP Compaq 6510b
===============

The HP 6510b is a compact yet powerful laptop with a high-resolution
screen (if you pick the WXGA+ version). It has been labeled "Novel SuSE
Enterprise certified" by HP, which should mean Linux runs fine on it.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Hardware specifications                                            |
| -   2 Setup                                                              |
|     -   2.1 CPU Frequency Scaling                                        |
|     -   2.2 X3100 onboard GPU                                            |
|     -   2.3 IPW3945 ABG wireless LAN                                     |
|     -   2.4 Broadcom NetLink BCM5787M Gigabit LAN                        |
|     -   2.5 Suspension and hibernation                                   |
|     -   2.6 FireWire                                                     |
|     -   2.7 AuthenTec AES2501 fingerprint reader                         |
|     -   2.8 Tactile strip                                                |
|     -   2.9 lspci output                                                 |
|     -   2.10 lsusb output                                                |
+--------------------------------------------------------------------------+

Hardware specifications
-----------------------

-   Intel Core 2 Duo T7100 / T7300
-   2 GB of DDR2 533 Mhz SO-DIMM
-   14.1" 1280x800 WXGA / 1440x900 WXGA+ TFT
-   Intel GMA965GM chipset with X3100 onboard GPU
-   IPW3945 a/b/g wireless LAN miniPCI with wireless hardware switch
-   Broadcom Tigon Gigabit LAN adapter
-   Infineon TPM
-   AuthenTec AES2501 fingerprint reader
-   built-in Bluetooth
-   cardreader (supporting SD, MemoryStick, ea.)
-   4x USB 2.0
-   1x FireWire 400 4-pin connector

Setup
-----

> CPU Frequency Scaling

See the main CPU Frequency Scaling article.

> X3100 onboard GPU

Feature-wise this is an awesome GPU. Opensource drivers that support 3D
out of the box. However, it has a problem many of the Intel GPUs have:
it will stick to VESA resolutions in the framebuffer. Since the only
fitting resolution is 1024x768, that is what you'll when using a
framebuffer (on boot, and in a command line environment). You can check
what modes the GPU supports like this:

    [stijn@lysithea ~]$ cat /sys/class/graphics/fb0/modes
    U:1024x768p-75

As you can see this is the only resolution. According to the uvesafb
FAQ, if that's all you get, not even uvesafb can fix it up for you. For
earlier chipsets (865 and 915 for example) tools like 855resolution and
915resolution are available, but the latter does not support the Intel
G965M yet.

There are modified PKGBUILDs and patches to fix that, but the URLs
provided on this page before do not exist anymore. They allow you to set
the 1440x900 resolution, but one needs to dig far deeper into the system
to get the system booting in that resolution, it seems.

> IPW3945 ABG wireless LAN

You have two choices for this card, either go with the present (and soon
to be phased out) ieee80211 stack, or with the successor, the mac80211
stack. Both are present in the Arch kernel from 2.6.22 on. With the
former you'll need Intel's proprietary regulatory daemon and firmware,
and - last but not least - the driver; the latter does not require any
regulatory daemon, but still requires the driver and firmware to be
installed.

Note: each driver needs different firmware!

The radio switch is hardware (it sits on the tactile strip), which is
pretty convenient. Just touch it and the radio gets enabled. The switch
could also be pretty shitty at times, as it will disable radio if you
scrape away some dust from the tactile strip.

> Broadcom NetLink BCM5787M Gigabit LAN

No setup required, it just needs the tg3 module.

  

> Suspension and hibernation

In the early days, there were a bunch of different hacks that you had to
perform in order to be able to suspend/hibernate your 6510b. Nowadays,
all you should need is the following:

    sudo pacman -S pm-utils

That will install the pm-utils package which contains the programs
pm-suspend, pm-hibernate, etc. To suspend to RAM, just do the following:

    sudo pm-suspend

...and to hibernate...

    sudo pm-hibernate

Pretty straight-forward! There is also a "hybrid", called
pm-suspend-hybrid. What this does is that it does everything it needs to
hibernate and then suspends the computer instead of shutting it down, as
it normally would when hibernating! So if you do not run out of power
during this suspended state, you can start the computer up again as if
it was a normal supension—if you do run out of power, it would just act
like a normal hibernation.

> FireWire

FireWire is supported out of the box, however, for FireWire HD support,
you might need to load the sbp2 module (that is, if you are using the
common stack, since a new one is in the works and already present in the
kernel). You have the common stack if you run stock Arch kernels.

  

> AuthenTec AES2501 fingerprint reader

As duly pointed out on the forums, fingerprint readers are more a threat
to your privacy than a safeguard. Your fingerprints (unless you are
paranoid and type with gloves on) are likely to be all over your
keyboard, rendering the 'security' purpose of this device useless. Keep
this in mind if you intend to use the reader as a replacement for your
password; fingerprints can be duplicated easily with basic stuff
(graphite ea.).  
 There is a utility called fprint available, together with a libfprint
library it depends on. Both are packaged for Arch Linux. The fprint
program is still called fprint_demo for the moment, but it works :-).
Integration with the login manager seems possible - for that you'll need
amongst others the pam_fprint module installed (find a PKGBUILD here).
Afer installing the package, run

    pam_fprint_enroll

and follow the instructions to scan the finger you want to use for
authentication. The next step is to configure PAM. First edit
/etc/pam.d/login, and make the first lines look like this:

    #%PAM-1.0
    auth            required        pam_securetty.so
    auth            requisite       pam_nologin.so
    auth            sufficient      pam_fprint.so
    auth            required        pam_unix.so nullok
    auth            required        pam_tally.so onerr=succeed file=/var/log/faillog

This will make PAM accept a successful fingerprint scan as a valid login
token, if the scan fails, it will fall back to a password. From this
moment on, you'll be able to log on with a scan on a tty - enter your
username, press Enter, and scan the finger you told pam_fprint_enroll to
use as default. Voilà :-).

On the forum you can also find a topic that covers setting up your
fingerprint reader with PAM and SLiM, but this is with the aes2501
kernelspace driver.

> Tactile strip

This laptop sports a fancy tactile strip, providing some extra buttons
as well as volume control (toggling mute and changing volume). I have
not tried yet to get hal working for my multimedia keys yet, the present
solution works fine. Enter keytouch: The HP NC6320 settings
(pre-supplied by keytouch) seem to work just fine for muting & adjusting
the volume. The 'Help' key (left to the radio switch) fires up your DE's
help center if everything goes well, the button to the right is
recognised too (you have to configure it though ;-)). As a fancy plus,
you'll get a nice OSD when you mute/unmute or change volume.

> lspci output

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
    00:1c.4 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 5 (rev 03)
    00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 (rev 03)
    00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #2 (rev 03)
    00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #3 (rev 03)
    00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 03)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3)
    00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface Controller (rev 03)
    00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) IDE Controller (rev 03)
    00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E) SATA AHCI Controller (rev 03)
    02:04.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev b6)
    02:04.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller (rev 02)
    10:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG Network Connection (rev 02)
    18:00.0 Ethernet controller: Broadcom Corporation NetLink BCM5787M Gigabit Ethernet PCI Express (rev 02)

  

> lsusb output

    Bus 007 Device 001: ID 0000:0000  
    Bus 006 Device 001: ID 0000:0000  
    Bus 005 Device 001: ID 0000:0000  
    Bus 004 Device 001: ID 0000:0000  
    Bus 003 Device 003: ID 08ff:2580 AuthenTec, Inc. 
    Bus 003 Device 001: ID 0000:0000  
    Bus 002 Device 001: ID 0000:0000  
    Bus 001 Device 003: ID 03f0:171d Hewlett-Packard 
    Bus 001 Device 001: ID 0000:0000

The AuthenTec device is the fingerprint reader, the Hewlett-Packard one
is the Bluetooth module.

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_Compaq_6510b&oldid=237798"

Category:

-   HP
