Autowifi
========

  

Warning:Autowifi has been deprecated in favor of netcfg's
net-auto-wireless mode

Autowifi is a daemon that configures your wireless network automatically
depending on the ESSID. Once configured, no user interaction is
necessary and no GUI tools are required.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 The idea                                                           |
| -   2 Requirements and installation                                      |
| -   3 Configuration                                                      |
|     -   3.1 Configuring wpa_supplicant                                   |
|     -   3.2 Configuring autowifi                                         |
|         -   3.2.1 Advanced configuration                                 |
|                                                                          |
| -   4 Running autowifi                                                   |
+--------------------------------------------------------------------------+

The idea
--------

wpa_supplicant is a very powerful tool. It scans for wireless networks
automatically and associates with the network that has the best quality
and security settings (note: despite its name, it works with WPA, WEP,
and open networks). However, wpa_supplicant doesn't automatically
configure the interface parameters once it has associated, requiring
user interaction everytime.

The idea of autowifi is to fill that gap: It connects to a running
wpa_supplicant and takes care of interface configuration with dhcp,
static ip addresses or custom post-up and post-down scripts.

Requirements and installation
-----------------------------

To use autowifi, you need

-   a wifi driver that is supported by wpa_supplicant (like the ipw*
    drivers, madwifi, rt2x00 or even ndiswrapper)
-   wpa_supplicant
-   dhclient (if you want to use dhcp)

The above are available easily via pacman.

You can install autowifi by getting a package from
https://dev.archlinux.org/~thomas/autowifi/ and installing it with
pacman.

Configuration
-------------

> Configuring wpa_supplicant

For autowifi to work, you have to configure wpa_supplicant.

These options should be present in /etc/wpa_supplicant.conf

    # general options
    # Don't change this path to something else:
    ctrl_interface=/var/run/wpa_supplicant
    # Give everyone in the group "users" access to the control interface
    # required if you want to dynamically configure the network via wpa_cli or wpa_gui without being root
    ctrl_interface_group=users
    eapol_version=1
    ap_scan=1
    fast_reauth=1

For certain drivers, you may need to instead use ap_scan=0 to get
wpa_supplicant to work properly, the default configuration file includes
some information on that topic.

Now, you need to add a network block for each network you usually use.
You can add a priority= option to each of them if you prefer one network
over another.

An open network:

    network={
      ssid="some_open_network"
      key_mgmt=NONE
    }

Connect to any open network in range (this does not work with every
driver):

    network={
      key_mgmt=NONE
    }

A WEP-encrypted network:

    network={
      ssid="some_wep_network"
      key_mgmt=NONE
      wep_key0="abcde"
      wep_key1=0102030405
      wep_key2="1234567890123"
      wep_tx_keyidx=0
      # Add this option for "shared" wep mode
      #auth_alg=SHARED
    }

A WPA-secured network (prefer WPA2 over WPA if possible):

    network={
      ssid="some_secure_network"
      proto=RSN WPA
      # ASCII passphrase.
      psk="very secure passphrase"
      # If you have a 64 digit hex passphrase, specify it like this:
      #psk=1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef
    }

This is just a short overview; a more complete description of all
options and possibilities can be found in the wpa_supplicant default
configuration file.

> Configuring autowifi

Now autowifi has to be configured. First we set the startup parameters
in /etc/conf.d/autowifi:

    INTERFACE="wlan0"
    CONFIG="/etc/wpa_supplicant.conf"

Then, we configure the autowifi profiles. We begin with the default
profile in /etc/autowifi/networks/default:

    # This is the default profile
    # It is used when no other profile is matched
    # For a description, see the "example" profile
    NETWORK="dhcp"

This is a pretty good setting, as most people will have dhcp enabled.
Most users won't have to configure anything else.

Advanced configuration

In the file /etc/autowifi/regexp you can use regular expressions to map
several ESSIDs to the same profile name:

    # This file contains lines of the format
    #   profile regex
    # If the current SSID matches "regex", then the
    # profile "profile" is used.
    # Empty lines and lines starting with # are ignored.

    mynet somenetregexp[0-9] .*

The above setting means that every ESSID that matches the regular
expression "somenetregexp[0-9] .*" will use the profile name mynet.

The profile name is determined like this:

-   If the ESSID matches one or more regular expressions in the regexp
    file, the profile name of the first matched expression is used.
-   If the ESSID doesn't match any of the regular expressions, the ESSID
    itself is used as the profile name.

If the file /etc/autowifi/networks/profilename exists, it is used,
otherwise /etc/autowifi/networks/default is used. Here are some examples
for autowifi profiles:

Static IP address:

    NETWORK="static"
    ADDRESS="192.168.50.60"
    NETMASK="255.255.255.0"
    DNS="192.168.50.1"
    GATEWAY="192.168.50.1"

Use dhcp and a custom post-up script:

    NETWORK="dhcp"

    autowifi_connect() {
      something_cool
    }
    autowifi_disconnect() {
      killall something_cool
    }

If NETWORK="custom" is specified, only the autowifi_connect() and
autowifi_disconnect() scripts are executed, no further configuration is
done.

Running autowifi
----------------

To start autowifi, run

    /etc/rc.d/autowifi start

If you want to start it at boot, add it to rc.conf.

You can add more networks dynamically while wpa_supplicant is running
using the wpa_gui (package wpa_supplicant_gui) or wpa_cli tools. If you
change the wpa_supplicant.conf file while wpa_supplicant is running, run
wpa_cli reconfigure for the new configuration to take effect.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Autowifi&oldid=238736"

Category:

-   Wireless Networking
