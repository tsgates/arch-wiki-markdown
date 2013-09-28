Bluetooth
=========

Summary

Covers the installation and use of Bluetooth on Arch Linux.

Related

Bluetooth mouse configuration

Bluetooth is a standard for the short-range wireless interconnection of
cellular phones, computers, and other electronic devices. In Linux, the
canonical implementation of the Bluetooth protocol stack is BlueZ.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Graphical front-ends                                               |
|     -   2.1 Blueman                                                      |
|         -   2.1.1 Script for Thunar                                      |
|                                                                          |
|     -   2.2 GNOME Bluetooth                                              |
|     -   2.3 BlueDevil                                                    |
|     -   2.4 Fluxbox, Openbox, other WM                                   |
|                                                                          |
| -   3 Manual configuration                                               |
|     -   3.1 Audio Streaming                                              |
|                                                                          |
| -   4 Pairing                                                            |
| -   5 Using Obex for sending and receiving files                         |
| -   6 Examples                                                           |
|     -   6.1 Siemens S55                                                  |
|     -   6.2 Logitech Mouse MX Laser / M555b                              |
|     -   6.3 Motorola V900                                                |
|     -   6.4 Motorola RAZ                                                 |
|     -   6.5 Pairing with an iPhone using bluez-simple-agent              |
|     -   6.6 Headset and Alsa Devices                                     |
|     -   6.7 Microsoft Bluetooth Mobile Keyboard 6000                     |
|                                                                          |
| -   7 Troubleshooting                                                    |
|     -   7.1 Segfaults in Bluez 4.95                                      |
|     -   7.2 passkey-agent                                                |
|     -   7.3 Blueman                                                      |
|     -   7.4 gnome-bluetooth                                              |
|     -   7.5 Bluetooth USB Dongle                                         |
|     -   7.6 Logitech Bluetooth USB Dongle                                |
|     -   7.7 hcitool scan: Device not found                               |
|     -   7.8 My computer isn't visible                                    |
|     -   7.9 Nautilus cannot browse files                                 |
|     -   7.10 Bluetooth is disabled when starting GNOME                   |
|     -   7.11 Sennheiser MM400 Headset connection problems                |
|     -   7.12 My device is paired but no sound is played from it          |
|                                                                          |
| -   8 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

To use Bluetooth, install bluez, available in the Official Repositories.
The dbus daemon(start automatically by systemd) is used to read settings
and for PIN pairing, while the bluetooth daemon is required for the
Bluetooth protocol.

Start the bluetooth service:

    # systemctl start bluetooth.service

Enable the bluetooth service at system boot up:

    # systemctl enable bluetooth.service

Graphical front-ends
--------------------

The following packages allow for a graphical interface to customize
Bluetooth.

> Blueman

Blueman is a full featured Bluetooth manager written in GTK+ and, as
such, is recommended for GNOME or Xfce. You can install Blueman with the
package blueman, available in the Official Repositories.

Be sure that bluetooth daemon is running as described above, and execute
blueman-applet. To make the applet run on login add blueman-applet
either under System -> Preferences -> Startup Applications (GNOME) or
Xfce Menu -> Settings -> Session and Startup (Xfce).

In order for a user to add and manage Bluetooth devices using Blueman,
the user must be added to the 'lp' group. See
/etc/dbus-1/system.d/bluetooth.conf for the section that enables users
of the 'lp' group to communicate with the Bluetooth daemon.

