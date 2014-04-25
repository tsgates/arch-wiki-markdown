Sane
====

Related articles

-   Scan print and save Script
-   Scanner Button Daemon

Sane provides a library and a command-line tool to use scanners under
GNU/Linux. Here you can check if sane supports your scanner.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 For Acer/BenQ hardware
    -   2.2 For HP hardware
    -   2.3 For Brother hardware
    -   2.4 For Epson hardware
    -   2.5 For Samsung hardware
    -   2.6 For plustek scanners
    -   2.7 For microtek scanners
-   3 Firmware
-   4 Install a frontend
-   5 Network scanning
    -   5.1 Sharing Your Scanner Over a Network
    -   5.2 Configuring xinetd for sane
    -   5.3 Accessing Your Scanner from a Remote Workstation
-   6 Troubleshooting
    -   6.1 Invalid argument
        -   6.1.1 Missing firmware file
        -   6.1.2 Wrong firmware file permissions
        -   6.1.3 Multiple backends claim scanner
    -   6.2 Slow startup
    -   6.3 Permission problem
    -   6.4 Epson Perfection 1270
    -   6.5 Hangs while scanning due to xhci pre-boot mode

Installation
------------

Install sane from the official repositories.

Configuration
-------------

Now you can try to see if sane recognizes your scanner

    $ scanimage -L

If that fails, check that your scanner is plugged into the computer. You
also might have to unplug/plug your scanner for
/etc/udev/rules.d/sane.rules to recognize your scanner.

Now you can see if it actually works

    $ scanimage --format=tiff > test.tiff

If the scanning fails with the message
scanimage: sane_start: Invalid argument you may need to specify the
device.

    $ scanimage -L

    device `v4l:/dev/video0' is a Noname Video WebCam virtual device
    device `pixma:04A91749_247936' is a CANON Canon PIXMA MG5200 multi-function peripheral

Then you would need to run

    $ scanimage --device pixma:04A91749_247936 --format=tiff > test.tiff

> For Acer/BenQ hardware

If you own an USB scanner from Acer (now BenQ), you need to download a
suitable firmware binary and configure /etc/sane.d/snapscan.conf.

-   Find out which model you own and take note of the USB ID:

    $ lsusb

    Bus 002 Device 010: ID 04a5:20b0 Acer Peripherals Inc. (now BenQ Corp.) S2W 3300U/4300U

-   Go to snapscan main page and see whether your scanner is supported
    and which firmware you need (e.g, u176v046.bin).
-   Search the firmware image on the Internet and download it to
    /usr/share/sane/snapscan/.
-   Edit the head of /etc/sane.d/snapscan.conf and configure the
    following two lines:

    firmware /usr/share/sane/snapscan/u176v046.bin
    /dev/usb/scanner0 bus=usb

> For HP hardware

For HP hardware you may also need to install hplip from the official
repositories (see hplib supported devices) and/or hpoj from the AUR (see
hpoj supported devices).

-   Uncomment or add hpaio and hpoj to a new line in
    /etc/sane.d/dll.conf.
-   Running hp-setup as root may help you add your device.
-   hp-plugin is the 'HPLIP Plugin Download and Install Utility'.
-   hp-scan is the 'HPLIP Scan Utility'.

For Hewlett-Packard OfficeJet, PSC, LaserJet, and PhotoSmart printer
multi-function peripherals, run ptal-init setup as root and follow
instructions. Then start the ptal-init daemon.

> For Brother hardware

In order to install a Brother Scanner or Printer/Scanner combo you need
the right driver (which can be found in the AUR). There are only four
drivers to choose from (brscan1-4). In order to find the right one you
should search for your model at the brother linux scanner page.

After you installed the driver you need to run (eg. setupSaneScan2 for
brscan2 compatible devices):

    # /usr/local/Brother/sane/setupSaneScan2 -i

so the drivers/scanner are recognized by sane.

