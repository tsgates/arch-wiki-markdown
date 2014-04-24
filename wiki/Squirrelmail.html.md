Squirrelmail
============

SquirrelMail is a fantastic, lightweight, webmail solution for your
webserver. Squirrelmail provides the capability for users to access
their mail hosted on the server through a well written package with a
very good layout. It can be accessed via http or https and supports IMAP
and IMAPS capability. The SquirrelMail site is well maintained and can
generally answer all your questions. SquirrelMail promotes itself by
saying:

SquirrelMail is a standards-based webmail package written in PHP. It
includes built-in pure PHP support for the IMAP and SMTP protocols, and
all pages render in pure HTML 4.0 (with no JavaScript required) for
maximum compatibility across browsers. See:
http://squirrelmail.org/index.php

Contents
--------

-   1 Installing Squirrelmail
    -   1.1 Available Versions
    -   1.2 Install Details
-   2 Tweaks & Recommended Settings

Installing Squirrelmail
-----------------------

(An alternative and easier version is available here)

> Available Versions

SquirrelMail is available in two flavors. Version 1.4 and version 1.5.
Version 1.4 is the stable version while 1.5 is the development version.
Both are available in either a compressed tar archive or through svn.
The development version contains a newer interface and features not
found in the stable release. Plugins that extend the functionality of
both versions are available (Calendar, Spelling, etc.)

Note:I have used the development version for several years and have only
had a couple of issues which were resolved with the developer in a
matter of hours after first reporting the issue on the SquirrelMail
mailing list.

> Install Details

You will need to configure your mail package before you can use
SquirrelMail. Installing SquirrelMail is straight forward:

Note:I prefer dovecot, but you can use just about any mail package you
want. If you access your mail via secure IMAP (on port 993, etc.) and
you have disabled regular IMAP (port 143) for security reasons, then I
would avoid UW-IMAP due to difficulties in communicating with localhost
via secure IMAP.

Obtain the SquirrelMail version of choice at:
http://squirrelmail.org/download.php

Regardless of which version you download or checkout, the installation
is the same. After you have obtained the SquirrelMail package:

-   Place the contents (the entire squirrelmail directory) in your
    document root. For Arch, that will be under /srv/http (other
    distributions can be in /var/www/html, /srv/www/htdocs).
-   Create directories outside of your document root for the
    SquirrelMail "data" and "attachment" directories. Example: "mkdir -p
    /usr/local/share/sqmail/{data,attach}" which will create the
    directories under /usr/local/share/sqmail. You then must make the
    directories readable and writable by the web server. On Arch, "chown
    -R http:http /usr/local/share/sqmail
-   Configure SquirrelMail (as root) by running the perl script
    /srv/http/squirrelmail/config/conf.pl. Simply fill in the
    information specific to your configuration. Note, there are
    preconfigured setting groups for different mail packages (dovecot,
    courier, UW, etc...) This will help. If you need more help, the
    SquirrelMail site is a great resource.
-   Make sure you turn on the option under "11. tweaks" to "Allow remote
    config test" to allow you to check the configuration if you are not
    doing your configuration from localhost. (turn it off when you are
    done with all test and your satisfied with your setup)
-   You will need to modify /etc/php/php.ini to change a few setting to
    accommodate SquirrelMail. Open /etc/php/php.ini and modify the
    following settings:
    -   memory_limit = 128M  ; must be at least 32M
    -   post_max_size = 16M  ; controls the maximum attachment size
    -   open_basedir =
        /srv/http/:/srv/www:/home/:/tmp/:/usr/share/pear/:/usr/local/share/sqmail/

You simply need to add the path to your SquirrelMail data and attachment
directories, shown above as ":/usr/local/share/sqmail/"

-   Reload the webserver configuration: "/etc/rc.d/apache reload"
-   When you are done with the setting and choosing plugins in conf.pl
    and done with modifying php.ini, just point your browser to
    http://your.server.com/squirrelmail/configcheck.php to test your
    configuration. Fix any problems you encounter. When done, disable
    "Allow remote config test" in conf.pl.

Now you should be able to point your browser to
http://your.server.com/squirrelmail and login. As the exit to conf.pl
says "Happy SquirrelMailing!"

Tweaks & Recommended Settings
-----------------------------

TBD at a later time ;-)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Squirrelmail&oldid=219506"

Category:

-   Mail Server

-   This page was last modified on 24 August 2012, at 03:46.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
