SpotCommander
=============

SpotCommander is a remote control for Spotify for Linux, optimized for
mobile devices. It's based on HTML5 & PHP, works on any device with a
modern browser, and it's free and open source.

SpotCommander is the most elegant, intuitive, feature-rich & universal
remote control for Spotify, exclusive for Linux users!

Contents
--------

-   1 Features
-   2 Option 1: Install from AUR
-   3 Option 2: Install manually
    -   3.1 Install & configure required packages
    -   3.2 Give Apache access to /tmp
    -   3.3 Reboot
    -   3.4 Install SpotCommander
    -   3.5 Try it
    -   3.6 Configuration
-   4 See also

Features
--------

-   Reponsive & intuitive user interface
-   Launch/quit Spotify
-   Now playing
-   Control playback
-   Adjust volume
-   Toggle shuffle & repeat
-   Playlists
-   Starred items
-   Search
-   Browse playlists
-   Browse albums
-   Browse artists
-   Recently played
-   Queue
-   Lyrics
-   Start track radio
-   Top lists
-   Popular playlists
-   New albums
-   Genres
-   Share to social networks
-   Gestures
-   Keyboard shortcuts
-   Android app
-   Fullscreen on iOS
-   Automatic update checking

Option 1: Install from AUR
--------------------------

SpotCommander is available in AUR, and can be installed like any other
package from AUR. The PKGBUILD automates the manual installation process
described below.

Note:If you have any kind of web server software installed on your
system already, you should install manually instead to avoid touching
your current configuration.

Option 2: Install manually
--------------------------

Note:This must be done as root.

> Install & configure required packages

-   Install required packages:

     $ pacman -S apache php php-apache php-sqlite qt4 inotify-tools xautomation wmctrl wget

-   DON NOT FORGET: Enable PHP as described in the LAMP article. Make
    sure you enable mod_mpm_prefork.

-   Enable required PHP modules. In /etc/php/php.ini, uncomment these:

     extension=curl.so
     ...
     extension=pdo_sqlite.so
     ...
     extension=posix.so
     ...
     extension=sqlite3.so

-   As root, create the file /etc/httpd/conf/extra/spotcommander.conf
    and add:

    <Directory "/srv/http/spotcommander">
    AllowOverride All
    </Directory>

Note:If you are going to install in another directory than
/srv/http/spotcommander, make sure you use the correct directory above.

-   In /etc/httpd/conf/httpd.conf, add to bottom:

    Include conf/extra/spotcommander.conf

-   Make Apache start when system boots:

     $ systemctl enable httpd.service

> Give Apache access to /tmp

-   Open /usr/lib/systemd/system/httpd.service and set:

     PrivateTmp=false

> Reboot

-   Some of the actions above require a reboot to take effect, so you
    must reboot your system now before continuing

> Install SpotCommander

-   Go into the web server root directory:

     $ cd /srv/http/

-   Download the tar.bz2 file:

     $ wget -N http://www.olejon.net/code/spotcommander/files/spotcommander-9.0.tar.bz2

-   Extract the tar.bz2 file:

     $ tar -jxvf spotcommander-9.0.tar.bz2

-   Remove the tar.bz2 file:

     $ rm spotcommander-9.0.tar.bz2

-   Go into the spotcommander folder:

     $ cd spotcommander

-   Set the correct permissions:

     $ chmod 755 . && chmod 755 bin/* && chmod 777 cache/* && chmod -R 777 db/ && chmod 666 run/*

-   Create symlink:

     $ ln -fs $(pwd)/bin/spotcommander /usr/local/bin/spotcommander

-   You must now start the daemon. Open up a desktop terminal (not SSH)
    as the desktop user running Spotify (not root), and run this
    command:

     $ spotcommander start

By running it in the terminal the first time, you will be able to see if
there are any errors.

-   You should add the daemon to your startup applications. As root,
    create the file /etc/xdg/autostart/spotcommander.desktop and add:

    [Desktop Entry]
    Type=Application
    Name=SpotCommander
    Exec=spotcommander start

> Try it

-   You should now be able to control Spotify by going to:

     http://your.computers.ip.address.or.hostname/spotcommander

-   To find your current IP address, run this command:

     $ ip addr

-   Android users should download the Android app, which can find your
    computer automatically

> Configuration

It is not necessary to configure anything, but in the config.php file
there are some options you can change.

See also
--------

-   Official website

Retrieved from
"https://wiki.archlinux.org/index.php?title=SpotCommander&oldid=304607"

Category:

-   Audio/Video

-   This page was last modified on 15 March 2014, at 12:26.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
