NetworkManager
==============

Related articles

-   Network configuration
-   Wireless network configuration
-   Netctl
-   Wicd

NetworkManager is a program for providing detection and configuration
for systems to automatically connect to network. NetworkManager's
functionality can be useful for both wireless and wired networks. For
wireless networks, NetworkManager prefers known wireless networks and
has the ability to switch to the most reliable network.
NetworkManager-aware applications can switch from online and offline
mode. NetworkManager also prefers wired connections over wireless ones,
has support for modem connections and certain types of VPN.
NetworkManager was originally developed by Red Hat and now is hosted by
the GNOME project.

Contents
--------

-   1 Base install
    -   1.1 VPN support
-   2 Graphical front-ends
    -   2.1 GNOME
    -   2.2 KDE
    -   2.3 Xfce
    -   2.4 Openbox
    -   2.5 Other desktops and window managers
    -   2.6 Command line
        -   2.6.1 nmcli examples
-   3 Configuration
    -   3.1 Enable NetworkManager
    -   3.2 Enable NetworkManager Wait Online
    -   3.3 Set up PolicyKit permissions
    -   3.4 Network services with NetworkManager dispatcher
        -   3.4.1 Avoiding the three seconds timeout
        -   3.4.2 Start OpenNTPD
        -   3.4.3 Mount remote folder with sshfs
        -   3.4.4 Use dispatcher to connect to a VPN after a
            network-connection is established
    -   3.5 Proxy settings
    -   3.6 Disable NetworkManager
-   4 Testing
-   5 Troubleshooting
    -   5.1 Using nm-applet, wifi networks don't prompt for password and
        just disconnect
    -   5.2 No traffic via PPTP tunnel
    -   5.3 Network management disabled
    -   5.4 Customizing resolv.conf
    -   5.5 DHCP problems with dhclient
    -   5.6 Hostname problems
        -   5.6.1 Option 2: Configure dhclient to push the hostname to
            the DHCP server
        -   5.6.2 Option 3: Configure NetworkManager to use dhcpcd
    -   5.7 Missing default route
    -   5.8 3G modem not detected
    -   5.9 Switching off WLAN on laptops
    -   5.10 Static IP settings revert to DHCP
    -   5.11 Cannot edit connections as normal user
    -   5.12 Forget hidden wireless network
    -   5.13 VPN not working in Gnome
    -   5.14 Unable to connect to visible european wireless networks
    -   5.15 Automatically connect to VPN not working on boot
    -   5.16 NetworkManager dispatcher does not run using systemd
-   6 Tips and tricks
    -   6.1 Sharing internet connection over Wi-Fi
        -   6.1.1 Ad-hoc
        -   6.1.2 Real AP
    -   6.2 Checking if networking is up inside a cron job or script
    -   6.3 Automatically unlock keyring after login
        -   6.3.1 GNOME
        -   6.3.2 KDE
        -   6.3.3 SLiM login manager
    -   6.4 KDE and OpenConnect VPN with password authentication
    -   6.5 Ignore specific devices
    -   6.6 Connect faster
        -   6.6.1 Disabling IPv6
        -   6.6.2 Use OpenDNS servers
    -   6.7 Enable DNS Caching

Base install
------------

NetworkManager can be installed with the package networkmanager,
available in the official repositories.

Note:You must ensure that no other service that wants to configure the
network is running, in fact multiple networking services will conflict.
You can find a list of the currently running services with
systemctl --type=service and then stop them.

> VPN support

Network Manager VPN support is based on a plug-in system. If you need
VPN support via network manager you have to install one of the following
packages from the official repositories:

-   networkmanager-openconnect
-   networkmanager-openvpn
-   networkmanager-pptp
-   networkmanager-vpnc

Graphical front-ends
--------------------

To configure and have easy access to NetworkManager most people will
want to install an applet. This GUI front-end usually resides in the
system tray (or notification area) and allows network selection and
configuration of NetworkManager. Various applets exist for different
types of desktops.

