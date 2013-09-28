Canon iP4300
============

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Requirements                                                       |
| -   3 Methods of getting the printer working                             |
|     -   3.1 Proprietary Drivers                                          |
|         -   3.1.1 Install needed packages                                |
|         -   3.1.2 Download drivers                                       |
|             -   3.1.2.1 Canon iP4200                                     |
|                                                                          |
|         -   3.1.3 Move the files                                         |
|         -   3.1.4 Install the printer with CUPS                          |
|         -   3.1.5 Creating links for libs                                |
|         -   3.1.6 Troubleshooting                                        |
|                                                                          |
|     -   3.2 Gutenprint                                                   |
|         -   3.2.1 Install needed packages                                |
|         -   3.2.2 install the printer with CUPS                          |
|                                                                          |
|     -   3.3 Turboprint                                                   |
|         -   3.3.1 Install Turboprint                                     |
|         -   3.3.2 Install the printer with CUPS                          |
|                                                                          |
|     -   3.4 Related Links/Additional Information                         |
+--------------------------------------------------------------------------+

Introduction
============

This is a brief summary of the ways that the Canon iP4300 printer can be
made to work with arch. As the printers are very similar, these
techniques would very likely work with the iP4200 also.

Requirements
============

The following packages will very likely be needed:

-   cups
-   ghostscript
-   gsfonts

Install with:

    # pacman -S cups ghostscript gsfonts

For information about setting up cups, refer to CUPS, however all that
is really needed for the iP4300 is to start the cups daemon with:

    # /etc/rc.d/cupsd start

and to add cupsd to the daemons line in /etc/rc.conf

Methods of getting the printer working
======================================

There are basically four options:

