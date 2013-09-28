CUPS
====

Summary

Installing and configuring CUPS

Related

CUPS printer sharing

CUPS printer-specific problems

Samba

From CUPS' site:

"CUPS is the standards-based, open source printing system developed by
Apple Inc. for OS® X and other UNIX®-like operating systems".

Although there are other printing packages such as LPRNG, the Common
Unix Printing System is the most popular choice because of its relative
ease of use.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 CUPS Linux Printing workflow                                       |
| -   2 Installing the client package                                      |
|     -   2.1 Optional advanced network setup                              |
|                                                                          |
| -   3 Installing the server packages                                     |
|     -   3.1 Printer driver                                               |
|         -   3.1.1 Download printer PPD                                   |
|         -   3.1.2 Another source for printer drivers                     |
|                                                                          |
| -   4 Hardware support and configuration                                 |
|     -   4.1 USB printers                                                 |
|         -   4.1.1 Blacklisting usblp                                     |
|                                                                          |
|     -   4.2 Parallel port printers                                       |
|     -   4.3 HP Printer                                                   |
|                                                                          |
| -   5 Configuring                                                        |
|     -   5.1 CUPS daemon                                                  |
|     -   5.2 Web interface and tool-kit                                   |
|         -   5.2.1 CUPS administration                                    |
|         -   5.2.2 Remote access to web interface                         |
|                                                                          |
|     -   5.3 Command-line configuration                                   |
|     -   5.4 Alternative CUPS interfaces                                  |
|         -   5.4.1 GNOME                                                  |
|         -   5.4.2 KDE                                                    |
|         -   5.4.3 Other                                                  |
|                                                                          |
| -   6 PDF virtual printer                                                |
|     -   6.1 Print to PostScript                                          |
|                                                                          |
| -   7 Troubleshooting                                                    |
|     -   7.1 Problems resulting from upgrades                             |
|         -   7.1.1 CUPS stops working                                     |
|         -   7.1.2 All jobs are "stopped"                                 |
|         -   7.1.3 All jobs are "The printer is not responding"           |
|         -   7.1.4 The PPD version is not compatible with gutenprint      |
|                                                                          |
|     -   7.2 Other                                                        |
|         -   7.2.1 CUPS permission errors                                 |
|         -   7.2.2 HPLIP printer sends "/usr/lib/cups/backend/hp failed"  |
|             error                                                        |
|         -   7.2.3 HPLIP printer claims job is complete but printer does  |
|             nothing                                                      |
|         -   7.2.4 hp-toolbox sends an error, "Unable to communicate with |
|             device"                                                      |
|         -   7.2.5 CUPS returns '"foomatic-rip" not available/stopped     |
|             with status 3' with a HP printer                             |
|         -   7.2.6 Printing fails with unauthorised error                 |
|         -   7.2.7 Print button greyed-out in GNOME print dialogs         |
|         -   7.2.8 Unknown supported format: application/postscript       |
|         -   7.2.9 Finding URIs for Windows Print Servers                 |
|         -   7.2.10 Print-Job client-error-document-format-not-supported  |
|         -   7.2.11 /usr/lib/cups/backend/hp failed                       |
|         -   7.2.12 Unable to get list of printer drivers                 |
|         -   7.2.13 lp: Error - Scheduler Not Responding                  |
|         -   7.2.14 CUPS prints only an empty and an error-message page   |
|             on HP LaserJet                                               |
|         -   7.2.15 "Using invalid Host" error message                    |
|         -   7.2.16 Printer doesn't print with an "Filter failed" message |
|             on CUPS web interface (HP printer)                           |
|         -   7.2.17 HPLIP 3.13: Plugin is installed, but HP Device        |
|             Manager complains it is not                                  |
|         -   7.2.18 Printer is not recognized by CUPS                     |
|                                                                          |
| -   8 See also                                                           |
+--------------------------------------------------------------------------+

CUPS Linux Printing workflow
----------------------------

As of cups version 1.5.3-3, Arch Linux makes use of the new full
pdf-based printing workflow. For further reading check PDF standard
printing job format and an old CUPS filtering chart for history and fun.
A good starting point for general Linux printing questions is here.

There are two ways to setup a printer.

-   If there's a CUPS server running in your network and sharing a
    printer you only need to install the client package.
