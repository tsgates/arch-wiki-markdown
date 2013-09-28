MythWeb
=======

MythWeb is a web interface for MythTV

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Link to the Video Directory                                  |
|                                                                          |
| -   2 Configuration                                                      |
|     -   2.1 MythWeb                                                      |
|     -   2.2 Apache                                                       |
|     -   2.3 PHP                                                          |
|                                                                          |
| -   3 Using MythWeb                                                      |
| -   4 Securing MythWeb                                                   |
| -   5 Troubleshooting                                                    |
| -   6 External Links                                                     |
+--------------------------------------------------------------------------+

Installation
------------

Install MythWeb

    # pacman -S mythplugins-mythweb

You will also need to install php-apache, the MythWeb package has not
yet been updated to depend on this.

    # pacman -S php-apache

> Link to the Video Directory

MythWeb looks in the video_dir directory for MythTV recordings. You will
need to create a link to the folder where your MythTV recordings are
stored.

    # ln -s <recording_dir> /srv/http/mythweb/video_dir

Configuration
-------------

> MythWeb

Copy the MythWeb configuration file mythweb.conf to the Apache
configuration directory.

    # cp /srv/http/mythweb/mythweb.conf.apache   /etc/httpd/conf/extra/mythweb.conf

Edit mythweb.conf to point it to the correct installation directory
(near the beginning of the file).

    <Directory "/srv/http/mythweb" >

Then check that the configuration matches your MythTV setup. If you have
changed the database login or password you will need to change the
following section.

    setenv db_server        "localhost"
    setenv db_name          "mythconverg"
    setenv db_login         "mythtv"
    setenv db_password      "mythtv"

> Apache

Edit the Apache configuration file /etc/httpd/conf/httpd.conf

Uncomment (or add) the line

    LoadModule php5_module modules/libphp5.so

Insert the following two lines in the Supplemental Configuration section
of httpd.conf, it's found towards the end of the file.

    Include conf/extra/php5_module.conf
    Include conf/extra/mythweb.conf

> PHP

Edit the PHP configuration file /etc/php/php.ini

Uncomment the following lines in the Dynamic extensions section.

    extension=mysql.so
    extension=posix.so

Make sure open_basedir contains /srv/http/ to allow file operation in
the MythWeb directory. Starting with MythTV 0.23, you will also need to
permit access to /usr/share/mythtv/.

    open_basedir = /srv/http/:/home/:/tmp/:/usr/share/pear/:/usr/share/mythtv/

Enable the allow_url_fopen option for MythWeb's status page to work.

    allow_url_fopen = On

Using MythWeb
-------------

You can now start the Apache daemon, mythbackend must already be
running.

    /etc/rc.d/httpd start

Open MythWeb in your browser.

    http://localhost/mythweb

Securing MythWeb
----------------

It is also probably a good idea to set up password protection for
MythWeb if you intend to allow connections from the Internet. To enable
authentication open the /etc/httpd/conf/extra/mythweb.conf file and
uncomment the authentication section (near the beginning):

    AuthType           Digest
    AuthName           "MythTV"
    AuthUserFile       /var/www/htdigest
    Require            valid-user
    BrowserMatch       "MSIE"      AuthDigestEnableQueryStringHack=On
    Order              allow,deny
    Satisfy            any

Now we need to fix the configuration to match how we have MythWeb set
up, change the AuthUserFile so it reads

    AuthUserFile       /etc/httpd/conf/extra/httpd-passwords

If you do not want to access MythWeb from IE you can delete the
BrowserMatch line.

You also probably do not want to have to enter your password when you're
connecting from your local computer, so add the following line between
the last two lines:

    Allow from 127. 192.168.1.

This will cause passwordless access from both your local machine AND
your local network (provided you're using the 192.168.1.0 255.255.255.0
subnet)

Your config should now look something like:

    AuthType           Digest
    AuthName           "MythTV"
    AuthUserFile       /etc/httpd/conf/extra/httpd-passwords
    Require            valid-user
    Order              allow,deny
    Allow from 127. 192.168.1.
    Satisfy            any

Save the file. Now we'll create the httpd-passwords file,

    # htdigest -c /etc/httpd/conf/extra/httpd-passwords MythTV MYUSER

Where MYUSER is the username you want to use to access MythWeb. Enter
the login password when prompted.

If you need more users:

    # htdigest /etc/httpd/conf/extra/httpd-passwords MythTV MYUSER

NOTE: No -c after initial user, otherwise you will overwrite the current
file.

Now all we need to do now is restart the apache server for the changes
to take effect.

    # /etc/rc.d/httpd restart

Troubleshooting
---------------

If you get a 403 Forbidden error, recheck your paths in mythweb.conf

External Links
==============

-   MythTV Wiki page on MythWeb

Retrieved from
"https://wiki.archlinux.org/index.php?title=MythWeb&oldid=197902"

Category:

-   Audio/Video
