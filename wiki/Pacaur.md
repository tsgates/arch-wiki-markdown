Pacaur
======

> Summary

How to install and use pacaur.

> Related

AUR Helpers

Pacaur is an Arch User Repository (AUR) helper aiming at speed and
simplicity, designed to minimize user prompt interaction and to use an
uncluttered interface. It is written in Bash and built upon the well
designed cower and expac C backends.

Note:Pacaur is targeted at advanced users who want some degree of
automation for repetitive tasks. As such, the user is expected to be
familiar with the manual build process.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Philosophy                                                         |
| -   2 Installation                                                       |
| -   3 Usage                                                              |
|     -   3.1 Userbase target                                              |
|     -   3.2 Example                                                      |
|                                                                          |
| -   4 Configuration                                                      |
|     -   4.1 Config files                                                 |
|     -   4.2 Sudo configuration                                           |
|                                                                          |
| -   5 Troubleshooting                                                    |
|     -   5.1 Host name error                                              |
|     -   5.2 Using gvim as editor                                         |
|                                                                          |
| -   6 Improving pacaur                                                   |
|     -   6.1 Internationalization                                         |
|     -   6.2 Bug reports                                                  |
|     -   6.3 Feature requests                                             |
|                                                                          |
| -   7 External Links                                                     |
+--------------------------------------------------------------------------+

Philosophy
----------

Pacaur's main feature revolves around a fast workflow idea, that is,
spending as little time as possible interacting with package management
prompts. Speed, simplicity and the need for an uncluttered interface
were also taken into consideration.

Pacaur is:

Fast

-   It minimizes user interaction.
-   It has very good performance with a small memory footprint.
-   It retrieves and edits sall PKGBUILDs, solves all conflicts and asks
    about providers before building anything.

  
 Simple

-   It does not add a lot of features, but simply extends pacman to
    manage the AUR.
-   It does not reinvent the wheel, but is built upon existing tools
    (cower, expac, sudo).
-   It is a small bash script using tiny C libraries.
-   It is based on the libalpm C interface directly maintained by a
    pacman developer.

  
 Powerful

-   It can be used as a separate AUR frontend, or a single tool to
    manage official and AUR packages.
-   It searches with regex support (through cower).
-   It provides binary and AUR package names completion.
-   It passes arguments to pacman when appropriate.
-   It shows current and available versions when checking for updates.

  
 Secure

-   It does not source PKGBUILDs unecessarily.
-   It detects and warns of possible malicious pseudocode in PKGBUILDs.
-   It disposes of an additional full secured mode for paranoid people.

Installation
------------

The following binary dependencies need to be installed:

-   sudo [core]
-   expac [community]

You can then install cower as a dependency, and then pacaur itself. Both
of those packages are available in the AUR.

Usage
-----

Invoking pacaur consists of supplying an operation, any applicable
options, and usually one or more targets.

    usage:  pacaur <operation> [options] [package(s)]
    operations:
     pacman extension
       -S, -Q          extend pacman operations to the AUR
     AUR only
       -s, --search    search AUR repository for matching strings
       -i, --info      view package information -- pass twice for details
       -d, --download  download target(s) -- pass twice to download AUR dependencies
       -m, --makepkg   download and make target(s)
       -y, --sync      download, make and install target(s)
       -k, --check     check for AUR update(s)
       -u, --update    update AUR package(s)
     general
       -v, --version   display version information
       -h, --help      display help information
       --fixbackend    quickly rebuild backend

    options:
     pacman extension - can be used with the -S, -Ss, -Si, -Sii, -Sw, -Su, -Qu, -Sc, -Scc operations
       -a, --aur       only search, install or clean packages from the AUR
       -r, --repo      only search, install or clean packages from the repositories
     general
       -e, --edit      edit target PKGBUILD -- can be combined with the -d, -m, -y, -u flags
       -c, --clean     clean target(s) build files -- can be combined with the -m, -y, -u flags
       -q, --quiet     show less information for query and search
       --devel         consider AUR development packages upgrade
       --ignore        ignore a package upgrade (can be used more than once)
       --noconfirm     do not prompt for any confirmation
       --noedit        do not prompt to edit files
       --rebuild       always rebuild package

> Userbase target

Pacaur has two types of users in mind:

-   those who prefer to have one single tool to manage AUR and official
    repositories,
