Active Directory Integration
============================

Warning:Because Arch Linux is a rolling release distribution, it is
possible that some of the information in this article could be outdated
due to package or configuration changes made by the maintainers. Never
blindly follow these or any other instructions. When the instructions
say to edit or change a file, consider making a backup copy. Check the
date of the last revision of this article.

A key challenge for system administrators of any datacenter is trying to
coexisting in Heterogeneous environments. By this we mean the mixing of
different server operating system technologies (typically Microsoft
Windows & Unix/Linux). User management and authentication is by far the
most difficult of these to solve. The most common way of solving this
problem is to use a Directory Server. There are a number of open-source
and commercial solutions for the various flavors of *NIX; however, few
solve the problem of interoperating with Windows. Active Directory (AD)
is a directory service created by Microsoft for Windows domain networks.
It is included in most Windows Server operating systems. Server
computers on which Active Directory is running are called domain
controllers.

Active Directory serves as a central location for network administration
and security. It is responsible for authenticating and authorizing all
users and computers within a network of Windows domain type, assigning
and enforcing security policies for all computers in a network and
installing or updating software on network computers. For example, when
a user logs into a computer that is part of a Windows domain, it is
Active Directory that verifies his or her password and specifies whether
he or she is a system administrator or normal user.

Active Directory uses Lightweight Directory Access Protocol (LDAP)
versions 2 and 3, Kerberos and DNS. These same standards are available
as linux, but piecing them together is not an easy task. Following these
steps will help you configure an ArchLinux host to authenticate against
an AD domain.

This guide explains how to integrate an Arch Linux host with an existing
Windows Active Directory domain. Before continuing, you must have an
existing Active Directory domain, and have a user with the appropriate
rights within the domain to: query users and add computer accounts
(Domain Join).

This document is not an intended as a complete guide to Active Directory
nor Samba. Refer to the resources section for additional information.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Terminology                                                        |
| -   2 Configuration                                                      |
|     -   2.1 Active Directory Configuration                               |
|         -   2.1.1 Updating the GPO                                       |
|                                                                          |
|     -   2.2 Linux Host Configuration                                     |
|     -   2.3 Installation                                                 |
|     -   2.4 Updating DNS                                                 |
|     -   2.5 Configuring NTP                                              |
|     -   2.6 Kerberos                                                     |
|         -   2.6.1 Creating a Kerberos Ticket                             |
|         -   2.6.2 Validating the Ticket                                  |
|                                                                          |
|     -   2.7 Samba                                                        |
|                                                                          |
| -   3 Starting and testing services                                      |
|     -   3.1 Starting Samba                                               |
|     -   3.2 Join the Domain                                              |
|     -   3.3 Restart Samba                                                |
|     -   3.4 Testing Winbind                                              |
|     -   3.5 Testing nsswitch                                             |
|     -   3.6 Testing Samba commands                                       |
|                                                                          |
| -   4 Configuring PAM                                                    |
|     -   4.1 Testing login                                                |
|     -   4.2 /etc/pam.d/gdm                                               |
|     -   4.3 Sudo                                                         |
|                                                                          |
| -   5 Configuring Shares                                                 |
| -   6 See also                                                           |
|     -   6.1 Commercial Solutions                                         |
+--------------------------------------------------------------------------+

Terminology
-----------

If you are not familiar with Active Directory, there are a few keywords
that are helpful to know.

-   Domain : The name used to group computers and accounts.
-   SID : Each computer that joins the domain as a member must have a
    unique SID or System Identifier.
-   SMB : Server Message Block.
-   NETBIOS: Network naming protocol used as an alternative to DNS.
    Mostly legacy, but still used in Windows Networking.
-   WINS: Windows Information Naming Service. Used for resolving Netbios
    names to windows hosts.
-   Winbind: Protocol for windows authentication.

Configuration
-------------

> Active Directory Configuration

Warning:This section has not been validated. Proceed with caution

Updating the GPO

It may be necessary to disable Digital Sign Communication (Always) in
the AD group policies. Dive into:

Local policies -> Security policies -> Microsoft Network Server ->
Digital sign communication (Always) -> activate define this policy and
use the disable radio button.

If you use Windows Server 2008 R2, you need to modify that in GPO for
Default Domain Controller Policy -> Computer Setting -> Policies ->
Windows Setting -> Security Setting -> Local Policies -> Security Option
-> Microsoft network client: Digitally sign communications (always)

> Linux Host Configuration

The next few steps will begin the process of configuring the Host. You
will need root or sudo access to complete these steps.

> Installation

Install the following packages:

