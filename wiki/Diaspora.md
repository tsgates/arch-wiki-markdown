Diaspora
========

Diaspora is the privacy aware, personally controlled, do-it-all, open
source social network.

On November 23, 2010 was announced that Diaspora is in private alpha
phase.

Since August 27, 2012 Diaspora is ruled by the community (announcement).

Contents
--------

-   1 Prerequisites
-   2 Installation
-   3 Updating
-   4 Add yourself as an admin
-   5 Troubleshooting
    -   5.1 GDM login screen with Diaspora
-   6 See also

Prerequisites
-------------

-   Since Diaspora can run on MySQL and PostgreSQL you need to decide
    which one you want to use. Install one of them and set it up.
-   Diaspora starts a so called appserver, on port 3000 by default,
    which serves the dynamic contents. You need a reverse proxy to
    handle the static content that forwards requests it can't handle to
    the appserver. Typical tools for that are Apache or Nginx.
-   You'll also need the usual tools to build packages from the AUR.
-   And ruby2.0 and ruby2.0-bundler from the AUR.

Installation
------------

Obtain the diaspora package from the AUR. If you want only one database
support, modify the PKGBUILD pkgname lines accordingly.

Now edit /etc/webapps/diaspora/database.yml and fill out the needed
values. Then edit /etc/webapps/diaspora/diaspora.yml and change at least
the url setting to the URL your installation will be reachable under
(the one served by your reverse proxy). You can change the port the
appserver will listen on under the server section. By default Diaspora
requires a SSL setup, you can disable that with the require_ssl setting.

Ensure your database is running and then switch to the diaspora user:

    $ su diaspora
    $ cd

Create the database and initialize the schema:

     bundle-2.0 exec rake-2.0 db:create db:schema:load

If the user you specified in the database.yml file can't create
databases leave the 'db:create' out and create a database named
diaspora_production by hand.

You can now switch back to your regular user and start diaspora systemd
service.

The static content your reverse proxy needs to serve will be available
under /usr/share/webapps/diaspora/public/

Updating
--------

Updating is very analogous. Obtain the newest version of the package and
build it, just like in the installation instructions. Watch for .pacnew
files and review the changes. Also read the changelog over at Diaspora.
Then again ensure the database is running and switch to the diaspora
user:

     $ su diaspora
     $ cd

And update the database schema:

     bundle-2.0 exec rake-2.0 db:migrate

Exit and restart diaspora systemd service.

Add yourself as an admin
------------------------

Switch to the diaspora user and start the Rails console:

     su diaspora
     cd
     bundle-2.0 exec rails console production

Then run the following command, replacing user with your username:

     Role.add_admin User.find_by_username(user)

You can exit the Rails console by pressing Ctrl+d.

Troubleshooting
---------------

> GDM login screen with Diaspora

GDM will insert the user diaspora in its login window because it
currently considers the id range 500-1000 as normal users while Arch
considers this range for system users as defined in /etc/login.defs. GDM
does that probably to keep legacy normal users working. To exclude this
user from the login window, add this 'Exclude' line in your
/etc/gdm/custom.conf file:

    [greeter]
    Exclude=diaspora

See also
--------

-   Diaspora git

Retrieved from
"https://wiki.archlinux.org/index.php?title=Diaspora&oldid=296614"

Category:

-   Web Server

-   This page was last modified on 8 February 2014, at 21:57.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
