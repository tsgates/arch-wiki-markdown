NetworkManager
==============

Summary

Covers installation and configuration of NetworkManager – a set of
co-operative tools that make networking simple and straightforward.

Overview

Arch Linux provides netcfg for network management. netcfg supports wired
connections on desktops and servers, as well as wireless setups and
roaming for mobile users, facilitating easy management of network
profiles. NetworkManager and Wicd are popular third-party alternatives.

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

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Base install                                                       |
|     -   1.1 VPN support                                                  |
|                                                                          |
| -   2 Graphical front-ends                                               |
|     -   2.1 GNOME                                                        |
|     -   2.2 KDE                                                          |
|     -   2.3 XFCE                                                         |
|     -   2.4 Openbox                                                      |
|     -   2.5 Other desktops and window managers                           |
|     -   2.6 Command line                                                 |
|                                                                          |
| -   3 Configuration                                                      |
|     -   3.1 Disable current network setup                                |
|     -   3.2 Enable NetworkManager                                        |
|     -   3.3 Enable NetworkManager Wait Online                            |
|     -   3.4 Set up PolicyKit permissions                                 |
|     -   3.5 Network services with NetworkManager dispatcher              |
|         -   3.5.1 Start OpenNTPD                                         |
|         -   3.5.2 Mount remote folder with sshfs                         |
|         -   3.5.3 Use dispatcher to connect to a VPN after a             |
|             network-connection is established                            |
|                                                                          |
|     -   3.6 Proxy settings                                               |
|                                                                          |
| -   4 Testing                                                            |
| -   5 Troubleshooting                                                    |
|     -   5.1 No traffic via PPTP tunnel                                   |
|     -   5.2 Network management disabled                                  |
|     -   5.3 NetworkManager prevents DHCPCD from using resolv.conf.head   |
|         and resolv.conf.tail                                             |
|     -   5.4 Preserving changes to resolv.conf                            |
|     -   5.5 DHCP problems                                                |
|     -   5.6 Hostname problems                                            |
|     -   5.7 Missing default route                                        |
|     -   5.8 3G modem not detected                                        |
|     -   5.9 Switching off WLAN on laptops                                |
|     -   5.10 Static IP settings revert to DHCP                           |
|     -   5.11 Cannot edit connections as normal user                      |
|     -   5.12 Forget hidden wireless network                              |
|     -   5.13 VPN not working in Gnome                                    |
|                                                                          |
| -   6 Tips and tricks                                                    |
|     -   6.1 Sharing internet connection over wifi                        |
|         -   6.1.1 Ad-hoc                                                 |
|         -   6.1.2 Real AP                                                |
|                                                                          |
|     -   6.2 Checking if networking is up inside a cron job or script     |
|     -   6.3 Automatically unlock keyring after login                     |
|         -   6.3.1 GNOME                                                  |
|         -   6.3.2 KDE                                                    |
|         -   6.3.3 SLiM login manager                                     |
|                                                                          |
|     -   6.4 Ignore specific devices                                      |
|     -   6.5 Connect faster                                               |
|         -   6.5.1 Disabling IPv6                                         |
|         -   6.5.2 Speed up DHCP by disabling ARP probing in DHCPCD       |
|         -   6.5.3 Use OpenDNS servers                                    |
+--------------------------------------------------------------------------+

Base install
------------

NetworkManager can be installed with the package networkmanager,
available in the official repositories.

> VPN support

Network Manager VPN support is based on a plug-in system. If you need
VPN support via network manager you have to install one of the following
packages from the official repositories:

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

The KNetworkManager front-end is a Plasma widget available in the
official repositories as package kdeplasma-applets-networkmanagement.

Note:If you are changing from another network managing tool like Wicd,
do not forget to set the default 'Network Management Backend' in System
Settings -> Hardware -> Information Sources

If you have both the Plasma widget and nm-applet installed and do not
want to start nm-applet when using KDE, add the following line to
/etc/xdg/autostart/nm-applet.desktop:

    NotShowIn=KDE

See Userbase page for more info.

> XFCE

network-manager-applet will work fine in XFCE, but in order to see
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

> Openbox

To function properly in Openbox, the GNOME applet requires the
xfce4-notifyd notification daemon for the same reason as in XFCE and the
gnome-icon-theme package to be able to display the applet in the
systray.

If you want to store authentication details (Wireless/DSL) install and
configure gnome-keyring.

Note:If the networkmanager daemon is in rc.conf, the following settings
are obsolete or the applet will be started twice.

To have Openbox's autostart start nm-applet properly, you may need to
delete the file /etc/xdg/autostart/nm-applet.desktop (You may need to
delete this file again after every update to network-manager-applet).

Then in autostart, start nm-applet with this line:

    (sleep 3 && /usr/bin/nm-applet --sm-disable) &

If you experience errors connecting, make sure you have your D-Bus user
session started.

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

> Disable current network setup

You will want to disable your current network setup to be able to
properly test NetworkManager

First, stop the network daemon:

    # systemctl stop net-auto-wireless.service

