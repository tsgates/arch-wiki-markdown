Bluez4
======

Related articles

-   Bluetooth
-   Bluetooth Mouse
-   Bluetooth mouse configuration
-   Bluetooth Headset
-   Blueman

Bluez4 is an older version of the Linux bluetooth stack. Information on
the current version of the bluetooth stack, Bluez5, can be found in the
Bluetooth article.

Contents
--------

-   1 Installation
-   2 Pairing with bluez4
-   3 Bluez4 examples
    -   3.1 Siemens S55
    -   3.2 Motorola V900
    -   3.3 Motorola RAZ
    -   3.4 Pairing with an iPhone using bluez-simple-agent
    -   3.5 Logitech mouse MX Laser / M555b
    -   3.6 Headset and ALSA devices
        -   3.6.1 Referencing the bluetooth device in asound.conf
        -   3.6.2 Using bluez-tools from the AUR
    -   3.7 Microsoft Bluetooth Mobile Keyboard 6000
-   4 Bluez4 - Troubleshooting
    -   4.1 passkey-agent
    -   4.2 Sennheiser MM400 headset connection problems
    -   4.3 My device is paired but no sound is played from it
-   5 See also

Installation
------------

Warning:Bluez4 is unmaintained. It has been superseded by Bluez5. Where
possible, it is recommended that you use Bluez5 instead.

Bluez4 can be installed from the bluez4 package in the AUR. Ensure that
the bluetooth daemon is started:

    # systemctl start bluetooth

To enable the daemon at boot use the command:

    # systemctl enable bluetooth

Pairing with bluez4
-------------------

The procedure on a mobile may be as follows:

-   The computer sends a connect request to the mobile.
-   A PIN, determined by the computer, is prompted for at the mobile
-   The same key must be re-entered at the computer.

To pair with a device without using the gnome-bluez package, the
bluez-simple-agent utility that comes with the bluez package can be
used. This utility depends on three packages from the official
repositories: python2-dbus python2-gobject dbus-glib.

First, scan for external devices:

    $ hcitool scan

Run the script as root:

    # bluez-simple-agent

The message "Agent registered" should be returned, press Ctrl+c to quit.

Below is a basic example of pairing with a specific device. The script
will ask for the passcode, enter the code and confirm with enter.

    # bluez-simple-agent hci0 00:11:22:33:AA:BB

Note:bluez-simple-agent is only needed once for pairing a device, not
every time you want to connect.

See the Examples section below for pairing examples with various
devices.

Bluez4 examples
---------------

> Siemens S55

Note:It has not yet been determined whether the connection can be
initiated from the phone.

-   The steps under installation

    $ hcitool scan

    Scanning ...
            XX:XX:XX:XX:XX:XX  NAME

    $ B=XX:XX:XX:XX:XX:XX

Start the simple-agent in a second terminal:

    $ su -c bluez-simple-agent

    Password: 
    Agent registered

Back to the first console:

    $ obexftp -b $B -l "Address book"

    # Phone ask for pin, I enter it and answer yes when asked if I want to save the device
    ...
    <file name="5F07.adr" size="78712" modified="20030101T001858" user-perm="WD" group-perm="" />
    ...

    $ obexftp -b 00:01:E3:6B:FF:D7 -g "Address book/5F07.adr"

    Browsing 00:01:E3:6B:FF:D7 ...
    Channel: 5
    Connecting...done
    Receiving "Address book/5F07.adr"... Sending "Address book"... done
    Disconnecting...done

    $ obexftp -b 00:01:E3:6B:FF:D7 -p a

    ...
    Sending "a"... done
    Disconnecting...done

> Motorola V900

After installing Blueman and running blueman-applet, click "find me"
under connections > bluetooth in Motorola device. In blueman-applet,
scan devices, find the Motorola, click "add". Click "bond" in
blueman-applet, enter some PIN, enter the same PIN in Motorola when it
asks. In terminal:

    $ mkdir ~/bluetooth-temp
    $ obexfs -n XX:XX:XX:XX:XX:XX ~/bluetooth-temp
    $ cd ~/bluetooth-temp

and browse... Only audio, video, and pictures are available when you do
this.

