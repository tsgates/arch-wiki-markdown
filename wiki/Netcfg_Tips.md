netcfg Tips
===========

Summary

Collect of tips and tricks for netcfg.

Resources

netcfg

Netcfg Troubleshooting

Note:Netcfg has been superseded by netctl

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Enabling WOL                                                       |
| -   2 Using jumbo frames                                                 |
| -   3 Clean logouts for users connected via sshd                         |
| -   4 rfkill (enable/disable radio power)                                |
| -   5 Execute commands before/after interface up/down                    |
| -   6 Intermittent Connection Failure                                    |
| -   7 Per-interface configuration                                        |
| -   8 Output hooks                                                       |
| -   9 ArchAssistant (GUI)                                                |
| -   10 Netcfg Easy Wireless LAN (newlan)                                 |
| -   11 wifi-select                                                       |
| -   12 Passing arguments to dhcpcd                                       |
|     -   12.1 Speed up DHCP with dhcpcd                                   |
|                                                                          |
| -   13 Using dhclient instead of dhcpcd                                  |
| -   14 Configuring a bridge for use with virtual machines (VMs)          |
| -   15 Adding multiple IP addresses to one interface                     |
| -   16 Adding static routes                                              |
|     -   16.1 Bluetooth tethering with pand                               |
+--------------------------------------------------------------------------+

> Enabling WOL

Enabling WOL can be accomplished using a POST_UP statement in the
profile.

    POST_UP='/usr/sbin/ethtool -s eth0 wol g'

> Using jumbo frames

Insert the following line to the network profile(s) which require a
non-standard MTU value:

    POST_UP='/usr/sbin/ip link set eth0 mtu 4000'

The above example is using a 4k jumbo frame.

> Clean logouts for users connected via sshd

Insert the following line to the network profile(s) which will kill all
connected sshd sessions upon a network restart/stop:

    PRE_DOWN='/usr/bin/pkill sshd'

> rfkill (enable/disable radio power)

netcfg can enable/disable radio for wireless cards equipped with
software control of radio. For wireless cards with hardware switches,
netcfg can detect disabled hardware switches and fail accordingly.

