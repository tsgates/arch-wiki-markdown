Toshiba Satellite R15 wacom tablet pc
=====================================

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: Out of date. All 
                           useful info already      
                           covered by Beginners'    
                           guide. (Discuss)         
  ------------------------ ------------------------ ------------------------

This document contains instructions for installing Arch Linux on a
Toshiba Satellite R15 wacom tablet pc using the stock 2.6.17-ARCH
kernel. It assumes that you have completed the installation as described
in the Installation guide.

Contents
--------

-   1 Working
-   2 Not tested
-   3 CD/FTP Installation
-   4 Wireless Network
-   5 Video
-   6 Audio
-   7 Power Management
    -   7.1 Toshiba ACPI
    -   7.2 CPU frequency scaling
    -   7.3 klaptop
-   8 Wacom/Tablet

> Working

-   Audio
-   Video
-   Wireless
-   Power management
-   Tablet/Pen
-   Touch Pad
-   DVD-R/CD-R

> Not tested

-   Extra keys in tablet mode
-   SD slot
-   PC card slot
-   Tablet rotation
-   Accelerometer

CD/FTP Installation
-------------------

Quick notes:

-   The default installation is relatively painless.
-   Wireless won't work initially. However, the wired connection will.
    Plug 'er in.
-   Use the ftp/http package source for more up to date packages.
-   If you select all the packages, you'll have a conflict or two. Just
    deselect one of the conflicted packages and try again.

  

Wireless Network
----------------

The Toshiba Satellite R15 uses the Intel Pro/Wireless network interface
(ipw2200). See Wireless network configuration#ipw2100 and ipw2200.

Video
-----

The Toshiba Satellite R15 uses the Intel 82852/855GM Integrated Graphics
Device which uses the i810 driver. See Intel Graphics.

Audio
-----

Alsa should work out of the box. The only thing you'll have to do is
unmute the channels you want to hear. To use alsamixer, enter the
following:

  

    $ alsamixer

  
 Hit the letter 'm' to unmute the channels you want to use. Use the up
and down cursor keys to raise and lower the volumes. When you're done,
hit escape. You can also use kmix to unmute and adjust the volumes.

If alsamixer doesn't exist, try adding the following packages (as root)
and do the previous stuff again:

  

    # pacman -S alsa-lib alsa-oss alsa-utils

  
 That's it. She's good to go.

Power Management
----------------

Lucky for you and me, Arch Linux is set up pretty awesomely. All we have
to do to get proper power management is to add the right modules to the
modules section of /etc/rc.conf and download a package or two. How
awesome is that? It's awesome, let me tell you.

> Toshiba ACPI

The first thing to note is that you're on a Toshiba which means we need
to load the toshiba_acpi module. As root, edit rc.conf and add
toshiba_acpi to the modules secion of /etc/rc.conf:

  

    MODULES=(toshiba_acpi eepro100 ipw2200)

  
 This'll give us control over the fan, the brightness of the LCD, etc.

> CPU frequency scaling

See the main CPU Frequency Scaling article.

> klaptop

That's it. We're done with power management. Reboot'er and check out
your new power settings. The easiest way to manage these is with the KDE
system try application called klaptop.

1.  Right click on the system tray icon, and go to configure klaptop.
2.  Click on the last tab called 'ACPI Config'.
3.  If check boxes are grayed out, click the 'Setup Helper Application'
    button.
4.  Enter your password when prompted. Close and reopen the config.
5.  Now you should be able to edit all the options in all the tabs.
6.  Now configure to your own personal taste.

Note: You might have to reboot for settings to take effect.

Bon apetite? Bueno! ;)

Wacom/Tablet
------------

See Wacom Tablet.

And that's it. You're done. Your computer is fully operation now. Well,
as operation as I need it, anyways. A bit anti-climatic, isn't it?

Farewell, my friends. :)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Toshiba_Satellite_R15_wacom_tablet_pc&oldid=302850"

Category:

-   Mobile devices

-   This page was last modified on 2 March 2014, at 08:23.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
