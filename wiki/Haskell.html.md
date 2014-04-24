Haskell
=======

Haskell is a general purpose, purely functional, programming language.

Contents
--------

-   1 Installation
    -   1.1 Compiler
    -   1.2 Haskell platform
-   2 Managing Haskell packages
    -   2.1 Pros/Cons of the different methods
    -   2.2 ArchHaskell repository
        -   2.2.1 Preparation
        -   2.2.2 Installing and removing packages
    -   2.3 cabal-install
        -   2.3.1 Preparation
        -   2.3.2 Installing packages
        -   2.3.3 Removing packages
-   3 Troubleshooting
    -   3.1 Switching to ArchHaskell repository

Installation
------------

Haskell generates machine code that can be run natively on Linux. There
is nothing special required to run a binary (already compiled) software,
like the ones provided in the official repositories or by the
ArchHaskell group. On the other side, AUR packages or source codes
requires a compiler to build the software.

Installing the compiler alone permits to build Haskell source code. For
development there is a Haskell-Platform bundle which offers the complete
set of tools to get started with Haskell.

> Compiler

To build a Haskell source–code into native–code, a compiler must be
installed. There are several implementations available, but the most
used one (which became de facto the reference) is the GHC (Glasgow
Haskell Compiler). It is available in the official repositories as ghc.

You can try it with the following file:

    Main.hs

    main = putStrLn "Hello, World"

and by running:

    $ ghc Main.hs
    $ ./Main 

    Hello, World

> Haskell platform

To start developing in Haskell easily, there is a haskell-platform
bundle which is described as:

The easiest way to get started with programming Haskell. It comes with
all you need to get up and running. Think of it as "Haskell: batteries
included".

An AUR package exists (haskell-platform), but can advantageously be
replaced by installing the following packages from the official
repositories:

-   ghc (ghc) — The compiler
-   cabal-install (cabal-install) — A command line interface for Cabal
    and Hackage
-   haddock (haddock) — Tools for generating documentation
-   happy (happy) — Parser generator
-   alex (alex) — Lexical analyzer generator

Managing Haskell packages
-------------------------

There are a lot of Haskell libraries and executables grouped in
packages. They are all available on Hackage. To install and manage these
packages, several methods are available and unusual ones are explained
in the rest of this section.

The recommended workflow is the following:

-   Official repositories or ArchHaskell repository as principal source
    of Haskell packages (the or is exclusive here)
-   cabal-install (possibly with sandboxes) for Haskell development
-   Arch User Repository for packages that are not available elsewhere

A wrapper around cblrepo exists, called cabal2pkgbuild
(cabal2pkgbuild-git), that you can use to create PKGBUILD files for
Hackage packages.

> Pros/Cons of the different methods

-   Official repositories

Pros: Provided by ArchLinux developers, consistent versions of packages,
already compiled

Cons: Only a few packages available

-   ArchHaskell repository

Pros: Provided by ArchHaskell group, consistent versions of packages,
already compiled

Cons: Need manual intervention to get started with

-   cabal-install

Pros: All packages available

Cons: Installed in home folder, cabal-install is not a package manager,
incompatible versions of packages possible (aka. cabal hell)

-   Arch User Repository

Pros: Simple to get started

Cons: Risk of unmaintained or orphaned packages, incompatible versions
of packages possible

> ArchHaskell repository

Preparation

Add the haskell-core unofficial user repository to your configuration.
Be sure to put [haskell-core] above [extra] to ensure that the packages
from [haskell-core] take precedence, in case of duplicate packages in
the two repositories.

Note:A note for xmonad users: if you switch to this option, you need to
install the haskell-xmonad package instead of xmonad (which is in the
official community repo and has different dependencies).

You also need need to do the following to add Magnus Therning's key (the
maintainer of the repository):

    # pacman-key -r 4209170B
    # pacman-key --lsign-key 4209170B

and then force the refresh of the package list:

    # pacman -Syy

Installing and removing packages

Use pacman for installing or removing packages.

> cabal-install

Warning:Discouraged method, keep in mind that cabal-install is not a
package manager.

Note:The only exception is for Haskell development, where cabal-install
is the recommended tool. Since version 1.18, cabal provides a sandbox
system that permits to isolate different versions of libraries for
different projects. There is an introduction to cabal sandbox here.

Preparation

Install cabal-install from the official repositories.

To run installed executables without specifying the path, the cabal
binary folder ~/.cabal/bin must be added to the $PATH variable. That can
be done by putting the following line in your shell configuration file,
for instance ~/.bashrc for bash or ~/.zshrc for zsh:

    PATH=$PATH:~/.cabal/bin

Installing packages

    $ cabal update
    $ cabal install <pkg>

You can add -j for parallel compilation. It is also possible to install
a package system–wide with the --global flag, but this is strongly
discouraged. With the user–wide install, all files are kept in ~/.cabal
and libraries are registered to ~/.ghc, offering the possibility to do a
clean-up easily by simply removing these folders. With system–wide
install, the files will be dispersed in the file system and difficult to
manage.

Removing packages

There is no easy way to do it.

Troubleshooting
---------------

> Switching to ArchHaskell repository

There can be some problems switching to ArchHaskell repository when some
Haskell packages are already installed from official repositories. The
surest way is to remove all Haskell related packages, synchronize the
pacman packages database, and reinstall all the needed packages. Also
for Xmonad users, be sure to install haskell-xmonad package instead of
xmonad.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Haskell&oldid=306117"

Category:

-   Programming language

-   This page was last modified on 20 March 2014, at 17:43.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
