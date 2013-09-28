Huawei E220
===========

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Plugging In                                                        |
|     -   2.1 Quick Start                                                  |
|         -   2.1.1 Easy Install using Network Manager                     |
|         -   2.1.2 Scripting                                              |
|         -   2.1.3 Bare Naked                                             |
|         -   2.1.4 Configure n' Dial                                      |
|         -   2.1.5 If using PIN code add this before Init2                |
|                                                                          |
|     -   2.2 Slow Start                                                   |
|                                                                          |
| -   3 Extras                                                             |
|     -   3.1 Port Testing                                                 |
|                                                                          |
| -   4 Troubleshooting                                                    |
|     -   4.1 Hal                                                          |
|     -   4.2 Route                                                        |
|                                                                          |
| -   5 Links                                                              |
+--------------------------------------------------------------------------+

Introduction
============

Marketed by various telecommunications companies in several countries,
the E220 is a 3.5G HSDPA USB modem used mainly for wireless Internet
access via mobile telephony networks. Technically it is a modem, USB and
(due to the CDFS format) CD-ROM device. With a kernel version older than
2.6.20, getting Linux to recognize the device as a modem and accessing
its functions requires a workaround.

"Linux kernel versions prior to 2.6.20 have some problems with it, as
the SCSI CDROM fakevolume with drivers for Microsoft systems gets
automounted by usbstorage.ko module, preventing serial device
/dev/ttyUSB0 from working properly."

However, as support for it was added in 2.6.20 via modules usb-storage
and usbserial, getting it to work is as simple as plugging it in and
dialling up (the above statement is of no concern to us as we can load
and unload modules at will, it was probably meant for pre-packaged GNU
and Linux distributions). In fact, using the modem under Linux proves to
be more reliable as there are no uncalled-for disconnections. This is
probably due to the fact that we are communicating directly with the
modem, whereas in Windows or Mac OS X drivers are installed on first run
(that is what the storage portion is for) and connection is achieved
through a thick software layer every time, leaving room for possible
interferences and conflicts.

Plugging In
===========

Archers do not use old stuff, let alone use old kernels. That is,
however, not enough reason to explain why in some cases the modem still
needs the workaround. Thus, you have to see for yourself if you are one
of the lucky ones. It almost seems as if the "support" in kernels >
2.6.20 is a myth, although that may be entirely incorrect (maybe it is
how Arch developers package the vanilla kernels in which case we have
only phrakkkture and gang to thank).

The magic (trick) lies in the kernel modules; udev rules, unloading,
blacklisting, reloading and loading things will get it done.

Quick Start
-----------

> Easy Install using Network Manager

If you are using network-manager then this modem should be plug 'n play.
I tested using Huawei E270, but since lsusb said that my modem is
E220/E270, I assume it is the same. (Note: You can follow these
instructions too if lsusb detects your Huawei E180 as E220.)

The required packages are modemmanager and network-manager-applet from
extra. Install them if you haven't.

Start the networkmanager daemon from rc.conf or manually using
/etc/rc.d/networkmanager start. Start the nm-applet if it hasn't started
yet. Make sure the modem is connected; I used a cable with two usb port
like the one for an external harddrive. Then, from nm-applet add a
Mobile Broadband config via 'Edit Connections...'. Set the config
according your network; usually apn, username, and password.

Activate the connection by choosing it on the Network Manager applet. If
it is not showing up, unplug and plug in the modem again to refresh the
connection. Now you should see it listed in the Network Manager applet.
Click on it and it will try to connect. Once connected, the icon will
change. You're good to go then.

  
 For Vodafone brands of this device, you can use vodafone-mccd which is
the Vodafone Mobile Connect Card Driver for Linux. The official name is
very long, yes.

> Scripting

If you have UDEV and HAL set up right but do not want extra bulk like an
entire package (yeah right as if it adds a GiB full of stuff), then have
no fear - bash is here. You can have my custom "installer" which
incorporates everything including the HAL and UDEV rules. You can change
the default installation of stuff to /usr instead of /usr/local if you
want. Well, you can change anything if you want (or can). Download the
tar archive and then extract it and pwn it:

    $ tar xf huawei-e220.tar.gz
    $ cd huawei-e220
    $ nano setup.sh # if you want to
    # ./setup.sh

Enjoy me lad!

> Bare Naked

You can just try Plug 'n Dial first to see if it works (I will give you
free beer if it does!). After hooking up to the USB port (some say an
upright position is best; let it hang over the edge of the desk), check
to make sure it is detected.

    $ cat /proc/bus/usb/devices

You should see Huawei somewhere there. If not, you are on your own. The
usb-storage and/or usbserial modules must be loaded, whether manually or
by HAL is up to you and/or your system.

    # modprobe usb-storage
    # modprobe usbserial
    $ sleep 6 # the modem may take a while to initialize
    $ ls /dev/ttyUSB*

You should see three renditions of ttyUSB. If not, we will get to that
later. This is a "Quick Start" after all, no? The ports:

