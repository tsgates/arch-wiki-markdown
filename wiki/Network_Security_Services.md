Network Security Services
=========================

Network Security Services (NSS) is a set of libraries designed to
support cross-platform development of security-enabled client and server
applications. Applications built with NSS can support SSL v2 and v3,
TLS, PKCS #5, PKCS #7, PKCS #11, PKCS #12, S/MIME, X.509 v3
certificates, and other security standards.

Contents
--------

-   1 Certificate management
    -   1.1 List
    -   1.2 Add
    -   1.3 Edit
    -   1.4 Delete
-   2 Links and References

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
"https://wiki.archlinux.org/index.php?title=Network_Security_Services&oldid=302649"

Category:

-   Internet applications

-   This page was last modified on 1 March 2014, at 04:29.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
