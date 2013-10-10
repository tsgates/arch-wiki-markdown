netcfg Troubleshooting
======================

> Summary

Collection of troubleshooting for netcfg.

> Resources

netcfg

Netcfg Tips

Note:Netcfg has been superseded by netctl

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Troubleshooting                                                    |
|     -   1.1 Debugging                                                    |
|     -   1.2 Network unavailable                                          |
|     -   1.3 Wireless association failed                                  |
|     -   1.4 Unable to get IP address with DHCP                           |
|     -   1.5 Not a valid connection, check spelling or look at examples   |
|     -   1.6 No Connection                                                |
|         -   1.6.1 Carrier Timeout                                        |
|         -   1.6.2 Skip no carrier                                        |
|                                                                          |
|     -   1.7 Driver quirks                                                |
|     -   1.8 Ralink legacy drivers rt2500, rt2400 that use iwpriv         |
|     -   1.9 "find: '/var/run/network/suspend/': No such file or          |
|         directory"                                                       |
|     -   1.10 wlan0 does not exist                                        |
|     -   1.11 Help                                                        |
+--------------------------------------------------------------------------+

Troubleshooting
---------------

> Debugging

To run netcfg with debugging output, set the NETCFG_DEBUG environment
variable to "yes", for example:

    # NETCFG_DEBUG="yes" netcfg <arguments>

Debugging information for wpa_supplicant can be logged using WPA_OPTS
within a profile, for example:

    WPA_OPTS="-f/path/to/log"

Whatever is entered here will be added to the command when
wpa_supplicant is called.

> Network unavailable

This error is typically due to:

-   Out of range; or
-   Driver issue.

> Wireless association failed

This error is typically due to:

-   Out of range/reception;
-   Incorrect configuration;
-   Invalid key;
-   Driver problem; or
-   Trying to connect to a hidden network.

If the connection problem is due to poor reception, increase the TIMEOUT
variable in /etc/network.d/mynetwork, such as:

    TIMEOUT=60

If an AP with a hidden SSID is used, try:

    PRE_UP='iwconfig $INTERFACE essid $ESSID'

> Unable to get IP address with DHCP

This error is typically due to out of range/bad reception.

Try increasing DHCP_TIMEOUT variable in your network
/etc/network.d/profile.

> Not a valid connection, check spelling or look at examples

You must set CONNECTION to one of the connection types listed in the
/usr/lib/network/connections directory. Alternatively, use one of the
provided configuration examples in /etc/network.d/examples.

> No Connection

Carrier Timeout

If you get a set of debug messages similar to the following (remembering
that profile names and interface names may be different), it could be
that the process of bringing up the interface is taking too long.

     DEBUG: Loading profile eth0-dhcp
     DEBUG: Configuring interface eth0
     :: eth0-dhcp up
     DEBUG: status reported to profile_up as:
     DEBUG: Loading profile eth0-dhcp
     DEBUG: Configuring interface eth0
     DEBUG: ethernet_iproute_up ifup
       > No connection
     DEBUG: profile_up connect failed
      [FAIL]

The default is 2 seconds. To lengthen the timeout, set the
CARRIER_TIMEOUT variable before calling netcfg.

This thread shows one example of this issue:
https://bbs.archlinux.org/viewtopic.php?id=138615

Skip no carrier

When you can manually bring up an interface but the journal says „No
connection“ during boot, it might be that the physical connection cannot
be detected fast enough. Try adding this to your profile:

    SKIPNOCARRIER='yes'

Netcfg will then assign the IP address regardless of whether there is a
cable actually attached.

> Driver quirks

Note:You most likely do not need quirks; ensure your configuration is
correct before considering them. Quirks are intended for a small range
of drivers with unusual issues, many of them older versions. These are
workarounds, not solutions.

Some drivers behave oddly and need workarounds to connect. Quirks must
be enabled manually. They are best determined by reading the forums,
seeing what others have used, and, if that fails, trial and error.
Quirks can be combined.

 prescan
    Run iwlist $INTERFACE scan before attempting to connect (Broadcom)
 preessid
    Run iwconfig $INTERFACE essid $ESSID before attempting to connect
    (ipw3945, Broadcom and Intel PRO/Wireless 4965AGN)
 wpaessid
    Same as previous, run before starting wpa_supplicant. Not supported
    anymore - use IWCONFIG="essid $ESSID" instead. (ath9k)
 predown
    Take interface down before association and then restore it after
    (madwifi)
 postsleep
    Sleep one second before checking if the association was successful
 postscan
    Run iwlist scan after associating

Add the required quirks to the netcfg configuration file
/etc/network.d/mynetwork. For example:

    QUIRKS=(prescan preessid)

If you receive "Wireless network not found", "Association failed" errors
and have tried the above, or if an AP with a hidden SSID is used, see
the above section #Wireless association failed.

> Ralink legacy drivers rt2500, rt2400 that use iwpriv

There is no plans to add WPA support to these drivers. rt2x00 is
supported, however, and will replace these.

If you must use them, create a shell script that runs the needed iwpriv
commands and put its path in PRE_UP.

> "find: '/var/run/network/suspend/': No such file or directory"

If you get this error message, then do not bother because it is a known
bug. Create the directory by hand.

> wlan0 does not exist

In order to make sure the network hardware is initialised before a
network connection attempt is made, add the "After" and "BindTo" lines
to the appropriate netcfg or netcfg@ file found in
/etc/systemd/system/*/

     After=sys-devices-xxx-net-wlan0.device
     BindTo=sys-devices-xxx-net-wlan0.device

where "sys-devices-xxx-net-wlan0.device" can be seen in

systemctl --full

> Help

If this article did not help solve your problem, the next best places to
ask for help are the forums, the mailing list, and the IRC Channel.

To be able to determine the problem, we need information. When you ask,
provide the following output:

-   ALL OUTPUT FROM netcfg
    -   This is absolutely crucial to be able determine what went wrong.
        The message might be short or non-existent, but it can mean a
        great deal.

-   /etc/network.d network profiles
    -   This is also crucial as many problems are simple configuration
        issues. Feel free to censor your wireless key.

-   netcfg version
-   lsmod
-   iwconfig

Retrieved from
"https://wiki.archlinux.org/index.php?title=Netcfg_Troubleshooting&oldid=255988"

Category:

-   Networking
