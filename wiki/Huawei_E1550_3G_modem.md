Huawei E1550 3G modem
=====================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Prepare device                                                     |
|     -   2.1 Switch into modem mode                                       |
|     -   2.2 Driver loading                                               |
|     -   2.3 Optional: device naming                                      |
|                                                                          |
| -   3 Connecting internet                                                |
| -   4 AT commands                                                        |
| -   5 Sending SMS                                                        |
| -   6 USSD Requests                                                      |
| -   7 Success Stories                                                    |
| -   8 References                                                         |
+--------------------------------------------------------------------------+

Introduction
------------

This article describes how to configure Huawei E1550 3G modems.

This modem is generic modem device, but there are two kludges:

-   you need to switch it into modem mode
-   you need to load proper driver (usbserial)

Prepare device
--------------

> Switch into modem mode

By default kernel recongnizes it as usb-storage device (SCSI CD-ROM). It
is true, because of this modem contains MicroSD card (up to 4Gb) reader
and internal flash.

To switch modem on you shoud run

    $ /lib/udev/usb_modeswitch --vendor 0x12d1 --product 0x1446 --type option-zerocd

command.

See also usb_modeswitch package in [community], which you may need in
future since in udev-157 modem-modeswitch has been renamed and changed
as described in the commit. This package does not need any
modifications, just install it.

Also you can create udev's config:
/etc/udev/rules.d/15-huawei-e1550.rules

     SUBSYSTEM=="usb", SYSFS{idProduct}=="1446", SYSFS{idVendor}=="12d1", RUN+="/lib/udev/usb_modeswitch --vendor 0x12d1 --product 0x1446 --type option-zerocd"

After that, modem changes its USB IDs to 12d1:140c and
/proc/bus/usb/devices shows new USB endpoints.

> Driver loading

usbserial is proper driver for this modem, but probably it does not
recognize it, so you shold force it, passing USB IDs.

     # modprobe usbserial vendor=0x12d1 product=0x140c

or put options into /etc/modprobe.d/modprobe.conf

     options usbserial vendor=0x12d1 product=0x140c

(do not forget to 'rmmod usbserial' if it is already loaded before)

> Optional: device naming

You can rename ttyUSB port using following udev rules:

     UBSYSTEMS=="usb", ATTRS{modalias}=="usb:v12D1p1001*", KERNEL=="ttyUSB*", ATTRS{bInterfaceNumber}=="00", ATTRS{bInterfaceProtocol}=="ff", NAME="ttyUSB_utps_modem"
     SUBSYSTEMS=="usb", ATTRS{modalias}=="usb:v12D1p1001*", KERNEL=="ttyUSB*", ATTRS{bInterfaceNumber}=="01", ATTRS{bInterfaceProtocol}=="ff", NAME="ttyUSB_utps_diag"
     SUBSYSTEMS=="usb", ATTRS{modalias}=="usb:v12D1p1001*", KERNEL=="ttyUSB*", ATTRS{bInterfaceNumber}=="02", ATTRS{bInterfaceProtocol}=="ff", NAME="ttyUSB_utps_pcui"

     SUBSYSTEMS=="usb", ATTRS{modalias}=="usb:v12D1p1003*", KERNEL=="ttyUSB*", ATTRS{bInterfaceNumber}=="00", ATTRS{bInterfaceProtocol}=="ff", NAME="ttyUSB_utps_modem"
     SUBSYSTEMS=="usb", ATTRS{modalias}=="usb:v12D1p1003*", KERNEL=="ttyUSB*", ATTRS{bInterfaceNumber}=="01", ATTRS{bInterfaceProtocol}=="ff", NAME="ttyUSB_utps_pcui"

Connecting internet
-------------------

Now you have new 2 or 3 /dev/ttyUSB* devices.Most likely first of them
(ttyUSB0 if you had not such devices before) is PPP compatible modem.
Use it as usual with pppd, kppp, gnome-ppp, network-manager, etc.

Note: If you want to use your 3G modem with network-manager, you have to
install the package modemmanager (it's in the extra repository) and then
restart the networkmanager (usually /etc/rc.d/networkmanager restart).
Now you can 'Enable Mobile Broadband' in your networkmanager applet in
GNOME

AT commands
-----------

There are some usefull commands:

-   AT^U2DIAG=0 - the device is only Modem
-   AT^U2DIAG=1 - device is in modem mode + CD ROM
-   AT^U2DIAG=255 - the device in modem mode + CD ROM + Card Reader
-   AT^U2DIAG=256 - the device in modem mode + Card Reader
-   AT+CPIN=<PIN-CODE> - enter PIN-code
-   AT+CUSD=1,<PDU-encoded-USSD-code>,15 - USSD request, result can be
    found (probably) in /dev/ttyUSB2.

Encode "*100#" to PDU format:

     perl -e '@a=split(//,unpack("b*","*100#")); for ($i=7; $i < $#a; $i+=8) { $a[$i]="" } print uc(unpack("H*", pack("b*", join("", @a))))."\n"'

Decode "AA180C3602" from PDU format:

     perl -e '@a=split(//,unpack("b*", pack("H*","AA180C3602"))); for ($i=6; $i < $#a; $i+=7) {$a[$i].="0" } print pack("b*", join("", @a)).""'

Answer decoding (this example is balance response: 151.25):

     perl -e 'print pack("H*", "003100350031002C003200350020044004430431002E0020");'

Some operators return USSD result in PDU encoding, so you should check
proper decoding method.

-   AT+CSQ - get signal quality (AT+CSQ=?)
-   AT+GMI - get manufacturer
-   AT+GMM - get model
-   AT+GMR - get revision
-   AT+GMN - get IMEI
-   AT+COPS? - get operator info
-   AT^CARDLOCK="NCK-code" - unlock modem. NCK-code should be calculated
    by IMEI. After that modem can work with any GSM-provider.
-   AT^SYSCFG=mode, order, band, roaming, domain - System Config

Mode:

-   2 Automatic search
-   13 2G ONLY
-   14 3G ONLY
-   16 No change

Order:

-   0 Automatic search
-   1 2G first, then 3G
-   2 3G first, then 2G
-   3 No change

Band:

-   80 GSM DCS systems
-   100 Extended GSM 900
-   200 Primary GSM 900
-   200000 GSM PCS
-   400000 WCDMA IMT 2000
-   3FFFFFFF Any band
-   40000000 No change of band

Roaming:

-   0 Not supported
-   1 Roaming is supported
-   2 No change

Domain:

-   0 CS_ONLY
-   1 PS_ONLY
-   2 CS_PS
-   3 ANY
-   4 No change

Sending SMS
-----------

You can use gammu.

Edit ~/.gammurc

     [gammu]
     port=/dev/ttyUSB0
     connection=at
     name=huawei e1550
     model=

The run command:

     gammu sendsms TEXT +7123456789 -text qwe

USSD Requests
-------------

Use huawei-ussd package. Or use ussd.php tool.

Success Stories
---------------

2010-August-03: I didn't do anything, I just installed
usb_modeswitch-1.1.3-2 and my kernel is 2.6.33. In the syslog
(/var/log/messages.log) the usb_modeswitch can automatically configure
the modem correctly but I still cannot connect to the internet using
gnome network manager applet, then I installed the modemmanager package
and restart the networkmanager service. Everything is working properly
now.

References
----------

-   USB_3G_Modem
-   Huawei_E220

Retrieved from
"https://wiki.archlinux.org/index.php?title=Huawei_E1550_3G_modem&oldid=207409"

Category:

-   Modems
