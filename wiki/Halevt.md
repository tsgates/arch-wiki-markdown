Halevt
======

This document describes a method to configure halevt and traydevice in
order to mount removable media.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
| -   3 Tips and Tricks                                                    |
| -   4 Alternatives                                                       |
+--------------------------------------------------------------------------+

Installation
------------

First you need to install halevt and traydevice from AUR.

Configuration
-------------

After that you need to install a halevt config in ~/.halevt/:

    $ cp /usr/share/halevt/examples/umount_from_tray-gtkdialog.xml ~/.halevt/traydevice.xml
    $ vim ~/.halevt/traydevice.xml

Edit the relevant part into

    <halevt:Device match="&MOUNTABLE;">
     <halevt:Insertion exec="traydevice $hal.udi$"/>
     <halevt:OnInit exec="traydevice $hal.udi$"/>
    </halevt:Device>

Or if you want it to automatically mount when plugging in then edit into

    <halevt:Device match="&MOUNTABLE;">
     <halevt:Insertion exec="halevt-mount -u $hal.udi$ &amp; traydevice $hal.udi$"/>
     <halevt:OnInit exec="halevt-mount -u $hal.udi$ &amp; traydevice $hal.udi$"/>
    </halevt:Device>

Next you need to edit the default.xml file of traydevice and change it
to use halevt-mount instead of pmount-hal.

    $ cp /usr/share/traydevice/default.xml ~/.config/traydevice/
    $ vim ~/.config/traydevice/default.xml

Edit the relevant part into

    <menuitem icon="gtk.STOCK_ADD" text="mount">
     <!- - execute command pmount-hal, passing it hal udi of managed device -->
     <command executable="halevt-mount">
      <arg>-u</arg>
      <ref>info.udi</ref>

and

    <!- - execute command pumount, passing it device node from hal property -->
    <menuitem icon="gtk.STOCK_REMOVE" text="umount">
     <command executable="halevt-umount">
      <arg>-u</arg>
      <ref>info.udi</ref>

Finally you need to make halevt start when you login to X. Just add
halevt to ~/.config/openbox/autostart if you are using Openbox, or
~/.config/awesome/rc.lua for Awesome.

Tips and Tricks
---------------

It is better to start halevt individually per user rather than as a
system daemon since it might conflict with other volume manager.

Alternatives
------------

Instead of halevt you can use another program based on UDisks -
UDisksEvt. With the most recent version of Traydevice you can setup a
complete hal-less (hal is deprecated after all) automounting system.
UDisksEvt example configuration file already contains appropriate setup
for Traydevice, so it should work out-of-the-box.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Halevt&oldid=238399"

Category:

-   Hardware detection and troubleshooting
