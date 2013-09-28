Low Memory Footprint Advanced Network Scripts for Sub Laptops
=============================================================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Is this script   
                           still developed? It is   
                           still use rc.local and   
                           many info in #The usual  
                           tools for managing and   
                           why they do not feet is  
                           wrong and misleading.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: If no one update 
                           the script, this page    
                           can be deleted.          
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 The usual tools for managing and why they do not feet              |
|     -   2.1 graphical environment tools                                  |
|         -   2.1.1 NetworkManager                                         |
|         -   2.1.2 Blueman                                                |
|                                                                          |
|     -   2.2 start-up daemons                                             |
|         -   2.2.1 wicd                                                   |
|         -   2.2.2 netcfg                                                 |
|                                                                          |
| -   3 Acceptable penalties                                               |
| -   4 The solution                                                       |
| -   5 Reports                                                            |
+--------------------------------------------------------------------------+

Introduction
------------

Note:The purpose of this *experimental* article is to both present a
solution for a versatile & lightweight networking needs and to get
feedback from the community about the best way to implement these
solutions -- for example, this scripts still have to get more "Arch
Friendly" (so it can be enabled on the NETWORK section of the
/etc/rc.conf file)

Said that, considering you want to make your laptop connect to the
Internet in all available ways, like:

-   wired network (both dhcp and adsl)
-   wireless network (either WEP or WPA)
-   usb 3g modem
-   wired Internet access through a mobile phone
-   wireless (bluetooth pan) Internet access through a mobile phone
-   a modem (if you get a tone)

... and want to use the fewest memory & battery possible, then this
document might be of some help.

  

The usual tools for managing and why they do not feet
-----------------------------------------------------

> graphical environment tools

NetworkManager

Seems to be the most complete option even though it lacks bluetooth
support and needs gnome. On a lightweight system you would use Compiz +
Cairo-Dock, Openbox or even Xfce. Nonethless, there is a console
version, but it uses its own daemon, requires dbus and is written in
Python (heavy).

Blueman

Works on Xfce but deals only with bluetooth.

> start-up daemons

The following tools work for non-graphical environments -- what make
them feasible, but:

wicd

Wired and wireless only. Nice tool, but depends on dbus and is written
in Python, making it heavy.

netcfg

Wired, wireless and possibly others too. Lightweight, but couldn't find
a way to configure multiple access points for the same card.

  

Acceptable penalties
--------------------

To do what the managers described above can't do or do in a heavy-weight
fashion, we must accept that:

1.  Networks will be detected at boot time only. If you want to change
    on the fly, you'll need to do it manually
2.  In case of a connection drop (true for wifi and bluetooth
    connections) you will have the set it back up manually also

Accepting these restrictions, we do not need a daemon and the
connections can be set up at boot.

The solution
------------

Create a script to be called from your /etc/rc.local file.

This script will try to obtain a connection using the following rules:

1.  If there is line on eth0, then start dhcpcd (for LAN Internet
    access) or start your ADSL connection (you should configure it
    separetely)
2.  No wire? Lets check for a 3G modem. If present, connect (you should
    configure it with the pppoe tools)
3.  No 3G modem? Lets then turn on the Bluetooth adapter. If a known
    mobile is within range, connect to it (the device must be paired
    with bluez-simple-agent)
4.  Finally, turn on the Wifi and attempt to connect (use wpa_passphrase
    to get the contents for /etc/wpa_supplicant.conf)

