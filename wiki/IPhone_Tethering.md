iPhone Tethering
================

Unless disabled by your provider, it's possible to share your iPhone's
3G data connection over WiFi, USB and Bluetooth without needing to
jailbreak. WiFi requires no additional configuration provided your
computer can connect to wireless networks, and you'll find instructions
for USB and Bluetooth below.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Tethering over USB                                                 |
|     -   1.1 Tethering over USB using Personal Hotspot                    |
|         -   1.1.1 Troubleshooting                                        |
|             -   1.1.1.1 The iPhone appears in the device list but it     |
|                 doesn't connect                                          |
|                                                                          |
|     -   1.2 Tethering over USB using SSH and itunnel                     |
|     -   1.3 Tethering over USB from within a Windows guest in Virtualbox |
|                                                                          |
| -   2 Tethering over Bluetooth                                           |
|     -   2.1 Hardware Requirements                                        |
|     -   2.2 Setup                                                        |
|         -   2.2.1 Gnome/XFCE                                             |
|         -   2.2.2 netcfg                                                 |
+--------------------------------------------------------------------------+

Tethering over USB
------------------

> Tethering over USB using Personal Hotspot

Tethering natively over USB is the optimal choice as it provides a more
stable connection and uses less batteries than bluetooth or wifi.

To tether your iPhone over USB, you'll need the following packages
installed:

    # pacman -S usbmuxd libimobiledevice ifuse

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

Once your iPhone's filesystem is mounted, you should be able to use
netcfg, NetworkManager, wicd, dhcpcd etc to connect to the internet
through the new iPhone ethernet device just like you would any other
ethernet connection.

Troubleshooting

The iPhone appears in the device list but it doesn't connect

Its possible that you may need to connect your iPhone and pair it with
your computer before connecting in some circumstances (iPhones using a
PIN unlock?):

    # idevicepair pair

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

From the article entitled Bluetooth:

To use Bluetooth, the bluez package for the Linux Bluetooth protocol
stack must be installed:

    # pacman -S bluez

Once bluez is installed, both the dbus daemon and the bluetooth daemon
must be running:

    # /etc/rc.d/dbus start

    # /etc/rc.d/bluetooth start

The dbus daemon is used to read settings and for pin pairing, while the
bluetooth daemon is required for the Bluetooth protocol. It is important
that dbus is started before bluetooth. If dbus was not running when
bluetooth was started, then try (after dbus is running):

    # /etc/rc.d/bluetooth restart

To start bluetooth automatically on boot, add bluetooth to your daemons
array in rc.conf:

    DAEMONS=(... bluetooth ...)

No further configuration seems to be necessary on Arch systems. If
problems arise, see the first sources link for possible config file
edits.

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
"https://wiki.archlinux.org/index.php?title=IPhone_Tethering&oldid=223932"

Category:

-   Mobile devices
