3G and GPRS modems with pppd
============================

  

3G and GPRS modems with pppd alone

Why not to use a pppd wrapper (like wvdial or similar)?. I particularly
switched to direct pppd because my previous software sometimes silently
exited instead of reconnecting, as it was configured to do, requiring me
to travel to manually perform the reconnection.

You may be reading this page by the same reason it was written for: you
may have finally concluded that the lesser the layers, the less likely
the troubles.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Prerequisites and tested hardware                                  |
| -   2 Configuration                                                      |
|     -   2.1 /etc/ppp/options-mobile                                      |
|     -   2.2 /etc/ppp/peers                                               |
|     -   2.3 /etc/ppp/chatscripts                                         |
|                                                                          |
| -   3 Start the pppd                                                     |
| -   4 Patch for modem availability after booting                         |
|     -   4.1 netcfg hook                                                  |
|     -   4.2 network hook                                                 |
|                                                                          |
| -   5 Troubleshooting                                                    |
| -   6 AT^SYSCFG Huawey command reference                                 |
| -   7 Automatic PPP                                                      |
| -   8 Related Articles                                                   |
+--------------------------------------------------------------------------+

Prerequisites and tested hardware
---------------------------------

The only requirement is the ppp package (2.4.5-1 tested). The method
described supports easy switching between several carriers and 3G and
GPRS modes. It has been tested and directly works with no modifications
(except for the device name) with:

-   Huawey EM770 MiniPCIe modem (Asus Eee PC 1000H Go internal
    integrated modem).
-   Huawey E220 and E1552 external USB dongles.
-   Nokia N73 (USB tethering; select "PC Suite" when the phone asks).
-   Nokia CS-15 (lsusb says 0421:0612 Nokia Mobile Phones)
-   Alcatel x310e (carrier: Wind IT)

This guide assumes that your modem hardware is properly detected and
working. You simply may look at /var/log/messages to discover the device
names appeared when the modem is plugged in. Alternatively:

    root@quark:~# dmesg | grep GSM | grep attached
    usb 1-6: GSM modem (1-port) converter now attached to ttyUSB0
    usb 1-6: GSM modem (1-port) converter now attached to ttyUSB1
    usb 1-6: GSM modem (1-port) converter now attached to ttyUSB2
    usb 2-2: GSM modem (1-port) converter now attached to ttyUSB3
    usb 2-2: GSM modem (1-port) converter now attached to ttyUSB4

In this computer there are 2 devices available: a internal 3G modem
(ttyUSB0) and a external 3G dongle (ttyUSB3). The Nokia phones use other
device names, like ttyACM0. The extra devices created are useful to get
and query the internal modem state while the main one is in use (you may
try the cat command on them).

To enable some modems you may need the usb_modeswitch package (see the
USB 3G Modem wiki for more information).

Configuration
-------------

The following files are also available as netcfg-ppp-mobile-git in the
Arch User Repository.

> /etc/ppp/options-mobile

Create this file:

    /etc/ppp/options-mobile

    ttyUSB0
    921600
    lock
    crtscts
    modem
    passive
    novj
    defaultroute
    noipdefault
    usepeerdns
    noauth
    hide-password
    persist
    holdoff 10
    maxfail 0
    debug

The first line is the modem device (ttyUSB0 in the example) and it will
be a permanent option while your hardware doesn't changes. You may want
to modify some options (see man pppd). The proposed setup tries to keep
the connection permanently established, reconnecting when necessary.

> /etc/ppp/peers

Add these files:

    root@quark:/etc/ppp/peers# ll
    total 8
    -rw-r----- 1 root root 141 Jun 20 19:29 mobile-auth
    -rw-r----- 1 root root 104 Jun 20 19:29 mobile-noauth
    lrwxrwxrwx 1 root root  13 Jun 20 19:30 provider -> mobile-noauth

The provider symlink defines the default peer for pppd, and as you see
it points to the mobile-noauth file. It is possible to setup a different
file with user/password for each carrier (with mobile-auth being a
example) but it seems that this is not necessary (at least, not for
Vodafone or Simyo in Spain).

    /etc/ppp/peers/mobile-auth

    file /etc/ppp/options-mobile
    user "your_usr"
    password "your_pass"
    connect "/usr/sbin/chat -v -t15 -f /etc/ppp/chatscripts/mobile-modem.chat"

    /etc/ppp/peers/mobile-noauth

    file /etc/ppp/options-mobile
    connect "/usr/sbin/chat -v -t15 -f /etc/ppp/chatscripts/mobile-modem.chat"

