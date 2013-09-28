Dell Inspiron 8500
==================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Intro                                                              |
|     -   1.1 Summary                                                      |
|     -   1.2 To do                                                        |
|     -   1.3 Working                                                      |
|     -   1.4 Partially Working                                            |
|     -   1.5 Not Working                                                  |
|                                                                          |
| -   2 Kernel                                                             |
| -   3 X.org                                                              |
|     -   3.1 nVidia Geforce4 4200 Go (64 Mb)                              |
|     -   3.2 ATI Mobility Raedon 9600                                     |
|                                                                          |
| -   4 Hardware                                                           |
|     -   4.1 Infrared receiver                                            |
|                                                                          |
| -   5 Power Management                                                   |
|     -   5.1 CPU Scaling                                                  |
|     -   5.2 ACPI                                                         |
|                                                                          |
| -   6 See also                                                           |
|     -   6.1 General                                                      |
|     -   6.2 Linux on a Dell Inspiron 8500                                |
+--------------------------------------------------------------------------+

Intro
-----

> Summary

Arch Linux is my best experience so far with Linux on this computer,
even if it's a laptop! I've tried Mandrake 10, 10.1, Suse 9.2, Gentoo
2004.3 and Fedora Core 2 and 3. I really like the KISS philosophy!

> To do

-   Make swsusp2 work
-   Clean up of acpi/cpufreq with the governor chooser
-   ACPI daemon and events
-   Better kernel configuration display

> Working

-   Ethernet: Broadcom chip, use b44 module
-   Wireless: Dell TrueMobile 1300 ndiswrapper
-   Audio: ac97 (?)
-   Display: 1920x1200
-   Firewire
-   InfraRed (IrDa)

> Partially Working

-   nVidia Geforce4 4200 Go (64 Mb)

> Not Working

-   Modem

Kernel
------

A working v2.6.19 config is at https://pastebin.archlinux.org/345

X.org
-----

> nVidia Geforce4 4200 Go (64 Mb)

to do

> ATI Mobility Raedon 9600

my working /etc/X11/xorg.conf Note: I have an Alps touchpad that uses
the synaptics driver. You would need to install the "synaptics" package
to use it. (As configured below it has no tapping.)

  

    # **********************************************************************
    # Modules section. This allows modules to be specified
    # **********************************************************************

    Section "Module"

       Load "dbe"  	# Double buffer extension

       SubSection  "extmod"
         Option    "omit xfree86-dga"   # do not initialize the DGA extension
       EndSubSection

       Load "freetype"
       Load "glx"
       Load "dri"
       Load "drm"
       Load "synaptics"

    EndSection


    # ******************************
    # Files section
    # ******************************

    Section "Files"

       FontPath   "/usr/share/fonts/misc"
       FontPath   "/usr/share/fonts/TTF"
       FontPath   "/usr/share/fonts/local"
       
    EndSection


    # ******************************
    # Server flags section
    # ******************************

    Section "ServerFlags"

    EndSection


    # ******************************
    # Core keyboard's InputDevice section
    # ******************************

    Section "InputDevice"

       Identifier "Keyboard1"
       Driver	   "kbd"
       Option     "AutoRepeat" "500 30"
       Option     "XkbRules"   "xorg"
       Option     "XkbModel"   "dell101"
       Option     "XkbLayout"  "us"

    EndSection


    # ******************************
    # Core Pointer's InputDevice section
    # ******************************

    Section "InputDevice"

       Identifier "Generic Mouse"
       Driver "mouse"
       Option "Protocol" "Auto" # Auto detect
       Option "Device" "/dev/input/mice"
       Option "ZAxisMapping" "4 5 6 7"
       Option "Emulate3Buttons"

    EndSection

    Section "InputDevice"

       Driver     "synaptics"
       Identifier "Alps touchpad"
       Option     "Device" "/dev/input/mice"
       Option     "Protocol" "auto-dev"
       Option     "Emulate3Buttons"

       # synaptic driver specific options
       Option  "LeftEdge"        "1700"
       Option  "RightEdge"       "5300"
       Option  "TopEdge"         "1700"
       Option  "BottomEdge"      "4200"
       Option  "FingerLow"       "25"
       Option  "FingerHigh"      "30"
       Option  "MaxTapTime"      "180"
       Option  "MaxTapMove"      "220"
       Option  "VertScrollDelta" "100"
       Option  "MinSpeed"        "0.4"
       Option  "MaxSpeed"        "0.5"
       Option  "AccelFactor"     "0.01"
       Option  "SHMConfig"       "on"
       # Option  "Repeater"    "/dev/ps2mouse"

    EndSection


    # ******************************
    # Monitor section
    # ******************************

    Section "Monitor"

       Identifier  "Dell Inspiron 8500 WXGA LCD"
       HorizSync   15-100
       VertRefresh 15-100

    EndSection


    # ******************************
    # Graphics device section
    # ******************************

    Section "Device"

       Identifier  "ATI Mobility Radeon 9600"
       Driver      "radeon"
       Option "AGPMode" "4"

    EndSection


    # ******************************
    # Screen sections
    # ******************************

    Section "Screen"

       Identifier   "Screen 1"
       Device       "ATI Mobility Radeon 9600"
       Monitor      "Dell Inspiron 8500 WXGA LCD"
       DefaultDepth 24

       Subsection "Display"
           Depth    24
           Modes    "1280x800"
           ViewPort 0 0
       EndSubsection

    EndSection


    # ******************************
    # ServerLayout sections.
    # ******************************

    Section "ServerLayout"

       Identifier  "Layout 1"
       Screen      "Screen 1"
       InputDevice "Alps Touchpad" "CorePointer"
       InputDevice "Keyboard1" "CoreKeyboard"

    EndSection


    # ******************************
    # DRI extension options section
    # ******************************

    Section "DRI"
       Group "video"
       Mode 0666
    EndSection

    Section "Extensions"
       Option "Composite" "Enable"
       Option "RENDER"    "Enable"
    EndSection

