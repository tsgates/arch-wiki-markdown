ASUS Eee PC 1215n
=================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: This article     
                           mentions acpi_call and   
                           legacy Bumblebee         
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This page includes general information regarding Asus EEE PC 1215n and
related notes on installing/using Arch Linux on it.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 System Specs                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Wireless and Bluetooth                                       |
|     -   2.2 Media- and FN-keys                                           |
|     -   2.3 nVidia ION 2 with Optimus                                    |
|     -   2.4 Bumblebee Installation                                       |
|     -   2.5 Relevant links                                               |
|                                                                          |
| -   3 Problems                                                           |
|     -   3.1 Nvidia graphic card                                          |
|     -   3.2 Bluetooth                                                    |
|     -   3.3 CPU power consumption                                        |
+--------------------------------------------------------------------------+

System Specs
============

CPU: Intel Atom D525 1.83GHz 667 MHz CPU, 1MB L2 Cache

RAM: 2GB 1066MHz DDR3

HDD: 250/320GB 5400RPM

GPU: nVidia ION2 with Optimus (see below)

Display: 12.1" 1366x768 LED display

Wireless: Broadcom BCM4313 802.11 b/g

Bluetooth: TODO

Webcam: TODO

Card Reader: TODO

Extras: Two USB 3.0 ports, Bluetooth 3 (optional)

Configuration
=============

Wireless and Bluetooth
----------------------

PS : With the new Kernel (3.0+) there is no need for any of the
procedure below, because Wireless and Bluetooth work out of box ^^

Wireless: In order to use Wireless with the BCM4313 (Linux Kernel 3.0+)
you need to blacklist bcmia by editing your
/etc/modprobe.d/modprobe.conf and add this :

    # blacklist bcma

Then restart and you can now use your BCM4313 normally :D

Bluetooth: BCM4313 --> Install packages to manager Bluetooth like
"bluez", "bluez-firmware".

    # sudo pacman -S bluez bluez-firmware 

And then activate them by adding the bluetooth to the Daemons of the
"/etc/rc.conf" configuration file.

    # sudo nano /etc/rc.conf

And then add to bluetooth to the Daemons:

    # DAEMONS=(... bluetooth)

Restart the all thing, so you can use the Bluetooth and/or the Wireless

For more information about installing and configuration bluetooth, take
a look at the "Arch Linux Bluetooth Wiki"[1].

Media- and FN-keys
------------------

example ~/.xbindkeysrc configuration

    #Muter/UnMute
    "amixer set "Master" toggle"
        m:0x0 + c:121
        XF86AudioMute 
    #Volume up
    "amixer set "Master" 5%+"
        m:0x0 + c:123
        XF86AudioRaiseVolume 
    #Volume down
    "amixer set "Master" 5%-"
        m:0x0 + c:122
        XF86AudioLowerVolume 
    #MPD next song
    "mpc next"
        m:0x0 + c:171
        XF86AudioNext 
    #MPD stop playing
    "mpc stop"
        m:0x0 + c:174
        XF86AudioStop 
    #MPD prev song
    "mpc prev"
        m:0x0 + c:173
        XF86AudioPrev 
    #MPD pase/unpause
    "mpc toggle"
        m:0x0 + c:172
        XF86AudioPlay 

nVidia ION 2 with Optimus
-------------------------