> GNOME

GNOME's network-manager-applet is lightweight enough and works across
all environments.

If you want to store authentication details (Wireless/DSL) and enable
global connection settings, i.e "available to all users" install and
configure GNOME Keyring.

> KDE

The Plasma-nm front-end is a Plasma widget available in the official
repositories as package kdeplasma-applets-plasma-nm. The older
KNetworkManager front-end Plasma widget is also available as package
kdeplasma-applets-networkmanagement from the aur.

If you have both the Plasma widget and nm-applet installed and do not
want to start nm-applet when using KDE, add the following line to
/etc/xdg/autostart/nm-applet.desktop:

    NotShowIn=KDE

See Userbase page for more info.

> Xfce

network-manager-applet will work fine in Xfce, but in order to see
notifications, including error messages, nm-applet needs an
implementation of the Freedesktop desktop notifications specification
(see the Galapago Project) to display them. To enable notifications
install xfce4-notifyd, a package that provides an implementation for the
specification.

Without such a notification daemon, nm-applet outputs the following
errors to stdout/stderr:

    (nm-applet:24209): libnotify-WARNING **: Failed to connect to proxy
    ** (nm-applet:24209): WARNING **: get_all_cb: couldn't retrieve
    system settings properties: (25) Launch helper exited with unknown
    return code 1.
    ** (nm-applet:24209): WARNING **: fetch_connections_done: error
    fetching connections: (25) Launch helper exited with unknown return
    code 1.
    ** (nm-applet:24209): WARNING **: Failed to register as an agent:
    (25) Launch helper exited with unknown return code 1

nm-applet will still work fine, though, but without notifications.

If nm-applet is not prompting for a password when connecting to new wifi
networks, and is just disconnecting immediately, you probably need to
install gnome-keyring.

> Openbox

To function properly in Openbox, the GNOME applet requires the
xfce4-notifyd notification daemon for the same reason as in XFCE and the
gnome-icon-theme package to be able to display the applet in the
systray.

If you want to store authentication details (Wireless/DSL) install and
configure gnome-keyring.

nm-applet installs the autostart file at
/etc/xdg/autostart/nm-applet.desktop. If you have issues with it (e.g.
nm-applet is started twice or is not started at all), see
Openbox#Autostart directory or [1] for solution.

> Other desktops and window managers

In all other scenarios it is recommended to use the GNOME applet. You
will also need to be sure that the gnome-icon-theme package is installed
to be able to display the applet.

To store connection secrets install and configure gnome-keyring.

In order to run nm-applet without a systray, you can use trayer or
stalonetray. For example, you can add a script like this one in your
path:

    nmgui

    #!/bin/sh
    nm-applet    > /dev/null 2>/dev/null &
    stalonetray  > /dev/null 2>/dev/null
    killall nm-applet

When you close the stalonetray window, it closes nm-applet too, so no
extra memory is used once you are done with network settings.

> Command line

The networkmanager package contains nmcli since version 0.8.1.

nmcli examples

To connect to a wifi network:

    nmcli dev wifi connect <name> password <password>

To connect to a wifi on the wlan1 wifi interface:

    nmcli dev wifi connect <name> password <password> iface wlan1 [profile name]

To disconnect an interface:

    nmcli dev disconnect iface eth0

To reconnect an interface marked as disconnected

    nmcli con up uuid <uuid>

To get a list of UUIDs

    nmcli con list

To see a list of network devices and their state

    nmcli dev

Configuration
-------------

NetworkManager will require some additional steps to be able run
properly.

Verify that your /etc/hosts is correct before continuing. If you
previously tried to connect before doing this step, NetworkManager may
have altered it. An example hostname line in /etc/hosts:

    /etc/hosts

    127.0.0.1 localhost
    ::1       localhost

In case you have nss-myhostname turned off, the line would look like:

    /etc/hosts

    127.0.0.1 my-laptop localhost
    ::1       my-laptop localhost

