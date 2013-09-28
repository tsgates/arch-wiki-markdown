Wicd
====

Summary

Covers installation and configuration of Wicd – an open source wired and
wireless network manager for Linux which aims to provide a simple
interface to connect to networks with a wide variety of settings.

Overview

Arch Linux provides netcfg for network management. netcfg supports wired
connections on desktops and servers, as well as wireless setups and
roaming for mobile users, facilitating easy management of network
profiles. NetworkManager and Wicd are popular third-party alternatives.

Wicd is a network connection manager that can manage wireless and wired
interfaces, similar and an alternative to NetworkManager. Wicd is
written in Python and GTK+, requiring fewer dependencies than other
network managers. Alternatively, a version of Wicd for KDE, written in
Qt, is available from the Arch User Repository. Wicd can also run from
the terminal in a curses interface, requiring no X server session or
task panel (see #Running Wicd).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Base package                                                 |
|     -   1.2 GTK client                                                   |
|     -   1.3 KDE client                                                   |
|     -   1.4 Notifications                                                |
|     -   1.5 Alternative                                                  |
|                                                                          |
| -   2 Getting Started                                                    |
|     -   2.1 Initial Setup                                                |
|     -   2.2 Running Wicd                                                 |
|         -   2.2.1 Autostart                                              |
|                                                                          |
|     -   2.3 Scripts                                                      |
|         -   2.3.1 Stop ARP spoofing attacks                              |
|         -   2.3.2 Change MAC using macchanger                            |
|                                                                          |
| -   3 Troubleshooting                                                    |
|     -   3.1 Failed to get IP address                                     |
|     -   3.2 Random disconnecting                                         |
|         -   3.2.1 Cause #1                                               |
|         -   3.2.2 Cause #2                                               |
|                                                                          |
|     -   3.3 Importing pynotify failed, notifications disabled            |
|     -   3.4 Dbus connection error message                                |
|     -   3.5 Problems after package update                                |
|     -   3.6 Note about graphical sudo programs                           |
|     -   3.7 Making eduroam work with wicd                                |
|     -   3.8 Two instances of wicd-client (and possibly two icons in      |
|         tray)                                                            |
|     -   3.9 Bad password using PEAP with TKIP/MSCHAPV2                   |
|     -   3.10 Wicd skips obtaining IP address on WLAN                     |
|                                                                          |
| -   4 External links                                                     |
+--------------------------------------------------------------------------+

Installation
------------

> Base package

Install wicd, available in the Official Repositories. It includes
everything needed to run the wicd daemon and the wicd-cli and
wicd-curses interfaces.

> GTK client

For a GTK front-end, install wicd-gtk, available in the official
repositories. It includes everything needed to run the GTK interface of
wicd and the autostart file for the client to appear in the system tray.

> KDE client

For a KDE front-end, install wicd-kde, available in the Arch User
Repository.

> Notifications

To enable visual notifications about network status, you need to install
the notification-daemon.

If you are not using GNOME, you will want to install xfce4-notifyd
instead of the notification-daemon, because it pulls a lot of
unnecessary GNOME packages.

> Alternative

The wicd-bzr buildscript is available in the AUR, which should build the
latest development branch. If you need an alternative version or you
just want to roll your own package, you can easily build it using ABS.

Getting Started
---------------

> Initial Setup

Wicd provides a daemon that must be started.

Warning: Running multiple network managers will cause problems, so it is
important to disable all other network management daemons.

First, stop all previously running network daemons:

    # systemctl stop netcfg
    # systemctl stop dhcpcd
    # systemctl stop NetworkManager

Disable any existing network management services, including netcfg,
dhcpcd, and networkmanager. Refer to Systemd#Using_units.

Note: You might need to stop and disable the network daemon instead of
netcfg, which is a current replacement for network service. If unsure,
try disabling both.

Start the wicd service:

    # systemctl start wicd

Enable the service at system start up:

    # systemctl enable wicd.service

Add your account to users group:

    # gpasswd -a USERNAME users

Note: The Unix group that dbus allows to access wicd is subject to
change, and may be different than users. Check which policy group is
specified in /etc/dbus-1/system.d/wicd.conf, and add your user to that
group.

If you added your user to a new group, log out and then log in.

> Running Wicd

To load Wicd, run:

    $ wicd-client

To force it to start minimized in the notification area, run:

    $ wicd-client --tray

If your desktop environment does not have a notification area, run:

    $ wicd-client -n

The above commands will only work if you have installed the wicd-gtk. If
you did not install wicd-gtk then use wicd-cli or wicd-curses:

    $ wicd-curses

Note: Wicd does not prompt you for a passkey. To use encrypted
connections (WPA/WEP), expand the network you want to connect to, click
Advanced and enter the needed info.

Autostart

The wicd-gtk package puts a file in
/etc/xdg/autostart/wicd-tray.desktop, which will autostart wicd-client
upon login to your DE/WM. If so, enabling the service with systemctl is
sufficient.

If /etc/xdg/autostart/wicd-tray.desktop does not exist, you can add
wicd-client to your DE/WM startup to have the application start when you
log in.

Note:If wicd-client is added to DE/WM startup when
/etc/xdg/autostart/wicd-tray.desktop exists, you will have an issue of
two wicd-client instances running.

> Scripts

Wicd has the ability to run scripts during all stages of the connection
process (post/pre connect/disconnect). Simply place a script inside the
relevant stage folder within /etc/wicd/scripts/ and make it executable.

The scripts are able to receive three parameters, these being:

    $1 - the connection type (wireless/wired).
    $2 - the ESSID (network name).
    $3 - the BSSID (gateway MAC).

Stop ARP spoofing attacks

The script below can be used to set a static ARP, to stop ARP spoofing
attacks. Simply change the values within the case statement to match
those of the networks you want to set static ARP entries for.

    #!/bin/bash
    #Set the parameters passed to this script to meaningful variable names.
    connection_type="$1"
    essid="$2"
    bssid="$3"

    if [ "${connection_type}" == "wireless" ]; then

           #Change below to match your networks.
           case "$essid" in
                   YOUR-NETWORK-NAME-ESSID)
                           sudo arp -s 192.168.0.1 00:11:22:33:44:55
                           ;;
                   Netgear01923)
                           sudo arp -s 192.168.0.1 10:11:20:33:40:50
                           ;;
                   ANOTHER-ESSID)
                           sudo arp -s 192.168.0.1 11:33:55:77:99:00
                           ;;
                   *)
                           echo "Static ARP not set. No network defined."
                           ;;
           esac
    fi

