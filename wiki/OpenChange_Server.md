OpenChange Server
=================

Related articles

-   Samba
-   Samba/Tips and tricks
-   Samba/Troubleshooting
-   Samba/Advanced file sharing with KDE4
-   Samba Domain Controller
-   Active Directory Integration
-   Samba 4 Active Directory Domain Controller

This article explains how to setup a mail server using OpenChange server
following on from the Samba 4 Active Directory Domain Controller
article. Postfix is used for the MTA, Dovecot for the IMAP/POP server,
and SOGo for the backend with all users stored in Samba's Active
Directory (normal Exchange attributes are used througout).

Contents
--------

-   1 Installation
    -   1.1 Prerequisites
    -   1.2 Installation
        -   1.2.1 SOGo installation
-   2 Configuration
    -   2.1 Initial OpenChange configuration
        -   2.1.1 Samba
        -   2.1.2 OpenChange
    -   2.2 Initial SOGo configuration
        -   2.2.1 Apache httpd
        -   2.2.2 PostGRE SQL
        -   2.2.3 SOGo
    -   2.3 Initial Postfix configuration
        -   2.3.1 Basic configuratoin
        -   2.3.2 Virtual user configuration
        -   2.3.3 LDAP configuration
    -   2.4 Dovecot configuration
        -   2.4.1 Basic configuration
        -   2.4.2 LDAP configuration
        -   2.4.3 Testing Dovecot authentication
        -   2.4.4 LMTP configuration
        -   2.4.5 TLS configuration
    -   2.5 Postfix final configuration
        -   2.5.1 SASL configuration
        -   2.5.2 LMTP configuration
        -   2.5.3 TLS configuration
        -   2.5.4 Testing the Postfix SASL configuration
    -   2.6 SOGo final configuration
        -   2.6.1 PostgreSQL
        -   2.6.2 SOGo
        -   2.6.3 Apache
    -   2.7 OpenChange final configuration
        -   2.7.1 OCSManager
        -   2.7.2 Adding OpenChange MAPIProxy and OCSManger to Apache

Installation
------------

> Prerequisites

Install prerequisites from the official repositories: apache base-devel
ccache curl cyrus-sasl docbook-xml docbook-xsl dovecot libical
libmemcached memcached mod_wsgi pigeonhole postfix postgresql
python2-beaker python2-decorator python2-formencode python2-mako
python2-nose python2-paste python2-pycurl python2-pygments
python2-setuptools python2-simplejson python2-tempita wget.

And from the AUR: python-webhelpers paste-deploy paste-script repoze-lru
routes webob weberror webtest pylons.

> Installation

Install openchange-server and sope from the AUR.

SOGo installation

