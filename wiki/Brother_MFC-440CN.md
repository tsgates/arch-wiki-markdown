Brother MFC-440CN
=================

  

Contents
--------

-   1 AUR packages way
-   2 Non AUR packages way
    -   2.1 Introduction
    -   2.2 Download Brother drivers
    -   2.3 Extracting the RPM files
    -   2.4 Editing files to make them work with Arch
    -   2.5 Installing the driver and printer

AUR packages way
----------------

In AUR two packages has been added to keep your life easier. You need
lpr package and cupswrapper package that you can find there:

-   brother-mfc440cn-lpr
-   brother-mfc440cn-cupswrapper

You can download them, build your packages and install them. After
installing cupswrapper you'll be able to add your MFC-440CN printer, or
you can run cupswrappermfc440cn to auto-add your printer:

    # /usr/share/brother/Printer/mfc440cn/cupswrapper/cupswrappermfc440cn

This will restart your cups daemon!

If you want to install it by yourself (maybe because autoinstall
procedure fails or the printer is not correctly installed), just do it
from your cups web-interface.

In case of network installation keep in mind these parameters:

-   "LDP/LPR Host or Printer" is the connection to choose
-   "lpd://<your_printer_ip>/binary_p1" is the addres you should use.

  
 All the rest of this page remains valid at all effect, but aur packages
wont hurt your /usr/local directory and it's faster.

  
 Note: If you use x86_64, you must install lib32-libcups (from the
multilibs repository) for this printer driver to work! When
lib32-libcups is not installed, the printer refuses to print, but no
error message is given.

Non AUR packages way
--------------------

> Introduction

This is a small tutorial to make the printer Brother MFC-440CN work on
Arch. This tutorial has also been confirmed to work for the Brother
MFC-240C (just replace all instances of MFC-240CN with the appropriate
model number). This tutorial is largely a copy of the Brother HL-2030
tutorial with changes made to fit this specific printer. There are no
drivers available from Openprinting.org at the moment for this printer
to work in CUPS. If you previously tried to install the printer in CUPS,
remove it.

> Download Brother drivers

First create a temporary directory. Then you must download the official
LPR drivers from the Brother website in that directory. Click here .
This is a RPM archive. You have to download the cupswrapper file. Right
here. This script creates the filters and PPD file for CUPS
automatically. It's an RPM archive too.

  

> Extracting the RPM files

Now you need a small script called rpmextract which allows you to get
the files included in the RPM you've just downloaded. Log in as root and
execute :

    # pacman -S rpmextract

Extract both RPM files :

    $ rpmextract.sh mfc440cnlpr-1.0.0-9.i386.rpm
    $ rpmextract.sh mfc440cncupswrapper-1.0.0-9.i386.rpm

It should give you a usr directory with two sub-directories: bin and
local.

  

> Editing files to make them work with Arch

Arch Linux uses its own file system organization, so you have to edit
some files. Use your favorite text editor (i.e. vi) to open the file
named cupswrappermfc440cn. If you created the temporary directory "tmp"
in your home, the file will be in
/home/user/tmp/usr/local/Brother/Printer/mfc440cn/cupswrapper/ . In this
file, you must replace all the /etc/init.d/ occurences by /etc/rc.d/.
When it's done, copy all the files in their corresponding directories :

    # cp -r /home/user/tmp/usr/* /usr

> Installing the driver and printer

Last step ! Go into /usr/local/Brother/Printer/mfc440cn/cupswrapper/ and
run the cupswrapper file :

    # cd /usr/local/Brother/Printer/mfc440cn/cupswrapper/
    # ./cupswrappermfc440cn

It will stop the cups daemon if it's running, and restart it. Now go to
the CUPS page : http://localhost:631/ In the Administartion category,
choose Manage printers. There you should see a MFC-440CN printer
automatically installed and configured. It is now configured to use the
USB port. If the printer is used as a network printer you need to modify
the printer configuration. Choose Modify printer, and select Brother
MFC-440CN in the device list. If it do not exist choose LPD/LPR Host or
Printer instead. Then in Device URI you enter the printer IP, i.e
lpd://10.0.0.10. You will find the IP address in the LAN configuration
on the printer itself. The rest of the configuration is preset, so just
choose continue. Click to print the test page, and you can hear the
sweet sound of your printer. If not, try to restart your printer, and
make sure the printers state is Idle, accepting jobs.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Brother_MFC-440CN&oldid=196824"

Category:

-   Printers

-   This page was last modified on 23 April 2012, at 13:25.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
