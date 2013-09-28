Aura
====

Aura is a multilingual package manager for Arch Linux written in
Haskell. It connects to both the official ABS repositories and to the
Arch User Repository, allowing easy control of all packages on an Arch
system. It allows all pacman operations and provides new custom ones for
dealing with AUR packages. This differs from some other AUR helpers.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Philosophy                                                         |
| -   2 Installation                                                       |
|     -   2.1 [extra] / [community] / [haskell-core] Dependencies          |
|     -   2.2 AUR Only Dependencies                                        |
|                                                                          |
| -   3 Aura-unique Operators                                              |
| -   4 Usage                                                              |
|     -   4.1 Installing Packages                                          |
|     -   4.2 Saving/Restoring the Global Package State                    |
|     -   4.3 Working with the Package Cache                               |
|     -   4.4 Working with the Pacman Log                                  |
|     -   4.5 Working with Orphan Dependencies                             |
|     -   4.6 Tips and Tricks                                              |
|                                                                          |
| -   5 Multilingual Support                                               |
| -   6 Troubleshooting                                                    |
|     -   6.1 GHC dependency is too big                                    |
|                                                                          |
| -   7 External Links                                                     |
+--------------------------------------------------------------------------+

Philosophy
----------

Aura's philosophy as a package manager can be view in more detail here.
The main points are summarized below.

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

Note:A number of Aura's dependencies can be found in the [haskell-core]
repository. These tend to be more recent than those in [extra],
[community, and the AUR. Naturally, installing them this way is faster
than building manually from the AUR. See here on how to add
[haskell-core] as a repository.

Aura requires the following dependencies to build:

> [extra] / [community] / [haskell-core] Dependencies

-   ghc
-   haskell-regex-base
-   haskell-parsec
-   haskell-syb
-   haskell-transformers
-   haskell-mtl
-   haskell-json

> AUR Only Dependencies

-   haskell-curl
-   haskell-regex-pcre

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

Search the AUR via a regex:

    aura -As (regex)

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

> Tips and Tricks

If you want to search the official repositories and the AUR with one
command you can do that with a simple bash function. Put the following
in your ~/.bashrc:

    function packagesearch () {
    aura -Ss $1; aura -As $1;
    } 

Multilingual Support
--------------------

Aura supports multiple output languages. The current available languages
(and their flags) are:

-   English (default) => --english
-   Japanese => --日本語 or --japanese
-   Polish => --polski or --polish
-   Croatian => --hrvatski or --croatian
-   German => --deutsch or --german
-   Spanish => --español or --spanish
-   Portuguese => --português or --portuguese
-   French => --français or --french
-   Russian => --русский or --russian
-   Italian => --italiano or --italian
-   Serbian => --српски or --serbian

Note:To use non-ASCII arguments, you will need a UTF-8 compatible
terminal client, like urxvt.

Troubleshooting
---------------

> GHC dependency is too big

While a ~700mB dependency is a big one, ghc is nothing but a build
dependency for aura. It is not needed post-installation. Feel free to
uninstall it (and any other orphans) with aura -Oj.

External Links
--------------

-   Aura's github page
-   Aura's ArchLinux forum post

Retrieved from
"https://wiki.archlinux.org/index.php?title=Aura&oldid=253729"

Categories:

-   Package management
-   Arch User Repository
