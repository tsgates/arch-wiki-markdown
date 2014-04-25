LDAP Hosts
==========

Related articles

-   OpenLDAP
-   LDAP Authentication

This document will allow you to put your /etc/hosts into your LDAP
server. At first make sure you have an LDAP server up and running (take
LDAP Authentication as an introduction). Next you need to create a
proper ldif file from /etc/hosts. Actually mine is like:

    127.0.0.1 localhost
    192.168.1.1 gojira.marex.local gojira
    192.168.1.50 gamera.marex.local gamera
    192.168.1.51 iris.marex.local iris
    192.168.1.52 zedan.marex.local zedan

Where 127.0.0.1 is localhost (of course), 192.168.1.1 is the LDAP
server, followed by at least 3 workstation (gamera, iris & zedan). For a
ldif file you need to create a ou for your hosts and each host (I will
call the next file hosts.ldif):

    dn: ou=Hosts,dc=marex,dc=local                                                                                              
    objectClass: organizationalUnit                                                                                             
    objectClass: top                                                                                                            
    ou: Hosts

    dn: cn=gojira+ipHostNumber=192.168.1.1,ou=Hosts,dc=marex,dc=local
    objectClass: ipHost
    objectClass: device
    objectClass: top
    cn: gojira
    ipHostNumber: 192.168.1.1

    dn: cn=gamera+ipHostNumber=192.168.1.50,ou=Hosts,dc=marex,dc=local
    objectClass: ipHost
    objectClass: device
    objectClass: top
    cn: gamera
    ipHostNumber: 192.168.1.50

    dn: cn=iris+ipHostNumber=192.168.1.51,ou=Hosts,dc=marex,dc=local
    objectClass: ipHost
    objectClass: device
    objectClass: top
    cn: iris
    ipHostNumber: 192.168.1.51

    dn: cn=zedan+ipHostNumber=192.168.1.52,ou=Hosts,dc=marex,dc=local
    objectClass: ipHost
    objectClass: device
    objectClass: top
    cn: zedan
    ipHostNumber: 192.168.1.52

Next put the file into your LDAP server with your credentials (output
truncated):

    $ ldapadd -x -W -D 'cn=ldapadmin,dc=marex,dc=local' -h 192.168.1.1 -p 389 -f hosts.ldif
    ...
    adding new entry "cn=zedan+ipHostNumber=192.168.1.52,ou=Hosts,dc=marex,dc=local"

If everything filled up then edit your /etc/nss_ldap.conf and change the
line beginning with nss_base_hosts to the following:

    nss_base_hosts          ou=Hosts,dc=marex,dc=local?one

Now change the /etc/hosts in that way that only localhost, the LDAP
server and the own name of the workstation exist. An example how it
could look on the workstation gamera:

    127.0.0.1 localhost
    192.168.1.1 gojira.marex.local gojira
    192.168.1.50 gamera.marex.local gamera

On the LDAP server you can ignore every workstation. Finally you need to
edit hosts entry in your /etc/nsswitch.conf:

    hosts:          files dns ldap

Now test your configuration:

    $ getent hosts
    127.0.0.1       localhost
    192.168.1.1     gojira.marex.local gojira
    192.168.1.50    gamera.marex.local gamera
    192.168.1.1     gojira
    192.168.1.50    gamera
    192.168.1.51    iris
    192.168.1.52    zedan

The first 3 lines are from /etc/hosts, the last 4 lines are from your
LDAP server. Finally to get ping work with LDAP you need to start nscd:

    $ mkdir -p /var/db/nscd
    $ mkdir -p /var/run/nscd
    $ /etc/rc.d/nscd start
    $ ping iris
    PING iris (192.168.1.51) 56(84) bytes of data.
    ...

Retrieved from
"https://wiki.archlinux.org/index.php?title=LDAP_Hosts&oldid=284177"

Category:

-   Networking

-   This page was last modified on 23 November 2013, at 00:33.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
