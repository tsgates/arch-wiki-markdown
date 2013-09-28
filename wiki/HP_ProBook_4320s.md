HP ProBook 4320s
================

Note:Because of my bluetooth not working, I'am still stuck to the
uncomfortable option to master the ugly touthpad here. As of FEB/2012
this is still true, except that bluetooth can be enabled with a special
procedure involving Windows

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Device Information                                                 |
|     -   1.1 lspci model HP Probook 4320s P/N:WS904EA#ABB                 |
|     -   1.2 items of interest form lspci                                 |
|     -   1.3 other devices needing an attention                           |
|                                                                          |
| -   2 Configuration                                                      |
|     -   2.1 Networking                                                   |
|         -   2.1.1 WLAN                                                   |
|         -   2.1.2 Bluetooth [Not Working]                                |
|                                                                          |
|     -   2.2 Graphics                                                     |
|         -   2.2.1 Video card ATI                                         |
|                                                                          |
|     -   2.3 Input Devices                                                |
|         -   2.3.1 Clikpad (touchpad)                                     |
|         -   2.3.2 ClickPad with newest synaptics package                 |
|         -   2.3.3 Working w/o aditional settings in ../xorg.d/: with the |
|             newer Synaptics package                                      |
|         -   2.3.4 What's needed is the real buttons work                 |
|                                                                          |
|     -   2.4 Power related configurations                                 |
|         -   2.4.1 cpufreq                                                |
|         -   2.4.2 laptop-mode                                            |
|         -   2.4.3 lm-ensors                                              |
|                                                                          |
| -   3 External links                                                     |
+--------------------------------------------------------------------------+

Device Information
==================

There are many configurations for these models of HP Probooks. Mine is
like the following "lspci". Mostly, the stuff in lspci is pretty
meaningless, because your OS (most likely Arch) will pick up all the
device modules automatically, so you should't worry or pay too close
attention to them. The most and only items in the lspci are your
graphics card and your wireless networking card.

lspci model HP Probook 4320s P/N:WS904EA#ABB
--------------------------------------------

    00:00.0 Host bridge: Intel Corporation Core Processor DRAM Controller (rev 02)
    00:01.0 PCI bridge: Intel Corporation Core Processor PCI Express x16 Root Port (rev 02)
    00:16.0 Communication controller: Intel Corporation 5 Series/3400 Series Chipset HECI Controller (rev 06)
    00:1a.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 05)
    00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset High Definition Audio (rev 05)
    00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 1 (rev 05)
    00:1c.1 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 2 (rev 05)
    00:1c.3 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 4 (rev 05)
    00:1c.5 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI Express Root Port 6 (rev 05)
    00:1d.0 USB Controller: Intel Corporation 5 Series/3400 Series Chipset USB2 Enhanced Host Controller (rev 05)
    00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev a5)
    00:1f.0 ISA bridge: Intel Corporation Mobile 5 Series Chipset LPC Interface Controller (rev 05)
    00:1f.2 SATA controller: Intel Corporation 5 Series/3400 Series Chipset 6 port SATA AHCI Controller (rev 05)
    01:00.0 VGA compatible controller: ATI Technologies Inc Manhattan [Mobility Radeon HD 5000 Series]
    01:00.1 Audio device: ATI Technologies Inc Manhattan HDMI Audio [Mobility Radeon HD 5000 Series]
    44:00.0 Network controller: RaLink RT3090 Wireless 802.11n 1T/1R PCIe
    45:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 03)
    ff:00.0 Host bridge: Intel Corporation Core Processor QuickPath Architecture Generic Non-core Registers (rev 02)
    ff:00.1 Host bridge: Intel Corporation Core Processor QuickPath Architecture System Address Decoder (rev 02)
    ff:02.0 Host bridge: Intel Corporation Core Processor QPI Link 0 (rev 02)
    ff:02.1 Host bridge: Intel Corporation Core Processor QPI Physical 0 (rev 02)
    ff:02.2 Host bridge: Intel Corporation Core Processor Reserved (rev 02)
    ff:02.3 Host bridge: Intel Corporation Core Processor Reserved (rev 02)

items of interest form lspci
----------------------------

    44:00.0 Network controller: RaLink RT3090 Wireless 802.11n 1T/1R PCIe
    01:00.0 VGA compatible controller: ATI Technologies Inc Manhattan [Mobility Radeon HD 5000 Series]

