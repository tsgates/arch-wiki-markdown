APC UPS
=======

This document describes how to install the APC UPS daemon. The main
advantage of using an APC UPS (for me) is that it can communicate with
your Linux box through either a RS-232 or USB serial connection. In the
event of a prolonged power outage, should the APC UPS lose most of its
battery capacity, it can tell the Linux box to perform a safe shutdown.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Install the package                                                |
| -   2 Configure APC UPS                                                  |
| -   3 Test                                                               |
|     -   3.1 Congratulations!                                             |
|                                                                          |
| -   4 Hibernating instead of shutting down                               |
|     -   4.1 Create the hibernate script                                  |
|     -   4.2 Link the hibernate script for apcupsd to use it              |
|     -   4.3 Make apcupsd kill UPS power once the hibernate is done       |
|                                                                          |
| -   5 See also                                                           |
+--------------------------------------------------------------------------+

Install the package
-------------------

    # pacman -S apcupsd

Configure APC UPS
-----------------

The main configuration file for the APC UPS daemon can be found here:
/etc/apcupsd/apcupsd.conf

In the following example, the lines of text are changed to support a USB
style cable:

Before:

    UPSCABLE smart

    UPSTYPE smartups

    DEVICE /dev/ttyS0

After:

    UPSCABLE usb

    UPSTYPE usb

    DEVICE /dev/usb/hiddev[[0-15]]

Test
----

First, start the daemon:

    # systemctl start apcupsd

Next, wait about a minute and confirm the daemon is running and properly
monitoring the battery:

    # apcaccess status
    APC      : 001,033,0819
    DATE     : Sat Mar 05 SOMETIME 2005
    HOSTNAME : somehostname
    RELEASE  : 3.10.16
    VERSION  : 3.10.16 (04 November 2004) unknown
    UPSNAME  : somehostname
    CABLE    : USB Cable
    MODEL    : Back-UPS ES 725
    UPSMODE  : Stand Alone
    STARTTIME: Sat Mar SOMETIME 2005
    STATUS   : ONLINE
    LINEV    : 119.0 Volts
    LOADPCT  :  23.0 Percent Load Capacity
    BCHARGE  : 100.0 Percent
    TIMELEFT :  30.5 Minutes
    MBATTCHG : 5 Percent
    MINTIMEL : 3 Minutes
    MAXTIME  : 0 Seconds
    LOTRANS  : 088.0 Volts
    HITRANS  : 138.0 Volts
    ALARMDEL : Always
    BATTV    : 13.5 Volts
    NUMXFERS : 0
    TONBATT  : 0 seconds
    CUMONBATT: 0 seconds
    XOFFBATT : N/A
    STATFLAG : 0x02000008 Status Flag
    MANDATE  : 2002-12-02
    SERIALNO : QB0249360043
    BATTDATE : 2000-00-00
    NOMBATTV :  12.0
    FIRMWARE : 02.n2.D USB FW:n2
    APCMODEL : Back-UPS ES 725
    END APC  : Sat SOMETIME 2005

To fully test your setup:

1.  Change TIMEOUT form 0 to 1 in the /etc/apcupsd/apcupsd.conf file
2.  Remove wall power from the UPS
3.  Observe that your Linux box powers down, in short order
4.  Plug the UPS back into the wall
5.  Power on your Linux box
6.  Change TIMEOUT from 1 back to 0 in the /etc/apcupsd/apcupsd.conf
    file

> Congratulations!

Now all that's left to do is enable the apcupsd service.

Hibernating instead of shutting down
------------------------------------

You can make your system hibernate instead of shutting down. First, make
sure the system hibernates cleanly. To set up hibernation, look here.

> Create the hibernate script

Create this in /usr/local/bin/hibernate as root:

    #!/bin/bash
    # Hibernate the system - designed to be called via symlink from /etc/apcupsd
    # directory in case of apcupsd initiating a shutdown/reboot.  Can also be used
    # interactively or from any script to cause a hibernate.

    # Do the hibernate
    /usr/sbin/pm-hibernate
    # At this point system should be hibernated - when it comes back, we resume this script here

    # On resume, tell controlling script (/etc/apcupsd/apccontrol) NOT to continue with default action (i.e. shutdown).
    exit 99

Make it executable by running

    # chmod +x /usr/local/bin/hibernate

> Link the hibernate script for apcupsd to use it

Create a symbolic link from the /etc/apcupsd directory to the script.
The result is the apcupd's apccontrol script, in this directory, will
call the hibernate script instead of doing the default shutdown action
for these operations.

    # ln -s /usr/local/bin/hibernate /etc/apcupsd/doshutdown

If you are running apcupsd as a client to another machine running
apcupsd as a server and want your machine to hibernate if the sever is
shutdown or if communication to the server is lost then you may also
wish to add:

    # ln -s /usr/local/bin/hibernate /etc/apcupsd/remotedown

> Make apcupsd kill UPS power once the hibernate is done

Once the PC has hibernated successfully, it's better for the UPS to be
switched off in order to conserver battery charge, and prevent full
battery drain. This can be achieved very easily! Create a file
/etc/pm/sleep.d/99apc and put the following contents in it

    #!/bin/bash
    case $1 in
        hibernate)
            # See if this is a powerfail situation.                            # ***apcupsd***
            if [ -f /etc/apcupsd/powerfail ]; then                             # ***apcupsd***
            echo                                                               # ***apcupsd***
            echo "APCUPSD will now power off the UPS"                          # ***apcupsd***
            echo                                                               # ***apcupsd***
            /etc/apcupsd/apccontrol killpower                                  # ***apcupsd***
            echo                                                               # ***apcupsd***
            echo "Please ensure that the UPS has powered off before rebooting" # ***apcupsd***
            echo "Otherwise, the UPS may cut the power during the reboot!!!"   # ***apcupsd***
            echo                                                               # ***apcupsd***
            fi                                                                 # ***apcupsd***
            ;;
    esac

Make the script executable by doing

    # chmod +x /etc/pm/sleep.d/99apc

Now you can test your setup.

See also
--------

-   Apcupsd a daemon for controlling APC UPSes
-   Forcing hibernate
-   apcupsd manual

Retrieved from
"https://wiki.archlinux.org/index.php?title=APC_UPS&oldid=253352"

Category:

-   Power management
