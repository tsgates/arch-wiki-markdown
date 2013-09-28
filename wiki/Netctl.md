netctl
======

  Summary
  ------------------------------------------------------------------------------
  A guide to configuring the network using netctl and network profile scripts.

Netctl is a new Arch project that replaces netcfg. Netctl is the future
(and present) of CLI-based network management on Arch Linux.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Required reading                                                   |
| -   3 Configuration                                                      |
|     -   3.1 Automatic Operation                                          |
|         -   3.1.1 Just One Profile                                       |
|         -   3.1.2 Multiple Profiles                                      |
|                                                                          |
|     -   3.2 Migrating from netcfg                                        |
|     -   3.3 Passphrase obfuscation (256-bit PSK)                         |
|                                                                          |
| -   4 Support                                                            |
| -   5 Tips and Tricks                                                    |
+--------------------------------------------------------------------------+

Installation
------------

The netctl package is available in the Official Repositories. Installing
netctl will replace netcfg.

Required reading
----------------

Considerable effort has gone into the construction of quality man pages.
Users should read the following man pages prior to using netctl:

-   netctl
-   netctl.profile
-   netctl.special

netctl and netcfg are conflicting packages. You will be potentially
connectionless after installing netctl if your profiles are
misconfigured.

Configuration
-------------

netctl may be used to introspect and control the state of the systemd
services for the network profile manager. Example configuration files
are provided for the user to assist them in configuring their network
connection. These example profiles are located in /etc/netctl/examples/.
The common configurations include:

-   ethernet-dhcp
-   ethernet-static
-   wireless-wpa
-   wireless-wpa-static

To use an example profile, simply copy one of them from
/etc/netctl/examples/ to /etc/netctl/ and configure it to your needs:

    # cp /etc/netctl/examples/wireless-wpa /etc/netctl/

Once you have created your profile, make an attempt to establish a
connection using the newly created profile by running:

    # netctl start <profile>

If issuing the above command results in a failure, then use
journalctl -xn and netctl status <profile> in order to obtain a more in
depth explanation of the failure. Make the needed corrections to the
failed configuration and retest.

> Automatic Operation

Just One Profile

If you are using only one profile, once that profile is started
successfully, it can be enabled using

    # netctl enable <profile> 

This will create and enable a systemd service that will start when the
computer boots.

Note:The connection to a dhcp-server is only established, if the
interface is connected and up at boot time (or when the service starts).
In order to have an automatic connection established on cable connect,
proceed to the Multiple Profiles section.

Multiple Profiles

Whereas with netcfg there was net-auto-wireless.service and
net-auto-wired.service, netctl uses netctl-auto@<interface>.service for
wireless profiles, and netctl-ifplugd@<interface>.service for wired
profiles. In order to make the netctl-auto@<interface>.service work for
wireless interfaces, the package wpa_actiond is required to be
installed. In order to make the netctl-ifplugd@<interface>.service work
for wired interfaces, the package ifplugd is required to be installed.
Configure /etc/ifplugd/ifplugd.conf accordingly. Automatic selection of
a WPA-enabled profile by netctl-auto is not possible with option
Security=wpa-config, please use Security=wpa-configsection instead.

Once your profiles are set and verified to be working, simply enable
these services with

    # systemctl enable netctl-auto@<interface>.service 
    # systemctl enable netctl-ifplugd@<interface>.service  

If you have previously enabled a profile through netctl, run

    # netctl disable <profile> 

to prevent the profile from starting twice at boot, and possibly causing
issues with wpa_supplicant.

Note:If there is ever a need to alter a currently enabled profile,
execute netctl reenable <profile> to apply the changes.

> Migrating from netcfg

Warning:netctl conflicts with netcfg so disable existing
netcfg@<profile> service before installing netctl.

netctl uses /etc/netctl to store its profiles, not /etc/network.d
(netcfg's profile storage location).

In order to migrate from netcfg, at least the following is needed:

-   Move network profile files to the new directory.
-   Rename variables therein according to netctl.profile(5) (Most
    variable names have only UpperCamelCase i.e CONNECTION= becomes
    Connection=).
-   For static IP configuration make sure the Address= variables have a
    netmask after the IP (e.g. Address=('192.168.1.23/24'
    '192.168.1.87/24') in the example profile).
-   If you setup a wireless profile according in the
    wireless-wpa-configsection example, note that this overrides
    wpa_supplicant options defined above the brackets. For a connection
    to a hidden wireless network, add scan_ssid=1 to the options in the
    wireless-wpa-configsection; Hidden=yes does not work there.
-   Unquote interface variables and other variables that don't strictly
    need quoting (this is mainly a style thing).
-   Run netctl enable <profile> for every profile in the old NETWORKS
    array. 'last' doesn't work this way, see netctl.special(7).
-   Use netctl list / netctl start <profile> instead of netcfg-menu.
    wifi-menu remains available.

> Passphrase obfuscation (256-bit PSK)

Users not wishing to have their passphrase stored in plain text have the
option of storing the corresponding 256-bit PSK instead, which is
calculated from the passphrase and the SSID using standard algorithms.

Calculate your 256-bit PSK using wpa_passphrase:

    Usage: wpa_passphrase [ssid] [passphrase]

    $ wpa_passphrase archlinux freenode

In a second terminal window copy the example file wireless-wpa from
/etc/netctl/examples to /etc/netctl.

    # cp /etc/netctl/examples/wireless-wpa /etc/netctl/wireless-wpa

You will then need to edit /etc/netctl/wireless-wpa using your favorite
text editor and add the Pre-shared Key that was generated earlier using
wpa_passphrase, to the Key variable of this profile.

Once completed your network profile wireless-wpa containing a 256-bit
PSK should resemble:

    /etc/netctl/wireless-wpa

    Description='A simple WPA encrypted wireless connection using 256-bit PSK'
    Interface=wlp2s2
    Connection=wireless
    Security=wpa
    IP=dhcp
    ESSID=archlinux
    Key=\"64cf3ced850ecef39197bb7b7b301fc39437a6aa6c6a599d0534b16af578e04a

Note:Make sure to use the special non-quoted rules for Key= that are
explained at the end of netctl.profile(5).

Note:The key that you put in the profile configuration is enough to
connect to a WPA-PSK network, which means this procedure is only good to
hide the human-readable passphrase, but will not prevent anyone with
read access to this file from connecting to the network. You should ask
yourself if there is any use in this at all, since using the same
passphrase for anything else is a very poor security measure.

Support
-------

Official announcement thread:
https://bbs.archlinux.org/viewtopic.php?id=157670

Tips and Tricks
---------------

As of April 2013 there is no netctl alternative to netcfg current. If
you relied on it for something, like a status bar for a tiling window
manager, you can now use:

    # netctl list | sed -n 's/^\* //p'

or, when netctl-auto was used to connect:

    # wpa_cli -i <interface> status | sed -n 's/^id_str=//p'

Retrieved from
"https://wiki.archlinux.org/index.php?title=Netctl&oldid=255884"

Category:

-   Networking
