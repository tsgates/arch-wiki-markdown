USB 3G Modem
============

A number of mobile telephone networks around the world offer mobile
internet connections over UMTS (or EDGE or GSM) using a portable USB
modem device.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Remove the PIN                                                     |
| -   2 Device identification                                              |
| -   3 Mode switching                                                     |
| -   4 Connection                                                         |
|     -   4.1 Network Manager                                              |
|     -   4.2 wvdial                                                       |
|     -   4.3 sakis3g                                                      |
|     -   4.4 Low connection speed                                         |
|         -   4.4.1 QoS parameter                                          |
|         -   4.4.2 Baud parameter                                         |
|                                                                          |
|     -   4.5 Monitor used bandwith                                        |
|                                                                          |
| -   5 Reading SMS                                                        |
|     -   5.1 command line script                                          |
|                                                                          |
| -   6 Fix image quality                                                  |
| -   7 Related Articles                                                   |
+--------------------------------------------------------------------------+

Remove the PIN
--------------

First of all use your SIM card in a normal phone and disable the PIN
request if present. If the SIM card asks the PIN wvdial won't work.

Device identification
---------------------

Install usbutils

    pacman -S usbutils

and then examine the output of

    $ lsusb

which will show the vendor and product IDs of the device. Note that some
devices will show two different product IDs at different times as
explained below.

Mode switching
--------------

Often these devices will have two modes (1) USB flash memory storage (2)
USB Modem. The first mode, sometimes known as ZeroCD, is often used to
deliver an internet communications program for another operating system
and is generally of no interest to Linux users. Additionally some have a
slot into which the user can insert an additional flash memory card.

A useful utility for switching these devices into modem mode is
usb_modeswitch, available in [community]:

    pacman -S usb_modeswitch

Udev rules are supplied with the package in
/lib/udev/rules.d/40-usb_modeswitch.rules. This contains entries for
many devices, which it will switch to modem mode upon insertion.

When a device is switched, its product ID may change to a different
value. The vendor ID will remain unchanged. This can be seen in the
output of lsusb.

Some devices are supported in the USB serial kernel module called
"option" (after the Option devices, but not limited to just those) and
may be used without usb_modeswitch.

Udev itself included a utility called /lib/udev/modem-modeswitch. In
udev 157 this was renamed to /lib/udev/mobile-action-modeswitch and
morphed into a tool that only switches Mobile Action cables. For other
devices use usb_modeswitch.

Note:You can find an alternative way to do this base on eject command
here.

Connection
----------

> Network Manager

After installing usbutils and usb_modeswitch you just need to install
modemmanager to make the modem work with NetworkManager:

    # pacman -S modemmanager

After you restart the NetworkManager-applet and plug the modem in again
NetworkManager should recognize the modem in the menu without further
configuration. Setting up the modem in NetworkManager is
self-explanatory, you should only need the login-information provided by
your network provider.

> wvdial

See main article: wvdial

The general procedure is to switch the device into modem mode, make sure
the ttyUSB device(s) are recognized by the usbserial kernel module, and
then to run wvdial to dial, connect and start pppd.

Install wvdial

    # pacman -S wvdial

The configuration file /etc/wvdial.conf will in general depend on (a)
which device you have (b) which mobile network you are connecting to. A
single wvdial.conf file can be defined with named sections to be usable
with several USB modems and networks, should you need them.

Run (as root)

    # wvdialconf