Install sogo from the AUR using this custom PKGBUILD:

    # Maintainer: Steven Hiscocks <steven [at] hiscocks [dot] me [dot] uk>
    # Contributor:  Andre Wayand <aur-sogo@awayand.sleepmail.com>
    # Contributor: DJ Lucas <dj [at] linuxfromscratch [dot] org>
    pkgname=('sogo' 'sogo-openchange')
    pkgver=2.2.1
    pkgrel=1
    pkgdesc="groupware server built around OpenGroupware.org (OGo) and the SOPE application server"
    arch=('i686' 'x86_64')
    url="http://www.sogo.nu/"
    license=('GPL')
    makedepends=('gcc-objc' 'sope=2.2.1' 'gnustep-base' 'libmemcached' 'memcached')
    source=(
      http://www.sogo.nu/files/downloads/SOGo/Sources/SOGo-${pkgver}.tar.gz
      sogo_configure.patch
      UI_MailPartViewers_GNUmakefile.patch
      sogo.service
      sogo.tmpfiles
    )
    md5sums=('14a966f5f75688c4a869ac2fb735076d'
             '5fbd694ee94639697c5f635013d89327'
             '55f74eb6978ae43eac4279580d350dc5'
             'bb173559e42739d1a7c9d88cbc5c262e'
             '04dc24e79e11b62933843cd1f9f60792')

    prepare() {
      cd "$srcdir/SOGo-${pkgver}"
      patch configure ../sogo_configure.patch
      patch -p1 < ../UI_MailPartViewers_GNUmakefile.patch
    }

    build() {
      cd "$srcdir/SOGo-${pkgver}"
      ./configure --prefix=$(gnustep-config --variable=GNUSTEP_SYSTEM_ROOT) --disable-debug
      make
      cd "${srcdir}/SOGo-${pkgver}/OpenChange"
      #Set python interpreter to python2
      sed 's@/usr/bin/python@/usr/bin/python2@' \
          -i $(grep -R -e "/usr/bin/python" | \
              grep -v "/usr/bin/python2" | \
              cut -d ":" -f 1)
      sed 's@22\.6@2.7@' -i GNUmakefile
      #Remove -Werror
      sed 's@-Werror @@' -i GNUmakefile
      #Fix SoObjects include directory
      sed 's@-I../S@-I.. -I../S@' -i GNUmakefile
      make
    }

    package_sogo() {
      pkgdesc="groupware server built around OpenGroupware.org (OGo) and the SOPE application server"
      depends=('sope=2.2.1' 'gnustep-base' 'libmemcached' 'memcached')
      backup=(etc/sogo/sogo.conf etc/httpd/conf/extra/SOGo.conf)
      install=sogo.install
      options=('!strip')
      optdepends=(
        'postgresql: run database server for sogo locally'
        'mariadb: run database server for sogo locally'
        'openldap: run directory server for sogo locally'
        'postfix: run smtp server for sogo locally'
        'dovecot: run imap server for sogo locally'
        'courier-imap: run imap server for sogo locally'
        'nginx: webserver to provide web interface locally'
        'apache: webserver to provide web interface locally'
        'lighttpd: webserver to provide web interface locally'
        'funambol: sync mobile devices with sogo contacts, events, tasks via SyncML'
      )
      cd "${srcdir}/SOGo-${pkgver}"
      make install DESTDIR="${pkgdir}" GNUSTEP_SYSTEM_ADMIN_TOOLS="/usr/bin"
      install -D -m 0644 "${srcdir}"/sogo.service \
                         "${pkgdir}"/usr/lib/systemd/system/sogo.service
      install -D -m 0644 "${srcdir}"/sogo.tmpfiles \
                         "${pkgdir}"/usr/lib/tmpfiles.d/sogo.conf
      install -D -m 0600 "${srcdir}"/SOGo-${pkgver}/Scripts/sogo.conf \
                         "${pkgdir}"/etc/sogo/sogo.conf
      install -d "${pkgdir}/var/log/sogo"
      install -D -m 0644 "${srcdir}/SOGo-${pkgver}/Apache/SOGo.conf" \
                         "${pkgdir}/etc/httpd/conf/extra/SOGo.conf"
    }

    package_sogo-openchange() {
      pkgdesc="SOGo connector for OpenChange Server"
      depends=('sogo' 'openchange-server')
      options=('!strip')

      cd "${srcdir}/SOGo-${pkgver}/OpenChange"
      make install DESTDIR="${pkgdir}" GNUSTEP_SYSTEM_ADMIN_TOOLS="/usr/bin"
    }

Note:The maintainer of the SOGo package is aware of the changes needed
for this to work and has expressed interest in making those changes, but
I need to do additional testing first to make sure we can do this in a
non-split package due to AUR restrictions. I am the hold-up on this, not
the current maintainer.

Configuration
-------------

> Initial OpenChange configuration

Samba

Make a backup copy of your existing samba configuration

    # cp /etc/samba/smb.conf{,.bak}

Append the following lines to "[global]" section of the
/etc/samba/smb.conf file:

    # Begin OpenChange Server Configuration
    dcerpc endpoint servers = +epmapper, +mapiproxy, +dnsserver
    dcerpc_mapiproxy:server = true
    dcerpc_mapiproxy:interfaces = exchange_emsmdb, exchange_nsp, exchange_ds_rfr
    # End OpenChange Server configuration</pre>

OpenChange

Next, provision the database and create the openchange DB.

    # openchange_provision
    # openchange_provision --openchangedb

Enable mail for the first user (we will use administrator):

    # openchange_newuser --create Administrator

Restart samba.

At this point, you should verify that all samba services are working as
expected. Use the tests in the Samba 4 Active Directory Domain
Controller guide in addition to testing RPC from a windows client
(simply connect with RSAT tools or soemthing similar). If all is well,
then continue. If not, restore the backup of the smb.conf until you can
track down the problem.

Finally, verify that you can edit user properties. For this, we'll use
ldbedit. Here you can directly modify user attributes. Relevant
attributes are mail and proxyAddresses. The proxyAddress attributie
labeled SMTP (as opposed to smtp) is the default mail address. If using
internal and exteranal domains, you will need to set SMTP to external
address as this will be the SMTP from address and envelope sender in
outgoing messages. Replace vim in the following command with your
preferred editor:

    # LDB_MODULES_PATH="/usr/lib/samba/ldb" ldbedit -e vim -H /var/lib/samba/private/sam.ldb '(samaccountname=administrator)'

