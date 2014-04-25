Surfraw
=======

surfraw provides a fast UNIX command line interface to a variety of
popular WWW search engines. Surfraw was originally created by Julian
Assange.

Contents
--------

-   1 Installation
-   2 Configuration
-   3 Usage
-   4 Troubleshooting
    -   4.1 /usr/bin/surfraw: line 487: <url>: No such file or directory

Installation
------------

Install surfraw from the official repositories.

Configuration
-------------

Surfraw uses the default browser to open the result. The behaviour can
be customized via ~/.surfraw.conf

    SURFRAW_graphical_browser=/usr/bin/chromium
    #SURFRAW_text_browser=/usr/bin/elinks
    SURFRAW_graphical=yes

Usage
-----

Surfraw consists of a collection of shell scripts, called elvi, each of
which searches a specific web site.

To see the list of elvi type:

    surfraw -elvi

You can call surfraw in full, or the shortened form:

    sr duckduckgo Archlinux 

You can also add surfraw to your $PATH to call the elvi directly.

There are over 100 elvi available for searching the web, e.g. from
amazon:

    surfraw amazon -search=books -country=en -q Stanislaw Lem 

To search the aur:

    sr aur yaourt

To search this wiki:

    sr archwiki surfraw

For a full list of web site search scripts see: List of Elvi

Troubleshooting
---------------

> /usr/bin/surfraw: line 487: <url>: No such file or directory

If you get a error message like this:

    $ sr google foo
    /usr/bin/surfraw: line 487: http://www.google.com/search?q=foo&num=30: No such file or directory

That happens because you haven't specified a browser. Add your graphical
browser's location to config file, like this:

    /etc/xdg/surfraw/conf

    def SURFRAW_graphical_browser /usr/bin/firefox

Retrieved from
"https://wiki.archlinux.org/index.php?title=Surfraw&oldid=302662"

Categories:

-   Internet applications
-   Search

-   This page was last modified on 1 March 2014, at 04:30.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
