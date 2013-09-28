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

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Initial Notes                                                      |
| -   2 Installation                                                       |
| -   3 Configuration                                                      |
|     -   3.1 Apache                                                       |
|     -   3.2 lighttpd Specific Configuration                              |
|                                                                          |
| -   4 Post Installation                                                  |
|     -   4.1 Cleaning Up                                                  |
|     -   4.2 Installing Plugins                                           |
|     -   4.3 Backing Up                                                   |
|                                                                          |
| -   5 Further Reading                                                    |
| -   6 See Also                                                           |
+--------------------------------------------------------------------------+

Initial Notes
-------------

DokuWiki should work on any web server which supports PHP 5.1.2 or
later. As the requirements may change over time, you should consult the
requirements page for DokuWiki for additional details.

It is strongly recommend to read through the appropriate sections of
DokuWiki's security page for your web server. Most popular web servers
are covered but there are generic instructions as well.

The package in [community] unpacks DokuWiki at /srv/http/dokuwiki and
changes ownership to the "http" user. This should work fine for most
popular web servers as packaged for Arch.

Installation
------------

1.  Install your web server of choice (e.g. Apache or lighttpd) and
    configure it for PHP. As mentioned above, DokuWiki has no need for a
    database server so you may be able to skip those steps when setting
    up your web server.
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

    alias.url += ("/dokuwiki" => "/usr/share/webapps/dokuwiki/")

Add alias somewhere in lighttpd or fastcgi conf file

Restart lighttp:

     # /etc/rc.d/lighttpd restart

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

See Also
--------

DokuWiki HowTo Install and Upgrade

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dokuwiki&oldid=247389"

Category:

-   Office
