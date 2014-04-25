Unofficial user repositories
============================

Related articles

-   pacman-key
-   Official repositories

Because the AUR only allows users to upload PKGBUILD and other package
build related files, but does not provide a means for distributing a
binary package, a user may want to create a binary repository of their
packages elsewhere. See Pacman Tips#Custom local repository for more
information.

If you have your own repository, please add it to this page, so that all
the other users will know where to find your packages. Please keep the
following rules when adding new repositories:

-   Keep the lists in alphabetical order.
-   Include some information about the maintainer: include at least a
    (nick)name and some form of contact information (web site, email
    address, user page on ArchWiki or the forums, etc.).
-   If the repository is of the signed variety, please include a key-id,
    possibly using it as the anchor for a link to its keyserver; if the
    key is not on a keyserver, include a link to the key file.
-   Include some short description (e.g. the category of packages
    provided in the repository).
-   If there is a page (either on ArchWiki or external) containing more
    information about the repository, include a link to it.
-   If possible, avoid using comments in code blocks. The formatted
    description is much more readable. Users who want some comments in
    their pacman.conf can easily create it on their own.

Note:If you are looking to add a signed repository to your pacman.conf,
you must be familiar with Pacman-key#Adding unofficial keys.

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: Please fill in   
                           the missing information  
                           about maintainers.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Any
    -   1.1 Signed
        -   1.1.1 infinality-bundle-fonts
        -   1.1.2 xyne-any
    -   1.2 Unsigned
        -   1.2.1 archlinuxgr-any
-   2 Both i686 and x86_64
    -   2.1 Signed
        -   2.1.1 arcanisrepo
        -   2.1.2 blackarch
        -   2.1.3 carstene1ns
        -   2.1.4 catalyst
        -   2.1.5 catalyst-hd234k
        -   2.1.6 city
        -   2.1.7 crypto
        -   2.1.8 demz-repo-core
        -   2.1.9 demz-repo-archiso
        -   2.1.10 gtmanfred
        -   2.1.11 infinality-bundle
        -   2.1.12 pipelight
        -   2.1.13 repo-ck
        -   2.1.14 sergej-repo
    -   2.2 Unsigned
        -   2.2.1 alucryd
        -   2.2.2 archaudio
        -   2.2.3 archie-repo
        -   2.2.4 archlinuxcn
        -   2.2.5 archlinuxfr
        -   2.2.6 archlinuxgis
        -   2.2.7 archlinuxgr
        -   2.2.8 archlinuxgr-kde4
        -   2.2.9 archstuff
        -   2.2.10 arsch
        -   2.2.11 aurbin
        -   2.2.12 cinnamon
        -   2.2.13 ede
        -   2.2.14 haskell-core
        -   2.2.15 heftig
        -   2.2.16 herecura-stable
        -   2.2.17 herecura-testing
        -   2.2.18 jelle
        -   2.2.19 mesa-git
        -   2.2.20 oracle
        -   2.2.21 pantheon
        -   2.2.22 paulburton-fitbitd
        -   2.2.23 pfkernel
        -   2.2.24 suckless
        -   2.2.25 unity
        -   2.2.26 unity-extra
        -   2.2.27 unity
        -   2.2.28 unity-extra
        -   2.2.29 home_tarakbumba_archlinux_Arch_Extra_standard
-   3 i686 only
    -   3.1 Signed
        -   3.1.1 eee-ck
        -   3.1.2 xyne-i686
    -   3.2 Unsigned
        -   3.2.1 andrwe
        -   3.2.2 batchbin
        -   3.2.3 esclinux
        -   3.2.4 kpiche
        -   3.2.5 kernel26-pae
        -   3.2.6 linux-pae
        -   3.2.7 rfad
        -   3.2.8 studioidefix
-   4 x86_64 only
    -   4.1 Signed
        -   4.1.1 apathism
        -   4.1.2 freifunk-rheinland
        -   4.1.3 heimdal
        -   4.1.4 infinality-bundle-multilib
        -   4.1.5 siosm-aur
        -   4.1.6 siosm-selinux
        -   4.1.7 subtitlecomposer
        -   4.1.8 xyne-x86_64
    -   4.2 Unsigned
        -   4.2.1 andrwe
        -   4.2.2 archstudio
        -   4.2.3 brtln
        -   4.2.4 hawaii
        -   4.2.5 pnsft-pur
        -   4.2.6 mingw-w64
        -   4.2.7 rightscale
        -   4.2.8 seiichiro
        -   4.2.9 studioidefix
        -   4.2.10 zen
