Smartlink Modem drivers
=======================

Contents
--------

-   1 How to install Smartlink Modem drivers
    -   1.1 From README
    -   1.2 Installation
        -   1.2.1 Configuration of "normal modem"
        -   1.2.2 Configuration of "Alsa Modems" (Alsa Mode)
    -   1.3 3. NOTE:

> How to install Smartlink Modem drivers

From README

    Introduction:
    This is Smart Link Soft Modem for Linux version 2.9. It provides
    full-featured 56K Voice Fax Modem.
    This is implemented as generic application (slmodemd) and set of
    hardware specific kernel-space drivers (slamr, slusb).
    ALSA modem drivers may be used instead of proprietary ones (see ALSA mode).

    Features:

    Modem: V.92, V.90, V.34, V.32bis, V.32, V.23, V.22, V.21, Bell 103/212.
    Flow control: V.42.
    Compression: V.44, V.42bis.
    Fax: Class 1.
    Voice: V253 like modem.
    Multiple modems are supported.


    Supported Hardware:

    HAMR5600 based AMR/CNR/MDC/ACR modem cards on the following Southbridge
    chips:
    - Intel ICH0,ICH2, ICH3, ICH4
    - Via 686A, 686B, 8231, 8233
    - SiS 630
    - ALI 1535.
    SmartPCI56/561/562/563 based PCI modem cards.
    SmartUSB56 based USB modem.

    ALSA has the built-in modem drivers included in 'alsa-driver' >= 1.0.2
    and in Linux kernel. Currently there is 'intel8x0m' (snd-intel8x0m)
    modem driver, which supports ICH based AC97 modems (MC97).

    Recent 'alsa-driver' (>=1.0.6) has also support for NVidia NForce
    (snd-intel8x0m) and ATI IXP (snd-atiixp-modem) based modems.

Installation

Install slmodem from the AUR.

Configuration of "normal modem"

In /etc/rc.conf:

-   Add ppp_generic, slamr or slusb to modules list
-   Add slmodem daemon list

/etc/conf.d/slmodem:

-   Modify to your needs especially   
     /dev/slamr0 #(depends on your chipset slamr' or 'slusb')   
    --country=USA #(See output of 'slmodemd --countrylist')

Configuration of "Alsa Modems" (Alsa Mode)

/etc/rc.conf:

-   Add ppp_generic and snd_intel8x0m modules list
-   Add slmodem-alsa to daemon list

/etc/conf.d/slmodem-alsa:

-   Modify to your needs especially   

--country=USA #(See output of 'slmodemd --countrylist')

    IMPORTANT:
    It is possible that you have to add an additional device entry.
    A useful "detector" is command aplay -l which shows the list of existing ALSA
    devices with a description.

-   add one of the following: hw:0,hw:1,modem:0 or modem:1   
     to /etc/conf.d/slmodem-alsa at the end of the SLMODEM_ARGS line!   
     eg.: SLMODEM_ARGS"--country=USA --alsa hw:1"

The modem device is called /dev/ttySL0 and is symlinked to /dev/modem if
you use udev.

3. NOTE:

If pppd quits with an ERROR 1 just after connection, change auth to
noauth in /etc/ppp/options or use the call option (see the pppd
manpage). wvdial requires option 'Carrier Check = no' in config file

If you do not want to set the permissions of your modem you "can" set
/usr/bin/pppd setuid but this may be a security risk, you have been
warned!!!

If you have comments on the package please post it here

Retrieved from
"https://wiki.archlinux.org/index.php?title=Smartlink_Modem_drivers&oldid=283725"

Category:

-   Modems

-   This page was last modified on 20 November 2013, at 00:48.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
