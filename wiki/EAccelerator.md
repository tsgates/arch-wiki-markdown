EAccelerator
============

eAccelerator is a free open-source PHP accelerator & optimizer. It
increases the performance of PHP scripts by caching them in their
compiled state, so that the overhead of compiling is almost completely
eliminated. It also optimizes scripts to speed up their execution.
eAccelerator typically reduces server load and increases the speed of
your PHP code by 1-10 times.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Enable it in PHP                                                   |
| -   3 Check if installation was ok                                       |
| -   4 Troubleshooting                                                    |
| -   5 Sources                                                            |
+--------------------------------------------------------------------------+

Installation
------------

Download the tarball from eaccelerator or use your favorite tool for
AUR.

IMPORTANT: If you are having problems with open_basedir, you need to
edit the PKGBUILD, change the ./configure line to

    ./configure --without-eaccelerator-use-inode --prefix=/usr

I recommend that you do it anyway since future versions of eAccelerator
won't be using inodes. You can find more info here:
http://eaccelerator.net/ticket/104#comment:13

Compile the package with

    makepkg -s

Enable it in PHP
----------------

After the discussion here and the guidance by Spider.007 (also the
maintainer of the AUR package) it is clear that you should do nothing
special in order for eAccelerator to work.

Check if installation was ok
----------------------------

You can either from the command line or using phpinfo(). If the command
line php binary uses the same configuration file as the php-fastcgi
version and/or the mod_php version, you can check it by executing:

    $ php -v

If installation was succesfull you should see something similar to the
following:

    Zend Engine v2.3.0, Copyright (c) 1998-2011 Zend Technologies
       with eAccelerator v0.9.6.1, Copyright (c) 2004-2010 eAccelerator, by eAccelerator

This will show eAccelerator has been loaded successfully, but this
doesn't necessarily show that eAccelerator is working like it should.
Load a php script running on your webserver in your browser. Assuming
you didn't disable the filecache with shm_only = 1, a cached script
should appear in the cache directory.

You could/should also check using phpinfo(). To do so add:

    <?php
      phpinfo();
    ?>

to a file and open it with your browser. eAccelerator should have its
own section.

Troubleshooting
---------------

If you get this error

    PHP Warning:  Module 'eAccelerator' already loaded in Unknown on line 0

Then eAccelerator is loaded twice in your config files. Make sure you
are not loading eAccelerator in both php.ini and its own config file. If
you followed this wiki you shouldn't be having this problem.

If after upgrading php (through pacman) you get this

    [eAccelerator] This build of "eAccelerator" was compiled for PHP version 5.3.6. Rebuild it for your PHP version (5.3.8) or download precompiled binaries.

Then uninstall eAccelerator (I did a pacman -Rcsun eaccelerator),
rebuild it from AUR and reinstall. Everything should be fine once again.

Sources
-------

-   Lighttpd_for_SSL_and_non-SSL#FastCGI_and_PHP_with_eAcceleration -
    helped me install eAccelerator and contains most of the above info
    and more.
-   eAccelerator Wiki, Settings
-   AUR Package and open_basedir fix info by furibondox in the comments
-   eAccelerator info on open_basedir errors
-   Module 'eAccelerator' already loaded

Retrieved from
"https://wiki.archlinux.org/index.php?title=EAccelerator&oldid=229901"

Category:

-   Web Server
