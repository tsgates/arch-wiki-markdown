Aura
====

Aura is a multilingual package manager for Arch Linux written in
Haskell. It connects to both the official ABS repositories and to the
Arch User Repository, allowing easy control of all packages on an Arch
system. It allows all pacman operations and provides new custom ones for
dealing with AUR packages. This differs from some other AUR helpers.

Contents
--------

-   1 Philosophy
-   2 Installation
    -   2.1 [extra] / [community] / [haskell-core] Dependencies
    -   2.2 [haskell-core] / AUR Dependencies
    -   2.3 [haskell-happstack] / AUR Dependencies
-   3 Aura-unique Operators
-   4 Usage
    -   4.1 Installing Packages
    -   4.2 Saving/Restoring the Global Package State
    -   4.3 Working with the Package Cache
    -   4.4 Working with the Pacman Log
    -   4.5 Working with Orphan Dependencies
-   5 Multilingual Support
-   6 Troubleshooting
    -   6.1 Too many Haskell dependencies
    -   6.2 Build failing at configuration step
    -   6.3 Update or Install failing while determining dependencies
    -   6.4 Auto-prompt for sudo
    -   6.5 Searching both Repos and AUR simultaneously
-   7 External Links

Philosophy
----------

Aura's philosophy as a package manager can be viewed in more detail
here. The main points are summarized below.

-   Aura is Pacman - All pacman operators and their sub-options are
    allowed.
-   ABS and AUR are separate - New aura-only operators are introduced
    for handling AUR packages.
-   Quiet Building - Makepkg output is suppressed by default. Unsuppress
    by using -x alongside -A.
-   Run as Root, Build as a User - Running makepkg as root or with sudo
    is dangerous. Aura builds packages with normal user privileges, even
    when run with sudo.
-   Know your System - Editing PKGBUILDs mid-build is not default
    behaviour. All package research should be done prior to building.
-   Downgradibility - Aura caches built package files, so they can be
    managed like any ABS package would. This includes downgrading with
    -C.
-   No Orphans - Aura provides several options for dealing with orphaned
    dependencies.
-   Multilingual - Aura provides multiple output languages.

Installation
------------

Note:All of Aura's dependencies can be found prebuilt in the
[haskell-core] and [haskell-happstack] repositories. These tend to be
more recent than those in [extra], [community], and the AUR. Naturally,
installing them this way is faster than building manually from the AUR.
See here on how to add [haskell-core] and [haskell-happstack] as
repositories.

Aura requires the following dependencies to build:

> [extra] / [community] / [haskell-core] Dependencies

-   ghc
-   haskell-regex-base
-   haskell-parsec
-   haskell-syb
-   haskell-transformers
-   haskell-mtl
-   haskell-json
-   haskell-temporary

> [haskell-core] / AUR Dependencies

-   haskell-regex-pcre

> [haskell-happstack] / AUR Dependencies

-   haskell-http-conduit

Once all of these are installed, you can build aura.

Aura-unique Operators
---------------------

See the aura man page for more detailed descriptions.

-   -A - Perform actions involving the AUR. Default action builds and
    installs AUR packages.
-   -B - Manage the saving and restoring of the global package state.
    Default action stores a record of all installed packages.
-   -C - Perform actions involving the package cache. Default action
    downgrades packages. This is interactive.
-   -L - Perform actions involving the pacman log. Default action opens
    the log for read-only viewing.
-   -M - Perform actions involving the ABS tree. Default action manually
    builds from your local ABS tree.
-   -O - Perform actions involving orphaned dependencies. Default action
    lists orphaned dependencies.

Usage
-----

> Installing Packages

Install an AUR package:

    aura -A (package)

Author's favourite. Upgrade all AUR packages, show PKGBUILD diffs, and
remove unneeded makedeps after installation:

    aura -Akua

Just sync the package database and upgrade all installed AUR packages:

    aura -Ayu

Install with makepkg output unsuppressed:

    aura -Ax (package)

Install and remove make dependencies afterwards:

    aura -Aa (package)

Show a packages recent PKGBUILD changes when installing:

    aura -Ak (package)

Look up information on an AUR package:

    aura -Ai (package)