-   ttyUSB0 - Modem
-   ttyUSB1 - USB?
-   ttyUSB2 - Nothing

Now you need a dialler. Most convenient of all would be wvdial, so
install it. You should have ppp already, if not just pull them both in.

    # pacman -S wvdial ppp

> Configure n' Dial

Most SIM and data services provided together with the device do not
require special settings and work with similar configuration to get
connected. They are almost "Plug n' Play", a special trait of Linux.
Edit /etc/wvdial.conf and use something like the following:

    [Dialer hsdpa]
    Phone = *99***16#
    Username = 65
    Password = user123
    Stupid Mode = 1
    Dial Command = ATDT
    Modem = /dev/ttyUSB0
    Baud = 460800
    Init2 = ATZ
    Init3 = ATQ0 V1 E1 S0=0 &C1 &D2 +FCLASS=0
    ISDN = 0
    Modem Type = Analog Modem

For providers that do require a specific Init string and user/password
combination, mkwvconf-git in AUR can help generate a wvdial
configuration (based on the mobile-broadband-provider-info-git package).

> If using PIN code add this before Init2

     Init1 = AT+CPIN=9999

where 9999 is changed for your PIN-code

There is an example here by a "Linux Guru". Then load the PPP module.

    # modprobe ppp-generic

You can now connect immediately, but probably only as root, which is not
a disadvantage.

    # wvdial hsdpa

Slow Start
----------

Edit: This section is nullified if you have UDEV and HAL workarounds, or
a script, or a package from AUR.  

So why then? Well, for some reason those of us on newer kernels still
have to ride the old ways. In some cases, all that is needed to be done
is to remove the usb-storage module first, then load usbserial with the
device IDs. The first cat command on this page will have that
information, while lsusb is an alternative. Anyhow, the IDs are the same
for almost all E220s, so you can copy wholesale.

    # modprobe -r usb-storage usbserial
    # modprobe usbserial vendor=0x12d1 product=0x1003

In other cases, where the option module gets autoloaded for use by
usbserial, you just have to blacklist it in rc.conf:

    MOD_BLACKLIST=(option) 

When you cannot salvage anything from this either, you have to go Gentoo
and compile something. Do not worry, it is only a script and we do
things like this almost everyday, albeit in bash.

    $ mkdir ~/huawei-e220 && cd ~/huawei-e220
    $ wget http://www.kanoistika.sk/bobovsky/archiv/umts/huaweiAktBbo.c
    $ gcc -lusb -o e220 *.c
    # ./e220

This gets around the kernel to recognize the modem functionalities of
the device. You can now carry on and connect using the above methods. If
you had to follow this step, you will always need the script unless you
set udev rules and such (package link below). So move it to a global
PATH.

    $ cd ~/huawei-e220
    # mv e220 /usr/bin/e220

Now it is easier.

Extras
======

Note: It seems some people get it to work using ttyUSB1, which should
not be the case, but rest assured that at least on recent kernels and
systems ttyUSB0 is the correct port to dial with.

Port Testing
------------

To check if the device is functioning alright on a particular serial
port, there is a program for probing serial devices.

    # pacman -S minicom

Now run it.

    # minicom -s

Change the serial port to /dev/ttyUSB1 and exit from the page, this will
open the main program. When it initializes the modem, issue the command
AT. The answer should be OK, which means the modem is working well on
that port.

Troubleshooting
===============

Hal
---

The hald daemon detects the SCSI CD-ROM drive and because of that it
will try to change the modem to storage mode. To prevent this you need
to create a Hal policy so it ignores the device.

Create a file the
/usr/share/hal/fdi/preprobe/20thirdparty/10-huawei-e220.fdi and putt
this in it

    <?xml version="1.0" encoding="UTF-8"?>
    <deviceinfo version="0.2">
      <device>
        <match key="usb.vendor_id" int="0x12d1"> 
          <match key="usb.product_id" int="0x1003"> 
            <merge key="info.ignore" type="bool">true</merge>
          </match>
        </match>
      </device>
    </deviceinfo>

With this, for my experience, only two USB serial ports are created and
them vodafone-mccd doesn't recognize correctly the modem but you can
connect correctly with wvdial.

Route
-----

If problem with connection through ppp0 one might need to add the
network manually:

     # ip route add ip route add 10.0.0.0/8 dev ppp0

if the remote adress starts on 10.

Then you add default route and dns as usually:

    # ip route add default via 10.x.x.x

(change to remote adress recieved and viewed with command ip a)

Links
=====

http://wwwu.uni-klu.ac.at/agebhard/HuaweiE220/  
 http://oozie.fm.interia.pl/pro/huawei-e220/  
 http://mybroadband.co.za/vb/showthread.php?t=21726  
 USB 3G Modem

Retrieved from
"https://wiki.archlinux.org/index.php?title=Huawei_E220&oldid=249631"

Category:

-   Modems