To implement it, create a script named /usr/local/bin/sublapnet with the
following lines

    #! /bin/bash

    # sublapnet
    # =========
    #
    # Low Memory Footprint Advanced Network Script for Sub Laptops
    #
    # For documentation, please see https://wiki.archlinux.org/index.php?title=Low_Memory_Footprint_Advanced_Network_Scripts_for_Sub_Laptops
    #
    # Please share any improvements you make to this script.

    # interfaces
    ETH=eth0
    WLAN=wlan0
    BNEP=bnep0

    # connection devices
    USB_MODEM=/dev/ttyUSB0
    BTDEV=hci0
    BTNAME="badbook"
    MOBILE_BDADDR=AA:BB:CC:DD:EE:FF

    # other
    PPP3G=my3Gconnection


    # check for eth0 line
    if dmesg | grep "${ETH}" | grep -i "Link is up" &>/dev/null; then
    	UNNECESSARY_PROCESSES="dhcpcd"
           # eth0 is automatically brought up by the NETWORK definitions from /etc/rc.conf file. At this point, we should already have an IP.
           # Here one might (depending on the assigned IP) decide to connect to an ADSL provider.

    # check for a 3g modem
    elif [ -e ${USB_MODEM} ]; then
           pon ${PPP3G}

    # is the bluetooth adapter & mobile ready?
    elif hciconfig ${BTDEV} up && sleep 1 && hcitool scan | grep ${MOBILE_BDADDR} &>/dev/null; then

    	echo "Please assure the mobile is set to share the internet via a Bluetooth PAN connection..."
    	/etc/rc.d/dbus restart
    	/etc/rc.d/bluetooth restart
    	sleep 1
    	hciconfig hci0 up
    	hciconfig hci0 lm master
    	hciconfig hci0 name "${BTNAME}"
    	hciconfig hci0 class 0x480100
    	hciconfig hci0 pscan
    	hciconfig hci0 lp RSWITCH HOLD SNIFF PARK
    	sleep 1
    	modprobe bnep
    	sleep 1
    	for i in {1..3}; do
    		pand -n --connect ${MOBILE_BDADDR} && break
    		sleep 1
    	done
    	pkill dhcpcd
    	ifconfig bnep0 up
    	sleep 1
    	dhcpcd -p bnep0
    	sleep 1
    	pkill dhcpcd

    	/etc/rc.d/dbus stop

    else

           # attempt to save a little power
           hciconfig ${BTDEV} down
           ifconfig ${ETH} down

           # WPA wireless (using wpa_supplicant)
           if ifconfig $WLAN up; then
                   wpa_supplicant -i${WLAN} -c/etc/wpa_supplicant.conf -B
                   for attempt in {0..4}; do
                           sleep 5
                           if dmesg | tail | grep "$WLAN: New link status: Connected" || dmesg | tail | grep "$WLAN: associated" || dmesg | tail | grep "$WLAN: authenticated"; then
                                  /sbin/dhcpcd $WLAN || continue
                                   break
                           fi
                   done

    		# wpa_supplicant can be removed depending on your wifi driver -- whether it reconnects automatically or not
                   UNNECESSARY_PROCESSES="dhcpcd _wpa_supplicant"
    	fi

    	# WEP wireless
    #	WLAN=wlan0
    #	if ifconfig $WLAN up; then
    #		for attempt in {0..4}; do
    #			iwconfig $WLAN essid wagemobile key open A0B1B09004
    #			sleep 5
    #			if dmesg | tail | grep "$WLAN: New link status: Connected" || dmesg | tail | grep "$WLAN0: associated"; then
    #				/sbin/dhcpcd $WLAN
    #                                ping -W 1 -i 0.4 192.168.0.1 &>/dev/null &
    #				break
    #			fi
    #		done
    #	fi

    fi

    # remove unnecessary processes
    for p in $UNNECESSARY_PROCESSES; do
    	pkill -stop -f "$p"
    	pkill -9 -f "$p"
    done

and, finally, hook it to your /etc/rc.local startup script:

    /usr/local/sublapnet &

Reports
-------

This script is reported to work on:

-   Compaq Armada M300
-   Compaq Evo 620N
-   Sony Vaio VGN-NR320AH

Retrieved from
"https://wiki.archlinux.org/index.php?title=Low_Memory_Footprint_Advanced_Network_Scripts_for_Sub_Laptops&oldid=250566"

Category:

-   Networking
