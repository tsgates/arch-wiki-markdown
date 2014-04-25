netctl
======

Related articles

-   Network configuration
-   Wireless network configuration
-   NetworkManager
-   Wicd
-   Bridge with netctl

netctl is a CLI-based tool used to configure and manage network
connections via profiles. It is a native Arch Linux project that
replaces the old netcfg utility.

Contents
--------

-   1 Installation
-   2 Required reading
-   3 Configuration
    -   3.1 Automatic operation
        -   3.1.1 Basic method
        -   3.1.2 Automatic switching of profiles
    -   3.2 Migrating from netcfg
    -   3.3 Passphrase obfuscation (256-bit PSK)
-   4 Tips and tricks
    -   4.1 Using a GUI
    -   4.2 Replace 'netcfg current'
    -   4.3 Eduroam
    -   4.4 Bonding
        -   4.4.1 Load balancing
        -   4.4.2 Wired to wireless failover
    -   4.5 DHCP timeout issues
    -   4.6 Using any interface
-   5 See also

Installation
------------

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: Optional         
                           dependencies should be   
                           mentioned. (Discuss)     
  ------------------------ ------------------------ ------------------------

The netctl package is available in the official repositories. Installing
netctl will replace netcfg.

netctl and netcfg are conflicting packages. You will be potentially
connectionless after installing netctl if your profiles are
misconfigured.

Note:It may be a good idea to use systemctl --type=service to ensure
that no other service is running that may want to configure the network.
Multiple networking services will conflict.

Required reading
----------------

It is advisable to read the following man pages before using netctl:

-   netctl
-   netctl.profile
-   netctl.special

Configuration
-------------

netctl uses profiles to manage network connections, profile files are
stored in /etc/netctl/. Example configuration files are provided for the
user to assist them in configuring their network connection. These
example profiles are located in /etc/netctl/examples/. The common
configurations include:

-   ethernet-dhcp
-   ethernet-static
-   wireless-wpa
-   wireless-wpa-static

To use an example profile, simply copy one of them from
/etc/netctl/examples/ to /etc/netctl/ and configure it to your needs:

    # cp /etc/netctl/examples/wireless-wpa /etc/netctl/profile

Note:You will most probably need to edit the interface name in the
profile. As of v197, udev no longer assigns network interface names
according to the wlanX and ethX naming scheme. Please do not assume that
your wireless interface is named wlan0, or that your wired interface is
named eth0. You can use the command ip link to discover the names of
your interfaces.

Tip:For wireless settings, you can use wifi-menu -o to generate the
profile file in /etc/netctl/.

Once you have created your profile, make an attempt to establish a
connection using the newly created profile by running:

    # netctl start profile

Note:profile is the file name, not including the full path. Providing
the full path will make netctl exit with an error code.

If issuing the above command results in a failure, then use
journalctl -xn and netctl status profile in order to obtain a more in
depth explanation of the failure. Make the needed corrections to the
failed configuration and retest.

> Automatic operation

If you use only one profile (per interface) or want to switch profiles
manually, the Basic method will do. Most common examples are servers,
workstations, routers etc.

If you need to switch multiple profiles frequently, use Automatic
switching of profiles. Most common examples are laptops.

Basic method

With this method, you can statically start only one profile per
interface. First manually check that the profile can be started
successfully, then it can be enabled using

    # netctl enable profile

This will create and enable a systemd service that will start when the
computer boots. Changes to the profile file will not propagate to the
service file automatically. After such changes, it is necessary to
reenable the profile:

    # netctl reenable profile

Note:The connection is only established if the profile can be started
succesfully at boot time (or when the service starts). That specifically
means, in case of wired connection the cable must be plugged-in, in case
of wireless connection the network must be in range.

Tip:To enable static IP profile on wired interface no matter if the
cable is connected or not, use SkipNoCarrier=yes in your profile.

Automatic switching of profiles

netctl provides two special systemd services for automatic switching of
profiles:

-   For wired interfaces: netctl-ifplugd@interface.service. Using this
    netctl profiles change as you plug the cable in and out.
-   For wireless interfaces: netctl-auto@interface.service. Using this
    netctl profiles change as you move from range of one network into
    range of other network.

