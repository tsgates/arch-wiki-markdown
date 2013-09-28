Streaming media
===============

Businesses are storing their data on the network for ages now, but the
past few years, there has been a trend in home networking to put all
content on a central server and distributing it to the home computers
and dedicated appliances on the network. This page offers an overview of
the possible packages to stream digital media (video, audio and images,
and in several cases also online content) from your server to your
clients.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Serverside                                                         |
|     -   1.1 Using a uPNP or DLNA-compliant server                        |
|         -   1.1.1 Generic instructions                                   |
|         -   1.1.2 Mediatomb                                              |
|         -   1.1.3 minidlna                                               |
|         -   1.1.4 Fuppes [1]                                             |
|         -   1.1.5 uShare                                                 |
|         -   1.1.6 Coherence [2]                                          |
|         -   1.1.7 PS3 Mediaserver [3]                                    |
|         -   1.1.8 Universal Media Server                                 |
|         -   1.1.9 Rygel [5]                                              |
|                                                                          |
|     -   1.2 Using other software                                         |
|         -   1.2.1 MPD                                                    |
|                                                                          |
| -   2 Clientside                                                         |
|     -   2.1 uPNP / DLNA                                                  |
|     -   2.2 Using other software                                         |
|         -   2.2.1 MPD: MPC                                               |
+--------------------------------------------------------------------------+

Serverside
----------

> Using a uPNP or DLNA-compliant server

Generic instructions

-   Your server should be set up to use multicasting. This will ensure
    that your clients will always find the server automatically on the
    network:

-   Setting it up manually in /etc/rc.conf:

    ROUTES=(!gateway multicast)
    gateway=""
    multicast="-net 239.0.0.0 netmask 255.0.0.0 eth0"

-   Using avahi and mdns

-   Some of the hereafter mentioned software packages do not get along
    together. If you are experiencing problems, make sure you are not
    running two of them at the same time.

Mediatomb

See MediaTomb

minidlna

See Minidlna

Fuppes [1]

uShare

See uShare

Coherence [2]

Fairly new server, implemented in Python. Should be handling transcoding
in the svn-version. Looked very promising, but development seems to have
stalled somehow.

PS3 Mediaserver [3]

See PS3 Mediaserver

Universal Media Server

A DLNA-compliant UPnP Media Server [4]

Rygel [5]

Server and client based on GUPnP and written in Vala - will be used in
Gnome 3.0

> Using other software

MPD

See article at Mpd

Clientside
----------

The VLC media player includes a Universal Plug'n'Play module and can
browse and play from a server.

> uPNP / DLNA

> Using other software

MPD: MPC

Retrieved from
"https://wiki.archlinux.org/index.php?title=Streaming_media&oldid=244548"

Category:

-   Networking