Note:If you are running Blueman outside GNOME/GDM (e.g., in Xfce using
the startx command) you should add . /etc/X11/xinit/xinitrc.d/* on top
of your ~/.xinitrc to make Nautilus capable to browse your devices.

To receive files don't forget to right click on the Blueman tray icon ->
Local Services -> Transfer -> File Receiving" and tick the square box
next to "Enabled".

Script for Thunar

If you are not using Nautilus (for example Thunar) you may find the
following script useful:

    obex_thunar.sh

     #!/bin/bash
     fusermount -u ~/bluetooth
     obexfs -b $1 ~/bluetooth
     thunar ~/bluetooth

Now you will need to move the script to an appropriate location (e.g.,
/usr/bin). After that, mark it as executable:

    chmod +x /usr/bin/obex_thunar.sh

The last step is to change the line in Blueman tray icon -> Local
Services -> Transfer -> Advanced to obex_thunar.sh %d.

> GNOME Bluetooth

GNOME Bluetooth is a fork of the old bluez-gnome and is focused on
integration with the GNOME desktop environment. GNOME Bluetooth is
required by gnome-shell, so you should already have it installed if you
are running GNOME 3. Otherwise, it can be installed with the package
gnome-bluetooth.

Run bluetooth-applet for a nice Bluetooth applet. You should now be able
to setup devices and send files by right-clicking the Bluetooth icon. To
make the applet run on login, add it to System -> Preferences -> Startup
Applications.

To add a Bluetooth entry to the SendTo menu in Thunar's file properties
menu, see instructions here.

> BlueDevil

The Bluetooth tool for KDE is BlueDevil. It can be installed with the
package bluedevil, available in the Official Repositories.

Make sure bluetooth daemon is running, as described above. You should
get a Bluetooth icon both in Dolphin and in the system tray, from which
you can configure BlueDevil and detect Bluetooth devices by clicking the
icon. You can also configure BlueDevil from the KDE System Settings

> Fluxbox, Openbox, other WM

Of course you can still use the preceding applications even if GNOME,
Xfce or KDE are not your desktop manager. This list should help you
figuring out which application does what:

-   bluetooth-applet -- tray icon with access to settings, pairing
    wizard, management of known devices
-   /usr/lib/gnome-user-share/gnome-user-share -- needs to be running if
    you're about to receive files via obexBT from a paired/bonded device

if you're receiving an error during transmission and/or there's no file
received add this into

/etc/dbus-1/system.d/bluetooth.conf

     <policy user="your_user_id">
       <allow own="org.bluez"/>
       <allow send_destination="org.bluez"/>
       <allow send_interface="org.bluez.Agent"/>
     </policy>

-   bluetooth-wizard -- for new devices to be paired
-   bluetooth-properties -- accessible also via bluetooth-applet icon
-   gnome-file-share-properties -- permissions on receiving files via
    bluetooth
-   bluez-sendto -- gui for sending files to a remote device

Manual configuration
--------------------

To configure BlueZ manually, you may need to edit the configuration
files in /etc/bluetooth. These are:

    audio.conf
    input.conf
    main.conf
    network.conf
    rfcomm.conf

The default configuration should work for most purposes. Most
configuration options are well-documented in these files, so
customization is a simple matter of reading the option descriptions. For
general options, start with main.conf.

  

> Audio Streaming

You can use bluez-tools from the AUR with pulseaudio to stream audio to
a bluetooth headset. Find the MAC of the headset:

    $ hcitool scan

Connect to the headset:

    $ bt-audio -c XX:XX:XX:XX:XX:XX

Open pulseaudio volume control:

    $ pavucontrol

The headset should show up in the Configuration tab.

Pairing
-------

Many bluetooth devices require pairing. The exact procedure depends on
the devices involved and their input functionality.

The procedure on a mobile may be as follows:

-   The computer sends a connect request to the mobile.
-   A pin, determined by the computer, is prompted for at the mobile
-   The same key must be re-entered at the computer.

To pair with a device without using the gnome-bluez package, the
bluez-simple-agent utility that comes with the bluez package can be
used. This utility depends on three packages from [extra]:

    # pacman -S python2-dbus python2-gobject dbus-glib

First, scan for external devices:

    $ hcitool scan

Run the script as root:

    # bluez-simple-agent

The message "Agent registered" should be returned, press control-c to
quit.

Below is a basic example of pairing with a specific device. The script
will ask for the passcode, enter the code and confirm with enter.

    # bluez-simple-agent hci0 00:11:22:33:AA:BB

Note:bluez-simple-agent is only needed once for pairing a device, not
every time you want to connect.

See the Examples section below for pairing examples with various
devices.

Using Obex for sending and receiving files
------------------------------------------

Another option, rather than using KDE or Gnome Bluetooth packages, is
Obexfs which allows you to mount your phone and treat it as part of your
filesystem. Note that to use Obexfs, you need a device that provides an
Obex FTP service.

To install;

    # pacman -S obexfs

and then your phone can then be mounted running as root

    # obexfs -b <devices mac address> /mountpoint

For more mounting options see
http://dev.zuckschwerdt.org/openobex/wiki/ObexFs

For devices don't support Obex FTP service, check if Obex Object Push is
supported.

    # sdptool browse XX:XX:XX:XX:XX:XX

Read the output, look for Obex Object Push, remember the channel for
this service. If supported, you can use ussp-push to send files to this
device:

    # ussp-push XX:XX:XX:XX:XX:XX@CHANNEL file wanted_file_name_on_phone

Examples
--------

> Siemens S55

This is what I did to connect to my S55. (I have not figured out how to
initiate the connection from the phone)

-   The steps under installation
-   

      $> hcitool scan
      Scanning ...
              XX:XX:XX:XX:XX:XX  NAME
      $> B=XX:XX:XX:XX:XX:XX

Start the simple-agent in a second terminal

      $> su -c bluez-simple-agent 
      Password: 
      Agent registered

Back to the first console

      $> obexftp -b $B -l "Address book"
      # Phone ask for pin, I enter it and answer yes when asked if I want to save the device
      ...
      <file name="5F07.adr" size="78712" modified="20030101T001858" user-perm="WD" group-perm="" />
      ...
      $> obexftp -b 00:01:E3:6B:FF:D7 -g "Address book/5F07.adr"
      Browsing 00:01:E3:6B:FF:D7 ...
      Channel: 5
      Connecting...done
      Receiving "Address book/5F07.adr"... Sending "Address book"... done
      Disconnecting...done
      $> obexftp -b 00:01:E3:6B:FF:D7 -p a                      
      ...
      Sending "a"... done
      Disconnecting...done

> Logitech Mouse MX Laser / M555b

To quickly test the connection:

    $> hidd --connect XX:XX:XX:XX:XX:XX

For automated reconnection, use your desktop wizard to configure the
bluetooth mouse. If your desktop environment doesn't includes support
for this task, see the Bluetooth mouse manual configuration guide.

> Motorola V900

After installing blueman and running blueman-applet, click "find me"
under connections -> bluetooth in motorla device. In blueman-applet,
scan devices, find the motorola, click "add" in blueman-applet. Click
"bond" in blueman-applet, enter some pin, enter the same pin in motorola
when it asks. In terminal:

      cd ~/
      mkdir bluetooth-temp
      obexfs -n xx:yy:zz:... ~/bluetooth-temp
      cd ~/bluetooth-temp

and browse... Only audio, video, and pictures are available when you do
this.

> Motorola RAZ

    > pacman -S obextool obexfs obexftp openobex bluez

    > lsusb
    Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 002 Device 002: ID 03f0:171d Hewlett-Packard Wireless (Bluetooth + WLAN) Interface [Integrated Module]
    Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

    > hciconfig hci0 up

    > hciconfig
    hci0:   Type: BR/EDR  Bus: USB
            BD Address: 00:16:41:97:BA:5E  ACL MTU: 1017:8  SCO MTU: 64:8
            UP RUNNING
            RX bytes:348 acl:0 sco:0 events:11 errors:0
            TX bytes:38 acl:0 sco:0 commands:11 errors:0

    > hcitool dev
    Devices:
            hci0    00:16:41:97:BA:5E

Attention: make sure that bluetooth on your phone is enabled and your
phone is visible!

    > hcitool scan
    Scanning ...
            00:1A:1B:82:9B:6D       [quirxi]

    > hcitool inq
    Inquiring ...
            00:1A:1B:82:9B:6D       clock offset: 0x1ee4    class: 0x522204

    > l2ping 00:1A:1B:82:9B:6D
    Ping: 00:1A:1B:82:9B:6D from 00:16:41:97:BA:5E (data size 44) ...
    44 bytes from 00:1A:1B:82:9B:6D id 0 time 23.94ms
    44 bytes from 00:1A:1B:82:9B:6D id 1 time 18.85ms
    44 bytes from 00:1A:1B:82:9B:6D id 2 time 30.88ms
    44 bytes from 00:1A:1B:82:9B:6D id 3 time 18.88ms
    44 bytes from 00:1A:1B:82:9B:6D id 4 time 17.88ms
    44 bytes from 00:1A:1B:82:9B:6D id 5 time 17.88ms
    6 sent, 6 received, 0% loss

    > hcitool name  00:1A:1B:82:9B:6D
    [quirxi]

    # hciconfig -a hci0
    hci0:   Type: BR/EDR  Bus: USB
            BD Address: 00:16:41:97:BA:5E  ACL MTU: 1017:8  SCO MTU: 64:8
            UP RUNNING
            RX bytes:9740 acl:122 sco:0 events:170 errors:0
            TX bytes:2920 acl:125 sco:0 commands:53 errors:0
            Features: 0xff 0xff 0x8d 0xfe 0x9b 0xf9 0x00 0x80
            Packet type: DM1 DM3 DM5 DH1 DH3 DH5 HV1 HV2 HV3
            Link policy:
            Link mode: SLAVE ACCEPT
            Name: 'BCM2045'
            Class: 0x000000
            Service Classes: Unspecified
            Device Class: Miscellaneous,
            HCI Version: 2.0 (0x3)  Revision: 0x204a
            LMP Version: 2.0 (0x3)  Subversion: 0x4176
            Manufacturer: Broadcoml / Corporation (15)

    > hcitool info 00:1A:1B:82:9B:6D
    Requesting information ...
            BD Address:  00:1A:1B:82:9B:6D
            Device Name: [quirxi]
            LMP Version: 1.2 (0x2) LMP Subversion: 0x309
            Manufacturer: Broadcom Corporation (15)
            Features: 0xff 0xfe 0x0d 0x00 0x08 0x08 0x00 0x00
                    <3-slot packets> <5-slot packets> <encryption> <slot offset>
                    <timing accuracy> <role switch> <hold mode> <sniff mode>
                    <RSSI> <channel quality> <SCO link> <HV2 packets>
                    <HV3 packets> <A-law log> <CVSD> <power control>
                    <transparent SCO> <AFH cap. slave> <AFH cap. master>

Edit your main.conf and enter the proper class for your phone ( Class =
0x100100 ):

    > vim /etc/bluetooth/main.conf

      # Default device class. Only the major and minor device class bits are
      # considered.
      #Class = 0x000100
      Class =  0x100100

    > /etc/rc.d/dbus start
    :: Starting D-BUS system messagebus 
    [DONE]

    > /etc/rc.d/bluetooth start
    :: Stopping bluetooth subsystem:  pand dund rfcomm hidd  bluetoothd
    [DONE]
    :: Starting bluetooth subsystem:  bluetoothd

Pairing with bluez-simple-agent only has to be done once. On your
motorola-phone give 0000 in as your pin when phone asks for it !!

    > /usr/bin/bluez-simple-agent hci0 00:1A:1B:82:9B:6D
    RequestPinCode (/org/bluez/10768/hci0/dev_00_1A_1B_82_9B_6D)
    Enter PIN Code: 0000
    Release
    New device (/org/bluez/10768/hci0/dev_00_1A_1B_82_9B_6D)

Now you can browse the filesystem of your phone with obexftp:

    > obexftp -v -b 00:1A:1B:82:9B:6D -B 9 -l
    Connecting..\done
    Tried to connect for 448ms
    Receiving "(null)"...-<?xml version="1.0" ?>
    <!DOCTYPE folder-listing SYSTEM "obex-folder-listing.dtd">
    <folder-listing>
    <parent-folder />
    <folder name="audio" size="0" type="folder" modified="20101010T132323Z" user-perm="RW" />
    <folder name="video" size="0" type="folder" modified="20101010T132323Z" user-perm="RW" />
    <folder name="picture" size="0" type="folder" modified="20101010T132323Z" user-perm="RW" />
    </folder-listing>
    done
    Disconnecting..\done

Or you can mount your phone into a directory on your computer and treat
it like a normal file system:

    > groupadd bluetooth
    > mkdir /mnt/bluetooth
    > chown root:bluetooth /mnt/bluetooth
    > chmod 775 /mnt/bluetooth
    > usermod -a -G bluetooth arno

    > obexfs -b 00:1A:1B:82:9B:6D /mnt/bluetooth/
    > l /mnt/bluetooth/
    total 6
    drwxr-xr-x 1 root root    0 10. Okt 13:25 .
    drwxr-xr-x 5 root root 4096 10. Okt 10:08 ..
    drwxr-xr-x 1 root root    0 10. Okt 2010  audio
    drwxr-xr-x 1 root root    0 10. Okt 2010  picture
    drwxr-xr-x 1 root root    0 10. Okt 2010  video

> Pairing with an iPhone using bluez-simple-agent

Assuming a bluetooth device called hci0 and an iPhone that showed up in
a hcitool scan as '00:00:DE:AD:BE:EF':

       # bluez-simple-agent hci0 00:00:DE:AD:BE:EF
       Passcode:

> Headset and Alsa Devices

1. First if you have not already, install bluez

    # pacman -S bluez

2. Scan for your device

    $ hcitool (-i <optional hci#>***) scan

3. Pair your headset with your device

    $ bluez-simple-agent (optional hci# ***) XX:XX:XX:XX:XX:XX
      and put in your pin (0000 or 1234, etc)

4. Add this to your/etc/asound.conf file

    #/etc/asound.conf

    pcm.btheadset {
       type plug
       slave {
           pcm {
               type bluetooth
               device XX:XX:XX:XX:XX:XX 
               profile "auto"
           }   
       }   
       hint {
           show on
           description "BT Headset"
       }   
    }
    ctl.btheadset {
      type bluetooth
    }  

5. Check to see if it has been added to alsa devices

    $ aplay -L

6. Now play with aplay:

    $ aplay -D btheadset /path/to/audio/file
      

or Mplayer:

    $ mplayer -ao alsa:device=btheadset /path/to/audio/or/video/file

-   -   -   To find hci# for a usb dongle, type in

    $ hcitool dev

> Microsoft Bluetooth Mobile Keyboard 6000

1. Scan for your device

    $ hcitool (-i <optional hci#>***) scan
    Scanning ...
           00:11:22:33:44:55       Microsoft Bluetooth Mobile Keyboard 6000

  
 2. On second console run as root (do not terminate):

    # bluez-simple-agent
    Agent registered

3. Back on first console run:

    $ bluez-simple-agent hci0 00:11:22:33:44:55
    Enter PIN Code: 1234
    (now enter that pin on the keyboard and press enter)
    Release
    New device (/org/bluez/5373/hci0/dev_00_11_22_33_44_55)

4.

    $ bluez-test-device trusted 00:11:22:33:44:55

5.

    $ bluez-test-input connect 00:11:22:33:44:55

No your keyboard should work. You can terminate bluez-simple-agent on
second console with Ctrl-C

Troubleshooting
---------------

> Segfaults in Bluez 4.95

If bluetoothd stops working after enabling or disabling your bluetooth
device via rfkill or gnome-bluetooth applet, look at your dmesg output.
If it looks like:

    bluetoothd[2330]: segfault at 1 ip 00007fcef2327b75 sp 00007fff9f769cb0 error 4 in libglib-2.0.so.0.2800.8[7fcef22ca000+e9000]

then you should consider downgrading to 4.94 (just grab the PKGBUILD/etc
from arch and change version to 4.94 and correct the md5sum for bluez)
or wait for an update of bluez. Here is a (arch) bug report about it.

> passkey-agent

    $> passkey-agent --default 1234
    Can't register passkey agent
    The name org.bluez was not provided by any .service files

You probably started /etc/rc.d/bluetooth before /etc/rc.d/dbus

    $> hciconfig dev
    # (no listing)

Try running hciconfig hc0 up

> Blueman

If blueman-applet fails to start, try removing the entire
/var/lib/bluetooth directory and restarting the machine (or just the
hal, dbus, and bluetooth services).

    # rm -rf /var/lib/bluetooth
    # reboot

> gnome-bluetooth

If you see this when trying to enable receiving files in
bluetooth-properties:

     Bluetooth OBEX start failed: Invalid path
     Bluetooth FTP start failed: Invalid path

Then run:

     # pacman -S xdg-user-dirs
     $ xdg-user-dirs-update

You can edit the paths using:

     $ vi ~/.config/user-dirs.dirs

> Bluetooth USB Dongle

If you are using a USB dongle, you should check that your Bluetooth
dongle is recognized. You can do that by inspecting
/var/log/messages.log when plugging in the USB dongle (or running
journalctl -f with systemd). It should look something like the following
(look out for hci):

    # tail -f /var/log/messages.log
     Feb 20 15:00:24 hostname kernel: [ 2661.349823] usb 4-1: new full-speed USB device number 3 using uhci_hcd
     Feb 20 15:00:24 hostname bluetoothd[4568]: HCI dev 0 registered
     Feb 20 15:00:24 hostname bluetoothd[4568]: Listening for HCI events on hci0
     Feb 20 15:00:25 hostname bluetoothd[4568]: HCI dev 0 up
     Feb 20 15:00:25 hostname bluetoothd[4568]: Adapter /org/bluez/4568/hci0 has been enabled

For a list of supported hardware please refer to the resources section
on this page.

If you only get the first two lines, you may see that it found the
device but you need to bring it up. Example:

    hciconfig -a hci0
    hci0:	Type: USB
    	BD Address: 00:00:00:00:00:00 ACL MTU: 0:0 SCO MTU: 0:0
    	DOWN 
    	RX bytes:0 acl:0 sco:0 events:0 errors:0
    	TX bytes:0 acl:0 sco:0 commands:0 errors:
    sudo hciconfig hci0 up
    hciconfig -a hci0
    hci0:	Type: USB
    	BD Address: 00:02:72:C4:7C:06 ACL MTU: 377:10 SCO MTU: 64:8
    	UP RUNNING 
    	RX bytes:348 acl:0 sco:0 events:11 errors:0
    	TX bytes:38 acl:0 sco:0 commands:11 errors:0

If this fails with an error like:

    Operation not possible due to RF-kill

it could be due either to the rfkill utility, in which case it should be
resolved with

    # rfkill unblock all

or, it could simply be the hardware switch of the computer. The hardware
bluetooth switch (at least sometimes) controls access to USB bluetooth
dongles also. Flip/press this switch and try bringing the device up
again.

To verify that the device was detected you can use hcitool which is part
of the bluez-utils. You can get a list of available devices and their
identifiers and their MAC address by issuing:

    $ hcitool dev
    Devices:
            hci0	00:1B:DC:0F:DB:40

More detailed informations about the device can be retrieved by using
hciconfig.

    $ hciconfig -a hci0
    hci0:   Type: USB
            BD Address: 00:1B:DC:0F:DB:40 ACL MTU: 310:10 SCO MTU: 64:8
            UP RUNNING PSCAN ISCAN 
            RX bytes:1226 acl:0 sco:0 events:27 errors:0
            TX bytes:351 acl:0 sco:0 commands:26 errors:0
            Features: 0xff 0xff 0x8f 0xfe 0x9b 0xf9 0x00 0x80
            Packet type: DM1 DM3 DM5 DH1 DH3 DH5 HV1 HV2 HV3 
            Link policy: RSWITCH HOLD SNIFF PARK 
            Link mode: SLAVE ACCEPT 
            Name: 'BlueZ (0)'
            Class: 0x000100
            Service Classes: Unspecified
            Device Class: Computer, Uncategorized
            HCI Ver: 2.0 (0x3) HCI Rev: 0xc5c LMP Ver: 2.0 (0x3) LMP Subver: 0xc5c
            Manufacturer: Cambridge Silicon Radio (10)

> Logitech Bluetooth USB Dongle

There are Logitech dongles (ex. Logitech MX5000) that can work in two
modes Embedded and HCI. In embedded mode dongle emulates a USB device so
it seems to your PC that your using a normal USB mouse/keyoard.

If you hold the little red Button on the USB BT mini-receiver it will
enable the other mode. Hold the red button on the BT dongle and plug it
into the computer, and after 3-5 seconds of holding the button, the
Bluetooth icon will appear in the system tray. Discussion

> hcitool scan: Device not found

-   On some Dell laptops (e.g. Studio 15) you have to switch the
    Bluetooth mode from HID to HCI using

    # hid2hci

Note:hid2hci is no longer in the $PATH, it is under /lib/udev/hid2hci,
but udev should run it automatically for you.

-   If the device won't show up and you have a Windows operating system
    on your machine, try booting it and enable the bluetooth adapter
    from windows.

-   Sometimes also this simple command helps:

    # hciconfig hci0 up

> My computer isn't visible

Can't discover computer from your phone? Enable PSCAN and ISCAN:

    # enable PSCAN and ISCAN
    $ hciconfig hci0 piscan 
    # check it worked
    $ hciconfig 
    hci0:   Type: USB
            BD Address: 00:12:34:56:78:9A ACL MTU: 192:8 SCO MTU: 64:8
            UP RUNNING PSCAN ISCAN
            RX bytes:20425 acl:115 sco:0 events:526 errors:0
            TX bytes:5543 acl:84 sco:0 commands:340 errors:0

Note: Check DiscoverableTimeout and PairableTimeout in
/etc/bluetooth/main.conf

Try changing device class in /etc/bluetooth/main.conf as following

    # Default device class. Only the major and minor device class bits are
    # considered.
    #Class = 0x000100 (from default config)
    Class = 0x100100

This was the only solution to make my computer visible for my phone.

> Nautilus cannot browse files

If nautilus doesn't open and show this error:

    Nautilus cannot handle obex: locations. Couldn't display "obex://[XX:XX:XX:XX:XX:XX]/".

Install gvfs-obexftp package:

    # pacman -S gvfs-obexftp

> Bluetooth is disabled when starting GNOME

If you have dbus and bluetooth backgrounded (@) in your DAEMONS array in
/etc/rc.conf, it might happen that bluetooth will be disabled when
starting up GNOME. To solve this, make sure dbus is not backgrounded.

> Sennheiser MM400 Headset connection problems

If your Sennheiser MM400 Headset immediately disconnects after
connecting as Headset Service with Blueman, try to connect it as
Audio Sink. Afterwards you can change the headset's Audio Profile to
Telephony Duplex with a right click in Blueman. With this option headset
functionality will be available although the headset was only connected
as Audio Sink in first place and no disconnection will happen (tested
with bluez 4.96-3, pulseaudio 1.1-1 and blueman 1.23-2).

> My device is paired but no sound is played from it

Try to first inspect /var/log/messages.log

    # tail /var/log/messages.log
    Jan 12 20:08:58 localhost pulseaudio[1584]: [pulseaudio] module-bluetooth-device.c: Service not connected
    Jan 12 20:08:58 localhost pulseaudio[1584]: [pulseaudio] module-bluetooth-device.c: Bluetooth audio service not available

If you see such messages, try first:

    # pactl load-module module-bluetooth-device

If the module fails to work, do this workaround: Open
/etc/bluetooth/audio.conf and add after [General] (on a new line)

    Enable=Socket

Then restart the bluetooth daemon with /etc/rc.d/bluetooth restart. Pair
again your device, and you should find it in the pulseaudio settings
(advanced settings for the sound)

More information on Gentoo Wiki

If after fixing this you still can't get sound, try using blueman (this
is the only one that works for me), make sure that notify-osd is
installed or it might show you weird error messages like this one:
"Stream setup failed"

fail
(/usr/lib/python2.7/site-packages/blueman/gui/manager/ManagerDeviceMenu.py:134)
fail (DBusException(dbus.String(u'Stream setup failed'),),)

See also
--------

-   Gentoo Linux Bluetooth Guide
-   openSUSE Bluetooth Hardware Compatibility List
-   Accessing a Bluetooth phone (Linux Gazette)
-   Bluetooth computer visibility

Retrieved from
"https://wiki.archlinux.org/index.php?title=Bluetooth&oldid=252488"

Category:

-   Bluetooth