Note:netcfg used net-auto-wireless.service and net-auto-wired.service
for this purpose.

First install required packages:

-   Package wpa_actiond is required to use
    netctl-auto@interface.service.
-   Package ifplugd is required to use netctl-ifplugd@interface.service.

Now configure all profiles that netctl-auto@interface.service or
netctl-ifplugd@interface.service can start.

If you want some wireless profile not to be started automatically by
netctl-auto@interface.service, you have to explicitly add
ExcludeAuto=yes to that profile. You can use Priority= to set priority
of some profile when multiple profiles are available.
netctl-ifplugd@interface.service will prefer profiles, which use DHCP.
To prefer a profile with a static IP, you can use AutoWired=yes. See
netctl.profile(5) for details.

Warning:Automatic selection of a WPA-enabled profile by netctl-auto is
not possible with option Security=wpa-config, please use
Security=wpa-configsection instead.

Once your profiles are set and verified to be working, simply enable
these services using systemctl:

    # systemctl enable netctl-auto@interface.service 
    # systemctl enable netctl-ifplugd@interface.service  

> Warning:

-   If any of the profiles contain errors, such as an empty or misquoted
    Key= variable, the unit will fail to load with the message
    "Failed to read or parse configuration '/run/network/wpa_supplicant_wlan0.conf',
    even when that profile is not being used.
-   This method conflicts with the Basic method. If you have previously
    enabled a profile through netctl, run netctl disable profile to
    prevent the profile from starting twice at boot.

Since netctl 1.3, it possible to manually control an interface otherwise
managed by netctl-auto without having to stop the netctl-auto service.
This is done using the netctl-auto command. To have a list of available
actions just run:

     # netctl-auto --help

> Migrating from netcfg

netctl uses /etc/netctl/ to store its profiles, not /etc/network.d/
(used by netcfg).

In order to migrate from netcfg, at least the following is needed:

-   Disable the netcfg service: systemctl disable netcfg.service.
-   Uninstall netcfg and install netctl.
-   Move network profile files to the new directory.
-   Rename variables therein according to netctl.profile(5) (Most
    variable names have only UpperCamelCase i.e CONNECTION becomes
    Connection).
-   For static IP configuration make sure the Address variables have a
    netmask after the IP (e.g.
    Address=('192.168.1.23/24' '192.168.1.87/24') in the example
    profile).
-   If you setup a wireless profile according in the
    wireless-wpa-configsection example, note that this overrides
    wpa_supplicant options defined above the brackets. For a connection
    to a hidden wireless network, add scan_ssid=1 to the options in the
    wireless-wpa-configsection; Hidden=yes does not work there.
-   Unquote interface variables and other variables that don't strictly
    need quoting (this is mainly a style thing).
-   Run netctl enable profile for every profile in the old NETWORKS
    array. last doesn't work this way, see netctl.special(7).
-   Use netctl list and/or netctl start profile instead of netcfg-menu.
    wifi-menu remains available.
-   Unlike netcfg, by default netctl fails to bring up a NIC when it is
    not connected to another powered up NIC. To solve this problem, add
    SkipNoCarrier=yes at the end of your /etc/netctl/profile.

> Passphrase obfuscation (256-bit PSK)

Note:Although "encrypted", the key that you put in the profile
configuration is enough to connect to a WPA-PSK network. Therefore this
process is only useful for hiding the human-readable version of the
passphrase. This will not prevent anyone with read access to this file
from connecting to the network. You should ask yourself if there is any
use in this at all, since using the same passphrase for anything else is
a very poor security measure.

Users not wishing to have the passphrase to their wireless network
stored in plain text have the option of storing the corresponding
256-bit pre-shared key (PSK) instead, which is calculated from the
passphrase and the SSID using standard algorithms.

-   Method 1: Use wifi-menu -o to generate a config file in /etc/netctl/
-   Method 2: Manual settings as follows.

For both methods it is suggested to chmod 600 /etc/netctl/<config_file>
to prevent user access to the password.

