OpenLDAP
========

Related articles

-   LDAP Authentication
-   LDAP Hosts

OpenLDAP is an open-source implementation of the LDAP protocol. An LDAP
server basically is a non-relational database which is optimised for
accessing, but not writing, data. It is mainly used as an address book
(for e.g. email clients) or authentication backend to various services
(such as Samba, where it is used to emulate a domain controller, or
Linux system authentication, where it replaces /etc/passwd) and
basically holds the user data.

Commands related to OpenLDAP that begin with ldap (like ldapsearch) are
client-side utilities, while commands that begin with slap (like
slapcat) are server-side.

Directory services are an enormous topic. Configuration can therefore be
complex. This page is a starting point for a basic OpenLDAP installation
and a sanity check. If you are totally new to those concepts, this is an
good introduction that is easy to understand and that will get you
started, even if you are new to everything LDAP.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 The server
    -   2.2 The client
    -   2.3 Test your new OpenLDAP installation
    -   2.4 OpenLDAP over TLS
        -   2.4.1 Create a self-signed certificate
        -   2.4.2 Configure slapd for SSL
        -   2.4.3 Start slapd with SSL
-   3 Next Steps
-   4 Troubleshooting
    -   4.1 Client Authentication Checking
    -   4.2 LDAP Sserver Stops Suddenly
-   5 See Also

Installation
------------

OpenLDAP contains both a LDAP server and client. Install it with the
package openldap, available in the official repositories.

Configuration
-------------

> The server

Note:If you already have an OpenLDAP database on your machine, remove it
by deleting everything inside /var/lib/openldap/openldap-data/.

The server configuration file is located at /etc/openldap/slapd.conf.

Edit the suffix and rootdn. The suffix typically is your domain name but
it does not have to be. It depends on how you use your directory. We
will use example for the domain name, and com for the tld. The rootdn is
your LDAP administrator's name (we'll use root here).

    suffix     "dc=example,dc=com"
    rootdn     "cn=root,dc=example,dc=com"

Now we delete the default root password and create a strong one:

    # sed -i "/rootpw/ d" /etc/openldap/slapd.conf #find the line with rootpw and delete it
    # echo "rootpw    $(slappasswd)" >> /etc/openldap/slapd.conf  #add a line which includes the hashed password output from slappasswd

You will likely want to add some typically used schemas to the top of
slapd.conf:

    include         /etc/openldap/schema/cosine.schema
    include         /etc/openldap/schema/inetorgperson.schema
    include         /etc/openldap/schema/nis.schema

You will likely want to add some typically used indexes to the bottom of
slapd.conf:

    index   uid             pres,eq
    index   mail            pres,sub,eq
    index   cn              pres,sub,eq
    index   sn              pres,sub,eq
    index   dc              eq

Now prepare the database directory. You will need to copy the default
config file and set the proper ownership:

    # cp /etc/openldap/DB_CONFIG.example /var/lib/openldap/openldap-data/DB_CONFIG
    # chown ldap:ldap /var/lib/openldap/openldap-data/DB_CONFIG

Note:With OpenLDAP 2.4 the configuration of slapd.config is deprecated.
From this version on all configuration settings are stored in
/etc/openldap/slapd.d/.

To store the recent changes in slapd.conf to the new slapd-config
configuration settings, we have to delete the old configuration files
first:

    # rm -rf /etc/openldap/slapd.d/*

Then we generate the new configuration with:

    # slaptest -f /etc/openldap/slapd.conf -F /etc/openldap/slapd.d/

This last command has to be run every time you change slapd.conf.

Check if everything succeeded and finally start the slapd daemon with
slapd.service using systemd.

Note:Index the directory after you populate it. You should stop slapd
before doing this.

    # slapindex
    # chown ldap:ldap /var/lib/openldap/openldap-data/*

> The client

The client config file is located at /etc/openldap/ldap.conf.

It is quite simple: you'll only have to alter BASE to reflect the suffix
of the server, and URI to reflect the address of the server, like:

    /etc/openldap/ldap.conf

    BASE            dc=example,dc=com
    URI             ldap://localhost

If you decide to use SSL:

-   The protocol (ldap or ldaps) in the URI entry has to conform with
    the slapd configuration
-   If you decide to use self-signed certificates, add a
    TLS_REQCERT allow line to ldap.conf

> Test your new OpenLDAP installation

This is easy, just run the command below:

    $ ldapsearch -x '(objectclass=*)'

Or authenticating as the rootdn (replacing -x by -D <user> -W), using
the example configuration we had above:

    $ ldapsearch -D "cn=root,dc=example,dc=com" -W '(objectclass=*)'

Now you should see some information about your database.

> OpenLDAP over TLS

Note:upstream documentation is much more useful/complete than this
section

If you access the OpenLDAP server over the network and especially if you
have sensitive data stored on the server you run the risk of someone
sniffing your data which is sent clear-text. The next part will guide
you on how to setup an SSL connection between the LDAP server and the
client so the data will be sent encrypted.

