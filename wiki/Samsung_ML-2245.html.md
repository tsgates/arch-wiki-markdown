Samsung ML-2245
===============

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason:                  
                           samsung-unified-driver   
                           is available in the AUR  
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: What matters in  
                           this article, the link   
                           to the driver, is        
                           broken. (Discuss)        
  ------------------------ ------------------------ ------------------------

Samsung ML-2245 is a laser printer that uses SPL (Samsung Printer
Language) and works with CUPS. There are original drivers by "Samsung",
but I haven't have success with installing it on my x86_64 PC. This
article is about how to make it to work.

Installation
------------

Install cups and splix (SPL drivers) from the official repositories.
Install cups-pdf to print to pdf as a virtual printer.

Configuration
-------------

Configure the CUPS, open a web browser, visit http://localhost:631 and
add your ML-2245:

    Administration > Printers/Add Printer

Unfortunaly there are no filters for CUPS in the official repositories
splix package.

Install necessary filters manually
----------------------------------

Download Original Samsung Unified Linux Driver (27.2 MB) from here (the
page is in russian, but just roll it some down, and you will understand
what you need). Unpack the tarball:

    $ tar -xzvf UnifiedLinuxDriver.tar.gz

    $ ls -l

    -rw-r--r-- 1 a users 30149710 Мар  2 00:45 UnifiedLinuxDriver.tar.gz
    drwxr-xr-x 3 a users     4096 Янв  6 04:32 cdroot

    $ ls -l cdroot/

    итого 8
    drwxr-xr-x 5 a users 4096 Янв  6 04:32 Linux
    -r-xr-xr-x 1 a users   60 Сен 26 17:47 autorun

    $ ls -l cdroot/Linux/

    итого 136
    -r-xr-xr-x 1 a users  3451 Сен 26 17:47 Installer.htm
    -r-xr-xr-x 1 a users   204 Сен 17  2007 OEM.ini
    -r-xr-xr-x 1 a users  3825 Сен 26 17:47 check_installation.sh
    drwxr-xr-x 8 a users  4096 Янв  6 04:32 i386
    -r-xr-xr-x 1 a users 52321 Сен 26 17:47 install.sh
    drwxr-xr-x 5 a users  4096 Янв  6 04:32 noarch
    -r-xr-xr-x 1 a users 52321 Сен 26 17:47 uninstall.sh
    drwxr-xr-x 8 a users  4096 Янв  6 04:32 x86_64

cdroot/Linux/${arch} - ${arch} is i386 or x86_64 - as you will. For
example:

    ls -l cdroot/Linux/x86_64/at_root/usr/lib64/cups/filter/

    итого 1560
    -rwxr-xr-x 1 a users 608624 Авг 29  2008 libscmssc.so
    -rwxr-xr-x 1 a users 632192 Авг 29  2008 libscmssf.so
    -rwxr-xr-x 1 a users  13672 Сен 17 17:53 pscms
    -rwxr-xr-x 1 a users  65448 Сен 17 17:53 rastertosamsunginkjet
    -rwxr-xr-x 1 a users  44328 Сен 17 17:53 rastertosamsungpcl
    -rwxr-xr-x 1 a users  69216 Сен 17 17:53 rastertosamsungspl
    -rwxr-xr-x 1 a users 132936 Сен 17 17:53 rastertosamsungsplc

There are our filters!

Install necessary filter manually, e.g. for ML-2245:

    # cp /cdroot/Linux/x86_64/at_root/usr/lib64/cups/filter/rastertosamsungspl \
      /usr/lib/cups/filter/
    # chown root:root /usr/lib/cups/filter/rastertosamsungspl
    # chmod 644 /usr/lib/cups/filter/rastertosamsungspl

You should be able to print now.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Samsung_ML-2245&oldid=303579"

Category:

-   Printers

-   This page was last modified on 8 March 2014, at 09:41.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