To enable rfkill support, you need to specify what sort of switch the
wireless interface has; hardware or software. This can be set within a
profile or at the interface level (/etc/network.d/interfaces/$INTERFACE;
see #Per-interface configuration).

    RFKILL=soft # can be either 'hard' or 'soft'

For some kill switches the rfkill entry in /sys is not linked to the
interface and the RFKILL_NAME variable needs to be set to the contents
of the matching /sys/class/rfkill/rfkill#/name.

For example, on an Eee PC:

    RFKILL=soft
    RFKILL_NAME='eeepc-wlan'

On a mid-2011 Thinkpad:

    RFKILL=hard
    RFKILL_NAME='phy0'

Note:The net-auto-wireless daemon requires an interface level
configuration of rfkill or it will not start.

Warning:Some devices (at least few SiS cards) can create
/sys/class/rfkill/rfkill# entries with different names on every switch.
Something like this will work in such cases (wifi-only solution!):

    /etc/network.d/interfaces/wlan0

    RFKILL=hard
    RFKILL_NAME=`cat /sys/class/rfkill/rfkill*/name 2> /dev/null || echo ""`

> Execute commands before/after interface up/down

If your interface requires special actions prior/after the
establishment/closure of a connection, you may use the PRE_UP, POST_UP,
PRE_DOWN, and POST_DOWN variables.

For example, if you want to configure your wireless card to operate in
ad-hoc mode but you can only change modes when the interface is down,
you could use something like this:

    PRE_UP="ip link set wlan0 down; iwconfig wlan0 mode ad-hoc"

Or if you want to mount your network shares after a successful
connection, you could use:

    POST_UP="sleep 5; mount /mnt/shares/nexus/utorrent 2>/dev/null"

Sometimes you may want to run something from netcfg with another user:

    POST_UP="su -c '/you/own/command' username"

Note:If the commands specified in these properties return anything other
than 0 (success), netcfg aborts the current operation. So if you want to
mount a certain network share that might not be available at the time of
connection (thus returning an error), you could create a separate Bash
script with the mount commands and a exit 0 at the end. Alternatively
you can add || true to the end of the command that may fail.

Note:The contents of these variables are evaluated with an eval
statement. Profile and interface variables like ESSID are available for
use, but must be escaped so that their evaluation is deferred to the
eval. The easiest way to do that is to use single quotes. For example:
PRE_UP='echo $ESSID >/tmp/essid' will evaluate correctly, regardless
where the PRE_UP command is.

> Intermittent Connection Failure

Some driver+hardware combinations drop associations sometimes. Use the
pre and post commands to add/remove the driver and use a script like the
following to fix the current connection:

    /usr/local/bin/netcfgd

    #!/bin/bash
    log() { logger -t "$( basename $0 )" "$*" ; }

    main() {
            local host
            while sleep 1; do
                    [[ "$( netcfg current )" = "" ]] && continue

                    host=$( route -n | awk '/^0.0.0.0/ { print $2 }' )
                    ping -c1 -w10 $host && continue

                    log "trying to reassociate"
                    wpa_cli reassociate
                    ping -c1 -w10 $host && continue

                    log "reassociate failed, reconfiguring network"
                    netcfg -r $( netcfg current )
            done
    }

    exec 1>/dev/null
    [[ $EUID != 0 ]] && { log "must be root"; exit 1; }

    for cmd in wpa_cli ping netcfg; do
            ! which $cmd && {
                    log "can't find command ${cmd}, exiting..."
                    exit 1
            }
    done

    log 'starting...'
    main

> Per-interface configuration

Configuration options that apply to all profiles using an interface can
be set using /etc/network.d/interfaces/$INTERFACE. For example:

    /etc/network.d/interfaces/wlan0

This is useful for wpa_supplicant options, rfkill switch support,
pre/post up/down scripts and net-auto-wireless. These options are loaded
before profiles so that any profile-based options will take priority.

/etc/network.d/interfaces/$INTERFACE may contain any valid profile
option, though you are likely to use PRE_UP/DOWN and POST_UP/DOWN
(described in the previous section) or one of the options listed below.
Remember that these options are set for all profiles using the
interface; you probably do not want to connect to your work VPN here,
for instance, as it will try to connect on every wireless network!

    WPA_GROUP   - Setting the group of the wpa_ctrl interface
    WPA_COUNTRY - Enforces local regulatory limitations and allows use of more channels
    WPA_DRIVER  - Defaults to wext, may want nl80211 for mac80211 devices

Note:POST_UP/POST_DOWN require the wpa_actiond package.

> Output hooks

netcfg has limited support to load hooks that handle output. By default
it loads the arch hook which provides the familiar output that you see.
A syslog logging hook is also included. These can be found at
/usr/lib/network/hooks.

> ArchAssistant (GUI)

A Qt-based netcfg front-end called ArchAssistant exists. It proposes to
manage and connect/disconnect profiles from a system tray icon.
Automatic wireless detection is also available. This tool is
particularly useful for laptop users.

Links:

-   archassistant in the AUR
-   archassistant on kde-apps.org

There is also a relatively new GUI for netcfg on qt-apps.org that does
only network configuration. You can find it here.

> Netcfg Easy Wireless LAN (newlan)

newlan is a mono console application that starts a user-friendly wizard
to create netcfg profiles; it also supports wired connections.

Install the newlan package from the AUR.

newlan must be run with root privileges:

    # newlan -n mynewprofile

> wifi-select

Note:Latest version of netcfg will provide wifi-menu with functionality
equal to that of wifi-select.

There is a console tool for selecting wireless networks in "real-time"
(in NetworkManager fashion) called wifi-select. The tool is convenient
for use in Internet cafés or other places you are visiting for the first
(and maybe the last) time. With this tool, you do not need to create a
profile for a new network, just run wifi-select wlan0 as root and choose
the desired network.

The tool is currently packaged as wifi-select and is available in the
official repositories.

wifi-select does the following:

-   parses iwlist scan results and presents a list of networks along
    with their security settings (WPA/WEP/none) using dialog
-   if user selects network with existing profile -- just use this
    profile to connect with netcfg
-   if user selects a new network (for example, a Wi-Fi hotspot),
    wifi-select automatically generates a new profile with corresponding
    $SECURITY and asks for the key (if needed). It uses DHCP as $IP by
    default
-   then, if the connection succeeds, the profile is saved for later
    usage
-   if the connection fails, the user is asked if he or she wants to
    keep generated profile for further usage (for example to change $IP
    to static or adjust some additional options)

Links:

-   Forum thread related to development of wifi-select
-   wifi-select on GitHub

> Passing arguments to dhcpcd

For example, add this to the desired profile:

    DHCP_OPTIONS='-C resolv.conf -G'

The above example prevents dhcpcd from writing to /etc/resolv.conf and
setting any default routes.

Speed up DHCP with dhcpcd

By default, dhcpcd confirms that the assigned IP address is not already
taken via ARP. If you are confident that it will not be, e.g. in your
home network, you can speed up the connection process by about 5 seconds
by adding --noarp to DHCP_OPTIONS:

    DHCP_OPTIONS="--noarp"

If you never want dhcpcd to perform this check for any connection, you
can globally configure this by adding the following line to
/etc/dhcpcd.conf:

    noarp

> Using dhclient instead of dhcpcd

To use dhclient instead of dhcpcd, simply add DHCLIENT=yes to the
desired profile.

> Configuring a bridge for use with virtual machines (VMs)

To configure a bridge named br0 with a static IP:

    /etc/network.d/br0

    INTERFACE="br0"
    CONNECTION="bridge"
    DESCRIPTION="bridge br0 static"
    BRIDGE_INTERFACES="eth0"
    IP='static'
    ADDR='10.0.0.10'
    GATEWAY='10.0.0.1'
    DNS='10.0.0.1'

To configure a bridge named br0 with a dhcp IP:

    /etc/network.d/br0

    INTERFACE="br0"
    CONNECTION="bridge"
    DESCRIPTION="bridge br0 dhcp"
    BRIDGE_INTERFACES="eth0"
    IP='dhcp'

Then add the corresponding bridge name to your NETWORKS=(...) in
/etc/conf.d/netcfg.

It can be brought up by calling it directly, or by restarting
net-profiles.

    netcfg br0

    rc.d restart net-profiles

> Adding multiple IP addresses to one interface

If you want to assign multiple IP addresses to 1 specific interface,
this can be done by issuing the relevant ip command in a POST_UP
statement (which as the name suggests will be executed after the
interface has been brought up). Multiple statements can be separated
with a ;. So if you for example would want to assign both 10.0.0.1 and
10.0.0.2 to interface eth0; the config would look something among the
lines of:

    /etc/network.d/multiple_ip

    INTERFACE="eth0"
    CONNECTION="ethernet"
    IP='static'
    ADDR='10.0.0.1'
    POST_UP='ip addr add 10.0.0.2/24 dev eth0'

> Adding static routes

When wanting to configure static routes, this can be done by issuing the
relevant ip command in a POSTUP statement (which as the name suggests
will be executed after the interface has been brought up). Optionally, a
PRE_DOWN statement can be added to remove said routes when the interface
is brought down. Multiple statements can be separated with a ;. In the
below example we'll route 10.0.1.0/24 over interface eth1 and then
remove the route when the interface is brought down.

    /etc/network.d/static_routes

    INTERFACE="eth1"
    CONNECTION="ethernet"
    IP='static'
    POST_UP='ip route add 10.0.1.0/24 dev eth1'
    PRE_DOWN='ip route del 10.0.1.0/24 dev eth1'

Bluetooth tethering with pand

You can create a netcfg profile for easy tethering with your Bluetooth
enabled device by using the regular "ethernet" connection and managing
the pand connection in the PRE_UP and POST_DOWN hooks. Assuming an
already paired device with address 00:00:DE:AD:BE:EF:

    /etc/network.d/tether

    CONNECTION="ethernet"
    DESCRIPTION="Ethernet via pand tethering to Bluetooth device"
    INTERFACE="bnep0"
    BTADDR="00:00:DE:AD:BE:EF"
    PRE_UP="pand -E -S -c ${BTADDR} -e ${INTERFACE} -n 2>/dev/null"
    POST_DOWN="pand -k ${BTADDR}"
    IP="dhcp"

Then, either as root or using sudo, execute:

    # netcfg tether

To bring the interface down and un-tether:

    # netcfg down tether

Retrieved from
"https://wiki.archlinux.org/index.php?title=Netcfg_Tips&oldid=255987"

Category:

-   Networking
