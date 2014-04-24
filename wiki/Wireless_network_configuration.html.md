Wireless network configuration
==============================

Related articles

-   Network configuration
-   Software access point
-   Ad-hoc networking
-   Internet sharing

Configuring wireless is a two-part process; the first part is to
identify and ensure the correct driver for your wireless device is
installed (they are available on the installation media, but often have
to be installed explicitly), and to configure the interface. The second
is choosing a method of managing wireless connections. This article
covers both parts, and provides additional links to wireless management
tools.

Contents
--------

-   1 Device driver
    -   1.1 Check the driver status
    -   1.2 Installing driver/firmware
-   2 Wireless management
    -   2.1 Manual setup
        -   2.1.1 Getting some useful information
        -   2.1.2 Interface activation
        -   2.1.3 Access point discovery
        -   2.1.4 Operating mode
        -   2.1.5 Association
        -   2.1.6 Getting an IP address
        -   2.1.7 Custom startup scripts/services
            -   2.1.7.1 Manual wireless connection at boot using systemd
                and dhcpcd
            -   2.1.7.2 Systemd with wpa_supplicant and static IP
    -   2.2 Automatic setup
        -   2.2.1 Netctl
        -   2.2.2 Wicd
        -   2.2.3 NetworkManager
        -   2.2.4 WiFi Radar
-   3 Troubleshooting
    -   3.1 Rfkill caveat
    -   3.2 Regulatory domain
    -   3.3 Observing Logs
    -   3.4 Power saving
    -   3.5 Failed to get IP address
    -   3.6 Connection always times out
        -   3.6.1 Lowering the rate
        -   3.6.2 Lowering the txpower
        -   3.6.3 Setting rts and fragmentation thresholds
    -   3.7 Random disconnections
        -   3.7.1 Cause #1
        -   3.7.2 Cause #2
        -   3.7.3 Cause #3
-   4 Troubleshooting drivers and firmware
    -   4.1 Ralink
        -   4.1.1 rt2x00
        -   4.1.2 rt3090
        -   4.1.3 rt3290
        -   4.1.4 rt3573
        -   4.1.5 rt5572
    -   4.2 Realtek
        -   4.2.1 rtl8192cu
        -   4.2.2 rtl8192e
        -   4.2.3 rtl8188eu
    -   4.3 Atheros
        -   4.3.1 ath5k
        -   4.3.2 ath9k
            -   4.3.2.1 ASUS
    -   4.4 Intel
        -   4.4.1 ipw2100 and ipw2200
        -   4.4.2 iwlegacy
        -   4.4.3 iwlwifi
        -   4.4.4 Disabling LED blink
    -   4.5 Broadcom
    -   4.6 Other drivers/devices
        -   4.6.1 Tenda w322u
        -   4.6.2 orinoco
        -   4.6.3 prism54
        -   4.6.4 ACX100/111
        -   4.6.5 zd1211rw
        -   4.6.6 hostap_cs
    -   4.7 ndiswrapper
    -   4.8 compat-drivers-patched
-   5 See also

Device driver
-------------

The default Arch Linux kernel is modular, meaning many of the drivers
for machine hardware reside on the hard drive and are available as
modules. At boot, udev takes an inventory of your hardware and loads
appropriate modules (drivers) for your corresponding hardware, which
will in turn allow creation of a network interface.

Some wireless chipsets also require firmware, in addition to a
corresponding driver. Many firmware images are provided by the
linux-firmware package which is installed by default, however,
proprietary firmware images are not included and have to be installed
separately. This is described in #Installing driver/firmware.

> Note:

-   Udev is not perfect. If the proper module is not loaded by udev on
    boot, simply load it manually. Note also that udev may occasionally
    load more than one driver for a device, and the resulting conflict
    will prevent successful configuration. Make sure to blacklist the
    unwanted module.
-   The interface name for different drivers and chipsets will vary.
    Some examples are wlan0, eth1, and ath0. See also Network
    configuration#Device names.

Tip:Though not strictly required, it's a good idea to first install
user-space tools mentioned in #Manual setup, especially when some
problem should appear.

> Check the driver status

To check if the driver for your card has been loaded, check the output
of the lspci -k or lsusb -v command, depending on if the card is
connected by PCI(e) or USB. You should see that some kernel driver is in
use, for example:

    $ lspci -k

    06:00.0 Network controller: Intel Corporation WiFi Link 5100
    	Subsystem: Intel Corporation WiFi Link 5100 AGN
    	Kernel driver in use: iwlwifi
    	Kernel modules: iwlwifi

Note:If the card is a USB device, running dmesg | grep usbcore should
give something like usbcore: registered new interface driver rtl8187 as
output.

Also check the output of ip link command to see if a wireless interface
(e.g. wlan0, wlp2s1, ath0) was created. Then bring the interface up with
ip link set interface up. For example, assuming the interface is wlan0:

    # ip link set wlan0 up

