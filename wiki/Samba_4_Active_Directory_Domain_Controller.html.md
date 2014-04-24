Samba 4 Active Directory Domain Controller
==========================================

Related articles

-   Samba
-   Samba/Tips and tricks
-   Samba/Troubleshooting
-   Samba/Advanced file sharing with KDE4
-   Samba Domain Controller
-   Active Directory Integration
-   OpenChange Server

This article explains how to setup a new Active Directory Domain
Controller. It is assumed that all configuration files are in their
unmodified, post-installation state. This article was written and tested
on a fresh installation, with no modifications other than setting up a
staic IPv4 network connection, assigning a hostname, and adding openssh
and vim (which should have no effect on the Samba configuration).
Finally, most of the commands below will require elevated privileges.
Despite conventional wisdom, it may be easier to run these short few
commands from a root session as opposed to obtaining rights on an as
needed basis.

Contents
--------

-   1 Installation
-   2 Provisioning
    -   2.1 Argument Explanations
    -   2.2 Interactive Provision Explanations
-   3 Configuring Daemons
    -   3.1 NTPD
    -   3.2 BIND
    -   3.3 Kerberos Client Utilities
    -   3.4 Samba
-   4 Testing the Installation
    -   4.1 DNS
    -   4.2 NT Authentication
    -   4.3 Kerberos
-   5 Additional Configuration
    -   5.1 DNS
    -   5.2 DHCP
-   6 What to do Next

Installation
------------

A fully functional samba 4 DC requires several programs beyond those
included with the Samba distribution. Install all needed packages with
the following command:

    pacman -S dnsutils krb5 ntp openldap samba

Additionally, Samba contains its own fully functional DNS server, but
many admins prefer to use the ISC BIND package. If you need to maintain
DNS zones for external domains, you are strongly encouraged to use BIND.
If you would like to use BIND, issue the following command:

    pacman -S bind

If you need to share printers, you will also need CUPS:

    pacman -S cups

Provisioning
------------

The first step to creating an Active Directory domain is provisioning.
If this is the first domain controller in a new domain (as this guide
assumes), this involves setting up the internal LDAP, Kerberos, and DNS
servers and performing all of the basic configuration needed for the
directory. If you have set up a directory server before, you are
undoubtedly aware of the potential for errors in making these individual
components work together as a single unit. The difficulty in doing so is
the very reason that the Samba developers chose not to use the MIT or
Heimdal Kerberos server or OpenLDAP server, instead opting for internal
versions of these programs. The server packages above were installed
only for the client utilities. Provisioning is quite a bit easier with
Samba 4. Just issue the following command:

    samba-tool domain provision --use-rfc2307 --interactive --use-xattrs=yes

> Argument Explanations

--use-rfc2307 
    this argument adds POSIX attributes (UID/GID) to the AD Schema. This
    will be necessary if you intend to authenticate Linux, BSD, or OS X
    clients (including the local machine) in addition to Microsoft
    Windows.

--use-xattrs=yes 
    this argument enables the use of unix extended attributes (ACLs) for
    files hosted on this server. If you intend not have file shares on
    the domain controller, you can omit this switch (but this is not
    recommended). You should also ensure that any filesystems that will
    host Samba shares are mounted with support for ACLs.

--interactive 
    this parameter forces the provision script to run interactively.
    Alternately, you can review the help for the provision step by
    running samba-tool domain provision --help.

> Interactive Provision Explanations

Realm 
    INTERNAL.DOMAIN.COM - This should be the same as the DNS domain in
    all caps. It is common to use an internal-only sub-domain to
    separate your internal domain from your external DNS domains, but it
    is not required.

Domain 
    INTERNAL - This will be the NetBIOS domain name, usually the
    leftmost DNS sub-domain but can be anything you like. For example,
    the name INTERNAL would not be very descriptive. Perhaps company
    name or initials would be appropriate. This should be entered in all
    caps, and should have a 15 character maximum length for
    compatibility with older clients.

Server Role 
    dc - This article assumes that your are installing the first DC in a
    new domain. If you select anything different, the rest of this
    article will likely be useless to you.

