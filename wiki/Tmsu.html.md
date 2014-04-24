Tmsu
====

tmsu is a tool for tagging your files. It provides a simple command-line
tool for applying tags and a virtual file-system so that you can get a
tagged based view of your files from within any other program.

Contents
--------

-   1 Installation
-   2 Usage
-   3 Obstacles
-   4 See also

Installation
------------

tmsu can be installed with the tmsu or tmsu-bin packages.

Usage
-----

The tmsu website provides an excellent short quick tour on the basic
usage.

Obstacles
---------

tmsu creates symlinks between files, folders and the related tags. That
is, it cannot handle file deletions and moves very well although there
is a 'repair' command that will detect file moves and renames. It also
updates fingerprints for modified files. There is no automatic directory
watcher and it is not planned to add this facility as it would not work
across all file system types.

See also
--------

-   Reddit discussion
-   tmsu extensions

Retrieved from
"https://wiki.archlinux.org/index.php?title=Tmsu&oldid=301734"

Categories:

-   Search
-   File systems

-   This page was last modified on 24 February 2014, at 13:32.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