-   samba
-   pam-krb5 ---- error: does not exist in latest version or arch linux!
-   pam_pwcheck
-   openntpd (or) ntp

> Updating DNS

Active Directory is heavily dependent upon DNS. You will need to update
/etc/resolv.conf to use one or more of the Active Directory domain
controllers:

    /etc/resolv.conf

    nameserver <IP1>
    nameserver <IP2>

Replacing <IP1> and <IP2> with valid IP addresses for the AD servers. If
your AD domains do not permit DNS forwarding or recursion, you may need
to add additional resolvers.

Note:If your machine dual boots Windows and Linux, you should use a
different DNS hostname and netbios name for the linux configuration if
both operating systems will be members of the same domain.

> Configuring NTP

Read NTPd or OpenNTPD to configure a NTP service. Note that OpenNTPD is
no longer maintained.

On the configuration, use the IP addresses for the AD servers.
Alternatively, you can use other known NTP servers provided the Active
directory servers sync to the same stratum. However, AD servers
typically run NTP as a service.

Ensure the daemon is configured to sync automatically on startup.

> Kerberos

Let's assume that your AD is named example.com. Let's further assume
your AD is ruled by two domain controllers, the primary and secondary
one, which are named PDC and BDC, pdc.example.com and bdc.example.com
respectively. Their IP adresses will be 192.168.1.2 and 192.168.1.3 in
this example. Take care to watch your syntax; upper-case is very
important here.

    /etc/krb5.conf

    [libdefaults]
            default_realm 	= 	EXAMPLE.COM
    	clockskew 	= 	300
    	ticket_lifetime	=	1d
            forwardable     =       true
            proxiable       =       true
            dns_lookup_realm =      true
            dns_lookup_kdc  =       true
    	
    [realms]
    	EXAMPLE.COM = {
    		kdc 	= 	PDC.EXAMPLE.COM
                    admin_server = PDC.EXAMPLE.COM
    		default_domain = EXAMPLE.COM
    	}
    	
    [domain_realm]
            .kerberos.server = EXAMPLE.COM
    	.example.com = EXAMPLE.COM
    	example.com = EXAMPLE.COM
    	example	= EXAMPLE.COM

    [appdefaults]
    	pam = {
    	ticket_lifetime 	= 1d
    	renew_lifetime 		= 1d
    	forwardable 		= true
    	proxiable 		= false
    	retain_after_close 	= false
    	minimum_uid 		= 0
    	debug 			= false
    	}

    [logging]
    	default 		= FILE:/var/log/krb5libs.log
    	kdc 			= FILE:/var/log/kdc.log
            admin_server            = FILE:/var/log/kadmind.log

Note:Heimdal 1.3.1 deprecated DES encryption which is required for AD
authentication before Windows Server 2008. You'll probably have to add

    allow_weak_crypto = true

to the [libdefaults] section.

Creating a Kerberos Ticket

Now you can query the AD domain controllers and request a kerberos
ticket (uppercase is necessary):

    kinit administrator@EXAMPLE.COM

You can use any username that has rights as a Domain Administrator.

Validating the Ticket

Run klist to verify you did receive the token. You should see something
similar to:

    # klist

     Ticket cache: FILE:/tmp/krb5cc_0
     Default principal: administrator@EXAMPLE.COM
     
     Valid starting    Expires           Service principal 
     02/04/12 21:27:47 02/05/12 07:27:42 krbtgt/EXAMPLE.COM@EXAMPLE.COM
             renew until 02/05/12 21:27:47

> Samba

Samba is a free software re-implementation of the SMB/CIFS networking
protocol. It also includes tools for Linux machines to act as Windows
networking servers and clients.

Note:The configuration can vary greatly depending on how the Windows
environment is deployed. Be prepared to troubleshoot and research

In this section, we will focus on getting Authentication to work first
by editing the 'Global' section first. Later, we will go back and add
shares.

    /etc/samba/smb.conf

    [Global]
      netbios name = MYARCHLINUX
      workgroup = EXAMPLE
      realm = EXAMPLE.COM
      server string = %h ArchLinux Host
      security = ads
      encrypt passwords = yes
      password server = pdc.example.com
      idmap uid = 10000-20000
      idmap gid = 10000-20000
     
      #idmap backend = rid

      winbind use default domain = Yes
      winbind enum users = Yes
      winbind enum groups = Yes
      winbind nested groups = Yes
      winbind separator = +
      winbind refresh tickets = yes
      winbind gid = 10000-20000

      template shell = /bin/bash
      template homedir = /home/%D/%U
       
      preferred master = no
      dns proxy = no
      wins server = pdc.example.com
      wins proxy = no

      inherit acls = Yes
      map acl inherit = Yes
      acl group control = yes

      load printers = no
      debug level = 3
      use sendfile = no

