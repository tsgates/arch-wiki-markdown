Lexmark
=======

This page's purpose is to inform Arch users how to set up various types
of hardware produced by Lexmark. It'll be informal so please be add what
you feel is necessary, argue a conclusion...

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Requirements                                                       |
| -   2 Drivers                                                            |
| -   3 Debugging                                                          |
| -   4 Etc.                                                               |
+--------------------------------------------------------------------------+

Requirements
------------

Lexmark does provide drivers for Linux systems with all their hardware
and can be installed in two differing ways. The preferable is to create
an Arch-based PKGBUILD so you can keep track, maintain... of what is
installed; the other method is to use the automated script installer
created by Lexmark.

Most packages here are part of the base install and the X windows system
and are only kept for inclusiveness. Here is a list of known packages
believed to be required:

    cups
    libcups
    glibc
    ncurses
    libusb
    libxext
    libxtst
    libxi
    libstdc++5
    heimdal
    lua  # for the automated installer
    java # for the automated installer, and some of the Lexmark tools.

Drivers
-------

The drivers will need to be downloaded. Preferably, put together in an
Arch Linux package and install via it. Here is a basic PKGBUILD that can
do this that still needs work but will give an idea of what to do.

    # Contributor: Todd Partridge (Gen2ly) toddrpartridge (at) yahoo

    pkgname=cups-lexmark-Z2300-2600
    pkgver=1
    pkgrel=1
    pkgdesc="Lexmark Z2300 and 2600 Series printer driver for cups"
    arch=('i686')
    url="http://www.lexmark.com/"
    license=('Custom')
    depends=('cups' 'glibc' 'ncurses' 'libusb' 'libxext' 'libxtst' 'libxi' 'libstdc++5' 'heimdal' 'lua' 'java-runtime')
    conflicts=('z600' 'cjlz35le-cups' 'cups-lexmark-700')
    md5sums=()


    build() {

      # Check if installer if placed in the work directory and test it.
      cd $startdir
      _instmd5=3c37eb87e3dad4853bf29344f9695134
      _installer=lexmark-inkjet-08-driver-1.0-1.i386.tar.gz.sh
      if [ ! -f $_installer ]; then
        msg "!! The automated installer needs to be placed in work directory:"
        msg "!! $(pwd)" 
        msg "!! Visit http://lexmark.com/ and download the driver there." && return 1
      else
        if [[ "$(md5sum $installer | awk '{print $1}')" == "$_instmd5" ]]; then
          msg "Check: Installer is the correct size"
        else
          msg "!! The installer size check did not match.  Exiting." && return 1
        fi
      fi

      # Extract installer
      sh lexmark-inkjet-08-driver-1.0-1.i386.tar.gz.sh --target Installer-Files
      cd Installer-Files
      mkdir Driver
      tar xvvf instarchive_all --lzma -C Driver/
      cd Driver
      tar xv lexmark-inkjet-08-driver-1.0-1.i386.tar.gz -C $pkgdir
    }

The driver will need to be downloaded. Just enter you basic model number
on Lexmark's search and you should find your model. Keep in mind you can
use the automated installer but doing this will leave it untracked. If
you need to tell CUPS you PPD it is in: /usr/local/lexmark/lxk08/etc/.

Debugging
---------

If the installer, or CUPS give messages about not being able to
communicate with the printer or that the "USB device is not found" this
is because it looks like the the driver is looking for the usblp kernel
module. In this instance, un-blacklist the usblp (if isn't already), and
use the cups-usblp found in the AUR.

Etc.
----

For maintainance of your printer Lexmark has created a utility to help
called lexijtools.

To uninstall an automated install:

    sh /usr/local/lexmark/inkjet-08-driver.uninstall

Some junk will be left behind and can now be removed:

    rm -R /usr/local/lexmark

How to add scanner support?

Note:Does scanning software need to be added first? During scripting
install a note described that no Sane libraries were found

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lexmark&oldid=238828"

Category:

-   Printers
