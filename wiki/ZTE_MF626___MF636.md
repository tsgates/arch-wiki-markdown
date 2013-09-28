ZTE MF626 / MF636
=================

  

  Summary
  ------------------------------------
  Tutorial to use ZTE modem in Arch.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Disable CD mode on the device                                      |
| -   3 Disable CD mode on the device with wvdial                          |
| -   4 Setup udev rules                                                   |
| -   5 Create a wvdial configuration                                      |
| -   6 Create a wvdial configuration (extracted from sakis3g, the above   |
|     config didn't work for me)                                           |
| -   7 Connect to the internet                                            |
| -   8 Tips & Tricks                                                      |
| -   9 Acknowledgements                                                   |
+--------------------------------------------------------------------------+

Introduction
------------

See also USB 3G Modem.

The ZTE MF626 / MF636 is a USB modem which combines 3G+/3G with
EDGE/GPRS in one compact device. It has an integrated micro-SD card
reader. It can send data at speeds up to 4.5 Mbps on 3G+ networks and
receive data at speeds of up to 7.2 Mbps.  It is also known as the
Rogers (Canadian cellular carrier) red stick USB dongle.

Disable CD mode on the device
-----------------------------

Using a Windows machine, plug in the USB device and go through the short
install wizard. Once done, close the Rogers app that starts up, then
head into the Device Manager (Control Panel -> System -> Hardware ->
Device Manager). Under the Ports section, find the COM port that's
connected to the USB modem (ignore the Diagnostics mode). Connect to
that COM port through Hyperterminal, found in the Accessories area of
the Start Menu. Connection parameters are:

    Bits per Second: 115200
    Data bits: 8
    Parity: None
    Stop bits: 1
    Flow Control: None

Once connected, type the following commands:

    AT+ZOPRT=5
    AT+ZCDRUN=8

This tells the modem not to use CD mode when it's first plugged into a
computer. Now exit Hypterterminal and remove the USB modem. You're done
with Windows.

Disable CD mode on the device with wvdial
-----------------------------------------

First remove usb-storage then modprobe usbserial

    rmmod usb_storage
    modprobe usbserial

Edit /etc/wvdial.conf :

    [Dialer Defaults]
    Modem = /dev/ttyUSB0
    Modem Type = Analog Modem
    ISDN = 0
    Init1 = AT+ZOPRT=5
    Init2 = AT+ZCDRUN=8

Run wvdial, it should use those commands and fail to connect.

Once it exits, unplug the stick and plug it back in and it should be
seen as a modem.

Setup udev rules
----------------

Create a file /etc/udev/rules.d/90-zte.conf that contains the following:

    ACTION!="add", GOTO="ZTE_End"
    SUBSYSTEM=="usb", SYSFS{idProduct}=="0031", SYSFS{idVendor}=="19d2", GOTO="ZTE_Modem"
    GOTO="ZTE_End"

    LABEL="ZTE_Modem"
    RUN+="/sbin/modprobe usbserial vendor=0x19d2 product=0x0031", MODE="660", GROUP="network"
    LABEL="ZTE_End"

Create a wvdial configuration
-----------------------------

Wvdial is an easy-to-use frontend to PPPd. The configuration is fairly
easy to comprehend. This one is probably longer than it needs to be, but
I'll include it all. Make sure you replace the /dev/ttyUSB0 line with
the node that your USB modem is connected to, you can see that with
dmesg. Save as /etc/wvdial.conf.

    [Dialer Defaults]
    Modem = /dev/ttyUSB0
    ISDN = off
    Modem Type = USB Modem
    Baud = 7200000
    Init = ATZ
    Init2 =
    Init3 =
    Init4 =
    Init5 =
    Init6 =
    Init7 =
    Init8 =
    Init9 =
    Phone = *99#
    Phone1 =
    Phone2 =
    Phone3 =
    Phone4 =
    Dial Prefix =
    Dial Attempts = 1
    Dial Command = ATM1L3DT
    Ask Password = off
    Password = off
    Username = na
    Auto Reconnect = off
    Abort on Busy = off
    Carrier Check = off
    Check Def Route = off
    Abort on No Dialtone = off
    Stupid Mode = on
    Idle Seconds = 0
    Auto DNS = on

Create a wvdial configuration (extracted from sakis3g, the above config didn't work for me)
-------------------------------------------------------------------------------------------

This is for Etisalat Misr, but I imagine it should work for all the
other networks that use the same stick.

    [Dialer Defaults]
    Modem = /dev/ttyUSB2
    Modem Type = Analog Modem
    ISDN = 0
    Baud = 7200000
    Dial Attempts = 3
    Username = apn
    Password = apn
    Phone = *99#
    Auto Reconnect = off
    Stupid Mode = 1
    Init1 = ATZ
    Init6 = AT+CGEQMIN=1,4,64,640,64,640
    Init7 = AT+CGEQREQ=1,4,64,640,64,640

Connect to the internet
-----------------------

Now just run wvdial to connect

    # wvdial

If you see output reporting your PPP local and endpoint IP addresses,
then it worked.

==

Tips & Tricks
-------------

All steps above may be obsolete if the modem stick is supported by
sakis3g which is an all in one command line script and automatises all
the steps above. The installation steps are as follows:

    wget "http://www.sakis3g.org/versions/latest/$ARCH/sakis3g.gz" # where $ARCH is either i386 or amd64
    gunzip sakis3g.gz
    chmod +x sakis3g
    ./sakis3g --interactive

Acknowledgements
----------------

Thanks to the following webpages that gave me all this information:

       * http://www.zeroflux.org/blog/post/255
       * http://www.matt-barrett.com/?p=5
       * http://ubuntuforums.org/showthread.php?t=1005910
       * http://ubuntuforums.org/showthread.php?t=1065934

Retrieved from
"https://wiki.archlinux.org/index.php?title=ZTE_MF626_/_MF636&oldid=234319"

Category:

-   Modems
