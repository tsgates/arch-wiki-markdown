Canon LBP2900
=============

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Requirements                                                       |
|     -   2.1 Additional requirements on Arch64                            |
|                                                                          |
| -   3 Driver                                                             |
| -   4 Installation                                                       |
| -   5 Restart cups                                                       |
| -   6 Add cups daemon in /etc/rc.conf                                    |
| -   7 Make folowing directories and fifo0                                |
| -   8 Register printer                                                   |
| -   9 Make udev rule for your printer                                    |
| -   10 Start printer daemon and print                                    |
| -   11 Turboprint                                                        |
| -   12 Related Links/Additional Information                              |
+--------------------------------------------------------------------------+

Introduction
============

This is a brief manual about how to make Canon i-sensys LBP2900
(LBP2900) to work with arch. This manual can be also applied on folowing
printer models: LBP3010/LBP3018/LBP3050, LBP3100/LBP3108/LBP3150,
LBP3250, LBP3310, LBP5100, LBP5300, LBP3500, LBP3300, LBP5000, LBP3210,
LBP3000, LBP2900, LBP3200, LBP-1120, LBP-1210

Note: if you can find your printer model on the list use this manual,
and switch [printer model] with your printer model

Requirements
============

-   cups
-   ghostscript
-   gsfonts
-   rpmextract.sh
-   system-config-printer
    (system-config-printer-gnome/kdeadmin-system-config-printer-kde)

Install with:

    # pacman -S cups ghostscript gsfonts rpmextract system-config-printer

Additional requirements on Arch64
---------------------------------

-   lib32-libcups
-   (old packages: lib32-cups)
-   lib32-heimdal
-   lib32-libxml2
-   lib32-popt from aur version 1.16-5

Install with:

    # pacman -S lib32-libcups lib32-heimdal lib32-libxml2

And build the aur package using ABS.

Driver
======

-   http://gdlp01.c-wss.com/gds/4/0900007724/11/Linux_CAPT_PrinterDriver_V230_uk_EN.tar.gz

Also you can search in http://software.canon-europe.com/ for your
printer driver, newest version is v240 at least for the lbp-3200
(checked april 2012).

For information about setting up cups, refer to CUPS.

Installation
============

Download the driver and extract it:

    # wget http://gdlp01.c-wss.com/gds/4/0900007724/11/Linux_CAPT_PrinterDriver_V230_uk_EN.tar.gz
    # tar -xvf Linux_CAPT_PrinterDriver_V230_uk_EN.tar.gz
    # cd Linux_CAPT_PrinterDriver_V230_uk_EN/32-bit_Driver/RPM
    or: # cd Linux_CAPT_PrinterDriver_V230_uk_EN/64-bit_Driver/RPM (on Arch 64-bit)
    # rpmextract.sh *

The last command above will extract all rpm-s and merge all directories
that were stored in them. So basically you'll get two directories: etc
and usr. Next thing you need to do is to open etc directory and change
init.d to rc.d. You can also do it by command:

    # mv etc/init.d etc/rc.d

Now you can remove rpm-s:

    # rm *.rpm

and execute the next command which will merge etc and usr directories
with appropriate ones in / directory:

    # cp -var * /

Restart cups
============

    # /etc/rc.d/cupsd restart

Add cups daemon in /etc/rc.conf
===============================

Open /etc/rc.conf with a text editor of your choice (e.g. nano), and put
cups in the list of daemons:

    DAEMONS=(... @bluetooth cupsd gdm)

Make folowing directories and fifo0
===================================

    # mkdir /var/ccpd /var/captmon
    # mkfifo /var/ccpd/fifo0

Make fifo0 accessable to everyone:

    # chmod 777 /var/ccpd/fifo0

Change the owner of fifo0 into root:

    # chown root /var/ccpd/fifo0

Register printer
================

Register the printer driver with the print spooler with the following
command, replacing [printer model] with your printer model and [printer
driver file] with your driver file:

    # /usr/sbin/lpadmin -p [printer model] -m [printer driver file] -v ccp://localhost:59787 -E

    (old method - now wrong: # /usr/sbin/lpadmin -p [printer model] -m [printer driver file] -v ccp:/var/ccpd/fifo0 -E)

for this manual it would be

    # /usr/sbin/lpadmin -p LBP2900 -m CNCUPSLBP2900CAPTK.ppd -v ccp://localhost:59787 -E

    (old method - now wrong: # /usr/sbin/lpadmin -p LBP2900 -m CNCUPSLBP2900CAPTK.ppd -v ccp:/var/ccpd/fifo0 -E)

Register the printer with ccpd daemon, once again replace [printer
model] with your printer model:

    # /usr/sbin/ccpdadmin -p [printer model] -o /dev/usb/lp0

in this case it is:

    # /usr/sbin/ccpdadmin -p LBP2900 -o /dev/usb/lp0

Make udev rule for your printer
===============================

Create an udev rule so when you turn the printer on, printer daemon
(ccpd) will start:

    # echo -e '#Own udev rule for Canon-CAPT\nSUBSYSTEM=="usb", KERNEL=="lp*", RUN+="/etc/rc.d/ccpd restart"' <no line break>
    > /etc/udev/rules.d/85-canon-capt.rules

Reload Rules:

    # udevadm control --reload-rules

More about udev rules you can see here:
http://reactivated.net/writing_udev_rules.html

Start printer daemon and print
==============================

    # /etc/rc.d/ccpd start

The printer should now be installed. You could test it by pressing the
Print Test Page button.

Turboprint
==========

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Related Links/Additional Information
====================================

https://help.ubuntu.com/community/HardwareSupportComponentsPrinters/CanonPrinters/Canon_LBP_2900
- A guide for setting up the printer on ubuntu

Retrieved from
"https://wiki.archlinux.org/index.php?title=Canon_LBP2900&oldid=245123"

Category:

-   Printers