> Motorola RAZ

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with Bluetooth.  
                           Notes: I see that the    
                           example recommends bluez 
                           version 5. Is this       
                           example relevant to      
                           Bluez4 or Bluez5? If the 
                           example works with       
                           Bluez5 then it should be 
                           removed from this        
                           article and moved to the 
                           examples section of the  
                           Bluetooth article. This  
                           article should only      
                           contain content that is  
                           relevant only to Bluez4. 
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Install obextool obexfs obexftp openobex bluez.

    # lsusb

    Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 002 Device 002: ID 03f0:171d Hewlett-Packard Wireless (Bluetooth + WLAN) Interface [Integrated Module]
    Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

    # hciconfig hci0 up

    # hciconfig

    hci0:   Type: BR/EDR  Bus: USB
            BD Address: 00:16:41:97:BA:5E  ACL MTU: 1017:8  SCO MTU: 64:8
            UP RUNNING
            RX bytes:348 acl:0 sco:0 events:11 errors:0
            TX bytes:38 acl:0 sco:0 commands:11 errors:0

    # hcitool dev

    Devices:
            hci0    00:16:41:97:BA:5E

Make sure that bluetooth on your phone is enabled and your phone is
visible!

    # hcitool scan

    Scanning ...
            00:1A:1B:82:9B:6D       [quirxi]

    # hcitool inq

    Inquiring ...
            00:1A:1B:82:9B:6D       clock offset: 0x1ee4    class: 0x522204

    # l2ping 00:1A:1B:82:9B:6D

    Ping: 00:1A:1B:82:9B:6D from 00:16:41:97:BA:5E (data size 44) ...
    44 bytes from 00:1A:1B:82:9B:6D id 0 time 23.94ms
    44 bytes from 00:1A:1B:82:9B:6D id 1 time 18.85ms
    44 bytes from 00:1A:1B:82:9B:6D id 2 time 30.88ms
    44 bytes from 00:1A:1B:82:9B:6D id 3 time 18.88ms
    44 bytes from 00:1A:1B:82:9B:6D id 4 time 17.88ms
    44 bytes from 00:1A:1B:82:9B:6D id 5 time 17.88ms
    6 sent, 6 received, 0% loss

    # hcitool name 00:1A:1B:82:9B:6D

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

    # hcitool info 00:1A:1B:82:9B:6D

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

Edit your /etc/bluetooth/main.conf and enter the proper class for your
phone ( Class = 0x100100 ):

    # Default device class. Only the major and minor device class bits are
    # considered.
    #Class = 0x000100
    Class =  0x100100

    # systemctl start bluetooth

    :: Stopping bluetooth subsystem:  pand dund rfcomm hidd  bluetoothd
    [DONE]
    :: Starting bluetooth subsystem:  bluetoothd

Pairing with bluez-simple-agent only has to be done once. On your
Motorola phone give 0000 in as your PIN when phone asks for it!

    /usr/bin/bluez-simple-agent hci0 00:1A:1B:82:9B:6D

    RequestPinCode (/org/bluez/10768/hci0/dev_00_1A_1B_82_9B_6D)
    Enter PIN Code: 0000
    Release
    New device (/org/bluez/10768/hci0/dev_00_1A_1B_82_9B_6D)

Now you can browse the filesystem of your phone with obexftp:

    obexftp -v -b 00:1A:1B:82:9B:6D -B 9 -l

    Connecting..\done
    Tried to connect for 448ms
    Receiving "(null)"...-<?xml version="1.0" ?>
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

    # groupadd bluetooth
    # mkdir /mnt/bluetooth
    # chown root:bluetooth /mnt/bluetooth
    # chmod 775 /mnt/bluetooth
    # usermod -a -G bluetooth arno
    # obexfs -b 00:1A:1B:82:9B:6D /mnt/bluetooth/

> Pairing with an iPhone using bluez-simple-agent

Assuming a bluetooth device called hci0 and an iPhone that showed up in
a hcitool scan as '00:00:DE:AD:BE:EF':

    # bluez-simple-agent hci0 00:00:DE:AD:BE:EF

    Passcode:

> Logitech mouse MX Laser / M555b

To quickly test the connection:

    $ hidd --connect XX:XX:XX:XX:XX:XX

For automated reconnection, use your desktop wizard to configure the
bluetooth mouse. If your desktop environment doesn't includes support
for this task, see the Bluetooth mouse configuration article.

> Headset and ALSA devices

Referencing the bluetooth device in asound.conf