If you first followed the Samba 4 Active Directory Domain Controller
article, you should see the following in the editor window (substituting
internal.domain.tld with your domain's values):

    ...
    mail: Administrator@internal.domain.tld
    ...
    proxyAddresses: =EX:/o=First Organization/ou=First Administrative Group/cn=Recipients/cn=Administrator
    proxyAddresses: smtp:postmaster@internal.domain.tld
    proxyAddresses: X400:c=US;a= ;p=First Organizati;o=Exchange;s=Administrator
    proxyAddresses: SMTP:Administrator@internal.domain.tld
    ...

It is important to change both the mail attribute (this is what we'll
use for group expansion), and the primary SMTP address. Change it to the
following (again, substitute appropriate values for
internal.domain.tld):

    ...
    mail: Administrator@domain.tld
    ...
    proxyAddresses: =EX:/o=First Organization/ou=First Administrative Group/cn=Recipients/cn=Administrator
    proxyAddresses: smtp:postmaster@internal.domain.tld
    proxyAddresses: smtp:postmaster@domain.tld
    proxyAddresses: X400:c=US;a= ;p=First Organizati;o=Exchange;s=Administrator
    proxyAddresses: smtp:Administrator@internal.domain.tld
    proxyAddresses: SMTP:administrator@domain.tld
    ...

> Initial SOGo configuration

Apache httpd

Add SOGo to the Apache configuration appending the following lines at
the ond of /etc/httpd/conf/httpd.conf:

    # Include SOGo configuration
    include conf/extra/SOGo.conf

    # mkdir /var/run/sogo
    # chown sogo:sogo /var/run/sogo

Then start and enable httpd service.

Open a browser and go to http://server.internal.domain.tld/SOGo/ but do
not try to login just yet, just verify that you can connect and get the
login screen.

PostGRE SQL

Initialize the default database and start PostgreSQl (be sure to replace
en_US.UTF-8 with the correct locale for your installation):

    # mkdir -p /var/lib/postgres/data
    # chown -R postgres:postgres /var/lib/postgres
    # su - postgres -c "initdb --locale en_US.UTF-8 -D '/var/lib/postgres/data'"

Then start and enable postgresql service.

Create the sogo user and the sogo DB for PostgreSQL (do not select a
strong password for the sogo user, just use "sogo" for simplicity. This
is temporary and we will change it later):

    # su - postgres
    createuser --no-superuser --no-createdb --no-createrole --encrypted --pwprompt sogo
    createdb -O sogo sogo

Edit the access configuration for the openchange DB:

    # cp /var/lib/postgres/data/pg_hba.conf{,.bak}
    # sed \
        's/D$/D\n\n#Configuration for OpenChange/' \
        -i /var/lib/postgres/data/pg_hba.conf
    # sed \
        's/ange$/ange\nhost\topenchange\topenchange\t127.0.0.1\/32\t\tmd5/' \
        -i /var/lib/postgres/data/pg_hba.conf
    # chown postgres:postgres /var/lib/postgres/data/pg_hba.conf{,.bak}

The restart the postgresql service.

SOGo

Configure SOGo defaults with the following commands (be certain to
replace REGION/LOCALITY, SAMBAADMINPASSWORD, and
dc=internal,dc=domain,dc=tld with approproptiate values):

    su - sogo -s /bin/bash
    defaults write sogod SOGoTimeZone "REGION/LOCALITY"
    defaults write sogod OCSFolderInfoURL "postgresql://sogo:sogo@localhost:5432/sogo/sogo_folder_info"
    defaults write sogod SOGoProfileURL "postgresql://sogo:sogo@localhost:5432/sogo/sogo_user_profile"
    defaults write sogod OCSSessionsFolderURL "postgresql://sogo:sogo@localhost:5432/sogo/sogo_sessions_folder"
    defaults write sogod OCSEMailAlarmsFolderURL "postgresql://sogo:sogo@localhost:5432/sogo/sogo_alarm_folder"
    defaults write sogod SOGoUserSources '({CNFieldName = displayName; IDFieldName = cn; UIDFieldName = sAMAccountName; IMAPHostFieldName =; baseDN = "cn=Users,dc=internal,dc=domain,dc=tld"; bindDN = "cn=Administrator,cn=Users,dc=internal,dc=domain,dc=tld"; bindPassword = "SAMBAADMINPASSWORD"; canAuthenticate = YES; displayName = "Shared Addresses"; hostname = "localhost"; id = public; isAddressBook = YES; port = 389;})'
    defaults write sogod WONoDetach NO
    defaults write sogod WOLogFile /var/log/sogo/sogo.log
    defaults write sogod WOPidFile /var/run/sogo/sogo.pid
    exit

Next, edit the sogo configuration file, /etc/httpd/conf/extra/SOGo.conf,
and comment out the following lines for testing (until your SSL certs
are in place and configuration is complete):

    ## adjust the following to your configuration
    #  RequestHeader set "x-webobjects-server-port" "443"
    #  RequestHeader set "x-webobjects-server-name" "yourhostname"
    #  RequestHeader set "x-webobjects-server-url" "https://yourhostname"

Give the root user the GNUStep configuration for the sogo user:

    # ln -s /etc/sogo/GNUStep /root/GNUStep

> Initial Postfix configuration

Basic configuratoin

Create a minimal Postfix configuration. Replace
server.internal.domain.tld with a valid internal FQDN):

    # postconf -e myhostname=server.internal.domain.tld
    # postconf -e mydestination=localhost