If you get this error message: SIOCSIFFLAGS: No such file or directory,
it most certainly means that your wireless chipset requires a firmware
to function.

Check kernel messages for firmware being loaded:

    $ dmesg | grep firmware

    [   7.148259] iwlwifi 0000:02:00.0: loaded firmware version 39.30.4.1 build 35138 op_mode iwldvm

If there is no relevant output, check the messages for the full output
for the module you identified earlier (iwlwifi in this example) to
identify the relevant message or further issues:

    $ dmesg | grep iwlwifi

    [   12.342694] iwlwifi 0000:02:00.0: irq 44 for MSI/MSI-X
    [   12.353466] iwlwifi 0000:02:00.0: loaded firmware version 39.31.5.1 build 35138 op_mode iwldvm
    [   12.430317] iwlwifi 0000:02:00.0: CONFIG_IWLWIFI_DEBUG disabled
    ...
    [   12.430341] iwlwifi 0000:02:00.0: Detected Intel(R) Corporation WiFi Link 5100 AGN, REV=0x6B

If the kernel module is successfully loaded and the interface is up, you
can skip the next section.

> Installing driver/firmware

Check the following lists to discover if your card is supported:

-   The Ubuntu Wiki has a good list of wireless cards and whether or not
    they are supported either in the Linux kernel or by a user-space
    driver (includes driver name).
-   Linux Wireless Support and The Linux Questions' Hardware
    Compatibility List (HCL) also have a good database of
    kernel-friendly hardware.
-   The kernel page additionally has a matrix of supported hardware.

If your wireless card is listed above, follow the #Troubleshooting
drivers and firmware subsection of this page, which contains information
about installing drivers and firmware of some specific wireless cards.
Then check the driver status again.

If your wireless card is not listed above, it is likely supported only
under Windows (some Broadcom, 3com, etc). For these, you can try to use
ndiswrapper.

Wireless management
-------------------

Assuming that your drivers are installed and working properly, you will
need to choose a method of managing your wireless connections. The
following subsections will help you decide.

Procedure and tools required will depend on several factors:

-   The desired nature of configuration management; from a completely
    manual command line procedure to an automated solution with
    graphical front-ends.
-   The encryption type (or lack thereof) which protects the wireless
    network.
-   The need for network profiles, if the computer will frequently
    change networks (such as a laptop).

> Tip:

-   Whatever is your choice, you should try to connect using the manual
    method first. This will help you understand the different steps that
    are required and troubleshoot possible problems.
-   If possible (e.g. if you manage your Wi-Fi access point), try
    connecting with no encryption, to check that everything works. Then
    try using encryption, either WEP (simple to configure, but crackable
    in a matter of seconds), WPA or WPA2.

The following table shows the different methods that can be used to
activate and manage a wireless connection, depending on the encryption
and management types, and the various tools that are required. Although
there may be other possibilities, these are the most frequently used:

Management method

Interface activation

Wireless connection management   
(/=alternatives)

Assigning IP address   
(/=alternatives)

Manually managed,   
with no or WEP encryption

ip

iw / iwconfig

ip / dhcpcd / dhclient

Manually managed,   
with WPA or WPA2 PSK encryption

ip

iw / iwconfig + wpa_supplicant

ip / dhcpcd / dhclient

Automatically managed,   
with network profiles support

netctl, Wicd, NetworkManager, etc.  

These tools pull in the required dependencies from the list of packages
in the manual method.

> Manual setup

Just like other network interfaces, the wireless ones are controlled
with ip from the iproute2 package.

You will need to install a basic set of tools for managing the wireless
connection, either:

-   iw - the current nl80211 standard, but not all wireless chip's
    modules support it

or

-   wireless_tools - currently deprecated, but still widely supported.

And for WPA/WPA2 encryption, you will also need:

-   wpa_supplicant

The table below gives an overview of comparable commands for iw and
wireless_tools (see [1] for more examples). These user-space tools work
extremely well and allow complete manual control of wireless connection.

> Note:

-   Examples in this section assume that your wireless device is wlan0
    and that you are connecting to your_essid wifi access point. Replace
    both accordingly.
