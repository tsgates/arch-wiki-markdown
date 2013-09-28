Adminer
=======

Adminer is a simple tool for database management. It's possible to
manage MySQL, PostgreSQL, Sqlite3, MS SQL and Oracle. It's a simpler
alternative to PhpMyAdmin. More pieces of information about this project
you can find at official page or wikipedia.

Installation under Apache
-------------------------

-   Ensure you do not have an older copy of adminer.

    $ rm -r /srv/http/adminer

-   To install adminer just simply run yaourt:

    $ yaourt -S adminer

-   After installation it's neccessary to add following line to
     /etc/httpd/conf/httpd.conf:

    Include conf/extra/httpd-adminer.conf

It can be done by running:

    # echo "Include conf/extra/httpd-adminer.conf" >> /etc/httpd/conf/httpd.conf

-   After it restart your apache daemon. If you are using systeminit
    run :

    # rc.d restart httpd

-   And if you are using systemd run :

    # systemctl restart httpd

Note: The Adminer can be accessed by your browser on
http://localhost/adminer

External links
--------------

-   Official Adminer webpage
-   Adminer on AUR
-   Author's weblog
-   Adminer on Wikipedia

Retrieved from
"https://wiki.archlinux.org/index.php?title=Adminer&oldid=243650"

Category:

-   Web Server