-   5 armv6h only
    -   5.1 Unsigned
        -   5.1.1 arch-fook-armv6h

Any
---

"Any" repositories are architecture-independent. In other words, they
can be used on both i686 and x86_64 systems.

> Signed

infinality-bundle-fonts

-   Maintainer: bohoomil
-   Description: infinality-bundle-fonts repository.
-   Upstream page: Infinality-bundle+fonts
-   Key-ID: 962DDE58

    [infinality-bundle-fonts]
    Server = http://ibn.net63.net/infinality-bundle-fonts

xyne-any

-   Maintainer: Xyne
-   Description: A repository for Xyne's own projects containing
    packages for "any" architecture.
-   Upstream page: http://xyne.archlinux.ca/projects/
-   Key-ID: Not needed, as maintainer is a TU

Note:Use this repository only if there is no matching [xyne-*]
repository for your architecture.

    [xyne-any]
    Server = http://xyne.archlinux.ca/repos/xyne

> Unsigned

archlinuxgr-any

Note:Off-line since 2014-02-16.

-   Maintainer:
-   Description: The Hellenic (Greek) unofficial Arch Linux repository
    with many interesting packages.

    [archlinuxgr-any]
    Server = http://archlinuxgr.tiven.org/archlinux/any

Both i686 and x86_64
--------------------

Repositories with both i686 and x86_64 versions. The $arch variable will
be set automatically by pacman.

> Signed

arcanisrepo

-   Maintainer: arcanis
-   Description: A repository with some AUR packages including packages
    from VCS
-   Key-ID: Not needed, as maintainer is a TU

    [arcanisrepo]
    Server = ftp://repo.arcanis.name/repo/$arch

blackarch

-   Maintainer (There are multiple maintainers. The person listed is the
    one whose key-id is given): Evan Teitelman (paraxor)
-   Description: Tools for penetration testing, security auditing, and
    security research.
-   Upstream page: http://blackarch.org/
-   Key-ID: EA87E4E3

    [blackarch]
    Server = http://blackarch.org/blackarch/$repo/os/$arch

carstene1ns

-   Maintainer: Carsten Teibes
-   Description: AUR packages maintained and/or used by Carsten Teibes
    (games/Wii/lib32/Python)
-   Upstream page: http://arch.carsten-teibes.de (still under
    construction)
-   Key-ID: 2476B20B

    [carstene1ns]
    Server = http://repo.carsten-teibes.de/$arch

catalyst

-   Maintainer: Vi0l0
-   Description: ATI Catalyst proprietary drivers.
-   Upstream Page: http://catalyst.wirephire.com
-   Key-ID: 653C3094

    [catalyst]
    Server = http://catalyst.wirephire.com/repo/catalyst/$arch
    ## Mirrors, if the primary server does not work or is too slow:
    #Server = http://70.239.162.206/catalyst-mirror/repo/catalyst/$arch
    #Server = http://mirror.rts-informatique.fr/archlinux-catalyst/repo/catalyst/$arch

catalyst-hd234k

-   Maintainer: Vi0l0
-   Description: ATI Catalyst proprietary drivers.
-   Upstream Page: http://catalyst.wirephire.com
-   Key-ID: 653C3094

    [catalyst-hd234k]
    Server = http://catalyst.wirephire.com/repo/catalyst-hd234k/$arch
    ## Mirrors, if the primary server does not work or is too slow:
    #Server = http://70.239.162.206/catalyst-mirror/repo/catalyst-hd234k/$arch
    #Server = http://mirror.rts-informatique.fr/archlinux-catalyst/repo/catalyst-hd234k/$arch

city

-   Maintainer: Balló György
-   Description: Experimental/unpopular packages.
-   Upstream page: http://pkgbuild.com/~bgyorgy/city.html
-   Key-ID: Not needed, as maintainer is a TU

    [city]
    Server = http://pkgbuild.com/~bgyorgy/$repo/os/$arch

crypto

-   Maintainer:
-   Description: Includes tomb, tomb-git, and other related software.

    [crypto]
    Server = http://tomb.dyne.org/arch_repo/$arch

demz-repo-core