-   Note that most of the commands have to be executed with root
    permissions. Executed with normal user rights, some of the commands
    (e.g. iwlist), will exit without error but not produce the correct
    output either, which can be confusing.

  iw command                                       wireless_tools command                           Description
  ------------------------------------------------ ------------------------------------------------ ------------------------------------------------------------
  iw dev wlan0 link                                iwconfig wlan0                                   Getting link status.
  iw dev wlan0 scan                                iwlist wlan0 scan                                Scanning for available access points.
  iw dev wlan0 set type ibss                       iwconfig wlan0 mode ad-hoc                       Setting the operation mode to ad-hoc.
  iw dev wlan0 connect your_essid                  iwconfig wlan0 essid your_essid                  Connecting to open network.
  iw dev wlan0 connect your_essid 2432             iwconfig wlan0 essid your_essid freq 2432M       Connecting to open network specifying channel.
  iw dev wlan0 connect your_essid key 0:your_key   iwconfig wlan0 essid your_essid key your_key     Connecting to WEP encrypted network using hexadecimal key.
  iw dev wlan0 connect your_essid key 0:your_key   iwconfig wlan0 essid your_essid key s:your_key   Connecting to WEP encrypted network using ASCII key.
  iw dev wlan0 set power_save on                   iwconfig wlan0 power on                          Enabling power save.

Note:Depending on your hardware and encryption type, some of these steps
may not be necessary. Some cards are known to require interface
activation and/or access point scanning before being associated to an
access point and being given an IP address. Some experimentation may be
required. For instance, WPA/WPA2 users may try to directly activate
their wireless network from step #Association.

Getting some useful information

Tip:See official documentation of the iw tool for more examples.

-   First you need to find the name of wireless interface. You can do it
    with following command:

    $ iw dev

    phy#0
    	Interface wlan0
    		ifindex 3
    		wdev 0x1
    		addr 12:34:56:78:9a:bc
    		type managed
    		channel 1 (2412 MHz), width: 40 MHz, center1: 2422 MHz

-   To check link status, use following command. Example output when not
    connected to an AP:

    $ iw dev wlan0 link

    Not connected.

When connected to an AP, you will see something like:

    $ iw dev wlan0 link

    Connected to 12:34:56:78:9a:bc (on wlan0)
    	SSID: MyESSID
    	freq: 2412
    	RX: 33016518 bytes (152703 packets)
    	TX: 2024638 bytes (11477 packets)
    	signal: -53 dBm
    	tx bitrate: 150.0 MBit/s MCS 7 40MHz short GI

    	bss flags:	short-preamble short-slot-time
    	dtim period:	1
    	beacon int:	100

-   You can get statistic information, such as the amount of tx/rx
    bytes, signal strength etc., with following command:

    $ iw dev wlan0 station dump

    Station 12:34:56:78:9a:bc (on wlan0)
    	inactive time:	1450 ms
    	rx bytes:	24668671
    	rx packets:	114373
    	tx bytes:	1606991
    	tx packets:	8557
    	tx retries:	623
    	tx failed:	1425
    	signal:  	-52 dBm
    	signal avg:	-53 dBm
    	tx bitrate:	150.0 MBit/s MCS 7 40MHz short GI
    	authorized:	yes
    	authenticated:	yes
    	preamble:	long
    	WMM/WME:	yes
    	MFP:		no
    	TDLS peer:	no

Interface activation

(Usually not required)

Some cards require that the kernel interface be activated before you can
use iw or wireless_tools:

    # ip link set wlan0 up

Note:If you get errors like
RTNETLINK answers: Operation not possible due to RF-kill, make sure that
hardware switch is on. See #Rfkill caveat for details.

To verify that the interface is up, inspect the output of the following
command:

    # ip link show wlan0

    3: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state DOWN mode DORMANT group default qlen 1000
        link/ether 12:34:56:78:9a:bc brd ff:ff:ff:ff:ff:ff

The UP in <BROADCAST,MULTICAST,UP,LOWER_UP> is what indicates the
interface is up, not the later state DOWN.

Access point discovery

See what access points are available:

    # iw dev wlan0 scan | less

Note:If it displays Interface doesn't support scanning, then you
probably forgot to install the firmware. In some cases this message is
also displayed when not running iw as root.

Tip:Depending on your location, you might need to set the correct
regulatory domain in order to see all available networks.

The important points to check:

-   SSID: the name of the network.
-   Signal: is reported in a wireless power ratio in dbm (e.g. from -100
    to 0). The closer the negative value gets to zero, the better the
    signal. Observing the reported power on a good quality link and a
    bad one should give an idea about the individual range.
-   Security: it is not reported directly, check the line starting with
    capability. If there is Privacy, for example
    capability: ESS Privacy ShortSlotTime (0x0411), then the network is
    protected somehow.
    -   If you see an RSN information block, then the network is
        protected by Robust Security Network protocol, also known as
        WPA2.
    -   If you see an WPA information block, then the network is
        protected by Wi-Fi Protected Access protocol.
    -   In the RSN and WPA blocks you may find the following
        information:
        -   Group cipher: value in TKIP, CCMP, both, others.
        -   Pairwise ciphers: value in TKIP, CCMP, both, others. Not
            necessarily the same value than Group cipher.
        -   Authentication suites: value in PSK, 802.1x, others. For
            home router, you'll usually find PSK (i.e. passphrase). In
            universities, you are more likely to find 802.1x suite which
            requires login and password. Then you will need to know
            which key management is in use (e.g. EAP), and what
            encapsulation it uses (e.g. PEAP). Find more details at
            Wikipedia:Authentication protocol and the sub-articles.
    -   If you do not see neither RSN nor WPA blocks but there is
        Privacy, then WEP is used.