If this server will be accessible from the internet, set the HELO/EHLO
values to match the FQDN as seen from the internet (replace
mail.domain.tld):

    # postconf -e smtp_helo_name=mail.domain.tld
    # postconf -e smtpd_banner='$smtp_helo_name ESMTP $mail_name'

Enable and start postfix.

Virtual user configuration

Create a vmail user and set up Postfix to use it:

    # groupadd -g 5000 vmail
    # useradd -u 5000 -g vmail -s /usr/bin/nologin -d /home/vmail -m vmail
    # chmod 750 /home/vmail
    # postconf -e virtual_minimum_uid=5000
    # postconf -e virtual_uid_maps=static:5000
    # postconf -e virtual_gid_maps=static:5000
    # postconf -e virtual_mailbox_base=/home/vmail
    # postfix reload

LDAP configuration

Next we need to tell Postfix how to lookup users. To do this, you will
need to create an unprivileged user to use for LDAP lookups (select a
suitably strong password, 63 alpha-numeric various case should be good):

    # samba-tool user create ldap --description="Unprivileged user for LDAP lookups"

Now, create a LDAP alias and group maps for Postfix pasting the
following lines in the file /etc/postfix/ldap-alias.cf as root (replace
internal, domain and tld with appropriate values):

    # Directory settings
    server_host = 127.0.0.1
    search_base = dc=internal,dc=domain,dc=tld
    scope = sub
    version = 3

    # User Binding
    bind = yes
    bind_dn = cn=ldap,cn=users,dc=internal,dc=domain,dc=tld
    bind_pw = axhnTc2LGdnUKQ80cWjWzZBR79SkgAQ1uLxv94M8EDosDoPBqD4bEEvJ1XvpwI7

    # Filter
    query_filter = (&(objectclass=person)(proxyAddresses=smtp:%s))
    result_attribute = samaccountname
    result_format = %s@internal.domain.tld

Create the group map:

    # sed -e '/^query/d' \
        -e '/^result/d' \
        -e '/format/d' \
        /etc/postfix/ldap-alias.cf > /etc/postfix/ldap-group.cf
    echo "query_filter = (&(objectclass=group)(mail=%s))" >> /etc/postfix/ldap-group.cf
    echo "special_result_attribute = member" >> /etc/postfix/ldap-group.cf
    echo "leaf_result_attribute = mail" >> /etc/postfix/ldap-group.cf

Set the right permissions:

    # chmod 0600 /etc/postfix/ldap-{alias,group}.cf

Next test our lookup maps for users (groups have not yet been created)
(substitue internal.domain.tld):

    postmap -q administrator@domain.tld ldap:/etc/postfix/ldap-alias.cf
    postmap -q administrator@internal.domain.tld ldap:/etc/postfix/ldap-alias.cf

You should receive the following output for both commands:

    Administrator@internal.domain.tld

Append any other hosted domains to the first command below, add the
maps, and then reload the Postfix configuration:

    # postconf -e virtual_mailbox_domains="domain.tld, internal.domain.tld"
    # postconf -e virtual_alias_maps="ldap:/etc/postfix/ldap-alias.cf, ldap:/etc/postfix/ldap-group.cf"
    # postfix reload

At this point, Dovecot will need to be configured before completing the
Postfix configuration as Dovecot SASL and LMTP will be used for
athentication and delivery (respectively).

> Dovecot configuration

Basic configuration

Create a very basic dovecot configuration:

    # cp /etc/dovecot/dovecot.conf{.sample,}
    # chown root:root /etc/dovecot/dovecot.conf

Then create the file /etc/dovecot/conf.d/local.conf with this content:

    auth_mechanisms = plain login
    disable_plaintext_auth = no
    ssl = no
    auth_username_format = %n
    mail_location = /home/vmail/%Lu/Maildir

Enable and start dovecot.

LDAP configuration

Add the LDAP lookup configuation /etc/dovecot/conf.d/ldap.conf:

    passdb ldap {
        driver = ldap
        args = /etc/dovecot/dovecot-ldap-passdb.conf
    }
    userdb ldap {
        driver = ldap
        args = /etc/dovecot/dovecot-ldap-userdb.conf
    }

    # chmod 0644 /etc/dovecot/conf.d/ldap.conf
    # chown root:root /etc/dovecot/conf.d/ldap.conf