-   Maintainer:
-   Description: Packages for ZFS on Arch Linux.
-   Upstream page: http://demizerone.com/archzfs
-   Key-ID: 0EE7A126 (temporarily using key 5EE46C4C [1])

    [demz-repo-core]
    Server = http://demizerone.com/$repo/$arch

demz-repo-archiso

-   Maintainer:
-   Description: Packages for installing ZFSfrom an Arch ISO live disk
-   Upstream page: http://demizerone.com/archzfs
-   Key-ID: 0EE7A126 (temporarily using key 5EE46C4C [2])

    [demz-repo-archiso]
    Server = http://demizerone.com/$repo/$arch

gtmanfred

-   Maintainer: Daniel Wallace
-   Description: This repository contains git/svn/hg versions of a lot
    of my packages.
-   Key ID: Not required, as the maintainer is a TU

    [gtmanfred]
    Server = http://code.gtmanfred.com/$repo/$arch

infinality-bundle

-   Maintainer: bohoomil
-   Description: infinality-bundle main repository.
-   Upstream page: Infinality-bundle+fonts
-   Key-ID: 962DDE58

    [infinality-bundle]
    Server = http://ibn.net63.net/infinality-bundle/$arch

pipelight

-   Maintainer:
-   Description: Pipelight and wine-compholio
-   Upstream page: fds-team.de
-   Key-ID: E49CC0415DC2D5CA
-   Keyfile: http://repos.fds-team.de/Release.key

    [pipelight]
    Server = http://repos.fds-team.de/stable/arch/$arch

repo-ck

-   Maintainer: graysky
-   Description: Kernel and modules with Brain Fuck Scheduler and all
    the goodies in the ck1 patch set.
-   Upstream page: repo-ck.com
-   Wiki: repo-ck
-   Key-ID: 5EE46C4C

    [repo-ck]
    Server = http://repo-ck.com/$arch

sergej-repo

-   Maintainer: Sergej Pupykin
-   Description: psi-plus, owncloud-git, ziproxy, android, MySQL, and
    other stuff. Some packages also available for armv7h.
-   Key-ID: Not required, as maintainer is a TU

    [sergej-repo]
    Server = http://repo.p5n.pp.ru/$repo/os/$arch

> Unsigned

Note:Users will need to add the following to these entries:
SigLevel = PackageOptional

alucryd

-   Maintainer: Maxime Gauduin
-   Description: Repository containing various packages Maxime Gauduin
    maintains (or not) in the AUR.

    [alucryd]
    Server = http://pkgbuild.com/~alucryd/$repo/$arch

archaudio

-   Maintainer: Ray Rashif, Joakim Hernberg
-   Description: Pro-audio packages

    [archaudio-production]
    Server = http://repos.archaudio.org/$repo/$arch

archie-repo

-   Maintainer: Kalinda
-   Description: Repo for wine-silverlight, pipelight, and some misc
    packages.

    [archie-repo]
    Server = http://andontie.net/archie-repo/$arch

archlinuxcn

-   Maintainer:
-   Description: The Chinese Arch Linux communities packages.

    [archlinuxcn]
    Server = http://repo.archlinuxcn.org/$arch

archlinuxfr

-   Maintainer:
-   Description:
-   Upstream page: http://afur.archlinux.fr

    [archlinuxfr]
    Server = http://repo.archlinux.fr/$arch

archlinuxgis

-   Maintainer:
-   Description: Maintainers needed - low bandwidth

    [archlinuxgis]
    Server = http://archlinuxgis.no-ip.org/$arch

archlinuxgr

Note:Off-line since 2014-02-16.

-   Maintainer:
-   Description:

    [archlinuxgr]
    Server = http://archlinuxgr.tiven.org/archlinux/$arch

archlinuxgr-kde4

Note:Off-line since 2014-02-16.

-   Maintainer:
-   Description: KDE4 packages (plasmoids, themes etc) provided by the
    Hellenic (Greek) Arch Linux community

    [archlinuxgr-kde4]
    Server = http://archlinuxgr.tiven.org/archlinux-kde4/$arch

archstuff

Note:Off-line since 2014-01-06.

-   Maintainer:
-   Description: AUR's most voted and many bin32-* and lib32-* packages.

    [archstuff]
    Server = http://archstuff.vs169092.vserver.de/$arch

arsch

