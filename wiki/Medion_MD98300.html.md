Medion MD98300
==============

Contents
--------

-   1 Introduction
-   2 Hardware information
    -   2.1 lspci
    -   2.2 lsusb
-   3 W-LAN
-   4 Soundcard
    -   4.1 Compile the newest Alsa-driver
    -   4.2 Unmute channels
    -   4.3 Mute your speakers and use your headset
    -   4.4 Recording
-   5 Graphicscard
    -   5.1 Nv (free driver)
    -   5.2 Nvidia (non-free driver)
        -   5.2.1 Xorg.conf
-   6 Tweaks
    -   6.1 Cpufrequtils
    -   6.2 Disk related tweaks
        -   6.2.1 Disable file access time
        -   6.2.2 Laptop mode tools
        -   6.2.3 Ionice
    -   6.3 Touchpad tweaks

Introduction
============

Since I had a hard time getting my Laptop working with Arch (especially
sound drivers) I decided to write this wiki entry to make it easier for
people with the same problem. You can buy Medion Laptops at ALDI. This
report is listed at TuxMobil.

Hardware information
====================

Just for people who own similar hardware.

lspci
-----

    00:00.0 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
    00:00.1 RAM memory: nVidia Corporation C51 Memory Controller 0 (rev a2)
    00:00.2 RAM memory: nVidia Corporation C51 Memory Controller 1 (rev a2)
    00:00.3 RAM memory: nVidia Corporation C51 Memory Controller 5 (rev a2)
    00:00.4 RAM memory: nVidia Corporation C51 Memory Controller 4 (rev a2)
    00:00.5 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
    00:00.6 RAM memory: nVidia Corporation C51 Memory Controller 3 (rev a2)
    00:00.7 RAM memory: nVidia Corporation C51 Memory Controller 2 (rev a2)
    00:02.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1)
    00:03.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1)
    00:05.0 VGA compatible controller: nVidia Corporation C51 [Geforce 6150 Go] (rev a2)
    00:09.0 RAM memory: nVidia Corporation MCP51 Host Bridge (rev a2)
    00:0a.0 ISA bridge: nVidia Corporation MCP51 LPC Bridge (rev a3)
    00:0a.1 SMBus: nVidia Corporation MCP51 SMBus (rev a3)
    00:0a.3 Co-processor: nVidia Corporation MCP51 PMU (rev a3)
    00:0b.0 USB Controller: nVidia Corporation MCP51 USB Controller (rev a3)
    00:0b.1 USB Controller: nVidia Corporation MCP51 USB Controller (rev a3)
    00:0d.0 IDE interface: nVidia Corporation MCP51 IDE (rev f1)
    00:0e.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller (rev f1)
    00:10.0 PCI bridge: nVidia Corporation MCP51 PCI Bridge (rev a2)
    00:10.1 Audio device: nVidia Corporation MCP51 High Definition Audio (rev a2)
    00:14.0 Bridge: nVidia Corporation MCP51 Ethernet Controller (rev a3)
    00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
    00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
    00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
    00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
    03:09.0 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller
    03:09.1 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 19)
    03:09.2 System peripheral: Ricoh Co Ltd R5C843 MMC Host Controller (rev 0a)
    03:09.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter (rev 05)
    03:09.4 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev ff)

lsusb
-----

    Bus 001 Device 002: ID 0ace:1215 ZyDAS WLA-54L WiFi
    Bus 001 Device 001: ID 1d6b:0002
    Bus 002 Device 002: ID 04d9:0499 Holtek Semiconductor, Inc.
    Bus 002 Device 001: ID 1d6b:0001

W-LAN
=====

Wireless LAN should work out of the box. I didn't test it so far as I
prefer a wired connection.

Soundcard
=========

This Notebook has a Realtek ALC 833. Run

    cat /proc/asound/version

If it returns

    Advanced Linux Sound Architecture Driver Version 1.0.17.

(or a higher version) then continue reading at Edit modprobe.conf

Compile the newest Alsa-driver
------------------------------

Go to the AlsaProject download-page and download the Stable Release of
alsa-driver. Then unpack and compile the package:

    tar -xf alsa-driver-xxx
    cd alsa-driver-xxx
    ./configure --with-cards=hda-intel --with-sequencer=yes
    make

Finally run this as root:

    make install

Note: You must do this everytime you (re-)install or your kernel,
because its (old) alsa-module overwrites the one you just installed.

Unmute channels
---------------

Open a terminal and type

    alsamixer

Use the arrow keys to turn up volume where you need it.

Mute your speakers and use your headset
---------------------------------------

You might have noticed that your speakers do not get muted automatically
when you put in your earphones. Here's my solution to do that manually:
Open up alsamixer (like described before) Mute Surround by pressing M
(for mute), so it says MM instead of 00. Now you won't hear anything
from the built-in speakers, but you can use your earphones.

Recording
---------

Start alsamixer, navigate to 'mic' and set it to capture by pressing the
'spacebar' key on keyboard; the word 'capture' will appear at the bottom
of the 'Mic' control when capture is set.[1]

Graphicscard
============

There are two possible drivers you can use for the Nvidia 6150 Geforce
Go. I recommend the non-free driver, because the open one had no mouse
cursor as I tried it (which was really annoying). If you want
3d-allocation, you must use the closed source one.

Nv (free driver)
----------------

Installation:

    pacman -S nv

Here's no customized xorg.conf yet. Go make one yourself following this
guide and post it here.

Nvidia (non-free driver)
------------------------

Installation:

    pacman -S nvidia

Note: The xorg.conf is based on this one which was made for gentoo.[2]

Save the following as /etc/X11/xorg.conf:

