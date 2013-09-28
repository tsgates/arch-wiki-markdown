Unofficial User Repositories
============================

Since the AUR only allows users to upload PKGBUILD and other package
build related files, but does not provide a means for distributing a
binary package, a user may want to create a binary repository of their
packages elsewhere. See Pacman Tips#Custom local repository for more
information.

If you have your own repository, please add it to this page, so that all
the other users will know where to find your packages.

Please keep the lists in alphabetical order.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 List of unofficial user repositories                               |
|     -   1.1 Any                                                          |
|         -   1.1.1 Unsigned                                               |
|         -   1.1.2 Signed                                                 |
|                                                                          |
|     -   1.2 Both i686 and x86_64                                         |
|         -   1.2.1 Signed                                                 |
|         -   1.2.2 Unsigned                                               |
|                                                                          |
|     -   1.3 i686 only                                                    |
|         -   1.3.1 Signed                                                 |
|         -   1.3.2 Unsigned                                               |
|                                                                          |
|     -   1.4 x86_64 only                                                  |
|         -   1.4.1 Signed                                                 |
|         -   1.4.2 Unsigned                                               |
|                                                                          |
|     -   1.5 armv6h only                                                  |
|         -   1.5.1 Unsigned                                               |
+--------------------------------------------------------------------------+

List of unofficial user repositories
------------------------------------

> Any

"Any" repos are architecture-independent, i.e. they can be used on both
i686 and x86_64 systems.

Unsigned

    [arch-fonts]
    # Prebuilt packages for font packages found in AUR
    # This should be faster than building from source
    # as many have download speed of 10KB/s. If you find
    # missing font, email to <gmail.com: jesse.jaara>
    # Now with pkgfile support.
    Server = http://huulivoide.pp.fi/Arch/arch-fonts

    [archlinuxgr-any]
    # The Hellenic (Greek) archlinux unofficial repository with many interesting packages.
    Server = http://archlinuxgr.tiven.org/archlinux/any

Signed

    [xyne-any]
    # A repo for Xyne's own projects: http://xyne.archlinux.ca/projects/
    # Packages for "any" architecture.
    # Use this repo only if there is no matching [xyne-*] repo for your architecture.
    SigLevel = Required
    Server = http://xyne.archlinux.ca/repos/xyne

> Both i686 and x86_64

Signed

    [allanbrokeit]
    # http://allanmcrae.com/2011/06/the-allanbrokeit-repo-that-might-really-break-your-system/
    SigLevel = Required
    Server = http://allanmcrae.com/$repo/$arch

    [archnetflix]
    # Packages for viewing Netflix through patched WINE.
    # See http://demizerone.com/archnetflix
    SigLevel = Required
    Server = http://demizerone.com/$repo/community/$arch

    [ayatana]
    # Unity and related packages
    # http://pkgbuild.com/~bgyorgy/ayatana.html
    SigLevel = PackageRequired
    Server = http://pkgbuild.com/~bgyorgy/$repo/os/$arch

    [archzfs]
    # Packages for ZFS on Arch Linux
    # See http://demizerone.com/archzfs
    SigLevel = Required
    Server = http://demizerone.com/$repo/core/$arch

    [catalyst]
    # ATI Catalyst proprietary drivers.
    Server = http://catalyst.wirephire.com/repo/catalyst/$arch

    [city]
    # Experimental/unpopular packages
    # http://pkgbuild.com/~bgyorgy/city.html
    SigLevel = PackageRequired
    Server = http://pkgbuild.com/~bgyorgy/$repo/os/$arch

    [crypto]
    # Includes tomb, tomb-git and other related software
    SigLevel = Required
    Server = http://tomb.dyne.org/arch_repo/$arch

    [gtmanfred]
    SigLevel=Required
    # This repo contains git/svn/hg versions of a lot of my packages
    Server = http://code.gtmanfred.com/$repo/$arch

    [heftig]
    # Includes linux-zen and aurora (firefox development build - works alongside firefox in extra.)
    # https://bbs.archlinux.org/viewtopic.php?id=117157
    SigLevel = PackageOptional
    Server = http://pkgbuild.com/~heftig/repo/$arch

    [repo-ck]
    # ARCH kernel and modules with Brain Fuck Scheduler and all the goodies in the ck1 patch set
    # See the linux-ck wiki page for more
    # packages are signed
    Server = http://repo-ck.com/$arch

    [sergej-repo]
    # notion, psi-plus and some other stuff.
    # http://code.google.com/p/archlinux-stuff/source/browse/trunk
    Server = http://repo.p5n.pp.ru/$repo/os/$arch

Unsigned