In order to use TLS, you must have a certificate. For testing purposes,
a self-signed certificate will suffice. To learn more about
certificates, see OpenSSL.

Warning:OpenLDAP cannot use a certificate that has a password associated
to it.

Create a self-signed certificate

To create a self-signed certificate, type the following:

    $ openssl req -new -x509 -nodes -out slapdcert.pem -keyout slapdkey.pem -days 365

You will be prompted for information about your LDAP server. Much of the
information can be left blank. The most important information is the
common name. This must be set to the DNS name of your LDAP server. If
your LDAP server's IP address resolves to example.org but its server
certificate shows a CN of bad.example.org, LDAP clients will reject the
certificate and will be unable to negotiate TLS connections (apparently
the results are wholly unpredictable).

Now that the certificate files have been created copy them to
/etc/openldap/ssl/ (create this directory if it doesn't exist) and
secure them. slapdcert.pem must be world readable because it contains
the public key. slapdkey.pem on the other hand should only be readable
for the ldap user for security reasons:

    # mv slapdcert.pem slapdkey.pem /etc/openldap/ssl/
    # chmod -R 744 /etc/openldap/ssl/
    # chmod 400 /etc/openldap/ssl/slapdkey.pem
    # chmod 444 /etc/openldap/ssl/slapdcert.pem
    # chown ldap /etc/openldap/ssl/slapdkey.pem

The /etc/openldap/slapd.d folder and it's files should be owned by ldap
user and group:

    # chown -R ldap:ldap /etc/openldap/slapd.d/

Configure slapd for SSL

Edit the daemon configuration file (/etc/openldap/slapd.conf) to tell
LDAP where the certificate files reside by adding the following lines:

    # Certificate/SSL Section
    TLSCipherSuite HIGH:MEDIUM:-SSLv2
    TLSCertificateFile /etc/openldap/ssl/slapdcert.pem
    TLSCertificateKeyFile /etc/openldap/ssl/slapdkey.pem

The TLSCipherSuite specifies a list of OpenSSL ciphers from which slapd
will choose when negotiating TLS connections, in decreasing order of
preference. In addition to those specific ciphers, you can use any of
the wildcards supported by OpenSSL. NOTE: HIGH, MEDIUM, and +SSLv2 are
all wildcards.

Note:To see which ciphers are supported by your local OpenSSL
installation, type the following: openssl ciphers -v ALL

Start slapd with SSL

You will have to edit slapd.service to change to protocol slapd listens
on.

First, disable slapd.service if it's enabled.

    systemctl stop slapd.service

Then, copy the stock service to /etc/systemd/system/:

    # cp /usr/lib/systemd/system/slapd.service /etc/systemd/system/

Edit it, and add change ExecStart to:

    /etc/systemd/system/slapd.service

    ExecStart=/usr/bin/slapd -u ldap -g ldap -h "ldaps:///"

Localhost connections don't need to use SSL. So, if you want to access
the server locally you should change the ExecStart line to:

    ExecStart=/usr/bin/slapd -u ldap -g ldap -h "ldap://127.0.0.1 ldaps:///"

Then reenable and start it:

    # systemctl daemon-reload
    # systemctl restart slapd.service

If slapd started successfully you can enable it with:

    # systemctl enable slapd.service

Note:If you created a self-signed certificate above, be sure to add
TLS_REQCERT allow to /etc/openldap/ldap.conf on the client, or it won't
be able connect to the server.

Next Steps
----------

You now have a basic LDAP installation. The next step is to design your
directory. The design is heavily dependent on what you are using it for.
If you are new to LDAP, consider starting with a directory design
recommended by the specific client services that will use the directory
(PAM, Postfix, etc).

A directory for system authentication is the LDAP Authentication
article.

A nice web frontend is phpLDAPadmin.

Troubleshooting
---------------

> Client Authentication Checking

If you can't connect to your server for non-secure authentication

    $ ldapsearch -x -H ldap://ldaservername:389 -D cn=Manager,dc=example,dc=exampledomain

and for TLS secured authentication with:

    $ ldapsearch -x -H ldaps://ldaservername:636 -D cn=Manager,dc=example,dc=exampledomain

> LDAP Sserver Stops Suddenly

If you notice that slapd seems to start but then stops, you may have a
permission issue with the ldap datadir. Try running:

    # chown ldap:ldap /var/lib/openldap/openldap-data/*

to allow slapd write access to its data directory as the user "ldap"

See Also
--------

-   Official OpenLDAP Software 2.4 Administrator's Guide
-   phpLDAPadmin is a web interface tool in the style of phpMyAdmin.
-   LDAP Authentication
-   apachedirectorystudio2 from the Arch User Repository is an
    Eclipse-based LDAP viewer. Works perfect with OpenLDAP
    installations.

Retrieved from
"https://wiki.archlinux.org/index.php?title=OpenLDAP&oldid=302349"

Category:

-   Networking

-   This page was last modified on 27 February 2014, at 18:59.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
