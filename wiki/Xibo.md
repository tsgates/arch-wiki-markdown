xibo
====

Xibo is a digital signage tool. It requires a working LAMP setup for the
server.

Contents
--------

-   1 Server
    -   1.1 Installation
    -   1.2 Configuration
        -   1.2.1 Apache
        -   1.2.2 PHP
-   2 Client

Server
------

> Installation

Install the xibo package from the AUR repository.

> Configuration

Apache

Set up Apache to use php as outlined in the LAMP article.

Copy the example Apache configuration file to your Apache configuration
directory:

    # cp /etc/webapps/xibo/apache.example.conf /etc/httpd/conf/extra/httpd-xibo.conf

And include it in /etc/httpd/conf/httpd.conf:

    # Xibo configuration
    Include conf/extra/httpd-xibo.conf

PHP

You need to enable the mysql and gd extensions in PHP by editing
/etc/php/php.ini and uncommenting the following lines:

    extension=mysql.so
    extension=gd.so

Client
------

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xibo&oldid=303491"

Category:

-   Web Server

-   This page was last modified on 7 March 2014, at 14:53.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