> Enable NetworkManager

NetworkManager is controlled via NetworkManager.service. Once the
NetworkManager daemon is started, it will automatically connect to any
available "system connections" that have already been configured. Any
"user connections" or unconfigured connections will need nmcli or an
applet to configure and connect.

Note:NetworkManager will print probably meaningless warnings (FS#34971)
to your system log, when NetworkManager-dispatcher.service and
ModemManager.service are not enabled. To keep the log clean and suppress
this messages, enable both, even if they are not required by your
environment.

> Enable NetworkManager Wait Online

If you have services which fail if they are started before the network
is up, you have to use NetworkManager-wait-online.service in addition to
NetworkManager.service. This is however hardly ever necessary since most
network daemons start up fine, even if the network has not been
configured yet.

In some cases the service will still fail to start sucessfully on boot
due to the timeout setting in
/usr/lib/systemd/system/NetworkManager-wait-online.service being too
short. Change the default timeout from 30 to a higher value.

> Set up PolicyKit permissions

See General Troubleshooting#Session permissions for setting up a working
session.

With a working session, you have several options for granting the
necessary privileges to NetworkManager:

Option 1. Run a PolicyKit authentication agent when you log in, such as
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 (part of
polkit-gnome). You will be prompted for your password whenever you add
or remove a network connection.

Option 2. Add yourself to the wheel group. You will not have to enter
your password, but your user account may be granted other permissions as
well, such as the ability to use sudo without entering the root
password.

Option 3. Add yourself to the network group and create the following
file:

    /etc/polkit-1/rules.d/50-org.freedesktop.NetworkManager.rules

    polkit.addRule(function(action, subject) {
      if (action.id.indexOf("org.freedesktop.NetworkManager.") == 0 && subject.isInGroup("network")) {
        return polkit.Result.YES;
      }
    });

All users in the network group will be able to add and remove networks
without a password. This will not work under systemd if you do not have
an active session with systemd-logind.

> Network services with NetworkManager dispatcher

There are quite a few network services that you will not want running
until NetworkManager brings up an interface. Good examples are NTPd and
network filesystem mounts of various types (e.g. netfs). NetworkManager
has the ability to start these services when you connect to a network
and stop them when you disconnect. To activate the feature you need to
start the NetworkManager-dispatcher.service.

Once the feature is active, scripts can be added to the
/etc/NetworkManager/dispatcher.d directory. These scripts will need to
have executable, user permissions. For security, it is good practice to
make them owned by root:root and writable only by the owner.

The scripts will be run in alphabetical order at connection time, and in
reverse alphabetical order at disconnect time. They receive two
arguments: the name of the interface (e.g. eth0) and the status (up or
down for interfaces and vpn-up or vpn-down for vpn connections). To
ensure what order they come up in, it is common to use numerical
characters prior to the name of the script (e.g. 10_portmap or 30_netfs
(which ensures that the portmapper is up before NFS mounts are
attempted).

> Warning:

-   For security reason. You should disable write access for group and
    other. For example use 755 mask. In other case it can refuse to
    execute script, with error message "nm-dispatcher.action: Script
    could not be executed: writable by group or other, or set-UID." in
    /var/log/messages.log.
-   If you connect to foreign or public networks, be aware of what
    services you are starting and what servers you expect to be
    available for them to connect to. You could make a security hole by
    starting the wrong services while connected to a public network.

Avoiding the three seconds timeout

If the above is working, then this section is not relevant. However,
there is a general problem related to running dispatcher scripts which
take longer than 3 seconds to be executed. NetworkManager uses an
internal timeout of 3 seconds (see the Bugtracker for more information)
and automatically kills scripts that take longer than 3 seconds to
finish. In this case, the dispatcher service file, located in
/usr/lib/systemd/system/NetworkManager-dispatcher.service, has to be
modified to remain active after exit. Create the service file
/etc/systemd/system/NetworkManager-dispatcher.service with the following
content:

    .include /usr/lib/systemd/system/NetworkManager-dispatcher.service
    [Service]
    RemainAfterExit=yes

Now enable the modified NetworkManager-dispatcher script.

Start OpenNTPD

Install the networkmanager-dispatcher-openntpd package.

Mount remote folder with sshfs

As the script is run in a very restrictive environment, you have to
export SSH_AUTH_SOCK in order to connect to your SSH agent. There are
different ways to accomplish this, see this link for more information.
The example below works with gnome-keyring, and will ask you for the
password if not unlocked already. In case NetworkManager connects
automatically on login, it is likely gnome-keyring has not yet started
and the export will fail (hence the sleep). The UUID to match can be
found with the command nmcli con status or nmcli con list.

    #!/bin/sh
    USER='username'
    REMOTE='user@host:/remote/path'
    LOCAL='/local/path'

    interface=$1 status=$2
    if [ "$CONNECTION_UUID" = "uuid" ]; then
      case $status in
        up)
          export SSH_AUTH_SOCK=$(find /tmp -maxdepth 1 -type s -user "$USER" -name 'ssh')
          su "$USER" -c "sshfs $REMOTE $LOCAL"
          ;;
        down)
          fusermount -u "$LOCAL"
          ;;
      esac
    fi