Calculate your 256-bit PSK using wpa_passphrase:

    $ wpa_passphrase your_essid passphrase

    network={
      ssid="your_essid"
      #psk="passphrase"
      psk=64cf3ced850ecef39197bb7b7b301fc39437a6aa6c6a599d0534b16af578e04a
    }

Note:This information will be used in your profile, so do not close the
terminal.

In a second terminal window, copy the example file wireless-wpa from
/etc/netctl/examples to /etc/netctl:

    # cp /etc/netctl/examples/wireless-wpa /etc/netctl/wireless-wpa

You will then need to edit /etc/netctl/wireless-wpa using your favorite
text editor and add the pre-shared key, that was generated earlier using
wpa_passphrase, to the Key variable of this profile.

Once completed your network profile wireless-wpa containing a 256-bit
PSK should resemble:

    /etc/netctl/wireless-wpa

    Description='A simple WPA encrypted wireless connection using 256-bit PSK'
    Interface=wlp2s2
    Connection=wireless
    Security=wpa
    IP=dhcp
    ESSID=your_essid
    Key=\"64cf3ced850ecef39197bb7b7b301fc39437a6aa6c6a599d0534b16af578e04a

> Note:

-   Make sure to use the special quoting rules for the Key variable as
    explained at the end of netctl.profile(5).
-   If the passphrase fails, try removing the \" in the Key variable.

Tips and tricks
---------------

> Using a GUI

If you want a graphical user interface to manage netctl and your
connections, you can install netgui. Note, however, that netgui is still
in beta status and you should be familiar with the general netctl syntax
to debug possible issues.

> Replace 'netcfg current'

If you used netcfg current in the past, you can use
# netctl-auto current as a replacement for connections started with
netctl-auto (feature since netctl-1.3).

To manually parse the connections, you can also use:

    # netctl list | awk '/*/ {print $2}'

> Eduroam

Some universities use a system called "Eduroam" to manage their wireless
networks. For this system, a WPA config-section profile with the
following format is often useful:

    /etc/netctl/wlan0-eduroam

    Description='Eduroam-profile for <user>'
    Interface=wlan0
    Connection=wireless
    Security=wpa-configsection
    IP=dhcp
    WPAConfigSection=(
     'ssid="eduroam"'
     'proto=RSN WPA'
     'key_mgmt=WPA-EAP'
     'auth_alg=OPEN'
     'eap=PEAP'
     'identity="<user>"'
     'password="<password>"'
    )

Tip:To prevent storing your password as plaintext, you can generate a
password hash with
$ echo -n <password> | iconv -t utf16le | openssl md4. Then use it as
'password=hash:<hash>'.

For TTLS and certified universities this setup works:

    /etc/netctl/wlan0-eduroam

    Description='Eduroam university'
    Interface=wlan0 
    Connection=wireless
    Security=wpa-configsection
    IP=dhcp
    ESSID=eduroam
    WPAConfigSection=(
        'ssid="eduroam"'
        'proto=RSN WPA'
        'key_mgmt=WPA-EAP'
        'eap=TTLS'
        'anonymous_identity="anonymous@domain_university"'
        'identity="XXX@domain_university"'
        'password="XXX"'
        'ca_path="/etc/ssl/certs/"'
        'ca_path2="/etc/ssl/certs/"'
        'phase2="auth=PAP"'
    )

> Bonding

From kernel documentation:

The Linux bonding driver provides a method for aggregating multiple
network interfaces into a single logical "bonded" interface. The
behavior of the bonded interfaces depends on the mode. Generally
speaking, modes provide either hot standby or load balancing services.
Additionally, link integrity monitoring may be performed.

Load balancing

To use bonding with netctl, additional package from official
repositories is required: ifenslave.

Copy /etc/netctl/examples/bonding to /etc/netctl/bonding and edit it,
for example:

    /etc/netctl/bonding

    Description='Bond Interface'
    Interface='bond0'
    Connection=bond
    BindsToInterfaces=('eth0' 'eth1')
    IP=dhcp
    IP6=stateless

Now you can disable your old configuration and set bonding to be started
automatically. Switch to the new profile, for example:

    # netctl switch-to bonding

