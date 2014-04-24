OpenConnect
===========

From OpenConnect:

OpenConnect is a client for Cisco's AnyConnect SSL VPN, which is
supported by the ASA5500 Series, by IOS 12.4(9)T or later on Cisco
SR500, 870, 880, 1800, 2800, 3800, 7200 Series and Cisco 7301 Routers,
and probably others.

Contents
--------

-   1 Installation
-   2 Usage
    -   2.1 With NetworkManager
    -   2.2 Manual
-   3 External links

Installation
------------

Install the openconnect package from the Official repositories.

Usage
-----

> With NetworkManager

Install the networkmanager-openconnect package from the Official
repositories. Then configure and connect with nm-applet (network
manager's tray icon) or other utility.

> Manual

Download a more up-to-date script that OpenConnect will use to setup
routing and DNS information (the only difference, currently, between
this script and the one that comes with vpnc is using
/usr/sbin/resolvconf instead of /sbin/resolvconf, there should be an AUR
package for this eventually):

    # wget http://git.infradead.org/users/dwmw2/vpnc-scripts.git/blob_plain/HEAD:/vpnc-script

Replace references to /sbin/resolvconf with /usr/bin/resolvconf:

    # sed -i 's/\/sbin\/resolvconf/\/usr\/bin\/resolvconf/g' vpnc-script

Make it executable:

    # chmod +x vpnc-script

Now run OpenConnect as root with the script downloaded above, and
provide the gateway:

    # openconnect --script ./vpnc-script mygateway.com

Warning:The script has not been adapted to Arch Linux. You will probably
need to set your /etc/resolv.conf manually with the proper information.
After you run the openconnect command.

More advanced invocation with username and password:

    # echo -n 'passwd' | openconnect -u user --passwd-on-stdin mygateway.com

External links
--------------

-   OpenConnect

Retrieved from
"https://wiki.archlinux.org/index.php?title=OpenConnect&oldid=301606"

Category:

-   Virtual Private Network

-   This page was last modified on 24 February 2014, at 11:57.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