Use dispatcher to connect to a VPN after a network-connection is established

In this example we want to connect automatically to a previously defined
VPN connection after connecting to a specific Wi-Fi network. First thing
to do is to create the dispatcher script that defines what to do after
we are connected to the network.

1. Create the dispatcher script:

    /etc/NetworkManager/dispatcher.d/vpn-up

    #!/bin/sh
    VPN_NAME="name of VPN connection defined in NetworkManager"
    ESSID="wifi network ESSID (not connection name)"

    interface=$1 status=$2
    case $status in
      up|vpn-down)
        if iwgetid | grep -qs ":\"$ESSID\""; then
          nmcli con up id "$VPN_NAME"
        fi
        ;;
      down)
        if iwgetid | grep -qs ":\"$ESSID\""; then
          if nmcli con status id "$VPN_NAME" | grep -qs activated; then
            nmcli con down id "$VPN_NAME"
          fi
        fi
        ;;
    esac

Remember to make it executable with chmod +x and to make the VPN
connection available to all users.

Trying to connect using this setup will fail and NetworkManager will
complain about 'no valid VPN secrets', because of the way VPN secrets
are stored which brings us to step 2:

2. Edit your VPN connection configuration file to make NetworkManager
store the secrets by itself rather than inside a keyring that will be
inaccessible for root: open up
/etc/NetworkManager/system-connections/name of your VPN connection and
change the password-flags and secret-flags from 1 to 0.

Alternatively put the password directly in the configuration file adding
the section vpn-secrets:

     [vpn]
     ....
     password-flags=0
     
     [vpn-secrets]
     password=your_password

Note:It may now be necessary to re-open the NetworkManager connection
editor and re-enter the VPN passwords/secrets.

> Proxy settings

NetworkManager does not directly handle proxy settings, but if you are
using GNOME, you could use proxydriver wich handles proxy settings using
NetworkManager's informations. You can find the package for proxydriver
in the AUR.

In order for proxydriver to be able to change the proxy settings, you
would need to execute this command, as part of the GNOME startup process
(System -> Preferences -> Startup Applications):

    xhost +si:localuser:your_username

See: Proxy settings

> Disable NetworkManager

It might not be obvious, but the service automatically starts through
dbus, to completely disable it you can mask the service with systemctl :

    systemctl mask NetworkManager
    systemctl mask NetworkManager-dispatcher

Testing
-------

NetworkManager applets are designed to load upon login so no further
configuration should be necessary for most users. If you have already
disabled your previous network settings and disconnected from your
network, you can now test if NetworkManager will work. The first step is
to start the networkmanager daemon.

