OpenSync
========

OpenSync is a framework which provides synchronization services for PIM
data. Generally it consists of the library libopensync, various plugins
and the cli msynctool/osynctool.

Versioning
----------

The OpenSync project provides a stable release, currently version 0.22,
and a unstable/experimental release 0.3x, currently latest is version
0.39. Project access via SVN is also possible. A release date for the
next stable version 0.40 is not yet announced.

Dependencies
------------

Generally a mixture of different version numbers should be avoided
especially between the stable and experimental releases. A version 0.22
plugin insists on a version 0.22 libopensync and a version 0.39 plugin
should joined with the corresponding unstable library version. Since not
every version step provides all available plugins, your choosen version
of libopensync may depend on your plugin needs.

branch

stable

unstable

libopensync version

0.22

0.33 - 0.38

0.39

available plugins

-   evolution2
-   file
-   gnokii
-   google-calendar
-   gpe
-   irmc
-   jescs
-   kdepim (KDE3)
-   ldap
-   moto
-   opie
-   palm
-   python
-   sunbird
-   syncce
-   syncml

see http://opensync.org/download/releases/

-   evolution2
-   file
-   syncml
-   vformat
-   xmlformat

cli interface

msynctool 0.22

msynctool with corresponding version (?)

osynctool 0.39

gui

multisync-gui

n.a.

  
 The kdepim plugin in the stable branch is useless in KDE 4, since PIM
data is managed by akonadi. A suitable plugin is proposed as a part of
the oncoming version 0.40. A user who wants to synchronize a
syncml-capable mobile phone with evolution might be satisfied with the
latest unstable version. Other users might prefer the old but stable
branch. Since the community repo provides the latest unstable version of
libopensync a manual downgrading is necessary. For i686 there is a
unofficial user repository:

    [kpiche]
    # Stable OpenSync packages.
    Server = http://kpiche.archlinux.ca/repo

Configuration
-------------

Examples for 0.22 release: http://www.opensync.org/wiki/releases/0.2x

Retrieved from
"https://wiki.archlinux.org/index.php?title=OpenSync&oldid=206645"

Category:

-   System administration
