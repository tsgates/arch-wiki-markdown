Bluetooth mouse configuration
=============================

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Bluetooth   
                           Mouse.                   
                           Notes: please use the    
                           second argument of the   
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Determine your bluez dbus address
-   2 Test if your PC already knows your mouse
-   3 Create the bluez device for the mouse
-   4 Test again if your PC knows your mouse
-   5 Verify the permissions
-   6 Give your mouse permission to connect your PC
-   7 Make your mouse learn your PC address
-   8 Useful tips
-   9 Troubleshooting
-   10 More information
-   11 Related Articles

Determine your bluez dbus address
---------------------------------

Enter in X-window and open a terminal (dbus is usually not available
outside X). Now as a non privileged user type the following command:

    $ dbus-send --system --type=method_call --print-reply --dest=org.bluez "/" org.bluez.Manager.ListAdapters

    method return sender=:1.13 -> dest=:1.16 reply_serial=2
       array [
          object path "/org/bluez/3594/hci0"
       ]

The string "/org/bluez/3594/hci0" is the name of my adapter; yours will
be similar. In particular, 3594 is the PID of the bluetoothd process and
varies after each computer boot, making it more difficult to create
scripts targeting concrete adapters (imagine your network interface name
changing on each reboot):

    $ pidof bluetoothd
    3594

  
 To easier the setup process we save the dbus name of the adapter (do
not forget to put your own data here):

    $ export BLUEPATH="/org/bluez/3594/hci0"

Test if your PC already knows your mouse
----------------------------------------

Issue the following command (I assume you set-up the BLUEPATH variable
as explained in the previous step):

    $ dbus-send --system --type=method_call --print-reply --dest=org.bluez $BLUEPATH org.bluez.Adapter.GetProperties

At some point in the long output, you'll see a entry reporting the known
devices. In the example below there are none (empty list):

          dict entry(
             string "Devices"
             variant             array [
                ]
          )

If your mouse bluetooth address were listed it could be due to several
factors. For example, due to previous configuration tries maybe with
other tools. But it could also be due to your mouse already knowing your
PC (because you may have not followed the recomendation of making it
initially forget your PC). And that wouldn't be good news: in such case,
it will be a temporary entry created by bluez, just after the mouse
connects (and it will be rejected due to lack of permission). These
temporal entries will dissapear sooner or later removing any
configuration about to be performed. This may not be a good bluez
design, rather maybe one of the causes of the bluetooth unnecessary
complexities for the end users. Anyway, please continue with the next
step (please, do not skip it!).

Create the bluez device for the mouse
-------------------------------------

Make sure your mouse is in discovery mode and run the following command
(as always, use the dbus address of your own bluetooth adapter and, of
course, replace "00:07:61:F5:5C:3D" by the bluetooth address of your own
mouse):

    $ dbus-send --system --type=method_call --print-reply --dest=org.bluez $BLUEPATH org.bluez.Adapter.CreateDevice string:00:07:61:F5:5C:3D

    method return sender=:1.13 -> dest=:1.20 reply_serial=2
       object path "/org/bluez/3594/hci0/dev_00_07_61_F5_5C_3D"

In case of the mouse not being discoverable, it will return a "Host is
down" error. In case of a temporary device were already created, it will
reject the command because the device already exists.

