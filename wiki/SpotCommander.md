SpotCommander
=============

SpotCommander is an open source web-based remote control for the
GNU/Linux version of Spotify. The application is written in PHP and
HTML5, and thus optimized especially for mobile devices, like
smartphones or tablets. It has a visual appealing, responsive and
intuitive user interface.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Features                                                           |
| -   2 Installation                                                       |
|     -   2.1 Preconditions                                                |
|         -   2.1.1 Install Apache web server                              |
|         -   2.1.2 Configuration of Apache                                |
|         -   2.1.3 Other required packages                                |
|                                                                          |
|     -   2.2 Install SpotCommander                                        |
|     -   2.3 Add daemon to startup (optional)                             |
|     -   2.4 Configuration (optional)                                     |
|                                                                          |
| -   3 Usage                                                              |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Features
--------

The application offers amongst others the following features:

-   Launch and quit Spotify
-   Now playing
-   Control playback
-   Change Spotify's volume
-   Toggle shuffle and repeat
-   Browse playlists, albums and starred items
-   Search for tracks
-   Recently played
-   Queue
-   Gestures
-   Keyboard shortcuts

Installation
------------

Note:This must be done as root.

> Preconditions

Install Apache web server

-   To be able to use SpotCommander, it is neccessary to have an Apache
    web server installed on the device, which should be controlled
    remotely later. Apache and PHP can be installed this way:

     $ pacman -S apache php php-apache

See the LAMP article for more detailed information about Apache.

Configuration of Apache

-   Configure Apache. In /etc/httpd/conf/httpd.conf add:

    AddType text/cache-manifest .appcache

    <Directory "/srv/http/spotcommander">
    AllowOverride All
    ExpiresActive On
    ExpiresByType text/cache-manifest "access plus 0 seconds"
    </Directory>

-   To be able to run the application, the sqlite extension of PHP is
    required. First, install the package:

     $ pacman -S php-sqlite

-   Now edit the php configuration in /etc/php/php.ini:

     $ nano /etc/php/php.ini

-   Comment out the following lines, to enable the needed extensions:

     extension=curl.so
     ...
     extension=openssl.so
     ...
     extension=pdo_sqlite.so
     ...
     extension=sqlite3.so

Note:Make sure you have the openssl package installed.

-   Restart Apache:

     $ systemctl restart httpd.service

-   It is neccessary to give Apache access to /tmp. Search in
    /usr/lib/systemd/system/httpd.service for the line PrivateTmp=true
    and change it as follows:

     PrivateTmp=false

To make this change take effect, a reboot is needed.

Other required packages

-   In addition the following packages need to be installed:

     $ pacman -S qt4 inotify-tools xautomation wmctrl 

> Install SpotCommander

-   Go into the web server root directory:

     $ cd /srv/http/

-   Download the tar.bz2 file:

     $ wget -N http://www.olejon.net/code/spotcommander/files/spotcommander-8.6.tar.bz2

-   Extract the tar.bz2 file:

     $ tar -jxvf spotcommander-8.6.tar.bz2

-   Remove the tar.bz2 file:

     $ rm spotcommander-8.6.tar.bz2

-   Go into the spotcommander folder:

     $ cd spotcommander

-   Set the correct file permissions:

     $ chmod 755 . && chmod 755 bin/* && chmod 777 cache/* && chmod -R 777 db/ && chmod 666 run/*

-   Create a symlink, to be able to execute the SpotCommander daemon:

     $ ln -fs $(pwd)/bin/spotcommander /usr/local/bin/spotcommander

-   Start the daemon. Run this command in a desktop terminal as the
    desktop user running Spotify:

     $ spotcommander start

-   If you have followed the instructions carefully, you should be able
    to open SpotCommander under http://localhost/spotcommander now.

> Add daemon to startup (optional)

Create the file /etc/xdg/autostart/spotcommander.desktop and add:

    [Desktop Entry]
    Type=Application
    Name=SpotCommander
    Exec=spotcommander start

> Configuration (optional)

It is not necessary to configure anything, but in the config.php file
there are some options you can change.

Usage
-----

After you have set up the server successfully, every device in your
local network should be able to access SpotCommander under the ip adress
of the server. For example, if the server would have the ip
192.168.0.24:

     http://192.168.0.24/spotcommander/

To find out your current ip adress, execute the following:

     ip addr

If you cannot access the server, make sure, that apache is accessible by
other hosts in the LAN. Check in /etc/httpd/conf/httpd.conf to what
hosts it is listening to. The line should look like this:

     Listen 80

See also
--------

-   Official web site with more detailed information

Retrieved from
"https://wiki.archlinux.org/index.php?title=SpotCommander&oldid=255820"

Category:

-   Audio/Video