Operating mode

(Optional, but may be required)

At this step you might need to set the proper operating mode of the
wireless card. More specifically, if you are going to connect an ad-hoc
network, you need to set the operating mode to ibss:

    # iw dev wlan0 set type ibss

Note:Changing the operating mode on some cards might require the
wireless interface to be down (ip link set wlan0 down).

Association

Depending on the encryption, you need to associate your wireless device
with the access point to use and pass the encryption key.

-   No encryption

    # iw dev wlan0 connect your_essid

-   WEP

using a hexadecimal or ASCII key (the format is distinguished
automatically, because a WEP key has a fixed length):

    # iw dev wlan0 connect your_essid key 0:your_key

using a hexadecimal or ASCII key, specifying the third set up key as
default (keys are counted from zero, four are possible):

    # iw dev wlan0 connect your_essid key d:2:your_key

-   WPA/WPA2

You need to edit the /etc/wpa_supplicant.conf file as described in
WPA_Supplicant and according to what you got from #Access point
discovery. Then, issue this command:

    # wpa_supplicant -i wlan0 -c /etc/wpa_supplicant.conf

This is assuming your device uses the wext driver. If this does not
work, you may need to adjust these options. If connected successfully,
continue in a new terminal (or quit wpa_supplicant with Ctrl+c and add
the -B switch to the above command to run it in the background).
WPA_Supplicant contains more information and troubleshooting.

Regardless of the method used, you can check if you have associated
successfully:

    # iw dev wlan0 link

Getting an IP address

Note:See Network configuration#Configure the IP address for more
examples. This part is identical.

Finally, provide an IP address to the network interface. Simple examples
are:

    # dhcpcd wlan0

or

    # dhclient wlan0

for DHCP, or

    # ip addr add 192.168.0.2/24 dev wlan0
    # ip route add default via 192.168.0.1

for static IP addressing.

Tip:dhcpcd contains a hook (enabled by default) to automatically launch
WPA supplicant on wireless interfaces. It is started only if a
configuration file at /etc/wpa_supplicant.conf exists and no
wpa_supplicant process is listening on that interface. In most cases,
you do not need to create any custom service, just enable
dhcpcd@interface.

Custom startup scripts/services

Although the manual configuration method will help troubleshoot wireless
problems, you will have to re-type every command each time you reboot.
You can also quickly write a shell script to automate the whole process,
which is still a quite convenient way of managing network connection
while keeping full control over your configuration. You can find some
examples in this section.

Manual wireless connection at boot using systemd and dhcpcd

This example uses systemd for start up, WPA supplicant for connecting,
and dhcpcd for assigning an IP address.

Note:Make sure that wpa_supplicant is installed and create
/etc/wpa_supplicant.conf. See WPA supplicant for details.

Create a systemd unit, e.g
/etc/systemd/system/network-wireless@.service:

    /etc/systemd/system/network-wireless@.service

    [Unit]
    Description=Wireless network connectivity (%i)
    Wants=network.target
    Before=network.target
    BindsTo=sys-subsystem-net-devices-%i.device
    After=sys-subsystem-net-devices-%i.device

    [Service]
    Type=oneshot
    RemainAfterExit=yes

    ExecStart=/usr/bin/ip link set dev %i up
    ExecStart=/usr/bin/wpa_supplicant -B -i %i -c /etc/wpa_supplicant.conf
    ExecStart=/usr/bin/dhcpcd %i

    ExecStop=/usr/bin/ip link set dev %i down

    [Install]
    WantedBy=multi-user.target

Enable the unit and start it, passing the name of the interface:

    # systemctl enable network-wireless@wlan0.service
    # systemctl start network-wireless@wlan0.service

Systemd with wpa_supplicant and static IP

Note:Make sure that wpa_supplicant is installed and create
/etc/wpa_supplicant.conf. See WPA supplicant for details.

First create configuration file for the systemd service, replace
interface with proper interface name:

    /etc/conf.d/network-wireless@interface

    address=192.168.0.10
    netmask=24
    broadcast=192.168.0.255
    gateway=192.168.0.1

