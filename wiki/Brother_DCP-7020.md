Brother DCP-7020
================

  

Contents
--------

-   1 Introduction
-   2 Printer
    -   2.1 Download Printer drivers
    -   2.2 Extracting the RPM files
    -   2.3 Editing files to make it work with Arch
    -   2.4 Installing the driver and printer
-   3 Scanner
    -   3.1 Troubleshooting
        -   3.1.1 I can scan as root, but not as a normal user
        -   3.1.2 64 bit caveat

Introduction
============

This is a brief tutorial to make the Brother DCP-7020 printer/scanner
work on Arch. It is largely a duplicate of the tutorial for the Brother
HL-2030, with changes specific to the Brother DCP-7020.

NOTE: This printer works with the Foomatic driver for the HL-1250.

Printer
=======

Download Printer drivers
------------------------

If you previously tried to install the printer in CUPS, remove it.

  
 First create a temporary directory. Then you must download the official
LPR drivers from the Brother website into that directory. Click here
(and agree to their terms). This is an RPM archive. You have to download
the cupswrapper file here (and agree to their terms). This script
creates the filters and PPD file for CUPS automatically. It's an RPM
archive too.

  

Extracting the RPM files
------------------------

Now you need a small script called rpmextract which allows you to get
the files included in the RPM you've just downloaded. Log in as root and
execute :

    # pacman -S rpmextract

Extract both RPM files :

    $ rpmextract.sh brdcp7020lpr-2.0.1-1.i386.rpm
    $ rpmextract.sh cupswrapperDCP7020-2.0.1-1.i386.rpm

It should give you two directories : usr and var.

  

Editing files to make it work with Arch
---------------------------------------

Arch Linux uses its own file system organization, so you have to edit
some files. Use your text editor (i.e. vi) to open the file named
cupswrapperDCP7020-2.0.1 If you created the temporary directory "tmp" in
your home, this file will be in /home/(your
user)/tmp/usr/local/Brother/cupswrapper/cupswrapperDCP7020-2.0.1

In this file, you must replace all the /etc/init.d/ occurrences by
/etc/rc.d/ and /etc/init.d/cups by /etc/rc.d/cupsd.

Once you've finished this step, copy all of the files to their
corresponding directories in your file system :

    # cp -r /home/user/tmp/usr/* /usr
    # cp -r /home/user/tmp/var/* /var

Installing the driver and printer
---------------------------------

Last step!

Go into /usr/local/Brother/cupswrapper/ and run the cupswrapper file :

    # cd /usr/local/Brother/cupswrapper/
    # ./cupswrapperDCP7020-2.0.1

It will stop the cups daemon if it's running, and restart it.  
  
 Now go to the CUPS page : http://localhost:631/   
  
 Under the Printers tab you should see a DCP7020 printer automatically
installed and configured. You'll want to modify the printer options to
suite your situation.

Thanks to the creator of the HL-2030 page for making this much easier
than I expected it would be!

Scanner
=======

First, make sure you set up SANE.

  
 This scanner works with Brother's brscan2 driver. (32 bit | 64 bit)

You can install this manually, using the following instructions, or else
there's now a package in the AUR too, here.

You'll need to extract the files to a temp path:

    $ rpmextract brscan2-0.2.4-0.i386.rpm

or, for 64 bit:

    $ rpmextract brscan2-0.2.4-0.x86_64.rpm

Now copy the files to their corresponding directories in your file
system:

    # cp -r /path/to/brscan/usr/* /usr

Now you'll need to add "brother2" to the end of /etc/sane.d/dll.conf  
 Brother felt it necessary to include a script to do that, so you can
also run:

    # /usr/local/Brother/sane/setupSaneScan2 -i

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

Retrieved from
"https://wiki.archlinux.org/index.php?title=Brother_DCP-7020&oldid=238877"

Categories:

-   Printers
-   Imaging

-   This page was last modified on 6 December 2012, at 00:54.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