Add the LDAP user and password configurations (replace
dc=internal,dc=domain,dc=tld and INTERNAL with appropropriate values):

    cat > dovecot-ldap-passdb.conf << "EOF"
    hosts = localhost
    auth_bind = yes
    auth_bind_userdn = INTERNAL\%u
    ldap_version = 3
    base = dc=internal,dc=domain,dc=tld
    scope = subtree
    deref = never
    pass_filter = (&(objectClass=person)(sAMAccountName=%u)(mail=*))
    EOF

    cat > dovecot-ldap-userdb.conf << "EOF"
    hosts = localhost
    dn = cn=ldap,cn=Users,dc=internal,dc=domain,dc=tld
    dnpass = axhnTc2LGdnUKQ80cWjWzZBR79SkgAQ1uLxv94M8EDosDoPBqD4bEEvJ1XvpwI7
    ldap_version = 3
    # The base must be cn=Users for OpenChange ATM...future
    base = cn=Users,dc=internal,dc=domain,dc=tld
    user_attrs = =uid=5000,=gid=5000,=home=/home/vmail/%Lu,=mail=maildir:/home/vmail/%Lu/Maildir/
    user_filter = (&(objectClass=person)(sAMAccountName=%u)(mail=*))

    # Attributes and filter to get a list of all users
    iterate_attrs = sAMAccountName=user
    iterate_filter = (objectClass=person)
    EOF

    # mv dovecot-ldap-{pass,user}db.conf /etc/dovecot
    # chown root:root /etc/dovecot/dovecot-ldap{pass,user}db.conf
    # chmod 0600 /etc/dovecot/dovecot-ldap-userdb.conf
    # chmod 0644 /etc/dovecot/dovecot-ldap-passdb.conf

Create the SASL configuation /etc/dovecot/conf.d/sasl.conf:

    service auth {
        unix_listener /var/spool/postfix/private/auth {
            mode = 0660
            user = postfix
            group = postfix
         }
    }

    # chmod 0644 /etc/dovecot/conf.d/sasl.conf
    # chown root:root /etc/dovecot/conf.d/sasl.conf

Reload Dovecot for the configuration to take effect:

    # dovecot reload

Testing Dovecot authentication

Open a telnet session and test (commands you enter are in bold, replace
xxxxxxxx with your real password):

    telnet localhost 143
    Trying 127.0.0.1...
    Connected to localhost.
    Escape character is '^]'.
    * OK [CAPABILITY IMAP4rev1 LITERAL+ SASL-IR LOGIN-REFERRALS ID ENABLE IDLE AUTH=PLAIN AUTH=LOGIN] Dovecot ready.
    . LOGIN Administrator xxxxxxxx
    . OK [CAPABILITY IMAP4rev1 LITERAL+ SASL-IR LOGIN-REFERRALS ID ENABLE IDLE SORT SORT=DISPLAY THREAD=REFERENCES THREAD=REFS THREAD=ORDEREDSUBJECT MULTIAPPEND  URL-PARTIAL CATENATE UNSELECT CHILDREN NAMESPACE UIDPLUS LIST-EXTENDED I18NLEVEL=1 CONDSTORE QRESYNC ESEARCH ESORT SEARCHRES WITHIN CONTEXT=SEARCH LIST-STATUS SPECIAL-USE BINARY MOVE] Logged in
    . LOGOUT
    * BYE Logging out
    . OK Logout completed.
    Connection closed by foreign host.

If you've received anything other than OK, go back and double check your
configuration before continuing.

LMTP configuration

Create the LMTP configuration file /etc/dovecot/conf.d/lmtp.conf:

    mail_location = /home/vmail/%Lu/Maildir
    service lmtp {
      unix_listener /var/spool/postfix/private/dovecot-lmtp {
        mode = 0600
        user = postfix
        group = postfix
      }
      user = vmail
    }

    protocol lmtp {
      postmaster_address = postmaster@domain.tld
    }

    # chmod 0644 /etc/dovecot/conf.d/lmtp.conf
    # dovecot reload

TLS configuration

Put your certificate files into place and create the TLS configuration
file /etc/dovecot/conf.d/tls.conf (adjust paths and names as necessary).
The keyfile should be owned by root with 0400 permissions. Any
intermediate certificates should be concatenated after the public cert.:

    ssl = yes
    ssl_cert = </etc/dovecot/ssl/host.domain.tld.pem
    ssl_key = </etc/dovecot/ssl/host.domain.tld.key

    # chmod 644 /etc/dovecot/conf.d/tls.conf

Remove the earlier explicitly defined values from local.conf and reload
Dovecot:

    # sed -e '/^ssl/d' -e '/disable_plaintext/s/no/yes/' \
         -i /etc/dovecot/conf.d/local.conf
    # dovecot reload

> Postfix final configuration

SASL configuration