nVidia Optimus is basically a software configuration that utilizes an
Intel IGP + an nVidia GPU that writes to the Intel IGP's framebuffer.
This is all done on the software side. The nVidia GPU is not wired to
the outputs (VGA, HDMI etc.) At the time of this writing (September 27,
2010) Optimus on Linux sucks (i.e. doesn't work at all). You can still
use the Intel IGP, but there is no way to access the discrete GPU. DO
NOT try to install the nVidia binary driver, you have been warned.

Things are not that bad however. There is a kernel module called
"acpi_call" which enables you to power off the nVidia GPU, hence you can
significantly improve battery life.

David Airlie seems to be working on PRIME support (google it). You can
also try "bumblebee-git" from the aur, which is the first working
soloution to get the nvidia-card besides the intel gpu working.

Module auto-detection may load the nouveau module, but this sometimes
seems to cause X to crash after boot-up, so try blacklisting this module
if you encounter this problem.

Update 1 : There is a new project, called Bumblebee (Transformers
reference) that allows you to use the Nvidia Optimus ION2, but not
natively, you have to instale it, and then call each program on the
terminal with a command... (see more informations here[2] and here[3])

Bumblebee Installation
----------------------

Recently tested Bumblebee installation with kernel 3.1.8 and nvidia
driver 290.10, which is installed as part of bumblebee package.

Install Bumblebee from AUR and follow instructions here

Output from Optirun Test

After installation, use

    # glxgears 

and

    # optirun glxgears

for comparison of integrated and dedicated GPU rendering (integrated GPU
~60 FPS)

The default compression method for the dedicated GPU is "proxy" (lower
compression).

By changing the compression method while using Nvidia Optimus, the FPS
can be increased or decreased, some results (by compression method and
approx. FPS, respectively):

proxy 220, jpeg 340, rgb 280, yuv 330.

Power Management

On the wiki page, there are warnings about using power management with
Bumblebee, essentially turning the card on and off using "acpi_call"
module. Testing so far hasn't produced any problems....

The two files, cardon and cardoff, containing the commands used to
control Nvidia Optimus need to be created in "/etc/bumblebee" for the
1215n with the following commands:

"/etc/bumblebee/cardon"

    \_SB.PCI0.P0P4.GFX0._PS0

"/etc/bumblebee/cardoff"

    \_SB.PCI0.P0P4.GFX0._DSM  {0xF8,0xD8,0x86,0xA4,0xDA,0x0B,0x1B,0x47,0xA7,0x2B,0x60,0x42,0xA6,0xB5,0xBE,0xE0} 0x100 0x1A {0x1,0x0,0x0,0x3}
    \_SB.PCI0.P0P4.GFX0._PS3

Relevant links
--------------

http://airlied.livejournal.com/71734.html

https://launchpad.net/~hybrid-graphics-linux

http://linux-hybrid-graphics.blogspot.com/2010/02/howto-install-vgaswitcheroo-for-linux.html

https://aur.archlinux.org/packages.php?ID=48866 (AUR for Bumblebee)

https://github.com/MrMEEE/bumblebee/ (Bumblebee Project Git)

Problems
========

Nvidia graphic card
-------------------

On the default kernel (2.6.36 branch) you cannot suspend system after
disabling nvidia card with "acpi_call" module (nor after turning it on
once you disabed it). This bug affects also turning off laptop (you'll
have to manually power off laptop with power button). Using LTS 2.6.32
kernel ("kernel26-lts" package) allows you to safely power off/suspend
netbook with disabled nvidia card (but with older kernel you won't be
able to use some eee Fn hotkeys: disabling LCD/external output, volume
controls, playback controls).

Update (after a little testing):

With the latest kernel running (3.0) and the "acpi_call" module
installed from AUR, the suspend and hibernate scripts used by pm-utils
will work (from commandline and in Gnome 3) as long as the acpi_call
module is added to the suspend modules list used by the scripts.

Create a file modules in /etc/pm/config.d and paste in the line below.

     SUSPEND_MODULES="acpi_call"

Bluetooth
---------

Turning on bluetooth freezes the system. Need to do hard reset. No more
info about this atm.

CPU power consumption
---------------------

There is a kernel parameter which must be added in linux 3.0 kernel to
use energy saving feature of the intel driver:
pcie_aspm=force i915.i915_enable_rc6=1, see this thread.

Retrieved from
"https://wiki.archlinux.org/index.php?title=ASUS_Eee_PC_1215n&oldid=238823"

Category:

-   ASUS