> /etc/ppp/chatscripts

Since the chatscripts directory does not exists in Arch, manually create
it to place a few new files there:

    root@quark:/etc/ppp/chatscripts# ll
    total 44
    lrwxrwxrwx 1 root root  15 Jun 19 19:17 apn -> apn.es.vodafone
    -rw-r--r-- 1 root root  37 Jun 19 16:27 apn.es.simyo
    -rw-r--r-- 1 root root  35 Jun 19 16:27 apn.es.vodafone
    -rw-r--r-- 1 root root 394 Jun 20 19:29 mobile-modem.chat
    lrwxrwxrwx 1 root root  12 Jun 19 18:59 mode -> mode.3G-only
    -rw-r--r-- 1 root root  29 Jun 19 22:12 mode.3G-only
    -rw-r--r-- 1 root root  28 Jun 19 17:05 mode.3G-pref
    -rw-r--r-- 1 root root  29 Jun 19 17:05 mode.GPRS-only
    -rw-r--r-- 1 root root  28 Jun 19 17:06 mode.GPRS-pref
    -rw-r--r-- 1 root root   3 Jun 19 23:40 mode.NONE
    lrwxrwxrwx 1 root root   8 Jun 20 19:29 pin -> pin.CODE
    -rw------- 1 root root  13 Jun 20 19:29 pin.CODE
    -rw-r--r-- 1 root root   3 Jun 19 23:37 pin.NONE

The core script is mobile-modem.chat, which dialogues with the modem and
properly inserts another tiny scripts for selecting the APN, GPRS/3G and
the PIN code. You probably won't need to modify it. This script is
interpreted by the limited (but powerful enough) chat tool, included in
the standard ppp package. With the proposed method, you'll keep a little
personal file-based "database" of settings.

If you exchange the SIM card, to select the new carrier you only need to
update the apn symlink to point to the correct apn file and restart the
ppp network (for example with killall -HUP pppd). The same for changing
between 3G/GPRS forced modes (mode symlink).

The other files consist in a single line, which in some cases you may
need to modify in order to customize it.

    /etc/ppp/chatscripts/mobile-modem.chat

    ABORT 'BUSY'
    ABORT 'NO CARRIER'
    ABORT 'VOICE'
    ABORT 'NO DIALTONE'
    ABORT 'NO DIAL TONE'
    ABORT 'NO ANSWER'
    ABORT 'DELAYED'
    REPORT CONNECT
    TIMEOUT 6
    '' 'ATQ0'
    'OK-AT-OK' 'ATZ'
    TIMEOUT 3
    'OK' @/etc/ppp/chatscripts/pin
    'OK\d-AT-OK' 'ATI'
    'OK' 'ATZ'
    'OK' 'ATQ0 V1 E1 S0=0 &C1 &D2 +FCLASS=0'
    'OK' @/etc/ppp/chatscripts/mode
    'OK-AT-OK' @/etc/ppp/chatscripts/apn
    'OK' 'ATDT*99***1#'
    TIMEOUT 30
    CONNECT ''

    /etc/ppp/chatscripts/apn.es.vodafone

    AT+CGDCONT=1,"IP","ac.vodafone.es"

    /etc/ppp/chatscripts/apn.es.simyo

    AT+CGDCONT=1,"IP","gprs-service.com"

    /etc/ppp/chatscripts/apn.no.telenor

    AT+CGDCONT=1,"IP","Telenor"

(of course, you'll have to create your own apn files, replacing
"ac.vodafone.es" or "gprs-service.com" by your own APN strings on them).

For Telenor, use your mobile phone number (without country code) for
both user and password in /etc/ppp/peers/mobile-noauth.

    /etc/ppp/chatscripts/pin.CODE

    AT+CPIN=1234

    /etc/ppp/chatscripts/pin.NONE

    AT

