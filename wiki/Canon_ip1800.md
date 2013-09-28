Canon ip1800
============

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Requirements                                                       |
|     -   2.1 Download drivers                                             |
|     -   2.2 Install rpmextract                                           |
|     -   2.3 Extract drivers                                              |
|     -   2.4 Move the files                                               |
|     -   2.5 Install the printer with CUPS                                |
|     -   2.6 Creating links for libs                                      |
+--------------------------------------------------------------------------+

Introduction
============

This is a brief guide for installing the Canon iP1800, based on the wiki
for installing the Canon iP4300 printer.

Requirements
============

The following packages will very likely be needed:

-   cups
-   ghostscript
-   gsfonts
-   gutenprint

Install with:

    # pacman -S cups ghostscript gsfonts gutenprint

Now create a directory somewhere (for the sake of this tutorial let this
directory be ~/canon) and cd to it.

> Download drivers

Canon Australia provides the drivers in .rpm format, rpmextract will be
needed later. Download drivers to ~/canon directory.

-   cnijfilter-ip1800series
    http://support-au.canon.com.au/contents/AU/EN/0900718601.html
-   cnijfilter-common
    http://support-au.canon.com.au/contents/AU/EN/0900718405.html

> Install rpmextract

You will need this package to extract the content of the drivers

    # pacman -S rpmextract

> Extract drivers

    # rpmextract.sh cnijfilter-ip1800series-2.70-1.i386.rpm
    # rmpextract.sh cnijfilter-common-2.70-1.i386.rpm

> Move the files

The command rpmextract.sh should have created a usr/ directory in the
folder with the rpms. Copy every file in this directory's subfolders
into the corresponding actual location. e.g. copy the files in
~/canon/usr/lib/ to /usr/lib/ Do this for all files in all
subdirectories, and remember, this has to be done with root privileges.

> Install the printer with CUPS

CUPS now uses libusb instead of usblp. To read more on this, see the
Arch Wiki page for CUPS#Blacklisting usblp. Unload the module if it is
currently loaded:

    # rmmod usblp

Disable it permanently by adding it in /etc/rc.conf:

    MODULES=(... !usblp ...)

If cups was already running, restart it with

    # /etc/rc.d/cupsd restart

If cups is not already running, start it with

    # /etc/rc.d/cupsd start

Make the cups daemon start on boot by adding it to the daemons list in
/etc/rc.conf:

    DAEMONS=(syslog-ng dbus ... @cupsd)

Now point your browser of choice at http://localhost:631 This should
present the cups web interface. If not, ensure that cups is started (see
above) and that your hosts are set-up correctly (or see the CUPS
article).

-   Click Add Printer
-   Fill in the Name, Description and Location (not really very
    important)
-   Choose the connection method for your printer, and fill in any
    details required for this.
-   Now you will be prompted for a Make/Manufacturer - choose Provide a
    ppd file (click browse)
-   Navigate to /usr/share/cups/model/ and choose canonip1800.ppd

> Creating links for libs

The driver needs a few additional libraries for which you have to create
links. You can find the missing libraries by running the executable
files in /usr/local/bin/ that you have copied earlier. To verify which
libraries need linking, run the following command:

    # ldd /usr/local/bin/cifip1800

You'll probably have to link

    # ln -s /usr/lib/libcnbpcmcm312.so.6.50.1 /usr/lib/libcnbpcmcm312.so
    # ln -s /usr/lib/libcnbpess312.so.3.0.9 /usr/lib/libcnbpess312.so
    # ln -s /usr/lib/libpng.so /usr/lib/libpng.so.3
    # ln -s /usr/lib/libcnbpcnclapi312.so.3.3.0 /usr/lib/libcnbpcnclapi312.so
    # ln -s /usr/lib/libcnbpcnclbjcmd312.so.3.3.0 /usr/lib/libcnbpcnclbjcmd312.so
    # ln -s /usr/lib/libcnbpcnclui312.so.3.3.0 /usr/lib/libcnbpcnclui312.so

Retrieved from
"https://wiki.archlinux.org/index.php?title=Canon_ip1800&oldid=196828"

Category:

-   Printers
