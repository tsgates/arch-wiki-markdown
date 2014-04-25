Nemo
====

Related articles

-   Cinnamon
-   File manager functionality
-   Nautilus
-   Thunar
-   PCManFM

Nemo is a fork of Nautilus. It is also the default file manager of the
Cinnamon desktop. Nemo is based on the Nautilus 3.4 code. It was created
as a response to the changes in Nautilus 3.6 which saw features such as
type ahead find and split pane view removed.

Contents
--------

-   1 Installation
    -   1.1 Extensions
-   2 Configuration
    -   2.1 Show / hide desktop icons
    -   2.2 Make Nemo your default file browser
    -   2.3 Change application for "Open in terminal" context menu entry
-   3 Tips and tricks
    -   3.1 Nemo Actions
        -   3.1.1 Clam Scan
        -   3.1.2 Moving files
        -   3.1.3 Meld compare

Installation
------------

Install nemo from the official repositories.

> Extensions

Some programs can add extra functionality to Nemo. Here are a few
packages that do just that:

-   Nemo File Roller — File archiver extension for Nemo.

https://github.com/linuxmint/nemo-extensions/tree/master/nemo-fileroller
|| nemo-fileroller

-   Nemo Preview — GtkClutter and Javascript-based quick previewer for
    Nemo.

https://github.com/linuxmint/nemo-extensions/tree/master/nemo-preview ||
nemo-preview

-   Nemo Seahorse — PGP encryption and signing extension for Nemo.

https://github.com/linuxmint/nemo-extensions/tree/master/nemo-seahorse
|| nemo-seahorse

-   Nemo Share — Samba extension for Nemo.

https://github.com/linuxmint/nemo-extensions/tree/master/nemo-share ||
nemo-share

-   RabbitVCS Nemo — Integrate RabbitVCS into Nemo.

http://www.rabbitvcs.org/ || rabbitvcs-nemo

See nemo-extensions github repo for all extensions.

Configuration
-------------

Nemo is simple to configure graphically but not all options are in the
preferences screen in Nemo. More options are available in the
dconf-editor under org.nemo.

> Show / hide desktop icons

To enable/disable desktop icons rendering feature in nemo, change the
following setting true or false (false to hide, true to show):

    $ gsettings set org.nemo.desktop show-desktop-icons false

> Make Nemo your default file browser

Add the following line to the Default Applications section of the file
~/.local/share/applications/mimeapps.list

    [Default Applications]
    inode/directory=nemo.desktop

> Change application for "Open in terminal" context menu entry

    $ gsettings set org.cinnamon.desktop.default-applications.terminal exec terminal-name

Tips and tricks
---------------

> Nemo Actions

Nemo allows the user to add new entries to the context menu. The file
/usr/share/nemo/actions/sample.nemo_action contains an example of a Nemo
action. Directories to place custom action files:

-   /usr/share/nemo/actions/ for system-wide actions
-   $HOME/.local/share/nemo/actions/ for user actions

Pay attention to the name convention. Your file has to preserve the file
ending .nemo_action.

Clam Scan

    $HOME/.local/share/nemo/actions/clamscan.nemo_action

    [Nemo Action]
    Name=Clam Scan
    Comment=Clam Scan

    Exec=gnome-terminal -x sh -c "clamscan -r %F | less"

    Icon-Name=bug-buddy

    Selection=Any

    Extensions=dir;exe;dll;zip;gz;7z;rar;

Moving files

    $HOME/.local/share/nemo/actions/archive.nemo_action

    [Nemo Action]
    Active=true
    Name=Archive %N
    Comment=Archiving %N will add .archive to the object.
    Exec=<archive.py %F>
    Selection=S
    Extensions=any;

    $HOME/.local/share/nemo/actions/archive.py

    #! /usr/bin/python2 -OOt
    import sys
    import os
    import shutil

    filename = sys.argv[0]
    print "Running " + filename
    print "With the following arguments:"
    for arg in sys.argv:
        if filename == arg:
            continue
        else:
            print arg
            #os.rename('%s','%s.archive') % (arg,arg)
            shutil.move(arg, arg+".archive")

Meld compare

    $HOME/.local/share/nemo/actions/compare-save-for-later.nemo_action

    [Nemo Action]
    Active=true
    Name=Compare later
    Comment=Save file for comparison later.
    Exec=<compare.sh save %F>
    Icon-Name=meld
    Selection=S
    Extensions=any

    $HOME/.local/share/nemo/actions/compare-with-saved.nemo_action

    [Nemo Action]
    Active=true
    Name=Compare with saved element
    Comment=Compare %F saved file or directory.
    Exec=<compare.sh compare %F>
    Icon-Name=meld
    Selection=S
    Extensions=any

    $HOME/.local/share/nemo/actions/compare.sh

    #!/bin/bash
    savedfile=/var/tmp/compare-save-for-later.$USER
    comparator=meld
    if [ "$1" == "save" ]; then
    	echo "$2" > "$savedfile"
    else
    	"$comparator" $(cat "$savedfile") "$2"
    fi

Retrieved from
"https://wiki.archlinux.org/index.php?title=Nemo&oldid=289701"

Category:

-   File managers

-   This page was last modified on 21 December 2013, at 01:47.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
