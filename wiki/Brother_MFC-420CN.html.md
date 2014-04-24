Brother MFC-420CN
=================

Contents
--------

-   1 Introduction
-   2 Printer
    -   2.1 Prerequisites
    -   2.2 Download printer drivers
    -   2.3 Extracting the RPM files
    -   2.4 Editing files to make it work with Arch
    -   2.5 Installing the printer (Local USB)
    -   2.6 Installing the printer (Network, Ethernet)
        -   2.6.1 Troubleshooting
-   3 Scanner
    -   3.1 Scan Key Install (Optional)
    -   3.2 Troubleshooting
        -   3.2.1 I can scan as root, but not as a normal user
        -   3.2.2 64 bit caveat
-   4 PC FAX

Introduction
============

This is a brief tutorial to make the Brother MFC-420CN printer/scanner
work on Arch. While this tutorial is based on the MFC-420CN
specifically, it can be used as a general guide for most Brother MFC
model printers (substituting MFC-420CN for your model where needed). On
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

Note: lib32-libcups needs the [multilib] repositorie activated in
/etc/pacman.conf

If you previously tried to install the printer in CUPS, remove it and
any remaining driver files!!

Brother's scripts make use of the C Shell (csh) instead of the more
common Bash. We must install tcsh from the "extra" repo.

    # pacman -S tcsh

Brother's scripts look for C Shell in /bin/csh but will fail with the
error "Bad Interpreter" unless we correct this to /usr/bin/tcsh. As root
lets create a symbolic link:

    # ln -s /usr/bin/tcsh /bin/csh

Your user is a member of the printer group (lp). Be sure to logout for
changes to take affect.

    # usermod -aG lp [username]

Additional info about setting up CUPS if needed.

Download printer drivers
------------------------

Brother actively supplies Linux drivers for it's MFC series printers in
RPM and DEB formats. Luckily there are tools to change these formats
into something Arch can use.

First create a temporary directory.

Then you must download the official LPR drivers from the Brother website
into this directory. Click here to download the MFC-420CN LPR driver
(RPM archive).

You should also download the CUPS wrapper script. Click here to download
the MFC-420CN CUPS wrapper script (RPM archive). This script creates the
filters and PPD file for CUPS automatically saving us from extra work.

Extracting the RPM files
------------------------

Now you need a small script called rpmextract which allows you to
extract files from the RPM you've just downloaded.

In the terminal as root:

    # pacman -S rpmextract

Extract both RPM files :

    $ rpmextract.sh MFC420CNlpr-1.0.2-1.i386.rpm
    $ rpmextract.sh cupswrapperMFC420CN-1.0.0-1.i386.rpm

Editing files to make it work with Arch
---------------------------------------

Arch Linux uses its own file system organization, so we'll have to edit
some files. Assuming you are still in the temporary directory you
created. You can use your favorite text editor to edit
usr/local/Brother/cupswrapper/cupswrapperMFC420CN-1.0.0 and change all
instances of /etc/init.d/ to /etc/rc.d/ OR you can just do the
following.

As root in terminal:

    # sed -i 's|/etc/init.d|/etc/rc.d|' usr/local/Brother/cupswrapper/cupswrapperMFC420CN-1.0.0

Once you've finished this step, copy all of the files to their
corresponding directories in your file system :

    # cp -r usr/* /usr

Installing the printer (Local USB)
----------------------------------

The kernel module usblp must be blacklisted before installing the
driver, otherwise the Device URI will be wrong and the printer won't
work.

To disable the module, edit /etc/rc.conf as shown:

    /etc/rc.conf

    MODULES=(... !usblp ...)

Warning:Blacklisting modules in rc.conf has been obsoleted and no longer
works in initscripts 2011.06.1-1, so you'll have to use the following
method.

Create a .conf file inside /etc/modprobe.d/ and blacklist the module as
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

Now lets plug in the printer and run the script to install the driver
for us.

As root in terminal:

    /usr/local/Brother/cupswrapper/cupswrapperMFC420CN-1.0.0

It will stop the cups daemon if it's running, and restart it.

