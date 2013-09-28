Owncloud
========

ownCloud is a software suite that provides a location-independent
storage area for data (cloud storage).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Custom configurations                                              |
|     -   2.1 Filesize Limitations                                         |
|     -   2.2 Running owncloud in a subdirectory                           |
|                                                                          |
| -   3 Filling ownCloud with data                                         |
|     -   3.1 Small Files                                                  |
|         -   3.1.1 WebDav                                                 |
|         -   3.1.2 SABnzbd                                                |
|                                                                          |
|     -   3.2 Big Files                                                    |
|                                                                          |
| -   4 Important Notes                                                    |
| -   5 Nginx + uwsgi_php alternative                                      |
| -   6 Troubleshooting                                                    |
|     -   6.1 Self-Signed certificate not accepted                         |
|     -   6.2 Can't create data directory (/path/to/dir)                   |
+--------------------------------------------------------------------------+

Installation
------------

owncloud is available in the AUR.

1.  First of all set up the LAMP stack as described in the corresponding
    Wiki article.
2.  Install the owncloud package as described in
    AUR#Installing_packages.
3.  Copy /usr/share/doc/owncloud/examples/apache.conf_example to
    /etc/httpd/conf/extra/owncloud.conf (if using owncloud-git)
4.  Add the following lines into /etc/httpd/conf/httpd.conf (php5 should
    have been configured during the LAMP stack setup):

     Include /etc/httpd/conf/extra/owncloud.conf
     LoadModule php5_module modules/libphp5.so
     Include conf/extra/php5_module.conf

Uncomment extensions in /etc/php/php.ini

     gd.so
     intl.so
     openssl.so
     xmlrpc.so
     zip.so
     iconv.so

Depending on which database backend you are going to use uncomment
either one of the following extensions in /etc/php/php.ini

     sqlite.so
     sqlite3.so
     pdo_sqlite.so

OR

     mysql.so
     mysqli.so
     pdo_mysql.so

now restart httpd (Apache) and open http://localhost in your browser.
You should now be able to create a user account and follow the
installation wizard.

Custom configurations
---------------------

> Filesize Limitations

With the default configuration ownCloud only allows the upload of
filesizes less than 2MB. This can be changed by changing the following
line in /etc/php/php.ini to your liking.

As of version 4.0 this is no longer necessary! The maximum upload size
is now set via the ownCloud gui

     upload_max_filesize = 2M

As of version 4.5, upload limits are set in
/usr/share/webapps/owncloud/.htaccess. This won't work if PHP is set up
to run as CGI, so you need to change the limits in /etc/php/php.ini. You
also need to change open_basedir.

     upload_max_filesize = 512M
     post_max_size = 512M
     memory_limit = 512M
     open_basedir = /srv/http/:/home/:/tmp/:/usr/share/pear/:/usr/share/webapps/

> Running owncloud in a subdirectory

By including the default owncloud.conf in httpd.conf, owncloud will take
control of port 80 and your localhost domain. If you would like to have
owncloud run in a subdirectory, then skip the 'Include
/etc/httpd/conf/extra/owncloud.conf' line altogether and just use a
symbolic link like so:

    ln -s /usr/share/webapps/owncloud/ /srv/http/

In that case, you'll also have to ensure /usr/share/webapps is in the
open_basedir line of php.ini, and that per-directory .htaccess files are
read by apache.

(Alternatively, you could follow the standard procedure, but comment out
the VirtualHost part of the include file, and skip the
symlink/basedir/htaccess part.)

Filling ownCloud with data
--------------------------

> Small Files

WebDav

Always use WebDAV or the web interface to add new files to your
ownCloud. Otherwise they will not show up correctly, as they do not get
indexed right. No further configuration is necessary to enable WebDAV
uploads in ownCloud.

Consider installing and enabling php-apc to speed up WebDAV.

SABnzbd

When using SABnzbd, you might want to set

    folder_rename 0

in your sabnzbd.ini file, because ownCloud will scan the files as soon
as they get uploaded, preventing SABnzbd from removing UNPACKING
prefixes etc.

> Big Files

WebDAV isn't suitable for big files, because it fills up all the RAM and
CPU.

With the current version, it looks like, there is no good way of copying
huge amounts of data to your ownCloud.

  
 Here's a Workaround:

copy the files directly to your ownCloud and do a full re-scan of your
database (you could use the Re-scan filesystem add-on for example).

  
 But beware that this will not work as easily in the future, when
end-to-end encryption gets added to ownCloud (this is a planned
feature).

Important Notes
---------------

-   When using a subdomain (like cloud.example.xxx), make sure it is
    covered by your certificate. Otherwise, connection via the owncloud
    client or webdav might fail.

-   If you are planning on using OwnCloud's sync-clients, make sure to
    have NTP installed and running on your OwnCloud server, otherwise
    the sync-clients will fail.

-   Add some SSL encryption to your connection!

Nginx + uwsgi_php alternative
-----------------------------