Create a systemd unit file:

    /etc/systemd/system/network-wireless@.service

    [Unit]
    Description=Wireless network connectivity (%i)
    Wants=network.target
    Before=network.target
    BindsTo=sys-subsystem-net-devices-%i.device
    After=sys-subsystem-net-devices-%i.device

    [Service]
    Type=oneshot
    RemainAfterExit=yes
    EnvironmentFile=/etc/conf.d/network-wireless@%i

    ExecStart=/usr/bin/ip link set dev %i up
    ExecStart=/usr/bin/wpa_supplicant -B -i %i -c /etc/wpa_supplicant.conf
    ExecStart=/usr/bin/ip addr add ${address}/${netmask} broadcast ${broadcast} dev %i
    ExecStart=/usr/bin/ip route add default via ${gateway}

    ExecStop=/usr/bin/ip addr flush dev %i
    ExecStop=/usr/bin/ip link set dev %i down

    [Install]
    WantedBy=multi-user.target

Enable the unit and start it, passing the name of the interface:

    # systemctl enable network-wireless@wlan0.service
    # systemctl start network-wireless@wlan0.service

> Automatic setup

There are many solutions to choose from, but remember that all of them
are mutually exclusive; you should not run two daemons simultaneously.
The following table compares the different connection managers,
additional notes are in subsections below.

  ----------------------------------------------------------------------------------------------------------------
  Connection manager   Network       Roaming                    PPP support       Official      Console tools
                       profiles      (auto connect dropped      (e.g. 3G modem)   GUI           
                       support       or changed location)                                       
  -------------------- ------------- -------------------------- ----------------- ------------- ------------------
  Connman              Yes           Yes                        Yes               No            connmanctl

  Netctl               Yes           Yes                        Yes               No            netctl,wifi-menu

  NetworkManager       Yes           Yes                        Yes               Yes           nmcli

  Wicd                 Yes           Yes                        No                Yes           wicd-curses
  ----------------------------------------------------------------------------------------------------------------

Netctl

netctl is a replacement for netcfg designed to work with systemd. It
uses a profile based setup and is capable of detection and connection to
a wide range of network types. This is no harder than using graphical
tools.

See: Netctl

Wicd

Wicd is a network manager that can handle both wireless and wired
connections. It is written in Python and Gtk with fewer dependencies
than NetworkManager, making it an ideal solution for lightweight desktop
users.

See: Wicd

Note:wicd may cause excessive dropped connections with some drivers,
while NetworkManager might work better.

NetworkManager

NetworkManager is an advanced network management tool that is enabled by
default in most popular GNU/Linux distributions. In addition to managing
wired connections, NetworkManager provides worry-free wireless roaming
with an easy-to-use GUI program for selecting your desired network.

See: NetworkManager

Note:GNOME's network-manager-applet also works under Xfce if you install
xfce4-xfapplet-plugin (available in the AUR) first. Additionally, there
are applets available for KDE.

WiFi Radar

WiFi Radar is a Python/PyGTK2 utility for managing wireless (and only
wireless) profiles. It enables you to scan for available networks and
create profiles for your preferred networks.

See: Wifi Radar

Troubleshooting
---------------

This section contains general troubleshooting tips, not strictly related
to problems with drivers or firmware. For such topics, see next section.

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Commands in      
                           following subsections    
                           need updating according  
                           to wireless_tools -> iw  
                           transition. (Discuss)    
  ------------------------ ------------------------ ------------------------

> Rfkill caveat

Many laptops have a hardware button (or switch) to turn off wireless
card, however, the card can also be blocked by kernel. This can be
handled by rfkill. Use rfkill to show the current status:

    # rfkill list

    0: phy0: Wireless LAN
    	Soft blocked: yes
    	Hard blocked: yes

If the card is hard-blocked, use the hardware button (switch) to unblock
it. If the card is not hard-blocked but soft-blocked, use the following
command:

    # rfkill unblock wifi

Note:It is possible that the card will go from hard-blocked and
soft-unblocked state into hard-unblocked and soft-blocked state by
pressing the hardware button (i.e. the soft-blocked bit is just switched
no matter what). This can be adjusted by tuning some options of the
rfkill kernel module.

More info:
http://askubuntu.com/questions/62166/siocsifflags-operation-not-possible-due-to-rf-kill

> Regulatory domain

For example, the iwl3945 driver is by default configured to only work
with networks on channels 1-11. Higher frequency bands are not allowed
in some parts of the world (e.g. the US). In the EU however, channels 12
and 13 are used quite commonly (and Japan allows for channel 14). If the
regulatory domain is set to e.g. US, then networks using higher channels
will not show up in the scan.

It is possible to configure the cfg80211 kernel module to use specific
regulatory domain by adding e.g. options cfg80211 ieee80211_regdom=EU to
/etc/modprobe.d/modprobe.conf (see Kernel modules for details).

Tip:Check the Frequencies: block in the output of iw list to see which
frequencies are allowed for your card.

An alternative configuration would be installing the crda package and
editing /etc/conf.d/wireless-regdom (the file is actually provided by
wireless-regdb which is a dependency of crda).

> Observing Logs

