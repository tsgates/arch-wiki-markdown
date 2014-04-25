UWMWiFi
=======

UWMWiFi is the wireless network used by the University of
Wisconsin-Milwaukee.

Contents
--------

-   1 Netctl Setup
-   2 Manual Setup
-   3 About Identity
-   4 See Also

Netctl Setup
------------

Still a work in progress, but this seems to function

    /etc/netctl/UWMWiFi

    Description='UWM WiFi Network'
    Interface=wlp3s0
    Connection=wireless
    Security=wpa-configsection
    IP=dhcp
    WPAConfigSection=(
        'ssid="UWMWiFi"'
        'key_mgmt=WPA-EAP'
        'eap=PEAP'
        'identity="user@uwm.edu"'
        'password="password"'
        'priority=1'
    )

Then to connect

    # netctl stop-all
    # netctl enable UWMWiFi
    # netctl start UWMWiFi

Manual Setup
------------

If netctl does not work properly, try connecting manually using the iw
tool and wpa_supplicant as directed in Wireless network configuration.
Don't forget that most of these commands need to be run with elevated
permissions.

    /etc/wpa_supplicant/uwm.conf


    network={
     ssid="UWMWiFi"
     key_mgmt=WPA-EAP
     eap=PEAP
     identity="user@uwm.edu"
     password="password"

    }

    ctrl_interface=DIR=/run/wpa_supplicant

Get card name

    # ip link

Assuming your card is wlan0

    # ip link set wlan0 up
    # wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant/uwm.conf
    # dhcpcd wlan0

After resuming from sleep or similar

    # dhcpcd wlan0 -k
    # dhcpcd wlan0

So far, this method seems more reliable.

About Identity
--------------

On some parts of campus the identity field requires "@uwm.edu" and on
some parts it requires only the username. For example, the in the Union
connecting will fail if you include @uwm.edu, but in the EMS it will
fail without it.

This will be tested and validated in the future.

See Also
--------

https://wiki.archlinux.org/index.php/Netctl

https://wiki.archlinux.org/index.php/Wireless_Setup

https://wiki.archlinux.org/index.php/WPA_Supplicant

http://www4.uwm.edu/technology/authenticated/wifi/uwm/

Retrieved from
"https://wiki.archlinux.org/index.php?title=UWMWiFi&oldid=297910"

Category:

-   Wireless Networking

-   This page was last modified on 15 February 2014, at 16:00.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