Repositories with both i686 and x86_64 versions. The $arch variable will
be set automatically by pacman.

    [archaudio-production]
    # verified PKGBUILDs AND tested packages
    Server = http://repos.archaudio.org/$repo/$arch
     
    [archaudio-preview]
    # unverified PKGBUILDs AND/OR untested packages
    Server = http://repos.archaudio.org/$repo/$arch
     
    [archaudio-nightly]
    # verified devel PKGBUILDs
    Server = http://repos.archaudio.org/$repo/$arch
     
    [archaudio-experimental]
    # unverified devel PKGBUILDs
    Server = http://repos.archaudio.org/$repo/$arch

    [archlinuxcn]
    #The Chinese Arch Linux communities packages.
    Server = http://repo.archlinuxcn.org/$arch

    [archlinuxfr]
    # For a list of packages see http://afur.archlinux.fr
    SigLevel = Never
    Server = http://repo.archlinux.fr/$arch

    [archlinuxgis]
    # Maintainers needed - low bandwidth
    SigLevel = PackageOptional
    Server = http://archlinuxgis.no-ip.org/$arch

    [archlinuxgr]
    # For a list of packages see http://archlinuxgr.tiven.org/archlinux
    Server = http://archlinuxgr.tiven.org/archlinux/$arch

    [archlinuxgr-kde4]
    # KDE4 packages (plasmoids, themes etc) provided by the Hellenic (Greek) archlinux community
    Server = http://archlinuxgr.tiven.org/archlinux-kde4/$arch

    [archstuff]
    # AUR's most voted and many bin32-* and lib32-* packages.
    Server = http://archstuff.vs169092.vserver.de/$arch

    [arsch]
    # From users of orgizm.net
    Server = http://arsch.orgizm.net/$arch

    [aurbin]
    # Automated build of AUR packages
    SigLevel = Never
    Server = http://aurbin.net/$arch

    [cinnamon]
    # Stable and actively developed Cinnamon pkgs
    # Applets, Themes, Extensions, plus others
    # Hotot, qBitTorrent, GTK Themes, Perl Mods and more
    Server = http://archlinux.zoelife4u.org/cinnamon/$arch

    [ede]
    # Equinox Desktop Environment repository
    Server = http://www.equinox-project.org/repos/arch/$arch

    [haskell-core]
    # Arch-Haskell repository
    # More details: https://wiki.archlinux.org/index.php/Haskell_package_guidelines
    Server = http://xsounds.org/~haskell/core/$arch

    [herecura-stable]
    # additional apps not found in community
    Server = http://repo.herecura.be/herecura-stable/$arch

    [herecura-testing]
    # additional apps for testing build against stable arch
    Server = http://repo.herecura.be/herecura-testing/$arch

    [infinality-bundle]
    # infinality-bundle main repo
    Server = http://bohoomil.cu.cc/infinality-bundle/$arch

    [infinality-bundle-multilib]
    # infinality-bundle multilib repo
    Server = http://bohoomil.cu.cc/infinality-bundle-multilib/$arch

    [mate]
    # Contains official mate desktop packages (gnome2 fork)
    Server = http://repo.mate-desktop.org/archlinux/$arch

    [paulburton-fitbitd]
    # Contains fitbitd for synchronizing FitBit trackers
    SigLevel = Optional
    Server = http://www.paulburton.eu/arch/fitbitd/$arch

    [mesa-git]
    # mesa git builds for testing and multilib-testing 
    Server = http://pkgbuild.com/~lcarlier/$repo/$arch

    [pfkernel]
    # Generic and optimized binaries of the ARCH kernel patched with BFS, TuxOnIce, BFQ, Aufs3
    # linux-pf, kernel26-pf, gdm-old, nvidia-pf, nvidia-96xx, xchat-greek, arora-git
    Server = http://dl.dropbox.com/u/11734958/$arch

    [unity]
    # unity packages for arch
    Server = http://unity.xe-xe.org/$arch

    [unity-extra]
    # unity extra packages for arch
    Server = http://unity.xe-xe.org/extra/$arch

    [unity]
    # unity packages for arch
    Server = http://unity.humbug.in/$arch

    [unity-extra]
    # unity extra packages for arch
    Server = http://unity.humbug.in/extra/$arch

    [suckless]
    # suckless.org packages
    Server = http://dl.suckless.org/arch/$arch

    [ home_tarakbumba_archlinux_Arch_Extra_standard]
    # few prebuild aur packages (zemberek, firefox-kde-opensuse, etc.)
    SigLevel = Optional TrustAll
    Server = http://download.opensuse.org/repositories/home:/tarakbumba:/archlinux/Arch_Extra_standard/$arch