DNS Backend 
    BIND9_DLZ or SAMBA_INTERNAL - This is down to personal preference of
    the server admin. Again, if you are hosting DNS for external
    domains, you are strongly encouraged to use the BIND9_DLZ backend so
    that flat zone files can continue to be used and existing transfer
    rules can co-exist with the internal DNS server. If unsure, use the
    BIND9_DLZ backend.

Administrator password 
    xxxxxxxx - You must select a strong password for the administrator
    account. The minimum requirements are one upper case letter, one
    number, and at least eight characters. If you attempt to use a
    password that does not meet the complexity requirements,
    provisioning will fail.

Configuring Daemons
-------------------

> NTPD

Use the following commands to create a suitable NTP configuration for
your network time server. See Ntpd for explanations of, and additional
configuration options:

    mv /etc/ntp.conf{,.default}
    cat > /etc/ntp.conf << "EOF"
    # Begin /etc/ntp.conf

    # Associate to the public NTP pool servers
    server 0.pool.ntp.org
    server 1.pool.ntp.org
    server 2.pool.ntp.org

    # Location of drift file
    driftfile /var/lib/ntp/ntp.drift

    # Location of the log file
    logfile /var/log/ntp

    # Location of the update directory
    ntpsigndsocket /var/lib/samba/ntp_signd/

    # Restrictions
    restrict default kod nomodify notrap nopeer mssntp
    restrict 127.0.0.1
    restrict 0.pool.ntp.org mask 255.255.255.255 nomodify notrap nopeer noquery
    restrict 1.pool.ntp.org mask 255.255.255.255 nomodify notrap nopeer noquery
    restrict 2.pool.ntp.org mask 255.255.255.255 nomodify notrap nopeer noquery

    # End /etc/ntp.conf
    EOF
    install -d /var/lib/samba/ntp_signd
    chown root:ntp /var/lib/samba/ntp_signd
    chmod 0750 /var/lib/samba/ntp_signd
    systemctl enable ntpd.service
    systemctl start ntpd

> BIND

If you elected to use the BIND9_DLZ DNS backend, execute the following
commands to create a suitable BIND configuration. See Bind for
explanations of, and additional configuration options. Be sure to
replace the x characters with suitable values:

    mv /etc/named.conf{,.default}
    cat > /etc/named.conf << "EOF"
    //Begin /etc/named.conf

    // Global options
    options {
        auth-nxdomain yes;
        datasize default;
        directory "/var/named";
        empty-zones-enable no;
        pid-file "/run/named/named.pid";
        tkey-gssapi-keytab "/var/lib/samba/private/dns.keytab";
        forwarders { xxx.xxx.xxx.xxx; xxx.xxx.xxx.xxx; };
    //  Uncomment the next line to enable IPv6
    //    listen-on-v6 { any; };
        notify no;
    //  Add any subnets or hosts you want to allow to use this DNS server (use "; " delimiter)
        allow-query     { xxx.xxx.xxx.xxx/xx; };
    //  Add any subnets or hosts you want to allow to use recursive queries
        allow-recursion { xxx.xxx.xxx.xxx/xx; };
    //  Add any subnets or hosts you want to allow dynamic updates from
        allow-update    { xxx.xxx.xxx.xxx/xx; };
        version none;
        hostname none;
        server-id none;
    };

    //Root servers (required zone for recursive queries)
    zone "." IN {
        type hint;
        file "root.hint";
    };

    //Required localhost forward-/reverse zones
    zone "localhost" IN {
        type master;
        file "localhost.zone";
        allow-transfer { any; };
    };
    zone "0.0.127.in-addr.arpa" IN {
        type master;
        file "127.0.0.zone";
        allow-transfer { any; };
    };

    //Required zone for AD
    dlz "AD DNS Zone" {
        database "dlopen /usr/lib/samba/bind9/dlz_bind9_9.so";
    };

    //Log settings
    logging {
       channel xfer-log {
           file "/var/log/named.log";
           print-category yes;
           print-severity yes;
           print-time yes;
           severity info;
        };
        category xfer-in { xfer-log; };
        category xfer-out { xfer-log; };
        category notify { xfer-log; };
    };

    //End /etc/named.conf
    EOF
    chgrp named /var/lib/samba/private/dns.keytab
    chmod g+r /var/lib/samba/private/dns.keytab
    systemctl enable named.service
    systemctl start named

