Isatapd
=======

> Summary

Using isatapd to connect to IPv6 network

> Related

Daemon

IPv6_-_6in4_Tunnel

isatapd is an ISATAP client. It is a daemon program to create and to
maintain an ISATAP tunnel RFC 5214 in Linux.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
| -   3 Run                                                                |
| -   4 External links                                                     |
+--------------------------------------------------------------------------+

Installation
------------

You can install the package isatapd from the AUR . If you are using
yaourt, run

    $ yaourt -S isatapd

to install the package.

Configuration
-------------

The package add an rc.d script /etc/rc.d/isatapd to run isatapd as a
system service. You need to modify it to set your router. Change the
value of ISATAPD_ROUTER to the hostname of the router you want to use.

Note: The default value of ISATAPD_ROUTER is isatap.tsinghua.edu.cn.
It's the router provided by Tsinghua University.

If you want to modify other options instead of using the default values,
have a look at the project's homepage for further reference.

Run
---

After you have done with the configuration, you can add the script to
DAEMONS in /etc/rc.conf to have it start when you boot the system. Make
sure to have it go after your network configuration scripts. It's
recommended to have it start in background (with an @ in front) to save
your boot time.

External links
--------------

-   isatapd homepage

Retrieved from
"https://wiki.archlinux.org/index.php?title=Isatapd&oldid=207076"

Category:

-   Networking