Some applets will provide you with a .desktop file so that the
NetworkManager applet can be loaded through the application menu. If it
does not, you are going to either have to discover the command to use or
logout and login again to start the applet. Once the applet is started,
it will likely begin polling network connections with for
auto-configuration with a DHCP server.

To start the GNOME applet in non-xdg-compliant window managers like
Awesome:

    nm-applet --sm-disable &

For static IPs you will have to configure NetworkManager to understand
them. The process usually involves right-clicking the applet and
selecting something like 'Edit Connections'.

Troubleshooting
---------------

Some fixes to common problems.

> Using nm-applet, wifi networks don't prompt for password and just disconnect

This happens when no keyring package is installed. An easy solution is
to install gnome-keyring.

> No traffic via PPTP tunnel

PPTP connection logins successfully, you see ppp0 interface with correct
VPN IP, but you cannot even ping remote IP. It is due to lack of MPPE
(Microsoft Point-to-Point Encryption) support in stock Arch pppd. It is
recommended to first try with the stock Arch ppp as it may work as
intended.

To solve the problem it should be sufficient to install ppp-mppe from
the AUR.

WPA2-Enterprise wireless networks demanding MSCHAPv2 type-2
authentication with PEAP sometimes require ppp-mppe rather than the
stock ppp package. netctl seems to work out of the box without ppp-mppe,
however. In either case, usage of MSCHAPv2 is discouraged as it is
highly vulnerable, although using another method is usually not an
option. See this blog post.

> Network management disabled

Sometimes when NetworkManager shuts down but the pid (state) file does
not get removed and you will get a 'Network management disabled'
message. If this happens, you'll have to remove it manually:

    # rm /var/lib/NetworkManager/NetworkManager.state

If this happens upon reboot, you can add an action to your /etc/rc.local
to have it removed upon bootup:

    nmpid=/var/lib/NetworkManager/NetworkManager.state
    [ -f $nmpid ] && rm $nmpid

> Customizing resolv.conf

See the main page: resolv.conf. Also make sure that NetworkManager uses
dhcpcd and not dhclient. If you want to use dhclient, you may try the
networkmanager-dispatch-resolv package from the AUR.

> DHCP problems with dhclient

If you have problems with getting an IP via DHCP, try to add the
following to your /etc/dhclient.conf:

     interface "eth0" {
       send dhcp-client-identifier 01:aa:bb:cc:dd:ee:ff;
     }

Where aa:bb:cc:dd:ee:ff is the MAC address of this NIC. The MAC address
can be found using the ip link show eth0 command from the iproute2
package.

> Hostname problems

It depends on the NetworkManager plugins used, whether the hostname is
forwarded to a router on connect. The generic "keyfile" plugin does not
forward the hostname in default configuration. To make it forward the
hostname, add the following to

    /etc/NetworkManager/NetworkManager.conf

    [keyfile]
    hostname=your_hostname

The options under [keyfile] will be applied to network connections in
the default /etc/NetworkManager/system-connections path.

Another option is to configure the DHCP client, which NetworkManager
starts automatically, to forward it. NetworkManager utilizes dhclient in
default and falls back to dhcpcd, if the former is not installed. To
make dhclient forward the hostname requires to set a non-default option,
dhcpcd forwards the hostname by default.

First, check which DHCP client is used (dhclient in this example):

    # journalctl -b | egrep "dhclient|dhcpcd"

    ...
    Nov 17 21:03:20 zenbook dhclient[2949]: Nov 17 21:03:20 zenbook dhclient[2949]: Bound to *:546
    Nov 17 21:03:20 zenbook dhclient[2949]: Listening on Socket/wlan0
    Nov 17 21:03:20 zenbook dhclient[2949]: Sending on   Socket/wlan0
    Nov 17 21:03:20 zenbook dhclient[2949]: XMT: Info-Request on wlan0, interval 1020ms.
    Nov 17 21:03:20 zenbook dhclient[2949]: RCV: Reply message on wlan0 from fe80::126f:3fff:fe0c:2dc.

