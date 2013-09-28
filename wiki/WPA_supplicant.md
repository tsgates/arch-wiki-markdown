WPA supplicant
==============

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: Excessive        
                           wording, lack of flow,   
                           arbitrary subsection     
                           scheme (Discuss)         
  ------------------------ ------------------------ ------------------------

A network protected by a static (and even dynamic) WEP key can very
easily be compromised by a nefarious user. WPA corrects the problem of
the static key, by changing the key at a packet transmitted/received
frequency, or once a certain amount of time has passed. This process is
performed by a daemon which is tightly bound to your wireless hardware.

Inferior drivers (in particular those used through ndiswrapper) can
provide much frustration when used in conjunction with wpa_supplicant.
Therefore, if at all possible, use hardware with proper support and high
quality drivers.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Considerations                                                     |
| -   2 Installation                                                       |
|     -   2.1 Optional: Install the GUI version                            |
|                                                                          |
| -   3 Configuring and connecting                                         |
|     -   3.1 Manual                                                       |
|         -   3.1.1 Configuration file                                     |
|         -   3.1.2 Connection                                             |
|                                                                          |
|     -   3.2 wpa_gui and wpa_cli                                          |
|         -   3.2.1 Action script                                          |
|                                                                          |
|     -   3.3 Automatically start at boot                                  |
|         -   3.3.1 Using systemd                                          |
|             -   3.3.1.1 Step 1                                           |
|             -   3.3.1.2 Step 2                                           |
|                                                                          |
|         -   3.3.2 Using boot script                                      |
|         -   3.3.3 Using wpa auto                                         |
|         -   3.3.4 netcfg                                                 |
|         -   3.3.5 Wicd                                                   |
|                                                                          |
| -   4 Troubleshooting                                                    |
|     -   4.1 Fallback: Recompiling wpa_supplicant                         |
|     -   4.2 Unable to use wpa_gui for configuring new networks           |
|     -   4.3 No IP Address from the DHCP Server                           |
|     -   4.4 Netcfg association error on boot                             |
|     -   4.5 Wireless connection frequently drops                         |
+--------------------------------------------------------------------------+

Considerations
--------------

This article assumes that you are familiar with your hardware, and are
capable of finding your way around configuration files and configuring
your system. It is critical that you have read and understood the
Wireless Setup article because it is the basis for all that we are going
to explain here.

This document is not a prerequisite if your hardware works out of the
box and is handled through a network connection daemon like
NetworkManager or the like. If you prefer to connect to the network
using a graphical tool, you should not be reading this.

In this article, the passphrase will refer to the string of ASCII
characters provided by the network administrator. It will typically be
enclosed in quotes when used. The psk is the hexadecimal form of the
passphrase and will not be enclosed in quotes.

Installation
------------

WPA supplicant can be installed with the package wpa_supplicant,
available in the official repositories.

This package has been built with support for a very broad range of
wireless hardware. For your information, here is the list, which can be
obtained by executing 'wpa_supplicant':

    # wpa_supplicant
    ...

    Driver list:

    *HostAP
    *Prism54
    *NDISWrapper
    *AMTEL
    *IPW (both 2100 and 2200 drivers)
    *WEXT (Generic Linux wireless extensions)
    *Wired ethernet

Most wireless hardware is supported by default by wpa_supplicant. Even
if your chipset manufacturer is not listed (which is the most probable
case), you can still make use of the Generic Wireless Extensions (WEXT)
to connect to a WPA-secured network. Most (~75%) hardware is supported
by WEXT, whereas ~20% is compatible by recompiling wpa_supplicant and/or
hardware drivers from scratch, and, unfortunately, the missing 5% which
is definitely incompatible. The WPA Supplicant PKGBUILD is available
under: /var/abs/core/wpa_supplicant, with the ABS tree installed.

> Optional: Install the GUI version

Users who prefer a graphical interface can install the
wpa_supplicant_gui package, a GUI developed by the same team, from the
official repositories.

Configuring and connecting
--------------------------

WPA Supplicant is packaged with a sample configuration file:
/etc/wpa_supplicant/wpa_supplicant.conf. It is well commented and
provides many details about network mechanics. All the variables used in
this article are described in this file. It also features a lot of
configuration samples. It is highly recommended to read it, as well as
the manpages man wpa_supplicant and man wpa_supplicant.conf.

