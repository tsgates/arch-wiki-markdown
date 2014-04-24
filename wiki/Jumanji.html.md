Jumanji
=======

jumanji is a web browser that provides a minimalistic and space saving
interface as well as an easy usage that mainly focuses on keyboard
interaction like vimperator does.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 config.h
    -   2.2 rc file configuration
-   3 Commands
    -   3.1 Look and feel
    -   3.2 Page navigation
    -   3.3 Zooming
    -   3.4 Searching
    -   3.5 Bookmarks and history
    -   3.6 Link following
    -   3.7 Tabs
    -   3.8 Exit
-   4 See also

Installation
------------

Install one of jumanji variants from the AUR:

-   jumanji - Stable release.
-   jumanji-git - Development release.
-   jumanji-git-gtk2 - Development release using old GTK+ 2 libraries.

Configuration
-------------

> config.h

To modify config.h:

-   get jumanji-git PKGBUILD from AUR
-   makepkg
-   git --git-dir src/jumanji/ init
-   change src/jumanji/config.def.h
-   makepkg -e

> rc file configuration

jumanji allows for a lot of user configuration either by modifying the
config.def.h file or through a rc file located at
~/.config/jumanji/jumanjirc. you can set searchengines, homepages,
custom stylesheets, user scripts, proxy. Change the default download
directory and much more. A sample configuration file below shows how to
customize jumanji.

    # jumanji configuration
    # search engines
    searchengine ggl http://www.google.com/search?q=%s
    searchengine wiki http://en.wikipedia.org/w/index.php?search=%s
    # browser settings
    set homepage http://www.google.com/ig
    set auto_save 60
    set single_instance false
    # Use privoxy for adblocking
    set proxy localhost:8118 
    # look n feel
    set font monospace normal 9
    set stylesheet file:///home/inxs/.config/jumanji/style.css 
    # follow hints
    script ~/.config/jumanji/scripts/hinting.js
    # downloads
    set download_dir ~/downloads/
    set download_command urxvt -e sh -c "wget --load-cookies ~/.config/jumanji/cookies '%s' -O '%s'";
    # keybindings
    map <C-,> nav_history previous
    map <C-.> nav_history next
    bmap ^DD$ quit

Commands
--------

Below are some basic commands that can be used with jumanji

> Look and feel

    C-m       = Toggle status bar
    C-n       = Toggle tab bar

> Page navigation

    o         = enter url to open in same tab
    t         = enter url to open in new tab
    j         = scroll down
    k         = scroll up
    h         = scroll left
    l         = scroll right
    C-d       = scroll down (half the screen)
    C-u       = scroll up (half the screen)
    space     = page down
    gg        = beginning
    G         = end
    C-o       = back
    C-i       = forward
    :stop     = stop
    r         = reload

> Zooming

    zI        = zoom_in
    zO        = zoom_out
    z0        = zoom to original size

> Searching

    /        = search %s
    ?        = search reverse %s
    :open    = start a search with your search engine %s (the first one in your jumanjirc is used)

> Bookmarks and history

    :bmark   = insert bookmark (bookmarks are saved in ~/.config/jumanji/bookmarks)
    o <tab>  = show bookmarks and history to open in same tab
    t <tab>  = show bookmarks and history to open in new tab

> Link following

    f        = spawn numbers next to each hyperlink. Type the number after typing f to follow the link in the same tab [1]
    F        = spawn numbers next to each hyperlink. Type the number after typing F to follow the link in a new tab
    gh       = Go to homepage in the same tab
    gH       = open homepage in a new tab
    gf, C-s  = view source
    gF       = view source in a new tab

> Tabs

    gt  or C-Tab   or   S-k   = go to next tab
    gT  or C-S-Tab or   S-j   = go to previous tab
    xgt                       = go to tab number x, where x is any number 0-9
    C-w                       = close tab

> Exit

    ZZ        = exit
    C-q       = exit

See also
--------

-   Old, closed forum thread
-   The current forum thread

Retrieved from
"https://wiki.archlinux.org/index.php?title=Jumanji&oldid=275152"

Category:

-   Web Browser

-   This page was last modified on 12 September 2013, at 11:58.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
