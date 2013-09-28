Android Tethering
=================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 What is Tethering                                                  |
| -   2 Wi-Fi access point                                                 |
| -   3 USB tethering                                                      |
|     -   3.1 Tools Needed                                                 |
|     -   3.2 Procedure                                                    |
|     -   3.3 Netcfg                                                       |
|                                                                          |
| -   4 USB tethering with OpenVPN                                         |
|     -   4.1 Tools Needed                                                 |
|         -   4.1.1 Configuring the phone connection in Arch Linux         |
|                                                                          |
|     -   4.2 Procedure                                                    |
|                                                                          |
| -   5 Tethering with proxy                                               |
|     -   5.1 Tools Needed                                                 |
|     -   5.2 Instructions                                                 |
+--------------------------------------------------------------------------+

What is Tethering
-----------------

Tethering is a way to have Internet access on your PC through your
smartphone using its network connection. USB and Wi-Fi access point
tethering is natively supported from Android Froyo ( 2.2 ). Older
versions of the Android OS, mostly unofficial roms have this option
enabled.

Wi-Fi access point
------------------

Using an Android phone as a Wi-Fi access point (using 3G) has been
accessible by default since Froyo (Android 2.2) without needing to root
the phone. Moreover, this method will discharge the battery rapidly and
tends to cause intense heating, unlike USB. See : menu/wireless &
networks/Internet tethering/Wi-Fi access point

USB tethering
-------------

> Tools Needed

-   Root access to the phone (for old Android versions, Froyo (Android
    2.2) and beyond can do it natively)
-   USB connection cable from your phone to PC

> Procedure

-   Enable USB Debugging. This is usually done from Settings -->
    Applications --> Development --> USB debugging. Reboot the phone
    after checking this option to make sure USB debugging is enabled (if
    there is no such option, this step probably does not apply to your
    version of Android)
-   Disconnect your computer from any wireless or wired networks
-   Connect the phone to your computer using the USB cable (the USB
    connection mode -- Phone Portal, Memory Card or Charge only -- is
    not important, but please note that you will not be able to change
    the USB mode during tethering)
-   Enable the tethering option from your phone. This is usually done
    from Settings --> Wireless & Networks --> Internet tethering (or
    Tethering & portable hotspot, for more recent versions)

(The following step may not be needed. usbnet module may not be
necessary, do it only if you do not see a usb0 interface in the ifconfig
step)

-   Load the usbnet module(if it's not already loaded). You will need
    root access to do that

    modprobe usbnet

-   Make sure that the USB interface is recognized by the system by
    using the following command:

    ifconfig -a

you should be able to see a usb0 device listed like this (notice the
usb0 device):

    # ifconfig -a

    eth0      Link encap:Ethernet  HWaddr 00:16:36:FA:3E:31  
              UP BROADCAST MULTICAST  MTU:1500  Metric:1
              RX packets:0 errors:0 dropped:0 overruns:0 frame:0
              TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:1000 
              RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

    lo        Link encap:Local Loopback  
              inet addr:127.0.0.1  Mask:255.0.0.0
              inet6 addr: ::1/128 Scope:Host
              UP LOOPBACK RUNNING  MTU:16436  Metric:1
              RX packets:316435 errors:0 dropped:0 overruns:0 frame:0
              TX packets:316435 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:0 
              RX bytes:22875193 (21.8 Mb)  TX bytes:22875193 (21.8 Mb)

    usb0      Link encap:Ethernet  HWaddr C2:5A:11:8D:43:F5  
              BROADCAST MULTICAST  MTU:1500  Metric:1
              RX packets:0 errors:0 dropped:0 overruns:0 frame:0
              TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:1000 
              RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

-   Configure the new network device via DHCP using the following
    command:

    ifconfig usb0 up && dhcpcd usb0

To configure the new network device using the iproute toolkit, issue the
following as root:

    ip link set usb0 up && dhcpcd usb0

To stop the network sharing, issue the command:

    dhcpcd -x usb0

> Netcfg

To use Netcfg to configure USB tethering, just add a static ethernet
configuration like:

    /etc/network.d/usb-tether

    CONNECTION='ethernet'
    DESCRIPTION='A basic dhcp ethernet connection using iproute'
    INTERFACE='usb0'
    IP='dhcp'

USB tethering with OpenVPN
--------------------------

This method works for any old Android version and does not requires root
access nor modifications in the phone (it is also suitable for Android
2.2 and later, but no longer required).

It does not requires changes to your browser; in fact transparently
handles all network traffic for any PC application (except ICMP pings).
It is somewhat CPU intensive in the phone at high usage rates (a 500
kbyte/sec data transfer rate may take more than 50% of phone CPU on a
powerful Acer Liquid).

> Tools Needed

In Arch, you need to install the openvpn package. Is is also required
the Android SDK installed (which can be obtained here). In the phone,
the azilink application, a Java-based NAT that will communicate with
OpenVPN in your computer.

Configuring the phone connection in Arch Linux

Once you have installed the Android SDK, in order to use the provided
tools your phone must be properly set up in udev and your Linux user
needs to be granted rights. Otherwise you may need root privileges to
use the Android SDK, which is not recommended. To perform this
configuration, turn on USB debugging on the phone (usually in Settings
-> Applications -> Development -> USB debugging), connect it to the PC
by the USB cable and run the lsusb command. The device should be listed.
Example output for the Acer Liquid phone:

    Bus 001 Device 006: ID 0502:3202 Acer, Inc. 

Then, create the following file, replacing ciri by your own Linux user
name, and 0502 by the vendor ID of your own phone:

    /etc/udev/rules.d/51-android.rules

    SUBSYSTEM=="usb", ATTR(idVendor)=="0502", MODE="0666" OWNER="ciri"

As root run the udevadm control restart command (or reboot your
computer) to make the change effective. Now run in your linux PC the adb
shell command from the Android SDK as plain (non root) user: you should
get a unix prompt in your phone.

> Procedure

Run the AziLink application in the phone and select "About" at the
bottom to receive instructions, which basically are:

1.  You will have to enable USB debugging on the phone if it was not
    already enabled (usually in Settings -> Applications -> Development
    -> USB debugging).
2.  Connect the phone with the USB cable to the PC.
3.  Run AziLink and make sure that the Service active option at the top
    is checked.
4.  Run the following commands in your Linux PC:
    1.  As plain user: adb forward tcp:41927 tcp:41927 (requires Android
        SDK installed)
    2.  As root: openvpn AziLink.ovpn

    AziLink.ovpn

    dev tun
    remote 127.0.0.1 41927 tcp-client
    ifconfig 192.168.56.2 192.168.56.1
    route 0.0.0.0 128.0.0.0
    route 128.0.0.0 128.0.0.0
    socket-flags TCP_NODELAY
    keepalive 10 30
    dhcp-option DNS 192.168.56.1 

Tethering with proxy
--------------------

With this method tethering is achieved by port forwarding from the phone
to the PC. This is suitable only for browsing. For Firefox, you should
set network.proxy.socks_remote_dns to true in about:config ( address bar
)

> Tools Needed

-   Root access to the PC
-   Android SDK which can be obtained here
-   USB connection cable from your phone to PC
-   Proxoid application(free download from the Android market)

> Instructions

Follow the instructions demonstrated in the following link

Retrieved from
"https://wiki.archlinux.org/index.php?title=Android_Tethering&oldid=198248"

Category:

-   Networking