-   If the printer is connected directly to your system or you have
    access to an IPP network printer then setup a local CUPS server.

Installing the client package
-----------------------------

The package libcups is the only required package. Install it from the
Official repositories.

Then add your CUPS server's IP address or hostname into
/etc/cups/client.conf. That is all you need. Every application should
quickly find the printer(s) shared by that CUPS server.

> Optional advanced network setup

It is also possible to run a entire cupsd+cups-browsed instance on your
client with Avahi browsing enabled to discover unknown shared printers
in your network. This can be useful in large setups where the server is
unknown.

Note:This behavior did not change with cups 1.6.x - the difference is
that until 1.5.x cupsd was able to do printer browsing alone and now it
can only browse its own shared printers.

To get the local cupsd recognise other shared printers offered by a
remote cupsd server you need a running local cups-browserd (supported
since cups-filters 1.0.26) instance using Avahi to discover unknown
printers.

There is good news in April 2013 (still has to be incorporated above).

Installing the server packages
------------------------------

The following packages and some printer drivers are needed. Install them
from the Official repositories.

-   cups - the actual CUPS daemon
-   cups-filters - essential filters
-   ghostscript - (optional) PostScript interpreter
-   gsfonts - GhostScript standard Type1 fonts

If you want to enable printer browsing through your network, also
install avahi. Make sure avahi-daemon is started before cupsd.

If the system is connected to a networked printer using the Samba
protocol or if the system is to be a print server for Windows clients,
also install samba.

> Printer driver

Here are some of the driver packages. Choosing the right driver depends
on the printer:

-   gutenprint - A collection of high quality drivers for Canon, Epson,
    Lexmark, Sony, Olympus, and PCL printers for use with GhostScript,
    CUPS, Foomatic, and the GIMP
-   foomatic-db, foomatic-db-engine, foomatic-db-nonfree, and
    foomatic-filters - Foomatic is a database-driven system for
    integrating free software printer drivers with common spoolers under
    Unix. Installing foomatic-filters should solve problems if the cups
    error_log is reporting "stopped with status 22!".
-   hplip - HP drivers for DeskJet, OfficeJet, Photosmart, Business
    Inkjet and some LaserJet printer models, as well as a number of
    Brother printers.
-   splix - Samsung drivers for SPL (Samsung Printer Language) printers.

-   foo2zjs - Drivers for ZjStream protocol printers such as the HP
    Laserjet 1018. More info here. Package is available in the AUR.
-   hpoj - If you are using an HP Officejet, you should also install
    this package and follow the instructions to avoid problems as in
    this thread. Package is available in the AUR.
-   samsung-unified-driver - Unified Linux Driver for Samsung printers
    and scanners. Required for new printers such as the ML-2160. Package
    is available in the AUR.
-   ufr2 or cndrvcups-lb - Canon UFR2 driver with support for LBP, iR
    and MF series printers. Package is available in the AUR.

-   cups-pdf - A package that allows one to setup a virtual PDF Printer
    that generates a PDF out of jobs sent to it

If you are not sure of what driver package to install or if the current
driver is not working, it may be easiest to just install all of the
drivers. Some of the package names are misleading because printers of
other makes may rely on them. For example, the Brother HL-2140 needs the
hplip driver installed.

Download printer PPD

Depending on the printer, this step is optional and may not be needed,
as the standard CUPS installation already comes with quite a few PPD
(Postscript Printer Description) files. Moreover, the foomatic-filters,
gimp-print and hplip packages already include quite a few PPD files
which will automatically be detected by CUPS.

Here is an explanation of what a PPD file is from the Linux Printing
website:

"For every PostScript printer the manufacturers provide a PPD file which
contains all printer-specific information about the particular printer
model: Basic printer capabilities as whether the printer is a color
printer, fonts, PostScript level, etc., and especially the
user-adjustable options, as paper size, resolution, etc."

If the PPD for the printer is not already in CUPS, then:

-   check AUR to see if there are packages for the printer/manufacturer
-   visit the OpenPrinting database and select the manufacturer and
    model of the printer
-   visit the manufacturer's site and search for GNU/Linux drivers

Note:PPD files go in /usr/share/cups/model/

Another source for printer drivers

