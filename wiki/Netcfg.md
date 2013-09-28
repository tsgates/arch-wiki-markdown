netcfg
======

Summary

A guide to configuring the network using netcfg and network profile
scripts.

Overview

Arch Linux provides netcfg for network management. netcfg supports wired
connections on desktops and servers, as well as wireless setups and
roaming for mobile users, facilitating easy management of network
profiles. NetworkManager and Wicd are popular third-party alternatives.

Resources

Netcfg Tips

Netcfg Troubleshooting

Netcfg network scripts repository

Note:Netcfg has been superseded by netctl.

Netcfg is used to configure and manage network connections via profiles.
It has pluggable support for a range of connection types, such as
wireless, Ethernet and PPP. It is also capable of starting/stopping
many-to-one connections, that is, multiple connections within the same
profile, optionally with bonding. Further it is useful for users seeking
a simple and robust means of managing multiple network configurations
(e.g. laptop users).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Preparation                                                        |
| -   2 Installation                                                       |
| -   3 Configuration                                                      |
| -   4 Manual Operation                                                   |
| -   5 Automatic Operation                                                |
|     -   5.1 Just one profile                                             |
|     -   5.2 Net-Profiles                                                 |
|     -   5.3 Net-Auto-Wireless                                            |
|     -   5.4 Net-Auto-Wired                                               |
|                                                                          |
| -   6 FAQ                                                                |
|     -   6.1 Q: Why doesn't netcfg do (some feature)?                     |
|     -   6.2 Q: Why doesn't netcfg behave in this way?                    |
|     -   6.3 Q: Do I need anything else if I'm using netcfg?              |
+--------------------------------------------------------------------------+

Preparation
-----------

In the simplest cases, users must at least know the name of their
network interface(s) (e.g. eth0, wlan0). If configuring a static IP
address, the IP addresses of the default gateway and name server(s) must
also be known.

If connecting to a wireless network, have some basic information ready.
For a wireless network this includes what type of security is used, the
network name (ESSID), and any passphrase or encryption keys.
Additionally, ensure the proper drivers and firmware are installed for
the wireless device, as described in Wireless Setup.

Installation
------------

The netcfg package is available in the official repositories. As of
netcfg version 2.5.x, optional dependencies include wpa_actiond, which
is required for automatic/roaming wireless connections, and ifplugd,
which is required for automatic Ethernet configuration. See the
announcement.

Users wanting Bash completion support for netcfg, install the
bash-completion package from the official repositories.

Configuration
-------------

Note:netcfg >= 2.8.9 drops deprecated /etc/rc.conf compatibility. Netcfg
users should configure all interfaces in /etc/conf.d/netcfg instead of
/etc/rc.conf.

Network profiles are stored in /etc/network.d/. To minimize the
potential for errors, copy an example configuration from
/etc/network.d/examples/ to /etc/network.d/mynetwork. The file name is
the name of the network profile, and mynetwork is used as an example
throughout this article.

Depending on the connection type and security, use one of the following
examples from /etc/network.d/examples/ as a base.

Warning:Be wary of examples found on the internet as they often contain
deprecated options that may cause problems!

Connection

Type

Example Profile

Information

Wired

Dynamic IP

ethernet-dhcp

Static IP

ethernet-static

Routed

ethernet-iproute

Can be checked with ip route from the iproute2 package.

Wireless

WPA-Personal

wireless-wpa

Uses a passphrase/pre-shared key.

WPA-Enterprise

wireless-wpa-config

The wpa_supplicant configuration is external.

wireless-wpa-configsection

The wpa_supplicant configuration is stored as a string.

Modify the new configuration file, /etc/network.d/mynetwork:

-   Set INTERFACE to the correct wireless or Ethernet interface. This
    can be checked with ip link and iwconfig.
-   Ensure the ESSID and KEY (passphrase) are set correctly for wireless
    connections. Typos in these fields are common errors.
    -   Note that WEP string keys (not hex keys) must be specified with
        a leading s: (e.g. KEY="s:somepasskey").

Note:If you are using netcfg inside a VPS, please see the appropriate
page.

Note:Netcfg configurations are valid Bash scripts. Any configuration
involving special characters such as $ or \ needs to be quoted correctly
otherwise it will be interpreted by Bash. To avoid interpretation, use
single quotes or backslash escape characters where appropriate.

Note:Network information (e.g. wireless passkey) will be stored in plain
text format, so users may want to change the permissions on the newly
created profile (e.g. chmod 0600 /etc/network.d/mynetwork) to make it
readable by root only.