We shall now explain to Samba that it shall use the PDC´s database for
authentication queries. Again, we use winbindd which is a part of the
samba package. Winbind maps the UID and GID of the AD to our
Linux-machine. Winbind uses a Unix-implementation of RPC-calls,
Pluggable Authentication Modules (aka PAM) and Name Service Switch (NSS)
to allow Windows AD and users accessing and to grant permissions on the
Linux-machine. The best part of winbindd is, that you don´t have to
define the mapping yourself, but only define a range of UID and GID.
That´s what we defined in smb.conf.

Update the samba configuration file to enable the winbind daemon

    /etc/conf.d/samba

     ##### /etc/conf.d/samba #####
     #SAMBA_DAEMONS=(smbd nmbd)
     SAMBA_DAEMONS=(smbd nmbd winbindd)

Next, configure samba to startup at boot. Read Daemons for more details.

Starting and testing services
-----------------------------

> Starting Samba

Hopefully, you have not rebooted yet! Fine. If you are in an X-session,
quit it, so you can test login into another console, while you are still
logged in.

Start Samba (including smbd, nmbd and winbindd):

If you check the processes, you'll see that winbind did not actually
start. A quick review of the logs shows that the SID for this host could
be obtained from the domain:

    # tail /var/log/samba/log.winbindd

    [2012/02/05 21:51:30.085574,  0] winbindd/winbindd_cache.c:3147(initialize_winbindd_cache)
      initialize_winbindd_cache: clearing cache and re-creating with version number 2
    [2012/02/05 21:51:30.086137,  2] winbindd/winbindd_util.c:233(add_trusted_domain)
      Added domain BUILTIN  S-1-5-32
    [2012/02/05 21:51:30.086223,  2] winbindd/winbindd_util.c:233(add_trusted_domain)
      Added domain MYARCHLINUX  S-1-5-21-3777857242-3272519233-2385508432
    [2012/02/05 21:51:30.086254,  0] winbindd/winbindd_util.c:635(init_domain_list)
      Could not fetch our SID - did we join?
    [2012/02/05 21:51:30.086408,  0] winbindd/winbindd.c:1105(winbindd_register_handlers)
      unable to initialize domain list

> Join the Domain

You need an AD Administrator account to do this. Let's assume this is
named Administrator. The command is 'net ads join'

    # net ads join -U Administrator

    Administrator's password: xxx
    Using short domain name -- EXAMPLE
    Joined 'MYARCHLINUX' to realm 'EXAMPLE.COM'

See screenshot of Active Directory Users and Computers [[1]]

> Restart Samba

winbindd failed to start on the first try because we were not yet a
domain.

Restart the samba service and winbind should fire up as well.

NSSwitch tells the Linux host how to retrieve information from various
sources and in which order to do so. In this case, we are appending
Active Directory as additional sources for Users, Groups, and Hosts.

    /etc/nsswitch.conf

     passwd:            files winbind
     shadow:            files winbind
     group:             files winbind 
     
     hosts:             files dns wins

> Testing Winbind

Let's check if winbind is able to query the AD. The following command
should return a list of AD users:

    # wbinfo -u

    administrator
    guest
    krbtgt
    test.user

-   Note we created an Active Directory user called 'test.user' on the
    domain controller

We can do the same for AD groups:

    # wbinfo -g

    domain computers
    domain controllers
    schema admins
    enterprise admins
    cert publishers
    domain admins
    domain users
    domain guests
    group policy creator owners
    ras and ias servers
    allowed rodc password replication group
    denied rodc password replication group
    read-only domain controllers
    enterprise read-only domain controllers
    dnsadmins
    dnsupdateproxy

> Testing nsswitch

To ensure that our host is able to query the domain for users and
groups, we test nsswitch settings by issuing the 'getent' command. The
following output shows what a stock ArchLinux install looks like:

    # getent passwd

    root:x:0:0:root:/root:/bin/bash
    bin:x:1:1:bin:/bin:/bin/false
    daemon:x:2:2:daemon:/sbin:/bin/false
    mail:x:8:12:mail:/var/spool/mail:/bin/false
    ftp:x:14:11:ftp:/srv/ftp:/bin/false
    http:x:33:33:http:/srv/http:/bin/false
    nobody:x:99:99:nobody:/:/bin/false
    dbus:x:81:81:System message bus:/:/bin/false
    ntp:x:87:87:Network Time Protocol:/var/empty:/bin/false
    avahi:x:84:84:avahi:/:/bin/false
    administrator:*:10001:10006:Administrator:/home/EXAMPLE/administrator:/bin/bash
    guest:*:10002:10007:Guest:/home/EXAMPLE/guest:/bin/bash
    krbtgt:*:10003:10006:krbtgt:/home/EXAMPLE/krbtgt:/bin/bash
    test.user:*:10000:10006:Test User:/home/EXAMPLE/test.user:/bin/bash