Good values for forwarders are your ISP's DNS servers. Google (8.8.8.8
and 8.8.4.4) and OpenDNS (208.67.222.222 and 208.67.220.220) provide
suitable public DNS servers free of charge. Appropriate values for
subnets are specific to your network.

  
 You will need to begin using the local DNS server now. Execute the
following commands substituting your server's IP address(es), and
internal.domain.tld with your internal domain:

    cat >> /etc/resolvconf.conf << "EOF"
    search_domains=internal.domain.tld
    name_servers=xxx.xxx.xxx.xxx 
    EOF

And regenerate new conf file

    resolvconf -u

> Kerberos Client Utilities

The provisioning step above created a perfectly valid krb5.conf file for
use with a Samba 4 DC. Install it with the following commands:

    mv /etc/krb5.conf{,.default}
    cp /var/lib/samba/private/krb5.conf /etc

> Samba

Finally, enable and start Samba. The NTP update directory created
earlier must be removed or samba will fail to run. Execute the following
commands to start the Samba services:

    rm -rf /var/lib/samba/ntp_signd
    systemctl enable samba.service
    systemctl start samba

You will also need to fix permissions on the newly created NTP update
directory and restart NTPD:

    chgrp ntp /var/lib/samba/ntp_signd
    systemctl restart ntpd

Finally, if you intend to use the LDB utilities, you will need to set
the LDB_MODULES_PATH

    echo "export LDB_MODULES_PATH=\"\${LDB_MODULES_PATH}:/usr/lib/samba/ldb\"" > /etc/profile.d/sambaldb.sh
    chmod 0755 /etc/profile.d/sambaldb.sh

Testing the Installation
------------------------

> DNS

First, verify that DNS is working as expected. Execute the following
commands substituting appropriate values for internal.domain.com and
server:

    host -t SRV _ldap._tcp.internal.domain.com.
    host -t SRV _kerberos._udp.internal.domain.com.
    host -t A server.internal.domain.com.

You should receive output similar to the following:

    _ldap._tcp.internal.domain.com has SRV record 0 100 389 server.internal.domain.com.
    _kerberos._udp.internal.domain.com has SRV record 0 100 88 server.internal.domain.com.
    server.internal.domain.com has address xxx.xxx.xxx.xxx

> NT Authentication

Next, verify that password authentication is working as expected:

    smbclient //localhost/netlogon -U Administrator -c 'ls'

You will be prompted for a password (the one you selected earlier), and
will get a directory listing like the following:

    Domain=[INTERNAL] OS=[Unix] Server=[Samba 4.1.2]
      .                                   D        0  Wed Nov 27 23:59:07 2013
      ..                                  D        0  Wed Nov 27 23:59:12 2013

    		50332 blocks of size 2097152. 47185 blocks available

> Kerberos

Now verify that the KDC is working as expected. Be sure to replace
INTERNAL.DOMAIN.COM and use upper case letters:

    kinit administrator@INTERNAL.DOMAIN.COM

You should be prompted for a password and get output similar to the
following:

    Warning: Your password will expire in 41 days on Wed 08 Jan 2014 11:59:11 PM CST

Verify that you actually got a ticket:

    klist

You should get output similar to below:

    Ticket cache: FILE:/tmp/krb5cc_0
    Default principal: administrator@INTERNAL.DOMAIN.COM

    Valid starting       Expires              Service principal
    11/28/2013 00:22:17  11/28/2013 10:22:17  krbtgt/INTERNAL.DOMAIN.COM@INTERNAL.DOMAIN.COM
    	renew until 11/29/2013 00:22:14

As a final test, use smbclient with your recently acquired ticket.
Replace server with the correct server name:

    smbclient //server/netlogon -k -c 'ls'

The output should be the same as when testing password authentication
above.

Additional Configuration
------------------------

> DNS

