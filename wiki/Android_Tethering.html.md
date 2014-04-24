Android Tethering
=================

Tethering is a way to have internet access on your PC through your
smartphone using its network connection. USB tethering and Wi-Fi access
point tethering are natively supported since Android Froyo (2.2). In
older versions of the Android OS, most unofficial ROMs have this option
enabled.

Contents
--------

-   1 Wi-Fi access point
-   2 USB tethering
    -   2.1 Tools Needed
    -   2.2 Procedure
-   3 USB tethering with OpenVPN
    -   3.1 Tools Needed
        -   3.1.1 Configuring the phone connection in Arch Linux
    -   3.2 Procedure
    -   3.3 Troubleshooting
        -   3.3.1 DNS
        -   3.3.2 NetworkManager
-   4 Tethering with SOCKS proxy
    -   4.1 Tools Needed
    -   4.2 Instructions
        -   4.2.1 Tetherbot
        -   4.2.2 Proxoid

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

-   Enable USB Debugging on your phone or device. This is usually done
    from Settings --> Applications --> Development --> USB debugging.
    Reboot the phone after checking this option to make sure USB
    debugging is enabled (if there is no such option, this step probably
    does not apply to your version of Android)
-   Disconnect your computer from any wireless or wired networks
-   Connect the phone to your computer using the USB cable (the USB
    connection mode -- Phone Portal, Memory Card or Charge only -- is
    not important, but please note that you will not be able to change
    the USB mode during tethering)
-   Enable the tethering option from your phone. This is usually done
    from Settings --> Wireless & Networks --> Internet tethering (or
    Tethering & portable hotspot, for more recent versions)
-   Make sure that the USB interface is recognized by the system by
    using the following command:

    $ ip link

You should be able to see a usb0 or enp?s??u? device listed like this
(notice the enp0s20u3 device).

    # ip link

    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default 
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    2: enp4s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT group default qlen 1000
        link/ether ##:##:##:##:##:## brd ff:ff:ff:ff:ff:ff
    3: wlp2s0: <BROADCAST,MULTICAST> mtu 1500 qdisc mq state DOWN mode DEFAULT group default qlen 1000
        link/ether ##:##:##:##:##:## brd ff:ff:ff:ff:ff:ff
    5: enp0s20u3: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
        link/ether ##:##:##:##:##:## brd ff:ff:ff:ff:ff:ff

Note:Take care to use the device name from your own system in the
following commands.

Warning:The name may change depending on the usb port you use. You may
want to change the device name to create a unique name for your device
regardless of the usb port.

-   The final step is to configure a network connection on this
    interface.

USB tethering with OpenVPN
--------------------------

This method works for any old Android version and requires neither root
access nor modifications in the phone (it is also suitable for Android
2.2 and later, but no longer required).

It does not require changes to your browser. In fact, all network
traffic is transparently handled for any PC application (except ICMP
pings). It is somewhat CPU intensive on the phone at high usage rates (a
500 kBytes/sec data transfer rate may take more than 50% of phone CPU on
a powerful Acer Liquid).

> Tools Needed

For Arch, you need to install the openvpn package. It is also required
to have the Android SDK installed (which can be obtained here or from
the AUR). On the phone, you need the azilink application, which is a
Java-based NAT that will communicate with OpenVPN on your computer.

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
computer) to make the change effective.

Now run in your linux PC the adb shell command from the Android SDK as
plain (non root) user: you should get a unix prompt in your phone.

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

    $ adb forward tcp:41927 tcp:41927

    # openvpn AziLink.ovpn

    AziLink.ovpn

    dev tun
    remote 127.0.0.1 41927 tcp-client
    ifconfig 192.168.56.2 192.168.56.1
    route 0.0.0.0 128.0.0.0
    route 128.0.0.0 128.0.0.0
    socket-flags TCP_NODELAY
    keepalive 10 30
    dhcp-option DNS 192.168.56.1

> Troubleshooting

DNS

You may need to manually update the contents of resolv.conf to

    /etc/resolv.conf

    nameserver 192.168.56.1

NetworkManager

If you're running NetworkManager, you may need to stop it before running
OpenVPN.

Tethering with SOCKS proxy
--------------------------

With this method tethering is achieved by port forwarding from the phone
to the PC. This is suitable only for browsing. For Firefox, you should
set network.proxy.socks_remote_dns to true in about:config ( address bar
)

> Tools Needed

-   android-sdk, android-sdk-platform-tools, and android-udev packages
    from AUR
-   USB connection cable from your phone to PC
-   Either Tetherbot or Proxoid

> Instructions

Tetherbot

Follow the instructions under Using the Socks Proxy on [1].

Proxoid

Follow the instructions demonstrated in the following link

Retrieved from
"https://wiki.archlinux.org/index.php?title=Android_Tethering&oldid=303038"

Categories:

-   Networking
-   Mobile devices

-   This page was last modified on 3 March 2014, at 16:15.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