A good first measure to troubleshoot is to analyze the system's logfiles
first. In order not to manually parse through them all, it can help to
open a second terminal/console window and watch the kernels messages
with

    $ dmesg -w

while performing the action, e.g. the wireless association attempt.

When using a tool for network management, the same can be done for
systemd with

    # journalctl -f 

The individual tools used in this article further provide options for
more detailed debugging output, which can be used in a second step of
the analysis, if required.

> Power saving

See Power saving#Network interfaces.

> Failed to get IP address

-   If getting an IP address repeatedly fails using the default dhcpcd
    client, try installing and using dhclient instead. Do not forget to
    select dhclient as the primary DHCP client in your connection
    manager!

-   If you can get an IP address for a wired interface and not for a
    wireless interface, try disabling the wireless card's power saving
    features:

    # iwconfig wlan0 power off

-   If you get a timeout error due to a waiting for carrier problem,
    then you might have to set the channel mode to auto for the specific
    device:

    # iwconfig wlan0 channel auto

Before changing the channel to auto, make sure your wireless interface
is down. After it has successfully changed it, you can bring the
interface up again and continue from there.

> Connection always times out

The driver may suffer from a lot of tx excessive retries and invalid
misc errors for some unknown reason, resulting in a lot of packet loss
and keep disconnecting, sometimes instantly. Following tips might be
helpful.

Lowering the rate

Try setting lower rate, for example 5.5M:

    # iwconfig wlan0 rate 5.5M auto

Fixed option should ensure that the driver does not change the rate on
its own, thus making the connection a bit more stable:

    # iwconfig wlan0 rate 5.5M fixed

Lowering the txpower

You can try lowering the transmit power as well. This may save power as
well:

    # iwconfig wlan0 txpower 5

Valid settings are from 0 to 20, auto and off.

Setting rts and fragmentation thresholds

Default iwconfig options have rts and fragmentation thresholds off.
These options are particularly useful when there are many adjacent APs
or in a noisy environment.

The minimum value for fragmentation value is 256 and maximum is 2346. In
many windows drivers the maximum is the default value:

    # iwconfig wlan0 frag 2346

For rts minimum is 0, maximum is 2347. Once again windows drivers often
use maximum as the default:

    # iwconfig wlan0 rts 2347

> Random disconnections

Cause #1

If dmesg says
wlan0: deauthenticating from MAC by local choice (reason=3) and you lose
your Wi-Fi connection, it is likely that you have a bit too aggressive
power-saving on your Wi-Fi card[2]. Try disabling the wireless card's
power-saving features:

    # iwconfig wlan0 power off

See Power saving for tips on how to make it permanent (just specify off
instead of on).

If your card does not support iwconfig wlan0 power off, check the BIOS
for power management options. Disabling PCI-Express power management in
the BIOS of a Lenovo W520 resolved this issue.

Cause #2

If you are experiencing frequent disconnections and dmesg shows messages
such as

ieee80211 phy0: wlan0: No probe response from AP xx:xx:xx:xx:xx:xx after 500ms, disconnecting

try changing the channel bandwidth to 20MHz through your router's
settings page.

Cause #3

On some laptop models with hardware rfkill switches (e.g., Thinkpad X200
series), due to wear or bad design, the switch (or its connection to the
mainboard) might become loose over time resulting in seemingly random
hardblocks/disconnects when you accidentally touch the switch or move
the laptop. There is no software solution to this, unless your switch is
electrical and the BIOS offers the option to disable the switch. If your
switch is mechanical (most are), there are lots of possible solutions,
most of which aim to disable the switch: Soldering the contact point on
the mainboard/wifi-card, glueing or blocking the switch, using a screw
nut to tighten the switch or removing it altogether.

Troubleshooting drivers and firmware
------------------------------------

This section covers methods and procedures for installing kernel modules
and firmware for specific chipsets, that differ from generic method.

See Kernel modules for general informations on operations with modules.

> Ralink

rt2x00

Unified driver for Ralink chipsets (it replaces rt2500, rt61, rt73,
etc). This driver has been in the Linux kernel since 2.6.24, you only
need to load the right module for the chip: rt2400pci, rt2500pci,
rt2500usb, rt61pci or rt73usb which will autoload the respective rt2x00
modules too.

A list of devices supported by the modules is available at the project's
homepage.

Additional notes

-   Since kernel 3.0, rt2x00 includes also these drivers: rt2800pci,
    rt2800usb.
-   Since kernel 3.0, the staging drivers rt2860sta and rt2870sta are
    replaced by the mainline drivers rt2800pci and rt2800usb[3].
-   Some devices have a wide range of options that can be configured
    with iwpriv. These are documented in the source tarballs available
    from Ralink.

rt3090