You will also need to create a reverse lookup zone for each subnet in
your environment in DNS. It is important that this is kept in Samba's
DNS as opposed to BIND to allow for dynamic updates by cleints. For each
subnet, create a reverse lookup zone with the following commands.
Replace server.internal.domain.tld and xxx.xxx.xxx with appropriate
values. For xxx.xxx.xxx, use the first three octets of the subnet in
reverse order (for example: 192.168.0.0/24 becomes 0.168.192):

    samba-tool dns zonecreate server.internal.domain.tld xxx.xxx.xxx.in-addr.arpa

Now, add a record for you server (if your server is multi-homed, add for
each subnet) again substituting appropriate values as above. zzz will be
replaced by the fourth octet of the IP for the server:

    samba-tool dns add server.internal.domain.tld' xxx.xxx.xxx.in-addr.arpa zzz PTR server.internal.domain.tld'

Finally, restart Bind and test the lookup. Replace xxx.xxx.xxx.xxx with
the IP of your server:

    systemctl restart named
    host -t PTR xxx.xxx.xxx.xxx

You should get output similar to the following:

    xxx.xxx.xxx.xxx.in-addr.arpa domain name pointer server.internal.domain.tld.

> DHCP

It should be noted that using this method will affect functionality of
windows clients, as they will still attempt to update DNS on their own
and will be denied permission to do so as the record will be owned by
the dhcp user. You should create a GPO to overcome this, but
unfortunately, Samba 4 does not yet have a command line utility to
modify GPOs, so you'll need a Windows PC with the RSAT tools installed.
Simply create a dedicated GPO with the Group Policy Editor, apply only
to OUs that contain workstations (so that servers can still update using
'ipconfig /registerdns') and configure the following settings:

    Computer Configuration
      Policies
        Administrative Templates
          Network
            DNS Client
              Dynamic Update = Disabled
              Register PTR Records = Disabled

Install ISC DHCPd:

    pacman -S dhcpd

Create an unprivileged user in AD for performing the updates. When
prompted for password, use a secure password. 63 random, mixed case,
alpha-numeric characters is sufficient. Optionally samba-tool also takes
a random argument:

    samba-tool user create dhcp --description="Unprivileged user for DNS updates via DHCP server"

Give the user privelges to administer DNS:

    samba-tool group addmembers DnsAdmins dhcp

Export the users credentials to a private keytab:

    samba-tool domain exportkeytab --principal=dhcp@INTERNAL.DOMAIN.TLD dhcpd.keytab
    install -vdm 755 /etc/dhcpd
    mv dhcpd.keytab /etc/dhcpd
    chown root:root /etc/dhdpd.keytab
    chmod 400 /etc/dhcpd/dhcpd.keytab