For network scanners, Brother provides a different configuration tool
for each brscan version (eg. brsaneconfig2 for brscan2 compatible
devices):

    # brsaneconfig2 -a name=<ScannerName> model=<ScannerModel> ip=<ScannerIP>

Example:

    # brsaneconfig2 -a name=SCANNER_DCP770CW model=DCP-770CW ip=192.168.0.110

> For Epson hardware

For network (including Wi-Fi) scanners, you can use "Image Scan! for
Linux".

Install iscan and iscan-plugin-network from the AUR, then edit
/etc/sane.d/epkowa.conf and add the line:

    net {IP_OF_SCANNER}

> For Samsung hardware

For some Samsung MFP printers you may need to edit
/etc/sane.d/xerox_mfp.conf.

example entry:

    #Samsung SCX-3200
    usb 0x04e8 0x3441

Change the printer model as needed. You can get the idVendor and
idProduct code with lsusb. See this thread.

When plugging in a usb2 printer/scanner to a usb3 interface there is
currently a bug in the xhci kernel code that causes the xsane process to
hang when the scanner is connected. In the event of a multi-function
Samsung printer having an ethernet or wireless interface then it is
possible to access the scanner over the network rather than the usb
interface by adding in a line to the file /etc/sane.d/xerox_mfp.conf
such as

    #Samsung scx4500w wireless ip network address
    tcp xx.xx.xx.xx

where xx.xx.xx.xx is the static ip address of the printer.

Then when xsane starts up you can choose the network tcp access option
instead of the usb line, and the scanner will be accessed via the
network instead of the usb port and avoid the current usb3 issues.

> For plustek scanners

Some plustek scanners (noticeably Canoscan ones), require a lock
directory. Make sure that /var/lock/sane directory exists, that its
permissions are 660, and that it is owned by <user>:scanner. If the
directory permissions are wrong, only root will be able to use the
scanner. Seems (at least on x86-64) that some programs using libusb
(noticeably xsane and kooka) need scanner group rw permissions also for
accessing /proc/bus/usb to work for a normal user.

> For microtek scanners

