Usenet Resource Downloader
==========================

Note:Though URD's installation manual is fairly complete, some quirks
required for operation were not listed in the documentation. Hence this
article.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 About                                                              |
| -   2 Dependencies                                                       |
|     -   2.1 Required                                                     |
|     -   2.2 Optional                                                     |
|                                                                          |
| -   3 Installation                                                       |
|     -   3.1 Preparing the files                                          |
|     -   3.2 Adjustments to php.ini                                       |
+--------------------------------------------------------------------------+

About
-----

URD is a program to download binaries from usenet (newsgroups) through a
web interface.

While some other programs offer similar services (e.g. Ninan, Sabnzbd),
URD doesn't need external NZB files to function. URD lets you subscribe
to newsgroups, and will then automatically analyse those articles to
form downloadable 'sets', consisting of all the files belonging to a
specific upload. These sets are displayed, and through point and click
you can be downloading a binary in no time.

That isn't to say that NZB files are unsupported. URD allows both
exporting of NZB files (from a set, for example) and importing.

source: http://urdland.com/cms/content/view/15/30/

Dependencies
------------

Required

-   HTTP server
-   PHP 5.x
-   MySQL
-   php-curl
-   php-gmp
-   php-gd
-   unrar
-   Smarty AUR
-   par2cmdline AUR
-   yydecode AUR

Optional

-   trickle
-   cksfv
-   tar
-   7zip
-   unzip
-   unarj
-   unace

  

Installation
------------

Preparing the files

This setup places all files under the set DocumentRoot, or default
directory as configured in your HTTP server. A seperate folder is
created for all downloads.

    wget http://urdland.com/urd-1.0.3.tar.gz
    tar -zxvf urd-1.0.3.tar.gz
    mv urd-1.0.3 urd/

TODO

Adjustments to php.ini

Add /usr/share/php and /dev/ to open_basedir

    open_basedir = /srv/http/:/home/:/tmp/:/usr/share/pear/:/usr/share/php/:/dev/:

Note:For full access to all features of the administration interface,
URD needs access to /usr/group. This can be done through the
open_basedir line mentioned above. Please take into consideration that
this is a system critical file.

Add /usr/share/php/smarty/libs to include_path

    ; UNIX: "/path1:/path2"
    include_path = ".:/usr/share/pear:/usr/share/php/smarty/libs"

Uncomment the following modules

    extension=sockets.so
    extension=xmlrpc.so
    extension=posix.so
    extension=openssl.so
    extension=gmp.so
    extension=curl.so

Retrieved from
"https://wiki.archlinux.org/index.php?title=Usenet_Resource_Downloader&oldid=225606"

Category:

-   Internet Applications