-   Maintainer:
-   Description: From users of orgizm.net

    [arsch]
    Server = http://arsch.orgizm.net/$arch

aurbin

-   Maintainer:
-   Description: Automated build of AUR packages

    [aurbin]
    Server = http://aurbin.net/$arch

cinnamon

-   Maintainer:
-   Description: Stable and actively developed Cinnamon packages
    (Applets, Themes, Extensions), plus others (Hotot, qBitTorrent, GTK
    themes, Perl modules, and more).

    [cinnamon]
    Server = http://archlinux.zoelife4u.org/cinnamon/$arch

ede

-   Maintainer:
-   Description: Equinox Desktop Environment repository

    [ede]
    Server = http://www.equinox-project.org/repos/arch/$arch

haskell-core

-   Maintainer:
-   Description: Arch-Haskell repository
-   Upstream page: Haskell Package Guidelines

    [haskell-core]
    Server = http://xsounds.org/~haskell/core/$arch

heftig

-   Maintainer: Jan Steffens
-   Description: Includes linux-zen and aurora (Firefox development
    build - works alongside firefox in the extra repository).
-   Upstream page: https://bbs.archlinux.org/viewtopic.php?id=117157

    [heftig]
    Server = http://pkgbuild.com/~heftig/repo/$arch

herecura-stable

-   Maintainer:
-   Description: additional packages not found in the community
    repository

    [herecura-stable]
    Server = http://repo.herecura.be/herecura-stable/$arch

herecura-testing

-   Maintainer:
-   Description: additional packages for testing build against stable
    arch

    [herecura-testing]
    Server = http://repo.herecura.be/herecura-testing/$arch

jelle

-   Maintainer:
-   Description:

    [jelle]
    Server = http://pkgbuild.com/~jelle/repo/$arch

mesa-git

-   Maintainer:
-   Description: Mesa git builds for the testing and multilib-testing
    repositories

    [mesa-git]
    Server = http://pkgbuild.com/~lcarlier/$repo/$arch

oracle

-   Maintainer:
-   Description: Oracle database client

Warning:By adding this you are agreeing to the Oracle license at
http://www.oracle.com/technetwork/licenses/instant-client-lic-152016.html

    [oracle]
    Server = http://linux.shikadi.net/arch/$repo/$arch/

pantheon

-   Maintainer: Maxime Gauduin
-   Description: Repository containing Pantheon-related packages

    [pantheon]
    Server = http://pkgbuild.com/~alucryd/$repo/$arch

paulburton-fitbitd

-   Maintainer:
-   Description: Contains fitbitd for synchronizing FitBit trackers

    [paulburton-fitbitd]
    Server = http://www.paulburton.eu/arch/fitbitd/$arch

pfkernel

-   Maintainer: nous
-   Description: Generic and optimized binaries of the ARCH kernel
    patched with BFS, TuxOnIce, BFQ, Aufs3, linux-pf, kernel26-pf,
    gdm-old, nvidia-pf, nvidia-96xx, xchat-greek, arora-git
-   Note: To browse through the repository, one needs to append
    index.html after the server URL (this is an intentional quirk of
    Dropbox). For example, for x86_64, point your browser to
    http://dl.dropbox.com/u/11734958/x86_64/index.html or start at
    http://tiny.cc/linux-pf

    [pfkernel]
    Server = http://dl.dropbox.com/u/11734958/$arch

suckless

-   Maintainer:
-   Description: suckless.org packages

    [suckless]
    Server = http://dl.suckless.org/arch/$arch

unity

-   Maintainer:
-   Description: unity packages for Arch

    [unity]
    Server = http://unity.xe-xe.org/$arch

unity-extra

-   Maintainer:
-   Description: unity extra packages for Arch

    [unity-extra]
    Server = http://unity.xe-xe.org/extra/$arch

unity

-   Maintainer:
-   Description: unity packages for Arch

    [unity]
    Server = http://unity.humbug.in/$arch

unity-extra

-   Maintainer:
-   Description: unity extra packages for Arch

    [unity-extra]
    Server = http://unity.humbug.in/extra/$arch

home_tarakbumba_archlinux_Arch_Extra_standard

-   Maintainer:
-   Description: Contains a few pre-built AUR packages (zemberek,
    firefox-kde-opensuse, etc.)

    [home_tarakbumba_archlinux_Arch_Extra_standard]
    Server = http://download.opensuse.org/repositories/home:/tarakbumba:/archlinux/Arch_Extra_standard/$arch

