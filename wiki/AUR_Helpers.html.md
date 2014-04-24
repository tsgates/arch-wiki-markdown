AUR Helpers
===========

Warning:None of these tools are officially supported by the Arch Linux
developers. See this forum thread.

AUR Helpers are written to make using the Arch User Repository more
comfortable.

Contents
--------

-   1 AUR uploader helpers
-   2 AUR search/build helpers
-   3 AUR maintaining helpers
-   4 Others
-   5 Quick Comparison Table
-   6 See also

AUR uploader helpers
--------------------

-   aurploader — prompts the user for an AUR username and password and
    will then upload PKGBUILD tarballs to the AUR. Before uploading each
    package, the user is prompted to select a category. When the uploads
    have completed, the user is asked if the cookie file should be kept
    so that the script can be run again without needing the AUR username
    and password to be re-entered. It can include comments, vote, and
    toggle notifications as well. It is now part of the python3-aur
    package, which includes modules for AUR automation and some other
    helpers.

http://xyne.archlinux.ca/projects/python3-aur || python3-aur

-   aurup — a command-line tool to upload AUR packages

http://www.pierloz.com/Aurup/ || aurup

-   burp — fast and simple AUR uploader written in C. Supports
    persistent cookies for seamless logins

https://github.com/falconindy/burp || burp

-   build script of newrelic-php — fast and simple AUR uploader written
    in Ruby. It uses curl for uploading so, probably work only on
    Linux/Mac. It's a part of newrelic-php5 package

https://github.com/axcoto/newrelic-php5/blob/master/build ||
newrelic-php5

AUR search/build helpers
------------------------

This is a list of helper utilities that search and/or build packages.

-   aur.sh — A ~150 byte Bash script outside the package system that
    downloads and builds AUR packages named on the command line (and
    their dependencies). Useful for bootstrapping more full-featured AUR
    helpers.

https://github.com/stuartpb/aur.sh || bash <(curl aur.sh) -si [package
...]

-   aura — a secure, multilingual package manager for Arch Linux written
    in Haskell. Has all pacman options, new ones for managing AUR
    packages, and a nifty logo.

https://github.com/fosskers/aura || aura

-   aurel — Search, vote and download AUR packages from Emacs

-   Forum page

https://github.com/alezost/aurel || aurel

-   aurifere — AUR wrapper for lazy people in Python.

https://github.com/madjar/aurifere || aurifere-git

-   aurinstaller — a full-of-bugs Bash AUR helper.

https://github.com/umby213/aurinstaller || aurinstaller-git

-   aurnotify — a tool set to notify the status of your favorite
    packages from AUR.

http://adesklets.sourceforge.net/desklets.html || aurnotify

-   aurbuild — tool to download and build packages from the AUR.

http://aurbuild.berlios.de/ || aurbuild

-   aurget — aims to be a simple, pacman-like interface to the AUR. It
    tries to make the AUR convenient: whether the user wishes to find,
    download, build, install, or update AUR packages quickly. Aurget
    does not wrap any pure pacman commands by design.

http://pbrisbin.com/posts/aurget/ || aurget

-   aurora — very simple front-end for the AUR. It allows the user to
    install AUR packages, download the AUR packages (for manual
    installation), and also offers an AUR upgrade feature. By design,
    aurora does not wrap pacman

http://bitbucket.org/bbenne10/aurora || aurora-hg

-   aurpac — light and fast AUR and pacman front-end

http://3ed.jogger.pl/2009/02/15/aurpac/ || aurpac

-   aurquery — caching wrapper around the AUR's RPC interface using the
    python3-aur library

http://xyne.archlinux.ca/projects/python3-aur || python3-aur

-   autoaur — script for automatic mass downloading, updating, building,
    and installing groups of AUR packages

https://github.com/stefanhusmann/autoaur || autoaur

-   cower — fast and simple AUR search and download agent, which will
    also check for updates and download dependencies.

-   Forum page

