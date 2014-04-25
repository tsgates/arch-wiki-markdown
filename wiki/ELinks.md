ELinks
======

ELinksis an advanced and well-established feature-rich text mode web
(HTTP/FTP/..) browser. ELinks can render both frames and tables, is
highly customizable and can be extended via Lua or Guile scripts. It
features tabs and some support for CSS.

Contents
--------

-   1 Installing
-   2 Usage
-   3 Configuration
-   4 Using ELinks with Tor
-   5 ToDo

Installing
----------

elinks is available from the official repositories.

Usage
-----

Start elinks with

    elinks

or, if you want to start a specific website:

    elinks foo.bar.org

Some basic keys are

    g Open URL-dialog
    t Open new tab
    > Change tab
    c Close current tab
    Esc Show toolbar

Configuration
-------------

ELinks is capable of using external programs for various tasks, one of
them is showing pictures. The %-sign is handled as filename (or URL).

    ~/.elinks/elinks.conf

    set mime.extension.jpg="image/jpeg"
    set mime.extension.jpeg="image/jpeg"
    set mime.extension.png="image/png"
    set mime.extension.gif="image/gif"
    set mime.extension.bmp="image/bmp"

    set mime.handler.image_viewer.unix.ask = 1
    set mime.handler.image_viewer.unix-xwin.ask = 0
     
    set mime.handler.image_viewer.unix.block = 1
    set mime.handler.image_viewer.unix-xwin.block = 0 
     
    set mime.handler.image_viewer.unix.program = "ADDYOURTERMINALPICTUREVIEWERHERE %"
    set mime.handler.image_viewer.unix-xwin.program = "ADDYOURXPICTUREVIEWERHERE %"

    set mime.type.image.jpg = "image_viewer"
    set mime.type.image.jpeg = "image_viewer"
    set mime.type.image.png = "image_viewer"
    set mime.type.image.gif = "image_viewer"
    set mime.type.image.bmp = "image_viewer"

Using ELinks with Tor
---------------------

ELinks does not support SOCKS directly, so alternatives are to either
invoke ELinks thus torify elinks or install privoxy from the official
repositories and use it for forwarding to Tor's SOCKS proxy, first by
adding the following line to your /etc/privoxy/config:

    forward-socks5 / localhost:9050 .

Restart privoxy.service and then entering the following lines to your
~/.elinks/elinks.conf:

    set protocol.http.proxy.host = "127.0.0.1:8118"
    set protocol.https.proxy.host = "127.0.0.1:8118"

Note:The above assumes that Tor is using port 9050 and that privoxy is
listening on port 8118

ToDo
----

Passing Youtube-links through external player

Basic scripting and CSS

Retrieved from
"https://wiki.archlinux.org/index.php?title=ELinks&oldid=302405"

Category:

-   Web Browser

-   This page was last modified on 28 February 2014, at 15:02.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