Now that the user is created, add this script to perform the updates:

    cat > /usr/sbin/samba-dnsupdate.sh << "EOF"
    #!/bin/bash
    # Begin samba-dnsupdate.sh
    # Author: DJ Lucas <dj_AT_linuxfromscratch_DOT_org>
    # kerberos_creds() courtesy of Sergey Urushkin
    # http://www.kuron-germany.de/michael/blog/wp-content/uploads/2012/03/dhcpdns-sergey2.txt

    # DHCP server should be authoritative for its own records, sleep for 5 seconds
    # to allow unconfigured Windows hosts to create their own DNS records
    # In order to use this script you should disable dynamic updates by hosts that
    # will receive addresses from this DHCP server. Instructions are found here:
    # https://wiki.archlinux.org/index.php/Samba_4_Active_Directory_Domain_Controller#DHCP
    sleep 5

    checkvalues()
    {
            [ -z "${2}" ] && echo "Error: argument '${1}' requires a parameter." && exit 1

            case ${2} in

                    -*)
                            echo "Error: Invalid parameter '${2}' passed to ${1}."
                            exit 1
                    ;;

                    *)
                            return 0
                    ;;
            esac
    }

    showhelp()
    {
    echo -e "\n"`basename ${0}` "uses samba-tool to update DNS records in Samba 4's DNS"
    echo "server when using INTERNAL DNS or BIND9 DLZ plugin."
    echo ""
    echo "    Command line options (and variables):"
    echo ""
    echo "      -a | --action      Action for this script to perform"
    echo "                         ACTION={add|delete}"
    echo "      -c | --krb5cc      Path of the krb5 credential cache (optional)"
    echo "                         Default: KRB5CC=/run/dhcpd.krb5cc"
    echo "      -d | --domain      The DNS domain/zone to be updated"
    echo "                         DOMAIN={domain.tld}"
    echo "      -h | --help        Show this help message and exit"
    echo "      -H | --hostname    Hostname of the record to be updated"
    echo "                         HNAME={hostname}"
    echo "      -i | --ip          IP address of the host to be updated"
    echo "                         IP={0.0.0.0}"
    echo "      -k | --keytab      Krb5 keytab to be used for authorization (optional)"
    echo "                         Default: KEYTAB=/etc/dhcp/dhcpd.keytab"
    echo "      -m | --mitkrb5     Use MIT krb5 client utilities"
    echo "                         MITKRB5={YES|NO}"
    echo "      -n | --nameserver  DNS server to be updated (must use FQDN, not IP)"
    echo "                         NAMESERVER={server.internal.domain.tld}"
    echo "      -p | --principal   Principal used for DNS updates"
    echo "                         PRINCIPAL={user@domain.tld}"
    echo "      -r | --realm       Authentication realm"
    echo "                         REALM={DOMAIN.TLD}"
    echo "      -z | --zone        Then name of the zone to be updated in AD.
    echo "                         ZONE={zonename}
    echo ""
    echo "Example: $(basename $0) -d domain.tld -i 192.168.0.x -n 192.168.0.x \\"
    echo "             -r DOMAIN.TLD -p user@domain.tld -H HOSTNAME -m"
    echo ""
    }

    # Process arguments
    [ -z "$1" ] && showhelp && exit 1
    while [ -n "$1" ]; do
            case $1 in

                    -a | --action)
                            checkvalues ${1} ${2}
                            ACTION=${2}
                            shift 2
                    ;;

                    -c | --krb5cc)
                            checkvalues ${1} ${2}
                            KRB5CC=${2}
                            shift 2
                    ;;

                    -d | --domain)
                            checkvalues ${1} ${2}
                            DOMAIN=${2}
                            shift 2
                    ;;

                    -h | --help)
                            showhelp
                            exit 0
                    ;;

                    -H | --hostname)
                            checkvalues ${1} ${2}
                            HNAME=${2%%.*}
                            shift 2
                    ;;

                    -i | --ip)
                            checkvalues ${1} ${2}
                            IP=${2}
                            shift 2
                    ;;

                    -k | --keytab)
                            checkvalues ${1} ${2}
                            KEYTAB=${2}
                            shift 2
                    ;;

                    -m | --mitkrb5)
                            KRB5MIT=YES
                            shift 1
                    ;;

                    -n | --nameserver)
                            checkvalues ${1} ${2}
                            NAMESERVER=${2}
                            shift 2
                    ;;

                    -p | --principal)
                            checkvalues ${1} ${2}
                            PRINCIPAL=${2}
                            shift 2
                    ;;

                    -r | --realm)
                            checkvalues ${1} ${2}
                            REALM=${2}
                            shift 2
                    ;;

                    -z | --zone)
                            checkvalues ${1} ${2}
                            ZONE=${2}
                            shift 2
                    ;;

                    *)
                            echo "Error!!! Unknown command line opion!"
                            echo "Try" `basename $0` "--help."
                            exit 1
                    ;;
            esac
    done

    # Sanity checking
    [ -z "$ACTION" ] && echo "Error: action not set." && exit 2
    case "$ACTION" in
            add | Add | ADD)
                    ACTION=ADD
            ;;
            del | delete | Delete | DEL | DELETE)
                    ACTION=DEL
            ;;
            *)
                    echo "Error: invalid action \"$ACTION\"." && exit 3
            ;;
    esac
    [ -z "$KRB5CC" ] && KRB5CC=/run/dhcpd.krb5cc
    [ -z "$DOMAIN" ] && echo "Error: invalid domain." && exit 4
    [ -z "$HNAME" ] && [ "$ACTION" == "ADD" ] && \
         echo "Error: hostname not set." && exit 5
    [ -z "$IP" ] && echo "Error: IP address not set." && exit 6
    [ -z "$KEYTAB" ] && KEYTAB=/etc/dhcp/dhcpd.keytab
    [ -z "$NAMESERVER" ] && echo "Error: nameservers not set." && exit 7
    [ -z "$PRINCIPAL" ] && echo "Error: principal not set." && exit 8
    [ -z "$REALM" ] && echo "Error: realm not set." && exit 9
    [ -z "$ZONE" ] && echo "Error: zone not set." && exit 10

    # Disassemble IP for reverse lookups
    OCT1=$(echo $IP | cut -d . -f 1)
    OCT2=$(echo $IP | cut -d . -f 2)
    OCT3=$(echo $IP | cut -d . -f 3)
    OCT4=$(echo $IP | cut -d . -f 4)
    RZONE="$OCT3.$OCT2.$OCT1.in-addr.arpa"

    kerberos_creds() {
    export KRB5_KTNAME="$KEYTAB"
    export KRB5CCNAME="$KRB5CC"

    if [ "$KRB5MIT" = "YES" ]; then
        KLISTARG="-s"
    else
        KLISTARG="-t"
    fi

    klist $KLISTARG || kinit -k -t "$KEYTAB" -c "$KRB5CC" "$PRINCIPAL" || { logger -s -p daemon.error -t dhcpd kinit for dynamic DNS failed; exit 11; }
    }


    add_host(){
        logger -s -p daemon.info -t dhcpd Adding A record for host $HNAME with IP $IP to zone $ZONE on server $NAMESERVER
        samba-tool dns add $NAMESERVER $ZONE $HNAME A $IP -k yes
    }


    delete_host(){
        logger -s -p daemon.info -t dhcpd Removing A record for host $HNAME with IP $IP from zone $ZONE on server $NAMESERVER
        samba-tool dns delete $NAMESERVER $ZONE $HNAME A $IP -k yes
    }


    update_host(){
        CURIP=$(host -t A $HNAME | cut -d " " -f 4)
        logger -s -p daemon.info -t dhcpd Removing A record for host $HNAME with IP $CURIP from zone $ZONE on server $NAMESERVER
        samba-tool dns delete $NAMESERVER $ZONE $HNAME A $CURIP -k yes
        add_host
    }


    add_ptr(){
        logger -s -p daemon.info -t dhcpd Adding PTR record $OCT4 with hostname $HNAME to zone $RZONE on server $NAMESERVER
        samba-tool dns add $NAMESERVER $RZONE $OCT4 PTR $HNAME.$DOMAIN -k yes
    }


    delete_ptr(){
        logger -s -p daemon.info -t dhcpd Removing PTR record $OCT4 with hostname $HNAME from zone $RZONE on server $NAMESERVER
        samba-tool dns delete $NAMESERVER $RZONE $OCT4 PTR $HNAME.$DOMAIN -k yes
    }


    update_ptr(){
        CURHNAME=$(host -t PTR $OCT4 | cut -d " " -f 5)
        logger -s -p daemon.info -t dhcpd Removing PTR record $OCT4 with hostname $CURHNAME from zone $RZONE on server $NAMESERVER
        samba-tool dns delete $NAMESERVER $RZONE $OCT4 PTR $CURHNAME -k yes
        add_ptr
    }


    case "$ACTION" in
        ADD)
            kerberos_creds
            host -t A $HNAME.$DOMAIN > /dev/null
            if [ "${?}" == 0 ]; then
                update_host
            else
                add_host
            fi

            host -t PTR $IP > /dev/null
            if [ "${?}" == 0 ]; then
                update_ptr
            else
                add_ptr
            fi
        ;;

        DEL)
            kerberos_creds
            host -t A $HNAME.$DOMAIN > /dev/null
            if [ "${?}" == 0 ]; then
                delete_host
            fi

            host -t PTR $IP > /dev/null
            if [ "${?}" == 0 ]; then
                delete_ptr
            fi
        ;;

        *)
            echo "Error: Invalid action '$ACTION'!" && exit 12
        ;;

    esac

    # End samba-dnsupdate.sh
    EOF
    chmod 750 /usr/sbin/samba-dnsupdate.sh

