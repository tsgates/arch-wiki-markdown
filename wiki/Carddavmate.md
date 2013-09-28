Carddavmate
===========

Carddavmate is a carddav client that runs in a web browser using
javascript. It is useful when you have a carddav server and want to
access the contacts on this server with only a web browser.

This guide shows you how to install carddavmate to use with davical

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Password Protection                                          |
|     -   2.2 configuring the carddav server                               |
|     -   2.3 configuring apache                                           |
|     -   2.4 Testing                                                      |
|     -   2.5 Troubleshooting                                              |
|     -   2.6 Security                                                     |
+--------------------------------------------------------------------------+

Installation
------------

Install carddavmate from the AUR. After that, config.js needs to be
configured, as well as httpd-carddavmate.conf. Then,
httpd-carddavmate.conf needs to be included in the apache config, and
apache needs to be restarted.

Configuration
-------------

> Password Protection

Password protection is implemented using apache's htpasswd facility. The
relevant file that includes the authentification credentials is at
/srv/http/carddavmate/htpasswd.

You may delete the file or remove the "test" account by deleting the
line from the file.

To add your own user, use this:

$ sudo htpasswd /srv/http/carddavmate/htpasswd

add "-c" after htpasswd if you deleted the file "htpasswd".

> configuring the carddav server

add the carddav server to your config by editing
/srv/http/carddavmate/config.js

An example is better than a thousand words, so here is an example that
works for me:

var globalSettings=[{href:
'https://carddav.example.com:443/caldav.php/joe/', userAuth: {userName:
'joe', userPassword: 'secret', serverPassword: false}, timeOut: 14000}];

> configuring apache

To "serve" the /srv/http/carddavmate directory properly, you need to
include /etc/httpd/conf/extra/httpd-carddavmate.conf in your apache
configuration. To do this, add the following line to
/etc/httpd/conf/httpd.conf

Include conf/extra/httpd-carddavmate.conf

Also, you need to edit httpd-carddavmate.conf to reflect the url where
carddavmate is installed. An example would be:

Header always set Access-Control-Allow-Origin
"https://carddavmate.example.com"

You can save this file and the restart apache by issuing

$ sudo rc.d restart httpd

> Testing

To test your installation, browse to https://127.0.0.1/carddavmate and
see if your carddav data shows up.

This was tested in chrome and worked fine, ymmv for firefox and others.

> Troubleshooting

Troubleshooting is best done using chrome's built-in javascript console

> Security

Since the client is a javascript program that runs in your browser, the
username/password that is configured in config.js on the server is also
in the browser and can be easily seen. To avoid issues, clear your
browser cache to delete the compromising files after you are done.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Carddavmate&oldid=207164"

Category:

-   Networking
