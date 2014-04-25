Blueman
=======

Blueman is a full featured Bluetooth manager written in GTK+.

Related articles

-   Bluez4
-   Bluetooth

Contents
--------

-   1 Installation
-   2 Usage
    -   2.1 Checking the Bluetooth hardware
    -   2.2 Autostarting
    -   2.3 Permissions
    -   2.4 Mounting Bluetooth devices without Nautilus
    -   2.5 Blueman and PulseAudio
-   3 Troubleshooting
    -   3.1 Workaround for a Bug with obex and gvfs
    -   3.2 Cannot receive files
    -   3.3 Blueman applet does not start
-   4 See also

Installation
------------

Warning:Blueman currently relies on the, now unmaintained, Bluez4 stack.
A version of Blueman that is compatible with Bluez5 is in development.
[1]

Blueman can be installed from the blueman-bzr package in the AUR.

Be sure to enable the Bluetooth daemon and start Blueman with
blueman-applet.

Tip:If you want to mount and browse remote devices, you may need to
install the gvfs-obexftp-bluez4 package from the AUR.

Usage
-----

> Checking the Bluetooth hardware

Be sure the local Bluetooth device is availabe by running hcitool dev.
If only Devices: is dumped, the local Bluetooth device is unavailable.
If this is the case, try restarting the bluetooth service or toggle the
WiFi/Bluetooth switch on your laptop (if it exists). For example: the
switch is Fn+F3 on an Acer Aspire laptop. Also try rebooting to activate
the local Bluetooth device. If you run blueman-applet without an
available local Bluetooth device, the Blueman tray icon will not appear.

> Autostarting

The following autostart file should have been created:
/etc/xdg/autostart/blueman.desktop. This means that Blueman should be
autostarted with most desktop environments without manual intervention.
See the article for your desktop environment or window manager as well
as the Autostarting article for further information on autostarting.

> Permissions

It might be necessary for the user to be added to the lp group in order
for the user to be able to add and manage Bluetooth devices using
Blueman. See /etc/dbus-1/system.d/bluetooth.conf for the section that
enables users of the lp group to communicate with the Bluetooth daemon.

To receive files remember to right click on the Blueman tray icon >
Local Services > Transfer > File Receiving" and tick the square box next
to "Enabled".

Note:If you are running Blueman in a session that is started with the
startx command, you should add source /etc/X11/xinit/xinitrc.d/* to your
~/.xinitrc to make Nautilus capable of browsing your devices.

> Mounting Bluetooth devices without Nautilus

Blueman is configured to use Nautilus for bluetooth device mounting by
default. The instructions below describe a method for using different
file managers with Blueman. The examples in this section focus on
Thunar. If you are using a different file manager, substitute thunar
with the name of the file manager you are using.

    obex_thunar.sh

    #!/bin/bash
    fusermount -u ~/bluetooth
    obexfs -b $1 ~/bluetooth
    thunar ~/bluetooth

Now you will need to move the script to an appropriate location (e.g.,
/usr/local/bin). After that, mark it as executable:

    # chmod +x /usr/local/bin/obex_thunar.sh

The last step is to change the line in Blueman tray icon > Local
Services > Transfer > Advanced to obex_thunar.sh %d.

Tip:If you do not want to create a script, you could just replace this
command: nautilus --browse obex:// with this one: thunar obex:// in
Local Services > Transfer > Advanced

> Blueman and PulseAudio

Users who want to use PulseAudio with a Bluetooth headset may want to
activate the PulseAudio plugin of Blueman. This automatically loads
PulseAudio Bluetooth module after audio device is connected and plays
all audio through the Bluetooth headset.

Troubleshooting
---------------

> Workaround for a Bug with obex and gvfs

Note:This bug only affects older versions of Blueman.

To browse a mobile phone using Nautilus and Blueman you will need a
patched version of GVFS (The GNOME Virtual File System.) Install
gvfs-rar from AUR. It is possible that you will need to rebuild the
obex-data-server package as shown below:

    $ ./configure --prefix=/usr --sysconfdir=/etc

> Cannot receive files

If you cannot receive files with Blueman, edit the /etc/conf.d/bluetooth
file and uncomment this line:

    #SDPD_ENABLE="true"

> Blueman applet does not start

If blueman-applet fails to start, try removing the entire
/var/lib/bluetooth directory and restarting the machine (or just the
dbus and bluetooth services).

    # rm -rf /var/lib/bluetooth
    $ systemctl reboot

If you see a notification saying Incoming file over Bluetooth then this
means that the device isn't marked as trusted. Mark it as trusted and
try sending the file again.

See also
--------

-   Blueman development, on Launchpad
-   Blueman development, on GitHub

Retrieved from
"https://wiki.archlinux.org/index.php?title=Blueman&oldid=306159"

Category:

-   Bluetooth

-   This page was last modified on 20 March 2014, at 19:19.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
