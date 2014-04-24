Wifi Radar
==========

WiFi Radar is a nifty little GUI program that lets you switch wireless
networks with ease.

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Installation
-   2 Configuration
-   3 Tips and tricks
-   4 Additional Resources

Installation
------------

Install wifi-radar from the official repositories.

Configuration
-------------

Edit /etc/sudoers using visudo command and add:

    yourusername     ALL=(ALL) NOPASSWD: /usr/sbin/wifi-radar

Configure wifi-radar to start at boot by enabling its Systemd service.

Run wifi-radar from your application menu. If you want to view the
available networks or to configure your setup, simply run wifi-radar as
root.

Tips and tricks
---------------

1.  You might need to edit /etc/conf.d/wifi-radar to set the particular
    network interface that you want to use.

1.  Some users have had to set ifup required to ON in order for WiFi
    Radar to work properly.

Additional Resources
--------------------

Wireless network configuration -- The wireless setup wiki page

Retrieved from
"https://wiki.archlinux.org/index.php?title=Wifi_Radar&oldid=297821"

Category:

-   Wireless Networking

-   This page was last modified on 15 February 2014, at 15:13.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