Some microtek scanners require the sg module, which should be loaded
automatically. If it is not loaded on your system, try to load it
manually (see Kernel modules#Configuration for details).

Check if the scanner is recognized, you should get the following output:

    scanimage -L

    device `microtek2:/dev/sg5' is a Microtek Phantom 636cx / C6 flatbed scanner

Firmware
--------

Note:This section is only needed if you need to upload firmware to your
scanner.

Firmwares usually have the .bin extension.

Firstly you need to put the firmware someplace safe, it is recommended
to put it in a subdirectory of /usr/share/sane.

Then you need to tell sane where the firmware is:

-   Find the name of the backend for your scanner from the sane
    supported devices list.
-   Open the file /etc/sane.d/<backend-name>.conf.
-   Make sure the firmware entry is uncommented and let the file-path
    point to where you put the firmware file for your scanner. Be sure
    that members of the group scanner can access the
    /etc/sane.d/<backend-name>.conf file.

If the backend of your scanner is not part of the sane package (such as
hpaio.conf which is part of hplip), you need to uncomment the relevant
entry in /etc/sane.d/dll.d/hplip.

Install a frontend
------------------

Many frontends exist for SANE, a non-exhaustive list of which can be
found on the sane-project website. Another way to find them is to use
pacman to search the repositories for keywords such as "sane" or
"scanner".

-   gscan2pdf — A GTK2-based GUI to produce PDFs, TIFFs or DjVus from
    scanned documents. It is also able to apply OCR in the process using
    different engines. Depends on a few Perl packages to build of which
    some are in the AUR as well.

http://gscan2pdf.sourceforge.net/ || gscan2pdf

-   Simple Scan — A simplified GUI that is intended to be easier to use
    and better integrated into the GNOME desktop than XSane. It was
    initially written for Ubuntu and is maintained by Robert Ancell of
    Canonical Ltd. for GNU/Linux.

http://launchpad.net/simple-scan || simple-scan

-   XSane — A full-featured GTK-based frontend looking a bit old but
    providing extended functionalities.

http://www.xsane.org/ || xsane

Note:Scanning directly to PDF using XSane in 16bit color depth mode is
known to produces corrupted files and a note in pacman output warns so.
8bit mode is known to work.

Network scanning
----------------

Sharing Your Scanner Over a Network

You can share your scanner with other hosts on your network who use
sane, xsane or xsane-enabled Gimp. To set up the server, first indicate
which hosts on your network are allowed access.

Change the /etc/sane.d/saned.conf file to your liking, for example:

    # required
    localhost
    # allow local subnet
    192.168.0.0/24

Insert the nf_conntrack_sane module for iptables to let the firewall
track saned connections.

Scanning requests are handled by saned. This can be run as a daemon with
saned -a or run when needed by xinetd:

Configuring xinetd for sane

Install xinetd from the official repositories.

Next, make sure the file /etc/xinetd.d/sane exists and disabled is set
to no:

    service sane-port
    {
       port        = 6566
       socket_type = stream
       wait        = no
       user        = nobody
       group       = scanner
       server      = /usr/bin/saned
       disable     = no
    }

The user named ('nobody' in the file included in the sane package) must
usually be a member of the scanner group to have permission to access
the scanner:

    # usermod -a -G scanner nobody

For some HP combined scanner-printers the user must be a member of the
lp group instead, which should also be used instead of scanner in the
service file.

Add the following line to /etc/services if it is not already present:

    sane-port 6566/tcp

Start the xinetd daemon.

Your scanner can now be used by other workstations, across your local
area network.

Accessing Your Scanner from a Remote Workstation

You can access your network-enabled scanner from a remote Arch Linux
workstation.

To set up your workstation, begin by installing xsane from the official
repositories.

Next, specify the server's host name or IP address in the
/etc/sane.d/net.conf file:

    # static IP address
    192.168.0.1
    # or host name
    stratus

Now test your workstation's connection, from a non-root login prompt:

    $ xsane

or

    $ scanimage -L

After a short while, xsane should find your remote scanner and present
you with the usual windows, ready for network scanning delight!

For HP All in one network printer/scanner/fax you need to configure it
via:

    $ hp-setup <printer ip>

Troubleshooting
---------------

> Invalid argument

If you get an "Invalid argument" error with xsane or another sane
front-end, this could be caused by one of the following reasons:

Missing firmware file

No firmware file was provided for the used scanner (see above for
details).

Wrong firmware file permissions

The permissions for the used firmware file are wrong. Correct them using

    # chown root:scanner /usr/share/sane/SCANNER_MODEL/FIRMWARE_FILE
    # chmod ug+r /usr/share/sane/SCANNER_MODEL/FIRMWARE_FILE

Multiple backends claim scanner

It may happen, that multiple backends support (or pretend to support)
your scanner, and sane chooses one that doesn't do after all (the
scanner won't be displayed by scanimage -L then). This has happend with
older Epson scanners and the epson2 resp. epson backends. In this case,
the solution is to comment out the unwanted backend in
/etc/sane.d/dll.conf. In the Epson case, that would be to change

     epson2
     #epson

to

     #epson2
     epson

> Slow startup

If you encounter slow startup issue (e.g. xsane or scanimage -L take a
lot to find scanner) it may be that more than one driver supporting it
is available.

Have a look at /etc/sane.d/dll.conf and try commenting out one (e.g. you
may have epson, epson2 and epkowa enabled at the same time, try leaving
only epson or epkowa uncommented)

> Permission problem

If you see your scanner only when running lsusb (as root), you might get
it working by adding your user to scanner and/or lp group.

    # gpasswd -a username scanner
    # gpasswd -a username lp

This is reported to work on HP all-in-one models (e.g., PSC 1315 and PSC
2355).

You can also try to change permissions of usb device but this is not
recommended, a better solution is to fix the Udev rules so that your
scanner is recognized.

Example:

First, as root, check connected usb devices with lsusb:

    #Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    #Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    #Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    #Bus 003 Device 003: ID 04d9:1603 Holtek Semiconductor, Inc. 
    #Bus 003 Device 002: ID 04fc:0538 Sunplus Technology Co., Ltd 
    #Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    #Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
    #Bus 001 Device 006: ID 03f0:2504 Hewlett-Packard 
    #Bus 001 Device 002: ID 046d:0802 Logitech, Inc. Webcam C200
    #Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

In our example we see scanner - 'Bus 001 Device 006: ID 03f0:2504
Hewlett-Packard'

Now edit /lib/udev/rules.d/53-sane.rules and look for the first part of
the ID number found previously and check if there is a line that also
reports the second part of the number (model numer), in this example
2504. If not found change or copy a line and enter the idVendor and
idProduct of your scanner, in this example it would be:

    # Hewlett-Packard ScanJet 4100C
    ATTRS{idVendor}=="03f0", ATTRS{idProduct}=="2504", MODE="0664", GROUP="scanner",
      ENV{libsane_matched}="yes"

Save the file, plug out and back in your scanner and the file
permissions should be now correct.

Another tip, is that you can add your device (scanner) in backend file:

Add 'usb 0x03f0 0x2504' to /etc/sane.d/hp4200.conf so it looks like
this:

    #
    # Configuration file for the hp4200 backend
    #
    #
    # HP4200
    #usb 0x03f0 0x0105
    usb 0x03f0 0x2504

> Epson Perfection 1270

For Epson Perfection 1270, you also need a firmware named esfw3e.bin. It
can be obtained by installing the Windows driver.

Modify the configuration file of the snapscan backend,
/etc/sane.d/snapscan.conf. Change the firmware path line with yours:

    # Change to the fully qualified filename of your firmware file, if
    # firmware upload is needed by the scanner
    firmware /mnt/mydata/Backups/firmware/esfw3e.bin

And add the following line in the end or anywhere you like

    # Epson Perfection 1270
    usb 0x04b8 0x0120

You can get such code information (usb 0x04b8 0x0120) by
sane-find-scanner command.

Also add such information lines to /etc/hotplug/usb/libsane.usermap to
setup your privilege, like:

    # Epson Perfection 1270
    libusbscanner 0x0003 0x04b8 0x0120 0x0000 0x0000 0x00 0x00 0x00 0x00 0x00 0x00 0x00000000

Replug scanner, you have a working Epson Perfection 1270 now.

Note:I can scan image if I define the X and Y value, but without that
error message occurs like:
scanimage: sane_start: Error during device I/O, if anyone knows any
other reasons, please add them to this section.

-   To prevent scanimage: sane_start: Error during device I/O and hangup
    of the scanner itself, when trying to scan with ADF (automatic
    document feed) enabled, I had to remove or comment out all Backends
    from /etc/sane.d/dll.conf and instead just add this to the file:

        snapscan

Finally. If you still get the Error I/O messages try to check the
transportation lock of the scanner. It is on the bottom of the scanner.
It must be opened.

> Hangs while scanning due to xhci pre-boot mode

If you get a problem where your scanner is detected while running lsusb
or scanimage -L and even the GUI apps, however when you attempt to scan,
the scanner starts but shortly after hangs or freezes while scanning the
following fix may help you.

You may also get this error loged while attempting to scan:

    kernel: usb 1-2: new high-speed USB device number 8 using xhci_hcd
    kernel: WARNING! power/level is deprecated; use power/control instead

The fix is: In the UEFI/BIOS change the setting under USB configuration,
xhci pre-boot mode from enabled to disabled.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Sane&oldid=306187"

Category:

-   Imaging

-   This page was last modified on 20 March 2014, at 21:53.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