Then, disable currently running network daemons.

    # systemctl disable net-auto-wireless.service

If you are running netctl, instead use:

    # systemctl stop netctl-auto@<interface>.service
    # systemctl disable netctl-auto@<interface>.service

Finally, bring down your NIC's (Network Interface Controllers, i.e.
network cards). For example (using the iproute2 package):

    # ip link set eth0 down
    # ip link set wlan0 down

Note: you must bring your NIC's back up before you continue if you
brought them down as shown above.

> Enable NetworkManager

Once the NetworkManager daemon is started, it will automatically connect
to any available "system connections" that have already been configured.
Any "user connections" or unconfigured connections will need nmcli or an
applet to configure and connect.

You can enable NetworkManager at startup with the following command:

    # systemctl enable NetworkManager

You can start the NetworkManager daemon immediately with the following
command:

    # systemctl start NetworkManager

> Enable NetworkManager Wait Online

If you have services which fail if they are started before the network
is up, you have to use NetworkManager-wait-online.service in addition to
the NetworkManager service. This is however hardly ever necessary since
most network daemons start up fine, even if the network has not been
configured yet.

You can enable NetworkManager Wait Online at startup with the following
command:

    # systemctl enable NetworkManager-wait-online

In some cases the service will still fail to start sucessfully on boot:

     NetworkManager-wait-online.service: main process exited, code=exited, status=1/FAILURE
     Failed to start Network Manager Wait Online
     Unit NetworkManger-wait-online.service entered failed state
     Starting Network.
     Reached target Network.

This is due to the timeout setting in
/usr/lib/systemd/system/NetworkManager-wait-online.service being to
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
until NetworkManager brings up an interface. Good examples are OpenNTPD
and network filesystem mounts of various types (e.g. netfs).
NetworkManager has the ability to start these services when you connect
to a network and stop them when you disconnect.

To use this feature, scripts can be added to the
/etc/NetworkManager/dispatcher.d directory. These scripts will need to
have executable, user permissions. For security, it is good practice to
make them owned by root:root and writable only by the owner.

The scripts will be run in alphabetical order at connection time, and in
reverse alphabetical order at disconnect time. They receive two
arguments: the name of the interface (e.g. eth0) and the status (up or
down). To ensure what order they come up in, it is common to use
numerical characters prior to the name of the script (e.g. 10_portmap or
30_netfs (which ensures that the portmapper is up before NFS mounts are
attempted).

Warning:For security reason. You should disable write access for group
and other. For example use 755 mask. In other case it can refuse to
execute script, with error message "nm-dispatcher.action: Script could
not be executed: writable by group or other, or set-UID." in
/var/log/messages.log

Warning:if you connect to foreign or public networks, be aware of what
services you are starting and what servers you expect to be available
for them to connect to. You could make a security hole by starting the
wrong services while connected to a public network.

Start OpenNTPD

The following example starts the OpenNTPD daemon when an interface is
brought up. Save the file as
/etc/NetworkManager/dispatcher.d/20_openntpd and make it executable.

    #!/bin/sh
    interface=$1 status=$2
    case $status in
      up)
        systemctl start openntpd
        ;;
      down)
        if ! nm-tool | awk '/State:/{print $2}' | grep -qs connected; then
          systemctl stop openntpd
        fi
        ;;
    esac

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
    if [ "$CONNECTION_UUID" = "<uuid>" ]; then
      case $status in
        up)
          export SSH_AUTH_SOCK=$(find /tmp -maxdepth 1 -type s -user "$USER" -name 'ssh')
          su "$USER" -c "sshfs $LOCAL $REMOTE"
          ;;
        down)
          fusermount -u "$LOCAL"
          ;;
      esac
    fi

Use dispatcher to connect to a VPN after a network-connection is established

In this example we want to connect automatically to a previously defined
VPN connection after connecting to a specific WiFi network. First thing
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
/etc/NetworkManager/system-connections/<name of your VPN connection> and
change the password-flags and secret-flags form 1 to 0.

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

> No traffic via PPTP tunnel

PPTP connection logins successfully, you see ppp0 interface with correct
VPN IP, but you cannot even ping remote IP. It is due to lack of MPPE
(Microsoft Point-to-Point Encryption) support in stock Arch pppd. It is
recommended to first try with the stock Arch ppp as it may work as
intended.

To solve the problem it should be sufficient to install ppp-mppe from
the AUR.

> Network management disabled

Sometimes when NetworkManager shuts down but the pid (state) file does
not get removed and you will get a 'Network management disabled'
message. If this happens, you'll have to remove it manually:

    # rm /var/lib/NetworkManager/NetworkManager.state

If this happens upon reboot, you can add an action to your /etc/rc.local
to have it removed upon bootup:

    nmpid=/var/lib/NetworkManager/NetworkManager.state
    [ -f $nmpid ] && rm $nmpid

> NetworkManager prevents DHCPCD from using resolv.conf.head and resolv.conf.tail

