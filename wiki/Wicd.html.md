Wicd
====

Related articles

-   Network configuration
-   Wireless network configuration
-   Netctl
-   NetworkManager

Wicd is a network connection manager that can manage wireless and wired
interfaces, similar and an alternative to NetworkManager. Wicd is
written in Python and GTK+. Alternatively, a version of Wicd for KDE,
written in Qt, is available from the Arch User Repository. Wicd can also
run from the terminal in a curses interface, requiring no X server
session or task panel (see #Running Wicd in Text Mode).

Note:Currently Wicd is no longer actively developed due to the lack of
manpower. For more information, see this bug report. If you want a
stable and actively developed network manager instead, consider Connman
or netctl.

Contents
--------

-   1 Installation
    -   1.1 Base package
    -   1.2 GTK+ client
    -   1.3 KDE client
    -   1.4 Notifications
    -   1.5 Alternative
-   2 Getting started
    -   2.1 Initial setup
    -   2.2 Running Wicd in Desktop Environment
    -   2.3 Running Wicd in Text Mode
    -   2.4 Autostart
    -   2.5 Scripts
        -   2.5.1 Stop ARP spoofing attacks
        -   2.5.2 Change MAC using macchanger
-   3 Troubleshooting
    -   3.1 Autoconnect on resume from hibernation/suspension
    -   3.2 Importing pynotify failed, notifications disabled
    -   3.3 Dbus connection error message
    -   3.4 Problems after package update
    -   3.5 Note about graphical sudo programs
    -   3.6 Making eduroam work with wicd
    -   3.7 Two instances of wicd-client (and possibly two icons in
        tray)
    -   3.8 Bad password using PEAP with TKIP/MSCHAPV2
    -   3.9 Wicd skips obtaining IP address on wlp
    -   3.10 dhcpcd not running
-   4 See also

Installation
------------

> Base package

Install wicd, available in the official repositories. It includes
everything needed to run the wicd daemon and the wicd-cli and
wicd-curses interfaces.

> GTK+ client

For a GTK+ front-end, install wicd-gtk, available in the official
repositories. It includes everything needed to run the GTK interface of
wicd and the autostart file for the client to appear in the system tray.

> KDE client

For a KDE front-end, install wicd-kde, available in the AUR.

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

Getting started
---------------

> Initial setup

Wicd provides a daemon that must be started.

Warning: Running multiple network managers will cause problems, so it is
important to disable all other network management daemons.

First, stop all previously running network daemons (like netctl, netcfg,
dhcpcd, NetworkManager).

Disable any existing network management services, including netctl,
netcfg, dhcpcd, and networkmanager. Refer to Systemd#Using_units.

Note:You might need to stop and disable the network daemon instead of
netctl, which is a current replacement for network service. If unsure,
try disabling both.

Start the wicd systemd daemon and enable it at system start up.

Add your account to users group:

    # gpasswd -a USERNAME users

Note:The Unix group that dbus allows to access wicd is subject to
change, and may be different than users. Check which policy group is
specified in /etc/dbus-1/system.d/wicd.conf, and add your user to that
group.

If you added your user to a new group, log out and then log in.

> Running Wicd in Desktop Environment

If you have installed the wicd-gtk and entered the desktop environment.
Open a virtual terminal to run one of the following commands.

-   To start Wicd as system service, run:

    $ systemctl start wicd.service

-   To load Wicd, run:

    $ wicd-client

-   To force it to start minimized in the notification area, run:

    $ wicd-client --tray

-   If your desktop environment does not have a notification area, or if
    you don't want wicd to show tray icon, run:

    $ wicd-client -n

> Running Wicd in Text Mode

If you did not install wicd-gtk then use wicd-cli or wicd-curses:

    $ wicd-curses

Note: Wicd does not prompt you for a passkey. To use encrypted
connections (WPA/WEP), expand the network you want to connect to, click
Advanced and enter the needed info.

> Autostart

The wicd-gtk package puts a file in
/etc/xdg/autostart/wicd-tray.desktop, which will autostart wicd-client
upon login to your DE/WM. If so, enabling the wicd system service is
enough:

    $ systemctl enable wicd.service

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
those of the networks you want to set static ARP entries for. Launch it
as root:

    #!/bin/bash
    #Set the parameters passed to this script to meaningful variable names.
    connection_type="$1"
    essid="$2"
    bssid="$3"

    if [ "${connection_type}" == "wireless" ]; then

            #Change below to match your networks.
            case "$essid" in
            YOUR-NETWORK-NAME-ESSID)
                    arp -s 192.168.0.1 00:11:22:33:44:55
             ;;
             Netgear01923)
                    arp -s 192.168.0.1 10:11:20:33:40:50
             ;;
             ANOTHER-ESSID)
                    arp -s 192.168.0.1 11:33:55:77:99:00
             ;;
             *)
                    echo "Static ARP not set. No network defined."
             ;;
           esac
    fi