Warning:Before discovering the trick of initially forcing the mouse to
"forget" the PC, I sometimes needed to retry this command several times.
Note that succeeding in this phase is the only way to be totally sure
that the existing device is not temporal (bluez should have replaced any
temporary device by a definitive after receiving a explicit createDevice
command, but it doesn't). It is also annoying that bluez requires a
device to exist and be reachable in order to simply add it to the list
of devices, which makes automated or manual configurations a pain (and
what's more: had not been necessary to turn the mouse ON, bluez would
had not become ever confused by its potential connections).

Test again if your PC knows your mouse
--------------------------------------

If we repeat this command:

    $ dbus-send --system --type=method_call --print-reply --dest=org.bluez $BLUEPATH org.bluez.Adapter.GetProperties

Now the bluetooth mouse bluez address should be listed in the known
devices array (note that bluez replaces ":" by "_"):

          dict entry(
             string "Devices"
             variant             array [
                   object path "/org/bluez/3594/hci0/dev_00_07_61_F5_5C_3D"
                ]
          )

Verify the permissions
----------------------

Issue the following command (replacing "dev_00_07_61_F5_5C_3D" by your
own device address obtained in the previous step):

    $ dbus-send --system --type=method_call --print-reply --dest=org.bluez "$BLUEPATH/dev_00_07_61_F5_5C_3D" org.bluez.Device.GetProperties

As usually, by default permissions are always denied. This is how the
"Trusted" entry will likely appear:

          dict entry(
             string "Trusted"
             variant             boolean false
          )

Give your mouse permission to connect your PC
---------------------------------------------

Issue the following command (with the proper replacement in the device
name):

    $ dbus-send --system --type=method_call --print-reply --dest=org.bluez "$BLUEPATH/dev_00_07_61_F5_5C_3D" org.bluez.Device.SetProperty string:Trusted variant:boolean:true

And repeat the previous step to make sure that the Trusted property is
now set to "true".

Make your mouse learn your PC address
-------------------------------------

Yes, now you must do the bad thing not recommended at the beginning of
this article: connect your mouse from the PC. Make sure your mouse is
discoverable with the proper button (this maybe isn't necessary, but it
is an easy way to ensure that it is receiving connections instead of
trying to make them) and issue the following command, using of course
your own mouse bluetooth address instead of mine (as user root):

    root@quark:~# hidd --connect 00:07:61:F5:5C:3D

Now the mouse should work in your X-window session. However, this is not
our goal. The entire point of this article is to automate the mouse
connection. Since your PC already knows your mouse, has authorized it
and the mouse knows the PC, now it should automatically reconnect each
time it is powered on.

Test if this is true by powering OFF and then ON again your mouse (of
course, discovery mode is no longer required). Move your mouse: after a
few seconds it should connect the PC and work. Note that this may take
as many as 10 or 15 seconds, because your computer may need some time to
detect the connection lost and accept a new connection (if the mouse is
kept enough time in OFF state, the connection after powering it ON will
be nearly immediate). The automatic mouse connection will now occur also
after rebooting the computer, either before or after the desktop login.

Useful tips
===========

In case you want to use the same bluetooth mouse with several computers,
you'll have to initially configure it for each computer (for example
following this guide steps). Later, each time you want to switch from
one computer into another, you simply need to place your mouse in
discovery mode and, from the new PC, perform the connection with the
hidd command as shown above. The mouse will be linked from now on to
that computer.

Note also that you'll need to repeat the full configuration of this
guide if your bluetooth adapter changes (eg. you use a new external BT
dongle adapter) since the devices creation and the permissions granted
are vinculated to a particular PC bluetooth adapter (not to the
computer).

As a tip for XFCE users, if you change the mouse properties
(acceleration, etc) select Save session for future logins before the
next immediate logout (otherwise, mouse settings seem not to be saved).

Troubleshooting
===============

When strictly following this guide, you should not need to debug your
mouse connections. In case you need it, you may enable the bluetooth
daemon debug. There are no startup options for this, but you may kill
the bluetoothd process and manually launch it again with the -d option.
This is a sample of the output (in /var/log/daemon.log) reporting the
typical problem: the mouse already knows the PC and connects it, the
daemon creates a temporary device for the mouse, after some time with no
authentication performed it rejects the mouse connection (what a pity!)
and removes the temporary device:

     May 13 01:11:11 quark bluetoothd[3881]: adapter_get_device(00:07:61:F5:5C:3D)
     May 13 01:11:11 quark bluetoothd[3881]: adapter_create_device(00:07:61:F5:5C:3D)
     May 13 01:11:11 quark bluetoothd[3881]: Creating device /org/bluez/3881/hci0/dev_00_07_61_F5_5C_3D
     May 13 01:11:11 quark bluetoothd[3881]: btd_device_ref(0xb9397530): ref=1
     May 13 01:11:11 quark bluetoothd[3881]: Incoming connection on PSM 17
     May 13 01:11:24 quark bluetoothd[3881]: Removing temporary device /org/bluez/3881/hci0/dev_00_07_61_F5_5C_3D
     May 13 01:11:24 quark bluetoothd[3881]: Removing device /org/bluez/3881/hci0/dev_00_07_61_F5_5C_3D
     May 13 01:11:24 quark bluetoothd[3881]: btd_device_unref(0xb9397530): ref=0
     May 13 01:11:24 quark bluetoothd[3881]: device_free(0xb9397530)

