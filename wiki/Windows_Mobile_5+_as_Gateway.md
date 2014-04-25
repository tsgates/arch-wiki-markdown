Windows Mobile 5+ as Gateway
============================

You can use GPRS/EDGE- or 3G-enabled WM device to access internet. Under
WM2003 you would have to use your device as GPRS-modem (see Bluetooth
GPRS Howto), but starting with WM5 your device can be used as NAT
gateway.

There are two ways to share your device's internet connection with PC:
via USB or via bluetooth PAN.

Contents
--------

-   1 USB connection
    -   1.1 WM device configuration
    -   1.2 PC configuration
        -   1.2.1 Installing SynCE driver via PKGBUILD
        -   1.2.2 Installing SynCE driver by hand
    -   1.3 Connecting to the Internet
-   2 Bluetooth PAN connection
    -   2.1 WM device configuration
    -   2.2 PC configuration

USB connection
--------------

> WM device configuration

-   Configure GPRS/EDGE or 3G internet connection.
-   Enable advanced network functionality in Start > Settings >
    Connections > USB to PC.

> PC configuration

All you need is USB RNDIS driver. It is already included in default
kernel(check for cdc_ether.ko, rndis_host.ko and usbnet.ko in
/lib/modules/$(uname -r)/kernel/drivers/usb/net directory). With each
kernel release the default driver works for more and more devices. Still
it may not work for yours. I.e. some users report that with the driver
from linux the new interface appears when WM device is connected, but
disappears when Internet sharing (see below) is turned on.

So, first, try the default driver from linux. In case it does not work
for you, you should install rndis-usb-lite driver from SynCE project.
You may install it via an AUR PKGBUILD or by hand.

Installing SynCE driver via PKGBUILD

There is a usb-rndis-lite package in AUR unsupported which downloads and
installs the driver.

Installing SynCE driver by hand

Having base-devel package installed should be enough to build the
driver. To do so, download the usb-rndis-lite sources using the
appropriate link from SynCE source installation page or use whatever way
you prefer, following the instructions on SynCE download page. Unpack
the tarball and navigate to the source directory. Use

    make

to build the driver but don't make install. Now you should have three
kernel modules (files with .ko extension) in the directory:
cdc_ether.ko, rndis_host.ko and usbnet.ko. You want these modules to
supersede those from linux. In fact you may just copy these files to
/lib/modules/$(uname -r)/kernel/drivers/usb/net directory (to overwrite
the existing driver), but the right way is to put the modules in
/lib/modules/$(uname -r)/updates directory, so that they are prefered
over all modules with same names.

    mkdir /lib/modules/$(uname -r)/updates
    cp *.ko /lib/modules/$(uname -r)/updates
    depmod -ae

You may need to reboot or to re-insert the modules if the driver still
does not work.

Now, when you connect your WM device to the PC via USB cable, you should
find new network interface (usually rndis0 for SynCE driver and just
ethN for default one). Execute # ip a to check that.

> Connecting to the Internet

-   Connect your devite to PC via USB cable.
-   On your device run Start > Programs > Internet Sharing. Select USB
    for PC Connection and proper internet connection. Then tap Connect
    and wait untill the Internet connection is established.
-   On your PC bring up the rndis0 (or whatever interface you have for
    device-PC connection) interface (usually this and following commands
    should be executed as root).

    # ip link set dev rndis0 up

-   Obtain ip address via dhcp:

    dhcpcd rndis0

or if you prefer dhclient:

    dhclient rndis0

If you use a connection manager (like wicd, NetworkManager, Network
profiles or etc.), you may use it to perform the last two steps
(bringing up the interface and obtainind IP via dhcp), but I didn't try
that.

That's all. Now you should have an IP of 192.168.0.x and 192.168.0.1
(this is your device's IP) as a default gateway.

Bluetooth PAN connection
------------------------

The following configuration has been tested on a Windows Mobile 6.5
device.

> WM device configuration

-   Configure GPRS/EDGE or 3G internet connection.
-   Enable "Receive all incoming beams" on the "Beam" configuration
-   On the mobile, turn on your bluetooth and make it visible
-   Pair (via bluetooth) your mobile with your PC.
-   Run the "Internet Sharing" application and configure it to
    "Bluetooth PAN"

> PC configuration

As root, run the following script:

    modprobe bnep
    for attempt in {1..3}; do
    pand -n connect AA:BB:CC:DD:EE:FF && break
    done
    sleep 1
    ip link set dev bnep0 up
    dhcpcd bnep0

where AA:BB:CC:DD:EE:FF is your mobile's bluetooth address.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Windows_Mobile_5%2B_as_Gateway&oldid=250571"

Category:

-   Mobile devices

-   This page was last modified on 14 March 2013, at 03:19.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
