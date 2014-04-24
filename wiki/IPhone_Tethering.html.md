iPhone Tethering
================

Unless disabled by your provider, it's possible to share your iPhone's
3G data connection over WiFi, USB and Bluetooth without needing to
jailbreak. WiFi requires no additional configuration provided your
computer can connect to wireless networks, and you'll find instructions
for USB and Bluetooth below.

Contents
--------

-   1 Tethering over USB
    -   1.1 Tethering over USB using Personal Hotspot
        -   1.1.1 Troubleshooting
            -   1.1.1.1 The iPhone appears in the device list but it
                doesn't connect
            -   1.1.1.2 "Trust This Computer" Alert Loop
    -   1.2 Tethering over USB using SSH and itunnel
    -   1.3 Tethering over USB from within a Windows guest in Virtualbox
-   2 Tethering over Bluetooth
    -   2.1 Hardware Requirements
    -   2.2 Setup
        -   2.2.1 Gnome/XFCE
        -   2.2.2 netcfg

Tethering over USB
------------------

> Tethering over USB using Personal Hotspot

Tethering natively over USB is the optimal choice as it provides a more
stable connection and uses less batteries than bluetooth or wifi.

To tether your iPhone over USB, you will need to install these packages:
usbmuxd, libimobiledevice and ifuse.

Then ensure the ipheth module is loaded (currently included in the
default and LTS Archlinux kernels)

    # modprobe ipheth

Assuming everything's gone smoothly so far, enable Personal Hotspot on
your iPhone and plug it into your computer. At this point you'll have a
new ethernet device available, but connecting through it might not work
quite yet; for some reason, the ipheth module only works when the
iPhone's filesystem has been mounted by ifuse, so unless your system did
it automatically when you plugged your iPhone in, you'll need to do it
manually:

    # ifuse /path/to/mountpoint

To manually unmount it later, run:

    # fusermount -u /path/to/mountpoint

Once your iPhone's filesystem is mounted, you should be able to use any
network manager to connect to the internet through the new iPhone
ethernet device just like you would any other ethernet connection.

Troubleshooting

The iPhone appears in the device list but it doesn't connect

Its possible that you may need to connect your iPhone and pair it with
your computer before connecting in some circumstances (iPhones using a
PIN unlock?):

    # idevicepair pair

"Trust This Computer" Alert Loop

At the time of this writing Feb 12, 2014, the library that enables this
functionality, libimobiledevice and/or its dependencies are not up to
date on the AUR. The bug, however is fixed in the master branch and
until the package maintainer updates the AUR packages, a script has been
made available for self-compilation of the required libraries under
ArchLinux.

Alternatively, install usbmuxd-git, libimobiledevice-git, and ifuse-git
from the Arch User Repository.

> Tethering over USB using SSH and itunnel

You'll need aur/itunnel and community/ifuse before following these
instructions:
http://dev.squarecows.com/2009/05/06/iphone-linux-tethering-via-usb-cable/

> Tethering over USB from within a Windows guest in Virtualbox

One potential way to accomplish this is to use a Windows guest in
VirtualBox, and present the host Arch system with a network interface
(Host Only?). The working iPhone network device in Windows might then be
bridged to the host only interface device within Windows. The iPhone USB
network driver is installed together with iTunes. However, this has yet
to be tested successfully. More info to come.

Tethering over Bluetooth
------------------------

Tethering over Bluetooth will drain the batteries relatively quickly,
but simultaneous charging from an USB port works well.

> Hardware Requirements

-   iPhone running OS 3.0 with tethering enabled. See Settings > General
    > Network and turn on the tethering option.
-   Bluetooth Adapter or similar, preferably with EDR(Enhanced Data
    Rate) for acceptable speeds. Tested with a Belkin F8T016NE.

> Setup

See the main article Bluetooth and setup the bluetooth daemon.

Gnome/XFCE

Install the Blueman GTK+ Bluetooth manager

    # pacman -S blueman

A Bluetooth icon should appear in your notification area. Note: the icon
may not appear if bluetooth was not turned on at startup. Click it, and
search for nearby devices, adding your iPhone (note, you may need to
have the Bluetooth setting screen up on your iPhone for discovery to
work).

Once the iPhone has been added to the devices list, open the Device menu
and select pair. This will require the usual entering of a PIN on the
computer then the iPhone. Now open the Device menu again, and choose
Network Access > Network Access Point. If everything goes well, blueman
reports a success and the status bar on your iPhone should glow blue,
indicating a successful tether.

Blueman will have created a new network interface, typically bnep0. To
connect to it, run the following as root.

    # dhcpcd bnep0

netcfg

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: netcfg has been  
                           superseded by netctl     
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Alternatively, you can create a netcfg network profile to allow easy
tethering from the command line, without requiring Blueman or Gnome.
Assuming an already paired iPhone with address '00:00:DE:AD:BE:EF',
simply create a profile in /etc/network.d called - for example -
'tether':

     CONNECTION="ethernet"
     DESCRIPTION="Ethernet via pand tethering to iPhone"
     INTERFACE="bnep0"
     IPHONE="00:00:DE:AD:BE:EF"
     PRE_UP="pand -E -S -c ${IPHONE} -e ${INTERFACE} -n 2>/dev/null"
     POST_DOWN="pand -k ${IPHONE}"
     IP="dhcp"

Then, either as root or using sudo, execute:

    # netcfg tether

To bring the interface down and un-tether:

    # netcfg down tether

Retrieved from
"https://wiki.archlinux.org/index.php?title=IPhone_Tethering&oldid=304190"

Categories:

-   Networking
-   Mobile devices

-   This page was last modified on 12 March 2014, at 19:07.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