https://github.com/falconindy/cower || cower

-   meat — front-end for cower (see above) written in entirely in Bash

Note:Meat is currently in development/alpha state.

https://github.com/e36freak/meat || meat-git

-   owlman — pacman and cower wrapper focused on simplicity

https://github.com/baskerville/owlman || owlman

-   pacaur — fast workflow AUR helper, using cower as its back-end. It
    aims for speed and simplicity and is designed to minimize user
    prompt interaction and to use an uncluttered interface.

-   Forum page

https://github.com/Spyhawk/pacaur || pacaur

-   packer — wrapper for pacman and the AUR. It was designed to be a
    simple and very fast replacement for the basic functionality of
    Yaourt. It has commands to install, update, search, and show
    information for any package in the main repositories and in the AUR.
    Use pacman for other commands, such as removing a package

-   Forum page
-   Wiki

https://github.com/keenerd/packer || packer

-   paktahn — yaourt replacement. Includes improvements such as a local
    cache for fast searches and interactive installation. Last Updated:
    2013-04-15 08:17

-   Forum page

https://github.com/skypher/paktahn || paktahn

-   pbfetch — script which can be used as a pacman-independent AUR
    helper or a pacman wrapper with additional AUR functionality.
    Pbfetch aims to be simple and fast versus the well established
    yaourt. Pbfetch can be used as a shortcut to simply download
    PKGBUILDs from the AUR or automatically build packages with
    dependency resolution, among other things. The user can select which
    AUR packages to upgrade using a simple menu as well as update all
    AUR packages

-   Forum page

https://github.com/dalingrin/pbfetch || pbfetch-git

-   pbget — simple command-line tool for retrieving PKGBUILDs and local
    source files for Arch Linux. It is able to retrieve files from the
    official SVN and CVS web interface, the AUR, and the ABS rsync
    server

http://xyne.archlinux.ca/projects/pbget || pbget

-   PKGBUILDer — An AUR helper with dependency support written in Python
    3. It was (probably) the first helper supporting updates through
    multiinfo. Contains many useful features and is written to be fast
    and verbose, to eliminate long waiting times.

https://github.com/Kwpolska/pkgbuilder || pkgbuilder

-   pkgman — script which helps to manage a local repository. It
    retrieves the PKGBUILD and related files for given name from ABS or
    AUR and lets you edit them, automatically generates checksums, backs
    up the source tarball, builds, and adds the package to your local
    repository. Then you can install it as usual with pacman. It also
    has AUR support for submitting tarballs and leaving comments.

-   Forum page

http://sourceforge.net/apps/mediawiki/pkgman/index.php || pkgman

-   pywer — A Python rewrite of cower with a library (libaur) for use in
    Python scripts, currently in development. It does not build
    packages. Checks for updates, searches for packages and maintainers,
    and gets information on packages.

http://kaictl.net/docs/pywer/ https://github.com/KaiSforza/pywer ||
python-pywer-git

-   spinach — just another AUR helper written in Bash

http://floft.net/wiki/Scripts/Spinach || spinach