Change MAC using macchanger

See the relative article.

The script below can be used to change the MAC address of your network
interfaces.

To change the MAC whenever you connect to a network, place this script
under /etc/wicd/scripts/preconnect/.

Take a look at macchanger --help to adjust the macchanger command to
your liking.

    #!/usr/bin/env bash

    connection_type="$1"

    if [[ "${connection_type}" == "wireless" ]]; then
            ip link set wlp2s0 down
            macchanger -A wlp2s0
            ip link set wlp2s0 up
    elif [[ "${connection_type}" == "wired" ]]; then
            ip link set enp1s0 down
            macchanger -A enp1s0
            ip link set enp1s0 up
    fi

Troubleshooting
---------------

See Network configuration#Troubleshooting for troubleshooting wired
connections and Wireless network configuration#Troubleshooting for
troubleshooting wireless connections. This section covers only problems
specific to wicd.

> Autoconnect on resume from hibernation/suspension

If for some reasons autoconnect on resume from hibernation or suspension
does not work automatically, you can manually restart Wicd by enabling
the following service file for your user.

    /etc/systemd/system/wicd-resume@.service

    [Unit]
    Description=Restart Wicd autoconnect service on resume
    After=suspend.target

    [Service]
    Type=oneshot
    User=%i
    RemainAfterExit=yes
    ExecStartPre=/usr/share/wicd/daemon/suspend.py
    ExecStart=/usr/share/wicd/daemon/autoconnect.py

    [Install]
    WantedBy=suspend.target

> Importing pynotify failed, notifications disabled

In case the python2-notify package did not get installed automatically.
You can install it from official repositories.

> Dbus connection error message

If wicd suddenly stopped working and it complains about dbus, it is
quite likely that you just need to remove wicd fully, including and all
its configuration files, and re-install it from scratch:

    # pacman -R wicd
    # rm -rf /etc/wicd /var/log/wicd /etc/dbus-1/system.d/wicd*
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

If the above doesn't work you could try
https://bbs.archlinux.org/viewtopic.php?pid=1268721

> Problems after package update

Sometimes the wicd client fails to load after a package update due to
D-Bus errors.

A solution is to remove the config files in the /etc/wicd/ directory.

    # systemctl stop wicd
    # rm /etc/wicd/*.conf
    # systemctl start wicd

> Note about graphical sudo programs

If you are receiving an error about wicd failing to find a graphical
sudo program, install one of gksu, ktsuss, or kdebase-runtime, then use
the relative command:

    $ ktsuss wicd-client -n

    $ gksudo wicd-client -n

    $ kdesu wicd-client -n

> Making eduroam work with wicd

Note:You may try the AUR package wicd-eduroam first. It will appear in
wicd as "eduroam". If it does not work for you, try the following.

This profile will only work for eduroam institutions which use TTLS and
will not work for PEAP (you can find a PEAP profile here: Eduroam wicd).

Save the following as /etc/wicd/encryption/templates/ttls-80211

    /etc/wicd/encryption/templates/ttls-80211

    name = TTLS for Wireless
    author = Alexander Clouter
    version = 1
    require anon_identity *Anonymous_Username identity *Identity password *Password 
    protected password *Password
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

    # echo ttls-80211 >> /etc/wicd/encryption/templates/active

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

> Wicd skips obtaining IP address on wlp

This can be caused by dhcpcd running alongside wicd as systemd service.
A solution would be to stop/disable dhcpcd.

> dhcpcd not running

Normally it should not be required, nor recommended to run the dhcpcd
service next to wicd. However, if you encounter the error message that
dhcpcd is not running, then you can try running dhcpcd and see if you
encounter any incompatibilities when using both services at the same
time.

    # systemctl start dhcpcd

Alternatively, as a workaround you might consider switching to dhclient
in the Wicd settings.

Note:If you get send_packet: Network is unreachable errors, then try
increasing the timeout in /usr/share/dhclient/dhclient.conf.

See also
--------

-   Note on interfaces at the official site
-   Forum post about two instances of wicd-client and /etc/xdg/autostart
-   Bug report mentioning /etc/xdg/autostart and wicd-client behavior

Retrieved from
"https://wiki.archlinux.org/index.php?title=Wicd&oldid=305383"

Category:

-   Networking

-   This page was last modified on 17 March 2014, at 22:45.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