Option 2: Configure dhclient to push the hostname to the DHCP server

Copy the example configuration file:

    # cp /usr/share/dhclient/dhclient.conf.example /etc/dhclient.conf

Take a look at the file - there will only really be one line we want to
keep and dhclient will use it's defaults (as it has been using if you
didn't have this file) for the other options. This is the important
line:

    /etc/dhclient.conf

    send host-name = pick-first-value(gethostname(), "ISC-dhclient");

Force an IP address renewal by your favorite means, and you should now
see your hostname on your DHCP server.

Option 3: Configure NetworkManager to use dhcpcd

Install dhcpcd and tell NetworkManager about it:

    /etc/NetworkManager/NetworkManager.conf

    dhcp=dhcpcd

Then restart NetworkManager.service.

> Missing default route

On at least one KDE4 system, no default route was created when
establishing wireless connections with NetworkManager. Changing the
route settings of the wireless connection to remove the default
selection "Use only for resources on this connection" solved the issue.

> 3G modem not detected

See USB_3G_Modem#Network_Manager.

> Switching off WLAN on laptops

Sometimes NetworkManager will not work when you disable your Wi-Fi
adapter with a switch on your laptop and try to enable it again
afterwards. This is often a problem with rfkill. Install rfkill from the
official repositories and use

    $ watch -n1 rfkill list all

to check if the driver notifies rfkill about the wireless adapter's
status. If one identifier stays blocked after you switch on the adapter
you could try to manually unblock it with (where X is the number of the
identifier provided by the above output):

    # rfkill event unblock X

> Static IP settings revert to DHCP

Due to an unresolved bug, when changing default connections to static
IP, nm-applet may not properly store the configuration change, and will
revert to automatic DHCP.

To work around this issue you have to edit the default connection (e.g.
"Auto eth0") in nm-applet, change the connection name (e.g. "my eth0"),
uncheck the "Available to all users" checkbox, change your static IP
settings as desired, and click Apply. This will save a new connection
with the given name.

Next, you will want to make the default connection not connect
automatically. To do so, run nm-connection-editor (not as root). In the
connection editor, edit the default connection (eg "Auto eth0") and
uncheck "Connect automatically". Click Apply and close the connection
editor.

> Cannot edit connections as normal user

See #Set_up_PolicyKit_permissions.

> Forget hidden wireless network

Since hidden network are not displayed in the selection list of the
Wireless view, they cannot be forgotten (removed) with the GUI. You can
delete one with the following command:

    # rm /etc/NetworkManager/system-connections/[SSID]

This works for any other connection.

> VPN not working in Gnome

When setting up openconnect or vpnc connections in NetworkManager while
using Gnome, you'll sometimes never see the dialog box pop up and the
following error appears in /var/log/errors.log:

    localhost NetworkManager[399]: <error> [1361719690.10506] [nm-vpn-connection.c:1405] get_secrets_cb(): Failed to request VPN secrets #3: (6) No agents were available for this request.

This is caused by the Gnome NM Applet expecting dialog scripts to be at
/usr/lib/gnome-shell, when NetworkManager's packages put them in
/usr/lib/networkmanager. As a "temporary" fix (this bug has been around
for a while now), make the following symlink(s):

    # For OpenConnect
    ln -s /usr/lib/networkmanager/nm-openconnect-auth-dialog /usr/lib/gnome-shell/ 

    # For VPNC (i.e. Cisco VPN)
    ln -s /usr/lib/networkmanager/nm-vpnc-auth-dialog /usr/lib/gnome-shell/

This may need to be done for any other NM VPN plugins as well, but these
are the two most common.

> Unable to connect to visible european wireless networks

Wlan chips are shipped with a default regulatory domain. If your
AccessPoint doesn't operate within these limitations, you will not be
able to connect to the network. Fixing this is easy:

-   Install crda with pacman, see
    Wireless_network_configuration#Regulatory_domain