And for groups:

    # getent group

    root:x:0:root
    bin:x:1:root,bin,daemon
    daemon:x:2:root,bin,daemon
    sys:x:3:root,bin
    adm:x:4:root,daemon
    tty:x:5:
    disk:x:6:root
    lp:x:7:daemon
    mem:x:8:
    kmem:x:9:
    wheel:x:10:root
    ftp:x:11:
    mail:x:12:
    uucp:x:14:
    log:x:19:root
    utmp:x:20:
    locate:x:21:
    rfkill:x:24:
    smmsp:x:25:
    http:x:33:
    games:x:50:
    network:x:90:
    video:x:91:
    audio:x:92:
    optical:x:93:
    floppy:x:94:
    storage:x:95:
    scanner:x:96:
    power:x:98:
    nobody:x:99:
    users:x:100:
    dbus:x:81:
    ntp:x:87:
    avahi:x:84:
    domain computers:x:10008:
    domain controllers:x:10009:
    schema admins:x:10010:administrator
    enterprise admins:x:10011:administrator
    cert publishers:x:10012:
    domain admins:x:10013:test.user,administrator
    domain users:x:10006:
    domain guests:x:10007:
    group policy creator owners:x:10014:administrator
    ras and ias servers:x:10015:
    allowed rodc password replication group:x:10016:
    denied rodc password replication group:x:10017:krbtgt
    read-only domain controllers:x:10018:
    enterprise read-only domain controllers:x:10019:
    dnsadmins:x:10020:
    dnsupdateproxy:x:10021:

> Testing Samba commands

Try out some net commands to see if samba can communicate with AD:

    # net ads info

    [2012/02/05 20:21:36.473559,  0] param/loadparm.c:7599(lp_do_parameter)
      Ignoring unknown parameter "idmapd backend"
    LDAP server: 192.168.1.2
    LDAP server name: PDC.example.com
    Realm: EXAMPLE.COM
    Bind Path: dc=EXAMPLE,dc=COM
    LDAP port: 389
    Server time: Sun, 05 Feb 2012 20:21:33 CST
    KDC server: 192.168.1.2
    Server time offset: -3

    # net ads lookup

    [2012/02/05 20:22:39.298823,  0] param/loadparm.c:7599(lp_do_parameter)
      Ignoring unknown parameter "idmapd backend"
    Information for Domain Controller: 192.168.1.2

    Response Type: LOGON_SAM_LOGON_RESPONSE_EX
    GUID: 2a098512-4c9f-4fe4-ac22-8f9231fabbad
    Flags:
            Is a PDC:                                   yes
            Is a GC of the forest:                      yes
            Is an LDAP server:                          yes
            Supports DS:                                yes
            Is running a KDC:                           yes
            Is running time services:                   yes
            Is the closest DC:                          yes
            Is writable:                                yes
            Has a hardware clock:                       yes
            Is a non-domain NC serviced by LDAP server: no
            Is NT6 DC that has some secrets:            no
            Is NT6 DC that has all secrets:             yes
    Forest:                 example.com
    Domain:                 example.com
    Domain Controller:      PDC.example.com
    Pre-Win2k Domain:       EXAMPLE
    Pre-Win2k Hostname:     PDC
    Server Site Name :              Office
    Client Site Name :              Office
    NT Version: 5
    LMNT Token: ffff
    LM20 Token: ffff

    # net ads status -U administrator | less

    objectClass: top
    objectClass: person
    objectClass: organizationalPerson
    objectClass: user
    objectClass: computer
    cn: myarchlinux
    distinguishedName: CN=myarchlinux,CN=Computers,DC=leafscale,DC=inc
    instanceType: 4
    whenCreated: 20120206043413.0Z
    whenChanged: 20120206043414.0Z
    uSNCreated: 16556
    uSNChanged: 16563
    name: myarchlinux
    objectGUID: 2c24029c-8422-42b2-83b3-a255b9cb41b3
    userAccountControl: 69632
    badPwdCount: 0
    codePage: 0
    countryCode: 0
    badPasswordTime: 0
    lastLogoff: 0
    lastLogon: 129729780312632000
    localPolicyFlags: 0
    pwdLastSet: 129729764538848000
    primaryGroupID: 515
    objectSid: S-1-5-21-719106045-3766251393-3909931865-1105
    ...<snip>...