For devices which are using the rt3090 chipset it should be possible to
use rt2800pci driver, however, is not working with this chipset very
well (e.g. sometimes it's not possible to use higher rate than 2Mb/s).

The best way is to use the rt3090-dkms driver from AUR. Make sure to
blacklist the rt2800pci module and setup the rt3090sta module to load at
boot.

Note:This driver also works with rt3062 chipsets. Also the rt3090
package is not supported by the latest kernel and has been orphaned
rt3090-dkms should be used instead.

rt3290

The rt3290 chipset is recognised by the kernel rt2800pci module.
However, some users experience problems and reverting to a patched
Ralink driver seems to be beneficial in these cases.

rt3573

New chipset as of 2012. It may require proprietary drivers from Ralink.
Different manufacturers use it, see the Belkin N750 DB wireless usb
adapter forums thread.

rt5572

New chipset as of 2012 with support for 5 Ghz bands. It may require
proprietary drivers from Ralink and some effort to compile them. At the
time of writing a how-to on compilation is available for a DLINK DWA-160
rev. B2 here.

> Realtek

rtl8192cu

The driver is now in the kernel, but many users have reported being
unable to make a connection although scanning for networks does work.

The dkms-8192cu package in the AUR may be a better choice for some
users.

rtl8192e

The driver is part of the current kernel package. The module
initialization may fail at boot giving this error message:

    rtl819xE:ERR in CPUcheck_firmware_ready()
    rtl819xE:ERR in init_firmware() step 2
    rtl819xE:ERR!!! _rtl8192_up(): initialization is failed!
    r8169 0000:03:00.0: eth0: link down

A workaround is to simply unload the module:

    # modprobe -r r8192e_pci

and reload the module (after a pause):

    # modprobe r8192e_pci

rtl8188eu

Some dongles, like the TP-Link TL-WN725N v2 (not sure, but it seems that
uses the rtl8179 chipset), use chipsets compatible with this driver. In
order to use it you have to install the dkms-8188eu package in the AUR.

> Atheros

The MadWifi team currently maintains three different drivers for devices
with Atheros chipset:

-   madwifi is an old, obsolete driver. Not present in Arch kernel since
    2.6.39.1[4].
-   ath5k is newer driver, which replaces the madwifi driver. Currently
    a better choice for some chipsets, but not all chipsets are
    supported (see below)
-   ath9k is the newest of these three drivers, it is intended for newer
    Atheros chipsets. All of the chips with 802.11n capabilities are
    supported.

There are some other drivers for some Atheros devices. See Linux
Wireless documentation for details.

ath5k

External resources:

-   http://wireless.kernel.org/en/users/Drivers/ath5k
-   http://wiki.debian.org/ath5k

If you find web pages randomly loading very slow, or if the device is
unable to lease an IP address, try to switch from hardware to software
encryption by loading the ath5k module with nohwcrypt=1 option. See
Kernel Modules#Setting module options for details.

Some laptops may have problems with their wireless LED indicator
flickering red and blue. To solve this problem, do:

    # echo none > /sys/class/leds/ath5k-phy0::tx/trigger
    # echo none > /sys/class/leds/ath5k-phy0::rx/trigger

For alternatives, see this bug report.

ath9k

External resources:

-   http://wireless.kernel.org/en/users/Drivers/ath9k
-   http://wiki.debian.org/ath9k

In the unlikely event that you have stability issues that trouble you,
you could try using the compat-wireless package. An ath9k mailing list
exists for support and development related discussions.

ASUS

With some ASUS laptops (tested with ASUS U32U series), it could help to
add options asus_nb_wmi wapf=1 to /etc/modprobe.d/asus_nb_wmi.conf to
fix rfkill-related issues.

> Intel

ipw2100 and ipw2200

These modules are fully supported in the kernel, but they require
additional firmware. Depending on which of the chipsets you have,
install either ipw2100-fw or ipw2200-fw. Then reload the appropriate
module.

Tip:You may use the following module options:

-   use the rtap_iface=1 option to enable the radiotap interface
-   use the led=1 option to enable a front LED indicating when the
    wireless is connected or not

iwlegacy

iwlegacy is the wireless driver for Intel's 3945 and 4965 wireless
chips. The firmware is included in the linux-firmware package.

udev should load the driver automatically, otherwise load iwl3945 or
iwl4965 manually. See Kernel modules#Loading for details.

iwlwifi

iwlwifi is the wireless driver for Intel's current wireless chips, such
as 5100AGN, 5300AGN, and 5350AGN. See the full list of supported
devices. The firmware is included in the linux-firmware package.

If you have problems connecting to networks in general or your link
quality is very poor, try to disable 802.11n and enable software
encryption:

    /etc/modprobe.d/iwlwifi.conf

    options iwlwifi 11n_disable=1
    options iwlwifi swcrypto=1

In case this does not work for you, you may try disabling power saving
for your wireless adapter. For a permanent solution, add a new udev
rule:

    /etc/udev/rules.d/80-iwlwifi.rules

    ACTION=="add", SUBSYSTEM=="net", ATTR{address}=="<your_mac_address>", RUN+="/usr/bin/iw dev %k set power_save off"

Disabling LED blink

Note:This works with the iwlegacy and iwlwifi drivers.

The default settings on the module are to have the LED blink on
activity. Some people find this extremely annoying. To have the LED on
solid when Wi-Fi is active, you can use the systemd-tmpfiles:

    /etc/tmpfiles.d/phy0-led.conf

    w /sys/class/leds/phy0-led/trigger - - - - phy0radio

Run systemd-tmpfiles --create phy0-led.conf for the change to take
effect, or reboot.

To see all the possible trigger values for this LED:

    # cat /sys/class/leds/phy0-led/trigger

Tip:If you do not have /sys/class/leds/phy0-led, you may try to use the
led_mode="1" module option. It should be valid for both iwlwifi and
iwlegacy drivers.

> Broadcom

See Broadcom wireless.

> Other drivers/devices

Tenda w322u

Treat this Tenda card as an rt2870sta device. See #rt2x00.

orinoco

This should be a part of the kernel package and be installed already.

Some Orinoco chipsets are Hermes II. You can use the wlags49_h2_cs
driver instead of orinoco_cs and gain WPA support. To use the driver,
blacklist orinoco_cs first.

prism54

The driver p54 is included in kernel, but you have to download the
appropriate firmware for your card from this site and install it into
the /usr/lib/firmware directory.

Note:There's also older, deprecated driver prism54, which might conflict
with the newer driver (p54pci or p54usb). Make sure to blacklist
prism54.

ACX100/111

Warning:The drivers for these devices are broken and do not work with
newer kernel versions.

Packages: tiacx tiacx-firmware (deleted from official repositories and
AUR)

See official wiki for details.

zd1211rw

zd1211rw is a driver for the ZyDAS ZD1211 802.11b/g USB WLAN chipset,
and it is included in recent versions of the Linux kernel. See [5] for a
list of supported devices. You only need to install the firmware for the
device, provided by the zd1211-firmware package.

hostap_cs

Host AP is a Linux driver for wireless LAN cards based on Intersil's
Prism2/2.5/3 chipset. The driver is included in Linux kernel.

Note:Make sure to blacklist the orinico_cs driver, it may cause
problems.

> ndiswrapper

Ndiswrapper is a wrapper script that allows you to use some Windows
drivers in Linux. See the compatibility list here. You will need the
.inf and .sys files from your Windows driver. Be sure to use drivers
appropriate to your architecture (x86 vs. x86_64).

Tip:If you need to extract these files from an *.exe file, you can use
cabextract.

Follow these steps to configure ndiswrapper.

1. Install the driver to /etc/ndiswrapper/*

    # ndiswrapper -i filename.inf

2. List all installed drivers for ndiswrapper

    $ ndiswrapper -l

3. Let ndiswrapper write its configuration in
/etc/modprobe.d/ndiswrapper.conf:

    # ndiswrapper -m
    # depmod -a

Now the ndiswrapper install is almost finished; follow the instructions
on Kernel modules#Loading to automatically load the module at boot.

The important part is making sure that ndiswrapper exists on this line,
so just add it alongside the other modules. It would be best to test
that ndiswrapper will load now, so:

    # modprobe ndiswrapper
    # iwconfig

and wlan0 should now exist. Check this page if you are having problems:
Ndiswrapper installation wiki.

> compat-drivers-patched

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason:                  
                           compat-drivers-patched   
                           has reached end-of-life, 
                           backports-patched should 
                           be used instead          
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Patched compat wireless drivers correct the "fixed-channel -1" issue,
whilst providing better injection. Please install the
compat-drivers-patched package from the AUR.

compat-drivers-patched does not conflict with any other package and the
modules built reside in /usr/lib/modules/your_kernel_version/updates.

These patched drivers come from the Linux Wireless project and support
many of the above mentioned chips such as:

    ath5k ath9k_htc carl9170 b43 zd1211rw rt2x00 wl1251 wl12xx ath6kl brcm80211

Supported groups:

    atheros ath iwlagn rtl818x rtlwifi wl12xx atlxx bt

It is also possible to build a specific module/driver or a group of
drivers by editing the PKGBUILD, particularly uncommenting the line #46.
Here is an example of building the atheros group:

    scripts/driver-select atheros

Please read the package's PKGBUILD for any other possible modifications
prior to compilation and installation.

See also
--------

-   The Linux Wireless project
-   Aircrack-ng guide on installing drivers

Retrieved from
"https://wiki.archlinux.org/index.php?title=Wireless_network_configuration&oldid=304843"

Category:

-   Wireless Networking

-   This page was last modified on 16 March 2014, at 08:00.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
