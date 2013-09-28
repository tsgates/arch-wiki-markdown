Pacman Development
==================

Interested in Pacman Development? This page should help you get started.

Remember that if you think something belongs on this page, add it! The
current pacman developers are not likely to know what people need to
know and should be on this page.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 References and Links                                               |
| -   2 Developer Repositories                                             |
|     -   2.1 Allan McRae                                                  |
|     -   2.2 Dan McGee                                                    |
|     -   2.3 Dave Reisner                                                 |
|                                                                          |
| -   3 Git Tips                                                           |
+--------------------------------------------------------------------------+

References and Links
--------------------

-   Pacman Homepage
-   Latest NEWS/ChangeLog
-   Pacman Git Web Interface
-   Pacman Roadmap

-   Mailing List Archives

-   HACKING
-   Submitting Patches
-   Translation Help

-   IRC: #archlinux-pacman on irc.freenode.net

Developer Repositories
----------------------

A handful of the "regulars" have their own repositories with work in
progress, working and feature branches, etc. Several are listed here,
but feel free to add more that you may know about.

> Allan McRae

Web: https://projects.archlinux.org/users/allan/pacman.git/  
 Clone: git://projects.archlinux.org/users/allan/pacman.git  
 Clone: https://projects.archlinux.org/git/users/allan/pacman.git

> Dan McGee

Web: http://code.toofishes.net/cgit/dan/pacman.git/  
 Clone: git://code.toofishes.net/dan/pacman.git  
 Clone: http://code.toofishes.net/git/dan/pacman.git

> Dave Reisner

Web: https://github.com/falconindy/pacman  
 Clone: git://github.com/falconindy/pacman.git  
 Clone: https://github.com/falconindy/pacman.git

Git Tips
--------

Before using these tips, it is highly recommended to read the Super
Quick Git Guide.

Clone git repo - only needed once

     git clone git://projects.archlinux.org/pacman.git pacman

Enable useful hooks

     mv .git/hooks/applypatch-msg.sample .git/hooks/applypatch-msg
     mv .git/hooks/commit-msg.sample .git/hooks/commit-msg
     mv .git/hooks/pre-commit.sample .git/hooks/pre-commit
     mv .git/hooks/pre-rebase.sample .git/hooks/pre-rebase

Always do your work on a new local branch to save yourself headaches.

Make patch to master branch

     git format-patch master

Amend patch (Don't use it after a push)

     git commit -a --amend -s

Update master branch

     git checkout master
     git pull

Merge changes on master with "<branch>"

     git rebase master <branch>

Get maint branch

     git checkout -b maint origin/maint

Add a remote repository

      git remote add toofishes git://code.toofishes.net/dan/pacman.git

Get toofishes working branch

      git branch -r
      git checkout -b toofishes-working toofishes/working

Retrieved from
"https://wiki.archlinux.org/index.php?title=Pacman_Development&oldid=237805"

Category:

-   Pacman development