Warning:Daemon may fail to start due to bug in csh. If "Unknown colorls
variable `mh'." message is displayed, before starting daemon, execute:

    unset LS_COLORS

Now go to the CUPS setup page: http://localhost:631/ Click on Manage
Printers you should see your MFC-420CN printer automatically installed
and configured. Print a test page!

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

    /usr/local/Brother/cupswrapper/cupswrapperMFC420CN-1.0.0

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
6.  Select the printer Brother MFC-420CN CUPS
7.  Click finish and print a test page.

NOTE: Be sure to add cups to the DAEMON line in rc.conf so it loads
everytime at startup.

NOTE: for Brother DCP340-CW. If you would like to print wireless, try
and modify the previous added printer using Cups:

1.  Click Printers.
2.  Click Modify Printer for the printer you installed previously
3.  Click Continue
4.  Choose LPD/LPR Host or Printer
5.  Write in the filed Device URI: lpd://192.168.1.199/binary_p1. Of
    course, replace that ip with yours.
6.  Choose Brother manufacturer and Brother MFC-210 Cups wrapper driver
    in the next screen
7.  Click on Modify Printer

and you will be able to print also using wifi of DCP340-CW.

> Troubleshooting

-   Error message "Unable to locate printer BRN30055C13A4A6" while
    printing a test page from CUPS web interface
    -   Edit /etc/cups/printers.conf and replace BRN30055C13A4A6 with
        the actual IP address of the printer

Scanner
=======

First, make sure you set up SANE.

This scanner works with Brother's brscan2 driver. (32 bit | 64 bit)

You can refer here for up to date scanner drivers:
http://solutions.brother.com/linux/en_us/download_scn.html

You'll need to extract the files to a temp path:

    $ rpmextract.sh brscan2-0.2.4-0.i386.rpm

or, for 64 bit:

    $ rpmextract.sh brscan2-0.2.4-0.x86_64.rpm

Now copy the files to their corresponding directories in your file
system:

    # cp -r /path/to/brscan/usr/* /usr

Now you'll need to add "brother2" to the end of /etc/sane.d/dll.conf  
 Brother felt it necessary to include a script to do that, so you can
also run:

    # /usr/local/Brother/sane/setupSaneScan2 -i

For a networked brother scanner:

    # brsaneconfig2 -a name=[ANY_NAME] model=[EXACT_MODEL] ip=[IP_ADDR]

Example:

    # brsaneconfig2 -a name=MFC420CN model=MFC-420CN ip=10.1.1.90

To test the networked scanner, you can install xsane:

    # pacman -S xsane

And run it to verify the installation (as a luser):

    $ xsane

Scan Key Install (Optional)
---------------------------

This allows the scanner to be recognized in other programs such as GIMP.
This information is a condensed and consolidated version off of
Brother's linux support site (Link)

You'll need to extract the files to a temp path:

    $ rpmextract.sh brscan-skey-0.2.1-1.i386.rpm

While in the directory that contains the extracted content, run:

    # cp -r ./usr/* /usr

Run the setup script for brscan-key:

    # /usr/local/Brother/sane/brscan-skey-0.2.1-1.sh

Execute the tool to verify that the previously installed scanner is
recognized:

    # brscan-skey -l

Expect the following output:

    # brscan-skey -l
     
    MFC420CN          : brother2:net1;dev0  : 10.1.1.90            Active

After you receive the above output via brscan-key, check the File->
Create list in GIMP (tested v. 2.6.4) and there should be two more
entries:

    XSane: Device Dialog...
    XSane: brother2:net1;dev0

If the new entries appear, congratulations! Your (networked) Brother
scanner is now available via any XSane interface!

Troubleshooting
---------------

> I can scan as root, but not as a normal user

Make sure your user is in the scanner group:

    # gpasswd -a username scanner

then log out and back in.

If you still can't scan as a normal user, check that /usr/lib/sane (or
/usr/lib64/sane for 64 bit) are readable and executable for your
user/group.

> 64 bit caveat

(Note: recent Arch update merged lib64 into lib, so this may not be
needed any more; you may still need to move the files back into
/usr/lib, instead of /usr/lib64)

The 64 bit RPM has two files in /usr/lib64/, along with two symlinks to
each file. However, the Arch64 Sane package will probably look in
/usr/lib/ rather than /usr/lib64/, so we'll need to create some more
symlinks. And since the symlinks reference the absolute path, not the
relative path, ie:

    linkedfile -> /usr/lib64/originalfile

rather than

    linkedfile -> ./originalfile

a simple cp -r /path/to/brscan/usr/lib64/* /usr/lib/ won't do.

    # ln -s /usr/lib64/libbrcolm2.so.1.0.1 /usr/lib/
    # ln -s /usr/lib64/libbrscandec2.so.1.0.0 /usr/lib/
    # ln -s /usr/lib64/sane/libsane-brother2.so.1.0.7 /usr/lib/sane/
    # cd /usr/lib
    # ln -s libbrcolm2.so.1.0.1 libbrcolm2.so.1
    # ln -s libbrcolm2.so.1 libbrcolm2.so
    # ln -s libbrscandec2.so.1.0.0 libbrscandec2.so.1
    # ln -s libbrscandec2.so.1 libbrscandec2.so
    # cd sane
    # ln -s libsane-brother2.so.1.0.7 libsane-brother2.so.1
    # ln -s libsane-brother2.so.1 libsane-brother2.so

Here's all of that in a nice bash friendly string:

    ln -s /usr/lib64/libbrcolm2.so.1.0.1 /usr/lib/; ln -s /usr/lib64/libbrscandec2.so.1.0.0 /usr/lib/; ln -s /usr/lib64/sane/libsane-brother2.so.1.0.7 /usr/lib/sane/; cd /usr/lib; ln -s libbrcolm2.so.1.0.1 libbrcolm2.so.1; ln -s libbrcolm2.so.1 libbrcolm2.so; ln -s libbrscandec2.so.1.0.0 libbrscandec2.so.1; ln -s libbrscandec2.so.1 libbrscandec2.so; cd sane; ln -s libsane-brother2.so.1.0.7 libsane-brother2.so.1; ln -s libsane-brother2.so.1 libsane-brother2.so

PC FAX
======

Brother also has a Linux driver for the PC FAX features of this printer.
For more information about the PC Fax drivers please see the Brother
Linux Driver page.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Brother_MFC-420CN&oldid=275973"

Categories:

-   Printers
-   Imaging

-   This page was last modified on 18 September 2013, at 19:06.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
