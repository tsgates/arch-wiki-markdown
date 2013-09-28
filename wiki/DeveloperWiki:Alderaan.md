DeveloperWiki:Alderaan
======================

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Specs                                                              |
| -   2 Partition layout                                                   |
| -   3 Services                                                           |
| -   4 Maintainer                                                         |
|     -   4.1 bbs.archlinux.org                                            |
|     -   4.2 wiki.archlinux.org                                           |
|     -   4.3 aur.archlinux.org                                            |
|                                                                          |
| -   5 Trivia                                                             |
| -   6 History                                                            |
+--------------------------------------------------------------------------+

Specs
-----

-   i7-920
-   8GB Ram
-   2x750GB HDD as Raid1
-   10TB Traffic
-   100Mbit/s Uplink

Partition layout
----------------

/dev/sda1 and /dev/sdb1 all the space -> /dev/md0

/dev/md0 contains an LVM (VG0) which contains the following volumes:

-   home /home
-   root /
-   srv /srv
-   log /var/log
-   mysql /var/lib/mysql
-   swap

Services
--------

-   postfix listening on localhost:25 and sendmail for outbound email
-   ngnix
-   mysql
-   bbs, wiki, AUR

Maintainer
----------

System (sudo): ioni,dan,bluewind,pierre

> bbs.archlinux.org

-   Maintainer: Pierre
-   Upstream: http://fluxbb.org/
-   Dependencies: php, mysql
-   Public git repo:
    https://projects.archlinux.org/vhosts/bbs.archlinux.org.git/

> wiki.archlinux.org

-   Maintainer: Pierre
-   Upstream: http://www.mediawiki.org/wiki/MediaWiki
-   Dependencies: php, mysql
-   Public git repo:
    https://projects.archlinux.org/vhosts/wiki.archlinux.org.git/

> aur.archlinux.org

-   Maintainer: Lukas Fleischer
-   Dependencies: php, mysql
-   Public git repo: https://projects.archlinux.org/aur.git/

Trivia
------

-   bootloader is grub2
-   network is configured via /etc/rc.d/network_simple

History
-------

-   12.12.11: removed pkgbuild from alderaan
-   12.12.11: moved bbs and wiki to alderaan
-   15.12.11: moved pkgbuild to brynhild

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:Alderaan&oldid=238798"

Category:

-   DeveloperWiki:Server Configuration
