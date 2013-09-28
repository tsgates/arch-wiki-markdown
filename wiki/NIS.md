NIS
===

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

NIS is a protocol developed by Sun to allow one to defer user
authentication to a server. The server software is in the ypserv
package, and the client software is in the yp-tools package. ypbind-mt
is also available, which is a multi threaded version of the client
daemon.

Note:Obviously this article is far from finished. hopefully in the
future that will change, but in the meantime check the More resources
section.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 NIS Client                                                         |
| -   2 NIS Server                                                         |
| -   3 Install Packages                                                   |
| -   4 Configuration                                                      |
|     -   4.1 /etc/conf.d/nisdomainname                                    |
|     -   4.2 /etc/ypserv.conf                                             |
|     -   4.3 /var/yp/Makefile                                             |
|     -   4.4 /var/yp/securenets                                           |
|     -   4.5 /var/yp/ypservers                                            |
|                                                                          |
| -   5 Start NIS Daemons                                                  |
|     -   5.1 initscripts                                                  |
|     -   5.2 systemd                                                      |
|                                                                          |
| -   6 More resources                                                     |
+--------------------------------------------------------------------------+

NIS Client
----------

The first step is to install the tools that you need. This provides the
configuration files and general tools needed to use NIS.

    # pacman -S yp-tools ypbind-mt

Next put your NIS domain name into the file /etc/conf.d/nisdomainname.

Now edit the /etc/yp.conf file and add your ypserver or nis server.

    ypserver your.nis.server

Start the rpcbind and ypbind daemons (add them to your rc.conf file if
you want it to start automatically).

    # /etc/rc.d/rpcbind start
    # /etc/rc.d/ypbind start

To test the setup so far you can run the command yptest:

    # yptest

If it works you will, among other things, see the contents of the NIS
user database (which is printed in the same format as /etc/passwd).

To actually use NIS to log in you have to edit /etc/nsswitch.conf.
Modify the lines for passwd, group and shadow to read:

    passwd: files nis
    group: files nis
    shadow: files nis

And then do not forget

    # /etc/rc.d/ypbind restart

See section 7 of The Linux NIS HOWTO for further information on
configuring NIS clients.

NIS Server
----------

Install Packages
----------------

Make sure packages ypbind-mt, ypserv, and yp-tools are installed:

    # pacman -S ypbind-mt yp-tools ypserv

Configuration
-------------

> /etc/conf.d/nisdomainname

Add the domain name to /etc/conf.d/nisdomainname:

    # NISDOMAINNAME="nis-domain-name"

> /etc/ypserv.conf

Add rules to /etc/ypserv.conf for your your nis clients of this form:

    # ip-address-of-client : nis-domain-name : rule : security

For example:

    # 192.168. : home-domain : * : port

For more information see man ypserv.conf.

> /var/yp/Makefile

Add or remove files you would like NIS to use to /var/yp/Makefile under
the "all" rule.

Default:

    # all:  passwd group hosts rpc services netid protocols netgrp \
    #         shadow # publickey networks ethers bootparams printcap mail \
    #         # amd.home auto.master auto.home auto.local passwd.adjunct \
    #         # timezone locale netmasks

Due to recent changes in networking in Archlinux you have to change the
line:

    # LOCALDOMAIN = `/bin/domainname`

to

    # LOCALDOMAIN = `/bin/hostname -d`

After that you have to build your NIS database:

    # cd /var/yp
    # make

> /var/yp/securenets

Add rules to /var/yp/securenets to restrict access:

    # 255.255.0.0 192.168.0.0 # Gives access to anyone in 192.168.0.0/16

Be sure to comment out this line, as it gives access to anyone.

    # 0.0.0.0      0.0.0.0

> /var/yp/ypservers

Add the domain name of your server to /var/yp/ypservers:

    # your.nis.server

Start NIS Daemons
-----------------

> initscripts

Note:The daemons MUST be started in this order.

Start rpcbind if it isn't already started:

    # systemctl start rpcbind

Start ypbind:

    # systemctl start ypbind

Start ypserv:

    # systemctl start ypserv

If you want these to start automatically on startup, then

    # systemctl enable rpcbind.service
    # systemctl enable ypbind.service
    # systemctl enable ypserv.service

> systemd

Simply use the systemctl command to enable and start the ypbind service:

    # systemctl enable ypbind.service

More resources
--------------

-   The Linux NIS HOWTO,very helpful and generally applicable to Arch
    Linux.
-   YoLinux NIS tutorial
-   Quick HOWTO, Configuring NIS

Retrieved from
"https://wiki.archlinux.org/index.php?title=NIS&oldid=255150"

Category:

-   Security