which will attempt to write /etc/wvdial.conf correctly. You will need to
add the user, password and Access Point Name (APN). You can obtain these
(i) from your network provider, (ii) from other users via published
wvdial.confs, or (iii) by logging the USB tty traffic under another
operating system (Sysinternals' Portmon).

A typical /etc/wvdial.conf looks like this:

    [Dialer Defaults]
    Init1 = ATZ
    Init2 = ATQ0 V1 E1 S0=0 &C1 &D2 +FCLASS=0
    Modem Type = Analog Modem
    ISDN = 0
    Modem = /dev/ttyUSB2
    Baud = 9600

    [Dialer thenet]
    Phone = *99***1#
    Username = thenetuser
    Password = thenetpw
    ; Username = 9180****** (If your provider use without Username)
    ; Password = 9180****** (If your provider use without Password)
    Stupid Mode = 1
    Baud = 460800
    Init3 = AT+CGDCONT=1,"IP","apn.thenet.net"

    [Dialer mypin]
    Init4 = AT+CPIN=1234

  

Often there will be several devices (at /dev/ttyUSB0, /dev/ttyUSB1,
/dev/ttyUSB2 for example). If in doubt about which to use, try each of
them in turn or use /dev/gsmmodem (a link set up by usb_modeswitch)
which should point to the correct one. Once the configuration files are
prepared, the internet connection is established by running

    $ wvdial <section>

If necessary additional setup commands can be placed in a simple script
like this:

    usb_modeswitch
    sleep 2
    modprobe usbserial vendor=0xVVVV product=0xMMMM maxSize=4096
    sleep 2
    wvdial thenet

where VVVV is the hexadecimal vendor ID from lsusb, MMMM is the
hexadecimal product ID when in modem mode, and "thenet" is the name of
the section in wvdial.conf which you wish to use. The maxSize option may
or may not be necessary. It simplifies matters if you disable the SIM
PIN, but if you require it, run "wvdial mypin" before "wvdial thenet".

The final wvdial command should start pppd and the obained IP address
should be visible in the terminal output. At that point the internet
connection should be live, which can be easily checked with a web
browser or by pinging an external IP address.

> sakis3g

There may be the chance that the modem stick is supported by sakis3g
which is an all in one command line script and automatises all the steps
above. The installation steps are as follows:

    wget "http://www.sakis3g.org/versions/latest/$ARCH/sakis3g.gz" # where $ARCH is either i386 or amd64
    gunzip sakis3g.gz
    chmod +x sakis3g
    ./sakis3g --interactive

or you could simply install it from aur:

    https://aur.archlinux.org/packages.php?ID=59017

Since sakis3g.org is no longer up, you need to download it from here and
extract it.

    http://sourceforge.net/projects/vim-n4n0/files/sakis3g.tar.gz/download

> Low connection speed

Someone claims that the connection speed under linux is lower than
Windows. https://bbs.archlinux.org/viewtopic.php?id=111513

A short summary for possible solutions which are not fully verified. In
most of conditions, the low speed is caused by bad receiver signals and
too many people in cell. But you still could use the following method to
try to improve the connection speed.

QoS parameter

AT+CGEQMIN and AT+CGEQREQ command could used to set the Qos command. And
also it should be possible to used to decrease and limit the connect
speed. Add the following Init command in wvdial.conf.

    Init6 = AT+CGEQMIN=1,4,64,640,64,640
    Init7 = AT+CGEQREQ=1,4,64,640,64,640

Baud parameter

Baud parameter in wvdial.conf could be used to increase the connection
speed.

    Baud = 460800

But the official Huawei E261 windows application set the Baud=9600 under
Windows Vista. More verifications are needed to double check this point.

> Monitor used bandwith

Frequently a 3G connection obtained via a mobile phone operator comes
with restricted bandwidth, so that you are only allowed to use a certain
bandwidth per time (e.g. 1GB per month). While it is quite
straight-forward to know which type of network applications are pretty
bandwidth extensive (e.g. video streaming, gaming, torrent, etc.), it
may be difficult to keep an overview about overall consumed bandwidth.

A number of tools are available to help with that. Two console tools are
vnstat, which allows to keep track of bandwith over time, and iftop to
monitor bandwidth of individual sessions. If you are a KDE user, KNemo
might help. All are available in the community repository.

Reading SMS
-----------

This was tested on a Huawei EM770W (GTM382E) 3g card integrated into an
Acer Aspire AS3810TG laptop.

    $ pacman -S gnokii
    $ mkdir -p $XDG_CONFIG_HOME/gnokii

(usually ~/.config/gnokii)

    $ cp /etc/gnokiirc ~/.config/gnokii/config

edit ~/.config/gnokii/config as follows:

    port = /dev/ttyUSB0

You may have to use a different port depending on your config, i.e.
/dev/ttyUSB1 or something else.

    model = AT
    connection = serial

You need to be part of the uucp group to use /dev/ttyUSB0, for example
if your user is called "x" and assuming you have sudo rights:

    $ sudo gpasswd -a x uucp
    $ newgrp uucp

The newgrp command allows you to take advantage of the new group
assignment immediately without having to logout/login.

Then launch gnokii:

    $ xgnokii

Click on the "SMS" icon button, a window opens up. Then click:
"messages->activate sms reading". Your messages will show up in the
window.

> command line script

A small command line script using gnokii to read SMS on your SIM card
(not phone memory) without having to start a GUI:

    $  gnokii --getsms SM 0 end 2>&1|grep Text -A1 -B3|grep -v Text

What it does:

    gnokii # invoke gnokii
    --getsms SM 0 end # read SMS from SM-memory location (=SIM card) starting at 0 and reading all occupied memory locations ("end")
    2>&1 # connect STDERR to STDOUT to make sure the output from the --getsms command can be piped to grep
    |grep Text # pipe output from gnokii to grep, anchoring at output containing "Text"
    -A1 -B3 # print one line after the matched pattern and three lines before the matched pattern
    |grep -v Text # grep result to another grep to exclude the "Text" line (-v for inverting the pattern)

Granted this doesn't work very well if your SMS contains the word
"Text", but you may adapt the script to your liking.

Fix image quality
-----------------

If you're getting low quality images while browsing the web over a
mobile broadband connection with the hints "shift+r improves the quality
of this image" and "shift+a improves the quality of all images on this
page", follow these instructions:

    pacman -Sy tinyproxy

Edit /etc/tinyproxy/tinyproxy.conf and insert the following two lines:

    AddHeader "Pragma" "No-Cache"
    AddHeader "Cache-Control" "No-Cache"

Start tinyproxy:

    /etc/rc.d/tinyproxy start

Configure your browser to use localhost:8888 as a proxy server and
you're all done. This is especially useful if you're using, for example,
Google Chrome which, unlike Firefox, doesn't allow you to modify the
Pragma and Cache-Control headers.

Related Articles
----------------

Huawei E220  
 Allow users to dial with wvdial  
 Idea_netsetter(Huawei_EG162G)  
 ZTE MF110/MF190  
 ZTE MF636  
 Internet key Momo Design  
 Dialup_without_a_dialer_HOWTO  
 3G and GPRS modems with pppd alone  
 Huawei E1550 3G modem  
 Huawei E173s

Retrieved from
"https://wiki.archlinux.org/index.php?title=USB_3G_Modem&oldid=254360"

Category:

-   Modems
