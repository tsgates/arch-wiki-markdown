Elinks
======

ELinksis an advanced and well-established feature-rich text mode web
(HTTP/FTP/..) browser. ELinks can render both frames and tables, is
highly customizable and can be extended via Lua or Guile scripts. It
features tabs and some support for CSS.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing                                                         |
| -   2 Usage                                                              |
| -   3 Configuration                                                      |
| -   4 ToDo                                                               |
+--------------------------------------------------------------------------+

Installing
----------

ELinks is available in the [community] repository.

    # pacman -S elinks

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

ToDo
----

Passing Youtube-links through external player

Basic scripting and CSS

Retrieved from
"https://wiki.archlinux.org/index.php?title=Elinks&oldid=206944"

Category:

-   Web Browser
