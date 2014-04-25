Brother DCP-150C
================

Contents
--------

-   1 Introduction
-   2 Printer
    -   2.1 Prerequisites
    -   2.2 Installing printer drivers
    -   2.3 Installing the printer (Local USB)
    -   2.4 Installing the printer (Network, Ethernet)
-   3 Scanner
    -   3.1 Scan Key Install (Optional)
    -   3.2 Troubleshooting
        -   3.2.1 Shifted printer output

Introduction
============

This is a brief tutorial to make the Brother DCP-150C printer/scanner
work on Arch. While this tutorial is based on the DCP-150C specifically,
it can be used as a general guide for most Brother USB printers. On
Brother's Linux Driver page you can find extra information along with
drivers for different printer models.

Printer
=======

Prerequisites
-------------

This tutorial assumes you have the following packages installed. Failure
to do so may result in hard to trace issues with printing.

-   cups
-   ghostscript
-   gsfonts
-   foomatic-filters
-   arch x86_64 requires lib32-libcups

If you previously tried to install the printer in CUPS, remove it and
any remaining driver files!!

  
 Brother's scripts make use of the C Shell (csh) instead of the more
common Bash. We must install tcsh from the "extra" repo.

    # pacman -S tcsh

Your user is a member of the printer group (lp). Be sure to logout for
changes to take affect.

    # usermod -aG lp [username]

Additional info about setting up CUPS if needed.

Installing printer drivers
--------------------------

You can get dcp150c drivers from the AUR.

Installing the printer (Local USB)
----------------------------------

The kernel module usblp must be blacklisted before installing the
driver, otherwise the Device URI will be wrong and the printer won't
work.

Warning:Blacklisting modules in rc.conf has been obsoleted and no longer
works in initscripts 2011.06.1-1, so you'll have to use the following
method.

To disable the module, create a .conf file inside /etc/modprobe.d/ as
follows:

    /etc/modprobe.d/blacklist.conf

    # Do not load the usblp module on boot
    blacklist usblp

Note:The blacklist command will blacklist a module so that it will not
be loaded automatically, but may be loaded if another non-blacklisted
module depends on it, or if it is loaded manually.

However, there is a workaround for this behaviour; the install command
instructs modprobe to run a custom command instead of inserting the
module in the kernel as normal, so you can force the module to always
fail loading with:

    /etc/modprobe.d/blacklist.conf

    ...
    install usblp /bin/false
    ...

This will effectively "blacklist" that module and any other that depends
on it.

Reboot the box to take effect, or manually remove the module without
rebooting:

    # modprobe -r usblp

You have to start the cups daemon (as root, of course) if it doesn't run
already, otherwise the installation script won't work and throws a
failure.

    # systemctl start cupsd.service

Now lets plug in the printer and run the script to install the driver
for us.

As root in terminal:

    # /usr/local/Brother/Printer/dcp150c/cupswrapper/cupswrapperdcp150c

It will stop the cups daemon, and restart it.

Warning:Daemon may fail to start due to bug in csh. If "Unknown colors
variable `mh'." message is displayed, before starting daemon, execute:

    unset LS_COLORS

Now go to the CUPS setup page: http://localhost:631/ Click on Manage
Printers you should see your DCP150C printer automatically installed and
configured. Print a test page!

If the test page fails with error "Printer not connected; will retry in
30 seconds..." then.

1.  Click Delete Printer and remove the automatically created printer.
2.  Click Administration --> Find New Printers
3.  You should see your Brother printer listed here, add it!
4.  Print a test page

NOTE: Be sure to add cupsd to the DAEMON line in rc.conf so it loads
everytime at startup.

Installing the printer (Network, Ethernet)
------------------------------------------

Now lets run the script to install the driver for us.

As root in terminal:

    /usr/local/Brother/Printer/dcp150c/cupswrapper/cupswrapperdcp150c

It will stop the cups daemon if it's running, and restart it.

Warning:Daemon may fail to start due to bug in csh. If "Unknown colorls
variable `mh'." message is displayed, before starting daemon, execute:

    unset LS_COLORS

Now go to the CUPS setup page: http://localhost:631/

1.  Click Manage Printers --> Delete Printer and remove the
    automatically created printer.
2.  Click Administration --> Find New Printers
3.  You should see your Brother printer listed here, add it!
4.  Print a test page

If Find New Printers doesn't list any printers you can try to set it up
manually.

1.  Click Add Printer
2.  Location can be left blank, but can have something in it for
    reference sake, Description can be left blank, but can also have
    something in it for reference sake. Click continue
3.  Choose the device "Appsocket/HP JetDirect" then click continue
4.  Set the Device URI to socket://192.168.0.10:9100
5.  Select the make Brother
6.  Select the printer Brother DCP-150C CUPS
7.  Click finish and print a test page.

NOTE: Be sure to make cups load at startup with.

    # systemctl enable cups.service

Scanner
=======

First, make sure you install sane with.

    # pacman -S sane

This scanner works with Brother's brscan2 driver. It can be found on
AUR:

    $ yaourt -S brscan2 brscan2-network

Let driver configure:

    # /usr/local/Brother/sane/setupSaneScan2 -i

To test the scanner, you can install xsane:

    # pacman -S xsane

And run it to verify the installation (as a user):

    $ xsane

Scan Key Install (Optional)
---------------------------

This allows the scanner to be recognized in other programs such as GIMP.
This information is a condensed and consolidated version off of
Brother's linux support site (Link)

Scan Key Tool can be found on AUR:

    $ yaourt -S brscan-skey 

Run the setup script for brscan-key:

    # /usr/local/Brother/sane/brscan-skey-0.2.1-1.sh

Execute the tool to verify that the previously installed scanner is
recognized:

    # brscan-skey -l

Expect the following output:

    # brscan-skey -l
     
    DCP150C          : brother2:net1;dev0  : 10.1.1.90            Active

NOTE: To let GIMP see the scanner be sure to install xsane-gimp with.

    # pacman -S xsane-gimp

After you receive the above output via brscan-key, check the File->
Create list in GIMP (tested v. 2.8) and there should be two more
entries:

    XSane: Device Dialog...
    XSane: brother2:net1;dev0

If the new entries appear, congratulations! Your Brother scanner is now
available via any XSane interface!

Troubleshooting
---------------

> Shifted printer output

Take a look at file /usr/local/Brother/Printer/dcp150c/inf/brdcp150crc
and verify if the value of PaperType matches your paper size.

(Change "Letter" to "A4")

Retrieved from
"https://wiki.archlinux.org/index.php?title=Brother_DCP-150C&oldid=285199"

Categories:

-   Printers
-   Imaging

-   This page was last modified on 29 November 2013, at 12:47.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