A WPA_Supplicant configuration file contains all configuration settings
for wpa_supplicant. You can create as many as you want and put them
anywhere you want, since you must specify which config file to use on
each wpa_supplicant call. Its content is quite simple:

-   The first part is the global config. It is a series of key-value
    lines.
-   The second part is composed of network blocks, one for each
    "profile" you want to set.

For the purpose of simplifying, we will leave the sample config file
where it is and work on a brand new file /etc/wpa_supplicant.conf.

There are several ways to manage wpa_supplicant configuration. You can
choose among one of the following methods.

> Manual

Configuration file

First you must retrieve all parameters needed to connect to your access
point.

    # iw wlan0 scan

More details here.

So now you should know the following parameters for wpa_supplicant:

-   ssid
-   proto (optional on unencrypted networks)
-   key_mgmt
-   pairwise
-   group

Additionally, you may need authentication parameters (EAP, PEAP, etc.)
if you are on such a network, as it is often the case in universities
for example.

First touch

Now you can create a network block in the config file:

    wpa_supplicant.conf

    network={
            ssid="mywireless_ssid"
            psk="secretpassphrase"
            # Additional parameters (proto, key_mgmt, etc.)
    }

This is the basic configuration required to get WPA working. The first
line is the opening statement for the network block, the second is the
SSID of the base station you are wanting to connect to, the third line
is the passphrase.

Warning:Do not forget the double quotes around the SSID and the PSK.

Passphrase to PSK

On the network-level, the passphrase is never directly used, it is only
a convenient way to handle the key for humans.

You may provide the hex version directly by utilizing the wpa_passphrase
utility, which is part of the wpa_supplicant package.

-   For example:

     # wpa_passphrase "mywireless_ssid" "secretpassphrase"

     network={
            ssid="mywireless_ssid"
            #psk="secretpassphrase"
            psk=7b271c9a7c8a6ac07d12403a1f0792d7d92b5957ff8dfd56481ced43ec6a6515
     }

Tip: If you're having trouble using this function with certain special
characters under your shell, use a temporary text file for the
passphrase. You can then direct input so that it is not interpreted by
the shell:  # cat passphrase_noquotes.txt | wpa_passphrase "ssid" 

Note the third line (commented out) is the passphrase, and the fourth
line is the PSK. Either is valid to connect, but the PSK is more
portable in config files.

-   Utilizing wpa_passphrase, specify your actual SSID and passphrase,
    and redirect the output to /etc/wpa_supplicant.conf:

    # wpa_passphrase mywireless_ssid "secretpassphrase" >> /etc/wpa_supplicant.conf

The >> will append the output to /etc/wpa_supplicant.conf. You can add
as many network blocks as you want. wpa_supplicant will know which one
to use based upon the detected SSIDs in the area.

Network block options

All of the security parameters need to be specified here. Note that if
you are unsure about which value your access point requires, you can use
several of them, wpa_supplicant will automatically use the one that
works. For example, you can add

    proto=WEP WPA

so that if your access point uses WEP or WPA, it will work in both case.
But if it uses RSN (aka WPA2) it will not find it by itself, you have to
append it to the other values.

If the SSID is hidden, add the following option to the block:

    scan_ssid=1

If you need to connect to several networks, just define another network
block in the same file. You can specify a priority for each network
block:

    priority=17

Change the priority at will, recalling that priorities with big numbers
are tried first.

There are a large number of options which are available to set under the
network which you can investigate by looking at the original
configuration file. In most cases you can use the defaults, and not
specify anything further in that section at the moment.

Global options

Lastly, you will need to specify some global options. Specify these
additional lines at the top of /etc/wpa_supplicant.conf, with your
editor of choice. The following is mandatory.

    ctrl_interface=DIR=/run/wpa_supplicant GROUP=wheel

Note:For use with netcfg>=2.6.1-1, this should be /run/wpa_supplicant
(note: not /var/run/wpa_supplicant). This will, however, break the
default for wpa_cli (use the -p option to override). If this is not
changed, one gets errors like "Failed to connect to wpa_supplicant -
wpa_ctrl_open: no such file or directory".