The dhcpd service will need to use a fast exiting wrapper script to
avoid locking issues and delays. Create the script with the following
commands (substituting correct values for server, internal.domain.tld,
and INTERNAL.DOMAIN.TLD):

    cat > /etc/dhcpd/update.sh << "EOF"
    #!/bin/bash
    # Begin /etc/dhcpd/update.sh

    # Variables
    KRB5CC="/run/dhcpd4.krb5cc"
    KEYTAB="/etc/dhcpd/dhcpd.keytab"
    DOMAIN="internal.domain.tld"
    REALM="INTERNAL.DOMAIN.TLD"
    PRINCIPAL="dhcp@${REALM}"
    NAMESERVER="server.${DOMAIN}"
    ZONE="${DOMAIN}"

    ACTION=$1
    IP=$2
    HNAME=$3

    export KRB5CC KEYTAB DOMAIN REALM PRINCIPAL NAMESERVER ZONE ACTION IP HNAME

    /usr/sbin/samba-dnsupdate.sh -m &

    # End /etc/dhcpd/update.sh
    EOF
    chmod 750 /etc/dhcpd/update.sh

Configure the dhcpd server following the dhcpd article and add the
following to all subnet declarations in /etc/dhcpd.conf that provide
DHCP service:

      on commit {
        set ClientIP = binary-to-ascii(10, 8, ".", leased-address);
        set ClientName = pick-first-value(option host-name, host-decl-name);
        execute("/etc/dhcpd/update.sh", "add", ClientIP, ClientName);
      }

      on release {
        set ClientIP = binary-to-ascii(10, 8, ".", leased-address);
        set ClientName = pick-first-value(option host-name, host-decl-name);
        execute("/etc/dhcpd/update.sh", "delete", ClientIP, ClientName);
      }

        on expiry {
        set ClientIP = binary-to-ascii(10, 8, ".", leased-address);
        set ClientName = pick-first-value(option host-name, host-decl-name);
        execute("/etc/dhcpd/update.sh", "delete", ClientIP, ClientName);

Here is a complete example /etc/dhcpd.conf for reference:

    # Begin /etc/dhcpd.conf

    # No DHCP service in the DMZ.
    subnet 192.168.2.0 netmask 255.255.255.0 {
    }

    # Internal subnet
    subnet 192.168.1.0 netmask 255.255.255.0 {
      range 192.168.1.100 192.168.1.199;
      option subnet-mask 255.255.255.0;
      option routers 192.168.1.254;
      option domain-name "internal.domain.tld";
      option domain-name-servers 192.168.1.1;
      option broadcast-address 192.168.1.255;
      default-lease-time 28800;
      max-lease-time 43200;
      authoritative;

      on commit {
        set ClientIP = binary-to-ascii(10, 8, ".", leased-address);
        set ClientName = pick-first-value(option host-name, host-decl-name);
        execute("/etc/dhcpd/update.sh", "add", ClientIP, ClientName);
      }

      on release {
        set ClientIP = binary-to-ascii(10, 8, ".", leased-address);
        set ClientName = pick-first-value(option host-name, host-decl-name);
        execute("/etc/dhcpd/update.sh", "delete", ClientIP, ClientName);
      }

        on expiry {
        set ClientIP = binary-to-ascii(10, 8, ".", leased-address);
        set ClientName = pick-first-value(option host-name, host-decl-name);
        execute("/etc/dhcpd/update.sh", "delete", ClientIP, ClientName);
      }
    }

    # End /etc/dhcpd.conf

Finally, start (or restart) the dhcpd4 service:

    systemctl restart dhcpd4

What to do Next
---------------

If you have made it this far without any unexpected output from the
tests above, you are good to go. Congrats!

Related topics (need additional authors):

OpenChange Server - The OpenChange project provides a Microsoft Exchange
compatible mail server using only open source software.

Place holder: Samba4_Client_Configuration (including this DC) - Most of
the LinuxPAM info in this article can be reused or modified for this
purpose.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Samba_4_Active_Directory_Domain_Controller&oldid=305795"

Category:

-   Networking

-   This page was last modified on 20 March 2014, at 05:44.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