Configuring PAM
---------------

Now we will change various rules in PAM to allow Active Directory users
to use the system for things like login and sudo access. When changing
the rules, note the order of these items and whether they are marked as
required or sufficient is critical to things working as expected. You
should not deviate from these rules unless you know how to write PAM
rules.

In case of logins, PAM should first ask for AD accounts, and for local
accounts if no matching AD account was found. Therefore, we add entries
to include pam_winbindd.so into the authentication process. Furthermore,
we include pam_mkhomedir.so. If an AD user logs in, /home/example/user
will be created automatically.

    /etc/pam.d/login

    #%PAM-1.0
    auth            required        pam_securetty.so
    auth            requisite       pam_nologin.so
    auth            sufficient      pam_unix.so nullok
    auth            required        pam_winbind.so use_first_pass use_authtok
    auth            required        pam_tally.so onerr=succeed file=/var/log/faillog
    # use this to lockout accounts for 10 minutes after 3 failed attempts
    #auth           required        pam_tally.so deny=2 unlock_time=600 onerr=succeed file=/var/log/faillog
    account         required        pam_access.so
    account         required        pam_time.so
    account         sufficient      pam_unix.so
    account         sufficient      pam_winbind.so use_first_pass use_authtok
    password        required        pam_pwcheck.so
    password        sufficient      pam_unix.so
    password        sufficient      pam_winbind.so use_first_pass use_authtok
    #password       required        pam_cracklib.so difok=2 minlen=8 dcredit=2 ocredit=2 retry=3
    #password       required        pam_unix.so sha512 shadow use_authtok
    session         required        pam_mkhomedir.so skel=/etc/skel/ umask=0022
    session         sufficient      pam_unix.so
    session         sufficient      pam_winbind.so use_first_pass use_authtok
    session         required        pam_env.so
    session         required        pam_motd.so
    session         required        pam_limits.so
    session         optional        pam_mail.so dir=/var/spool/mail standard
    session         optional        pam_lastlog.so
    session         optional        pam_loginuid.so
    -session        optional        pam_ck_connector.so nox11
    -session        optional        pam_systemd.so

> Testing login

Now, start a new console session (or ssh) and try to login using the AD
credentials. The domain name is optional, as this was set in the Winbind
configuration as 'default realm'. Please note that in the case of ssh,
you will need to modify the /etc/ssh/sshd_config file to allow kerberos
authentication (KerberosAuthentication yes).

    test.user
    EXAMPLE+test.user

Both should work. You should notice that /home/example/test.user will be
automatically created. Again, if you are using ssh, you need to add the
pam_mkhomedir.so line mentioned above to the /etc/pam.d/sshd file. Log
into another session using an linux account. Check that you still be
able to log in as root - but keep in mind to be logged in as root in at
least one session!

> /etc/pam.d/gdm

TODO

> Sudo

Another thing to get working is 'sudo'. First add the 'test.user' to
/etc/sudoers. You can tweak this later, for now lets test things are
working:

    /etc/sudoers

If you were to attempt a sudo now, it would fail.

Adjust the sudo file to mark pam_unix as sufficient and add the line for
winbind as shown:

    /etc/pam.d/sudo

    #%PAM-1.0
    auth            sufficient      pam_unix.so
    auth            required        pam_winbind.so use_first_pass use_authtok
    auth            required        pam_nologin.so

Configuring Shares
------------------

Earlier we skipped configuration of the shares. Now that things are
working, go back to /etc/smb.conf, and add the exports for the host that
you want available on the windows network.

    /etc/smb.conf

    [MyShare]
      comment = Example Share
      path = /srv/exports/myshare
      read only = no
      browseable = yes
      valid users = @NETWORK+"Domain Admins" NETWORK+test.user

In the above example, the keywork NETWORK is to be used. Do not
mistakenly substitute this with your domain name. For adding groups,
prepend the '@' symbol to the group. Note that Domain Admins is
encapsulated in quotes so Samba correctly parses it when reading the
configuration file.

See also
--------

-   Wikipedia: Active Directory
-   Wikipedia: Samba
-   Wikipedia: Kerberos
-   Samba: Documentation
-   Samba Wiki: Samba & Active Directory
-   Samba Man Page: smb.conf

> Commercial Solutions

-   Centrify
-   Likewise

Retrieved from
"https://wiki.archlinux.org/index.php?title=Active_Directory_Integration&oldid=249934"

Category:

-   Networking