Change MAC using macchanger

The script below can be used to change the MAC address of your network
interfaces.

To change the MAC whenever you connect to a network, place this script
under /etc/wicd/scripts/preconnect/

Take a look at macchanger --help to adjust the macchanger command to
your liking.

    #!/usr/bin/env bash

    connection_type="$1"

    if [[ "${connection_type}" == "wireless" ]]; then
        ip link set wlan0 down
        macchanger -A wlan0
        ip link set wlan0 up
    elif [[ "${connection_type}" == "wired" ]]; then
        ip link set eth0 down
        macchanger -A eth0
        ip link set eth0 up
    fi

Troubleshooting
---------------

> Failed to get IP address

If wicd repeatedly fails to get an IP address using the default dhcpcd
client, try installing and using dhclient instead:

    # pacman -S dhclient

Do not forget to select dhclient as the primary dhcp client in wicd
options afterwards!

If wicd can get an IP address for a wired interface and is unable to get
an IP address for a wireless interface, try disabling the wireless
card's powersaving features:

    # iwconfig wlan0 power off

> Random disconnecting

Cause #1

If dmesg says
wlan0: deauthenticating from MAC by local choice (reason=3) and you lose
your Wi-Fi connection, it is likely that you have a bit too aggressive
power-saving on your Wi-Fi card[1]. Try disabling the wireless card's
power-saving features:

    # iwconfig wlan0 power off

If you have the package pm-utils installed, it may be the reason
power-saving is on in your system[2]. You can put

    #!/bin/sh
    /sbin/iwconfig wlan0 power off

into the file /etc/pm/power.d/wireless (create it if it does not exist
and make it executable) and see if things get better.

If your card does not support iwconfig wlan0 power off, check the BIOS
for power management options. Disabling PCI-Express power management in
the BIOS of a Lenovo W520 resolved this issue.

Cause #2

If you are experiencing frequent disconnections with wireless and dmesg
shows messages such as

ieee80211 phy0: wlan0: No probe response from AP xx:xx:xx:xx:xx:xx after 500ms, disconnecting

try changing the channel bandwidth to 20MHz through your router's
settings page.

> Importing pynotify failed, notifications disabled

In case the python2-notify package did not get installed automatically.
You can install it from Official Repositories.

