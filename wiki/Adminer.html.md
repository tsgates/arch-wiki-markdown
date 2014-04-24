Adminer
=======

Adminer is a simple tool for database management. It's possible to
manage MySQL, PostgreSQL, Sqlite3, MS SQL and Oracle. It's a simpler
alternative to PhpMyAdmin. You can find more pieces of information about
this project at official page or Wikipedia.

Installation under Apache
-------------------------

Ensure you do not have an older copy of Adminer:

    $ rm -r /srv/http/adminer

Install adminer from the AUR and add the following line to
 /etc/httpd/conf/httpd.conf:

    Include conf/extra/httpd-adminer.conf

Then restart your apache daemon.

    # systemctl restart httpd

Note:The Adminer can be accessed by your browser on
http://localhost/adminer.

In case there is an (403) error, change the following lines inside the
/etc/httpd/conf/extra/httpd-adminer.conf file:

    Alias /adminer "/usr/share/webapps/adminer"
           <Directory "/usr/share/webapps/adminer">
                   AllowOverride All
                   Require all granted
           #php_admin_value open_basedir      "/srv/:/tmp/:/usr/share/webapps/:/etc/webapps:/usr/share/pear/"
    </Directory>

Restart the restart apache daemon again.

    # systemctl restart httpd

See also
--------

-   Official Adminer webpage
-   Author's weblog

Retrieved from
"https://wiki.archlinux.org/index.php?title=Adminer&oldid=305192"

Category:

-   Web Server

-   This page was last modified on 16 March 2014, at 19:13.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
