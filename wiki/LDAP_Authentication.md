LDAP Authentication
===================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: slapd.conf(5) is 
                           deprecated;              
                           initscripts/sysvinit is  
                           deprecated (Discuss)     
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with OpenLDAP    
                           Authentication.          
                           Notes: please use the    
                           second argument of the   
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 HOWTO - LDAP Authentication in Arch Linux                          |
|     -   1.1 Overview                                                     |
|         -   1.1.1 References                                             |
|         -   1.1.2 For the newbies                                        |
|                                                                          |
|     -   1.2 Install OpenLDAP                                             |
|     -   1.3 Design LDAP Directory                                        |
|     -   1.4 Configure and Fill OpenLDAP                                  |
|     -   1.5 Configure NSS                                                |
+--------------------------------------------------------------------------+

HOWTO - LDAP Authentication in Arch Linux
-----------------------------------------

> Overview

What you need to install, configure, and know, to get LDAP RFC 2251
Authentication working on Arch.

Steps:

1.  Install OpenLDAP
2.  Design LDAP Directory
3.  Configure and Fill OpenLDAP
4.  Configure NSS
5.  Configure PAM

References

http://aqua.subnet.at/~max/ldap/

For the newbies

If you are totally new to those concepts, here is an good introduction
that is easy to understand and that will get you started, even if you
are new to everything LDAP.

http://www.brennan.id.au/20-Shared_Address_Book_LDAP.html

> Install OpenLDAP

See the OpenLDAP article

> Design LDAP Directory

This all depends on what organization your network/computer is modeling.

Here is my initial layout in LDIF Format

    dn: dc=tklogic,dc=net
    dc: tklogic 
    description: The techknowlogic.net Network
    objectClass: dcObject
    objectClass: organization
    o: techknowlogic.net 

    dn: ou=People,dc=tklogic,dc=net
    ou: People
    objectClass: organizationalUnit

    dn: ou=Groups, dc=tklogic,dc=net
    ou: Groups
    objectClass: top
    objectClass: organizationalUnit

    dn: cn=tklusers,ou=Groups,dc=tklogic,dc=net
    gidNumber: 2000
    objectClass: posixGroup
    objectClass: top
    cn: tklusers

    dn: ou=Roles,dc=tklogic,dc=net
    ou: Roles
    description: Org Unit for holding a basic set of ACL Roles.
    objectClass: top
    objectClass: organizationalUnit

    dn: cn=ldap-reader,ou=Roles,dc=tklogic,dc=net
    userPassword: {CRYPT}xxxxxxxxxxxxx
    objectClass: organizationalRole
    objectClass: simpleSecurityObject
    cn: ldap-reader
    description: LDAP reader user for any unrestricted reads (i.e. for NSS)

    dn: cn=ldap-manager,ou=Roles,dc=tklogic,dc=net
    userPassword: {CRYPT}xxxxxxxxxxxxx
    objectClass: organizationalRole
    objectClass: simpleSecurityObject
    cn: ldap-manager
    description: LDAP manager user for any unrestricted read/writes (i.e. root-like)

Now for each user:

    dn: uid=user,ou=People,dc=tklogic,dc=net
    objectClass: top
    objectClass: person
    objectClass: organizationalPerson
    objectClass: inetOrgPerson
    objectClass: posixAccount
    objectClass: shadowAccount
    uid: user
    cn: Test User
    sn: User
    givenName: Test
    title: Guinea Pig
    telephoneNumber: +0 000 000 0000
    mobile: +0 000 000 0000
    postalAddress: AddressLine1$AddressLine2$AddressLine3
    userPassword: {CRYPT}xxxxxxxxxx
    labeledURI: http://test.tklogic.net/
    loginShell: /bin/bash
    uidNumber: 10000
    gidNumber: 2000
    homeDirectory: /users/test/
    description: A Test User for the ArchWiki LDAP-Authentication HOWTO

> Configure and Fill OpenLDAP

Client Side

/etc/openldap/ldap.conf

    BASE    dc=yourdomain,dc=com
    URI     ldap://yourdomain.com

/etc/pam_ldap.conf and /etc/nss_ldap.conf

If there is an actual difference between these files, please let me
know.

>> There's not. In Gentoo we use only one /etc/ldap.conf file, so I made
hardlinks on these two, using only one file it works. Wonder why Arch
has it separated. Anybody knows?

>>> Actually I have moved the /etc/nss_ldap.conf to /etc/ldap.conf.
/etc/openldap/ldap.conf and /etc/nss_ldap.conf are only sym-links to
/etc/ldap.conf. Works fine for me.

    host yourdomain.com
    base dc=yourdomain,dc=com
    uri ldap://yourdomain.com/
    ldap_version 3
    rootbinddn cn=Manager,dc=yourdomain,dc=com
    scope sub
    timelimit 5
    bind_timelimit 5
    nss_reconnect_tries 2
    pam_login_attribute uid
    pam_member_attribute gid
    pam_password md5
    pam_password exop
    nss_base_passwd		ou=People,dc=yourdomain,dc=com
    nss_base_shadow		ou=People,dc=yourdomain,dc=com

/etc/ldap.secret

    plaintextpassword

Chmod to 600

  
 Server Side

/etc/openldap/slapd.conf

    include         /etc/openldap/schema/core.schema
    include         /etc/openldap/schema/cosine.schema
    include         /etc/openldap/schema/inetorgperson.schema
    include         /etc/openldap/schema/nis.schema
    include         /etc/openldap/schema/courier.schema
    allow bind_v2
    password-hash {md5}
    pidfile   /var/run/slapd.pid
    argsfile  /var/run/slapd.args
    database        bdb
    suffix          "dc=yourdomain,dc=com"
    rootdn          "cn=Manager,dc=yourdomain,dc=com"
    rootpw          password (Use slappasswd -h {MD5} -s passwordstring)
    directory       /var/lib/openldap/openldap-data
    index   objectClass     eq
    index   uid     eq

> Configure NSS

/etc/nsswitch.conf

    passwd:         files
    group:          files
    hosts:          dns
    services:   files 
    networks:   files 
    protocols:  files 
    rpc:        files 
    ethers:     files 
    netmasks:   files
    bootparams: files
    publickey:  files
    automount:  files
    aliases:    files
    sendmailvars:   files
    netgroup:   file

/etc/nsswitch.ldap

    passwd:         files ldap
    group:          files ldap
    hosts:          dns ldap
    services:   ldap [NOTFOUND=return] files
    networks:   ldap [NOTFOUND=return] files
    protocols:  ldap [NOTFOUND=return] files
    rpc:        ldap [NOTFOUND=return] files
    ethers:     ldap [NOTFOUND=return] files
    netmasks:   files
    bootparams: files
    publickey:  files
    automount:  files
    sendmailvars:   files
    netgroup:   ldap [NOTFOUND=return] files

  
 /etc/rc.sysinit

Be sure to modify this file before you reboot or your machine will hang
on "Starting UDev Daemon"

Add this before UDev starts

    cp /etc/nsswitch.file /etc/nsswitch.conf

And this after UDev is started

    cp /etc/nsswitch.ldap /etc/nsswitch.conf

Hopefully there will be a fix later.

udev / ldap boot update -> please see:
https://wiki.archlinux.org/index.php/Udev-ldap_workaround </pre>

Alternative Fix

If you do not require LDAP to discover your host is to have the
nsswitch.conf read

    hosts:          files dns

this will bypass the need to modify /etc/rc.sysinit and not hang on boot

Retrieved from
"https://wiki.archlinux.org/index.php?title=LDAP_Authentication&oldid=246879"

Category:

-   Security