Hardware
--------

> Infrared receiver

First shutdown computer, reboot and enter the BIOS by pressing F2. Find
the Infrared option, enable it (it is disable by default!) and set it to
COM2. Visit LIRC's webpage and download their latest CVS snapshot.
Extract, go into directory and run setup.sh :

    > wget http://lirc.sourceforge.net/software/snapshots/lirc-0.8.1pre3.tar.bz2
    > tar -jxvf lirc-0.8.1pre3.tar.bz2
    > cd lirc-0.8.1pre3
    > ./setup.sh

Then select :

    1 Driver configuration
    --> 6 IrDA hardware
       --> 1 SIR IrDA (built-in IR ports)
    3 Save configuration & run configure

Now make it :

    make && sudo make install

Be sure you do not have the irdautils package. It blocks the serial
port. You will need to load the "lirc_sir" module. If you got error
like :

    lirc_sir: i/o port 0x02f8 already in use.

in dmesg, run this command as root :

    # /bin/setserial /dev/ttyS1 uart none

then try again to modprobe "lirc_sir". If it works, create the file
"/etc/modprobe.d/lirc" and put is that line :

    install lirc_sir /bin/setserial /dev/ttyS1 uart none; /sbin/modprobe --ignore-install lirc_sir

This will run the command above each time you try to modprobe the
"lirc_sir" module. Add the module to autoload (/etc/modules).

Now continue as the installation procedure of lirc.

  

Power Management
----------------

I suggest you read Gentoo Power Management Guide for great information.
After some work on this I wanted to add some information specific to the
I8500.

> CPU Scaling

See CPU Frequency Scaling.

> ACPI

To turnoff the computer when you press the power button, put the
following in /etc/acpi/handler.sh

    button/power)
           case "$2" in
               PBTN)
                       logger "PowerButton pressed: $2"
                       halt
               ;;
               *)    logger "ACPI action undefined: $2" ;;
           esac

Replace the "halt" line with the shutdown command of your choice.

  
 To turn off the backlight of an ATI Radeon Mobility card, put the
following in /etc/acpi/handler.sh

    button/lid)
           case "$2" in
               LID)
                   logger "ACPI button/lid action"
                   STATE=`radeontool light`
                   case "$STATE" in
                       "The radeon backlight looks on") radeontool light off ;;
                       "The radeon backlight looks off") radeontool light on ;;
                   esac
                   ;;
           esac
           ;;

This requires that you have the radeontool package installed (it is in
AUR). You also need to add "acpid" to the DAEMONS array in /etc/rc.conf.

See also
--------

> General

-   Gentoo Power Management Guide
-   Gentoo Dell Inspiron 8500 Wiki
-   Software Suspend 2
-   Linux on Laptops
-   This report is listed at the TuxMobil: Linux Laptop and Notebook
    Installation Guides Survey: DELL.

> Linux on a Dell Inspiron 8500

-   RedHat 9.0
-   Debian

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dell_Inspiron_8500&oldid=238765"

Category:

-   Dell
