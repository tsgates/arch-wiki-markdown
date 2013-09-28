Apache and spdy
===============

mod_spdy is a SPDY module for Apache 2.2 that allows your web server to
take advantage of SPDY features like stream multiplexing and header
compression.

-   mod_spdy dev site
-   References: 1 2 3

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Configure mod_spdy                                           |
|     -   2.2 Configure SPDY                                               |
|     -   2.3 Module Directives                                            |
+--------------------------------------------------------------------------+

Installation
------------

Install the package in aur mod_spdy  
 gclient depends python2

    sudo ln -sf /usr/bin/python2 /usr/bin/python

Configuration
-------------

> Configure mod_spdy

In /etc/httpd/conf/httpd.conf comment lines

    #LoadModule ssl_module modules/mod_ssl.so

    #Include conf/extra/httpd-ssl.conf

In /etc/httpd/conf/httpd.conf add Include

    Include conf/extra/spdy.conf

Create self-signed certificate (you can change key size and days of
validity)

     # cd /etc/httpd/conf
     # openssl genrsa -des3 -out server.key 1024
     # openssl req -new -key server.key -out server.csr
     # cp server.key server.key.org
     # openssl rsa -in server.key.org -out server.key
     # openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

Restart apache

     # rc.d restart httpd

> Configure SPDY

In /etc/httpd/conf/extra/spdy.conf

> Module Directives

    SpdyEnabled - Enable SPDY support
    SpdyMaxStreamsPerConnection - Maxiumum number of simultaneous SPDY streams per connection
    SpdyMinThreadsPerProcess - Miniumum number of worker threads to spawn per child process
    SpdyMaxThreadsPerProcess - Maxiumum number of worker threads to spawn per child process
    SpdyDebugLoggingVerbosity - Set the verbosity of mod_spdy logging
    SpdyDebugUseSpdyForNonSslConnections - Use SPDY even over non-SSL connections; DO NOT USE IN PRODUCTION

Retrieved from
"https://wiki.archlinux.org/index.php?title=Apache_and_spdy&oldid=219072"

Category:

-   Web Server