This is the output under a successfully accepted connection of a known
and trusted mouse:

     Jun  4 00:56:50 quark bluetoothd[9572]: src/adapter.c:adapter_get_device() adapter_get_device(00:07:61:F5:5C:3D)
     Jun  4 00:56:50 quark bluetoothd[9572]: input/server.c:connect_event_cb() Incoming connection on PSM 17
     Jun  4 00:56:50 quark bluetoothd[9572]: input/server.c:connect_event_cb() Incoming connection on PSM 19

The internal configuration is stored in
/var/lib/bluetooth/00:0F:3D:0B:F8:6B (being XX:XX:XX... your PC
bluetooth adapter address). Inside this directory there are files
containing the devices and their permissions. Another way to configure
the mouse would have been to momentarily stop the daemon and create here
the proper files, but that wouldn't be portable. The good old times of
plain easy configuration files in Linux are unnecessarily going away
(and the new HOWTO lengths are unnecessarily growing).

More information
================

If you download the original source package from Bluez site (for example
bluez-4.65.tar.gz) and extract the files, the subdirectory test contains
some useful python scripts. The test-device for example can be used to
create devices and change the permissions (instead of using the
dbus-send syntax).

Here is a compilation of useful samples for common bluetooth tasks (the
syntax is very tricky depending on the data type). They are very useful
for scripts, all of them are tested and some are used by this guide.
Remember that first you need to get your own device names (instead of
the ones in these samples) as explained in the sections above:

    dbus-send --system --type=method_call --print-reply --dest=org.bluez "/" org.bluez.Manager.ListAdapters
    dbus-send --system --type=method_call --print-reply --dest=org.bluez "/org/bluez/3858/hci0" org.bluez.Adapter.GetProperties
    dbus-send --system --type=method_call --print-reply --dest=org.bluez "/org/bluez/3858/hci0" org.bluez.Adapter.SetProperty string:Name variant:string:"My Name"
    dbus-send --system --type=method_call --print-reply --dest=org.bluez "/org/bluez/3858/hci0" org.bluez.Adapter.SetProperty string:Powered variant:boolean:true
    dbus-send --system --type=method_call --print-reply --dest=org.bluez "/org/bluez/3858/hci0" org.bluez.Adapter.SetProperty string:Discoverable variant:boolean:true
    dbus-send --system --type=method_call --print-reply --dest=org.bluez "/org/bluez/3858/hci0" org.bluez.Adapter.SetProperty string:DiscoverableTimeout variant:uint32:0
    dbus-send --system --type=method_call --print-reply --dest=org.bluez "/org/bluez/3858/hci0" org.bluez.Adapter.SetProperty string:Pairable variant:boolean:true
    dbus-send --system --type=method_call --print-reply --dest=org.bluez "/org/bluez/3858/hci0" org.bluez.Adapter.SetProperty string:PairableTimeout variant:uint32:0

    dbus-send --system --type=method_call --print-reply --dest=org.bluez "/org/bluez/3858/hci0" org.bluez.Adapter.CreateDevice string:00:12:EE:35:7A:21
    dbus-send --system --type=method_call --print-reply --dest=org.bluez "/org/bluez/3858/hci0/dev_00_12_EE_35_7A_21" org.bluez.Device.GetProperties
    dbus-send --system --type=method_call --print-reply --dest=org.bluez "/org/bluez/3858/hci0/dev_00_12_EE_35_7A_21" org.bluez.Device.SetProperty string:Trusted variant:boolean:true
    dbus-send --system --type=method_call --print-reply --dest=org.bluez "/org/bluez/3858/hci0" org.bluez.Adapter.RemoveDevice objpath:"/org/bluez/3858/hci0/dev_00_12_EE_35_7A_21"

Related Articles
================

Bluetooth  

Retrieved from
"https://wiki.archlinux.org/index.php?title=Bluetooth_mouse_configuration&oldid=292120"

Categories:

-   Mice
-   Bluetooth

-   This page was last modified on 9 January 2014, at 08:18.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