> Dbus connection error message

Otherwise you will get dbus error messages and not be able to connect to
networks.

-   NOTE: If wicd suddenly stopped working and it complains about dbus,
    it is quite likely that you just need to remove wicd fully,
    including and all its configuration files, and re-install it from
    scratch:

    # pacman -R wicd
    # rm -Rf /etc/wicd /var/log/wicd /etc/dbus-1/system.d/wicd*
    # pacman -S wicd

Check this link for more details:
https://bbs.archlinux.org/viewtopic.php?pid=577141#p577141

Wicd-client also throws a dbus connection error message ("Could not
connect to wicd's D-Bus interface.") when wicd is not running due to a
problem with a config file. It seems that sometimes an empty account
gets added to /etc/wicd/wired-settings.conf in which case you simply
have to remove the

    [] 

and restart wicd.

When running wicd daemon with `rc.d` it won't print error that `pid`
file is created. If you are sure wicd isn't running remove this file:

     # rm /var/run/wicd/wicd.pid

> Problems after package update

Sometimes the wicd client fails to load after a package update due to
D-Bus errors.

A solution is to remove the config files in the /etc/wicd/ directory.

    # systemctl stop wicd
    # rm /etc/wicd/*.conf
    # systemctl start wicd

> Note about graphical sudo programs

If you are receiving an error about wicd failing to find a graphical
sudo program, run one of the following commands:

    $ ktsuss wicd-client -n

    $ gksudo wicd-client -n

    $ kdesu wicd-client -n

These programs require the ktsuss (found in the AUR), gksu, and kdesu
packages, respectively.

> Making eduroam work with wicd

Note:You may try the AUR package wicd-eduroam first. It will appear in
wicd as "eduroam". If it does not work for you, try the following.

This profile will only work for eduroam institutions which use TTLS and
will not work for PEAP.

Save the following as /etc/wicd/encryption/templates/ttls-80211

    /etc/wicd/encryption/templates/ttls-80211

    name = TTLS for Wireless
    author = Alexander Clouter
    version = 1
    require anon_identity *Anonymous_Username identity *Identity password *Password 
    optional ca_cert *Path_to_CA_Cert cert_subject *Certificate_Subject
    -----
    ctrl_interface=/var/run/wpa_supplicant
    network={
           ssid="$_ESSID"
           scan_ssid=$_SCAN

           key_mgmt=WPA-EAP
           eap=TTLS

           ca_cert="$_CA_CERT"
           subject_match="$_CERT_SUBJECT"
     
           phase2="auth=MSCHAPv2 auth=PAP"

           anonymous_identity="$_ANON_IDENTITY"
           identity="$_IDENTITY"
           password="$_PASSWORD"
    }

Open a terminal

    cd /etc/wicd/encryption/templates
    echo ttls-80211 >> active

Open wicd, choose TTLS for Wireless in the properties of eduroam, and
enter the appropriate settings for your institution. The format of the
subject match should be something like "/CN=server.example.com".

NB. This only works in my institution by commenting subject_match, which
is not secure, but at least it connects.

> Two instances of wicd-client (and possibly two icons in tray)

See the note in Wicd#Running_Wicd about the autostart file in
/etc/xdg/autostart and the forum post and bug report provided in
Wicd#External_Links. Essentially, if
/etc/xdg/autostart/wicd-tray.desktop exists, remove it. You only need
the wicd service enabled in systemd.

> Bad password using PEAP with TKIP/MSCHAPV2

The connection template PEAP with TKIP/MSCHAPV2 requires the user to
enter the path to a CA certificate besides entering username and
password. However this can cause troubles resulting in a error message
of a bad password *. A possible solution is the usage of PEAP with GTC
instead of TKIP/MSCHAPV2 which does not require to enter the path of the
CA cert.

> Wicd skips obtaining IP address on WLAN

This can be caused by dhcpcd running alongside wicd as systemd service.
A solution would be to stop/disable dhcpcd.

    # systemctl stop dhcpcd
    # systemctl disable dhcpcd

External links
--------------

-   Note on interfaces at the official site
-   Forum post about two instances of wicd-client and /etc/xdg/autostart
-   Bug report mentioning /etc/xdg/autostart and wicd-client behavior

Retrieved from
"https://wiki.archlinux.org/index.php?title=Wicd&oldid=253349"

Categories:

-   Networking
-   Wireless Networking
