Wifi Radar
==========

  

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Installation                                                       |
| -   3 Configuration                                                      |
| -   4 Tips & Tricks                                                      |
| -   5 Additional Resources                                               |
+--------------------------------------------------------------------------+

Introduction
------------

-   WiFi Radar is a nifty little GUI program that lets you switch
    wireless networks with ease.

Installation
------------

To install WiFi Radar, install the wifi-radar package.

Configuration
-------------

    # visudo

Press i and add the following line:

    yourusername     ALL=(ALL) NOPASSWD: /usr/sbin/wifi-radar

Press Escape, then type ZZ to save and exit.

Configure wifi-radar to start at boot using /etc/rc.conf.

Run wifi-radar from your application menu. If you want to view the
available networks or to configure your setup, simply run wifi-radar as
root.

Tips & Tricks
-------------

1.  You might need to edit /etc/conf.d/wifi-radar to set the particular
    network interface that you want to use.

1.  Some users have had to set ifup required to ON in order for WiFi
    Radar to work properly.

Additional Resources
--------------------

Wireless Setup -- The wireless setup wiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=Wifi_Radar&oldid=205962"

Category:

-   Wireless Networking