There is a lot of optional parameters (have a look at
/etc/wpa_supplicant/wpa_supplicant.conf). For example:

    ap_scan=0
    fast_reauth=1

Note:Your network information will be stored in plain text format;
therefore, it may be desirable to change permissions on the newly
created /etc/wpa_supplicant.conf file (e.g.
chmod 0600 /etc/wpa_supplicant.conf to make it readable by root only),
depending upon how security conscious you are.

Complete example

    wpa_supplicant.conf

    ctrl_interface=DIR=/run/wpa_supplicant GROUP=wheel
    fast_reauth = 1
    ap_scan = 1

    network ={
        ssid     = "mySSID"
        proto    = RSN
        key_mgmt = WPA-EAP
        pairwise = TKIP CCMP
        auth_alg = OPEN
        group    = TKIP
        eap      = PEAP
        identity = "myUsername"
        password = "********"
    }

More sophisticated configurations, like EAPOL or RADIUS authentication
are very well detailed in the wpa_supplicant.conf man page
(man wpa_supplicant.conf). Do not forget to have a look at
/etc/wpa_supplicant/wpa_supplicant.conf. These configurations fall out
of the scope of this document.

Connection

Now you can try connecting manually.

First, bring the Wi-Fi interface up. For the purposes of this example,
we will use the interface wlan0.

    # ip link set wlan0 up

Typically, you will be able to use the Wireless EXTensions driver for
wpa_supplicant; if you cannot, then you might need to check how to do it
with your specific wireless device on the Internet.

Issue the following as root:

    # wpa_supplicant -B -Dwext -i wlan0 -c /etc/wpa_supplicant.conf 

The previous syntax tells wpa_supplicant to use its default hardware
configuration (WEXT - Linux Wireless EXTensions) and to associate with
the SSID which is specified in /etc/wpa_supplicant.conf. Also, this
association should be performed through the wlan0 wireless interface,
and the process should move to the background, (-B). For verbose output,
add -d or -dd (for debug) to dump more information to the console. You
can find additional examples here.

In the console output, there should be a line that reads 'Associated:'
followed by a MAC address. All that is required now is an IP address.

Note:If you don't want or need to touch /etc/wpa_supplicant.conf (e.g.,
when installing Arch), you can pipe wpa_passphrase to wpa_supplicant:

    wpa_passphrase essid pass | wpa_supplicant -B -i wlan0 -c /dev/stdin

As root, issue:

    # dhcpcd wlan0

Note:*Do not* request an IP address immediately! You must wait to ensure
that you are properly associated with the access point. If you use a
script, you can use sleep 10s to wait for 10 seconds.

Verify the interface has received an IP address using the iproute
package:

    # ip addr show wlan0

       wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
       link/ether 00:1C:BF:66:4E:E0 brd ff:ff:ff:ff:ff:ff
       inet 192.168.0.62/24 brd 192.168.0.255 scope global eth0
       inet6 fe80::224:2bff:fed3:759e/64 scope link 
          valid_lft forever preferred_lft forever

If the output is close to the above, you are now connected.

> wpa_gui and wpa_cli

There are two frontends to wpa_supplicant actually written by the
wpa_supplicant developers themselves, "wpa_cli", and "wpa_gui". wpa_cli
is, as you might expect, a command line front end, while "wpa_gui" is a
Qt-based frontend to wpa_supplicant. wpa_cli is included with the
wpa_supplicant package, whereas wpa_supplicant_gui is its own package.

  
 wpa_gui or wpa_cli require a very minimal /etc/wpa_supplicant.conf. A
simple example:

    ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=network
    update_config=1

This configuration will allow users in the network group to control
wpa_supplicant via the wpa_gui/wpa_cli frontends. The update_config=1
variable allows these programs {wpa_cli, wpa_gui} to automatically
modify the /etc/wpa_supplicant.conf file, to save new networks, or to
make modifications to existing networks.

Start wpa_supplicant:

    # wpa_supplicant -Dwext -i wlan0 -c /etc/wpa_supplicant.conf -B

