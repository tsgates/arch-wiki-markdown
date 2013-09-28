OpenConnect
===========

From OpenConnect:

OpenConnect is a client for Cisco's AnyConnect SSL VPN, which is
supported by the ASA5500 Series, by IOS 12.4(9)T or later on Cisco
SR500, 870, 880, 1800, 2800, 3800, 7200 Series and Cisco 7301 Routers,
and probably others.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Usage                                                              |
|     -   2.1 With NetworkManager                                          |
|     -   2.2 Manual                                                       |
|         -   2.2.1 IPv6                                                   |
|                                                                          |
| -   3 External links                                                     |
+--------------------------------------------------------------------------+

Installation
------------

Install the openconnect package from the Official Repositories.

Usage
-----

> With NetworkManager

Install the networkmanager-openconnect package from the Official
Repositories. Then configure and connect with nm-applet (network
manager's tray icon) or other utility.

> Manual

Run OpenConnect as root to your gateway:

    # openconnect mygateway.com

More advanced invocation with username and password:

    # echo -n 'passwd' | openconnect -u user --disable-ipv6 --passwd-on-stdin mygateway.com

IPv6

"The standard vpnc−script shipped with vpnc 0.5.3 is not capable of
setting up IPv6 routes; the one from
git://git.infradead.org/users/dwmw2/vpnc−scripts.git will be required."

Download the script that OpenConnect will use to setup routing and DNS
information (should be an AUR package for this eventually):

    # wget http://git.infradead.org/users/dwmw2/vpnc-scripts.git/blob_plain/HEAD:/vpnc-script

Make it executable:

    # chmod +x vpnc-script

Now run OpenConnect as root with the script downloaded above, and
provide the gateway:

    # openconnect --script ./vpnc-script mygateway.com

External links
--------------

-   OpenConnect

Retrieved from
"https://wiki.archlinux.org/index.php?title=OpenConnect&oldid=245682"

Category:

-   Virtual Private Network