other devices needing an attention
----------------------------------

Note: some updated information- read below.

-   Synaptics Clikpad (looks like a touchpad, but it has both of the
    buttons integrated in the overall touching zone of the touchpad).
-   Battery life!!! Huuuuge difference of battery life when win7 and
    Arch compared. I suspect it to be tricky configuration of
    lm-sensors, cpufreq, and acpi alltogether.

Updated information:

-   Clickpad It works pretty good, if package from AUR is isnstalled.
    This package removes the original xf86-input-synaptics package. With
    this AUR package, no /etc/X11/xorg.d/[files] are needed anymore,
    specially if you use gnome/kde of other environment settings. Both
    buttons work well, and both scrolling hor/vert are working too. If
    you want also the LED tapp to work, you must install another package
    form AUR.
-   Battery Well, it is still true for the most part, although utilising
    pm-utils configuration takes care of that quite well. One thing I
    cannot seem to figure out still is the cooling fans.

  

Configuration
=============

Networking
----------

> WLAN

Note: some updated information- read below.

This notebook comes, in my opinion, equiped the worst choice of wireless
hardware. Definetely, for linux users. The Ralink combo card RT3090 is
quite new, and Ralink promises extremely welcome support for the Linux
community. However, the drivers supplied by them are nothing more but a
pain and bunch of unstable, unusable lines of coding. So for now, let's
try using what's already there for us within the linux kernel.

There generally are two drivers. One of with is old and staging, and
another much newer, but probably not quite ready. The best choice is to
load the older rt2860sta driver and blacklist the rest.

-   add "rt2860sta" to the modules array in /etc/rc.conf
-   black list the rest. My /etc/modprobe.d/modprobe.conf looks like
    this

    blacklist rt2800pci
    blacklist rt61pci                                              
    blacklist rt2800usb
    blacklist rt2800lib
    blacklist rt2x00usb
    blacklist rt2x00lib
    blacklist rt2x00pci

-   if especially the rt2800pci is not blacklisted, it messes up your
    wireless stability.

-   Note, as of kernel version 3.0 this section's guide is deprecated.
    rt2800pci is currently the only working wifi method for this device.
    As noted above, connection stability is poor.

Updated information Untill the latest kernel rt2800pci module worked
good. This module is also the default one that get loaded automatically.
For me it was hugely unstable, so I started to dig into Ralink original
driver, and as of now I can declare some significant SUCCESSS. I have
been able to compile the Ralink driver (with many trials+errors) and it
seems to work alright. I seem to experience the speed overload issue [1]
however, but I am not sure whe the problem comes form just yet. Of
course, I can blame Rlinks alrgight, but just before I do that, I will
tinker with the driver settings prior-compiling. So far it helped. What
I did berofe compiling is his: In the original Ralink driver find , open
it with edit and edit lines: -

    file config.mk in os/linux folder:
    HAS_ATE=y (originally was n) - 
    HAS_WPA_SUPPLICANT=y (originally was n) - 
    HAS_NATIVE_WPA_SUPPLICANT_SUPPORT=y (originally was n) and - 
    HAS_ANTENNA_DIVERSITY_SUPPORT=y originally was n) 

Then compile as normal, install, and load the driver. I also did iwpriv
command to supress the uneeded log spit.

> Bluetooth [Not Working]

Note:Luckily bluetooth now WORKS, after the latest kernel upgrade

Note: after some time past, the bluetooth doesn't work again

As the half-mini wireless card RT3090 is a combo one, the bluetooth
radio is embeded together with wifi. The bluetooth device isn't listed
in lspci. However, is is visible with hciconfig -a command.
/etc/X11/xorg.conf.d # hciconfig -a

    hci0:	Type: BR/EDR  Bus: USB
    	BD Address: 70:F3:95:xx:xx:xx  ACL MTU: 310:10  SCO MTU: 64:8
    	UP RUNNING PSCAN 
    	RX bytes:778 acl:0 sco:0 events:40 errors:0
    	TX bytes:2112 acl:0 sco:0 commands:40 errors:0
    	Features: 0xff 0xff 0x8f 0xfe 0x9b 0xff 0x59 0x83
    	Packet type: DM1 DM3 DM5 DH1 DH3 DH5 HV1 HV2 HV3 
    	Link policy: RSWITCH HOLD SNIFF PARK 
    	Link mode: SLAVE ACCEPT 
    	Name: 'hpprobook'
    	Class: 0x580100
    	Service Classes: Capturing, Object Transfer, Telephony
    	Device Class: Computer, Uncategorized
    	HCI Version: 2.1 (0x4)  Revision: 0x149c
    	LMP Version: 2.1 (0x4)  Subversion: 0x149c
    	Manufacturer: Cambridge Silicon Radio (10)

