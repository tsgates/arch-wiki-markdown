Amarok
======

> Summary

Provides a brief overview of the quintessential KDE music player.

Related articles

Amarok 1.4

Amarok is a music player and organizer for Linux with an intuitive Qt
interface that integrates very well with KDE.

Amarok 2 has not yet and will not implement all features from Amarok
1.4[1], so if you are not satisfied with the new version and would
rather have the old one back, refer to that article.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Customization                                                      |
|     -   2.1 Integration with Gnome                                       |
|     -   2.2 Scripts and applets                                          |
|     -   2.3 Moodbar                                                      |
|                                                                          |
| -   3 SHOUTcast                                                          |
| -   4 Ampache/MP3 Streaming                                              |
| -   5 Collection database                                                |
|     -   5.1 MySQL                                                        |
|     -   5.2 PostgreSQL                                                   |
|                                                                          |
| -   6 Firefly / Daap-Share                                               |
| -   7 See Also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Amarok can be installed from the [extra] repository with pacman

    # pacman -S amarok

Amarok now depends on Phonon, so you will have to have a working
back-end selected for it. See KDE#Phonon. You may also need to install a
few codecs for use by the chosen back-end.

Customization
-------------

> Integration with Gnome

See Uniform Look for QT and GTK Applications for visual integration of
the main GUI.

> Scripts and applets

New scripts and applets can be found either directly from within Amarok
("Tools" -> "Script Manager" -> "Get More Scripts") or at kde-apps.org.

> Moodbar

The moodbar is a feature which turn your standard progress slider bar
into a progress slider bar coloured depending on the mood of your track.

Install moodbar from the AUR.

Then go to settings -> configure amarok and check "Show moodbar in
progress slider".

Please note that as of february 19th amarok 2 does NOT generate
moodfiles, you can either try to follow this tutorial [2] to create them
yourself or get amarok1 from AUR and let it generate all the .mood files
for you. For the amarok1 solution go to settings -> configure amarok,
and in the general tab check the "use moods" and "store moods data files
with music" boxes.

SHOUTcast
---------

For reasons which have not been adequately explained Amarok developers
have removed the SHOUTcast Internet radio features from version 2.1.90
onwards. See the discussion page, the forum here and the thread starting
here.

You can get back SHOUTcast by using the "SHOUTcast service" Script.
Start Amarok, go "Tools" -> "Script Manager" -> "Get More Scripts" ->
search for SHOUTcast -> install Shoutcast Service, restart Amarok. Then
you have it in "Internet" context.

Amarok 1.4 and VLC continue to support the SHOUTcast Internet radio
station index and streaming as before.

See also: How can I use Amarok to stream to my own radio station?, which
recommends Internet DJ Console, available in the AUR (idjc).

Ampache/MP3 Streaming
---------------------

if you are Streaming MP3s directly or with Ampache Plugin, you are not
able to seek in tracks if you are not using the gstreamer backend.
Install it with

    # pacman -S phonon-gstreamer gstreamer0.10 gstreamer0.10-plugins

Then go inside Amarok to "Settings" -> "Configure Amarok" -> "Playback"
-> "Configure Phonon" -> "Backend"-Tab -> make Gstreamer the prefered
Backend

Collection database
-------------------

Amarok 2.x can use sqlite (default) or mysql to store the collection
database. Users with large collections and more demanding performance
requirements might prefer use mysql.

> MySQL

For basic MySQL configuration refer to the MySQL page.

When using Amarok with MySQL you need to create a MySQL user that can
access the database. To do use, enter the following:

    # mysql -p -u root
    # CREATE DATABASE amarokdb;
    # USE amarokdb;
    # GRANT ALL ON amarokdb.* TO amarokuser@localhost IDENTIFIED BY 'password-user';
    # FLUSH PRIVILEGES;
    # quit

This creates a database called 'amarokdb' and a user with name
'amarokuser' with the password 'password-user' who can access said
database from localhost. If you want to connect to your database
computer from a different computer, change the line to

    # GRANT ALL ON amarok.* TO amarokuser@'%' IDENTIFIED BY  'password-user';

To configure amarok to use MySQL, enter the Configure Amarok screen,
choose Database and mark 'used external MySQL database'. Enter the
server (usually "localhost" if on your local box, else the name of the
remote box), the username ("amarokuser" in this example) and your chosen
password-user. Do not forget to select the path to your music
collection.

> PostgreSQL

Not yet supported, see more

Firefly / Daap-Share
--------------------

To make daap-shares visible in Amarok enable the "DAAP
Collection"-plugin in the Amarok settings.

Install nss-mdns:

    # pacman -S nss-mdns 

and complete the hosts line in /etc/nssswitch.conf to look like:

    hosts: files mdns4_minimal [NOTFOUND=return] nis dns mdns4

start avahi-daemon and add it to /etc/rc.conf:

    # /etc/rc.d/avahi-daemon start

See Also
--------

Common_Applications#Audio

Retrieved from
"https://wiki.archlinux.org/index.php?title=Amarok&oldid=238892"

Category:

-   Player
