CyberPower UPS
==============

This document describes how to install the CyberPower UPS daemon. The
main advantage of using a CyberPower UPS is that it is cheap and it can
communicate with your Linux box through either a RS-232 or USB serial
connection. In the event of a prolonged power outage, should the
CyberPower UPS lose most of its battery capacity, it can tell the Linux
box to perform a safe shutdown.

Installation
------------

Install powerpanel from AUR.

Configuration
-------------

Edit /etc/pwrstatd.conf

Email notifications can be accomplished by editing
/etc/powerpanel/pwrstatd-powerfail.sh and
/etc/powerpanel/pwrstatd-lowbatt.sh

Warning:Make sure the path to the email script at the bottom of these
scripts is correct. It should be /etc/powerpanel/pwrstatd-email.sh

Running
-------

Start and enable the service

    # systemctl start pwrstatd
    # systemctl enable pwrstatd

Then run # pwrstat -status

You should get something like this:


    The UPS information shows as following:

            Properties:
                    Model Name...................  Value 1500E
                    Firmware Number.............. BFF7104#7N5
                    Rating Voltage............... 230 V
                    Rating Power................. 900 Watt
     
            Current UPS status:
                    State........................ Normal
                    Power Supply by.............. Utility Power
                    Utility Voltage.............. 230 V
                    Output Voltage............... 230 V
                    Battery Capacity............. 100 %
                    Remaining Runtime............ 61 min.
                    Load......................... 126 Watt(14 %)
                    Line Interaction............. None
                    Test Result.................. Unknown
                    Last Power Event............. None

Retrieved from
"https://wiki.archlinux.org/index.php?title=CyberPower_UPS&oldid=274436"

Category:

-   Power management

-   This page was last modified on 5 September 2013, at 16:20.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
