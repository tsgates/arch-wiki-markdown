Advanced VirtualBox Networking
==============================

  ------------------------ ------------------------ ------------------------
  [Tango-user-trash-full.p This article or section  [Tango-user-trash-full.p
  ng]                      is being considered for  ng]
                           deletion.                
                           Reason: The amount of    
                           configuration required   
                           for these methods is not 
                           needed long time ago.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

The amount of configuration required for these methods is almost never
necessary due to recent VirtualBox improvements. Consult the main
article for simpler directions. The VirtualBox manual covers NAT,
host-only, and internal network options. These have been ommited due to
them being, for the most part, OS agnostic.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing                                                         |
| -   2 Ethernet host interface                                            |
| -   3 Wireless host interface                                            |
|     -   3.1 Simple: no DHCP                                              |
|                                                                          |
| -   4 VirtualBox setup                                                   |
+--------------------------------------------------------------------------+

Installing
----------

Install uml_utilities, available in Official Repositories.

Load the required module:

    # modprobe vboxnetflt

In order to use host-only and internal network settings you have to load
the vboxnetadp kernel module:

    # modprobe vboxnetadp

Ethernet host interface
-----------------------

Arch Linux provides two methods of configuring network devices. The
standard "network" daemon and the more versatile "netcfg"

Install the required packages:

    # pacman -S netcfg bridge-utils

Create the bridge configuration file:

    /etc/network.d/vboxbridge

    INTERFACE="br0"
    CONNECTION="bridge"
    DESCRIPTION="Virtualbox Bridge"
    PRE_UP="ip link set dev eth0 promisc on"
    BRIDGE_INTERFACES="eth0"
    IP="dhcp"

Test your configuration by running

    # netcfg vboxbridge

Now, you must edit your /etc/rc.conf

    /etc/rc.conf

    # These lines must be found and removed or commented out. 
    ##interface=eth0
    ##address=
    ##netmask=
    ##broadcast=
    ##gateway=

    ...

    # Uncomment this line
    NETWORKS=(vboxbridge)

    ...

    # Remove network and replace it with
    DAEMONS=(... net-profiles ...)

Reboot and test that internet is still operational by opening a browser
or pinging a website

    # ping -c 3 www.google.com

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: The example      
                           /etc/rc.conf stuff below 
                           needs to be fixed for    
                           /etc/conf.d/netcfg       
                           syntax. The example and  
                           the wording introducing  
                           the file do not match.   
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

If the ping didn't return any packets, your network configuration may
not have loaded. In newer versions of netcfg, using /etc/rc.conf to
specify which networks to load is deprecated, and as such, won't load.
Instead, you can edit /etc/conf.d/netcfg to add them:

    /etc/rc.conf

    #Insert the virtualbox network here
    NETWORKS=(last vboxbridge)

    WIRED_INTERFACE="eth0"
    WIRELESS_INTERFACE="wlan0"
    #AUTO_PROFILES=("profile1" "profile2")

Now, in the VirtualBox window, change the network adaptor to "Bridged
Adaptor", selecting "br0"

Wireless host interface
-----------------------

> Simple: no DHCP

Use this script:

    #!/bin/sh
    WLAN=wlan0
    TAPIP=192.168.2.150

    tap=$(tunctl -b -g 'vboxusers')

    cd /proc/sys/net/ipv4
    echo 1 > ip_forward
    echo 1 > conf/$WLAN/proxy_arp
    echo 1 > conf/$tap/proxy_arp

    ifconfig $tap up
    route add -host $TAPIP dev $tap

    ;WLAN,
    :The host's wireless device.
    ;TAPIP
    :The IP for the guest system. Should be in the same network as the host.

After running the script, the guest machine should be configured to use
TAPIP as its IP address, and the host's router and nameserver as its
defaults.

VirtualBox setup
----------------

-   Access the VM's Settings menu;
-   Select Network from the list to the left;
-   In the Attached to drop-down list, select Bridged Adapter; finally,
-   Select the name of the previously created TAP device from the Name
    drop-down list.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Advanced_VirtualBox_Networking&oldid=232583"

Category:

-   Virtualization
