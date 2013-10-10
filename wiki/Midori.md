Midori
======

> Summary

This article contains information about the installation and
configuration of the Midori browser, as well as various tips and trick.

> Related

Browser Plugins

Profile-sync-daemon

UZBL-Browser

Dillo

Midori is a lightweight Webkit-based web browser developed by Christian
Dywan. It is part of the Xfce Goodies project.

Some of its features are:

-   Full integration with GTK+ 2 and GTK+ 3.
-   Fast rendering, due to the WebKitGTK+ engine.
-   Tabs, windows, and session management.
-   Flexible, configurable web search.
-   Support for user scripts and styles.
-   Straightforward bookmark management.
-   Customizable and extensible interface.
-   Common extensions such as AdBlock, form history, a speed dial, etc.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Extensions                                                         |
|     -   2.1 AdBlock                                                      |
|     -   2.2 Search engines                                               |
|     -   2.3 User scripts                                                 |
|     -   2.4 Flash Plugin                                                 |
|                                                                          |
| -   3 Tips and Tricks                                                    |
|     -   3.1 Flash Block                                                  |
|     -   3.2 Personal AdBlock filters                                     |
|                                                                          |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

A GTK+ 2 version of Midori can be installed with the package midori,
available in the official repositories.

Development versions are available in the AUR:

-   midori-gtk2-git - for the GTK+ 2 version.
-   midori-git - for the GTK+ 3 and WebKitGTK3-based version.

Extensions
----------

> AdBlock

To enable the AdBlock extensions go to Menu > Preferences > Extensions
and check the Advertisement blocker box.

The AdBlock extension from Midori uses the same lists as the AdBlock
Plus extension for Firefox so you can get more lists from the AdBlock
Plus site. You can also block specific images on various sites by
right-clicking them and choosing Block image.

> Search engines

Midori also supports search engines, much in the fashion other browsers
do. Various search engines have shortcuts so that they can be easily
used from the address bar. To manage your search engines click on the
icon in the search engine box and choose Manage Search Engines.

Of course you can do clever things with this features, such as provide
various shortcuts for various websites (not just for searching). For
example you can add another entry to the Search Engines dialog with the
token arch and the necessary information for the Arch Linux homepage.
Now you can access the Arch Linux website just by typing arch.

Another example can be to add a shortcut for an URL shortener:

-   just add a new search engine with the URL
    http://is.gd/create.php?longurl= (or another shortener with similar
    functionality).
-   set a token for it (sh here).
-   get the short URL for any link by typing:

    sh [link]

in the address bar.

> User scripts

To enable the user scripts extensions go to Menu > Preferences >
Extensions and check the User addons box. Midori's user scripts are
compatible with Firefox's Greasemonkey scripts. You can find an
extensive list of scripts on userscripts.org.

For manual installation, you have to create the folder
~/.local/share/midori/scripts and copy your scripts there. This folder
will be automatically picked up by Midori and any compatible scripts
will be loaded.

> Flash Plugin

To get the Flash plugin working in Midori you can install the
midori-flash package from AUR or follow the instructions at
Epiphany#Flash.

Tips and Tricks
---------------

> Flash Block

You can also get the common FlashBlock extension in the form of a user
script either from userscripts.org or by using the FlashBlock WannaBe
script, this script has to be installed in ~/.local/share/midori/scripts
and ~/.local/share/midori/styles, for the JavaScript file and the CSS
file, respectively.

> Personal AdBlock filters

Midori's AdBlock support is rather basic, you can only use pre-made
lists or block some images. We can get around that by creating our own
lists and telling Midori where to find them.

For this:

-   create a folder for your filters, such as
    ~/.local/share/midori/filters
-   in that folder create a file with the content you want to block:

    myadblockfilters.txt

    [Adblock]
    ! Title: Personal AdBlocker v1
    ! Last modified: 31 Oct 2012 18:14 UTC
    ! Expires: 365 days

    ! Comments are made with exclamation marks

    ! You can filter out some elements directly
    http://forums.fedoraforum.org//forum/images/smilies/smile.gif

    ! Or use wildcards to filter out a bunch of stuff at once
    http://ubuntuforums.org/images/rebrand/statusicon/subforum_*.gif

    ! Or use use DOM tags, ids or classes
    www.phoronix.com#DIV.phxcms_header_legacy
    www.phoronix.com#DIV.phxcms_bar_align

-   go to Menu > Preferences > Extensions and click the configuration
    icon of Adblock and add:

    file://.local/share/midori/filters/myadblockfilters.txt

See also
--------

-   Midori FAQ

Retrieved from
"https://wiki.archlinux.org/index.php?title=Midori&oldid=232792"

Category:

-   Web Browser