Modify the default smtpd instance:

    # postconf -e smtpd_sasl_type=dovecot
    # postconf -e smtpd_sasl_path=private/auth
    # postconf -e smtpd_sasl_auth_enable=yes
    # postconf -e smtpd_relay_restrictions="permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination"

LMTP configuration

Use dovecot LMTP for delivery:

    postconf -e virtual_transport=lmtp:unix:private/dovecot-lmtp

TLS configuration

If you intend to use STARTTLS (as you should), enable the mail
submission port and restrict to authenticated clients. Edit the
following lines in /etc/postfix/master.cf (replace internal.domain.tld):

    submission inet n       -       n       -       -       smtpd
    -o syslog_name=postfix/submission
    -o smtpd_tls_security_level=encrypt
    -o smtpd_sasl_auth_enable=yes
    -o smtpd_sasl_type=dovecot
    -o smtpd_sasl_path=private/auth
    -o smtpd_sasl_security_options=noanonymous
    -o smtpd_client_restrictions=permit_sasl_authenticated,reject
    -o smtpd_sender_login_maps=ldap:/etc/postfix/ldap-sender.cf
    -o smtpd_sender_restrictions=reject_sender_login_mismatch
    -o smtpd_recipient_restrictions=reject_non_fqdn_recipient,reject_unknown_recipient_domain,permit_sasl_authenticated,reject

Add your certificates. If you intend to chroot postfix (not discussed in
this guide, see here), these need to be placed in the postfix
configuration directory as opposed to the default /etc/ssl/private
directory. Additionally, any intermediate certs should be concatenated
with the public cert being first in the chain and the key file should be
owned by root with 0400 permission mode:

    # postconf -e smtpd_tls_key_file=/etc/postfix/ssl/mail.domain.tld.key
    # postconf -e smtpd_tls_cert_file=/etc/postfix/ssl/mail.domain.tld.pem

Create a map to verify addresses to authenticated users:

    cat > ldap-sender.cf << "EOF"
    # Directory settings
    server_host = localhost
    search_base = dc=internal,dc=lucasit,dc=com
    version = 3
    scope = sub

    # User Binding
    bind = yes
    bind_dn = cn=ldap,cn=Users,dc=internal,dc=domain,dc=tld
    bind_pw = axhnTc2LGdnUKQ80cWjWzZBR79SkgAQ1uLxv94M8EDosDoPBqD4bEEvJ1XvpwI7

    # Filter
    query_filter = (&(objectclass=person)(proxyAddresses=smtp:%s))
    leaf_result_attribute = proxyAddresses
    result_attribute = sAMAccountName
    EOF
    # mv ldap-sender.cf /etc/postfix
    # chown root:root /etc/postfix/ldap-sender.cf
    # chmod 0640 /etc/postfix/ldap-sender.cf

If you'd like to enable TLS on the default SMTP port, you should make it
optional. If you make it required, you will not be able to receive mail
from many hosts on the internet.

    # postconf -e smtpd_tls_security_level=may

Reload postfix to apply the configuration changes:

    # postfix reload

Testing the Postfix SASL configuration

Begin by getting a base64 encoded version of you username and password
(replace xxxxxxxx with your real password):

    echo -ne '\000Administrator\000xxxxxxxx' | openssl base64

You should receive output similar to the following:

    AEFkbWluaXN0cmF0b3IAeHh4eHh4eHg=

Now, open a telnet session and test (commands you enter are in bold,
replace host.domain.tld with your real external FQDN and
AEFkbWluaXN0cmF0b3IAeHh4eHh4eHg= with the result of the previous
command):

    telnet localhost 25
    Trying 127.0.0.1...
    Connected to localhost.
    Escape character is '^]'.
    220 host.domain.tld ESMTP Postfix
    ehlo host.domain.tld
    250-mail.lucasit.com
    250-PIPELINING
    250-SIZE 10240000
    250-VRFY
    250-ETRN
    250-STARTTLS
    250-AUTH PLAIN LOGIN
    250-ENHANCEDSTATUSCODES
    250-8BITMIME
    250 DSN
    AUTH PLAIN AEFkbWluaXN0cmF0b3IAeHh4eHh4eHg=
    235 2.7.0 Authentication successful
    quit
    221 2.0.0 Bye
    Connection closed by foreign host.

If you've gotten anything other than a 235 message, something is wrong
and you should troubleshoot now rather than later.

At ths point, you have a fully functional mail server, though you'll
probably want to lock it down a bit tighter (which isn't covered in this
article). You could easily stop now and use any mail client you wish,
howerver, you'd miss out on the fun of Outlook, RPC/HTTPS, calendar, the
GAL, and contacts. This additional functionality is provided by SOGo and
OpenChange...

> SOGo final configuration

PostgreSQL

