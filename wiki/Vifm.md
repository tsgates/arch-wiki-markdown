Vifm
====

Vifm is a ncurses based file manager with vi like keybindings. If you
use vi, vifm gives you complete keyboard control over your files without
having to learn a new set of commands. Source: Vifm on sourceforge.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Help File                                                          |
| -   3 Customizing Vifm                                                   |
|     -   3.1 Color schemes                                                |
|     -   3.2 Key Mapping                                                  |
|     -   3.3 Opening filetypes in Vifm                                    |
|         -   3.3.1 Browse images in current directory with Feh            |
|                                                                          |
|     -   3.4 User commands                                                |
|         -   3.4.1 Creating symbolic links                                |
|         -   3.4.2 Torrent Creation                                       |
|                                                                          |
|     -   3.5 Marks                                                        |
|                                                                          |
| -   4 Alternative                                                        |
+--------------------------------------------------------------------------+

Installation
------------

Vifm is in Community:

    # pacman -S vifm

Optional, for file previews:

-   tree for directory previews
-   mp3info for viewing information about mp3 files
-   poppler for pdf previews

Help File
---------

Basic information about vifm is given in the help file. You can view it
by opening vifm and typing

    :h

Another good source of information is the man page.

Customizing Vifm
----------------

Vifm creates and populates a .vifm folder in your home directory
containing the following:

-   vifmrc - a well commented configuration file that can be edited to
    suit your working style.
-   vifm-help.txt - the help text
-   vifminfo - bookmarks and trash contents - it is not recommended to
    edit this file by hand
-   Trash/ directory - self explanatory
-   colors/ directory - color schemes
    -   Default - well commented default color scheme - can be copied to
        create user-created color schemes

To get started, read the information avaliable in:

-   /usr/share/vifm/vifm.txt
-   /usr/share/vifm/vifm-help.txt

> Color schemes

The ~/.vifm/colors directory contains the color schemes. The format is
outlined in the file and follows vi/vim syntax highlight format. It is
basically:

    highlight <group> cterm=<attribute> ctermfg=<color> ctermbg=<color>

An example colorscheme looks like:

    highlight Win cterm=none ctermfg=white ctermbg=black
    highlight Directory cterm=bold ctermfg=cyan ctermbg=none
    highlight Link cterm=bold ctermfg=yellow ctermbg=none
    highlight BrokenLink cterm=bold ctermfg=red ctermbg=none
    highlight Socket cterm=bold ctermfg=magenta ctermbg=none
    highlight Device cterm=bold ctermfg=red ctermbg=none
    highlight Fifo cterm=bold ctermfg=cyan ctermbg=none
    highlight Executable cterm=bold ctermfg=green ctermbg=none
    highlight Selected cterm=bold ctermfg=magenta ctermbg=none
    highlight CurrLine cterm=bold ctermfg=none ctermbg=blue
    highlight TopLine cterm=none ctermfg=black ctermbg=white
    highlight TopLineSel cterm=bold ctermfg=black ctermbg=none
    highlight StatusLine cterm=bold ctermfg=black ctermbg=white
    highlight WildMenu cterm=underline,reverse ctermfg=white ctermbg=black
    highlight CmdLine cterm=none ctermfg=white ctermbg=black
    highlight ErrorMsg cterm=none ctermfg=red ctermbg=black
    highlight Border cterm=none ctermfg=black ctermbg=white

> Key Mapping

As of 0.6.2 you can customize key bindings in Vifm. These can be set
from the command mode using the map command, like so:

     :map ] :s

However, these mappings will not be saved between sessions. To map a key
permanently, place them in ~/vifm/vifmrc. More sample mappings can be
seen at the end of that file.

> Opening filetypes in Vifm

You can assign applications to filetypes in vifmrc, eg.

    filetype *.jpg,*.jpeg,*.png,*.gif feh %f 2>/dev/null &
    filetype *.md5 md5sum -c %f

Several defaults can be found in vifmrc. These can be edited or added to
following the same format.

Browse images in current directory with Feh

    filextype *.jpg,*.jpeg,*.png,*.gif
           \ {View in feh}
           \ feh -FZ %d --start-at %d/%c,

It will display your selected image in feh, but it will enable you to
browse all other images in the directory as well, in their default
order.

> User commands

You can also create custom commands in vifmrc, eg.

    command df df -h %m 2> /dev/null
    command diff vim -d %f %F

Creating symbolic links

    command link ln -s %d/%f %D

When you call

    :link

a link of the selected file is made in the other directory (if you are
in split view). It even works with multiple files selected with visual
(v) or tag (t).

Torrent Creation

make a .torrent of the current file in the other tab's dir

    command mkt mktorrent -p -a [your announce url here] -o %D/%f.torrent %d/%f

> Marks

Marks can be set same as in vi. To set a mark for current file:

    m[a-z][A-Z][0-9]

Go to a file set for mark:

    '[a-z][A-Z][0-9]

Vifm will remember the marks between the sessions.

Alternative
-----------

Another text-based file manager with vi-like keybinds is ranger.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Vifm&oldid=250502"

Category:

-   File managers