-   Uncomment the correct Country Code in '/etc/conf.d/wireless-regdom'
-   reboot the system, because the setting is only read on boot.

  

> Automatically connect to VPN not working on boot

The problem seems to be with the keyring as mentioned in the dispatcher
section. You don't need to use the dispatcher to auto-connect. The
solution is to keep the password to your VPN in plaintext.

Edit /etc/NetworkManager/system-connections/VPN_NAME:

     [vpn]
     ....
     password-flags=0
     
     [vpn-secrets]
     password=your_password

  

> NetworkManager dispatcher does not run using systemd

Check your log with the command journalctl -b -u NetworkManager, search
for the following line:

     <warn> Dispatcher failed: (32) Unit dbus-org.freedesktop.nm-dispatcher.service failed to load: No such file or directory.

if this line present, enable the dbus unit by running:

     systemctl enable NetworkManager-dispatcher.service

Tips and tricks
---------------

> Sharing internet connection over Wi-Fi

You can share your internet connection (e.g.: 3G or wired) with a few
clicks using nm. You will need a supported Wi-Fi card (Cards based on
Atheros AR9xx or at least AR5xx are probably best choice)

Ad-hoc

-   Install the dnsmasq package to be able to actually share the
    connection.
-   Custom dnsmasq.conf may interfere with nm (not sure about this, but
    i think so).
-   Click on nm-applet -> Create new wireless network.
-   Follow wizard (if using WEP be sure to use 5 or 13 character long
    password, different lengths will fail).
-   Settings will remain stored for the next time you need it.

Real AP

Support of infrastructure mode (which is needed by Android phones as
they intentionally do not support ad-hoc) is supported by NetworkManager
as of late 2012.

See: http://fedoraproject.org/wiki/Features/RealHotspot

> Checking if networking is up inside a cron job or script

Some cron jobs require networking to be up to succeed. You may wish to
avoid running these jobs when the network is down. To accomplish this,
add an if test for networking that queries NetworkManager's nm-tool and
checks the state of networking. The test shown here succeeds if any
interface is up, and fails if they are all down. This is convenient for
laptops that might be hardwired, might be on wireless, or might be off
the network.

    if [ $(nm-tool|grep State|cut -f2 -d' ') == "connected" ]; then
        #Whatever you want to do if the network is online
    else
        #Whatever you want to do if the network is offline - note, this and the else above are optional
    fi

This useful for a cron.hourly script that runs fpupdate for the F-Prot
virus scanner signature update, as an example. Another way it might be
useful, with a little modification, is to differentiate between networks
using various parts of the output from nm-tool; for example, since the
active wireless network is denoted with an asterisk, you could grep for
the network name and then grep for a literal asterisk.

> Automatically unlock keyring after login

GNOME

1.  Right click on the nm-applet icon in your panel and select Edit
    Connections and open the Wireless tab
2.  Select the connection you want to work with and click the Edit
    button
3.  Check the boxes “Connect Automatically” and “Available to all users”

Log out and log back in to complete.

Note:The following method is dated and known not to work on at least one
machine!

-   In /etc/pam.d/gdm (or your corresponding daemon in /etc/pam.d), add
    these lines at the end of the "auth" and "session" blocks if they do
    not exist already:

     auth            optional        pam_gnome_keyring.so
     session         optional        pam_gnome_keyring.so  auto_start

-   In /etc/pam.d/passwd, use this line for the 'password' block:

     password    optional    pam_gnome_keyring.so

Next time you log in, you should be asked if you want the password to be
unlocked automatically on login.

KDE

Note:See http://live.gnome.org/GnomeKeyring/Pam for reference, and if
you are using KDE with KDM, you can use pam-keyring-tool from the AUR.

Put a script like the following in ~/.kde4/Autostart:

     #!/bin/sh
     echo PASSWORD | /usr/bin/pam-keyring-tool --unlock --keyring=default -s

Similar should work with Openbox, LXDE, etc.

SLiM login manager

See Slim#SLiM and Gnome Keyring.

