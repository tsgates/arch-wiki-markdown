PHP pthreads extension
======================

If you wish to have POSIX multi-threading you will need the pthreads
extension. To install the pthreads
(http://pecl.php.net/package/pthreads) extension using pecl you are
required to use a compiled version of PHP with the the thread safety
support flag --enable-maintainer-zts. currently the most clean way to do
this would be to rebuild the original package with the proper flag.

Check what packages depend on the php package, for example:

    pacman -Qii php

    :: php-apache: requires php
    :: php-apcu: requires php
    :: php-mcrypt: requires php
    :: php-pear: requires php
    :: php-pgsql: requires php

Remove all of them including 'php', for example:

    pacman -R php php-apache php-apcu php-mcrypt php-pear php-pgsql

Clone Archlinux's official package repository

    cd /opt/
    git clone git://projects.archlinux.org/svntogit/packages.git
    cd packages/php/repos/extra-x86_64

Make the changes to add threads support

    vim PKGBUILD

Should look something like

    ...
    --with-xsl=shared \
    --with-zlib \
    --enable-maintainer-zts
    ...

Make the new packages

    makepkg -s

Install the packages you removed

    pacman -U \
    php-5.5.8-1-x86_64.pkg.tar.xz \
    php-apache-5.5.8-1-x86_64.pkg.tar.xz \
    php-mcrypt-5.5.8-1-x86_64.pkg.tar.xz \
    php-pear-5.5.8-1-x86_64.pkg.tar.xz \
    php-pgsql-5.5.8-1-x86_64.pkg.tar.xz

Install pthreads

    pecl install pthreads

> Install the 'apcu' package for APC support back

    cd ../../../php-apcu/repos/extra-x86_64/
    makepkg -si

Retrieved from
"https://wiki.archlinux.org/index.php?title=PHP_pthreads_extension&oldid=292415"

Category:

-   Programming language

-   This page was last modified on 11 January 2014, at 12:40.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
