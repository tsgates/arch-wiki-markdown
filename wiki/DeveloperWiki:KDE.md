DeveloperWiki:KDE
=================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Packagers                                                          |
|     -   1.1 Plan                                                         |
|     -   1.2 Packages                                                     |
|     -   1.3 Todo / Notes                                                 |
|         -   1.3.1 common tasks                                           |
|         -   1.3.2 packages to be removed                                 |
|         -   1.3.3 packages to move with KDE                              |
|                                                                          |
| -   2 Packaging                                                          |
|     -   2.1 Known issues                                                 |
|     -   2.2 Changes from 4.9                                             |
|         -   2.2.1 New packages                                           |
|         -   2.2.2 Removed packages                                       |
|         -   2.2.3 soname bump                                            |
|                                                                          |
|     -   2.3 Broken packages which are not part of KDE SC                 |
+--------------------------------------------------------------------------+

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
-   kdeedu-kstars (miss xplanet)
-   kdeedu-marble (miss libwlocate, it hasn't a stable release)
-   kdenetwork (miss XMSS, libmeanwhile, msilbc)

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

-   kdeadmin-system-config-printer-kde
-   kdeartwork-aurorae
-   print-manager
-   kdegames
-   kdeutils-printer-applet

> packages to move with KDE

-   akonadi
-   soprano

Packaging
=========

Known issues
------------

-   the default screen locker shows a white wallpaper when
    kde-wallpapers isn't installed (you can set a different wallpaper in
    the Screen Locker menu)

If any problem occurs try a new user or (re)move ~/.kde4 /tmp/kde-*
/var/tmp/kdecache-*

Changes from 4.9
----------------

> New packages

-   nepomuk-widgets
-   kdegames-picmi
-   kdeutils-print-manager
-   kdeplasma-addons-runners-dictionary
-   kdeplasma-addons-wallpapers-qmlwallpapers
-   libkdegames
-   libkmahjongg

> Removed packages

-   kdeartwork-aurorae
-   kdegames-libkdegames
-   kdegames-libkmahjongg

> soname bump

-   libkipi.so.9 -> libkipi.so.10
-   libkdcraw.so.21 -> libkdcraw.so.22

Broken packages which are not part of KDE SC
--------------------------------------------

-   digikam (needs a rebuild)
-   kipi-plugins (needs a rebuild)
-   calligra-krita (needs a rebuild)

Retrieved from
"https://wiki.archlinux.org/index.php?title=DeveloperWiki:KDE&oldid=243096"

Category:

-   DeveloperWiki