Note:For WPA-Personal, it is also possible to encode the WPA passkey
into a hexadecimal string. Save the new hexadecimal string into the
wireless WPA profile in /etc/network.d/mynetwork as the value of the KEY
variable (make sure this will be the only KEY variable enabled), to look
similar to this:
KEY='7b271c9a7c8a6ac07d12403a1f0792d7d92b5957ff8dfd56481ced43ec6a6515'.
However, this key can also be used by anyone to get on your network, and
thus must be protected just as well as the cleartext key. The
hexadecimal encoding is more convenient if you use special characters
that are hard to express in scripts.

Note:By default netcfg uses dhcpcd for configuring network interfaces.
An alternate to dhcpcd is dhclient. To use dhclient, set DHCLIENT='yes'
in appropriate profile configuration.

Manual Operation
----------------

To connect a profile:

    # netcfg mynetwork

To disconnect a profile:

    # netcfg down mynetwork

If successful, users can configure netcfg to connect automatically or
during boot. If the connection fails, see Netcfg Troubleshooting for
solutions and for how to ask for help.

It is also possible to use an interactive menu (dialog package is
required):

    netcfg-menu

Additionally, see:

    $ netcfg help

Automatic Operation
-------------------

> Just one profile

In the simplest case, only one profile will be used and is always
desired to start on boot:

    # systemctl enable netcfg@myprofile

> Net-Profiles

Edit the NETWORKS array in /etc/conf.d/netcfg to refer to the network
config file /etc/network.d/mynetwork.

    /etc/conf.d/netcfg

    NETWORKS=(mynetwork yournetwork)

Start the service on startup:

    # systemctl enable netcfg

Alternatively, the profiles that were active at last shutdown can be
restored by setting the NETWORKS array to last.

    /etc/conf.d/netcfg

    NETWORKS=(last)

Note:For NETWORKS=(last) to work, you will have to connect to your
network manually first and then stop the daemon for Netcfg to remember
the network. You can stop the Netcfg daemon by running
netcfg-daemon stop as root.

Note:The NETWORKS=(menu) setting cannot be used anymore when switching
to systemd. See FS#31377 for details.

> Net-Auto-Wireless

This allows users to automatically connect to wireless networks with
proper roaming support. To use this feature, the wpa_actiond package is
required. Note that wireless-wpa-config profiles do not work with
net-auto-wireless. Convert them to wireless-wpa-configsection or
wireless-wpa instead.

Specify the desired wireless interface with the WIRELESS_INTERFACE
variable in /etc/conf.d/netcfg or define a list of wireless networks
that should be automatically connected with the AUTO_PROFILES variable
in /etc/conf.d/netcfg.

Note:If AUTO_PROFILES is not set, all wireless networks will be tried.

Note:By default, wpa_actiond sets dhcp timeout to 10 seconds (line 16 of
/usr/bin/netcfg-wpa_actiond-action) which may be not enough for all
users to always get an IP address successfully. To override this, for
example with classic 30 seconds timeout, write DHCP_TIMEOUT=30 to
/etc/conf.d/netcfg

Enable net-auto-wireless so systemd manages it.

    # systemctl enable net-auto-wireless

> Net-Auto-Wired

This allows users to automatically connect to wired networks. To use
this feature, the ifplugd package is required.

Specify the desired wired interface with the WIRED_INTERFACE variable in
/etc/conf.d/netcfg.

Enable net-auto-wired so systemd manages it.

    # systemctl enable net-auto-wired

The daemon starts an ifplugd process which runs
/etc/ifplugd/netcfg.action when the status of the wired interface
changes (e.g. a cable is plugged in or unplugged). On plugging in a
cable, attempts are made to start any profiles with
CONNECTION = "ethernet" or "ethernet-iproute" and
INTERFACE = WIRED_INTERFACE until one of them succeeds.

Note:DHCP profiles are tried before static ones, which could lead to
undesired results in some cases. However, one can tell netcfg to prefer
a particular interface by adding AUTO_WIRED=1 to the desired profile.

Note:The net-auto-wired daemon cannot start multiple ifplugd processes
for multiple interfaces (unlike ifplugd's own /etc/rc.d/ifplugd which
can).

FAQ
---

Q: Why doesn't netcfg do (some feature)?

A: Netcfg does not need to; it connects to networks. Netcfg is modular
and re-usable. See /usr/lib/network for re-usable functions for custom
scripts.

Q: Why doesn't netcfg behave in this way?

A: Netcfg does not enforce any rules; it connects to networks. Netcfg
does not impose any heuristics, like "disconnect from wireless if
Ethernet is connected". If you want such behavior, it should be simple
to write a separate tool on top of netcfg. See the question above.
Alternatively, you could be creative with the use of netcfg's POST_UP
functionality to handle some use cases.

Q: Do I need anything else if I'm using netcfg?

A: This question usually references /etc/hostname, which still has to be
set.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Netcfg&oldid=255864"

Category:

-   Networking