Turboprint is a proprietary driver for many printers not yet supported
by GNU/Linux (Canon i*, for example). Unlike CUPS, however, high quality
prints are either marked with a watermark or are a pay-only service.

Hardware support and configuration
----------------------------------

> USB printers

Tip:Most USB printers should work out of the box, you can skip this
section and come back if you can not get your printer to work.

USB printers can get accessed with two methods: The usblp kernel module
and libusb. The former is the classic way. It is simple: data is sent to
the printer by writing it to a device file as a simple serial data
stream. Reading the same device file allows bi-di access, at least for
things like reading out ink levels, status, or printer capability
information (PJL). It works very well for simple printers, but for
multi-function devices (printer/scanner) it is not suitable and
manufacturers like HP supply their own backends. Source: here.

Blacklisting usblp

Warning:As of cups version 1.6.0, you no longer need to blacklist the
usblp kernel module.  
 If you find out this is the only way to fix a remaining issue please
report this upstream to the CUPS bug tracker and maybe also get in
contact with Till Kamppeter (Debian CUPS maintainer). See upstream bug
for more.

If you have problems getting your USB printer to work, you can try
blacklisting the usblp kernel module:

    /etc/modprobe.d/blacklistusblp.conf

    blacklist usblp

Custom kernel users may need to manually load the usbcore kernel module
before proceeding.

Once the modules are installed, plug in the printer and check if the
kernel detected it by running the following:

    # tail /var/log/messages.log

or

    # dmesg

If you're using usblp, the output should indicate that the printer has
been detected like so:

    Feb 19 20:17:11 kernel: printer.c: usblp0: USB Bidirectional
    printer dev 2 if 0 alt 0 proto 2 vid 0x04E8 pid 0x300E
    Feb 19 20:17:11 kernel: usb.c: usblp driver claimed interface cfef3920
    Feb 19 20:17:11 kernel: printer.c: v0.13: USB Printer Device Class driver

If you blacklisted usblp, you will see something like:

    usb 3-2: new full speed USB device using uhci_hcd and address 3
    usb 3-2: configuration #1 chosen from 1 choice

> Parallel port printers

To use a parallel port printer, you will need to load the lp, parport
and parport_pc kernel modules.

Check the setup by running:

    # tail /var/log/messages.log

It should display something like this:

    lp0: using parport0 (polling).

If you are using a USB to parallel port adapter, CUPS will not be able
to detect the printer. As a workaround, add the printer using a
different connection type and then change DeviceID in
/etc/cups/printers.conf:

    DeviceID = parallel:/dev/usb/lp0

> HP Printer

HP printers can also be installed via HP's Linux setup tool. Install it
by installing hplip from the official repositories.

To run with qt frontend:

    # hp-setup -u

To run with command line:

    # hp-setup -i

PPD files are in /usr/share/ppd/HP/.

For printers that require the proprietary HP plugin (like the Laserjet
Pro P1102w), install the hplip-plugin package from AUR.

Configuring
-----------

Now that CUPS is installed, there are a variety of options on how to set
up printing solutions. As always, the tried and true command line method
is at your disposal. CUPS also embeds a full-featured web interface.
Likewise, various desktop environments such as GNOME and KDE have useful
programs that can help manage printers. Depending on your needs, you may
choose one method or the other.

If you are planning on connecting to a network printer, rather than one
that is directly connected to the computer, you might want to read the
CUPS printer sharing page first. Printer sharing between GNU/Linux
systems is quite easy and involves very little configuration, whereas
sharing between a Windows and GNU/Linux host requires a little bit more
effort.

> CUPS daemon

With the kernel modules installed, you can now start the cups and
optionally, the cups-browsed daemons.

> Web interface and tool-kit

Once the daemon is running, open a browser and go to:
http://localhost:631 (The localhost string may need to be replaced with
the hostname found in /etc/hostname).