where the -D option specifies your wireless driver (which is almost
always wext), -i specifies the interface (replace wlan0 with your
wireless interface's name) and -c specifies the configuration file to
use (normally /etc/wpa_supplicant.conf). -B instructs wpa_supplicant to
run as a daemon. You will have to run wpa_supplicant as root (or with
root permissions using sudo), but any user in the network group can run
wpa_gui or wpa_cli.

wpa_gui or wpa_cli should now be operable.

wpa_cli, when invoked without options, will give you a prompt
environment, try typing help for help.

wpa_gui is quite straightforward. If you hit "scan", you will be
presented with a list of detected SSIDs, you can double click to add
one, you will be given a dialogue box that will let you enter
information that you need to associate with your network. Most likely,
you will only have to enter your pre-shared key (PSK) if you use
WPA/WPA2 or your key0 for a WEP connection. The protocol for
WPA/WPA2/WEP/Unencrypted should be automatically detected. Things like
802.1X will require a bit more configuration.

Warning:WEP is seriously broken and should never be used outside of a
laboratory/testing environment. Use at least WPA (WPA2 is recommended)
for a more secure wireless network.

After you add a network, you can modify it if you do something like
changing the PSK. Switch to the 'Manage Networks' tab and select the
network you want to Edit / Remove. You can also add a network without
scanning, which you will need to do if you do not broadcast your SSID.

Note:Configuring your wireless network to not broadcast its SSID does
not increase the security of your wireless network. It is a trivial
exercise to identify hidden SSIDs.

Note:wpa_cli and wpa_gui will not get you an IP address or set up a
proper routing table. They will only associate you with a wireless
access point.

Action script

Write a script like this:

    ~/libexec/wpa_cli-action.sh

    case $2 in
    CONNECTED)
    	dhcpcd -x $1 >/dev/null
    	dhcpcd $1 >/dev/null
    ;;
    esac

Make it executable and launch wpa_supplicant with the preferred
configuration file:

    # wpa_supplicant -B -c /etc/wpa_supplicant.conf -i wlan0

Note:The configuration file must have the ctrl_interface setting so that
wpa_cli can work.

Now launch wpa_cli in daemon mode, pointing it to the previously saved
script:

    # wpa_cli -B -a ~/libexec/wpa_cli-action.sh

> Automatically start at boot

Note that the whole process we have been through is not permanent. It
means that on next reboot you will have to provide all the commands
again. Here are some method to make the change permanent.

Using systemd

This is a two step process. The first step is to enable the
wpa_supplicant service. The second is to enable the adapter specific
dhcpcd service.

Step 1

Copy your configuration file to an adapter specific file (wlan0 is used
here):

    # cp /etc/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant-wlan0.conf

Enable the systemd target:

    # systemctl enable wpa_supplicant@wlan0.service

Start the service:

    # systemctl start wpa_supplicant@wlan0.service

Check the status of the service:

    # systemctl status wpa_supplicant@wlan0.service

After "Active:" it should report "active (running)"

Step 2

We probably already have a dhcpcd service for eth0, but we need to add
one, specifically, for the wireless device:

Enable the systemd target:

    # systemctl enable dhcpcd@wlan0.service

Start the service:

    # systemctl start dhcpcd@wlan0.service

Check the status of the service:

    # systemctl status dhcpcd@wlan0.service

After "Active:" it should report "active (running)"

The next reboot should bring up the wireless adapter, associate it with
the network, and obtain an IP address. Verify this by:

    # ip a

Using boot script

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Should change to 
                           systemd service.         
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

To automatically start wpa_supplicant & wpa_cli at boot, add the
following lines to /etc/rc.local:

    wpa_supplicant -B -D wext -i wlan0 -c /etc/wpa_supplicant.conf
    wpa_cli -B -a  /path/to/your/wpa_cli-action.sh

Using wpa auto

The wpa_auto scripts from the AUR can be used to start wpa_supplicant at
boot and automatically run a DHCP client to configure your network
connection after you associate to a wireless network, or you could write
your own scripts to do so. Higher level wireless/network management
utilities are also available that are capable of managing both wireless
and wired connections.

netcfg

Install netcfg from the official repositories.