i686 only
---------

> Signed

eee-ck

-   Maintainer:
-   Description: Kernel and modules optimized for Asus Eee PC 701, with
    -ck patchset.

    [eee-ck]
    Server = http://zembla.shatteredsymmetry.com/repo

xyne-i686

-   Maintainer: Xyne
-   Description: A repository for Xyne's own projects containing
    packages for the "i686" architecture.
-   Upstream page: http://xyne.archlinux.ca/projects/
-   Key-ID: Not required, as maintainer is a TU

Note:This includes all packages in [xyne-any].

    [xyne-i686]
    Server = http://xyne.archlinux.ca/repos/xyne

> Unsigned

andrwe

-   Maintainer: Andrwe Lord Weber
-   Description: each program I'm using on x86_64 is compiled for i686
    too
-   Upstream page: http://andrwe.org/linux/repository

    [andrwe]
    Server = http://repo.andrwe.org/i686

batchbin

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: Who is the       
                           maintainer? (Discuss)    
  ------------------------ ------------------------ ------------------------

Note:Offline since 2014-02-15.

-   Maintainer:
-   Description: My personal projects and utilities which I feel can
    benefit others.

    [batchbin]
    Server = http://batchbin.ueuo.com/archlinux

esclinux

-   Maintainer:
-   Description: Mostly games, interactive fiction, and abc notation
    stuff already on the AUR.

    [esclinux]
    Server = http://download.tuxfamily.org/esclinuxcd/ressources/repo/i686/

kpiche

-   Maintainer:
-   Description: Stable OpenSync packages.

    [kpiche]
    Server = http://kpiche.archlinux.ca/repo

kernel26-pae

-   Maintainer:
-   Description: PAE-enabled 32-bit kernel 2.6.39

    [kernel26-pae]
    Server = http://kernel26-pae.archlinux.ca/

linux-pae

-   Maintainer:
-   Description: PAE-enabled 32-bit kernel 3.0

    [linux-pae]
    Server = http://pae.archlinux.ca/

rfad

-   Maintainer: requiem [at] archlinux.us
-   Description: Repository made by haxit

    [rfad]
    Server = http://web.ncf.ca/ey723/archlinux/repo/

studioidefix

-   Maintainer:
-   Description: Precompiled boxee packages.

    [studioidefix]
    Server = http://studioidefix.googlecode.com/hg/repo/i686

x86_64 only
-----------

> Signed

apathism

-   Maintainer: Koryabkin Ivan (apathism)
-   Upstream page: https://apathism.net/
-   Description: AUR packages that would take long to build, such as
    firefox-kde-opensuse.
-   Key-ID: 3E37398D
-   Keyfile: http://apathism.net/archlinux/apathism.key

    [apathism]
    Server = http://apathism.net/archlinux/

freifunk-rheinland

-   Maintainer: nomaster
-   Description: Packages for the Freifunk project: batman-adv, batctl,
    fastd and dependencies.

    [freifunk-rheinland]
    Server = http://mirror.fluxent.de/archlinux-custom/$repo/os/$arch

heimdal

Note:Offline since 2014-03-06.

-   Maintainer:
-   Description: Packages are compiled against Heimdal instead of MIT
    KRB5. Meant to be dropped before [core] in pacman.conf. All packages
    are signed.
-   Upstream page: https://github.com/Kiwilight/Heimdal-Pkgbuilds

Warning:Be careful. Do not use this unless you know what you are doing
because many of these packages override packages from the core and extra
repositories

    [heimdal]
    Server = http://www.kiwilight.com/heimdal/$arch/

infinality-bundle-multilib

-   Maintainer: bohoomil
-   Description: infinality-bundle multilib repository.
-   Upstream page: Infinality-bundle+fonts
-   Key-ID: 962DDE58

    [infinality-bundle-multilib]
    Server = http://ibn.net63.net/infinality-bundle-multilib/$arch

siosm-aur

-   Maintainer: Timothee Ravier
-   Description: packages also available in the Arch User Repository,
    sometimes with minor fixes
-   Upstream page: https://tim.siosm.fr/repositories/
-   Key-ID: 78688F83

    [siosm-aur]
    Server = http://repo.siosm.fr/$repo/

siosm-selinux