Looks good as it should, but there is no radio activity! Nothing shows
up on scannig neither direction. I assume, the driver is either dead, or
I am missing something.

Note:Please, fill me in if you know how to get the bluetooth working
Bluetooth works only if dualbooted with windows, the hard wireless key
is disabled before rebooting, and then already in Linux, you press the
key again. This enables back the wireless device along with the
bluetooth radio as well.

Note:bccmd enabletx as root (or with sudo) works for me in Ubuntu, might
apply here too...

Graphics
--------

> Video card ATI

Not much to say.. Just install the required package with pacman and you
are all set. Your system will pick up the driver at the next lounch of
X. The package is xf86-video-ati. Works without an issue. FGLRX works
normally, that is to say, with poor stability and compatibility, Wine
gaming is

Input Devices
-------------

> Clikpad (touchpad)

Note: All the configs below are NOT needed if yo use Gnome or other DE
settings for your mouse/pad. All taps, buttons, scrolls are WORKING if
you install synaptics package from AUR

The touchpad -clickpad is a pain. Unless you are already using the
2.6.38 kernel (as you shoud) and xf86-input-synaptics 1.4.0-2 package
(wich came out pretty much the same day), your clikpad will be jittering
and acting annoyingly with the default settings. I managed to get it
working somewhat well by tweaking it with the
/etc/X11/xorg.d/10-synaptics.conf file see below.

Now - with the synaptics package older than "xf86-input-synaptics
1.4.0-2", there are many things to tweak to get your clikpad working
somewhat good. You will still miss the right-clik (the real click)
button though, but I worked around this problem by making a soft-clik
out of a two-finger touch that emulates the right-button click with
inserting "Option "RTCornerButton" "2" in the config file.

Note, that normaly you shoudn't have any other files in the ..xorg.d/
directory that state configurations for input devices, unless you need
specific configs for other input devices. When I connect external mouse,
it works without any specific configuration.

Here is my /etc/X11/xorg.conf.d/10-synaptics.conf file.

    # Config for clickpad ##
    Section "InputClass"
            Identifier "touchpad catchall"          ## As defined in ../10-evdev.conf file
            Driver "synaptics"
            MatchIsTouchpad "on"
            Option "SHMConfig" "true"               ## Alows you to run synclient commands on-the-fly. Good for testing
            MatchDevicePath "/dev/input/event*"
            Option "TapButton1" "1"
            Option "TapButton2" "3"
            Option "TapButton3" "0"
            Option "FastTaps"   "0"
            Option "LockedDrags" "flase"
            Option "TapAndDragGesture" "true"
            Option "MinSpeed"   "1"
            Option "MaxSpeed"   "1.95"              ## Found this value suiting best for me
            Option "AccelFactor"    "0.0115"        ## Also good for me
            #Option "AreaBottomEdge"  "3800"        ## Makes area around the real buttons insensitive for touch, disabled just because...
            Option "LeftEdge"        "1756"         ## Edge settins found to be correct
            Option "RightEdge"       "5258"
            Option "TopEdge"         "1622"
            Option "BottomEdge"      "3450"
            Option "FingerLow"  "30"                ## Managing sensitivity
            Option "FingerHigh" "50"                ## Also
            Option "MaxTapTime" "180"
            Option "MaxTapMove" "220"
            Option "VertEdgeScroll"      "true"
            Option "UpDownScrolling"    "true"        
            Option "VertScrollDelta"    "101"
            #Option "HorizEdgeScroll"    "true"    ## If enabled, the area right above real buttons will react to horizontal sroll, I prefer two-finger-scrolls for bot
    h ver and horiz 
            Option "HorizScrollDelta"   "88"
            Option "HorizTwoFingerScroll" "true"
            Option "VertTwoFingerScroll" "true"
            Option "RTCornerButton"    "2"         ## Right-top corner touch will emulate 3rd button press- good for pasting
            #Option "EmulateTwoFingerMinW" "5"
            #Option "HorizTwoFingerMinZ" "0"
            Option "CoastingFriction" "10"          ## Adds inertia for scrolls
            Option "CoastingSpeed"   "50"           ## Also
    EndSection

