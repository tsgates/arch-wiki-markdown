AUR Cleanup Day/2010
====================

This event happened in September 2010 (Source).

TUs are currently working through the list. You can still add packages
but please check the whole page first. The TUs will not delete any
useful package.

The AUR has a large number of obsolete packages which could use cleaning
up. Examples of packages that may be cleaned up are:

-   packages that have been renamed or replaced
-   old and unmaintained developmental (cvs/svn/etc) packages

Post suggestions of packages on this pages. Trusted Users will get
together and go though the list in a couple of weeks and confirm which
packages should be removed.

Please DO NOT REMOVE suggestions from the wiki page but add a comment on
why it should be kept instead. Please list packages in alphabetical
order!

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Package List                                                       |
| -   2 TU Working Area                                                    |
|     -   2.1 Packages to Remove                                           |
|     -   2.2 Packages to Keep                                             |
|                                                                          |
| -   3 Remove from Filesystem                                             |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Package List
------------

Add new packages here - check for the package in the sorted lists below
before adding

-   bmp-flac - doesnt work anymore
-   bmp-scrobbler - doesnt work anymore
-   boxee - deprecated by boxee-source
-   ct - project page and sources aren't available
-   divifund - "dead" project; it's very old and doesn't work with the
    latest versions of its dependencies
