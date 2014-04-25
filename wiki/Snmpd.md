Snmpd
=====

SNMP is a tool designed for the management and monitoring of network
devices. The Net-SNMP package is one implementation of SNMP that is
available for Arch Linux. This article discusses the configuration and
testing of the snmpd daemon that ships with Arch's net-snmp package.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Daemon
    -   2.2 SNMP 1 and 2c
    -   2.3 SNMP 3
    -   2.4 Start Daemon
-   3 Testing

Installation
------------

There is one package for net-snmp in Arch Linux which contains both the
snmpd daemon, and the accompanying utilities.

    # pacman -S net-snmp

Configuration
-------------

Note that it is crucial that the snmpd service is not running while
editing configuration files for it, especially /var/net-snmp/snmpd.conf.

> Daemon

Enable the daemon

    systemctl enable snmpd

> SNMP 1 and 2c

There are three versions of SNMP which are supported by net-snmp: 1, 2c
and 3. Versions 1 and 2c start with the same basic configuration, using
/etc/snmp/snmpd.conf.

    mkdir /etc/snmp/
    echo rocommunity read_only_user >> /etc/snmp/snmpd.conf

The above commands will add a user that can be used for monitoring.
Optionally, you can add another user used for management. This is not
recommended unless you have a specific reason.

    echo rwcommunity read_write_user >> /etc/snmp/snmpd.conf

> SNMP 3

SNMP v3 adds security and encrypted authentication/communication. It
uses different configuration in /etc/snmp/snmpd.conf, plus additional
configuration in /var/net-snmp/snmpd.conf.

    mkdir /etc/snmp/
    echo rouser read_only_user >> /etc/snmp/snmpd.conf
    mkdir -p /var/net-snmp/
    echo createUser read_only_user SHA password1 AES password2 > /var/net-snmp/snmpd.conf

Note that once snmpd is restarted, /var/net-snmp/snmpd.conf will be
rewritten, and the clear-text passwords that you have entered will be
encrypted. If this file is modified while snmpd is running, any changes
will be reset when the daemon is stopped. Therefore, it is crucial that
snmpd is not running while this file is being updated.

> Start Daemon

After configuring the daemon, start it

    systemctl start snmpd

Testing
-------

If using SNMP 1 or 2c, use one of the following commands to test
configuration:

    # snmpwalk -v 1 -c read_only_user localhost | less
    # snmpwalk -v 2c -c read_only_user localhost | less

If using SNMP 3, use the following command to test configuration:

    # snmpwalk -v 3 -u read_only_user -a SHA -A password1 -x DES -X password2 -l authNoPriv localhost | less

Either way, you should see several lines of data looking something like:

    SNMPv2-MIB::sysDescr.0 = STRING: Linux myhost 2.6.37-ARCH #1 SMP PREEMPT Sat Jan 29 20:00:33 CET 2011 x86_64
    SNMPv2-MIB::sysObjectID.0 = OID: ccitt.1
    DISMAN-EVENT-MIB::sysUpTimeInstance = Timeticks: (307772) 0:51:17.72
    SNMPv2-MIB::sysContact.0 = STRING: root@localhost
    SNMPv2-MIB::sysName.0 = STRING: myhost
    ...SNIP...

Retrieved from
"https://wiki.archlinux.org/index.php?title=Snmpd&oldid=282596"

Category:

-   Status monitoring and notification

-   This page was last modified on 13 November 2013, at 10:10.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
