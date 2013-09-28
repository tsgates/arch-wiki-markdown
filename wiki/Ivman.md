Ivman
=====

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: Depend on HAL,   
                           and last release time is 
                           2007.2.5. (Discuss)      
  ------------------------ ------------------------ ------------------------

This document describes how to install and properly configure ivman.
Ivman is a shell program for managing devices through HAL / dbus. Ivman
can prove extremely useful if you're using window manager or desktop
environment without automounting.

This document was generated through personal experience and a poor
translation of the Russian article on ivman.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
| -   3 Launching                                                          |
|     -   3.1 Daemon                                                       |
|     -   3.2 Userspace                                                    |
|                                                                          |
| -   4 Tips and tricks                                                    |
| -   5 Troubleshooting                                                    |
| -   6 Resources                                                          |
+--------------------------------------------------------------------------+

Installation
------------

Ivman requires the following:

-   udev
-   hal
-   dbus
-   pmount

To install all of these, Issue the following:

    # pacman -S udev hal dbus pmount

You'll then need the ivman package from the AUR: here

Note: The patched version is required due to ivman not being maintained
upstream and breaking with newer versions of HAL / dbus.

Configuration
-------------

To start, you should add hal to your rc.conf if you haven't already done
so. Change the file /etc/rc.conf and add hal to the daemons array. This
must be done as root.

    DAEMONS = (syslog-ng hal network ...)

By default, Ivman mounts all drives under /media. It dynamically creates
and deletes the required directories, so doing so yourself is
unnecessary. Because ivman uses pmount by default, flash drives are
called 'usbdisk', 'usbdisk1' etc. Cdroms are noted by their disc label.

If a device has a corresponding fstab entry, ivman will follow the
guidelines set forth in that line. If no entry is present,ivman will use
the command 'pmount' to mount the drive, which will use a default set of
options to mount the device under /media.Thus, if you want some set of
options that are different than the default, you should create an fstab
entry and allow ivman to handle the device that way.

Launching
---------

> Daemon

Ivman can be run as a daemon by adding 'ivman' to the DAEMONS array in
/etc/rc.conf:

    DAEMONS = (syslog-ng hal ivman network ...)

However, on some systems this has been reported to fail an indefinite
time after bootup. (This section is nearly undecipherable in the
translated version of the Russian article.) If you run the daemon at
start up, Ivman will mount all devices with read/write access to the
storage groups and read rights to everyone else.

> Userspace

If launched by a user, Ivman will mountthe device read/write for that
user and no rights for any other user.

To launch Ivman manually, just issue the command:

    # ivman

An efficient way to use the manual start is to add ivman to X's startup
scripts:

    ivman &
    numlockx &
    exec openbox-session

(You could also add ivman to your session files for window managers that
offer them such as openbox and pekwm)

You can safely use both the daemon and the userspace program at the same
time. If no copy of the userspace program is running, the daemon will
take over for that user. If the userspace program is running, it will
take over and do all of the work with the daemon idles.

Tips and tricks
---------------

The above mentioned steps are more than enough to get your devices
mounted, but ivman doesn't necessarily have to stop there. A
particularly interesting trick is to give the user a notification when a
device is plugged in, giving them visual feedback that the device was
indeed recognized and an indication of where it would be mounted. You
can do this through ivman's config files, which are located in ~/.ivman,
particularly IvmConfigActions.xml. To do this, add this rule to
IvmConfigActions.xml:

    <ivm:Match name="hal.info.category" value="storage"> <ivm:Match name="hal.info.category" value="storage"> 
         <ivm:Match name="hal.storage.bus" value="usb"> <ivm:Match name="hal.storage.bus" value="usb"> 
              <ivm:Option name="exec" value="kdialog -passivepopup 'обнаружен USB-накопитель $hal.info.vendor$ $hal.info.product$ с меткой $hal.partition.label$' 4" />    
              <ivm:Option name="exec" value="kdialog -passivepopup'obnaruzhen USB-nakopitel $hal.info.vendor$ $hal.info.product$ labeled $hal.partition.label$' 4" />     	
         </ivm:Match> </ ivm: Match> 
    </ivm:Match> </ ivm: Match>

The above rule matches all USB devices and shows a kdialog box
acknowledging that they are recognized. A more generic tool to use is
notify-send, which is a CLI tool for libnotify. Sending a notification
through this will cause all listening notification systems to activate.

Troubleshooting
---------------

I've had no issues with ivman once it was properly patched and set up,
but if you are having problems try running ivman in debug mode with:

    # ivman -d

or running

    # hal-devices

to ensure that the devices have been detected.

Resources
---------

The package halevt (in AUR) may also be of interest to those interested
in ivman.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ivman&oldid=206216"

Category:

-   File systems