-   drift - project page and sources aren't available
-   eclipse-i18n-pack1 - not needed anymore (it's for old eclipse),
    broken source link
-   eclipse-i18n-pack2 - not needed anymore (it's for old eclipse),
    broken source link
-   eclipse-i18n-pack2a - not needed anymore (it's for old eclipse),
    broken source link
-   eclipse-i18n-packbidi - not needed anymore (it's for old eclipse),
    broken source link
-   entropy-cvs - old dev-version, Enlightenment project uses svn now
-   eselect - is it needed in Arch Linux?
-   evfs-cvs - old dev-version, Enlightenment project uses svn now
-   exquisite-cvs - old dev-version, Enlightenment project uses svn now
-   falldown - project page and sources aren't available
-   fbpager-git - broken links (see comment by hadrurus)

<--firefox-like pkgs cleaning-->

-   bin32-swiftweasel-athlon64 - outdated from a long time.
-   firefox-nightly - this one should be renamed - it's prebuild binary
    and uses the same name schema as Firefoxes compiled from source.
-   firefox2 - outdated, deprecated by upstream.
-   firefox2-spell-es_ar - deprecated by upstream.
-   firefox2-spell-es_es - deprecated by upstream.
-   swiftweasel-amd-pgo - outdated, orphaned.

<--end of firefox-like pkgs-->

-   fluxbox-boxcolors-themes - replaced by fluxbox-colorflux-themes
-   freedcpp - replaced by freedcpp-svn
-   gnome-exotic-theme - replaced by gnome-theme-exotic
-   gnome-wild-shine-theme - duplicate of gnome-theme-wild-shine
-   gootool - replaced by worldofgoo-gootool
-   haskell-data-cordering - project page and sources aren't available
    anymore
-   haskell-data-tree-avl - project page and sources aren't available
    anymore
-   icegilgrey - project page and sources aren't available anymore
-   icns2png - replaced by libicns
-   kalsamix - "dead" project and too old to be useful
-   kdedecor-pureline - broken links, too old, not maintained
-   konch - broken links, too old, not maintained
-   ktu - project page and sources aren't available
-   latex-template-ieee - included in extra/texlive-publishers
-   libccfits - replaced by ccfits [1]
-   libcoaster - project page and sources aren't available, and too old
    to be useful
-   libpsychrometric - "dead" project, not maintained
-   libsipphoneapi-oss - very old, it seems not needed anymore
-   maxreloaded - replaced by maxr
-   manslide - replaced by smile
-   mupad - sources are no longer available
-   mupad-packages - sources are no longer available
-   ndn-beta - it's old beta version, broken source link, replaced by
    ndn
-   netscape-navigator - closed-sources, end of support by netscape --
    Does it still work? If so, no need to delete.
-   perl-date-korean - maintainer wrotes that it may be deleted
-   perl-threads - already included in core/perl
-   picasa-beta - there's picasa so I'm not sure if we need both
-   policykit1-gnome - obsoleted by extra/polkit-gnome
-   pyetk - dropped upstream
-   python-etk-svn - dropped upstream
-   snort-sam - too old and not maintained; there is snort in extra
-   snortsam - see comment for snort-sam
-   spring-mod-ca - obsolete, not maintained, replaced by springlobby
    (see comment by DuGi)
-   sqcam-cvs - depend on kernel26 and was not update since 1 year...
-   stepmania-cvs-extras - broken source links, same as stepmania-extras
-   tempest_for_eliza - project page and sources aren't available
-   tklor - this is a tool for reading forum "linux.org.ru"; development
    discontinued, project page deleted and current version doesn't work
-   viceplus - maintainer wrotes that it may be deleted
-   vim-colorschemes (372) and vim-colorsamplerpack (100) - OK to keep
    both packages but vim-colorsamplerpack is subset of
    vim-colorschemes. vim.org = 395 color schemes
-   vim-(individual color schemes) - there is 65 orphan individual
    colorschemes where 40 we can be found in vim-colorschemes or
    vim-colorsamplerpack. I can send a list
-   vim-(packages) - there 331 packages where almost all redirect to
    vim.org. Nice to have a lot packages in AUR bur we can search on
    vim.org (+2800 packages)!
-   xcursor-openzone-white - replaced by xcursor-openzone
-   xmltv-tv_grab_de_prisma - project page and sources aren't available
-   xulrunner-thai - too old to be useful, broken source link -- hm,
    what is jgc's opinion?
-   bash-bookmarks -this package is no longer needed (see comments)
-   gtkada -- svn build, PKGBUILD needs changes, can't get ahold of
    current maintainer
-   alacarte-xfce-devel - Dead project. Does not build with latest
    dependencies.
-   snowballz - Dead project that no longer works due a using a
    deprecated module from python-rabbyt.

TU Working Area
---------------

For editing by TUs only! The wiki has a history so do not think you can
get away with ignoring this... --Allan

> Packages to Remove

In community:

-   lmctl - replaced by lomoco --Allan
-   xchat-systray-integration - Xchat is integrated with systray with

> Packages to Keep

-   atmel-firmware - no longer needed -- why?
-   autoconf-compat - too old to be useful -- it is for compiling old
    stuff, lets keep it, does not harm
-   aur-install - does this one still work and do we need it anyway? --
    Seems to be actively maintained, no reason to delete. -- package is
    already REMOVED
-   amsn-plugins-texim - no longer exists -- it's here: [2]
    (StefanHusmann) -- package is already REMOVED
-   bin32-flashplayer-standalone - not needed anymore -- Still useful,
    because there is no native standalone flash player from Adobe on
    x86_64 systems. Mightyjaym (maintener)
-   blastwave - Dead projet, doesn't compile anymore. -- stefanhusmann:
    maybe only needs a maintainer.
-   btrfs - newer version (0.15) available, released May 29th, 2008. --
    So this package should maybe be orphaned, no obvious reason to
    delete it. [Edit: orphaning should be requested in the aur-general
    mailing list. Dragonlord] -- package is already REMOVED
-   btrfs-progs - newer version (0.15) available, released May 29th,
    2008. -- So this package should maybe be orphaned, no obvious reason
    to delete it.
-   cairo-wglitz - not needed anymore -- needed by cairo-dock
-   chocolate-doom-svn - package is broken. cause of AUR -- it is
    maintained.
-   cputnik - apparently "dead" project, broken links -- package has new
    and active maintainer
-   eclipse33 - not needed anymore -- No reason to delete, actively
    maintained StefanHusmann
-   editobj2 - not needed anymore -- needed by songwrite2, I asked the
    maintainer to take it. (stefanhusmann)
-   empathy - empathy is in extra -- empathy is orpaned in [testing], no
    package in extra (stefanhusmann)
-   fluxbox-styles-boxwhore - boxwhore website is dead -- no, it seems
    to be down sometimes, but sometimes it works again. Package is
    maintained and has votes. (stefanhusmann)
-   galeon - doesn't compile (not even the latest version) -- seems to
    be actively maintained (stefanhusmann)
-   gdal Contributor seems to be inactive. Newer version available so
    this package should maybe be orphaned, no obvious reason to delete
    it. NOTE : updated on sept 24 2008. -- in [community]
-   gltail - apparently, this is not needed anymore (see comment) --
    Should be rewritten, not dropped.
-   gnuserv - Deprecated in emacs-22+ - Please do not delete : see [3]
    The package never belonged to GNU emacs.(stefanhusmann)
-   gshare - The package didn't function for me with the latest gnome.
    Furthermore it looks like this project is dead (website is down,
    source is no longer available) -- it is in [community]
-   gvfs-smbfix - smb browse fix in gvfs 1.2 -- actively maintained
-   kanola - probably dead project, didn't went past the 0.0.1 release
    since 2006 -- PKGBUILD is maintained and maintainer is active.
-   klibc-zen - not needed anymore theres not even a kernel26zen. --
    there is, but I orphand the package.
-   ii-hg - outdated, probably discontinued as the project website isn't
    available anymore (moved maybe?)
    -   The project website is available at
        http://www.suckless.org/wiki/tools/irc/irc_it, so it's not dead.
        It only needs some changes to work again. --CuleX -- actively
        maintained

-   lam 7.1.3-1 - Doesn't compile and is orphaned. The successor openmpi
    works. -- actively maintained
-   lastfmsubmitd - Way old. -- actively maintained in [community]
-   mencode - outdated, tells aur is its homepage
    -   The package is to install a perl script included in the AUR
        tarball so it doesn't really have a home page. So it could be
        kept if the script can still be useful or, at least, the script
        could be moved to the wiki if there is a page for scripts.
        --Snowman

-   mpd-pausemode - "Website" is orig. contributor's email addr.;
    orphaned by this contributor, so presumably no longer developed. --
    no obvious need to delete
-   mlame - just a small bash script, no project page, could be moved to
    the wiki maybe -- actively maintained
-   mouseemu - Project not updated since 2006; xautomation also allows
    mouse emulation. -- package builds with little tweaking.
-   mplayer-w32codecs - not duplicate package as has more codecs than
    the "codecs" package. -- package is already REMOVED
    -   Should rename to "codecs-extra" and not provide same files as
        codecs package --Allan

-   netbeans-cpp_6.1-1 - not needed anymore -- seems to be maintained.
-   netbeans-ruby_6.1-1 - not needed anymore -- seems to be maintained.
-   ndiswrapper-zen - not needed anymore. theres not even a
    kernel26zen.-- there is. Orphaned.
-   nvidia-96xx-zen - not needed anymore. theres not even a
    kernel26zen..-- there is. Orphaned.
-   nvidia-beta-zen - not needed anymore. theres not even a
    kernel26zen..-- there is. Orphaned.
-   nvidia-zen - https://aur.archlinux.org/packages.php?ID=13903 --
    there isa zen kernel.
-   pidgimpd-svn - This package is orphaned and it doesn't build. There
    is mpd support in musictracker. -- actively maintained.
-   qgis contributor seems to be inactive. Newer version available so
    this package should maybe be orphaned, no obvious reason to delete
    it. -- package is in [community]
-   qgnokii - depend on qt3 but still use depend=(qt) -- builds fine
    with a little patch in pkgrel 6
-   sharpmusique - source is not available anymoreout this package --
    angvp -- maybe it comes back again. -- maintained
-   sonata-disautocenter - not needed anymore -- actively maintained
-   truecrypt-zen - not needed anymore. theres not even a
    kernel26zen..-- there is. Orphaned.
-   vim-colorschemes - Mirror says 404, there is vim-colorsamplerpack in
    [extra] -- It is actively maintained
-   weather-wallpaper - orphaned and references as dep non-existing
    pymetar -- It is actively maintained (by a TU)
-   ww2d-extra - broken links, and there is no sources in other place --
    maybe should be integrated into ww2d package which is also orphaned.
    Thoughts?
    -   I tried to update ww2d, but linux binary file downloaded from SF
        doesn't run: no errors, no any messages in terminal. Source code
        is available only in cvs-repository, and last commit was on
        2007-01-10. Program's author's site doesn't contain any
        information about ww2d. So this project is "dead".
        (manwithgrenade)

-   xmlwrapp no obvious reason to delete.
-   backintime-kde4 - made obsolete by other backintime version --
    actively maintained
-   viceplus - maintainer wrotes that it may be deleted (see comment) --
    but only because he made a mistake when uploading. no obvious need
    to remove. -- "Currently viceplus is merged with vice tree" ???
-   xfce4-genmon-plugin-svn - see comment for xfce-utils-svn -- there is
    no git-package yet
-   xfce4-notes-plugin-svn - see comment for xfce-utils-svn -- there is
    no git-package yet
-   xfce4-perl-svn - see comment for xfce-utils-svn -- there is no
    git-package yet -- package is already REMOVED
-   xfce4-power-manager-svn - see comment for xfce-utils-svn -- there is
    no git-package yet
-   xfce4-sensors-plugin-svn - see comment for xfce-utils-svn -- there
    is no git-package yet -- replaced by xfce4-sensors-plugin-git --
    package is already REMOVED
-   xfce4-settings-svn - see comment for xfce-utils-svn -- there is no
    git-package yet
-   xfce4-smartpm-plugin-svn - see comment for xfce-utils-svn -- there
    is no git-package yet
-   xfce4-taskmanager-svn - see comment for xfce-utils-svn -- there is
    no git-package yet
-   xfce4-weather-plugin-svn - see comment for xfce-utils-svn -- there
    is no git-package yet

Remove from Filesystem
----------------------

There are files on the AUR filesystem that have been created when poorly
formed packages were uploaded. This is a secondary consideration.

There are also directories in /packages/ for which the package no longer
exists. These probably need to be removed as well. All the packages that
moved to community ALSO still exist there.

List here files that are in directories of existing packages.

This script will take care of packages that no longer exist.

    #!/usr/bin/php
    <?php
    # Run this script by providing it with the top path of AUR.
    # In that path you should see a file lib/aur.inc
    #
    # This will remove files which belong to deleted packages.
    #
    # ex: php cleanup dev/aur/web
    #
    $dir = $argv[1];

    if (empty($dir)) {
            echo "Please specify AUR directory.\n";
            exit;
    }

    set_include_path(get_include_path() . PATH_SEPARATOR . "$dir/lib");
    include("config.inc");
    include("aur.inc");
    include("pkgfuncs.inc");

    exec('ls ' . INCOMING_DIR, $files);

    $count = 0;

    foreach ($files as $pkgname) {
            if (!package_exists($pkgname)) {
                    echo 'Removing ' . INCOMING_DIR . "$pkgname\n";
                    system('rm -r ' . INCOMING_DIR . $pkgname);
                    $count++;
            }
    }

    echo "\nRemoved $count directories.\n";

See also
--------

-   AUR Cleanup Day

Retrieved from
"https://wiki.archlinux.org/index.php?title=AUR_Cleanup_Day/2010&oldid=238355"

Categories:

-   Arch development
-   Package development
-   Events
-   Arch User Repository
