TuPac
=====

tupac (turbo pacman) is a pacman database search engine that boosts
pacman searches. The speed advantage is achieved by caching the pacman
database.

Tasks like checking the integrity of an entire pacman-tracked
installation, or finding orphans in large directories (like /usr), are
performed in a few seconds.

tupac is not a pacman wrapper. Its coding is only related to pacman
searches. For any other tasks it bypasses to yaourt.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Key features                                                       |
| -   2 Command Line Arguments                                             |
| -   3 What you must know                                                 |
| -   4 Installation                                                       |
| -   5 Design                                                             |
| -   6 History                                                            |
| -   7 Follow up                                                          |
+--------------------------------------------------------------------------+

Key features
------------

-   Searches the AUR
-   It allows you to refine searches by utilizing AND searches rather
    than OR searches (looks for packages that match all words)
-   Automatic cache updates (no user intervention required at all).
-   Very fast file level operations (find owners, find missing files,
    etc)

Command Line Arguments
----------------------

    tupac: A cached pacman implementatioin. Version: 0.3.5

     Usage:
      tupac [word] [word] [word] ...     : Search for and install packages that match all [word]
      tupac -Ss [word] [word] [word] ... : Search for packages that match all [word]
      tupac -Qo [file] [file] [file] ... : Search for each [file] owner
      tupac --checkdir [directory]       : Check integrity of a directory.
      tupac --orphans [directory]        : Find files that are not part of any package
      tupac                              : Manual call to update cache
      tupac [anything else]              : bypass to yaourt
      tupac --set-proxy [host:port|none] : set up a proxy

     Modifiers:
      --safe                             : Only search for safe packages
      --noaur                            : Don't search in AUR
      --noprompt                         : Don't prompt anything
      --color [darkbg|lightbg|nocolor]   : Choose color scheme
      --repos repo1,repo2,repo3,...      : Set active repositories

  

What you must know
------------------

Tupac does not parse "/etc/pacman.conf". It works exclusively with the
information available from the pacman database (/var/lib/pacman), so if
you erase a repo from pacman.conf it will still be shown in tupac,
unless you erase its directory from the database.

Installation
------------

tupac is available from the AUR.

Design
------

Tupac is written in php because:

-   the serialize function makes caching a blink
-   much simpler/cleaner coding than bash. This allows the design and
    implementation to concentrate on speed optimization.

History
-------

The initial idea was to boost some yaourt operations. tupac was intended
to be a rewrite of pajman, a program written in bash that had the same
objective- speed up pacman searches. When I got into the php context, (a
programming language that I use frequently) the idea of creating a cache
rapidly came to me. After implementing the file operations (orphans,
owners, integrity checks), I got so impressed with the results that i
decided to rename it to tupac, turbo pacman.

Follow up
---------

Check this forum's topic:
https://bbs.archlinux.org/viewtopic.php?id=38560

Retrieved from
"https://wiki.archlinux.org/index.php?title=TuPac&oldid=238025"

Category:

-   Package management
