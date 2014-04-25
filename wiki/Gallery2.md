Gallery2
========

Tip:There is currently a newer version of Gallery available.

Gallery2 gives you an intuitive way to blend photo management seamlessly
into your own website or simply use your site as a standalone photo
gallery.

See the LAMP page for how to install and configure an Apache server with
PHP and MySQL. Then, install the dependencies. The php-gd, imagemagick,
and ffmpeg packages are available in the repositories, while jpegtran is
in the AUR.

    pacman -S php-gd imagemagick ffmpeg

Next, download the source code for Gallery2.

    cd /tmp
    wget http://downloads.sourceforge.net/gallery/gallery-2.3.2-full.tar.gz
    tar xzf gallery-2.3.2-full.tar.gz
    sudo mv gallery2 /usr/share/webapps/

Edit /etc/httpd/conf/extra/httpd-gallery2.conf and add the following
lines:

    Alias /gallery2 "/usr/share/webapps/gallery2"
    <Directory "/usr/share/webapps/gallery2">
        AllowOverride All
        Options FollowSymlinks
        Order allow,deny
        Allow from all
    </Directory>

Then, edit /etc/httpd/conf/httpd.conf and add:

    Include conf/extra/httpd-gallery2.conf

Restart the Apache server with

     sudo /etc/rc.d/httpd restart

Once installation is complete, verify your ability to write to Gallery's
location on the server.

    sudo echo "RANDOM KEY" >> /usr/share/webapps/gallery2/login.txt

If you want maintenance to work, install the Statistics plugin:

    Set "Themes" and "Modules" folder to 755.
    Go to "Site Admin" --> "Plugins" --> "Get More Plugins"
    Then click "Update Plugin List"
    Install "Statistics" and other plugins that you had installed before upgrading.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Gallery2&oldid=210381"

Categories:

-   Graphics and desktop publishing
-   Web Server

-   This page was last modified on 19 June 2012, at 10:24.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
