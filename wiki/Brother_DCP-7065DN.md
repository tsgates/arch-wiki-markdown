Brother DCP-7065DN
==================

This is a brief tutorial to make the Brother DCP-7065DN printer/scanner
work on Arch. It is largely a duplicate of the tutorial for the Brother
HL-2030, with changes specific to the Brother DCP-7065DN.

Contents
--------

-   1 Printer
    -   1.1 Download Printer drivers
    -   1.2 Extracting the RPM files
    -   1.3 Editing files to make it work with Arch
    -   1.4 Installing the driver and printer
    -   1.5 Configure the Connection

Printer
-------

> Download Printer drivers

If you previously tried to install the printer in CUPS, remove it.

Install the necessary dependancies :

    $ pacman -S cups ghostscript gsfonts

Then create a temporary directory. Then you must download the official
LPR drivers from the Brother website into that directory. Click here
(and agree to their terms). This is an RPM archive. You have to download
the cupswrapper file here (and agree to their terms). This script
creates the filters and PPD file for CUPS automatically. It's an RPM
archive too.

> Extracting the RPM files

Now you need a small script called rpmextract which allows you to get
the files included in the RPM you have just downloaded. Log in as root
and execute :

    # pacman -S rpmextract

Extract both RPM files :

    $ rpmextract.sh dcp7065dnlpr-2.1.0-1.i386.rpm
    $ rpmextract.sh cupswrapperDCP7065DN-2.0.4-2.i386.rpm

It should give you two directories : usr and var.

> Editing files to make it work with Arch

Arch Linux uses its own file system organization, so you have to edit
some files. Use your text editor (i.e. vi) to open the file named
cupswrapperDCP7065DN-2.0.4 If you created the temporary directory "tmp"
in your home, this file will be in /home/(your
user)/tmp/usr/local/Brother/Printer/DCP7065DN/cupswrapper/cupswrapperDCP7065DN-2.0.4

In this file, you must replace all the

    if [ -e /etc/init.d/cups ]; then
      /etc/init.d/cups restart
    fi
    if [ -e /etc/init.d/cupsys ]; then
      /etc/init.d/cupsys restart
    fi

occurrences with

    systemctl restart cups.service

Once you have finished this step, copy all of the files to their
corresponding directories in your file system :

    # cp -r /home/user/tmp/usr/* /usr
    # cp -r /home/user/tmp/var/* /var

> Installing the driver and printer

Go into /usr/local/Brother/Printer/DCP7065DN/cupswrapper/ and run the
cupswrapper file as root :

    # cd /usr/local/Brother/Printer/DCP7065DN/cupswrapper/
    # ./cupswrapperDCP7065DN-2.0.4

It will stop the cups daemon if it's running, and restart it.

> Configure the Connection

Last step!

Now go to the CUPS page : http://localhost:631/

Under the Printers tab you should see a DCP7065DN printer automatically
installed and configured.

Click the printers name (DCP7065DN) and in the administration drop down
choose "Modify Printer"

Select "LPD/LPR Host or Printer". The next page prompts for the
connection string. Enter: lpd://<Your Printers IP Address>/BINARY_P1

And thats it. Check out pages for similar printers for Scanner setup.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Brother_DCP-7065DN&oldid=270559"

Categories:

-   Printers
-   Imaging

-   This page was last modified on 10 August 2013, at 01:06.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