From here, follow the various wizards to add the printer. A usual
procedure is to start by clicking on Adding Printers and Classes and
then Add Printer. When prompted for a username and password, log in as
root. The name assigned to the printer does not matter, the same applies
for 'location' and 'description'. Next, a list of devices to select from
will be presented. The actual name of the printer shows up next to the
label (e.g., next to USB Printer #1 for USB printers). Finally, choose
the appropriate drivers and the configuration is complete.

Now test the configuration by pressing the Maintenance drop-down menu
then Print Test Page. If it does not print and there is certainty
regarding the correctness of applied settings, then the problem is most
likely due to missing a proper printer driver.

Tip:See: #Alternative CUPS interfaces for other other front-ends.

Note:When setting up a USB printer, you should see your printer listed
on Add Printer page. If you can only see a "SCSI printer" option, it
probably means that CUPS has failed to recognize your printer.

Note:To enable wireless scanning on certain HP multi-function devices
using the hplip package, you may need to add the printer as a Network
Printer using the http:// protocol. To determine the proper URI to use,
run the hp-makeuri command.

CUPS administration

A username and password will be required when administering the printer
in the web interface, such as: adding or removing printers, stopping
print tasks, etc. The default username is the one assigned in the sys
group, or root. Other admin groups (e.g. lpadmin or printadmin) may be
added to the SystemGroup line in /etc/cups/cups-files.conf (you might
have to add this line). See these instructions at cups.org. You might
also want to read this post. Create the group[s] (man groupadd) and add
the group[s] to users (man usermod). cupsd must be restarted and the
user must re-login for these changes to take affect.

If the root account has been locked (i.e. when using sudo), it is not
possible to log in the CUPS administration interface with the default
username (root) and password. Follow the instructions above to add other
users as cups administrators.

Remote access to web interface

By default, the CUPS web interface can only be accessed by the
localhost; i.e. the computer that it is installed on. To remotely access
the interface, make the following changes to the /etc/cups/cupsd.conf
file. Replace the line:

    Listen localhost:631

with

    Port 631

so that CUPS listens to incoming requests.

Three levels of access can be granted:

    <Location />           #access to the server
    <Location /admin>	#access to the admin pages
    <Location /admin/conf>	#access to configuration files

To give remote hosts access to one of these levels, add an Allow
statement to that level's section. An Allow statement can take one or
more of the forms listed below:

    Allow from all
    Allow from host.domain.com
    Allow from *.domain.com
    Allow from ip-address
    Allow from ip-address/netmask

Deny statements can also be used. For example, if wanting to give all
hosts on the 192.168.1.0/255.255.255.0 subnet full access, file
/etc/cups/cupsd.conf would include this:

    # Restrict access to the server...
    # By default only localhost connections are possible
    <Location />
       Order allow,deny
       Allow from localhost
       Allow from 192.168.1.0/255.255.255.0
    </Location>

    # Restrict access to the admin pages...
    <Location /admin>
       # Encryption disabled by default
       #Encryption Required
       Order allow,deny
       Allow from localhost
       Allow from 192.168.1.0/255.255.255.0
    </Location>

    # Restrict access to configuration files...
    <Location /admin/conf>
       AuthType Basic
       Require user @SYSTEM
       Order allow,deny
       Allow From localhost
       Allow From 192.168.1.0/255.255.255.0
    </Location>

You might also need to add:

    DefaultEncryption Never

This should avoid the error: 426 - Upgrade Required when using the CUPS
web interface from a remote machine.

> Command-line configuration

CUPS can be fully controlled from command-line with nice tools, i.e. the
lp* and the cups* command families.

On Arch Linux, most commands support auto-completion with common shells.
Also note that command-line switches cannot be grouped.

List the devices

    # lpinfo -v

List the drivers

    # lpinfo -m

Add a new printer

    # lpadmin -p <printer> -E -v <device> -P <ppd>

The <printer> is up to you. The device can be retrieved from the 'lpinfo
-i' command. Example:

    # lpadmin -p HP_DESKJET_940C -E -v "usb://HP/DESKJET%20940C?serial=CN16E6C364BH"  -P /usr/share/ppd/HP/hp-deskjet_940c.ppd.gz

In the following, the <printer> references the name you have used here
to set up the printer.

Set the default printer

    $ lpoptions -d <printer>

Check the status

    $ lpstat -s
    $ lpstat -p <printer>

Deactivate a printer

    # cupsdisable <printer>

Activate a printer

    # cupsenable <printer>

Remove a printer

First set it to reject all incoming entries:

    # cupsreject <printer>

Then disable it.

    # cupsdisable <printer>

Finally remove it.

    # lpadmin -x <printer>

Print a file

    $ lpr <file>
    $ lpr -# 17 <file>              # print the file 17 times
    $ echo "Hello, world!" | lpr -p # print the result of a command. The -p switch adds a header.

Check the printing queue

    $ lpq
    $ lpq -a # on all printers

Clear the printing queue

    # lprm   # remove last entry only
    # lprm - # remove all entries

> Alternative CUPS interfaces

GNOME

If using GNOME, a possibility is to manage and configure the printer by
installing system-config-printer.

For system-config-printer to work as it should, running as root may be
required, or alternatively set up a "normal" user to administer CUPS (if
so follow steps 1-3).

1. Create group, and add a user to it

    # groupadd lpadmin
    # usermod -aG lpadmin <username>

2. Add lpadmin to this line in /etc/cups/cups-files.conf

    SystemGroup sys root <insert here>

3. Restart cups, log out and in again (or restart computer)

KDE

KDE users can modify their printers from the Control Center. Both should
refer to those desktop environments' documentation for more information
on how to use the interfaces.

Other

There is also gtklp in the AUR.

PDF virtual printer
-------------------

CUPS-PDF is a nice package that allows one to setup a virtual printer
that will generate a PDF from anything sent to it. This package is not
necessary, but it can be quite useful. It can be installed using the
following command:

    # pacman -S cups-pdf

After installing the package, set it up as if it were for any other
printer by using the web interface. Access the cups print manager:
http://localhost:631 and select:

    Administration -> Add Printer
    Select CUPS-PDF (Virtual PDF), choose for the make and driver:
    Make:	Generic
    Driver:	Generic CUPS-PDF Printer

Find generated PDF documents in a sub-directory located at
/var/spool/cups-pdf. Normally, the subdirectory is named after the user
who performed the job. A little tweak helps you to find your printed PDF
documents more easily. Edit /etc/cups/cups-pdf.conf by changing the line

    #Out /var/spool/cups-pdf/${USER}

to

    Out ${HOME}

> Print to PostScript

The CUPS-PDF (Virtual PDF Printer) actually creates a PostScript file
and then creates the PDF using the ps2pdf utility. To print to
PostScript, just print as usual, in the print dialog choose "CUPS-PDF"
as the printer, then select the checkbox for "print to file", hit print,
enter the filename.ps and click save. This is handy for faxes, etc...

Troubleshooting
---------------

The best way to get printing working is to set 'LogLevel' in
/etc/cups/cupsd.conf to:

    LogLevel debug

And then viewing the output from /var/log/cups/error_log like this:

    # tail -n 100 -f /var/log/cups/error_log

The characters at the left of the output stand for:

-   D=Debug
-   E=Error
-   I=Information
-   And so on

These files may also prove useful:

-   /var/log/cups/page_log - Echoes a new entry each time a print is
    successful
-   /var/log/cups/access_log - Lists all cupsd http1.1 server activity

Of course, it is important to know how CUPS works if wanting to solve
related issues:

1.  An application sends a .ps file (PostScript, a script language that
    details how the page will look) to CUPS when 'print' has been
    selected (this is the case with most programs).
2.  CUPS then looks at the printer's PPD file (printer description file)
    and figures out what filters it needs to use to convert the .ps file
    to a language that the printer understands (like PJL, PCL), usually
    GhostScript.
3.  GhostScript takes the input and figures out which filters it should
    use, then applies them and converts the .ps file to a format
    understood by the printer.
4.  Then it is sent to the back-end. For example, if the printer is
    connected to a USB port, it uses the USB back-end.

Print a document and watch error_log to get a more detailed and correct
image of the printing process.

> Problems resulting from upgrades

Issues that appeared after CUPS and related program packages underwent a
version increment

CUPS stops working

The chances are that a new configuration file is needed for the new
version to work properly. Messages such as "404 - page not found" may
result from trying to manage CUPS via localhost:631, for example.

To use the new configuration, copy /etc/cups/cupsd.conf.default to
/etc/cups/cupsd.conf (backup the old configuration if needed) and
restart CUPS to employ the new settings.

All jobs are "stopped"

If all jobs sent to the printer become "stopped", delete the printer and
add it again. Using the CUPS web interface, go to Printers > Delete
Printer.

To check the printer's settings go to Printers, then Modify Printer.
Copy down the information displayed, click 'Modify Printer' to proceed
to the next page(s), and so on.

All jobs are "The printer is not responding"

On networked printers, you should check that the name that CUPS uses as
its connection URI resolves to the printer's IP via DNS, e.g. If your
printer's connection looks like this:

    lpd://BRN_020554/BINARY_P1

then the hostname 'BRN_020554' needs to resolve to the printer's IP from
the server running CUPS

The PPD version is not compatible with gutenprint

Run:

    # /usr/sbin/cups-genppdupdate

And restart CUPS (as pointed out in gutenprint's post-install message)

> Other

CUPS permission errors

-   Some users fixed 'NT_STATUS_ACCESS_DENIED' (Windows clients) errors
    by using a slightly different syntax:

    smb://workgroup/username:password@hostname/printer_name

-   Sometimes, the block device has wrong permissions:

    # ls /dev/usb/
    lp0
    # chgrp lp /dev/usb/lp0

HPLIP printer sends "/usr/lib/cups/backend/hp failed" error

Make sure dbus is installed and running. If the error persists, try
starting avahi-daemon.

Try adding the printer as a Network Printer using the http:// protocol.
Generate the printer URI with hp-makeuri.

Note:There might need to set permissions issues right. Follow
indications here: CUPS#Device node permissions.

HPLIP printer claims job is complete but printer does nothing

This happens on HP printers when you select the (old) hpijs driver (e.g.
the Deskjet D1600 series). Instead, use the hpcups driver when adding
the printer.

Some HP printers (e.g HP LaserJet) require their firmware to be
downloaded from the computer every time the printer is switched on. If
there is an issue with udev (or equivalent) and the firmware download
rule is never fired, you may experience this issue. As a workaround, you
can manually download the firmware to the printer. Ensure the printer is
plugged in and switched on, then enter

    hp-firmware -n

hp-toolbox sends an error, "Unable to communicate with device"

If running hp-toolbox as a regular user results in:

    # hp-toolbox
    # error: Unable to communicate with device (code=12): hp:/usb/<printer id>

or, "Unable to communicate with device"", then it may be needed to add
the user to the lp and sys groups.

This can also be caused by printers such as the P1102 that provide a
virtual cd-rom drive for MS-Windows drivers. The lp dev appears and then
disappears. In that case try the usb-modeswitch and usb-modeswitch-data
packages, that lets one switch off the "Smart Drive" (udev rules
included in said packages).

This can also occur with network attached printers if the avahi-daemon
is not running.

CUPS returns '"foomatic-rip" not available/stopped with status 3' with a HP printer

If receiving any of the following error messages in
/var/log/cups/error_log while using a HP printer, with jobs appearing to
be processed while they all end up not being completed with their status
set to 'stopped':

    Filter "foomatic-rip" for printer "<printer_name>" not available: No such file or director

or:

    PID 5771 (/usr/lib/cups/filter/foomatic-rip) stopped with status 3!

make sure hplip has been installed, in addition to the packages
mentioned above. See this forum post for more information.

Printing fails with unauthorised error

If the user has been added to the lp group, and allowed to print (set in
cupsd.conf), then the problem lies in /etc/cups/printers.conf. This line
could be the culprit:

    AuthInfoRequired negotiate

Comment it out and restart CUPS.

Print button greyed-out in GNOME print dialogs

Source: I can't print from gnome applications. - Arch Forums

Be sure the package: libgnomeprint is installed

Edit /etc/cups/cupsd.conf and add

    # HostNameLookups Double

Restart CUPS:

    # systemctl restart cups

Unknown supported format: application/postscript

Comment the lines:

    application/octet-stream        application/vnd.cups-raw        0      -

from /etc/cups/mime.convs, and:

    application/octet-stream

in /etc/cups/mime.types.

Finding URIs for Windows Print Servers

Sometimes Windows is a little less than forthcoming about exact device
URIs (device locations). If having trouble specifying the correct device
location in CUPS, run the following command to list all shares available
to a certain windows username:

    $ smbtree -U windowsusername

This will list every share available to a certain Windows username on
the local area network subnet, as long as Samba is set up and running
properly. It should return something like this:

     WORKGROUP
    	\\REGULATOR-PC   		
    		\\REGULATOR-PC\Z              	
    		\\REGULATOR-PC\Public         	
    		\\REGULATOR-PC\print$         	Printer Drivers
    		\\REGULATOR-PC\G              	
    		\\REGULATOR-PC\EPSON Stylus CX8400 Series	EPSON Stylus CX8400 Series

What is needed here is first part of the last line, the resource
matching the printer description. So to print to the EPSON Stylus
printer, one would enter:

    smb://username.password@REGULATOR-PC/EPSON Stylus CX8400 Series

as the URI into CUPS. Notice that whitespaces are allowed in URIs,
whereas backslashes get replaced with forward slashes. If it won't work
try '%20' instead of spaces.

Print-Job client-error-document-format-not-supported

Try installing the foomatic packages and use a foomatic driver.

/usr/lib/cups/backend/hp failed

Change

     SystemGroup sys root

to

     SystemGroup lp root

in /etc/cups/cupsd.conf

  
 Following steps 1-3 in the Alternative CUPS interfaces below may be a
better solution, since newer versions of cups will not allow the same
group for both normal and admin operation.

Unable to get list of printer drivers

-   Check your ServerName in /etc/cups/client.conf is written without
    http://

    ServerName localhost:631

-   Try to remove Foomatic drivers.

lp: Error - Scheduler Not Responding

If you get this error when printing a document using:

    $ lp document-to-print

Try setting the CUPS_SERVER environment variable:

    $ export CUPS_SERVER=localhost

If this solves your problem, make the solution permanent by adding the
export line above to ~/.bash_profile.

CUPS prints only an empty and an error-message page on HP LaserJet

There is a bug that causes CUPS to fail when printing images on HP
LaserJet (in my case 3380). The bug has been reported and fixed by
Ubuntu. The first page is empty, the second page contains the following
error message:

     ERROR:
     invalidaccess
     OFFENDING COMMAND:
     filter
     STACK:
     /SubFileDecode
     endstream
     ...

In order to fix the issue, use the following command (as superuser):

     lpadmin -p <printer> -o pdftops-renderer-default=pdftops

"Using invalid Host" error message

Try to add "ServerAlias *" into cupsd.conf

Printer doesn't print with an "Filter failed" message on CUPS web interface (HP printer)

Change the permissions of the printer USB port:

Get the bus and device number from lsusb, then set the permission using:

chmod 0666 /dev/bus/usb/<bus number>/<device number>

To make the persistent permission change that will be triggered
automatically each time the computer is rebooted, add the following
line.

    /etc/udev/rules.d/10-local.rules

    SUBSYSTEM=="usb", ATTRS{idVendor}=="Printer_idVendor", ATTRS{idProduct}=="Printer_idProduct", GROUP="lp", MODE:="666"

Obtain the right information by using lsusb command, and don't forget to
substitute Printer_idVendor & Printer_idProduct with the relevant ones.

Each system may vary, so consult udev#List_attributes_of_a_device wiki
page.

HPLIP 3.13: Plugin is installed, but HP Device Manager complains it is not

The issue might have to do with the file permission change that had been
made to /var/lib/hp/hplip.state. To correct the issue, a simple
chmod 644 /var/lib/hp/hplip.state and chmod 755 /var/lib/hp should be
sufficient. For further information, please read this link.

Printer is not recognized by CUPS

If your printer is not listed in the "Add Printers" page of the CUPS web
interface, nor by lpinfo -v, try the following (suggested in this
thread):

1.  Remove usblp from blacklist
2.  Load usblp module

    modprobe usblp

1.  Stop cups (sudo systemctl stop cups)
2.  Add the following udev rule in the following new rule
    /etc/udev/rules.d/10-cups_device_link.rules

    KERNEL=="lp[0-9]", SYMLINK+="%k", GROUP="lp"

1.  Reload udev rules

    sudo udevadm control --reload-rules

1.  Unplug and re-plug the printer
2.  Wait a few seconds and then start cups again (sudo systemctl start
    cups)

See also
--------

-   Official CUPS documentation, locally installed
-   Official CUPS Website
-   Linux Printing, The Linux Foundation
-   Gentoo's Printing Guide, Gentoo Documentation Resources
-   Arch Linux User Forums
-   Install HP Printers Easy Way

Retrieved from
"https://wiki.archlinux.org/index.php?title=CUPS&oldid=256101"

Category:

-   Printers
