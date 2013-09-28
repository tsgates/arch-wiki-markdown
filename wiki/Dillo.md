Dillo
=====

Dillo is a multi-platform graphical web browser known for its speed and
small footprint.

-   Dillo is written in C and C++.
-   Dillo is based on FLTK2, the Fast Light Toolkit (statically-linked
    by default!).
-   Dillo is free software made available under the terms of the GNU
    General Public License (GPLv3).
-   Dillo strives to be friendly both to users and developers.
-   Dillo helps web authors to comply with web standards by using the
    bug meter.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installing                                                         |
| -   2 Starting                                                           |
| -   3 Configuration                                                      |
|     -   3.1 Enabling cookies in Dillo by default                         |
|                                                                          |
| -   4 Removing cookies                                                   |
| -   5 See also                                                           |
+--------------------------------------------------------------------------+

Installing
----------

Install dillo, available in the Official Repositories.

Starting
--------

You can start Dillo using dillo command.

Configuration
-------------

> Enabling cookies in Dillo by default

Cookies are disabled by default for privacy reasons. If you want to
enable them, read FAQ entry

Removing cookies
----------------

First, stop your plugins (dpis) with the following command:

    $ dpidc stop

The cookies dpi will write any permanent (ACCEPT) cookies to disk, and
temporary (ACCEPT_SESSION) cookies will be lost as the dpi exits.

Second, get rid of the permanent cookies by removing or editing your
~/.dillo/cookies.txt file. Info from http://www.dillo.org/FAQ.html#q8 .

See also
--------

-   Dillo Home Page

Retrieved from
"https://wiki.archlinux.org/index.php?title=Dillo&oldid=206667"

Category:

-   Web Browser
