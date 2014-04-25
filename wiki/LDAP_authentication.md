LDAP authentication
===================

Related articles

-   OpenLDAP
-   LDAP Hosts

Contents
--------

-   1 Introduction and Concepts
    -   1.1 NSS and PAM
-   2 LDAP Server Setup
    -   2.1 Installation
    -   2.2 Set up access controls
    -   2.3 Populate LDAP Tree with Base Data
    -   2.4 Adding users
-   3 Client Setup
    -   3.1 NSS Configuration
        -   3.1.1 Name Service Cache Daemon
    -   3.2 PAM Configuration
        -   3.2.1 Create home folders at login
        -   3.2.2 Enable sudo
-   4 Resources

Introduction and Concepts
-------------------------

This is a guide on how to configure an Arch Linux installation to
authenticate against an LDAP directory. This LDAP directory can be
either local (installed on the same computer) or network (e.g. in a lab
environment where central authentication is desired).

The guide is divided into two parts. The first part deals with how to
setup an OpenLDAP server that hosts the authentication directory. The
second part deals with how to setup the NSS and PAM modules that are
required for the authentication scheme to work on the client computers.
If you just want to configure Arch to authenticate against an already
existing LDAP server, you can skip to the second part.

> NSS and PAM

NSS (which stands for Name Service Switch) is a system mechanism to
configure different sources for common configuration databases. For
example, /etc/passwd is a file type source for the passwd database.

PAM (which stands for Pluggable Authentication Module) is a mechanism
used by Linux (and most *nixes) to extend its authentication schemes
based on different plugins.

So to summarize, we need to configure NSS to use the OpenLDAP server as
a source for the passwd, shadow and other configuration databases and
then configure PAM to use these sources to authenticate it's users.

LDAP Server Setup
-----------------

> Installation

You can read about installation and basic configuration in the OpenLDAP
article. After you have completed that, return here.

> Set up access controls

To make sure that no-one can read the (encrypted) passwords from the
LDAP server, but a user can edit their own password, add the following
to /etc/openldap/slapd.conf and restart slapd.service afterwards:

    slapd.conf

    access to attrs=userPassword
            by self write
            by anonymous auth
            by * none

    access to *
            by self write
            by * read

> Populate LDAP Tree with Base Data

Create a temporarily file called base.ldif with the following text.

Note:If you have a different domain name then alter "example" and "org"
to your needs

    base.ldif

    # example.org
    dn: dc=example,dc=org
    dc: example
    o: Example Organization
    objectClass: dcObject
    objectClass: organization

    # Manager, example.org
    dn: cn=Manager,dc=example,dc=org
    cn: Manager
    description: LDAP administrator
    objectClass: organizationalRole
    objectClass: top
    roleOccupant: dc=example,dc=org

    # People, example.org
    dn: ou=People,dc=example,dc=org
    ou: People
    objectClass: top
    objectClass: organizationalUnit

    # Groups, example.org
    dn: ou=Groups,dc=example,dc=org
    ou: Groups
    objectClass: top
    objectClass: organizationalUnit

Add it to your OpenLDAP Tree:

    $ ldapadd -D "cn=Manager,dc=example,dc=org" -W -f base.ldif

Test to make sure the data was imported:

    $ ldapsearch -x -b 'dc=example,dc=org' '(objectclass=*)'

> Adding users

To manually add a user, create an .ldif file like this:

    user_joe.ldif

    dn: uid=johndoe,ou=People,dc=example,dc=org
    objectClass: top
    objectClass: person
    objectClass: organizationalPerson
    objectClass: inetOrgPerson
    objectClass: posixAccount
    objectClass: shadowAccount
    uid: johndoe
    cn: John Doe
    sn: Doe
    givenName: John
    title: Guinea Pig
    telephoneNumber: +0 000 000 0000
    mobile: +0 000 000 0000
    postalAddress: AddressLine1$AddressLine2$AddressLine3
    userPassword: {CRYPT}xxxxxxxxxx
    labeledURI: https://archlinux.org/
    loginShell: /bin/bash
    uidNumber: 9999
    gidNumber: 9999
    homeDirectory: /home/johndoe/
    description: This is an example user

The xxxxxxxxxx in the userPassword entry should be replaced with the
value in /etc/shadow or use the slappasswd command. Now add the user:

    $ ldapadd -D "cn=Manager,dc=example,dc=org" -W -f user_joe.ldif

Note:You can automatically migrate all of your local accounts (and
groups, etc.) to the LDAP directory using PADL Software's Migration
Tools.

Client Setup
------------

Install the OpenLDAP client as described in OpenLDAP. Make sure you can
query the server with ldapsearch.

Next, install nss-pam-ldapd from the official repositories.

> NSS Configuration

NSS is a system facility which manages different sources as
configuration databases. For example, /etc/passwd is a file type source
for the passwd database, which stores the user accounts.

Edit /etc/nsswitch.conf which is the central configuration file for NSS.
It tells NSS which sources to use for which system databases. We need to
add the ldap directive to the passwd, group and shadow databases, so be
sure your file looks like this:

    passwd: files ldap
    group: files ldap
    shadow: files ldap

Edit /etc/nslcd.conf and change the base and uri lines to fit your ldap
server setup.

Start nslcd.service using systemd.

You now should see your LDAP users when running getent passwd on the
client.