Select a strong password (63 random alphanumeric characters is good) for
the sogo user and change it now:

    # su - postgres
    psql
    ALTER USER sogo WITH PASSWORD 'ZpRTOZuQiaKBma4YhvozRJwXCbLqhnRiurhvidB9A8vbjxEoNNjbAwHSbpBTobT';
    \q

SOGo

Create a suitable SOGo configuration file in /etc/sogo/sogo.conf
(replace items in italic with appropriate values):

    {
        /* Database Configuration */
        SOGoProfileURL = "postgresql://sogo:ZpRTOZuQiaKBma4YhvozRJwXCbLqhnRiurhvidB9A8vbjxEoNNjbAwHSbpBTobT@localhost:5432/sogo/sogo_user_profile";
        OCSFolderInfoURL = "postgresql://sogo:ZpRTOZuQiaKBma4YhvozRJwXCbLqhnRiurhvidB9A8vbjxEoNNjbAwHSbpBTobT@localhost:5432/sogo/sogo_folder_info";
        OCSSessionsFolderURL = "postgresql://sogo:ZpRTOZuQiaKBma4YhvozRJwXCbLqhnRiurhvidB9A8vbjxEoNNjbAwHSbpBTobT@localhost:5432/sogo/sogo_sessions_folder";

        /* Mail */
        SOGoDraftsFolderName = Drafts;
        SOGoSentFolderName = Sent;
        SOGoTrashFolderName = Trash;
        SOGoIMAPServer = localhost;
        SOGoSieveServer = sieve://127.0.0.1:4190;
        SOGoSMTPServer = 127.0.0.1;
        SOGoMailDomain = internal.domain.tld;
        SOGoMailingMechanism = smtp;
        SOGoForceExternalLoginWithEmail = NO;
        SOGoMailSpoolPath = /var/spool/sogo;
        NGImap4ConnectionStringSeparator = "/";
        SOGoAppointmentSendEMailNotifications = NO;
        SOGoACLsSendEMailNotifications = NO;

       /* User Authentication */
        SOGoUserSources = (
            {
            type = ldap;
            CNFieldName = cn;
            IDFieldName = cn;
            UIDFieldName = sAMAccountName;
            baseDN = "dc=internal,dc=domain,dc=tld";
            bindDN = "cn=ldap,cn=Users,dc=internal,dc=domain,dc=tld";
            bindFields = (sAMAccountName);
            bindPassword = axhnTc2LGdnUKQ80cWjWzZBR79SkgAQ1uLxv94M8EDosDoPBqD4bEEvJ1XvpwI7;
            canAuthenticate = YES;
            displayName = "Active Directory";
            hostname = ldap://127.0.0.1:389;
            id = directory;
            isAddressBook = YES;
            }
        );

        /* Web Interface */
        SOGoPageTitle = SOGo;
        SOGoVacationEnabled = YES;
        SOGoForwardEnabled = YES;
        SOGoSieveScriptsEnabled = YES;

        /* General */
        SOGoLanguage = English;
        SOGoTimeZone = America/Chicago;
        SOGoCalendarDefaultRoles = (
            PublicDAndTViewer,
            ConfidentialDAndTViewer
        );
        SOGoSuperUsernames = (administrator);

        /* Debug */
        //SoDebugBaseURL = YES;
        //ImapDebugEnabled = YES;
        //LDAPDebugEnabled = YES;
        //SOGoDebugRequests = YES;
        //PGDebugEnabled = YES;
        //SOGoUIxDebugEnabled = YES;
        //WODontZipResponse = YES;

    }

Then issue the following commands:

    # chmod 0600 /etc/sogo/sogo.conf
    # rm /etc/sogo/GNUstep/Defaults/sogod.plist
    # mkdir /var/spool/sogo
    # chown sogo:sogo /var/spool/sogo
    # chmod 700 /var/spool/sogo

Now restart sogo service and try it out by visiting
http://server.internal.domain.tld/SOGo/ .

Apache

If all is well with SOGo without SSL, go ahead and enable SSL in httpd
(modify paths and filenames as necessary):

    # sed '/httpd-ssl.conf/s/#//' -i /etc/httpd/conf/httpd.conf
    # sed -e '/^SSLCertificateFile/s@/etc/httpd/conf/server.crt@/etc/httpd/ssl/mail.domain.tld.pem@' \
             -e '/^SSLCertificateKeyFile/s@/etc/httpd/conf/server.key@/etc/httpd/ssl/mail.domain.tld.key@' \
             -i /etc/httpd/conf/extra/httpd-ssl.conf

Now go ahead and edit the /etc/httpd/conf/extra/SOGo.conf file and
uncomment the following lines, edit to suit your site:

    ## adjust the following to your configuration
    RequestHeader set "x-webobjects-server-port" "443"
    RequestHeader set "x-webobjects-server-name" "mail.domain.tld"
    RequestHeader set "x-webobjects-server-url" "https://mail.domain.tld"