Sometimes it is problematic to add static items to resolv.conf when it
is constantly rewritten by NetworkManager and dhcpcd. A simple solution
is using the following script:

    #!/bin/bash
    # 
    # /etc/NetworkManager/dispatcher.d/99-resolv.conf-head_and_tail
    # Include /etc/resolv.conf.head and /etc/resolv.conf.tail to /etc/resolv.conf
    #
    # scripts in the /etc/NetworkManager/dispatcher.d/ directory
    # are called alphabetically and are passed two parameters:
    # $1 is the interface name, and $2 is “up” or “down” as the
    # case may be.

    resolvconf='/etc/resolv.conf';
    cat "$resolvconf"{.head,,.tail} 2>/dev/null > "$resolvconf".tmp
    mv -f "$resolvconf".tmp "$resolvconf"

This script is also available in the AUR for convenience

> Preserving changes to resolv.conf

See Resolv.conf.

> DHCP problems

If you have problems with getting an IP via DHCP, try to add the
following to your /etc/dhclient.conf:

     interface "eth0" {
       send dhcp-client-identifier 01:aa:bb:cc:dd:ee:ff;
     }

Where aa:bb:cc:dd:ee:ff is the MAC address of this NIC. The MAC address
can be found using the ip link show eth0 command from the iproute2
package.

For some (incompliant) routers, you will not be able to connect properly
unless you comment the line

    require dhcp_server_identifier

in /etc/dhcpcd.conf (note that this file is distinct from dhcpd.conf).
This should not cause issues unless you have multiple DHCP servers on
your network (not typical); see this page for more information.

> Hostname problems

Add the following line to /etc/NetworkManager/NetworkManager.conf:

    dhcp=dhcpcd

then restart.

    systemctl restart NetworkManager

source https://bbs.archlinux.org/viewtopic.php?id=152376

> Missing default route

On at least one KDE4 system, no default route was created when
establishing wireless connections with NetworkManager. Changing the
route settings of the wireless connection to remove the default
selection "Use only for resources on this connection" solved the issue.

> 3G modem not detected

If NetworkManager (from v0.7.999) does not detect your 3G modem, but you
still can connect using wvdial, try installing modemmanager and restart
NetworkManager daemon with systemctl restart NetworkManager. It may also
be necessary to replug or restart your modem. This utility provides
support for hardware not in NetworkManager's default database.

> Switching off WLAN on laptops

Sometimes NetworkManager will not work when you disable your WiFi
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

Tips and tricks
---------------

> Sharing internet connection over wifi

You can share your internet connection (eg.: 3G or wired) by few clicks
using nm. You will need supported wifi card (Cards based on Atheros
AR9xx or at least AR5xx are probably best choice)

Ad-hoc

-   pacman -S dnsmasq
-   custom dnsmasq.conf may interfere with nm (not sure about this, but
    i think so)
-   Click on nm-applet -> Create new wireless network
-   Follow wizard (if using WEP be sure to use 5 or 13 charactes long
    password, different lengths will fail)
-   Settings will remain stored for next time you'll need it

Real AP

Support of infrastructure mode (which is needed by Andoid phones as they
don't intentionally support ad-hoc) is not currently supported by
NetworkManager, but is in active development...

See: http://fedoraproject.org/wiki/Features/RealHotspot

> Checking if networking is up inside a cron job or script

Some cron jobs require networking to be up to succeed. You may wish to
avoid running these jobs when the network is down. To accomplish this,
add an if test for networking that queries NetworkManager's nm-tool and
checks the state of networking. The test shown here succeeds if any
interface is up, and fails if they are all down. This is convenient for
laptops that might be hardwired, might be on wireless, or might be off
the network.

    if [ `nm-tool|grep State|cut -f2 -d' '` == "connected" ]; then
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

Speed up DHCP by disabling ARP probing in DHCPCD

dhcpcd contains an implementation of a recommendation of the DHCP
standard (RFC2131 section 2.2) to check via ARP if the assigned IP
address is really not taken. This seems mostly useless in home networks,
so you can save about 5 seconds on every connect by adding the following
line to /etc/dhcpcd.conf:

    noarp

This is equivalent to passing --noarp to dhcpcd, and disables the
described ARP probing, speeding up connections to networks with DHCP.

Use OpenDNS servers

Create /etc/resolv.conf.opendns with the nameservers:

    nameserver 208.67.222.222
    nameserver 208.67.220.220

or use Google DNS servers, because people have been getting ads via the
OpenDNS servers lately

    nameserver 8.8.8.8
    nameserver 8.8.4.4

And have the dispatcher replace the discovered DHCP servers with the
OpenDNS ones:

    /etc/NetworkManager/dispatcher.d/dns-servers-opendns

    #!/bin/bash
    # Use OpenDNS servers over DHCP discovered servers

    cp -f /etc/resolv.conf.opendns /etc/resolv.conf

Make the script executable:

    # chmod +x /etc/NetworkManager/dispatcher.d/dns-servers-opendns

Retrieved from
"https://wiki.archlinux.org/index.php?title=NetworkManager&oldid=256009"

Category:

-   Networking