You can avoid the use of Apache, and run owncloud in it's own process by
using the wsgi_php application server. uWSGI itself has a wealth of
features to limit the resource use, and to harden the security of the
application, and by being a separate process it can run under its own
user.

The nginx config is:

    #this is to avoid Request Entity Too Large error
    client_max_body_size 1000M;
    # deny access to some special files
    location ~ ^/(data|config|\.ht|db_structure\.xml|README) {
        deny all;
    }
    # pass all .php or .php/path urls to uWSGI
    location ~ ^(.+\.php)(.*)$ {
        include uwsgi_params;
        uwsgi_modifier1 14;
        uwsgi_pass 127.0.0.1:3001;
    }
    # everything else goes to the filesystem,
    # but / will be mapped to index.php and run through uwsgi
    location / {
        root /usr/share/webapps/owncloud;
        index index.php;
    }

The uWSGI /etc/uwsgi/owncloud.ini config file (run it with uwsgi_php
--ini /etc/uwsgi/owncloud.ini):

    [uwsgi]
    socket = 127.0.0.1:3001
    master = true
    chdir = /srv/http/owncloud
    php-docroot = /usr/share/webapps/owncloud
    php-index = index.php

    # only allow these php files, I don't want to inadvertently run something else
    php-allowed-ext = /index.php
    php-allowed-ext = /public.php
    php-allowed-ext = /remote.php
    php-allowed-ext = /cron.php
    php-allowed-ext = /status.php
    php-allowed-ext = /settings/apps.php
    php-allowed-ext = /core/ajax/update.php
    php-allowed-ext = /core/ajax/share.php
    php-allowed-ext = /core/ajax/requesttoken.php
    php-allowed-ext = /core/ajax/translations.php
    php-allowed-ext = /search/ajax/search.php
    php-allowed-ext = /search/templates/part.results.php
    php-allowed-ext = /settings/admin.php
    php-allowed-ext = /settings/users.php
    php-allowed-ext = /settings/personal.php
    php-allowed-ext = /settings/help.php
    php-allowed-ext = /settings/ajax/getlog.php
    php-allowed-ext = /settings/ajax/setlanguage.php
    php-allowed-ext = /settings/ajax/setquota.php
    php-allowed-ext = /settings/ajax/userlist.php
    php-allowed-ext = /settings/ajax/createuser.php
    php-allowed-ext = /settings/ajax/removeuser.php
    php-allowed-ext = /settings/ajax/enableapp.php
    php-allowed-ext = /core/ajax/appconfig.php

    php-set = date.timezone=Europe/Skopje
    php-set = open_basedir=/srv/http/owncloud:/tmp/:/usr/share/pear/:/usr/share/webapps/owncloud

    processes = 10
    cheaper = 2
    cron = -1 -1 -1 -1 -1 /usr/bin/curl -H https://localhost/cron.php

Finally, a simple systemd unit file to start the uwsgi instance can be
(this is without using the emperor):

    [Unit]
    Description=OwnCloud service via uWSGI-PHP

    [Service]
    User=http
    ExecStart=/usr/bin/uwsgi_php --ini /etc/uwsgi/owncloud.ini
    ExecReload=/bin/kill -HUP $MAINPID
    KillSignal=SIGQUIT
    Restart=always

    [Install]
    WantedBy=multi-user.target

  

Troubleshooting
---------------

> Self-Signed certificate not accepted

OwnCloud uses Wikipedia:cURL and Wikipedia:SabreDAV to check if WebDAV
is enabled. If you use a SSL/TLS with a self-signed certificate, e.g. as
shown in LAMP and access ownClouds admin panel, you will see the
following error message:

    Your web server is not yet properly setup to allow files synchronization because the WebDAV interface seems to be broken.

In order to circumvent this problem a few solutions are available. One
is to turn off the VERYFIPEER-parameter in cURL which is strongly
discouraged as it will effectively render any encryption useless (see:
https://github.com/owncloud/core/issues/1909#issuecomment-14107259).

A better way is to trust your own certificate. Assuming that you
followed the LAMP-tutorial, execute the following steps:

Create local directory for non-distribution certificates and copy LAMPs
certificate there. This will prevent ca-certificates-updates to
overwrite it.

    $ mkdir -p /usr/local/share/ca-certificates
    $ cp /etc/http/conf.d/server.crt /usr/local/share/ca-certificates/WWW.EXAMPLE.COM.crt

Add WWW.EXAMPLE.COM.crt to /etc/ca-certificates.conf:

    WWW.EXAMPLE.COM.crt
    [..]

Now, regenerate your certificate store:

    $ update-ca-certificates

Restart the httpd service to activate your certificate.

    $ systemctl restart httpd.service

> Can't create data directory (/path/to/dir)

Check your httpd conf file (like owncloud.conf). Add your data dir to

    php_admin_value open_basedir "/srv/http/:/home/:/tmp/:/usr/share/pear/:/usr/share/webapps/:/path/to/dir/"

Restart the httpd service to activate the change.

    # systemctl restart httpd.service

Retrieved from
"https://wiki.archlinux.org/index.php?title=Owncloud&oldid=254145"

Category:

-   Web Server
