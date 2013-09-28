OpenLDAP Authentication
=======================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason:                  
                           pam_ldap/nss_ldap are    
                           deprecated in favor of   
                           nss-pam-ldapd; pambase   
                           obsoletes most of the    
                           pam section (Discuss)    
  ------------------------ ------------------------ ------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with LDAP        
                           Authentication.          
                           Notes: please use the    
                           second argument of the   
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction and Concepts                                          |
|     -   1.1 OpenLDAP                                                     |
|     -   1.2 NSS and PAM                                                  |
|                                                                          |
| -   2 OpenLDAP Setup                                                     |
|     -   2.1 Installation                                                 |
|     -   2.2 Populate LDAP Tree with Base Data                            |
|                                                                          |
| -   3 Client Setup                                                       |
|     -   3.1 OpenLDAP                                                     |
|     -   3.2 NSS Configuration                                            |
|         -   3.2.1 Name Service Cache Daemon                              |
|         -   3.2.2 NSLCD                                                  |
|                                                                          |
|     -   3.3 PAM Configuration                                            |
|                                                                          |
| -   4 Resources                                                          |
+--------------------------------------------------------------------------+

Introduction and Concepts
-------------------------

This is a guide on how to configure an Archlinux installation to
authenticate against an OpenLDAP server.The openldap backend can be
either local (installed on the same computer) or network (i.e in a lab
environment where central authentication is desired). The guide will be
divided in two parts. The first part deals with how to setup OpenLDAP
locally and the second with how to setup the NSS and PAM modules
required for the authentication scheme to work. If you just want to
configure Arch to authenticated against an already excisting LDAP server
then you can skip to the second part.

> OpenLDAP

OpenLDAP is an open-source server implementation of the LDAP protocol.
It is mainly used as an authentication backend to various services (the
most famous one being Samba, which is used to emulate a domain
controller) and basically holds the user data. The closest analogue to
real life, would be the telephone directory. Another generalised
explanation of what an LDAP server does is that it is a database (which
it basically is, but it is not relational) which is optimised for
accessing the data and not reading them.

Commands relate to OpenLDAP that begin with ldap (like ldapsearch) are
client-side utilities while commands that begin with slap (like slapcat)
are server-side. Arch packages both in the openldap package, so you need
to install it regardless of o local or network OpenLDAP install.

> NSS and PAM

NSS (which stands for Name Service Switch) is a system mechanism to
configure different sources for common configuration databases. For
example, /etc/passwd is a file type source for the passwd database.

PAM (which stands for Pluggable Authentication Module) is a machanism
Linux (and most *nixes) uses to extend it's authentication schemes based
on different plugins.

So to summarize, we need to configure NSS to use the OpenLDAP server as
a source for the passwd shadow and other configuration databases and
then configure PAM to use these sources to authenticate it's users.

OpenLDAP Setup
--------------

> Installation

You can read about installation and basic configuration in the OpenLDAP
article. After you have completed that, return here.

> Populate LDAP Tree with Base Data

Create a file called base.ldif with the following text:

    # example.org
    dn: dc=example,dc=org
    objectClass: dcObject
    objectClass: organization
    o: Example Organization
    dc: example

    # Manager, example.org
    dn: cn=Manager,dc=example,dc=org
    cn: Manager
    description: LDAP administrator
    roleOccupant: dc=example,dc=org
    objectClass: organizationalRole
    objectClass: top

    # People, example.org
    dn: ou=People,dc=example,dc=org
    ou: People
    objectClass: top
    objectClass: organizationalUnit

    # Group, example.org
    dn: ou=Group,dc=example,dc=org
    ou: Group
    objectClass: top
    objectClass: organizationalUnit

Add it to your OpenLDAP Tree:

    ldapadd -x -D "cn=Manager,dc=example,dc=org" -W -f base.ldif

Test to make sure the data was imported:

    ldapsearch -x -b 'dc=example,dc=org' '(objectclass=*)'

  

Client Setup
------------

Install openldap from the official repositories. This is needed
regardless of whether you run openldap on your machine or over the
network.

Next, install nss-pam-ldapd from the Arch User Repository.

There is the nss_ldap and pam_ldap from the official repositories

> OpenLDAP

