OpenLDAP
========

  

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: slapd.conf(5) is 
                           deprecated; use          
                           slapd-config(5)          
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

OpenLDAP, LDAP & Directory services are an enormous topic. Configuration
is therefore complex. This page is a starting point for a basic openldap
install on Archlinux and a sanity check.

If you are totally new to those concepts, here is an good introduction
that is easy to understand and that will get you started, even if you
are new to everything LDAP.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 The server (slapd)                                           |
|         -   2.1.1 /etc/openldap/slapd.conf                               |
|         -   2.1.2 /etc/conf.d/slapd                                      |
|                                                                          |
|     -   2.2 The client                                                   |
|     -   2.3 Test your new OpenLDAP installation                          |
|     -   2.4 OpenLDAP over TLS                                            |
|         -   2.4.1 Create a self-signed certificate                       |
|         -   2.4.2 Configure slapd for SSL                                |
|         -   2.4.3 Start slapd with SSL                                   |
|                                                                          |
| -   3 Next Steps                                                         |
| -   4 Troubleshooting                                                    |
| -   5 See Also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

This part is easy:

    pacman -S openldap 

The openldap package basically contains two things: The LDAP server
(slapd) and the LDAP client. You will probably want to run the server on
your computer. After you design the directory, the server will be able
to provide authentication services for LDAP clients. It is quite likely
that you will run services requiring the LDAP authentication on that
very computer, in which case the LDAP client will query the LDAP server
from the same package.

Configuration
-------------

> The server (slapd)

First prepare the database directory. You will need to copy the default
config file and set the proper ownership.

