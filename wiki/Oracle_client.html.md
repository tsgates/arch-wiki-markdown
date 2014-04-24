Oracle client
=============

This document will explain how to install the Oracle database client
under Arch Linux. The client is used to connect to Oracle databases
running on other machines. If you want to host Oracle databases for
others to use, see the instructions for setting up an Oracle database
server.

Contents
--------

-   1 Method 1: Unofficial repository
-   2 Method 2: AUR
    -   2.1 Relevant packages
    -   2.2 Installing each package
    -   2.3 Installation paths

Method 1: Unofficial repository
-------------------------------

By far the easiest method is to use the unofficial Arch packages, as
this allows the Oracle client to be installed and upgraded like any
other program in the Arch repositories.

In order to use this method, you must agree to the Oracle Technology
Network Development and Distribution License Terms for Instant Client
and also trust the person who created these unofficial packages.

Add the following lines to /etc/pacman.conf:

    [oracle]
    SigLevel = Optional TrustAll
    Server = http://linux.shikadi.net/arch/$repo/$arch/

Then synchronise and view the newly available packages:

    $ pacman -Sys oracle

After upgrading your system, install oracle-instantclient-basic; then
you will need to re-source the profile script in any open shells, in
order to pick up the newly added environment variables. Without this,
some programs will complain that they cannot find the Oracle client.

    source /etc/profile

This sets $ORACLE_HOME to /usr. You should place your tnsnames.ora into
/etc.

Method 2: AUR
-------------

An alternative is to use the build scripts in the AUR. Due to the way
Oracle provides downloads of their software, the files cannot be
retrieved automatically. You must download the necessary .zip files
manually and place them in the same directory as the PKGBUILD from AUR,
before running makepkg. You will need an Oracle account before you can
log in and download the .zip files.

> Relevant packages

The packages required from the AUR are:

-   oracle-instantclient-basic - core Oracle client, required by all the
    other packages and any precompiled binaries using the native Oracle
    API
-   oracle-instantclient-sdk - C header files, required to compile
    software that accesses Oracle using the native API
-   oracle-instantclient-sqlplus - SQL*Plus command line utility
-   oracle-instantclient-odbc - UnixODBC connectivity
-   oracle-instantclient-jdbc - Java connectivity

> Installing each package

Download the tarball from the AUR.

    $ wget https://aur.archlinux.org/packages/or/oracle-instantclient-basic/oracle-instantclient-basic.tar.gz
    $ tar zxvf oracle-instantclient-basic.tar.gz
    $ cd oracle-instantclient-basic

Download the relevant .zip file from Oracle. You can run makepkg to find
out what file you need and where to get it from.

    $ makepkg
    ==> ERROR: You need to download instantclient-basic-linux.x64-11.2.0.3.0.zip

      -> This software cannot be downloaded automatically.  You will need to sign up
      -> for an Oracle account and download the software from Oracle directly.  Place
      -> the downloaded file in the same directory as the PKGBUILD and re-run makepkg.
      -> 
      -> The source .zip files can be downloaded from:
      -> 
      -> i686   - http://www.oracle.com/technetwork/topics/linuxsoft-082809.html
      -> x86_64 - http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html

Once the file has been downloaded from Oracle and placed in the same
directory as the PKGBUILD, run makepkg again.

    $ makepkg -ic

This will create the package and install it via sudo. After installing
oracle-instantclient-basic you will need to re-source the profile script
in any open shells, in order to pick up the newly added environment
variables.

    source /etc/profile

Without this, some programs will complain that they cannot find the
Oracle client.

> Installation paths

When using the packages in the AUR, the TNSNAMES file should be saved as
/etc/tnsnames.ora. ORACLE_HOME should be set automatically to /usr in
any new shells opened after the install, courtesy of
/etc/profile.d/oracle.sh.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Oracle_client&oldid=266723"

Category:

-   Database management systems

-   This page was last modified on 17 July 2013, at 08:54.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