> Xorg.conf

    Section "ServerLayout"
        Identifier     "X.org Configured"
        Screen      0  "Screen0" 0 0
      # Screen      1  "Screen1" RightOf "Screen0"
        InputDevice    "Mouse0" "CorePointer"
        InputDevice    "Keyboard0" "CoreKeyboard"
    EndSection

    Section "Files"
        RgbPath         "/usr/share/X11/rgb"
        ModulePath      "/usr/lib/xorg/modules"
        FontPath        "/usr/share/fonts/misc"
        FontPath        "/usr/share/fonts/100dpi:unscaled"
        FontPath        "/usr/share/fonts/75dpi:unscaled"
        FontPath        "/usr/share/fonts/TTF"
        FontPath        "/usr/share/fonts/Type1"
    EndSection

    Section "Module"
        Load           "extmod"
        Load           "glx"
        Load           "dbe"
        Load           "record"
        Load           "xtrap"
        Load           "freetype"
    EndSection

    Section "ServerFlags"
        Option         "Xinerama" "0"
    EndSection

    Section "InputDevice"
        # generated from data in "/etc/conf.d/gpm"
        Identifier     "Mouse0"
        Driver         "mouse"
        Option         "Protocol"
        Option         "Device" "/dev/input/mice"
        Option         "Emulate3Buttons" "no"
        Option         "ZAxisMapping" "4 5"
            Driver          "synaptics"
            Option          "Name"                  "Synaptics Touchpad"
            Option          "Device"                "/dev/input/mice"
            Option          "Protocol"              "auto-dev"
            Option          "SendCoreEvents"        "true"
            Option          "SHMConfig"             "true"
            Option          "LeftEdge"              "1900"    
            Option          "RightEdge"             "5900"
            Option          "TopEdge"               "1900"
            Option          "BottomEdge"            "4350"
            Option          "FingerHigh"            "25"
            Option          "FingerLow"             "20"
            Option          "MaxTapMove"            "220"
            Option          "MaxTapTime"            "180"
            Option          "MaxDoubleTapTime"      "180"
            Option          "MinSpeed"              "0.04"
            Option          "MaxSpeed"              "0.18"
            Option          "AccelFactor"           "0.001"
            Option          "VertScrollDelta"       "100"
            Option          "HorizScrollDelta"      "100"
            Option          "EmulateMidButtonTime"  "0"
            Option          "RTCornerButton"        "0"
            Option          "RBCornerButton"        "0"
            Option          "LTCornerButton"        "2"
            Option          "LBCornerButton"        "0"
    	#Option      	"CircularScrolling"     "on"
            #Option      	"CircScrollTrigger"     "2"

    EndSection

    Section "InputDevice"
        # generated from default
        Identifier     "Keyboard0"
        Driver         "kbd"
        Option         "XkbModel" "pc105"
        Option         "XkbLayout" "de"
        Option         "XkbRules" "xorg"
    EndSection

    Section "Monitor"
        # HorizSync source: edid, VertRefresh source: edid
        Identifier     "Monitor0"
        VendorName     "Unknown"
        ModelName      "LPL"
        HorizSync       30.0 - 75.0
        VertRefresh     60.0
        Option "DPMS" "True"

    EndSection

    Section "Device"
        Identifier     "Videocard0"
        Driver         "nvidia"
        VendorName     "NVIDIA Corporation"
        BoardName      "GeForce Go 6150"
        Option         "NVAgp"         "3"
        Option         "RenderAccel" "true"
        Option         "Coolbits" "1" 
        Option         "AllowGLXWithComposite" "true"
        Option    	   "AddARGBGLXVisuals" "True"
        Option	   "TripleBuffer" "false" #we do not have too much ram.
        Option         "NoLogo" "1"
        Option         "DPMS" "TRUE"
        Option "BackingStore" "True"
        Option "DamageEvents" "True"
        Option "RegistryDwords" "PerfLevelSrc=0x3333"
        Option         "OnDemandVBlankInterrupts" "True"


    EndSection

    Section "Screen"
        Identifier     "Screen0"
        Device         "Videocard0"
        Monitor        "Monitor0"
        DefaultDepth    24
        Option         "metamodes" "1280x800 +0+0; 800x600 +0+0; 640x480 +0+0"
        SubSection     "Display"
            Depth       24
            Modes      "1600x1200" "1280x1024" "1024x768" "800x600" "640x480"
        EndSubSection
    EndSection

    Section "Extensions"    
    	Option "Composite" "Enable"
    EndSection

Tweaks
======

Cpufrequtils
------------

Cpufrequtils is a CPU Frequency Scaling, a technology used primarily by
notebooks which enables the OS to scale the CPU speed up or down,
depending on the current system load and/or power scheme. Note that the
module you need to load at the CPU Frequency Driver part is powernow-k8.

Disk related tweaks
-------------------

> Disable file access time

Doesn't write the access time every time you read or modify a file. See
here.

> Laptop mode tools

They allow your HD to spin down when it isn't used. See here.

> Ionice

If you plan to copy a big file or do some other hard-disk-stressing
operation, your MD98300 will totally hang until its done under linux
(thats at least my experience). With ionice, you can start applications
with a different read/write scheduling class so it doesn't hang anymore.

Installation:

    pacman -S ionice

(I'm not sure about that because it seems to be in a group - but pacman
knows everything so it should point you to the right way)

Here's an example how to use it:

    ionice -c 3 cp /path/to/huge/file /path/of/the/copy

It starts cp with the scheduling class idle. That means that you
shouldn't get a hanging system while it is copying (although it will
need longer, but thats the deal).

More information in the man page[3]:

    man ionice

Touchpad tweaks
---------------

On this page are a few cool tweaks like circular scrolling.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Medion_MD98300&oldid=298147"

Category:

-   Laptops

-   This page was last modified on 16 February 2014, at 07:20.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