1. Scan for your device:

    $ hcitool (-i optional hci#***) scan

2. Pair your headset with your device:

    $ bluez-simple-agent (optional hci# ***) XX:XX:XX:XX:XX:XX
      and put in your PIN (0000 or 1234, etc)

3. Add this to your /etc/asound.conf file:

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

4. Check to see if it has been added to ALSA devices

    $ aplay -L

5. Now play with aplay:

    $ aplay -D btheadset /path/to/audio/file

or MPlayer:

    $ mplayer -ao alsa:device=btheadset /path/to/audio/or/video/file

To find hci# for a usb dongle, type in:

    $ hcitool dev

Using bluez-tools from the AUR

You can use bluez-tools from the AUR with PulseAudio to stream audio to
a bluetooth headset. Find the MAC of the headset:

    $ hcitool scan

Connect to the headset:

    $ bt-audio -c XX:XX:XX:XX:XX:XX

Open pulseaudio volume control:

    $ pavucontrol

The headset should show up in the Configuration tab.

> Microsoft Bluetooth Mobile Keyboard 6000

1. Scan for your device

    $ hcitool (-i optional_hci#***) scan

    Scanning ...
           00:11:22:33:44:55       Microsoft Bluetooth Mobile Keyboard 6000

2. On second console run as root (do not terminate):

    # bluez-simple-agent

    Agent registered

3. Back on first console run:

    $ bluez-simple-agent hci0 00:11:22:33:44:55

    Enter PIN Code: 1234
    (now enter that PIN on the keyboard and press enter)
    Release
    New device (/org/bluez/5373/hci0/dev_00_11_22_33_44_55)

4.

    $ bluez-test-device trusted 00:11:22:33:44:55

5.

    $ bluez-test-input connect 00:11:22:33:44:55

No your keyboard should work. You can terminate bluez-simple-agent on
second console with Ctrl+C

Bluez4 - Troubleshooting
------------------------

> passkey-agent

    $ passkey-agent --default 1234

    Can't register passkey agent
    The name org.bluez was not provided by any .service files

and

    $ hciconfig dev
    # (no listing)

Try running hciconfig hc0 up

> Sennheiser MM400 headset connection problems

If your Sennheiser MM400 Headset immediately disconnects after
connecting as Headset Service with Blueman, try to connect it as
Audio Sink. Afterwards you can change the headset's Audio Profile to
Telephony Duplex with a right click in Blueman. With this option headset
functionality will be available although the headset was only connected
as Audio Sink in first place and no disconnection will happen (tested
with bluez 4.96-3, pulseaudio 1.1-1 and blueman 1.23-2).

> My device is paired but no sound is played from it

Try to first inspect /var/log/messages.log. If you see such messages:

    Jan 12 20:08:58 localhost pulseaudio[1584]: [pulseaudio] module-bluetooth-device.c: Service not connected
    Jan 12 20:08:58 localhost pulseaudio[1584]: [pulseaudio] module-bluetooth-device.c: Bluetooth audio service not available

try first:

    # pactl load-module module-bluetooth-device

If the module fails to work, do this workaround: Open
/etc/bluetooth/audio.conf and add after [General] (on a new line)

    Enable=Socket

Then restart the bluetooth daemon. Pair again your device, and you
should find it in the pulseaudio settings (advanced settings for the
sound)

More information on Gentoo Wiki

If after fixing this you still can't get sound, try using blueman (this
is the only one that works for me), make sure that notify-osd is
installed or it might show you weird error messages like this one:
"Stream setup failed"

    fail (/usr/lib/python2.7/site-packages/blueman/gui/manager/ManagerDeviceMenu.py:134)
    fail (DBusException(dbus.String(u'Stream setup failed'),),)

See also
--------

-   Gentoo Linux Bluetooth guide
-   openSUSE Bluetooth hardware compatibility list
-   Accessing a Bluetooth phone (Linux Gazette)
-   Bluetooth computer visibility
-   Bluetooth for your mobile phone: Bluetooth pairing, data
    synchronization, photo download, Internet Dial-Up (tethering)
-   Bluetooth pairing and applications for synchronizing phone numbers,
    SMS-messages, phone call entries, your calendar and time; tethering

Retrieved from
"https://wiki.archlinux.org/index.php?title=Bluez4&oldid=305881"

Category:

-   Bluetooth

-   This page was last modified on 20 March 2014, at 15:53.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
