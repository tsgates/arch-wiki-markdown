HP Photosmart 2575
==================

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Choosing connection method                                         |
| -   2 Setup method with hplip                                            |
| -   3 Setup method without hplip                                         |
|     -   3.1 Install foomatic and cups packages                           |
|     -   3.2 Configure the printer in CUPS                                |
|                                                                          |
| -   4 Testing and troubleshooting                                        |
+--------------------------------------------------------------------------+

Choosing connection method
--------------------------

Determine method for connecting device. In my case I installed it over
the network (192.168.50:9100) because I wanted other computers to be
able to use it on my network without needing to set up all kinds of
things for printer sharing from linux to linux and linux to windows. If
you are connecting via USB then follow the instructions regarding USB
printers on CUPS first.

Setup method with hplip
-----------------------

Determine the printer IP address. In this example 192.168.1.111 will be
used. Install hplip, all other required packages are selected as
dependencies, including cups, foomatic-db, foomatic-db-hpijs,
foomatic-db-engine and sane.

    # pacman -S hplip
    # hp-setup 192.168.1.111

In dialogs from hp-setup you can leave the defaults. The model in
printer name is by default set to 2570 and you can rename it to 2575 if
you want to. After hp-setup is finished, both printer and scanner should
work. It is probably wise to ensure your printer/scanner always has this
same IP address, you can set this in your router DHCP server settings or
set the printer to static IP address via its web interface.

If hp-setup ask for qt4 and you don’t want to install it. Just try to
add the « -i » option to hp-setup.

Optionally install pyqt for graphical frontend before you run hp-setup
and to enable HP Device Manager for monitoring and controlling your
printer/scanner after install. In this case, you will also have to allow
temporal usage of your X session for other users, namely for root:

    $ xhost +localhost
    $ su
    # pacman -S pyqt3
    # hp-setup 192.168.1.111
    # exit
    $ xhost -localhost

Setup method without hplip
--------------------------

> Install foomatic and cups packages

The following packages will need to be installed: foomatic-db-engine
foomatic-db-ppd foomatic-filters cups

    # pacman -S foomatic-db-engine foomatic-db-ppd foomatic-filters cups

After installing packages, start the CUPS daemon by running

    # /etc/rc.d/cupsd start

Restart CUPS if the foomatic packages weren't installed and CUPS was
already installed and running.

> Configure the printer in CUPS

Download the HP-PhotoSmart_2570-hpijs.ppd and save to a place you can
access easily.

If you use KDE, I recommend using its interface. Run

    $ kcmshell printers

and go through the dialog. You can also access the dialog by running

    $ kprinter

and clicking the wand that says "Add printer..."

If you prefer, go through the CUPS configurator. This doesn't do quite
as much probing, but will get the job done. If you need your printer's
IP address, on the printer itself, hit setup, Network, View Network
Settings, Display Wired Summary. The port should be TCP 9100.

Testing and troubleshooting
---------------------------

If you installed everything the test page should print correctly and you
are good to go!

Test scanner with:

    $ scanimage -L

You should get output like:

    device `hpaio:/net/Photosmart_2570_series?ip=192.168.1.111' is a Hewlett-Packard Photosmart_2570_series all-in-one

If only root can find scanner, make sure you are member of scanner
group. If even root cannot find it, make sure hpaio is enabled (not
commented out) in /etc/sane.d/dll.conf

--Erroneous 01:06, 19 February 2007 (EST)

Retrieved from
"https://wiki.archlinux.org/index.php?title=HP_Photosmart_2575&oldid=196838"

Category:

-   Printers
