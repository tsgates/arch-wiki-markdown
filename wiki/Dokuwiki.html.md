Dokuwiki
========

"DokuWiki is a standards-compliant, simple-to-use wiki which allows
users to create rich documentation repositories. It provides an
environment for individuals, teams and companies to create and
collaborate using a simple yet powerful syntax that ensures data files
remain structured and readable outside the wiki."

"Unlimited page revisions allows restoration to any earlier page
version, and with data stored in plain text files, no database is
required. A powerful plugin architecture allows for extension and
enhancement of the core system. See the features section for a full
description of what DokuWiki has to offer."[1]

In other words, DokuWiki is a wiki written in PHP and requires no
database.

Like to see a running example?

Contents
--------

-   1 Initial Notes
-   2 Installation
-   3 Configuration
    -   3.1 Apache
    -   3.2 lighttpd Specific Configuration
    -   3.3 nginx
-   4 Post Installation
    -   4.1 Cleaning Up
    -   4.2 Installing Plugins
    -   4.3 Backing Up
-   5 Further Reading

Initial Notes
-------------

DokuWiki should work on any web server which supports PHP 5.1.2 or
later. As the requirements may change over time, you should consult the
requirements page for DokuWiki for additional details.

It is strongly recommend to read through the appropriate sections of
DokuWiki's security page for your web server. Most popular web servers
are covered but there are generic instructions as well.

The package in [community] unpacks DokuWiki at
/usr/share/webapps/dokuwiki with the configuration files in
/etc/webapps/dokuwiki and the data files in /var/lib/dokuwiki/data. It
also changes the ownership of the relevant files to the "http" user.
This should work fine for most popular web servers as packaged for Arch.

Installation
------------

1.  Install your web server of choice (e.g. Apache, nginx or lighttpd)
    and configure it for PHP. As mentioned above, DokuWiki has no need
    for a database server so you may be able to skip those steps when
    setting up your web server.
2.  Install dokuwiki from [community] with pacman.
3.  Configure web server for dokuwiki (see section below)
4.  With your web browser of choice, open
    http://<your-server>/dokuwiki/install.php and continue the
    installation from there.

Alternatively, if you would like to install from tarball, you can read
from http://www.dokuwiki.org/Install. Generally the procedure is the
same as above. Instead of using pacman, you will need to download the
tarball, unpack it to your server's document root (e.g.
/srv/http/dokuwiki), and chown to the appropriate user (e.g. "http").

Configuration
-------------

If you are using lighttpd or nginx you need to adjust the open_basedir
in /etc/php/php.ini to include the dokuwiki directories (php forbids
following symbolic links outside of the allowed scope):

    /etc/php/php.ini

    open_basedir = /srv/http/:/home/:/tmp/:/usr/share/pear/:/usr/share/webapps/:/etc/webapps/dokuwiki/:/var/lib/dokuwiki/

> Apache

Firstly, create the file /etc/httpd/conf/extra/dokuwiki.conf with the
following contents:

    Alias /dokuwiki /usr/share/webapps/dokuwiki
    <Directory /usr/share/webapps/dokuwiki/>
        Options +FollowSymLinks
        AllowOverride All
        order allow,deny
        allow from all
        php_admin_value open_basedir "/srv/http/:/home/:/tmp/:/usr/share/pear/:/usr/share/webapps/:/etc/webapps/dokuwiki/:/var/lib/dokuwiki/"
    </Directory>

Include the newly created file in the Apache configuration by placing
the following line at the end of /etc/httpd/conf/httpd.conf:

    Include conf/extra/dokuwiki.conf

Make sure the folders /etc/webapps/dokuwiki and /var/lib/dokuwiki are
owned by user and group "http". You may relocate these directories if
you like as long as you update the references in
/etc/httpd/conf/extra/dokuwiki.conf respectively.

Afterwards restart Apache:

     # systemctl restart httpd.service