Restart httpd service for the changes to take effect.

Go ahead and go to the regular http page and it should redirect you to
the https site.

> OpenChange final configuration

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Recent versions  
                           of Samba have left       
                           OCSManager/MAPIProxy in  
                           an unusable state.       
                           Fortunately, with        
                           SOGo-2.2, the new        
                           ActiveSync code should   
                           eliminate the need for   
                           OCSManager with Outlook  
                           2013+. (Discuss)         
  ------------------------ ------------------------ ------------------------

OCSManager

OCSManager is a Python-Paste serverlet that listens specifically for
autodiscover, EWS, and RPCProxy requests. Setup OCSMangaer with the
following commands (replace the items in italic type with appropriate
values):

    cat > ocsmanager.ini << "EOF"
    #
    # ocsmanager - Pylons configuration
    #
    # The %(here)s variable will be replaced with the parent directory of this file
    #
    [DEFAULT]
    debug = true
    email_to = postmaster@domain.tld
    smtp_server = localhost
    error_email_from = postmaster@domain.tld

    [main]
    auth = ldap
    mapistore_root = /var/lib/samba/private
    mapistore_data = /var/lib/samba/private/mapistore
    debug = yes

    [auth:ldap]
    host = ldap://server.domain.tld
    port = 389
    bind_dn = CN=Users,DC=internal,DC=domain,DC=tld
    bind_pw = axhnTc2LGdnUKQ80cWjWzZBR79SkgAQ1uLxv94M8EDosDoPBqD4bEEvJ1XvpwI7
    basedn = CN=ldap,CN=Users,DC=internal,DC=domain,DC=tld
    #filter = (cn=%s)
    #attrs = userPassword, x-isActive

    [server:main]
    use = egg:Paste#http
    host = server.internal.domain.tld
    port = 5000
    protocol_version = HTTP/1.1

    [app:main]
    use = egg:ocsmanager
    full_stack = true
    static_files = true
    cache_dir = %(here)s/data
    beaker.session.key = ocsmanager
    beaker.session.secret = SDyKK3dKyDgW0mlpqttTMGU1f
    app_instance_uuid = {ee533ebc-f266-49d1-ae10-d017ee6aa98c}
    NTLMAUTHHANDLER_WORKDIR = /var/cache/ntlmauthhandler
    SAMBA_HOST = server.internal.domain.tld

    [rpcproxy:ldap]
    host = server.internal.domain.tld
    port = 389
    basedn = CN=Users,DC=internal,DC=domain,DC=tld

    # WARNING: *THE LINE BELOW MUST BE UNCOMMENTED ON A PRODUCTION ENVIRONMENT*
    # Debug mode will enable the interactive debugging tool, allowing ANYONE to
    # execute malicious code after an exception is raised.
    set debug = false

    # Logging configuration
    [loggers]
    keys = root

    [handlers]
    keys = console

    [formatters]
    keys = generic

    [logger_root]
    level = INFO
    handlers = console

    [handler_console]
    class = StreamHandler
    args = (sys.stderr,)
    level = NOTSET
    formatter = generic

    [formatter_generic]
    format = %(asctime)s %(levelname)-5.5s [%(name)s] [%(threadName)s] %(message)s
    EOF
    # mv /etc/ocsmanager/ocsmanaer.ini{,.bak}
    # mv ocsmanager.ini /etc/ocsmanager

Then start and enable ocsmanager service.

Adding OpenChange MAPIProxy and OCSManger to Apache

This is the part that glues it all together:

    # echo "LoadModule wsgi_module modules/mod_wsgi.so" >> /etc/httpd/conf/httpd.conf 
    # echo "include conf/extra/rpcproxy.conf" >> /etc/httpd/conf/httpd.conf
    # echo "include conf/extra/ocsmanager-apache.conf" >> /etc/httpd/conf/httpd.conf

Now just restart httpd and samba. If you've made it this far, and your
DNS is configured correctly, you should be able to configure an Outlook
client with only an email address, username, and password. For Outlook
(or other MAPI clients that support RPC/HTTPS, you need open only port
443, at the edge. Obviously, you still need to consider additional
configuration for Postfix (spam and virus filtering, more restrictive
use of SMTPD and SMTP, open ports 25 and 587) if you intend to receive
mail from the internet. You'll probably also want to move the various
HTTPD pieces into virtual hosts, provide redirection on 80 for secure
services, etc., but those exercises are covered in great detail
elsewhere.

Retrieved from
"https://wiki.archlinux.org/index.php?title=OpenChange_Server&oldid=305794"

Category:

-   Mail Server

-   This page was last modified on 20 March 2014, at 05:26.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
