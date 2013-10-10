Direct Modem Connection
=======================

> Summary

This article describes how one can connect directly to the Internet from
an Arch Linux box using an internal modem or external modem in bridge
mode.

> Related

Most users of external modems or those behind routers should consult the
Configuring Network article instead.

Due to a lack of developers for dialup issues, connecting Arch to the
Internet with a dialup line requires a lot of manual setup. If at all
possible, set up a dedicated router which can be used as a default
gateway on the Arch box.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Analog Modem                                                       |
| -   2 ISDN                                                               |
|     -   2.1 Install and Configure Hardware                               |
|     -   2.2 Install and configure the ISDN utilities                     |
|                                                                          |
| -   3 DSL (PPPoE)                                                        |
| -   4 Dial-up without a dialer                                           |
+--------------------------------------------------------------------------+

Analog Modem
------------

To be able to use a Hayes-compatible, external, analog modem, you need
to at least have the ppp package installed. Modify the file
/etc/ppp/options to suit your needs, following instructions located in
man pppd. You will need to define a chat script to supply your username
and password to the ISP after the initial connection has been
established. The manpages for pppd and chat have examples in them that
should suffice to get a connection up and running if you are up for it.
With udev, your serial ports usually are /dev/tts/0 and /dev/tts/1.

Tip:Read #Dial-up without a dialer.

Instead of fighting a glorious battle with the plain pppd, you may opt
to install wvdial or a similar tool to ease the setup process
considerably. In case you are using a so-called WinModem, which is
basically a PCI plugin card working as an internal analog modem, you
should indulge in the vast information found on the LinModem homepage.

ISDN
----

Setting up ISDN is done in three steps:

1.  Install and configure hardware.
2.  Install and configure the ISDN utilities.
3.  Add settings for your ISP.

> Install and Configure Hardware

The current Arch stock kernels include the necessary ISDN modules,
meaning that you will not need to recompile your kernel unless you are
about to use odd ISDN hardware. After physically installing your ISDN
card in your machine or plugging in your USB ISDN-Box, you can try
loading the kernel module. Nearly all passive ISDN PCI cards are handled
by the hisax module, which needs two parameters: type and protocol. You
must set protocol to:

-   '1' if your country uses the 1TR6 standard.
-   '2' if it uses EuroISDN (EDSS1).
-   '3' if you are hooked to a so-called leased-line without D-channel.
-   '4' for US NI1.

Details on all those settings and how to set them is included in the
kernel documentation, more specifically in the isdn subdirectory, and
available online. The type parameter depends on your card; a list of all
possible types can be found in the README.HiSax kernel documentation.
Choose your card and load the module with modprobe, using appropriate
options like this:

    # modprobe hisax type=18 protocol=2

This will load the hisax module for my ELSA Quickstep 1000PCI, being
used in Germany with the EDSS1 protocol. You should find helpful
debugging output in your /var/log/everything.log file, in which you
should see your card being prepared for action. Please note that you
will probably need to load some USB modules before you can work with an
external USB ISDN Adapter.

Once you have confirmed that your card works with certain settings, you
can add the module to /etc/modprobe.d/ so it will be loaded at startup:

    /etc/modprobe.d/isdn.conf

    alias ippp0 hisax
    options hisax type=18 protocol=2

That being done, you should have working, supported hardware. Now you
need the basic utilities to actually use it!

> Install and configure the ISDN utilities

Install the isdn4k-utils package, and read the manpage to isdnctrl, it
will get you started. Further down in the manpage you will find
explanations on how to create a configuration file that can be parsed by
isdnctrl, as well as some helpful setup examples. Please note that you
have to add your SPID to your MSN setting separated by a colon if you
use US NI1.

After you have configured your ISDN card with the isdnctrl utility, you
should be able to dial into the machine you specified with the PHONE_OUT
parameter, but fail the username and password authentication. To make
this work add your username and password to /etc/ppp/pap-secrets or
/etc/ppp/chap-secrets as if you were configuring a normal analogous PPP
link, depending on which protocol your ISP uses for authentication. If
in doubt, put your data into both files.

If you set up everything correctly, you should now be able to establish
a dial-up connection with:

    # isdnctrl dial ippp0

If you have any problems, remember to check the logfiles!

DSL (PPPoE)
-----------

These instructions are relevant to you only if your PC itself is
supposed to manage the connection to your ISP. You do not need to do
anything but define a correct default gateway if you are using a
separate router of some sort to do the grunt work.

Before you can use your DSL online connection, you will have to
physically install the network card that is supposed to be connected to
the DSL-Modem into your computer. After loading the appropiate kernel
module for your newly installed network card, you should install the
rp-pppoe package and run the pppoe-setup script to configure your
connection. After you have entered all the data, you can connect and
disconnect your line with

    # systemctl start adsl

and

    # systemctl stop adsl

respectively. The setup is usually easy and straightforward, but feel
free to read the manpages for hints.

If you want to automatically 'dial in' at boot, issue command

    # systemctl enable adsl

or

    # systemctl disable adsl

to remove auto 'dial in' at boot.

Dial-up without a dialer
------------------------

This page tells you how you can execute pppd directly without using
dialer software such as pon/poff, wvdial, kppp, etc. It stays connected
throughout X server shutdowns and is extremely simple, in accordance
with Arch philosophy.

-   Back up /etc/ppp/options

    # mv /etc/ppp/options /etc/ppp/options.old

-   Create new /etc/ppp/options using this template:

    lock
    modem
    debug
    </dev/DEVICE>
    115200
    defaultroute
    noipdefault
    user <USERNAME>
    connect 'chat -t60 \"\" ATZ OK ATX3 OK ATDT<NUMBER> CONNECT'

Replace </dev/DEVICE> with your modem device. For comparison with
another operating system device, take a good look at the next table,

    Windows        GNU/Linux
     COM1   -->   /dev/ttyS0
     COM2   -->   /dev/ttyS1
     COM3   -->   /dev/ttyS2
     ...

Edit to point device to your modem device, to use your dial-up account
username, and to dial your ISP's number after the ATDT. You can disable
call waiting using ATDT 70,15555555 (in North America, anyway). You may
also wish to edit the dialer commands; search for information on how to
do this. If your ISP uses CHAP, then the next file is chap-secrets.

-   Edit /etc/ppp/chap-secrets. See The PAP/CHAP secrets file for more
    details.

    "USERNAME" * "PASSWORD"

-   Now you are ready to connect. Connect (as root) using
    pppd /dev/modem (or whatever device your modem is connected as).

To disconnect, use killall pppd.

If you wish to connect as user, you can use sudo. Configure sudo to call
the above commands for your user, and you can use the following aliases
in your ~/.bashrc (or /etc/bash.bashrc for system-wide availability):

    alias dial='sudo /usr/sbin/pppd /dev/modem'
    alias hang='sudo /usr/bin/killall pppd'

Now you can connect by running dial from a terminal and disconnect with
hang.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Direct_Modem_Connection&oldid=254318"

Category:

-   Modems
