autoaur
=======

  
 autoaur is a script for automatic mass downloading, updating, building
and installing groups of AUR packages. It was initially written by
Michal Krenek. A typical scenario would be building (including frequent
updating/rebuilding) Xgl, Compiz and all related packages from the AUR.
In fact, this was the original reason for making autoaur.

Installing
----------

Build and install autoaur from the AUR.

Configuring
-----------

A sample configuration file (or meta-PKGBUILD) for Xgl & Compiz comes
with autoaur. To use it, create a directory where all packages to be
downloaded and builded should be placed, go to this directory and run:

    $ autoaur /path/to/xgl.autoaur

autoaur is highly configurable, as demonstrated by its help command:

    Usage: autoaur [options] [config file]

    You must have a personal repository defined in makepkg.conf. See
    makepkg's manual page for further advice.

    Options:
      --nodownload         Do not download packages from AUR
      --noinstall          Do not install packages from AUR
      --noupdate           Do not update package versions
      --remove             Remove conflicting packages (without dependency check)
      --clean              Clean package directories before new installation
                           (old source code will be deleted)
      --nocolor            Disable colorized output messages
      --tarball            make a tarball and delete  
      --confighelp         Help with configuration files
      -h, --help           Basic help

As of March 26, 2010, autoaur-repo was merged with autoaur. autoaur now
uses the PKGEXT variable defined in makepkg.conf for creating packages.

When running a personal repository, configure the following line in the
config file:

    PERSREPO=personalreponame

Finally, add the directory to the PKGDEST variable in makepkg.conf.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Autoaur&oldid=197648"

Categories:

-   Package management
-   Arch User Repository

-   This page was last modified on 23 April 2012, at 15:58.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
