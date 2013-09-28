DeveloperWiki:Developer Checklist
=================================

New developer setup and checklist
=================================

For the admin
-------------

To add a new user:

-   adduser on nymeria
    -   Delete the user's password (passwd -d)
    -   Upload the user's public ssh key

-   add to dev
-   upgrade to a "developer" on flyspray
-   upgrade to a "developer" on the forums
-   upgrade to a "developer" on AUR
-   upgrade to a "Administrator" on the wiki: Special:Userrights
-   subscribe them to arch-dev and arch-dev-public Mailing lists
-   add to https://dev.archlinux.org/admin users table
-   give password to #archlinux-dev

For the new developer
---------------------

-   Add your email address to ~/.forward- the file should just be one
    plain line with an email address (so postfix can forward mail)
-   Make sure to checkout svn over ssh (See
    DeveloperWiki:HOWTO_Be_A_Packager)
-   Install devtools and namcap. You may also want the base-devel
    package if you do not have it
-   git projects are "fenced in" to prevent people from pushing code
    willy-nilly. If you think you should have push access to a git repo,
    talk to the owner of the repo (listed on projects). If they accept,
    any admin can add you to the proper group
-   The core repo is typically disabled for newer developers. This is
    just a safeguard. If you feel, at some point in the future, that
    you'd make a good maintainer of a given core package, send an email
    to the arch-dev mailing list requesting access

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:Developer_Checklist&oldid=247432"

Category:

-   DeveloperWiki