Then finish the installation by running the dokuwiki/install.php script
in your browser.

> lighttpd Specific Configuration

Edit the /etc/lighttpd/lighttpd.conf file as per the dokuwiki
instructions (might contain updated information).

Make sure the module mod_access is loaded. If not, load it by adding the
following to /etc/lighttpd/lighttpd.conf:

    server_modules += ("mod_access")

mod_access provides the url.access-deny command, which we are using from
this point.

Under the line:

    $HTTP["url"] =~ "\.pdf$" {
      server.range-requests = "disable"
    }

add this:

    # subdir of dokuwiki
    # comprised of the subdir of the root dir where dokuwiki is installed
    # in this case the root dir is the basedir plus /htdocs/
    # Note: be careful with trailing slashes when uniting strings.
    # all content on this example server is served from htdocs/ up.
    #var.dokudir = var.basedir + "/dokuwiki"
    var.dokudir = server.document-root + "/dokuwiki"

    # make sure those are always served through fastcgi and never as static files
    # deny access completly to these
    $HTTP["url"] =~ "/\.ht" { url.access-deny = ( "" ) }
    $HTTP["url"] =~ "/_ht" { url.access-deny = ( "" ) }
    $HTTP["url"] =~ "^" + var.dokudir + "/bin/"  { url.access-deny = ( "" ) }
    $HTTP["url"] =~ "^" + var.dokudir + "/data/" { url.access-deny = ( "" ) }
    $HTTP["url"] =~ "^" + var.dokudir + "/inc/"  { url.access-deny = ( "" ) }
    $HTTP["url"] =~ "^" + var.dokudir + "/conf/" { url.access-deny = ( "" ) }

These entries give some basic security to DokuWiki. lighttpd does not
use .htaccess files like Apache. You CAN install with out this, but I
would NEVER recommend it.

  
 Add alias somewhere in lighttpd or fastcgi conf file:

    alias.url += ("/dokuwiki" => "/usr/share/webapps/dokuwiki/")

The command alias.url is provided by the module mod_alias so that must
be loaded for the above to work.

Restart lighttp:

     # systemctl restart lighttpd

> nginx

Add the following location blocks to your /etc/nginx/nginx.conf.

    #Assuming that the root is set to /usr/share/webapps.
    #You may need to adjust your location blocks accordingly.
    location ~^/dokuwiki/(data|conf|bin|inc)/ { deny all; } # secure DokuWiki
    location ~^/dokuwiki/\.ht { deny all; } # also secure the Apache .htaccess files
    location ~^/dokuwiki/lib/^((?!php).)*$ { expires 30d; } # no need to serve non .php files through fastcgi, so we catch those requests here.
    location ~^/dokuwiki/.*\.php$ {
                include fastcgi_params;
                fastcgi_pass unix:/run/php-fpm/php-fpm.sock;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                fastcgi_param PATH_INFO $uri;
            }

Restart nginx

     # systemctl restart nginx

Post Installation
-----------------

> Cleaning Up

After configuring the server remove the install.php file!

     # rm /srv/http/dokuwiki/install.php

> Installing Plugins

Many community created plugins can be found here

They can be added through the web interface (as well as updated) through
the Admin menu. Some plugins cannot be downloaded, if they go over ssl
(e.g. git). Uncomment following line in /etc/php/php.ini:

    extension=openssl.so

> Backing Up

It is very trivial to backup DokuWiki, since there is no database. All
pages are in plain text, and require only a simple tar, or rsync.

A quick breakdown of the directories of interest in the current
(2008-05-05) version:

     /dokuwiki/data/  =>  All User Created Data
     /dokuwiki/lib/plugins/  =>  All User Added Plugins

Further Reading
---------------

The DokuWiki main site has all of the information and help that you
could possibly need.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dokuwiki&oldid=295079"

Category:

-   Office

-   This page was last modified on 30 January 2014, at 21:12.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