Create a network profile configuration by copying the example file:

    # cp /etc/network.d/examples/wireless-wpa-config /etc/network.d/wpa_suppl

Edit the new file to make sure it specifies the right interface, e.g.

    INTERFACE="wlan0"

The rest of the file should be left as-is.

Next, edit /etc/conf.d/netcfg. Add the network profile to the NETWORKS
array:

    NETWORKS=(... wpa_suppl)

Finally, add the net-profiles to systemd:

    # systemctl enable netcfg@wpa_suppl

On the next reboot, the wireless interface will be brought up and
wpa_supplicant started. If a known network is available, a connection
will be established. For more information on netcfg see Network
Profiles.

Wicd

Install wicd from the official repositories.

Wicd is very straightforward; scan for networks, fill in the required
data and connect. You might need to add /usr/lib/wicd/autoconnect.py to
init and power management scripts for reconnecting to networks if
auto-connection behavior is expected.

Troubleshooting
---------------

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Most of the issues are related to the association process; therefore,
you should have a deep look at wpa_supplicant's output when you suspect
it is misbehaving. Add -d (for debug) to increase the verbosity. Usually
-dd is enough. -dddd might be overkill.

When you are inspecting the log, have a look at entries like this one:

    ioctl[WHATEVER]: Operation not supported

If this is the case, you are experiencing a driver issue. Upgrade your
WLAN drivers, or change the -D parameter for wpa_supplicant.

Another common problem is No suitable AP found messages. wpa_supplicant
seems to have trouble finding hidden ESSIDs. Usually, setting
scan_ssid=1 in your network block will take care of this.

> Fallback: Recompiling wpa_supplicant

Grab a copy of wpa_supplicant's source code from the homepage or from
the ABS. Once downloaded and extracted, have a look at the file
'.config' (yes, it is hidden). The file looks like a kernel
configuration file, only much smaller. Have a look at the sections named
CONFIG_DRIVER_DRIVERNAME and choose yes or no, depending upon your
driver. Be careful with the options chosen, because you will need to
specify an additional path to your wireless drivers' source code in
order to correctly compile the low-level association component. Some
weird Atheros-based cards may need a fresh wpa_supplicant build compiled
against the latest madwifi-svn release available. If this is the case,
here is an example to help you through the compilation process:

madwifi example: edit the following lines in the configuration file to
look like this. This assumes that you have built madwifi with the ABS
and that the source code from the build is stored in
/var/abs/local/madwifi/src/.

    #Driver interface for madwifi driver
    CONFIG_DRIVER_MADWIFI=y
    #Change include directories to match with the local settings
    CFLAGS += -I/var/abs/local/madwifi/src/madwifi

Once configured, you can proceed with makepkg as usual.

> Unable to use wpa_gui for configuring new networks

By default the ap_scan variable is set to 0, which means that
wpa_supplicant lets the wireless LAN driver perform AP scanning. If your
driver does not support scanning, wpa_supplicant will quit when prompted
to scan for wireless networks. In this case, add:

    ap_scan=1

to your /etc/wpa_supplicant.conf

> No IP Address from the DHCP Server

If you can not get an IP address from the DHCP server when runing
dhcpcd wlan0, use the following command to stop wpa_supplicant and try
again:

    # wpa_cli terminate
    # iwconfig wlan0 essid "myEssid" key on #maybe "key on" is optional
    # sleep 15; dhcpcd wlan0

> Netcfg association error on boot

The following is a personal experience. My Broadcom BCM4322 WLAN card is
quite slow in associating with the access point on boot up. In
/etc/network.d/<your_profile>, try adding the following line:

    TIMEOUT=30

Reboot to see if that helps.

Note:TIMEOUT=30 may be a bit high, but you can always adjust the value
to an ideal timeout for your own configuration.

> Wireless connection frequently drops

If you connection frequently drops and dmesg show this message:

    wlan0: deauthenticating from XX:XX:XX:XX:XX:XX by local choice (reason=3)

A workaround is trying disable "group key update interval" option from
your router.

Retrieved from
"https://wiki.archlinux.org/index.php?title=WPA_supplicant&oldid=255231"

Category:

-   Wireless Networking