If your SIM card has the PIN code disabled, you should symlink pin to
pin.NONE to avoid sending it. When a SIM card has the PIN code enabled,
it is only required to be sent the first time after power on. There is a
modem command to query about this, but since I didn't find a reliable
way to use it in the chat script, the PIN, when enabled, is always sent.
This has no drawbacks, other than a little additional delay also due to
the chat script limitations while recovering from the modem error
response (if the PIN was no longer required).

    /etc/ppp/chatscripts/mode.3G-only

    AT\^SYSCFG=14,2,3fffffff,0,1

    /etc/ppp/chatscripts/mode.3G-pref

    AT\^SYSCFG=2,2,3fffffff,0,1

    /etc/ppp/chatscripts/mode.GPRS-only

    AT\^SYSCFG=13,1,3fffffff,0,0

    /etc/ppp/chatscripts/mode.GPRS-pref

    AT\^SYSCFG=2,1,3fffffff,0,0

    /etc/ppp/chatscripts/mode.NONE

    AT

The SYSCFG line in the mode.* files is device-dependent, and likely
Huawey-specific. It does not works in Nokia phones (you may symlink mode
to mode.NONE, which only sends the AT command with no effect). I had to
investigate before achieving success with both EM770 and E220 modems.
Despite many forums reporting a "4" trailing code, it seems that the
trailing 0/1 number, while optional in E220, becomes mandatory in EM770
for truly switching the mode. At the end of this guide there are
explained the available options for this command. As previously said,
you may simply link to mode.NONE and use your modem defaults in case of
problems.

Start the pppd
--------------

To start the pppd daemon, either run pon/poff or /etc/rc.d/ppp
start|stop. In Arch this can be automated to occur at system boot by
adding "@ppp" after "network" in the DAEMONS line of /etc/rc.conf (the
"@" places it in background, since pppd start may be a bit slow).

The log is stored in /var/log/messages.

With the above proposed setup, while the new ppp0 interface is up, pppd
will automatically set your default route (if none previously existing)
as well as the /etc/resolv.conf contents. It seems very reliable
handling DNS switchings (the backup is kept in resolv.conf.backup.ppp0,
but I never had to manually restore it, even after a power failure).

Patch for modem availability after booting
------------------------------------------

If you automate the pppd start, it may occur that the modem device does
not exists at the moment of the pppd lauch during the computer boot.
This may occur even when the USB modem module load is manually setup in
rc.conf: that helps, but the device may be still not always available
when pppd comes into scene. The pppd daemon rejects to start when the
configured device does not exists, and it doesn't seems to have an
option to force it to start (note that in case the device dissapears
once pppd is already running, for example by momentarily disconnecting
the external 3G USB modem, pppd will continue running and will reconnect
once it appears again).

The following script may be useful to wait until the hardware is ready.
It will typically wait for 0-2 seconds. The modem device is assumed to
be the first line on /etc/ppp/options-mobile. It takes an argument with
the maximum wait (in seconds). Optionally admits a second argument with
a profile name (from /etc/ppp/peers) which will be used to re-run pppd.
Do not forget to make the script executable:

    /etc/ppp/wait-dialup-hardware

    #!/bin/bash
    INTERFACE="/dev/$(head -1 /etc/ppp/options-mobile)"
    MAX_SECONDS_TIMEOUT=$1
    PEER_NAME=$2
    dsec=$((${MAX_SECONDS_TIMEOUT} * 10))
    for ((retry=0; retry < ${dsec}; retry++))
    do
        if [ -c ${INTERFACE} ]; then
            logger "$0: OK existing required device ${INTERFACE} (in $((retry / 10)).$((100 * (retry % 10) / 10)) seconds)"
            break
        else
            sleep 0.1
        fi
    done
    if [ ! -c ${INTERFACE} ]; then
        logger "$0: ERROR timeout waiting for required device ${INTERFACE}"
        exit 1
    fi
    if [ ! -z "${PEER_NAME}" ]; then
      logger "$0: starting pppd for ${PEER_NAME}"
      setsid nohup pon "${PEER_NAME}" > /dev/null 2>&1 < /dev/null &
    fi
    exit 0

The script will add a line to /var/log/messages:

    Jun  1 22:52:08 parsec logger: /etc/ppp/wait-dialup-hardware: OK existing required device /dev/ttyUSB0 (in 1.25 seconds)

> netcfg hook

To use the above script, netcfg users could add the following profile:

    /etc/network.d/ppp

    CONNECTION='ppp'
    INTERFACE='ignore'
    PEER='mobile-noauth'
    PPP_TIMEOUT=30
    PRE_UP='/etc/ppp/wait-dialup-hardware 10'

> network hook

