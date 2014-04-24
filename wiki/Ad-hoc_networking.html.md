Ad-hoc networking
=================

Related articles

-   Network configuration
-   Wireless network configuration
-   Software access point
-   Internet sharing

An IBSS (Independent Basic Service Set) network, often called an ad-hoc
network, is a way to have a group of devices talk to each other
wirelessly, without a central controller. It is an example of an
peer-to-peer network, in which all devices talk directly to each other,
with no inherent relaying.

For example, ad-hoc networking may be used to share an internet
connection.

Contents
--------

-   1 Requirements
-   2 Wifi link layer
    -   2.1 Manual method
    -   2.2 WPA supplicant
-   3 Network configuration
-   4 Tips and tricks
    -   4.1 Using NetworkManager
    -   4.2 Custom systemd service (with wpa_supplicant and static IP)
-   5 See also

Requirements
------------

-   A nl80211 compatible wireless device (e.g. ath9k) on all devices
    which will connect to the network

Wifi link layer
---------------

Since IBSS network is a peer-to-peer network, the steps necessary to set
up the wifi link layer should be the same on all devices.

Tip:It is possible to create complex network topologies, see Linux
Wireless documentation for advanced examples.

> Manual method

Warning:This method creates unencrypted ad-hoc network. See #WPA
supplicant for method using WPA encryption.

See Wireless network configuration#Manual setup for a better explanation
of the following commands. Make sure that iw is installed.

Set the operation mode to ibss:

    # iw interface set type ibss

Bring the interface up (an additional step like rfkill unblock wifi
might be needed):

    # ip link set interface up

Now you can create an ad-hoc network. Replace your_ssid with the name of
the network and frequency with the frequency in MHz, depending on which
channel you want to use. See the Wikipedia page List of WLAN channels
for a table showing frequencies of individual channels.

    # iw interface ibss join your_ssid frequency

> WPA supplicant

Note:This method creates ad-hoc network using WPA encryption. WPA2 is
currently not supported (August 2013).

Ensure that wpa_supplicant is installed, and create a configuration file
for it (see WPA supplicant for details).

    /etc/wpa_supplicant-adhoc.conf

    ctrl_interface=DIR=/run/wpa_supplicant GROUP=wheel

    # use 'ap_scan=2' on all devices connected to the network
    ap_scan=2

    network={
        ssid="MySSID"
        mode=1
        frequency=2432
        proto=WPA
        key_mgmt=WPA-NONE
        pairwise=NONE
        group=TKIP
        psk="secret passphrase"
    }

Run wpa_supplicant on all devices connected to the network with the
following command:

    # wpa_supplicant -B -i interface -c /etc/wpa_supplicant-adhoc.conf -D nl80211,wext

Network configuration
---------------------

The final step is to assign an IP address to all devices in the network.
There are multiple ways to do this:

-   Assign static IP addresses. See Network configuration#Static IP
    address for details.
-   Running DHCP server on one device. See dhcpd or dnsmasq for details.
-   Running avahi-autoipd. See Avahi#Obtaining IPv4LL IP address for
    details.

If you want to share an internet connection to the ad-hoc network, see
Internet sharing.

Tips and tricks
---------------

> Using NetworkManager

If you use NetworkManager, you can use nm-applet for ad-hoc network
configuration instead of the manual method described above. See
NetworkManager#Ad-hoc for details.

Note:NetworkManager does not support WPA encryption in ad-hoc mode.

> Custom systemd service (with wpa_supplicant and static IP)

You can use the following templates to enable wireless ad-hoc
networking:

    /etc/conf.d/network-wireless-adhoc@<interface>

    addr=192.168.0.2
    mask=24

    /etc/systemd/system/network-wireless-adhoc@.service

    [Unit]
    Description=Ad-hoc wireless network connectivity (%i)
    Wants=network.target
    Before=network.target
    BindsTo=sys-subsystem-net-devices-%i.device
    After=sys-subsystem-net-devices-%i.device

    [Service]
    Type=oneshot
    RemainAfterExit=yes
    EnvironmentFile=/etc/conf.d/network-wireless-adhoc@%i

    # perhaps rfkill is not needed for you
    ExecStart=/usr/bin/rfkill unblock wifi
    ExecStart=/usr/bin/ip link set %i up
    ExecStart=/usr/bin/wpa_supplicant -B -i %i -D nl80211,wext -c /etc/wpa_supplicant-adhoc.conf
    ExecStart=/usr/bin/ip addr add ${addr}/${mask} dev %i

    ExecStop=/usr/bin/ip addr flush dev %i
    ExecStop=/usr/bin/ip link set %i down

    [Install]
    WantedBy=multi-user.target

See also
--------

-   Ubuntu community wiki WifiDocs/Adhoc
-   Manual about creating an Ad-Hoc network on UbuntuGeek
-   Share your 3G Internet connection over wifi

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ad-hoc_networking&oldid=302092"

Category:

-   Wireless Networking

-   This page was last modified on 25 February 2014, at 18:38.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
