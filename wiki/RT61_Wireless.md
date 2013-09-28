RT61 Wireless
=============

  

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Bringing up the interface                                          |
|     -   2.1 No encryption and WEP encryption                             |
|     -   2.2 WPA/PSK or WPA2/PSK                                          |
|                                                                          |
| -   3 Master Mode                                                        |
+--------------------------------------------------------------------------+

Installation
------------

The RT61 Driver is included in the official kernel-tree so you must only
load the rt61 module using:

    # modprobe rt61pci

If you want to load the module at startup you can add it to MODULES=()
in rc.conf like this:

    MODULES=(... fuse rt61pci snd-via82xx ...)

Some RT61 devices need to load the firmware (you can check it using the
dmesg command) so you must install the rt2x00-rt61-fw package using:

    # pacman -S rt2x00-rt61-fw

Bringing up the interface
-------------------------

> No encryption and WEP encryption

Edit rc.conf to met your config:

    wlan_wlan0='wlan0 essid <youressid>' #no encryption
    wlan_wlan0='wlan0 essid <youressid> key open s:<yourWEPkey>' #WEP encryption
    wlan0=('dhcp')
    INTERFACES=(wlan0 lo) #among other interfaces

> WPA/PSK or WPA2/PSK

The README file tells you how to configure the interface using iwconfig
and iwlist commands. To set up the system to configure the interface at
startup you can use the AUR package scripts from klixon. Simply download
'rt61wpa' to '/etc/rc.d/rt61wpa' and 'rt61-wpa.conf.d' to
'/etc/conf.d/rt61-wpa', configure the 'rt61-wpa' file and place
'rt61wpa' in your rc.conf DAEMONS array before 'network'. You also have
to put

    wlan0=('dhcp')
    INTERFACES=(wlan0 lo) #among other interfaces

in your rc.conf.

Master Mode
-----------

You can't set the mode to Master with iwconfig. However, hostapd will be
able to do that. For more information see this tutorial:
http://www.clearfoundation.com/component/option,com_kunena/Itemid,232/catid,40/func,view/id,21824/

There shouldn't be any need for patching or using experimental version
anymore. The mentioned tutorial worked for me with the following
official packages:

-   core/kernel26-lts 2.6.32.28-2
-   community/hostapd 0.7.3-3
-   core/libnl 1.1-2

Retrieved from
"https://wiki.archlinux.org/index.php?title=RT61_Wireless&oldid=198540"

Category:

-   Wireless Networking
