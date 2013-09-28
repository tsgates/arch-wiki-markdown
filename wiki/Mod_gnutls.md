mod_gnutls
==========

  Summary
  ----------------------------------------------------------------------------------------------------
  An introduction to mod_gnutls, covering installation and basic configuration of the Apache module.

From mod_gnutls - Apache SSL/TLS module using GnuTLS library:

mod_gnutls uses the GnuTLS library to provide SSL 3.0, TLS 1.0, TLS 1.1
and 1.2 encryption for Apache HTTPD. It is similar to mod_ssl in
purpose, but does not use OpenSSL.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Install package                                              |
|     -   1.2 Configure Apache                                             |
|                                                                          |
| -   2 Known issues                                                       |
|     -   2.1 GnuTLS 3.0.5                                                 |
|     -   2.2 Connections from localhost                                   |
+--------------------------------------------------------------------------+

Installation
------------

> Install package

Install mod_gnutls, available in the Arch User Repository.

> Configure Apache

-   Add these lines to /etc/httpd/conf/httpd.conf:

    LoadModule gnutls_module modules/mod_gnutls.so
    Include conf/extra/httpd-gnutls.conf

-   Make sure that the following line is commented in
    /etc/httpd/conf/httpd.conf:

    Include conf/extra/httpd-ssl.conf

-   Create the file /etc/httpd/conf/extra/httpd-gnutls.conf with the
    following content:

    /etc/httpd/conf/extra/httpd-gnutls.conf

    Listen 443

    AddType application/x-x509-ca-cert .crt
    AddType application/x-pkcs7-crl    .crl

    GnuTLSCache dbm "/var/run/httpd/gnutls_scache"
    GnuTLSCacheTimeout 600

    <VirtualHost _default_:443>

    DocumentRoot "/srv/http"
    ServerName www.example.org
    ServerAdmin youremail@example.org
    ErrorLog "/var/log/httpd/error_log"
    TransferLog "/var/log/httpd/access_log"

    GnuTLSEnable on
    GnuTLSPriorities NORMAL

    GNUTLSExportCertificates on

    GnuTLSCertificateFile /path/to/certificate/domain.tld.crt
    GnuTLSKeyFile /path/to/certificate/domain.tld.key

    </VirtualHost>

-   Restart httpd (see Daemon).

-   Check that Apache loaded correctly and answers on port 443.

Known issues
------------

> GnuTLS 3.0.5

With version 3.0.5 libgnutls-extra was removed from GnuTLS. Therefore
mod_gnutls fails to compile with GnuTLS versions higher than 3.0.4. But
it does not use any functions of libgnutls-extra, it only includes its
header file. Therefore it can easily be patched. The patch is already
included in the PKGBUILD found in the AUR.

> Connections from localhost

mod_gnutls 0.5.10 (the version currently found in AUR) contains a bug
that answers all connections from localhost in plain text. The bug was
introduced in 0.5.10, previous versions do not show the problem. Please
do not use 0.5.10 when running some kind of SSL/SSH multiplexer like
sslh as it will break the HTTPS connection. The bug has already been
resolved and will be fixed in the next release.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Mod_gnutls&oldid=207341"

Category:

-   Web Server