Users of traditional network setup (instead of netcfg) can use the
following trick to launch the wait-dialup-hardware script from the
standard /etc/rc.d/ppp service. The example is intended to run the
mobile-noauth profile:

    /etc/ppp/peers/mobile-noauth.wait

    noauth
    pty "/etc/ppp/wait-dialup-hardware 10 mobile-noauth"

Updating the default provider symlink to point to the new intermediate
(fake) mobile-noauth.wait profile, it will simply run the
wait-dialup-hardware script from within pppd and, in turn, will restart
pppd with the final (non fake) mobile-noauth profile once the hardware
is ready. Note that the noauth option in the first line of the fake
profile is necessary (even if the final profile does requires
authentication).

Troubleshooting
---------------

In case of using a wrong PIN, my modem consistently rejects the APN
setting phase (no error in the steps before). This is how
/var/log/messages looks like:

    Jun 20 00:17:30 quark chat[3348]: send (AT+CGDCONT=1,"IP","ac.vodafone.es"^M)
    Jun 20 00:17:31 quark chat[3348]: expect (OK)                                
    Jun 20 00:17:31 quark chat[3348]: ^M
    Jun 20 00:17:31 quark chat[3348]: AT+CGDCONT=1,"IP","ac.vodafone.es"^M^M
    Jun 20 00:17:31 quark chat[3348]: ERROR^M                               
    Jun 20 00:17:34 quark chat[3348]: alarm
    Jun 20 00:17:34 quark chat[3348]: Failed

It would be a long story, but I'll simply abbreviate it: if you have
just set or changed the PIN in a phone, please reboot the phone and try
it in the phone before placing the SIM card in the modem (I'm not sure
if the PIN updates take effect just at the moment they are done in the
phone menus).

In case of frequent manual pppd restarts, as for example when testing
configuration options, the EM770 (firmware upgraded to 11.104.16.12.00)
sometimes becomes confused. Despite it responds to the AT commands, it
gets stuck in a "NO CARRIER" reply (while the 3G network is ok, as a
mobile phone may report). This not occurs with the proposed scripts (in
case of connection lost, they wait enough time before retrying). With
the modem stuck, powering OFF and then ON the computer solves the
problem. This is perhaps a firmware bug. Also, when using a PIN, this
modem returns a NO CARRIER reply in the first connection try (it seems
that a huge wait after setting the PIN helps; anyway the same effect is
achieved by the ordinary connection retry). While running, the EM770 is
stable, but the E220 or the Nokia phones are far more reliable in the
connection phase. Your mileage may vary depending on your hardware.

AT^SYSCFG Huawey command reference
----------------------------------

To see the supported values, you can query your own modem sending the
"AT^SYSCFG=?" command.

    AT^SYSCFG=$mode,$acqOrder,$band,$roam,$srvDomain

    $mode
    2=Auto-Select
    13=GSM only
    14=WCDMA only
    16=no Change

    $acqOrder
    0=Automatic
    1=GSM prefered
    2=WCDMA prefered
    3=no Change

    $band
    3fffffff = All
    other (query list with "AT^SYSCFG=?")

    $roam
    0=Not Supported
    1=Supported
    2=no Change

    $srvDomain
    0=Circuit-Switched only
    1=Packet-Switched only
    2=Circuit- & Packet-Switched
    3=Any
    4=no Change

AT^SYSCFG=? command output on Huawey EM770:

    ^SYSCFG:(2,13,14,16),(0-3),((80000,"GSM850"),(200000,"GSM1900"),(400380,"GSM900/GSM1800/WCDMA2100"),(4a80000,"GSM850/GSM1900/WCDMA850/WCDMA1900"),(3fffffff,"All Bands")),(0-2),(0-4)

Automatic PPP
-------------

For the Nokia CS-15, create (or add to) /etc/udev/rules.d/99-nokia.rules
with this line:

    SUBSYSTEM=="net", ACTION=="add", ATTRS{idVendor}=="0421", ATTRS{idProduct}=="0612", DEVPATH=="*/ttyACM0", RUN+="pon"

and it will connect ppp as soon as you plug in the device. You can
probably do something similar for the other modems.

Related Articles
----------------

Dialup_without_a_dialer_HOWTO  
 Huawei E220  
 USB 3G Modem  

Retrieved from
"https://wiki.archlinux.org/index.php?title=3G_and_GPRS_modems_with_pppd&oldid=236220"

Category:

-   Modems
