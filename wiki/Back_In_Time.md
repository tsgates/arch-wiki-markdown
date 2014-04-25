Back In Time
============

Back In Time is a simple backup tool for Linux inspired from “flyback
project” and “TimeVault”. The backup is done by taking snapshots of a
specified set of directories.

Back In Time currently provides two GUI: Gnome and KDE 4 (>= 4.1). For
upcoming releases, however, the team decided to switch to Qt.

Installation
------------

Stable releases of Back In Time can be installed as backintime from the
AUR. Alternatively, pre-compiled binary packages can be installed from
codercun's repo. An unstable branch exists with backintime-bzr.

Back In Time will automatically install a startup entry in
/etc/xdg/autostart. If you want to launch the GUI, then run
backintime-gnome. If you want to backup files other than your home user
files, then consider starting Back In Time with gksu backtintime-gnome
instead.

Configuration
-------------

The configuration can be done entirely via the GUI. All you have to do
is configure:

-   Where to save snapshot
-   What directories to backup
-   When backup should be done (manual, every hour, every day, every
    week, every month)

See also
--------

-   Back In Time website
-   Back In Time documentation

Retrieved from
"https://wiki.archlinux.org/index.php?title=Back_In_Time&oldid=302216"

Category:

-   System recovery

-   This page was last modified on 26 February 2014, at 15:22.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
