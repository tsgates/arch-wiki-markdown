Nss
===

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Certificate management                                             |
|     -   2.1 List                                                         |
|     -   2.2 Add                                                          |
|     -   2.3 Edit                                                         |
|     -   2.4 Delete                                                       |
|                                                                          |
| -   3 Links and References                                               |
+--------------------------------------------------------------------------+

Introduction
------------

Network Security Services (NSS) is a set of libraries designed to
support cross-platform development of security-enabled client and server
applications. Applications built with NSS can support SSL v2 and v3,
TLS, PKCS #5, PKCS #7, PKCS #11, PKCS #12, S/MIME, X.509 v3
certificates, and other security standards.

Certificate management
----------------------

> List

For list all certificates:

    certutil -d sql:$HOME/.pki/nssdb -L

For list details of a certificate:

    certutil -d sql:$HOME/.pki/nssdb -L -n <certificate nickname>

> Add

To add a certificate use:

    certutil -d sql:$HOME/.pki/nssdb -A -t <TRUSTARGS> -n <certificate nickname> -i <certificate filename>

The TRUSTARGS are three strings of zero or more alphabetic characters,
separated by commas. They define how the certificate should be trusted
for SSL, email, and object signing, and are explained in the certutil
docs or Meena's blog post on trust flags.

To add a personal certificate and private key for SSL client
authentication use the command:

    pk12util -d sql:$HOME/.pki/nssdb -i PKCS12_file.p12

This will import a personal certificate and private key stored in a PKCS
#12 file. The TRUSTARGS of the personal certificate will be set to
"u,u,u".

> Edit

    certutil -d sql:$HOME/.pki/nssdb -M -t <TRUSTARGS> -n <certificate nickname>

> Delete

    certutil -d sql:$HOME/.pki/nssdb -D -n <certificate nickname>

Links and References
--------------------

-   Network Security Services on mozilla.org.
-   Using the Certificate Database Tool on mozilla.org.
-   Certificate management on Chromium help.
-   Managing Certificate Trust flags in NSS Database on Meena's blog.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Nss&oldid=206844"

Category:

-   Internet Applications
