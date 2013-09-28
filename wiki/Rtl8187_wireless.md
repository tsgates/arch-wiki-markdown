Rtl8187 wireless
================

This page describes how to get the rtl8187 wifi-driver working

The rtl8187 chip is made for usb-cards/dongles. It supports
802.11(a)/b/g and the following encryptions: WEP, WPA and WPA2. The
rtl8187 driver is in the kernel now.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Using the driver                                                   |
| -   2 What to do if your connection always times out?                    |
|     -   2.1 Lowering the rate                                            |
|     -   2.2 Lowering the txpower                                         |
|     -   2.3 Setting rts and fragmentation thresholds                     |
|                                                                          |
| -   3 See also                                                           |
+--------------------------------------------------------------------------+

Using the driver
----------------

Make sure that you have loaded the rtl8187 module with

    # modprobe rtl8187

Then run

    # dmesg | grep rtl8187

You should see some output like this

     usbcore: registered new interface driver rtl8187 

If you see that line everything should be OK

If everything is right, you should have two new interfaces: wlan0 and
wmaster0 If you do not see wlan0 just run

    # ip link set dev wlan0 up

To list all available wifi-networks just run

    # iw dev wlan0 scan 

For more information about configuring your wifi-network see here:
Wireless management.

What to do if your connection always times out?
-----------------------------------------------

The open source driver suffers from a lot of tx excessive retries and
invalid misc errors for some unknown reason, resulting in a lot of
packet loss and it keeps disconnecting, some times instantly.

> Lowering the rate

The solution can be found in this thread:
https://bbs.archlinux.org/viewtopic.php?pid=299642

Just set the rate to 5.5

    iwconfig wlan0 rate 5.5M auto

Fixed option should ensure, however, it doesn't change the rate on its
own, thus making the connection a bit more stable:

    iwconfig wlan0 rate 5.5M fixed 

Alternativelly find the $POST_UP option and append the above options to
your profile config file:

    POST_UP="iwconfig wlan0 rate 5.5M fixed"

Try various rates until you get the optimal setting, with no
disconnection. In this case 12Mbits, as shown bellow:

    POST_UP="iwconfig wlan0 rate 12M fixed"

Now calling;

    netfcg2 -c <wireless profile>

or

      netcfg-menu 

and choosing your profile works without extra commands.

> Lowering the txpower

You can try lowering the transmit power as well. This may save power as
well:

    iwconfig wlan0 txpower 5

or even as low as 0. Valid settings are from 0 to 20, auto and off for
the stock kernel driver.

> Setting rts and fragmentation thresholds

Default iwconfig options have rts and fragmentation thresholds off.
These options are particularly useful when there are many adjacent APs
or in a noisy environment.

The minimum value for fragmentation value is 256 and maximum is 2346. In
many windows drivers the maximum is the default value:

    iwconfig wlan0 frag 2346

For rts minimum is 0, maximum is 2347. Once again windows drivers use
maximum as the default:

    iwconfig wlan0 rts 2347

See also
--------

-   The Linux Wireless project
-   Aircrack-ng information for rtl8187 chips

Retrieved from
"https://wiki.archlinux.org/index.php?title=Rtl8187_wireless&oldid=249646"

Category:

-   Wireless Networking
