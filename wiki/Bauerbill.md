Bauerbill
=========

Note:Bauerbill development has been officially discontinued: its latest
version does not work with pacman>=3.5. See [1].

Note:As of late June 2012 the sources and webpages for bauerbill,
powerpill and a few other discontinued projects have been removed.

Introduction
------------

Bauerbill is an extension of Powerpill that supports downloading and
building packages from ABS, the AUR, CPAN and Hackage. As an extension
of Powerpill it supports download acceleration via parallel and
segmented downloads, including for source files when building packages.
It also includes internal support for Reflector, Rebase and PkgD.

Usage
-----

Bauerbill shares some of the same commands as pacman; reading the pacman
commands will get you started. But Bauerbill is an extension to
pacman/Powerpill, so it then brings its own commands.

> List installed AUR packages

    $ bauerbill -Ss --aur $(pacman -Qm) | grep 'AUR/' | grep installed

Retrieved from
"https://wiki.archlinux.org/index.php?title=Bauerbill&oldid=243153"

Categories:

-   Arch User Repository
-   Package management