Note:This uses the round-robin policy, which is the default for the
bonding driver. See official documentation for details.

Tip:To check the status and bonding mode:

    $ cat /proc/net/bonding/bond0

Wired to wireless failover

This example describes how to use bonding to fallback to wireless when
the wired ethernet goes down. It is assumed that dhcpcd service is
running for all interfaces as by default.

You'll need additional packages from the official repositories: ifplugd,
ifenslave and wpa_supplicant.

First configure the bonding driver to use active-backup:

    /etc/modprobe.d/bonding.conf

    options bonding mode=active-backup
    options bonding miimon=100
    options bonding primary=eth0
    options bonding max_bonds=0

The max_bonds option avoids the Interface bond0 already exists error.
fail_over_mac=active setting may be added if MAC filtering is used.

Next, configure a netctl profile to enslave the two hardware interfaces:

    /etc/netctl/failover

    Description='A wired connection with failover to wireless'
    Interface='bond0'
    Connection=bond
    BindsToInterfaces=('eth0' 'wlan0')
    IP='dhcp'
    SkipNoCarrier='no'

Enable the profile on startup.

    # netctl enable failover

Configure wpa_supplicant to associate with known networks. This can be
done with a netctl profile (remember to use IP='no') and a
wpa_supplicant service running constantly, or on-demand with wpa_cli.
Ways to do this are covered on the wpa_supplicant page. To run
wpa_supplicant constantly create wpa_supplicant config file
/etc/wpa_supplicant/wpa_supplicant-wlan0.conf and then run:

    # systemctl enable wpa_supplicant@wlan0

Set IP='no' in wired network profile. IP address should be assigned to
bond0 interface only.

If you have a wired and wireless connection to the same network, you can
probably now disconnect and reconnect the wired connection without
losing connectivity. In most cases, even streaming music won't skip!

> DHCP timeout issues

If you are having timeout issues when requesting leases via DHCP you can
set the timeout value higher than netctl's 30 seconds by default. Create
a file in /etc/netctl/hooks/ or /etc/netctl/interfaces/, add
TimeoutDHCP=40 to it for a timeout of 40 seconds and make the file
executable.

> Using any interface

In some cases it may be desirable to allow a profile to use any
interface on the system. A common example use case is using a common
disk image across many machines with differing hardware (this is
especially useful if they are headless). If you use the kernel's naming
scheme, and your machine has only one ethernet interface, you can
probably guess that eth0 is the right interface. If you use udev's
Predictable Network Interface Names, however, names will be assigned
based on the specific hardware itself (e.g. enp1s0), rather than simply
the order that the hardware was detected (e.g. eth0, eth1). This means
that a netctl profile may work on one machine and not another, because
they each have different interface names.

A quick and dirty solution is to make use of the /etc/netctl/interfaces/
directory. Choose a name for your interface alias (en-any in this
example), and write the following to a file with that name (making sure
it is executable).

    /etc/netctl/interfaces/en-any

    #!/bin/bash
    for interface in /sys/class/net/en*; do
            break;
    done
    Interface=$(basename $interface)
    echo "en-any: using interface $Interface";

Then create a profile that uses the interface. Pay special attention to
the Interfaces directive. The rest are only provided as examples.

    /etc/netctl/wired

    Description='Wired'
    Interface=en-any
    Connection=ethernet
    IP=static
    Address=('192.168.1.15/24')
    Gateway='192.168.1.1'
    DNS=('192.168.1.1')

When the wired profile is started, any machine using the two files above
will automatically bring up and configure the first ethernet interface
found on the system, regardless of what name udev assigned to it. Note
that this is not the most robust way to go about configuring interfaces.
If you use multiple interfaces, netctl may try to assign the same
interface to them, and will likely cause a disruption in connectivity.
If you don't mind a more complicated solution, netctl-auto is likely to
be more reliable.

See also
--------

-   Official announcement thread
-   There is a cinnamon applet available in the AUR:
    cinnamon-applet-netctl-systray-menu

Retrieved from
"https://wiki.archlinux.org/index.php?title=Netctl&oldid=303439"

Category:

-   Networking

-   This page was last modified on 7 March 2014, at 07:30.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