> KDE and OpenConnect VPN with password authentication

kdeplasma-applets-plasma-nm does not support to configure username and
password for OpenConnect VPN connections in its GUI. You have to type
both values everytime you connect. kdeplasma-applets-plasma-nm 0.9.3.2-1
and above is however capable of retrieving OpenConnect username and
password directly from KWallet.

Open "KDE Wallet Manager" and look up your OpenConnect VPN connection
under "Network Management|Maps". Click "Show values" and enter your
credentials in key "VpnSecrets" in this form (replace THE_USERNAME and
THE_PASSWORD with your actual values):

    form:main:username%SEP%THE_USERNAME%SEP%form:main:password%SEP%THE_PASSWORD

Next time you connect, username and password should appear in the "VPN
secrets" dialog box.

> Ignore specific devices

Sometimes it may be desired that NetworkManager ignores specific devices
and does not try to configure addresses and routes for them.You can
quickly and easily ignore devices by MAC by using the following in
/etc/NetworkManager/NetworkManager.conf :

    [keyfile]
    unmanaged-devices=mac:00:22:68:1c:59:b1;mac:00:1E:65:30:D1:C4

After you have put this in, restart NetworkManager, and you should be
able to configure interfaces without NetworkManager altering what you
have set.

> Connect faster

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with             
                           Network_Configuration#Ad 
                           ditional_settings.       
                           Notes: This section      
                           contains mostly          
                           generally applicable     
                           tips. (Discuss)          
  ------------------------ ------------------------ ------------------------

Disabling IPv6

Slow connection or reconnection to the network may be due to superfluous
IPv6 queries in NetworkManager. If there is no IPv6 support on the local
network, connecting to a network may take longer than normal while
NetworkManager tries to establish an IPv6 connection that eventually
times out. The solution is to disable IPv6 within NetworkManager which
will make network connection faster. This has to be done once for every
network you connect to.

-   Right-click on the network status icon.
-   Click on "Edit Connections".
-   Go to the "Wired" or "Wireless" tab, as appropriate.
-   Select the name of the network.
-   Click on "Edit".
-   Go to the "IPv6 Settings" tab.
-   In the "Method" dropdown, choose "Ignore/Disabled".
-   Click on "Save".

Use OpenDNS servers

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: Very hacky        
                           solution, what's wrong   
                           with                     
                           #Customizing_resolv.conf 
                           ?                        
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Create /etc/resolv.conf.opendns with the alternative DNS server
addresses.

And have the dispatcher replace the discovered DHCP servers with the
OpenDNS ones:

    /etc/NetworkManager/dispatcher.d/dns-servers-opendns

    #!/bin/bash
    # Use OpenDNS servers over DHCP discovered servers

    cp -f /etc/resolv.conf.opendns /etc/resolv.conf

Make the script executable:

    # chmod +x /etc/NetworkManager/dispatcher.d/dns-servers-opendns

> Enable DNS Caching

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with             
                           dnsmasq#NetworkManager.  
                           Notes: should be covered 
                           only in one place        
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

DNS requests can be sped up by caching previous requests locally for
subsequent lookup. NetworkManager has a plugin to enable DNS caching
using dnsmasq, but it is not enabled in the default configuration. It
is, however, easy to enable using the following instructions.

Start by installing dnsmasq. Then, edit
/etc/NetworkManager/NetworkManager.conf and add the following line under
the [main] section:

    dns=dnsmasq

Now restart NetworkManager or reboot. NetworkManager will automatically
start dnsmasq and add 127.0.0.1 to /etc/resolv.conf. The actual DNS
servers can be found in /var/run/NetworkManager/dnsmasq.conf. You can
verify dnsmasq is being used by doing the same DNS lookup twice with dig
and verifying the server and query times.

Retrieved from
"https://wiki.archlinux.org/index.php?title=NetworkManager&oldid=305926"

Category:

-   Networking

-   This page was last modified on 20 March 2014, at 17:28.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
