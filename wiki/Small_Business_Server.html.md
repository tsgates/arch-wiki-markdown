Small Business Server
=====================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with The Perfect 
                           Small Business           
                           Server(+Failover).       
                           Notes: the linked        
                           article should be merged 
                           here. (Discuss)          
  ------------------------ ------------------------ ------------------------

In this series of articles we will present a way to configure a Linux
server to work in a mixed Windows/UNIX environment in a way that will
scale well.

Warning:Don't try to configure a system in a fastest way possible,
migrations between configurations (for example: from flat files to LDAP,
for both UNIX and Windows authentication) are not easy to do, are
disruptive and in the end result make those 5 minutes of work you do not
do now, hours later on.

Note:I'm suggesting here how to pick out and configure a Linux server
for a small company, with a server that is built from scratch or updated
with a new install, not all suggestions apply for every possible
workloads, though they should be a good starting point in most cases

Contents
--------

-   1 Introduction
-   2 Prerequisites
    -   2.1 Computers
        -   2.1.1 Hardware
        -   2.1.2 Basic configuration
        -   2.1.3 File systems
        -   2.1.4 Note on overall network architecture
-   3 Server Configuration
    -   3.1 Network access and basic services
        -   3.1.1 Routing
        -   3.1.2 Firewall
        -   3.1.3 DHCP
        -   3.1.4 DNS
        -   3.1.5 NTP
        -   3.1.6 proxy server
    -   3.2 FreeRadius EAP-TLS
    -   3.3 LDAP
    -   3.4 Samba
    -   3.5 mail server
    -   3.6 web server
    -   3.7 alternatives to group ware
        -   3.7.1 forum
        -   3.7.2 wiki
    -   3.8 Client backup
-   4 Windows workstation
    -   4.1 joining samba domain
-   5 Linux workstation
    -   5.1 LDAP authentication

Introduction
------------

This series of articles will show best practices to configure a
Windows/UNIX mixed domain in a extensible way. What to do, how to do it
and what not to do (and why).

Our server will support:

-   Network firewall and NAT
-   DNS and DHCP for hosts
-   User authentication and management with LDAP
-   File sharing with Samba, NAT and FTP
-   Printing with CUPS (from UNIX) and Samba (from Windows)
-   VPN service

Prerequisites
-------------

> Computers

You will need at at least 2 computers:

-   An Archlinux domain controller (our Small Business Server)
-   A Windows workstation or domain member server
-   A Linux domain member workstation/server

While the workstations can be made up of hardware that will make the OS
work, server machines need a little more thought put into early on to
save a few headaches later.

Hardware

It's best to use a server worthy hardware, but Linux will work well on
commodity hardware too. Things good to have:

1.  At least two disks for RAID (for a server that's the single most
    important thing)
2.  ECC RAM (ECC only RAM, not ECC Registered, is supported by most
    middle- and high-end commodity main-boards and isn't much more
    expensive that normal RAM)
3.  Hardware RAID isn't really necessary, Linux can utilize a software
    RAID configuration
    -   Usually will give you better throughput (only very high amounts
        of Input/Output operations Per Second (IOPS) are hard to achive,
        but if you care for IOPS, you need to look at enterprise
        hardware)
    -   Allow access to SMART data for HDDs
    -   Doesn't tie the array to a controller
    -   Is much more flexible than even the most expensive hardware RAID
        controllers

4.  Relatively fast processor
5.  Lots of RAM (4GB as of 2010 is absolute minimum for a new build)
6.  A gigabit ethernet NIC, plus a FastEthernet one if the server will
    work as a router too

Basic configuration

Some features (easy backups, migration and Windows Previous Versions on
Samba shares) require LVM running on the server.

When you are installing a new OS, put it on LVM, at the very least. Even
if you plan to use single partition for whole system, this way, later
on, you'll be able to migrate to larger HDDs or RAID without even
rebooting the system.

GRUB needs a physical partition (or a RAID1 volume) to install to, so
the basic configuration needs to be something like this:

      sda
    +--------+--------+
    |/boot   |LVM PV  |
    +--------+--------+

and like this for a 2+ drive setup:

      sda                      sdb                    
    +--------+------------+ +--------+------------+
    |/boot   |RAID volume | |/boot   |RAID volume |
    +--------+------------+ +--------+------------+
                ^                       ^
                +-----------------------+
                | RAID MD device        |
                +-----------------------+
                           |
              +---------------------------+
              | LVM PV                    |
              +---------------------------+

File systems

Note on overall network architecture

Server Configuration
--------------------

> Network access and basic services

Routing

Firewall

DHCP

DNS

(dynamic DNS)

NTP

proxy server

> FreeRadius EAP-TLS

Implementation 802.1x EAP-TLS using FreeRADIUS.

One common application of client side PKI certificates is 802.1x network
authentication using EAP/TLS to present the client's identity to the
server. Unlike many other EAP types, EAP/TLS does not transmit a
password from the supplicant to the server, which is better network
security.

This page explains how to build the FreeRadius server (v1.0.4 was
current at the time) and configure it to be used for 802.1x network
authentication and EAP/TLS.

  
 Install OpenSSL and Freeradius:

    * $pacman -S openssl
    * $pacman -S freeradius

Go to the directory /etc/raddb/certs If you wish to production server,
change the value on its files ca.cnf, server.cnf, client.cnf.

    * $ cd /etc/raddb/certs
    * $ make               //make Ccreate certificates A and сервера.

Generating Client Certificates

    make client.pem

Configure Freeradius:

    /etc/raddb/eap.conf
    <               default_eap_type = md5

    >               default_eap_type = tls

/etc/raddb/clients.conf > client 192.168.1.1 { > secret = Testing123 >
shortname = wifi-anna_r > } </pre>

    /etc/raddb/sites-available/default
    <       suffix
    > #     suffix

Run in debug mode radiusd -Xf. setting Example wifi AP.  

    Security Mode: RADIUS
    Radius Server Radius: 192.168.1.2
    Radius Server Port: 1812
    Radius Shared Secret: Testing123

For a client connection, you must copy:  

    Windows -  Key Certification Center ca.der
    It must be placed in the Trusted Root Certification.
    and client.p12 placed in a private.

Linux - NetworkManager  

    Wireless Security: Dynamic WEP (802.1x)
    Authentication: TLS
    Inedtity: any identifier, such as -
    User certificate: none
    CA certificate: ca.der
    Private key: client.p12
    Private key password: whatever

  

Resources are used to configure the authentication server through an
access point.

http://deployingradius.com/  
 http://www.dartmouth.edu/~pkilab/pages/EAP-TLSwFreeRadius.html  

http://www.lissyara.su/articles/freebsd/security/wpa2_radius+eap-tls_eap-peap/  

* * * * *

> LDAP

DNS and DHCP in LDAP on Arch, is it possible?

> Samba

> mail server

Zimbra or eGroupWare

> web server

> alternatives to group ware

forum

wiki

> Client backup

Windows workstation
-------------------

> joining samba domain

Linux workstation
-----------------

> LDAP authentication

Retrieved from
"https://wiki.archlinux.org/index.php?title=Small_Business_Server&oldid=286667"

Category:

-   Web Server

-   This page was last modified on 6 December 2013, at 16:28.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