Name Service Cache Daemon

You can optionally run NSCD. This is a daemon that NSS uses to cache
lookups and queries for network backends. This way you can login when
the LDAP server is down, it will also reduce load on the LDAP server.

Start nscd.service using systemd.

Note:It is recommended to stop the NSCD when troubleshooting because it
may mask problems by serving cached queries.

> PAM Configuration

The basic rule of thumb for PAM configuration is to include pam_ldap.so
wherever pam_unix.so is included. Arch moving to pambase has helped
decrease the amount of edits required. For more details about
configuring pam, the RedHat Documentation is quite good. You might also
want the upstream documentation for nss-pam-ldapd.

Tip:If you want to prevent UID clashes with local users on your system,
you might want to include minimum_uid=10000 or similar on the end of the
pam_ldap.so lines. You'll have to make sure the LDAP server returns
uidNumber fields that match the restriction.

Note:Each facility (auth, session, password, account) forms a separate
chain and the order matters. Sufficient lines will sometimes "short
circuit" and skip the rest of the section, so the rule of thumb for
auth, password, and account is sufficient lines before required, but
after required lines for the session section; optional can almost always
go at the end. When adding your pam_ldap.so lines, don't change the
relative order of the other lines without good reason! Simply insert
LDAP within the chain.

First edit /etc/pam.d/system-auth. This file is included in most of the
other files in pam.d, so changes here propagate nicely. Updates to
pambase may change this file.

Make pam_ldap.so sufficient at the top of each section, except in the
session section, where we make it optional.

    /etc/pam.d/system-auth

    auth      sufficient pam_ldap.so
    auth      required  pam_unix.so     try_first_pass nullok
    auth      optional  pam_permit.so
    auth      required  pam_env.so

    account   sufficient pam_ldap.so
    account   required  pam_unix.so
    account   optional  pam_permit.so
    account   required  pam_time.so

    password  sufficient pam_ldap.so
    password  required  pam_unix.so     try_first_pass nullok sha512 shadow
    password  optional  pam_permit.so

    session   required  pam_limits.so
    session   required  pam_unix.so
    session   optional  pam_ldap.so
    session   optional  pam_permit.so

Then edit both /etc/pam.d/su and /etc/pam.d/su-l identically. The su-l
file is used when the user runs su --login.

Make pam_ldap.so sufficient at the top of each section, and add
use_first_pass to pam_unix in the auth section.

    /etc/pam.d/su

    #%PAM-1.0
    auth      sufficient    pam_ldap.so
    auth      sufficient    pam_rootok.so
    # Uncomment the following line to implicitly trust users in the "wheel" group.
    #auth     sufficient    pam_wheel.so trust use_uid
    # Uncomment the following line to require a user to be in the "wheel" group.
    #auth     required      pam_wheel.so use_uid
    auth      required	pam_unix.so use_first_pass
    account   sufficient    pam_ldap.so
    account   required	pam_unix.so
    session   sufficient    pam_ldap.so
    session   required	pam_unix.so

To enable users to edit their password, edit /etc/pam.d/passwd:

    /etc/pam.d/passwd

    #%PAM-1.0
    password        sufficient      pam_ldap.so
    #password       required        pam_cracklib.so difok=2 minlen=8 dcredit=2 ocredit=2 retry=3
    #password       required        pam_unix.so sha512 shadow use_authtok
    password        required        pam_unix.so sha512 shadow nullok

Create home folders at login

If you want home folders to be created at login (eg: if you aren't using
NFS to store home folders), edit /etc/pam.d/system-login and add
pam_mkhomedir.so to the session section above any "sufficient" items.
This will cause home folder creation when logging in at a tty, from ssh,
xdm, kdm, gdm, etc. You might choose to edit additional files in the
same way, such as /etc/pam.d/su and /etc/pam.d/su-l to enable it for su
and su --login. If you don't want to do this for ssh logins, edit
system-local-login instead of system-login, etc.

    /etc/pam.d/system-login

    ...top of file not shown...
    session    optional   pam_loginuid.so
    session    include    system-auth
    session    optional   pam_motd.so          motd=/etc/motd
    session    optional   pam_mail.so          dir=/var/spool/mail standard quiet
    -session   optional   pam_systemd.so
    session    required   pam_env.so
    session    required   pam_mkhomedir.so skel=/etc/skel umask=0022

    /etc/pam.d/su-l

    ...top of file not shown...
    session         required        pam_mkhomedir.so skel=/etc/skel umask=0022
    session         sufficient      pam_ldap.so
    session         required        pam_unix.so

Enable sudo

To enable sudo from an LDAP user, edit /etc/pam.d/sudo. You'll also need
to modify sudoers accordingly.

    /etc/pam.d/sudo

    #%PAM-1.0
    auth      sufficient    pam_ldap.so
    auth      required      pam_unix.so  try_first_pass
    auth      required      pam_nologin.so

Resources
---------

The official page of the nss-pam-ldapd packet

The PAM and NSS page at the Debian Wiki 1 2

Using LDAP for single authentication

Heterogeneous Network Authentication Introduction

Discussion on suse's mailing lists about nss-pam-ldapd

Retrieved from
"https://wiki.archlinux.org/index.php?title=LDAP_authentication&oldid=297177"

Categories:

-   Networking
-   Security

-   This page was last modified on 13 February 2014, at 10:58.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
