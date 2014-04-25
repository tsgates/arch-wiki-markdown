DeveloperWiki:KDE
=================

Contents
--------

-   1 Packagers
    -   1.1 Plan
    -   1.2 Packages
    -   1.3 Todo / Notes
        -   1.3.1 common tasks
        -   1.3.2 packages to be removed
        -   1.3.3 packages to move with KDE
-   2 Packaging
    -   2.1 Known issues
    -   2.2 Changes from 4.12
        -   2.2.1 Removed packages
        -   2.2.2 New packages
    -   2.3 Broken packages which are not part of KDE SC

Packagers
=========

Plan
----

1.  check for new/removed dependencies
2.  check for new/removed sub modules
    1.  check if we should probably add some replaces

3.  recheck kde-meta
4.  review build logs
5.  review namcap logs
6.  check packages which are not part of KDE SC but depend on it
7.  check packages which depends on split libraries

Packages
--------

-   kdeaccessibility-kmag (miss libkdeaccessibilityclient, it hasn't a
    stable release)
-   kdebindings-kimono (miss soprano, nepomuk, akonadi bindings)
-   kdebindings-kross (miss falcon)
-   kdebindings-perlkde (miss akonadi)
-   kdebindings-smokekde (miss akonadi)
-   kdeedu-kig (miss boost-python?)
-   kdeedu-kstars (miss xplanet, astrometry)
-   kdeedu-marble (miss libshp, qextserialport, libwlocate, it hasn't a
    stable release)
-   kdenetwork-kopete (miss XMSS, libmeanwhile)

Todo / Notes
------------

> common tasks

-   change url to application homepage (e.g.
    http://kde.org/applications/utilities/ark/ or
    https://projects.kde.org/projects/kde/kdemultimedia/libkcddb instead
    of just kde.org)
-   check this Bug report: https://bugs.kde.org/show_bug.cgi?id=189465
-   update KDE and KDE Packages

> packages to be removed

-   nepomuk-core
-   nepomuk-widgets
-   shared-desktop-ontologies
-   soprano
-   virtuoso
-   virtuoso-base

> packages to move with KDE

Packaging
=========

Known issues
------------

If any problem occurs try a new user or (re)move ~/.kde4 /tmp/kde-*
/var/tmp/kdecache-*

-   Nepomuk does not work in application X: KDE SC 4.13 has been built
    without Nepomuk support.

Changes from 4.12
-----------------

> Removed packages

-   nepomuk-core
-   nepomuk-widgets

> New packages

-   kfilemetadata
-   baloo
-   baloo-widgets
-   kdeedu-artikulate
-   kqtquickcharts

Broken packages which are not part of KDE SC
--------------------------------------------

-   digikam (must be rebuilt with newer kdeedu-marble)

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:KDE&oldid=303782"

Category:

-   DeveloperWiki

-   This page was last modified on 9 March 2014, at 13:18.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