Checkout an AUR package's PKGBUILD:

    aura -Ap (package)

Only download an AUR package's PKGBUILD:

    aura -Ap package > PKGBUILD

Search the AUR with a keyword:

    aura -As (keyword)

> Saving/Restoring the Global Package State

Save the global package state:

    aura -B

Restore a saved state. Downgrades upgraded packages, removes recently
installed:

    aura -Br

Remove old saved states. Saves `number` states and removes the rest.

    aura -Bc (number)

> Working with the Package Cache

Downgrade a package (this is interactive):

    aura -C (package)

Search the package cache for package files via a regex:

    aura -Cs (regex)

Backup the package cache:

    aura -Cb (/path/to/backup/location/)

Reduce the package cache to contain only the 5 most recent versions of
each package file:

    aura -Cc 5

> Working with the Pacman Log

View the pacman log:

    aura -L

View log info on a package:

    aura -Li

Search the log via a regex:

    aura -Ls (regex)

> Working with Orphan Dependencies

Display orphans:

    aura -O

Adopt a package (shorthand for -D --asexplicit):

    aura -O (package)

Uninstall all orphans:

    aura -Oj

  

Multilingual Support
--------------------

Aura supports multiple output languages.

Language

Native Flag

English Flag

English (default)

--english

--english

Japanese

--日本語

--japanese

Polish

--polski

--polish

Croatian

--hrvatski

--croatian

Swedish

--svenska

--swedish

German

--deutsch

--german

Spanish

--español

--spanish

Portuguese

--português

--portuguese

French

--français

--french

Russian

--русский

--russian

Italian

--italiano

--italian

Serbian

--српски

--serbian

Norwegian

--norsk

--norwegian

Note:To use non-ASCII arguments, you will need a UTF-8 compatible
terminal client, like urxvt.

Troubleshooting
---------------

> Too many Haskell dependencies

There is a pre-built binary version of aura available as the aura-bin
package in the AUR. No Haskell dependencies required.

> Build failing at configuration step

If you get the following:

    Configuring aura-1.x.x.x...
    Setup: At least the following dependencies are missing:
    regex-pcre -any

Then you need to rebuild the haskell-regex-pcre AUR package, or install
it out of [haskell-core]. This usually occurs after ghc upgrades, and
has to do with ghc and all the haskell libraries being linked by special
hash values for security purposes.

> Update or Install failing while determining dependencies

If you get the following:

    aura >> Determining dependencies...
    aura: fd:6: hGetContents: invalid argument (invalid byte sequence)

This is a known bug in 1.2.X but may affect later versions.

Ensure your locale is set properly by following this wiki page.
Especially the English Language example. You may be required to use
US.UTF-8.

Check your locale settings with

    $ locale

and double check that LANG is the same as what is in /etc/locale.gen. If
the problem persists try setting LC_ALL to the same thing as LANG. For
example:

    $ export LC_ALL=en_US.UTF-8

> Auto-prompt for sudo

Aura will not prompt for elevated privileges by default. If you'd like
it do so (like some other AUR helpers) you can write a wrapper script to
re-try aura with sudo when needed. The following creates a function a
that wraps aura:

    function a(){
        AURA="$(aura "$@")"

        if echo "$AURA" | grep -q '^aura >>= .*You have to use `.*sudo.*` for that.*$'
        then
            sudo aura "$@"
        else
            echo "$AURA"
        fi
    }

Either add this function to your corresponding rc/profile or as a
stand-alone script on your PATH.

> Searching both Repos and AUR simultaneously

If you want to search the official repositories and the AUR with one
command you can do that with a simple bash function. Put the following
in your ~/.bashrc:

    function search() {
      aura -Ss $1; aura -As $1;
    } 

Here is a fish shell version:

    function search
      aura -Ss $argv
      aura -As $argv
    end 

External Links
--------------

-   Aura's github page
-   Aura's ArchLinux forum post

Retrieved from
"https://wiki.archlinux.org/index.php?title=Aura&oldid=304805"

Categories:

-   Package management
-   Arch User Repository

-   This page was last modified on 16 March 2014, at 07:36.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
