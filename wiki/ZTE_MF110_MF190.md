ZTE MF110/MF190
===============

  

  Summary
  ------------------------------------
  Tutorial to use ZTE modem in Arch.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Switch from CD mode to modem mode on the device                    |
| -   3 Disable CD mode on the device                                      |
| -   4 Disable CD mode on the device with wvdial                          |
| -   5 Setup udev rules                                                   |
| -   6 Create a wvdial configuration                                      |
| -   7 Connect to the internet                                            |
| -   8 Acknowledgements                                                   |
+--------------------------------------------------------------------------+

Introduction
------------

See also USB 3G Modem.

The ZTE MF110 / MF190 is a USB modem which combines 3G+/3G with
EDGE/GPRS in one compact device. It has an integrated micro-SD card
reader. It can send data at speeds up to 4.5 Mbps on 3G+ networks and
receive data at speeds of up to 7.2 Mbps.

Switch from CD mode to modem mode on the device
-----------------------------------------------

When you first plug the device, it is identified as a USB SCSI CDROM.
You can find out the name of the device by using this:

    [user@mypc] dmesg | tail
    [ 6102.172283] usb 1-5: new high-speed USB device number 4 using ehci_hcd
    [ 6102.300560] scsi24 : usb-storage 1-5:1.0
    [ 6103.302591] scsi 24:0:0:0: CD-ROM            ZTE      USB SCSI CD-ROM  2.31 PQ: 0 ANSI: 0
    [ 6103.305000] sr1: scsi-1 drive
    [ 6103.305422] sr 24:0:0:0: Attached scsi CD-ROM sr1

The dongle is identified this way:

    [user@mypc]$ lsusb | grep -i zte
    Bus 001 Device 005: ID 19d2:0150 ZTE WCDMA Technologies MSM

The easiest way to switch to modem mode is by ejecting the CDROM.

    eject /dev/sr1

After that, the led will turn off. A few seconds later, it will turn on
again and it will be identified as modem by the kernel:

    [user@mypc]$ lsusb | grep -i zte
    Bus 001 Device 005: ID 19d2:0124 ZTE WCDMA Technologies MSM

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

    # Is this the actual modem?
    SUBSYSTEM=="usb", SYSFS{idProduct}=="0124", SYSFS{idVendor}=="19d2", GOTO="ZTE_Modem"

    # Is this the ZeroCD device?
    SUBSYSTEM=="usb", SYSFS{idProduct}=="0150", SYSFS{idVendor}=="19d2", GOTO="ZTE_ZeroCD"

    LABEL="ZTE_Modem"
    # This is the Modem part of the card, let's load usbserial with the correct vendor and product ID's so we get our usb serial devices
    RUN+="/sbin/modprobe usbserial vendor=0x19d2 product=0x0124",
    # Make users belonging to the dialout group able to use the usb serial devices.
    MODE="660", GROUP="network"
    GOTO="ZTE_End"

    LABEL="ZTE_ZeroCD"
    # This is the ZeroCD part of the card, remove the usb_storage kernel module so it does not get treated like a storage device
    #RUN+="/sbin/rmmod usb_storage"
    RUN+="/usr/bin/eject /dev/sr1"

Honestly, I didn't make it work, although apparently is OK.

Create a wvdial configuration
-----------------------------

Wvdial is an easy-to-use frontend to PPPd. The configuration is fairly
easy to comprehend. Make sure you replace the /dev/ttyUSB2 line with the
node that your USB modem is connected to, you can see that with dmesg.
Save as /etc/wvdial.conf.

    [Dialer Defaults]

    ; Disable usb CDROM
    ; Init1 = AT+ZCDRUN=8

    ; Enable usb CDROM
    ; Init1 = AT+ZCDRUN=9

    Modem = /dev/ttyUSB2
    Modem Type = Analog Modem
    ISDN = 0
    Baud = 7200000
    Dial Attempts = 3
    Username = MOVISTAR
    Password = MOVISTAR
    APN = movistar.es
    Phone = *99***# 
    Auto Reconnect = off
    Stupid Mode = 1
    Init1 = AT+CPIN=YOUR PIN HERE!
    Init2 = ATZ
    Init6 = AT+CGEQMIN=1,4,64,640,64,640
    Init7 = AT+CGEQREQ=1,4,64,640,64,640

Connect to the internet
-----------------------

Now just run wvdial to connect

    # wvdial

If you see output reporting your PPP local and endpoint IP addresses,
then it worked.

Acknowledgements
----------------

Thanks to the following web pages that gave me all this information:

       * http://blog.ufsoft.org/zte-mf622-usb-modem-under-linux
       * https://wiki.archlinux.org/index.php/ZTE_MF626_/_MF636
       * http://wiki.bandaancha.st/APN_de_las_operadoras_para_configurar_el_módem_de_Internet_móvil_3G

Retrieved from
"https://wiki.archlinux.org/index.php?title=ZTE_MF110/MF190&oldid=240654"

Category:

-   Modems