-   those who prefer to keep their AUR frontend separate from Pacman.

As such there are two sets of commands:

-   commands that wrap the pacman binary (-S, -Ss, -Si, -Sw. -Su, -Qu,
    -Sc) and extend its functions to the AUR. This behavior can be
    disabled with the fallback variable in the config file.
-   commands that are AUR specific (-s, -i, -m, -y, -k, -u).

> Example

By default, pacaur -Ss package will search the repo, then the AUR if
necessary.

    $ pacaur -Ss expac
    community/expac 1-2
        pacman database extraction utility
    aur/expac-git 20110324-1 (24)
        pacman database extraction utility

This behavior is optional and can be disabled with the fallback variable
in the config file. When disabled, pacaur -Ss package will search the
repo only.

Also, pacaur -Ssr package will be restricted to searching in the repo
only, while pacaur -Ssa package will search the AUR.

    $ pacaur -Ssr expac
    community/expac 1-2
        pacman database extraction utility

    $ pacaur -Ssa expac
    aur/expac-git 20110324-1 (24)
        pacman database extraction utility

pacaur -s package will search the AUR only.

    $ pacaur -s expac
    aur/expac-git 20110324-1 (24)
        pacman database extraction utility

Configuration
-------------

Here are the available options in the config file:

    #
    # /etc/xdg/pacaur/config
    #

    # The following options are commented out with their default values listed.
    # If you wish to use different values, uncomment and update the values.
    #builddir="${BUILDDIR:-$tmpdir}"       # build directory
    #editor="${EDITOR:-vi}"                # PKGBUILD editor
    #editpkgbuild=true                     # edit PKGBUILD script
    #editinstall=true                      # edit install script
    #fallback=true                         # pacman fallback to the AUR
    #clean=true                            # clean up after package install
    #cleandevel=true                       # clean up devel package
    #secure=false                          # enhanced security
    #sudoloop=false                        # prevent sudo timeout

See also man pacaur.

> Config files

Pacaur fully honors pacman and makepkg configuration files, as well as
the sudoers and cower config file (if existing).

In particular, the following options in /etc/pacman.conf can be used for
further configuration:

-   Colors to enable colored output.
-   VerbosePkgLists to display the name, version and size of target
    packages formatted as a table.

Note that pacman and makepkg environment variables ($BUILDDIR, $PKGDEST,
$PACMAN, ...) are fully honored.

> Sudo configuration

Pacaur is designed to be used with sudo for minimal password prompting
and your /etc/sudoers should be configured accordingly.

To avoid password prompt timeout (typically if you went grabbing a
coffee while waiting the build to finish), disable it in your sudoers:

    Defaults passwd_timeout=0

Troubleshooting
---------------

> Host name error

When checking AUR packages for updates, pacaur outputs a lot of
"Couldn't resolve host name" and "Timeout was reached" messages in spite
of the internet line working correctly.

-   Configure your DNS server to improve queries speed. Try using Google
    primary DNS (8.8.8.8 and 8.8.4.4).
-   Alternatively, tweak cower's config file to decrease the number of
    threads used in "MaxThread" variable.

> Using gvim as editor

When using gvim as editor, gvim opens but the build continues. In the
config file, try:

    editor="gvim --nofork"

Improving pacaur
----------------

> Internationalization

See Internationalization howto.

> Bug reports

When reporting problems, please:

-   check whether "makepkg -si" can build and install a package
    successfully. As pacaur relies exclusively on makepkg to build and
    install packages, the PKGBUILD must be corrected by its maintainer
    if makepkg fails.
-   check that the problem is reproducible, and is not caused by a
    misconfiguration of
    pacman.conf/makepkg.conf/pacaur.conf/sudoers/etc.
-   post the ouput of "bash -x pacaur <your command>" here or on github
    to help me debug the issue.

> Feature requests

Pacaur is considered as "features complete" and most probably will not
include new features. However, any feature request or patch will be
considered, and might be implemented as long as the objectives of speed,
simplicity, fast workflow, uncluttered interface and the Arch way are
respected.

External Links
--------------

-   Project page
-   Forum page
-   pacaur's github page

Retrieved from
"https://wiki.archlinux.org/index.php?title=Pacaur&oldid=255808"

Categories:

-   Package management
-   Arch User Repository