Warning:The following snippet wipes out any existing ldap database.

    rm -rf /var/lib/openldap/openldap-data/*
    cp /etc/openldap/DB_CONFIG.example /var/lib/openldap/openldap-data/DB_CONFIG
    chown ldap:ldap /var/lib/openldap/openldap-data/DB_CONFIG

/etc/openldap/slapd.conf

Next we prepare slapd.conf. Add some typically used schemas...

    include         /etc/openldap/schema/cosine.schema
    include         /etc/openldap/schema/nis.schema
    include         /etc/openldap/schema/inetorgperson.schema

Edit the suffix. Typically this is your domain name but it does not have
to be. It depends on how you use your directory. We will use 'example'
for the domain name, and 'com' for the tld. Also set your ldap
administrators name (we'll use 'root' here)

    suffix     "dc=example,dc=com"
    rootdn     "cn=root,dc=example,dc=com"

Now we delete the default root password and create a strong one:

    #find the line with rootpw and delete it
    sed -i "/rootpw/ d" slapd.conf
    #add a line which includes the hashed password output from slappasswd
    echo "rootpw    $(slappasswd)" >> slapd.conf

ldap won't find things unless you index them. Read the ldap
documentation for details, you can use the following to start with. (add
them to your slapd.conf)

    index   uid             pres,eq
    index   mail            pres,sub,eq
    index   cn              pres,sub,eq
    index   sn              pres,sub,eq
    index   dc              eq

Note:

Don't forget to run slapindex after you populate your directory. (slapd
needs to be stopped to do this). Then change the ownership for all the
generated files:

    chown ldap:ldap /var/lib/openldap/openldap-data/*

If you want to use SSL, you have to specify a path to your certificates
here. See OpenLDAP Authentication

Finally you can start the slapd daemon.

    #systemctl start slapd

It might be possible that /run/openldap does not exist, starting the
daemon won't work. Just create the directory and change the permission:

    #mkdir /run/openldap
    #chown ldap:ldap /run/openldap

/etc/conf.d/slapd

Very important, you define here on which port the server should listen
and if you want to use SSL, you will want to use the ldaps:// URI
instead of the default ldap:// You can also specify additional slapd
options here.

  

> The client

The client is usually not such a big deal, just keep in mind that your
apps that require LDAP auth use it, so if something goes wrong with
LDAP, do not waste your time with the app, start debugging the client
instead.

The client config file is located at /etc/openldap/ldap.conf It is
actually very simple.

If you decide to use SSL:

-   The protocol (ldap or ldaps) in the URI entry has to conform with
    the slapd configuration
-   If you decide to use self-signed certificates, you have to add them
    to TLS_CACERT

> Test your new OpenLDAP installation

This is easy, just run the command below:

    ldapsearch -x -b  -s base '(objectclass=*)' namingContexts

you should see some information on your database.

> OpenLDAP over TLS

Note:upstream documentation is much more useful/complete than this
section

If you access the Openldap server over the network and especially if you
have sensitive data stored on the server you run the risk of someone
sniffing your data which is sent clear-text. The next part will guide
you on how to setup an SSL connection between the LDAP server and the
client so the data will be sent encrypted.

In order to use TLS, we must first create a certificate. You can have a
certificate signed, or create your own Certificate Authority (CA), but
for our purposed, a self-signed certificate will suffice.

Warning:OpenLDAP cannot use a certificate that has a password associated
to it.

Create a self-signed certificate

To create a self-signed certificate, type the following:

    openssl req -new -x509 -nodes -out slapdcert.pem -keyout slapdkey.pem -days 365

You will be prompted for information about your LDAP server. Much of the
information can be left blank. The most important information is the
common name. This must be set to the DNS name of your LDAP server. If
your LDAP server's IP address resolves to example.org but its server
certificate shows a CN of bad.example.org, LDAP clients will reject the
certificate and will be unable to negotiate TLS connections (apparently
the results are wholly unpredictable).

Now that the certificate files have been created copy them to
/etc/openldap/ssl/ (if this directory doesn't exist create it) and
secure them. IMPORTANT: slapdcert.pem must be world readable because it
contains the public key. slapdkey.pem on the other hand should only be
readable for the ldap user for security reasons:

    cp slapdcert.pem slapdkey.pem /etc/openldap/ssl/
    chown ldap slapdkey.pem
    chmod 400 slapdkey.pem
    chmod 444 slapdcert.pem

Configure slapd for SSL

Edit the daemon configuration file (/etc/openldap/slapd.conf) to tell
LDAP where the certificate files reside by adding the following lines:

    # Certificate/SSL Section
    TLSCipherSuite HIGH:MEDIUM:+SSLv2
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

In order to tell OpenLDAP to start using encryption, edit
/etc/conf.d/slapd, uncomment the SLAPD_SERVICES line and set it to the
following:

    SLAPD_SERVICES="ldaps:///"

Localhost connections don't need to use SSL so you can use this instead:

    SLAPD_SERVICES="ldap://127.0.0.1 ldaps:///:

  
 IMPORTANT: If you created a self-signed certificate above be sure to
add the following line to /etc/openldap/ldap.conf or you won't be able
connect to the server to test it:

    TLS_REQCERT allow

Finally restart the server.

Next Steps
----------

You now have a basic ldap installation. The step is to design your
directory. The design is heavily dependent on what you are using it for.
If you are new to ldap, consider starting with a directory design
recommended by the specific client services that will use the directory
(PAM, Postfix, etc).

A directory for system authentication is the LDAP Authentication
article.

Troubleshooting
---------------

If you notice that slapd seems to start but then stops, you may have a
permission issue with the ldap datadir. Try running:

    # chown ldap:ldap /var/lib/openldap/openldap-data/*

to allow slapd write access to its data directory as the user "ldap"

See Also
--------

-   http://www.openldap.org/doc/admin24/
-   phpLDAPadmin is a web interface tool in the style of phpmyadmin.
-   apachedirectorystudio2 from the Arch User Repository is an
    Eclipse-based LDAP viewer. Works perfect for OpenLDAP installations.

Retrieved from
"https://wiki.archlinux.org/index.php?title=OpenLDAP&oldid=254539"

Category:

-   Networking
