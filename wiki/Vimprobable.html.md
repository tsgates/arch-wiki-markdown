Vimprobable
===========

Vimprobable is a WWW browser that behaves like the Vimperator plugin
available for Mozilla Firefox. It is based on the WebKit engine (using
GTK bindings). It is a fork of the currently abandoned vimpression.

Contents
--------

-   1 Install
-   2 Configuration
-   3 Tips
    -   3.1 HTML5 Video
-   4 Resources

Install
-------

There are two versions of Vimprobable in the AUR: vimprobable-git and
vimprobable2-git. Now that Vimprobable2 is at version 1.0, it is
considered the primary branch; development of Vimprobable1 will still
recieve bugfixes, but active development will be restricted to
Vimprobable2.

The first version can only be customised by editing config.h before
compilation. It is pretty stable and very usable. Version 2, while also
stable, is under more active development - it aims at allowing more
customisation, for example through :set and :map commands.

Configuration
-------------

Both versions require you to make customizations in the config.h file
before recompiling with

    $ makepkg -efi

Additionally, Vimprobable2 will look for a configuration file called
$XDG_CONFIG_HOME/vimprobable/vimprobablerc that has a number of options
that can be configured without any need to recompile. You will need to
create this file yourself.

A basic vimprobablerc might contain the following options:

    set homepage=https://bbs.archlinux.org/
    set scrollbars=false
    set fontsize=12
    set monofontsize=10
    set monofont="Droid Sans Mono Slashed"

More details on configuring Vimprobable2 can be found in the rc man page

    man vimprobablerc

Within the source directory, you will find two other files that can be
customized, config.h and keymap.h. As one would expect, the first
contains general configuration options, such as appearance and the
second allows you to set your own keybindings. Any changes to either of
these files require that Vimprobable2 be recompiled before they take
effect.

Tip:As per the post install instructions, you will need to copy these
files from the source directory to customize them.

Details for the default keybindings and options can be found in the man
page

    man vimprobable

Tips
----

Setting a more generic user agent will make accessing some websites more
straightforward. In $XDG_CONFIG_HOME/vimprobable/vimprobablerc add a
useragent for a browser that the site will find more acceptable, for
example:

    set useragent="Vimprobable2 (X11; U; Unix; en-US) AppleWebKit/531.2+ Compatible (Safari)"

You can find a list of useragents here:
http://www.useragentstring.com/pages/useragentstring.php

You can specify additional search engines in Vimprobable2's config.h
like so

    static Searchengine searchengines[] = {
    { "b",         "http://blekko.com/?q=%s" },
    { "d",         "http://duckduckgo.com/?q=%s" },
    { "g",         "http://www.google.com/search?hl=en&source=hp&ie=ISO-8859-l&q=%s" },
    { "a",         "https://wiki.archlinux.org/index.php?title=Special%%3ASearch&search=%s&go=Go" },
    { "w",         "https://secure.wikimedia.org/wikipedia/en/w/index.php?title=Special%%3ASearch&search=%s&go=Go" },
    }

If you are running Vimprobable in tabbed, you can direct other
applications to open webpages and have them captured in tabbed by
starting Vimprobable with an xid:

     $(tabbed -d >/tmp/tabbed.xid); vimprobable2 -e $(</tmp/tabbed.xid)

and then directing the other applications to use that xid to launch
Vimprobable:

     exec vimprobable2 -e $(</tmp/tabbed.xid) "$1"

With this script you can create a tabbed session if there is not alredy
a window with tabbed, and then launch Vimprobable within it.

    #!/usr/bin/env bash
    [[ -z $((xprop -id $(</tmp/tabbed.xid)) 2>/dev/null) ]] && tabbed -d > /tmp/tabbed.xid 
    exec vimprobable2 -e $(</tmp/tabbed.xid) $( [[  "$1"  ]] && echo "$1") &

> HTML5 Video

To get Vimprobable to play HTML5 Video, you will need to ensure that all
of the gstreamer plugins are installed: gstreamer0.10 gstreamer0.10-bad
gstreamer0.10-base gstreamer0.10-base-plugins gstreamer0.10-ffmpeg
gstreamer0.10-good

See this thread for details:
https://bbs.archlinux.org/viewtopic.php?id=94997

Resources
---------

-   Vimprobable website
-   tabbed a suckless program for managing tabs
-   A screencast introduction to Vimprobable

Retrieved from
"https://wiki.archlinux.org/index.php?title=Vimprobable&oldid=296043"

Category:

-   Web Browser

-   This page was last modified on 3 February 2014, at 12:56.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
