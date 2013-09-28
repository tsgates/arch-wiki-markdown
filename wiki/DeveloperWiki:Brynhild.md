DeveloperWiki:Brynhild
======================

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Specs                                                              |
| -   2 Partition layout                                                   |
| -   3 Services                                                           |
| -   4 Trivia                                                             |
| -   5 Quirks                                                             |
| -   6 History                                                            |
+--------------------------------------------------------------------------+

Specs
-----

-   i7-960
-   8GB Ram
-   2x750GB HDD as Raid1
-   10TB Traffic
-   100Mbit/s Uplink

Partition layout
----------------

Services
--------

-   ssh
-   pkgbuild.com

Trivia
------

-   bootloader is syslinux
-   network is configured via /etc/rc.d/network_simple

Quirks
------

-   Duplex detection doesn't work so force full duplex

History
-------

-   10.8.2011: initial setup
-   23.10.11: power outage
-   24.10.11: sda failed/replaced
-   25.10.11: mysql: fluxbb corrupted; dropped table; restored clean sql
    dump
-   27.10.11: mysql: fluxbb.search_matches corrupted
-   15.11.11: mysql: fluxbb.search_matches corrupted
-   9.12.11: mysql: corrupted (possibly index) page in fluxbb.posts;
    dumped and recreated entire mysql directory on a new LV
-   12.12.11: moved bbs and wiki to alderaan
-   15.12.11: moved pkgbuild to brynhild
-   25.9.12: switched scheduler to deadline, changed swappiness to 40,
    changed allowed ssh ciphers --Bluewind (talk) 10:07, 25 September
    2012 (UTC)

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:Brynhild&oldid=225022"

Category:

-   DeveloperWiki:Server Configuration
