Connman
=======

> Summary

Covers installation and configuration of ConnMan – an alternative to
NetworkManager.

> Related

Wireless Setup

ConnMan is an alternative to NetworkManager and Wicd and was created by
Intel and the Moblin project for use with embedded devices. ConnMan is
designed to be light on resources making it ideal for netbooks, and
other mobile devices. It is modular in design takes advandage of the
dbus API and provides proper abstraction on top of wpa_supplicant.
ConnMan currently has plugins available for:

-   WiFi
-   Ethernet
-   Bluetooth (Through bluez)
-   WiMAX
-   VPN's (Through the connman-vpn.service)

It is Typically used for Wireless networking and being plugin based it
is extremely fast at resolving connections. After setup You may wish to
check for yourself with systemd-analyze blame To see the difference in
performance VS other Network Managers.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuring                                                        |
| -   3 Using ConnMan                                                      |
|     -   3.1 Desktop Clients/Applets                                      |
|     -   3.2 Using the Command Line Client                                |
|         -   3.2.1 Settings                                               |
|         -   3.2.2 Hardware                                               |
+--------------------------------------------------------------------------+

Installation
------------

Install from community

Configuring
-----------

To control ConnMan as a regular user, add these lines to
/etc/dbus-1/system.d/connman.conf under the policy user="root" block.

Note:This is now implemented in the current releases of ConnMan

      <policy group="network">
           <allow send_destination="org.moblin.connman"/>
           <allow send_interface="org.moblin.connman.Agent"/>
           <allow send_interface="org.moblin.connman.Counter"/>
       </policy>

Using ConnMan
-------------

First enable and start the connman service with systemctl.

    # systemctl enable connman.service
    # systemctl start connman.service

> Desktop Clients/Applets

Unfortunately, at the time of this writing, ConnMan only has two working
panel applets and a dmenu client.To control ConnMan in other window
managers / desktop environments, one can use the test scripts included
in the source package.

-   econnman for the Enlightenment Desktop.
-   connman-ui-git A GTK client applet for use in most other Desktop
    Environments.
-   connman_dmenu-git The client/frontend for dmenu. refer to this
    thread https://bbs.archlinux.org/viewtopic.php?pid=1260787

Note:connman_dmenu-git requires connman-git in the AUR

Currently the GTK client is not 100% stable however it is good enough
for day-to-day usage. To use it just add connman-ui-gtk to your startup.

You need python and python-dbus to run these.

> Using the Command Line Client

Note:As of version 1.7 connman has a standard command line client
connmanctl

Start connman and in a terminal, open the test directory in the source
package.

To scan the network connmanctl accepts simple names called technologies.
To scan for nearby WiFi networks:

    $ connmanctl scan wifi

To list the available networks found after a scan run:

Note:you will see something similar to this (Not actual results):

    ./test-connman services
    $ connmanctl services
    *AO MyNetwork               wifi_dc85de828967_68756773616d_managed_psk
        OtherNET                wifi_dc85de828967_38303944616e69656c73_managed_psk 
        AnotherOne              wifi_dc85de828967_3257495245363836_managed_wep
        FourthNetwork           wifi_dc85de828967_4d7572706879_managed_wep
        AnOpenNetwork           wifi_dc85de828967_4d6568657272696e_managed_none

To connect to an open network simple use the enter the second field
beginning with wifi_

    $ connmanctl connect wifi_dc85de828967_4d6568657272696e_managed_none

The code after the SSID is important. This identifies the network you
want to connect to. To connect to this network first, enter your
password by:

    ./test-connman passphrase wifi_8945762986259dfgs9hsd9bgs9e_managed_wep PASSWORDHERE

And connect using:

    ./test-connman connect wifi_8945762986259dfgs9hsd9bgs9e_managed_wep

You should now be connected to the network. Check using ip a or
connmanctl state.

Settings

Settings and profiles are automatically created for networks the user
connects to often. They contain feilds for the passphrase, essid and
other information. Profile settings are stored in directories under
/var/lib/connman/ by their service name. To view all network profiles
do:

Note:VPN settings can be found in /var/lib/connman-vpn/

    # cat /var/lib/connman/*/settings

Hardware

Various hardware interfaces are referred to as Technologies by
connmanctl. To interact with them one must refer to the technology by
type. Technologies can be toggled On/Off with:
$ connmanctl enable technology_type And
$ connmanctl disable technology_type

Example:

    This will toggle wifi off
    $ connmanctl disable wifi 

Note:The field Type = tech_name provides the technology type used with
connmanctl commands

To list available technologies run:

    $ connmanctl technologies

To get just the types by their name one can use this one liner.

    $ connmanctl technology | grep "Type" | awk '{print $NF}'

  
 For further detailed information on ConnMan refer to this
documentation:
http://git.kernel.org/cgit/network/connman/connman.git/plain/doc/overview-api.txt?id=HEAD

Retrieved from
"https://wiki.archlinux.org/index.php?title=Connman&oldid=255746"

Category:

-   Wireless Networking
