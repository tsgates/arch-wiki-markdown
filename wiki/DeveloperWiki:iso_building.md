DeveloperWiki:iso building
==========================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 How to build release iso's/img's                                   |
|     -   1.1 Preparation                                                  |
|         -   1.1.1 Bleeding edge archiso (needed for 2009.01)             |
|         -   1.1.2 Packaged archiso (after new archiso release which is   |
|             planned after 2009-01 iso release)                           |
|                                                                          |
|     -   1.2 Execution                                                    |
|     -   1.3 unanswered questions                                         |
+--------------------------------------------------------------------------+

How to build release iso's/img's
================================

Preparation
-----------

> Bleeding edge archiso (needed for 2009.01)

    $ git clone git://projects.archlinux.org/archiso.git
    $ cd archiso/archiso
    $ sudo make install

> Packaged archiso (after new archiso release which is planned after 2009-01 iso release)

    $ pacman -S archiso

Execution
---------

    $ cd ../configs/install-iso
    $ sudo make all-iso (or ftp-iso, or core-iso)

unanswered questions
--------------------

-   any specific requirements on /etc/pacman.conf? (related to
    settings/available repos?)

When testing and working on iso's locally i set up a local repository
(iso-test) where i store local modified packages (installer, grub-gfx or
mkinitcpio etc). This repo on the build machine at first rank in the
pacman.conf. When building the iso, packages from this repo go into the
live-cd part of the iso and are so preferred over those in the normal
repos. Also testing repo should be activated (after private repo, but
before normal repos) when ex. the kernel is currently available only
from testing. For Release-Iso's (or Release-Candidates) the testing repo
and your local repo should be disabled of course. (GerBra)

-   how do you build iso's with only core or with core+testing
    available?

by just (un)commenting testing from /etc/pacman.conf?

All official repos should/must be enabled on the build machine (testing
is special issue). To build the iso we need packages from core, extra
and community(grub-gfx) (GerBra)

-   assuming that the relevant repositories are frozen, if I build an
    iso on my system, and someone else builds the iso on his system,
    will the iso's match perfectly? (eg same md5sums)

I think it would be useful in the future we build locally first and test
it, and then instead of uploading to gerolde, we can just rebuild it
there?

AFAIK the md5sums must not match on different build (although when both
use the same software versions). Squashfs compressed images could be
slightly different on different machines/builds and so the iso md5sum
could differ. (GerBra)

-   naming convention? see
    https://www.archlinux.org/pipermail/arch-releng/2009-January/000046.html

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:iso_building&oldid=239153"

Category:

-   Arch development
