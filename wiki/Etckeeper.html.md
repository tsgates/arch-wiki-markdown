Etckeeper
=========

Etckeeper lets you keep /etc under version control.

Contents
--------

-   1 Install
-   2 Configure
-   3 Usage
    -   3.1 Cron
    -   3.2 Wrapper Script
    -   3.3 Incron
    -   3.4 Automatic push to remote repo

Install
-------

Get etckeeper from the AUR.

Configure
---------

The main config file is /etc/etckeeper/etckeeper.conf. You can set
things such as the VCS to use in this file.

Once you've set your preferred VCS (the default is git), you can
initialize the /etc repository by running

    # etckeeper init

Usage
-----

Etckeeper supports using pacman as a LOWLEVEL_PACKAGE_MANAGER in
etckeeper.conf. Support for using pacman as a HIGHLEVEL_PACKAGER_MANAGER
is not yet added, so you'll need to either commit changes manually or
use one of the stopgap solutions below.

> Cron

There is a cron script in the source distribution at debian/cron.daily.
You can use this script to automatically commit changes on a schedule.
To make it run daily, for example, make sure you have cron installed and
enabled, then simply copy the script from the srcdir where you built
etckeeper to /etc/cron.daily and make sure it's executable (e.g.
chmod +x /path/to/script).

> Wrapper Script

In order to emulate the auto-commit functionality that etckeeper has on
other systems, you could place a script such as the one below somewhere
in your PATH, make it executable, and use it instead of pacman -Syu to
update your system.

    #!/bin/bash

    etckeeper pre-install
    pacman -Syu
    etckeeper post-install

Alternatively you can add a quick alias to ~/.bashrc:

    alias pkg-update='sudo etckeeper pre-install && sudo pacman -Syu && sudo etckeeper post-install'

> Incron

As an alternative to the above, you could set up incron to automatically
commit changes using etckeeper whenever a file in /etc is modified.

> Automatic push to remote repo

Warning:Pushing your etckeeper repository to a publicly accessible
remote repository can expose sensitive data such as password hashes or
private keys. Proceed with caution.

Whilst having a local backup in /etc/.git is a good first step,
etckeeper can automatically push your changes on each commit to a remote
repository such as Github. Create an executable file
/etc/etckeeper/commit.d/40github-push:

    #!/bin/sh
    set -e

    if [ "$VCS" = git ] && [ -d .git ]; then
      cd /etc/
      git push origin master
    fi

Change to etc/.git and add your remote Github repository:

    # git remote add origin https://github.com/user/repo.git

Now each time you run your wrapper script or alias from above, changes
will be automatically commited to your Github repo.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Etckeeper&oldid=272025"

Category:

-   System administration

-   This page was last modified on 21 August 2013, at 18:17.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