What is achieved with these setings are explained in the comments in the
file.

> ClickPad with newest synaptics package

Note: Users, please, help updating this information, as it is far from
complete

Now, with the newer package form Synaptics (1.4.0-2) I was really
expecting much more improvement. However, it comes with some degree of
dissapointment. First I tried to roll on without any aditional
configuration of the device. I left it with the default settings that
came with the new version of synaptics package.

-   First, the clickpad seems to work smoother than before - thank you!
-   However, the right-button is still missing. Vertical-two-finger
    sroll is working out-of-the-box - thank you!
-   The default sensitivity of the clickpad is set too much - bad!
-   None of the true wonders of clickpad are available (correct me if I
    am wrong)
    -   wonders like two-finger-zoom (stealed from apple),
    -   two-finger rotation,
    -   finger-movement inertia (really nice option- I very much like
        it),
    -   scrolling inertia (also very useful),
    -   Clickpad off button in the upper-left corner.

-   I have the opportunity to test all the wonders of the clickpad,
    because I double-boot my Probook with Windows7. Where all the
    features of the clickpad are available.

> Working w/o aditional settings in ../xorg.d/: with the newer Synaptics package

This is the default config file, let's use it and see how it goes..
/etc/X11/xorg.conf.d/10-synaptics.conf

    Section "InputClass"
            Identifier "touchpad catchall"
            Driver "synaptics"
            MatchIsTouchpad "on"
            MatchDevicePath "/dev/input/event*"
            Option "TapButton1" "1"
            Option "TapButton2" "2"
            Option "TapButton3" "3"
    EndSection

When reverting to using the same (my tweaked file) config file as listed
above, everything works pretty much the same as with the newer driver,
except that more options come default.

> What's needed is the real buttons work

Note:Please, contributors wanted to update this information

Power related configurations
----------------------------

Note:Everything here is related to the notebook running on batteries

So far I seem to have configured the following things to my
understanding, but the most annoying thing remains- battery life is BAD!
I can see outmost 1h50m when unplugged. In Win7 with the HP
PowerAssistant common tweaks, I see 3h40m right after unplugging.

-   Cooler fan is running, which makes me think, that the cpu's are
    overloaded. But they are not.
-   cpufreq-info says my cpu cores all are governed by the
    "conservative" mode. Later changed it to powersave mode.
-   command "watch grep \"cpu MHz\" /proc/cpuinfo" shows cpu cores at
    the lowest Mhz,
-   laptop-mode is enabled and configured properly.

> cpufreq

> laptop-mode

-   My settings in /etc/laptop-mode/conf.d/cpufreq.conf set the
    governing of cpu cores accordingly:

    BATT_CPU_MAXFREQ=fastest
    BATT_CPU_MINFREQ=slowest
    BATT_CPU_GOVERNOR=powersave
    BATT_CPU_IGNORE_NICE_LOAD=1
    LM_AC_CPU_MAXFREQ=fastest
    LM_AC_CPU_MINFREQ=slowest
    LM_AC_CPU_GOVERNOR=performance
    LM_AC_CPU_IGNORE_NICE_LOAD=1
    NOLM_AC_CPU_MAXFREQ=fastest
    NOLM_AC_CPU_MINFREQ=slowest
    NOLM_AC_CPU_GOVERNOR=performance
    NOLM_AC_CPU_IGNORE_NICE_LOAD=0

But actually, my fans run quieter when notebook is charging, and cpu
governor is "prformance". Can you beat that? Before I had the
"BATT_CPU_GOVERNOR=conservative" which seemed to log a unknown error.
Later I changed it to "powersave", and now my log reads:

    ACPI group/action undefined: processor / CPU0
    ACPI group/action undefined: processor / CPU1
    ACPI group/action undefined: processor / CPU2
    ACPI group/action undefined: processor / CPU3

I am not sure what this "action undefined" means. Hope nothing bad.

> lm-ensors

-   After configuring lm-sensors, the command "sensors" are not showing
    the RPM data of systems fans.

I suspect the problem to be there...

External links
==============

Another article on Arch and ProBook 4320s, with solutions to various
usability problems (audio, clickpad, wireless...).

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_ProBook_4320s&oldid=217404"

Category:

-   HP