-   srcman — pacman/makepkg wrapper written in Bash, which transparently
    handles pacman operations on "source packages". This means, for
    example, that packages can be specified for installation either
    explicitly (pacman's -U operation) or can be installed from a
    (source) repository (-S operation). The address of an AUR pacman
    database can be found in the corresponding forum thread. The primary
    goal of this project is to provide a complete pacman wrapper;
    therefore, srcman supports all current pacman operations for binary
    and source packages

https://bbs.archlinux.org/viewtopic.php?id=65501 || srcman

-   trizen — A lightweight wrapper for the AUR written in Perl.

https://github.com/trizen/trizen || trizen

-   yaah — A minimalist wrapper for the AUR written in Bash.

https://bitbucket.org/the_metalgamer/yaah/ || yaah

-   yaourt (Yet Another User Repository Tool) — community-contributed
    wrapper for pacman which adds seamless access to the AUR, allowing
    and automating package compilation and installation for both
    unofficial AUR and official Arch packages. Yaourt uses the same
    syntax as pacman, which saves you from relearning an entirely new
    method of system maintenance but also adds new options. Yaourt
    expands the power and simplicity of pacman by adding even more
    useful features and provides pleasing, colorized output, interactive
    search mode, and much more.

http://archlinux.fr/yaourt-en || yaourt

AUR maintaining helpers
-----------------------

-   pkgcheck — Uses rules in PKGBUILDs to parse upstream version
    information or looks for changes by checksumming the web page

https://bbs.archlinux.org/viewtopic.php?id=162816 || Repository: GitHub

-   pkgbuild-watch — Looks for changes on the upstream web pages

http://kmkeen.com/pkgbuild-watch || pkgbuild-watch

-   pkglivecheck — Parses the source URL from PKGBUILDs and tries to
    find new versions of packages by incrementing the version number and
    sending requests to the web server

https://mailman.archlinux.org/pipermail/pacman-dev/2013-April/017048.html
|| Repository: GitHub

-   pkgbuildup — Help AUR package maintainers automatically update
    PKGBUILD files. Supports a simple template variable syntax

Repository: GitHub || pkgbuildup-git

Others
------

Other useful libraries.

-   haskell-archlinux — library to programmatically access the AUR and
    package metadata from the Haskell programming language

http://hackage.haskell.org/package/archlinux || haskell-archlinux

-   parched — pacman package and PKGBUILD parser module written in
    Python

https://github.com/sebnow/parched || parched-git

Quick Comparison Table
----------------------

Note:Secure means that the application, by default, does not source the
PKGBUILD at all, or, before doing it, reminds the user and offers him
the opportunity to inspect it manually. Some helpers are known to source
PKGBUILDs before the user can inspect them. For example, for dependency
resolution, and this can allow malicious code to be executed. Optional
means that there's a command line flag or configuration option to
prevent the automatic sourcing before viewing.

Name

Written In

Active Project

Official Repository Support

Pacman-like Syntax

Shell Tab Completion

Secure (see note above)

Multilingual

Specificity

aura

Haskell

Yes

Yes

Yes

Bash/zsh/fish

Yes

Yes

Handles backups, downgrades, ABS Support

aurget

Bash

Yes

No

Yes

Bash

No

No

-

aurel

Emacs Lisp

Yes

No

No

No

Yes

No

-

aurora

Python 3

Yes

No

No

No

No

No

-

cower

C

Yes

No

No

Bash/zsh

Yes

No

Minimalist helper without automatic build support.

owlman

Dash

Yes

Yes

No

Bash

Yes

No

-

pacaur

Bash/C

Yes

Yes

Yes

Bash/zsh

optional

Yes

Minimize user interaction.

packer

Bash

Yes

Yes

Yes

No

optional

No

-

paktahn

Lisp

Yes

Yes

Yes

No

No

No

-

pbfetch

Bash

Yes

Yes

Yes

No

Yes

No

-

PKGBUILDer

Python 3

Yes

Yes (pb command)

No

No

No

Yes

-

pywer

Python 3

Yes

No (read only libaur.repos)

No

Yes (zsh)

Yes

No

Includes Python 3 libaur library

spinach

Bash

Yes

Yes

No

No

Yes

No

-

trizen

Perl

Yes

Yes

Yes

No

Yes

No

Full dependencies support for AUR packages.

yaah

Bash

Yes

No

No

Bash

Yes

No

Minimalist helper without automatic build support.

yaourt

Bash/C

Yes

Yes

Yes

Bash/zsh/fish

Yes

Yes

Handles backups, ABS support

See also
--------

-   pacman GUI Frontends

Retrieved from
"https://wiki.archlinux.org/index.php?title=AUR_Helpers&oldid=303946"

Categories:

-   Arch User Repository
-   Package management

-   This page was last modified on 10 March 2014, at 21:00.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
