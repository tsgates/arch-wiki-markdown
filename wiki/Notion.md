Notion
======

Notion is a tiling, tabbed window manager for X.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Starting Notion                                                    |
| -   3 Using Notion                                                       |
| -   4 Lua 5.2                                                            |
|     -   4.1 gfind                                                        |
|     -   4.2 goto                                                         |
|                                                                          |
| -   5 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Install notion from the Official Repositories.

Starting Notion
---------------

You can start Notion from the command line by adding exec notion to
~/.xinitrc or any other startup script you may want to use. An example
.xinitrc file can be found below.

    DEFAULT_SESSION=notion
    case $1 in
    awesome) 
                       exec awesome
                       ;;
    notion) 
                       exec notion
                       ;;
    openbox) 
                       exec openbox-session
                       ;;
    *) 
                       exec $DEFAULT_SESSION
                       ;;
    esac

Using Notion
------------

You can view Notion's man page at any time during use by pressing the F1
key and pressing the return key This will tell you the default key
bindings for Notion. You can also access the man page for other programs
this way by pressing F1, typing in the program's name and pressing
return.

Lua 5.2
-------

> gfind

You should replace 'gfind' to 'gmatch' because of 'gfind' was removed

> goto

'goto' is a keyword now. You can use following workaround:

replace

     win:goto()

to

     function win_goto(w) return w['goto'](w) end
     ...
     win_goto(win)

See also
--------

-   http://sourceforge.net/apps/mediawiki/notion/index.php?title=Tour -
    Tour of Notion
-   http://notion.sourceforge.net/notionconf/ - Configuring and
    Extending Notion using LUA
-   http://sourceforge.net/apps/mediawiki/notion - Notion Wiki

Retrieved from
"https://wiki.archlinux.org/index.php?title=Notion&oldid=240286"

Category:

-   Tiling WMs
