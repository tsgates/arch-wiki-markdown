Pass
====

pass is a simple password manager for the command line. Passwords are
stored inside gpg encrypted files in a simple directory tree structure.
Basically pass is a shell script that makes use of existing tools like
gnupg, pwgen, tree & git and can therefore be considered less "bloated"
than alternatives like e.g. keepass

Contents
--------

-   1 Installation
-   2 Basic usage
-   3 Migrating to pass
-   4 See also

Installation
------------

Install pass, available in the official repositories.

Basic usage
-----------

Note:To be able to use pass you need to set up gnupg as described in
Gnupg#Basic keys management

-   Initialize the password store

    $ pass init <gpg-id or email>

-   Insert password, providing a descriptive hierarchical name

    $ pass insert archlinux.org/wiki/username

-   Get a view of the password store

    $ pass

    Password Store
    └── archlinux.org
        └── wiki
            └── username

-   Generate a new random password, where <n> is the desired password
    length as a number.

    $ pass generate archlinux.org/wiki/username <n>

-   Retrieve password, you will be prompted for the gpg passphrase

    $ pass archlinux.org/wiki/username

-   If you're using Xorg and have xclip installed, the retrieved
    password can be put on the clipboard temporarily to paste into web
    forms via:

    $ pass -c archlinux.org/wiki/username

Migrating to pass
-----------------

There are multiple scripts listed on the pass-project page to import
passwords from other programs

See also
--------

-   A more comprehensive pass tutorial

Retrieved from
"https://wiki.archlinux.org/index.php?title=Pass&oldid=305549"

Category:

-   Security

-   This page was last modified on 19 March 2014, at 02:07.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
