Moodle
======

From Wikipedia:

Moodle (abbreviation for Modular Object-Oriented Dynamic Learning
Environment) is a free source e-learning software platform, also known
as a Course Management System, Learning Management System, or Virtual
Learning Environment (VLE).

This article describes how to set up the Moodle server on an Arch Linux
system. Usage is not covered. For more help visit its home page.

Contents
--------

-   1 Install the LAMP Stack
-   2 Download and install Moodle
-   3 Preconfiguration
    -   3.1 File access
    -   3.2 Create the MoodleData Directory
    -   3.3 Configure PHP extension
    -   3.4 Restart Apache
-   4 Installation
-   5 See also
-   6 External links

Install the LAMP Stack
----------------------

Follow the instructions to install LAMP here.

Download and install Moodle
---------------------------

Download the most current version of Moodle from
http://download.moodle.org/ - this installation was done with 2.3.1+,
and there may be minor changes to the install routine in later versions.

Unzip it into /srv/http:

    # tar xzvf moodle-latest-23.tgz -C /srv/http

Make it read/writeable by Apache:

    # chown -R http:http /srv/http/moodle

Preconfiguration
----------------

Some changes need to be made to the default setup so Moodle will work.

> File access

Add /srv to /etc/php/php.ini:

    open_basedir = /srv/http/:/home/:/tmp/:/usr/share/pear/:/srv/

This allows PHP to access the /srv/moodledata directory (thanks to forum
user "Ravenman") for this fix.

> Create the MoodleData Directory

This needs to be readable and writeable by Apache:

    # mkdir /srv/moodledata
    # chown http:http /srv/moodledata

> Configure PHP extension

Install php-intl and php-gd:

    # pacman -S php-intl php-gd

Uncomment the following lines in /etc/php/php.ini (remove the semicolon
from the start of the line):

    extension=curl.so
    extension=gd.so
    extension=gettext.so
    extension=iconv.so
    extension=intl.so
    extension=mysqli.so
    extension=openssl.so
    extension=soap.so
    extension=xmlrpc.so
    extension=zip.so

> Restart Apache

You now need to restart Apache to make these changes current. Note that
if you get any errors while installing Moodle, and make subsequent
changes, you will need to restart Apache after each set of changes.

    # rc.d restart httpd

Installation
------------

Go to http://localhost/moodle/install.php - this starts the Moodle
installer. There then follows a sequence of configuration screens, most
of which should be left at the defaults.

-   Select the language

-   You should pass the first page of tests (PHP Settings). If not check
    you installed libGD, the most likely problem.

-   Leave the default locations as they are. An error here is likely to
    be a data directory problem - check the directory exists, that it
    has the right ownership and that open_basedir in /etc/php/php.ini is
    set correctly.

-   On the MySQL Screen, enter the user (root) and that user's password
    in the screen. If you get an error here, go to the test.php created
    when you set up the LAMP stack and check mysql is working, and also
    check the passwords.

-   On the Environment screen, you should pass all the tests - if not
    the errors give you a clue what is missing - an uninstalled program
    or a failure to uncomment one of the lines in /etc/php/php.ini

-   If you are English, you do not need to download language packs.

-   If the config.php has failed - probably because of lack of write
    access to the moodle subdirectory - the most likely reason is the
    ownership of the /srv/http/moodle structure which should be
    http:http - this was set earlier but you might have skipped that
    bit.

-   The remainder of the install should be automatic. It takes 2 or 3
    minutes on my computer to set up all the SQL Databases and so on.

-   The final page allows you to set up the administrator user for
    Moodle. You need to enter a password, name and set the country as a
    bare minimum. Don't forget the password !

Happy Moodling !

See also
--------

-   MySQL - Article for MySQL
-   LAMP - Self contained web-server that supports PHP, Perl, and MySQL

External links
--------------

-   http://www.moodle.org/
-   http://www.apache.org/
-   http://www.php.net/
-   http://www.mysql.com/

Retrieved from
"https://wiki.archlinux.org/index.php?title=Moodle&oldid=240818"

Category:

-   Web Server

-   This page was last modified on 19 December 2012, at 00:44.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