Before you begin setting up PAM and NSS for ldap authentication, you
should try to check if the LDAP server is available. You can do this
easily with ldapsearch.

You can search an LDAP server with the following command:

    ldapsearch -x -H <URL> -b <BASE>

Tip: -x is required in all client commands because SASL authentication
probably hasn't been configured.

You can add the URL and BASE settings to /etc/openldap/ldap.conf in
order to avoid writing the everytime. All client-side ldap utilities use
this file to read some general variables.

Warning: If you created a self-signed certificate above you need to also
add the following line or you will not be able connect to the server:
TLS_REQCERT allow

> NSS Configuration

NSS is a system facility which manages different sources as
configuration databases. For example /etc/passwd is i file-type source
for the passwd which by default stores the user accounts. nss_ldap is a
plugin which allow NSS to see an OpenLDAP server as a source for these
databases.

Edit /etc/nsswitch.conf which is the central configuration file for NSS.
It tells NSS which sources to use for which system databases. We need to
add the ldap directive to the passwd, group and shadow databases, so be
sure your file looks like this:

    passwd: files ldap
    group: files ldap
    shadow: files ldap

Name Service Cache Daemon

NSCD is a daemon that NSS runs that is responsible for caching lookups
and queries for network backends.

Template:Important

READ THIS FIRST: [NSCD Bugged in Arch Linux] Fix nscd:

    mkdir -p /var/db/nscd/
    mkdir -p /var/run/nscd/

Run nscd:

    systemctl start nscd

NSLCD

> PAM Configuration

Edit /etc/pam.d/login:

    auth            requisite       pam_securetty.so
    auth            requisite       pam_nologin.so
    auth            sufficient      pam_ldap.so              
    auth            required        pam_env.so
    auth            required        pam_unix.so nullok try_first_pass
    account         sufficient      pam_ldap.so
    account         required        pam_access.so
    account         required        pam_unix.so
    session         required        pam_motd.so
    session         required        pam_limits.so
    session         optional        pam_mail.so dir=/var/spool/mail standard
    session         optional        pam_lastlog.so
    session         required        pam_unix.so

Edit /etc/pam.d/passwd:

    password        sufficient      pam_ldap.so
    password        required        pam_unix.so shadow md5 nullok

Edit /etc/pam.d/shadow:

    auth            sufficient      pam_ldap.so
    auth            sufficient      pam_rootok.so
    auth            required        pam_unix.so
    account         sufficient      pam_ldap.so
    account         required        pam_unix.so
    session         sufficient      pam_ldap.so
    session         required        pam_unix.so
    password        sufficient      pam_ldap.so
    password        required        pam_permit.so

edit /etc/pam.d/su:

    auth            sufficient      pam_ldap.so
    auth            sufficient      pam_rootok.so
    auth            required        pam_unix.so use_first_pass
    account         sufficient      pam_ldap.so
    account         required        pam_unix.so
    session         sufficient      pam_ldap.so
    session         required        pam_unix.so

edit /etc/pam.d/sshd:

    auth            sufficient      pam_ldap.so
    auth            required        pam_securetty.so        #Disable remote root
    auth            required        pam_unix.so try_first_pass
    auth            required        pam_nologin.so
    auth            required        pam_env.so
    account         sufficient      pam_ldap.so
    account         required        pam_unix.so
    account         required        pam_time.so
    password        sufficient      pam_ldap.so
    password        required        pam_unix.so
    session         required        pam_unix_session.so
    session         required        pam_limits.so

edit /etc/pam.d/other:

    auth            sufficient      pam_ldap.so
    auth            required        pam_unix.so
    account         sufficient      pam_ldap.so
    account         required        pam_unix.so
    password        sufficient      pam_ldap.so
    password        required        pam_unix.so
    session         required        pam_unix.so

Resources
---------

The official page of the nss-pam-ldapd packet

The PAM and NSS page at the Debian Wiki 1 2

Using LDAP for single authentication

Heterogeneous Network Authentication Introduction

Discussion on suse's mailing lists about nss-pam-ldapd

Retrieved from
"https://wiki.archlinux.org/index.php?title=OpenLDAP_Authentication&oldid=252603"

Categories:

-   Networking
-   Security