-   Maintainer: Timothee Ravier
-   Description: packages required for SELinux support – work in
    progress (notably, missing an Arch Linux-compatible SELinux policy).
    See the SELinux page for details.
-   Upstream page: https://tim.siosm.fr/repositories/
-   Key-ID: 78688F83

    [siosm-selinux]
    Server = http://repo.siosm.fr/$repo/

subtitlecomposer

-   Maintainer: Mladen Milinkovic (maxrd2)
-   Description: Subtitle Composer stable and nightly builds
-   Upstream page: https://github.com/maxrd2/subtitlecomposer
-   Key-ID: EA8CEBEE

    [subtitlecomposer]
    Server = http://smoothware.net/$repo/$arch

xyne-x86_64

-   Maintainer: Xyne
-   Description: A repository for Xyne's own projects containing
    packages for the "x86_64" architecture.
-   Upstream page: http://xyne.archlinux.ca/projects/
-   Key-ID: Not required as maintainer is a TU

Note:This includes all packages in [xyne-any].

    [xyne-x86_64]
    Server = http://xyne.archlinux.ca/repos/xyne

> Unsigned

Note:Users will need to add the following to these entries:
SigLevel = PackageOptional

andrwe

-   Maintainer: Andrwe Lord Weber
-   Description: contains programs I'm using on many systems
-   Upstream page: http://andrwe.dyndns.org/doku.php/blog/repository
    [dead link 2013-11-30]

    [andrwe]
    Server = http://repo.andrwe.org/x86_64

archstudio

-   Maintainer:
-   Description: Audio and Music Packages optimized for Intel Core i3,
    i5, and i7.
-   Upstream page: http://www.xsounds.org/~archstudio

    [archstudio]
    Server = http://www.xsounds.org/~archstudio/x86_64

brtln

-   Maintainer: Bartłomiej Piotrowski
-   Description: Alpha releases of MariaDB, Wine with win32 support
    only, and some VCS packages.

    [brtln]
    Server = http://pkgbuild.com/~barthalion/brtln/$arch/

hawaii

-   Maintainer:
-   Description: hawaii Qt5/Wayland-based desktop environment
-   Upstream page: http://www.maui-project.org/

    [hawaii]
    Server = http://archive.maui-project.org/archlinux/$repo/os/$arch

pnsft-pur

-   Maintainer:
-   Description: Japanese input method packages Mozc (vanilla) and
    libkkc

    [pnsft-pur]
    Server = http://downloads.sourceforge.net/project/pnsft-aur/pur/x86_64

mingw-w64

-   Maintainer:
-   Description: Almost all mingw-w64 packages in the AUR updated every
    8 hours.
-   Upstream page: http://arch.linuxx.org

    [mingw-w64]
    Server = http://downloads.sourceforge.net/project/mingw-w64-archlinux/$arch
    Server = http://arch.linuxx.org/archlinux/$repo/os/$arch

rightscale

-   Maintainer: Chris Fordham <chris@fordham-nagy.id.au>
-   Description: Packages for RightScale including the RightLink cloud
    instance agent. Install the package, rightscale-agent.

    [rightscale]
    Server = https://s3-us-west-1.amazonaws.com/archlinux-rightscale/$arch

seiichiro

-   Maintainer:
-   Description: VDR and some plugins, mms, foo2zjs-drivers

    [seiichiro]
    Server = http://repo.seiichiro0185.org/x86_64

studioidefix

-   Maintainer:
-   Description: Precompiled boxee packages.

    [studioidefix]
    Server = http://studioidefix.googlecode.com/hg/repo/x86_64

zen

Note:Offline since 2014-03-06.

-   Maintainer:
-   Description: Various and zengeist AUR packages.

    [zen]
    Server = http://zloduch.cz/archlinux/x86_64

armv6h only
-----------

> Unsigned

arch-fook-armv6h

-   Maintainer: Jaska Kivelä <jaska@kivela.net>
-   Description: Stuff that I have compiled for my Raspberry PI.
    Including Enlightenment and home automation stuff.

    [arch-fook-armv6h]
    Server = http://kivela.net/jaska/arch-fook-armv6h

Retrieved from
"https://wiki.archlinux.org/index.php?title=Unofficial_user_repositories&oldid=303823"

Category:

-   Package management

-   This page was last modified on 9 March 2014, at 17:53.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