-   Proprietary Drivers
-   Original Canon Drivers found in AUR
    (https://aur.archlinux.org/packages.php?ID=28923)
-   Gutenprint
-   Turboprint

Proprietary Drivers
-------------------

> Install needed packages

You will need the package rpmextract

    # pacman -S rpmextract

Now create a directory somewhere (for the sake of this tutorial let this
directory be ~/canon) and cd to it.

> Download drivers

The following download locations seem not to be available any more. You
can get the rpm packages from the canon download center / support page.
There also seems to be a Debian version with extra functionality
available (see discussion).

Download cnijfilter-ip4300-2.70-1.i386.rpm and
cnijfilter-common-2.70-1.i386.rpm from
ftp://download.canon.jp/pub/driver/bj/linux/ and put into the folder you
created, or:

    # wget ftp://download.canon.jp/pub/driver/bj/linux/cnijfilter-common-2.70-1.i386.rpm
    # wget ftp://download.canon.jp/pub/driver/bj/linux/cnijfilter-ip4300-2.70-1.i386.rpm

If the above command to download cnijfilter-ip4300-2.70-1.i386.rpm
doesn't work you can try the following link:

    # wget http://files.canon-europe.com/files/soft27403/software/Linux_Print_Filterv270.tgz

As of 09-10-2010 canon.jp was not responding. Canon Australia has both
files available. Go to
http://www.canon.com.au/en-AU/Support-Services/Drivers-and-Downloads and
select Printers & Consumables -> Inkjet Single Function -> Pixma iP4300
from the drop down menus. From there you can select Linux as the
operating system on the right and download both of these files (scroll
to the bottom of the page for the "Download" link):

-   Linux Common Package v.2.70:
    http://support-au.canon.com.au/contents/AU/EN/0900718403.html
-   Linux iP4300 driver v.2.70:
    http://support-au.canon.com.au/contents/AU/EN/0900719301.html

Note:A recent user was unable to successfully use the iP4300 printer
with Canon's drivers. The installation succeeded, but printing a test
page failed with "/usr/lib/cups/filter/pstocanonij failed" and
"/usr/lib/cups/filter/pstocanonij: No such file or directory", even
though said filter was present. Installing the gutenprint package (see
Canon_iP4300#Gutenprint), restarting cups, deleting the printer and
reinstalling it with the gutenprint driver worked flawlessly

Canon iP4200

For the Canon Pixma iP4200 download the following files (common + ip4200
package):

    # http://support-au.canon.com.au/EN/search?v%3aproject=ABS-EN&binning-state=model%3d%3dPIXMA%20iP4200%0Amenu%3d%3dDownload%0Aos%3d%3dLinux&

Now extract the rpms:

    # rpmextract.sh cnijfilter-ip4300-2.70-1.i386.rpm 
    # rpmextract.sh cnijfilter-common-2.70-1.i386.rpm

Now for the monotonous bit (there is probably a much quicker way to do
this using scripts etc, but this way is simple and allows you to see
what goes where)

> Move the files

The command rpmextract.sh should have created a usr/ directory in the
folder with the rpms. Copy every file in this directory's subfolders
into the corresponding actual location. e.g. copy the files in
~/canon//usr/lib/ to /usr/lib/ Do this for all files in all
subdirectories (however I as my language is english, I didn't bother
copying the locale folder in ~/canon/usr/local/share and everything
still seems to work fine.

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

    DAEMONS=(syslog-ng dbus hal ... @cupsd)

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
-   Navigate to /usr/share/cups/model/ and choose canonip4300.ppd

The printer should now be installed. If you finish these steps and
receive an error like "device uri: 'cnij_usb:/dev/usb/lp0' is bad!",
then go back to the beginning of this section and make sure that the
usblp module is not loaded.

Once installed, you could test the printer by pressing the Print Test
Page button, or continue onto the next step to add support for higher
resolutions. Bulk of information from
http://www.erlandertervueren.com/ubuntu/ip4300_guide The installed PPD
file doesn't allow you to select the printing quality. To fix this, back
up your ppd file, then open it as root. Your ppd file will be found in
/etc/cups/ppd and it's name depends upon what you called your printer.
The commands below assume the printer was called Canon:

    # su root
    # <text editor here> /etc/cups/ppd/Canon.ppd

Insert these lines in the file after the "Resolution" section:

    *OpenUI *CNQuality/Quality: PickOne
    *DefaultCNQuality: 3
    *CNQuality 2/High: "2"
    *CNQuality 3/Normal: "3"
    *CNQuality 4/Standard: "4"
    *CNQuality 5/Economy: "5"
    *CloseUI: *CNQuality

The following gives a greater choice of print resolution if added to the
"Resolution" section, but it is currently not know if the Quality
setting impinges upon this. Note that the ip4200 only offers 600dpi in
black and white. (Maybe someone could verify some of this)

    *Resolution 1200/1200 dpi: "<</HWResolution[1200 1200]>>setpagedevice"
    *Resolution 2400/2400 dpi: "<</HWResolution[2400 2400]>>setpagedevice"
    *Resolution 4800/4800 dpi: "<</HWResolution[4800 4800]>>setpagedevice"

> Creating links for libs

The driver needs a few additional libraries for which you have to create
links. You can find the missing libraries by running the executable
files in /usr/local/bin/ that you have copied earlier. You'll probably
have to link

    # ln -s /usr/lib/libpng.so /usr/lib/libpng.so.3
    # ln -s /usr/lib/libxml2.so.2 /usr/lib/libxml.so.1

Eventually you also have to install gtk

    # pacman -S gtk

> Troubleshooting

If the printer (in my case iP4200) still doesn't work try adding it
without providing the ppd file. Add a new printer via
http://localhost:631, choose Canon from above the file selection dialog
for the ppd file and then navigate to the according device.

Gutenprint
----------

> Install needed packages

First of we are going to need the gutenprint drivers, so let's install
them

    # pacman -S gutenprint

> install the printer with CUPS

Almost the same procedure as described above in the Proprietary Drivers
section can be used to install the printer. Here are the steps needed

If cups is not already running, start it with

    # /etc/rc.d/cupsd start

Now point your browser of choice at http://localhost:631 This should
present the cups web interface. If not, ensure that cups is started (see
above) and that your hosts are set-up correctly (or see the CUPS
article).

-   Click Add Printer
-   Fill in the Name, Description and Location (not really very
    important)
-   Choose the connection method for your printer, and fill in any
    details required for this.
-   Now you will be prompted for your Printer Model - scroll down and
    choose

    Canon PIXMA iP4300 - CUPS+Gutenprint V5.0.2 (en)

-   Click Add Printer

Note! The version number may vary on your installation.

The printer should now be installed. You could test it by pressing the
Print Test Page button. Keep in mind that the proprietary drivers have a
higher printing quality especially when it comes to printing pictures.

Turboprint
----------

> Install Turboprint

Download the archive (.tgz) from the downloads section, . Extract the
archive and run ./setup

> Install the printer with CUPS

Almost the same procedure as described above in the Guntenprint section
can be used to install the printer. Here are the steps needed

If cups is not already running, start it with

    # /etc/rc.d/cupsd start

Now point your browser of choice at http://localhost:631 This should
present the cups web interface. If not, ensure that cups is started (see
above) and that your hosts are set-up correctly (or see the CUPS
article).

-   Click Add Printer
-   Fill in the Name, Description and Location (not really very
    important)
-   Choose the connection method for your printer, and fill in any
    details required for this.
-   Now you will be prompted for your Printer Model - scroll down and
    choose

    Canon PIXMA iP4300 - CUPS+Gutenprint V5.0.2 (en)

-   Click Add Printer

Note! The version number may vary on your installation.

The printer should now be installed. You could test it by pressing the
Print Test Page button.

Related Links/Additional Information
------------------------------------

http://www.erlandertervueren.com/ubuntu/ip4300_guide/ - A guide for
setting up the printer on ubuntu - may help if using gnome etc.

To install the Canon iP1800 Printer, follow the steps of Turboprinter to
install it and in the cups section, select the printer "Canon iP2000" to
detect it.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Canon_iP4300&oldid=196829"

Category:

-   Printers
