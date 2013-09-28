DeveloperWiki:NewMirrors
========================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Adding a new mirror                                                |
| -   2 2-tier mirroring scheme                                            |
| -   3 For the mirror administrator                                       |
| -   4 The Arch Linux side                                                |
| -   5 Mirror size                                                        |
+--------------------------------------------------------------------------+

> Adding a new mirror

This text should outline the procedure for adding a new mirror for Arch
packages.

2-tier mirroring scheme
-----------------------

Due to the high load and bandwidth limits Arch Linux uses 2-tier
mirroring scheme.

There are few tier 1 mirrors that sync directly from archlinux.org every
hour.

All other mirrors should sync from one of tier 1 mirrors. Syncing from
archlinux.org is not allowed.

For the mirror administrator
----------------------------

Please open a feature request with a request to become an authorized
mirror.

Please provide the following:

-   Mirror domain name
-   Geographical location of the mirror
-   Supported access methods (http, ftp, rsync, ...)
-   URLs for the above access methods
-   The name of tier 1 mirror you are syncing from, which should be one
    of this:
    -   aarnet.edu.au (Australia) -
        rsync://mirror.aarnet.edu.au/archlinux/
    -   gwdg.de (Germany) - rsync://ftp5.gwdg.de/pub/linux/archlinux/
    -   uk2.net (Great Britain) - rsync://mirrors.uk2.net/archlinux/
    -   gtlib.gatech.edu (USA) -
        rsync://rsync.gtlib.gatech.edu/archlinux/
    -   rit.edu (USA) - rsync://mirror.rit.edu/archlinux/
    -   tku.edu.tw (Taiwan) - rsync://ftp.tku.edu.tw/archlinux/
    -   las.ic.unicamp.br (Brazil) -
        rsync://rsync.las.ic.unicamp.br/pub/archlinux/
    -   c3sl.ufpr.br (Brazil) -
        rsync://archlinux.c3sl.ufpr.br/archlinux/

-   An administrative contact email

Please join the arch-mirrors mailing list.

Please ensure the following, to provide consistent mirroring and keep
the upstream mirror's load low:

-   Sync all contents of the upstream mirror (i.e. do not sync only some
    repositories)
-   Use the following rsync options: -rtlvH --delete-after
    --delay-updates --safe-links --max-delete=1000
-   Do not rsync more rapidly than every hour
-   Sync on a random minute so it is more likely the requests will be
    spaced out with other mirrors

The Arch Linux side
-------------------

-   Add the mirror info to the Django admin site
-   Regenerate the rsync whitelist with the gen_rsyncd.conf.sh script -
    only for tier 1 mirrors, or when disabling access to a previously
    untiered mirror
-   Regenerate the pacman-mirrorlist package

Mirror size
-----------

To give you an impression how much space will be needed for a mirror
here are some numbers:

-   archive - 14GB (permanently frozen)
-   core + extra + community - 20GB as of July 2010
-   testing + community-testing - from few MBs to few GBs
-   temporary repositories (like gnome-unstable, kde-unstable, xorg18
    etc.) - up to 1GB
-   iso - 11GB as of July 2010
-   other - 5.3GB as of July 2010
-   sources - 6.8GB as of July 2010

Most mirrors do not sync archive, other and sources directories, but
sync everything else (including temporary repositories), so usually you
will need about 35GB reserved for Arch Linux mirror.

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:NewMirrors&oldid=238686"

Category:

-   DeveloperWiki