> i686 only

Signed

    [eee-ck]
    # kernel and modules optimized for Asus Eee PC 701, with -ck patchset.
    # this replaces the now defunct http://dl.dropbox.com/u/15563529/eee-ck
    SigLevel = PackageRequired
    Server = http://zembla.shatteredsymmetry.com/repo

    [xyne-i686]
    # A repo for Xyne's own projects: http://xyne.archlinux.ca/projects/
    # Packages for the "i686" architecture.
    # Note that this includes all packages in [xyne-any].
    SigLevel = Required
    Server = http://xyne.archlinux.ca/repos/xyne

Unsigned

    [andrwe]
    # For a list of packages see: http://andrwe.org/linux/repository
    Server = http://repo.andrwe.org/i686

    [batchbin]
    # My personal projects and utilities which I feel can benifit others
    SigLevel = Never
    Server = http://batchbin.ueuo.com/archlinux

    [esclinux]
    # Mostly games, interactive fiction and abc notation stuffs already on AUR.
    Server = http://download.tuxfamily.org/esclinuxcd/ressources/repo/i686/

    [kpiche]
    # Stable OpenSync packages.
    Server = http://kpiche.archlinux.ca/repo

    [kernel26-pae]
    # PAE-enabled 32-bit kernel 2.6.39
    Server = http://kernel26-pae.archlinux.ca/

    [linux-pae]
    # PAE-enabled 32-bit kernel 3.0
    Server = http://pae.archlinux.ca/

    [mingw32]
    # Libs & tools for crosscompiling for Win32, mainly taken from AUR.
    # Contact: Alexander 'hatred' Drozdov <adrozdoff [at] gmail (dot) com> (Russian-speaked guys can write on Russian :-)
    Server = http://hatred.homelinux.net/archlinux/mingw32/os/i686

    [rfad]
    # Repository made by haxit | Contact at: requiem [at] archlinux.us for package suggestions!
    Server = http://web.ncf.ca/ey723/archlinux/repo/

    [studioidefix]
    # Precompiled boxee packages.
    Server = http://studioidefix.googlecode.com/hg/repo/i686

> x86_64 only

Signed



    [heimdal]
    # SigLevel = Required
    # Packages are compiled against Heimdal instead of MIT KRB5. Meant to be dropped
    # before [core] in pacman.conf. All packages are signed. Be careful, don't use
    # this unless you know what you're doing as many of these packages override [core]
    # and [extra]. The source is available at:
    # https://github.com/Kiwilight/Heimdal-Pkgbuilds
    Server = http://www.kiwilight.com/heimdal/$arch/

    [xyne-x86_64]
    # A repo for Xyne's own projects: http://xyne.archlinux.ca/projects/
    # Packages for the "x86_64" architecture.
    # Note that this includes all packages in [xyne-any].
    SigLevel = Required
    Server = http://xyne.archlinux.ca/repos/xyne

Unsigned

    [andrwe]
    # For a list of packages see: http://andrwe.dyndns.org/doku.php/blog/repository
    Server = http://repo.andrwe.org/x86_64

    [arch-desktop]
    # This repo contains only a handful of packages that work together to create a consistent, usable ArchLinux desktop.
    Server = http://wooptoo.com/arch-desktop/x86_64/

    [archstudio]
    # Audio and Music Packages 
    # optimized for Intel Core i3,i5 i7  
    # Details: http://www.xsounds.org/~archstudio
    Server = http://www.xsounds.org/~archstudio/x86_64

    [hawaii]
    #hawaii Qt5/Wayland-based desktop environment
    #http://www.maui-project.org/en/
    Server = http://archive.maui-project.org/archlinux/$repo/os/$arch
    SigLevel = TrustAll

    [pyropeter]
    # My AUR packages: https://aur.archlinux.org/packages.php?SeB=m&K=pyropeter
    Server = http://pyropeter.eu/arch/pyropeter

    [seiichiro]
    # VDR and some plugins, mms, foo2zjs-drivers
    Server = http://repo.seiichiro0185.org/x86_64

    [studioidefix]
    # Precompiled boxee packages.
    Server = http://studioidefix.googlecode.com/hg/repo/x86_64

    [zen]
    # Various and zengeist' AUR packages.
    Server = http://zloduch.cz/archlinux/x86_64

> armv6h only

Unsigned

    [arch-fook-armv6h]
    # Enligthenment and home automation stuff for the Raspberry PI
    Server = http://kivela.net/jaska/arch-fook-armv6h

Retrieved from
"https://wiki.archlinux.org/index.php?title=Unofficial_User_Repositories&oldid=255855"

Category:

-   Package management
