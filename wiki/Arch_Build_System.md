Arch Build System
=================

Summary

The Arch Build System is a ports-like system for building and packaging
software from source code. This article includes a general overview of
the ABS followed by detailed usage instructions.

Overview

Packages in Arch Linux are built using makepkg and a custom build script
for each package (known as a PKGBUILD). Once packaged, software can be
installed and managed with pacman. PKGBUILDs for software in the
official repositories are available from the ABS tree; thousands more
are available from the (unsupported) Arch User Repository.

Related

ABS FAQ

Arch Packaging Standards

Creating Packages

Kernel Compilation with ABS

This article provides an overview of the Arch Build System along with a
walkthrough for beginners. It is not a complete reference guide! For a
quick and simple introduction to the ABS, see the ABS FAQ. If you need
more information, please reference the man pages.

Note:ABS syncs once a day so it may lag behind what is already available
in the repositories.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 What is the Arch Build System?                                     |
|     -   1.1 What is a ports-like system?                                 |
|     -   1.2 ABS is a similar concept                                     |
|     -   1.3 ABS overview                                                 |
|                                                                          |
| -   2 Why would I want to use ABS?                                       |
| -   3 How to use ABS                                                     |
|     -   3.1 Install tools                                                |
|     -   3.2 /etc/abs.conf                                                |
|     -   3.3 ABS tree                                                     |
|         -   3.3.1 Download ABS tree                                      |
|                                                                          |
|     -   3.4 /etc/makepkg.conf                                            |
|         -   3.4.1 Set the PACKAGER variable in /etc/makepkg.conf         |
|             -   3.4.1.1 Showing All Packages (including those from AUR)  |
|             -   3.4.1.2 Showing Only Packages Contained in Repos         |
|                                                                          |
|     -   3.5 Create a build directory                                     |
|     -   3.6 Build package                                                |
|         -   3.6.1 fakeroot                                               |
+--------------------------------------------------------------------------+

What is the Arch Build System?
------------------------------

The Arch Build System, ABS for short, is a ports-like system for
building and packaging software from source code. While pacman is the
specialized Arch tool for binary package management (including packages
built with the ABS), ABS is a collection of tools for compiling source
into installable .pkg.tar.xz packages.

> What is a ports-like system?

Ports is a system used by *BSD to automate the process of building
software from source code. The system uses a port to download, unpack,
patch, compile, and install the given software. A port is merely a small
directory on the user's computer, named after the corresponding software
to be installed, that contains a few files with the instructions for
building and installing the software from source. This makes installing
software as simple as typing make or make install clean within the
port's directory.

> ABS is a similar concept

ABS is made up of a directory tree (the ABS tree) residing under
/var/abs. This tree contains many subdirectories, each within a category
and each named by their respective package. This tree represents (but
does not contain) all official Arch software, retrievable through the
SVN system. You may refer to each package-named subdirectory as an
'ABS', much the way one would refer to a 'port'. These ABS (or
subdirectories) do not contain the software package nor the source but
rather a PKGBUILD file (and sometimes other files). A PKGBUILD is a
simple Bash build script -- a text file containing the compilation and
packaging instructions as well as the URL of the appropriate source
tarball to be downloaded. (The most important component of ABS are
PKGBUILDs.) By issuing the ABS makepkg command, the software is first
compiled and then packaged within the build directory before being
installed. Now you may use pacman, the Arch Linux package manager, to
install, upgrade, and remove your new package.

> ABS overview

'ABS' may be used as an umbrella term since it includes and relies on
several other components; therefore, though not technically accurate,
'ABS' can refer to the following tools as a complete toolkit:

 ABS tree
    The ABS directory structure; an SVN hierarchy under /var/abs/ on
    your (local) machine. It contains many subdirectories, named for all
    available official Arch Linux software from repositories specified
    in /etc/abs.conf, but not the packages themselves. The tree is
    created after installing the abs package with pacman and
    subsequently running the abs script.

 PKGBUILDs
    A Bash script that contains the URL of the source code along with
    the compilation and packaging instructions.

 makepkg
    ABS shell command tool which reads the PKGBUILDs, automatically
    downloads and compiles the sources and creates a .pkg.tar* according
    to the PKGEXT array in makepkg.conf. You may also use makepkg to
    make your own custom packages from the AUR or third-party sources.
    (See the Creating Packages wiki article.)

 pacman
    pacman is completely separate, but is necessarily invoked either by
    makepkg or manually, to install and remove the built packages and
    for fetching dependencies.

 AUR
    The Arch User Repository is separate from ABS but AUR (unsupported)
    PKGBUILDs are built using makepkg to compile and package up
    software. In contrast to the ABS tree on your local machine, the AUR
    exists as a website interface. It contains many thousands of
    user-contributed PKGBUILDs for software which is unavailable as an
    official Arch package. If you need to build a package outside the
    official Arch tree, chances are it is in the AUR.

Why would I want to use ABS?
----------------------------

The Arch Build System is used to:

-   Compile or recompile a package, for any reason
-   Make and install new packages from source of software for which no
    packages are yet available (see Creating Packages)
-   Customize existing packages to fit your needs (enabling or disabling
    options, patching)
-   Rebuild your entire system using your compiler flags, "à la FreeBSD"
    (e.g. with pacbuilder)
-   Cleanly build and install your own custom kernel (see Kernel
    Compilation)
-   Get kernel modules working with your custom kernel
-   Easily compile and install a newer, older, beta, or development
    version of an Arch package by editing the version number in the
    PKGBUILD

ABS is not necessary to use Arch Linux, but it is useful for automating
certain tasks of source compilation.

How to use ABS
--------------

Building packages using abs consists of these steps:

1.  Install the abs package with pacman.
2.  Run abs as root to create the ABS tree by synchronizing it with the
    Arch Linux server.
3.  Copy the build files (usually residing under
    /var/abs/<repo>/<pkgname>) to a build directory.
4.  Navigate to that directory, edit the PKGBUILD (if desired/necessary)
    and do makepkg.
5.  According to instructions in the PKGBUILD, makepkg will download the
    appropriate source tarball, unpack it, patch if desired, compile
    according to CFLAGS specified in makepkg.conf, and finally compress
    the built files into a package with the extension .pkg.tar.gz or
    .pkg.tar.xz.
6.  Installing is as easy as doing pacman -U <.pkg.tar.xz file>. Package
    removal is also handled by pacman.

> Install tools

To use the ABS, you first need to install abs from the official
repositories.

This will grab the abs-sync scripts, various build scripts, and rsync
(as a dependency, if you do not already have it).

Before you can actually build anything, however, you will also need
basic compiling tools. These are handily collected in the package group
base-devel. This group can be installed with pacman.

> /etc/abs.conf

As root, edit /etc/abs.conf to include your desired repositories.

Remove the ! in front of the appropriate repositories. For example:

    REPOS=(core extra community !testing)

> ABS tree

The ABS tree is an SVN directory hierarchy located under /var/abs and
looks like this:

    | -- core/
    |     || -- acl/
    |     ||     || -- PKGBUILD
    |     || -- attr/
    |     ||     || -- PKGBUILD
    |     || -- abs/
    |     ||     || -- PKGBUILD
    |     || -- autoconf/
    |     ||     || -- PKGBUILD
    |     || -- ...
    | -- extra/
    |     || -- acpid/
    |     ||     || -- PKGBUILD
    |     || -- apache/
    |     ||     || -- PKGBUILD
    |     || -- ...
    | -- community/
    |     || -- ...

The ABS tree has exactly the same structure as the package database:

-   First-level: Reposistory name
-   Second-level: Package name directories
-   Third level: PKGBUILD (contains information needed to build a
    package) and other related files (patches, other files needed for
    building the package)

The source code for the package is not present in the ABS directory.
Instead, the PKGBUILD file contains a URL that will download the source
code when the package is built. So the size of abs tree is quite small.

Download ABS tree

As root, run:

    # abs

Your ABS tree is now created under /var/abs. Note the appropriate
branches of the ABS tree now exist and correspond to the ones you
specified in /etc/abs.conf.

The abs command should be run periodically to keep in sync with the
official repositories. Individual ABS package files can also be
downloaded with:

    # abs <repository>/<package>

This way you do not have to check out the entire abs tree just to build
one package.

> /etc/makepkg.conf

/etc/makepkg.conf specifies global environment variables and compiler
flags which you may wish to edit if you are using an SMP system, or to
specify other desired optimizations. The default settings are for i686
and x86_64 optimizations which will work fine for those architectures on
single-CPU systems. (The defaults will work on SMP machines, but will
only use one core/CPU when compiling -- see makepkg.conf.)

Set the PACKAGER variable in /etc/makepkg.conf

Setting the PACKAGER variable in /etc/makepkg.conf is an optional but
highly recommended step. It allows a "flag" to quickly identify which
packages have been built and/or installed by YOU, not the official
maintainer! This is easily accomplished using expac available from the
community repo:

Showing All Packages (including those from AUR)

    $ grep myname /etc/makepkg.conf
    PACKAGER="myname <myemail@myserver.com>"

    $ expac "%n %p" | grep "myname" | column -t
    archey3 myname
    binutils myname
    gcc myname
    gcc-libs myname
    glibc myname
    tar myname

Showing Only Packages Contained in Repos

This example only shows packages contained in the repos defined in
/etc/pacman.conf:

    $ . /etc/makepkg.conf; grep -xvFf <(pacman -Qqm) <(expac "%n\t%p" | grep "$PACKAGER$" | cut -f1)
    binutils
    gcc
    gcc-libs
    glibc
    tar

> Create a build directory

It is recommended to create a build directory where the actual compiling
will take place; you should never modify the ABS tree by building within
it, as data will be lost (overwritten) on each ABS update. It is good
practice to use your home directory, though some Arch users prefer to
create a 'local' directory under /var/abs/, owned by a normal user.

Create your build directory. e.g.:

    $ mkdir -p $HOME/abs

Copy the ABS from the tree (/var/abs/<repository>/<pkgname>) to the
build directory.

> Build package

In our example, we will build the slim display manager package.

Copy the slim ABS from the ABS tree to a build directory:

    $ cp -r /var/abs/extra/slim/ ~/abs

Navigate to the build directory:

    $ cd ~/abs/slim

Modify the PKGBUILD to add or remove support for components, to patch or
to change package versions, etc. (optional):

    $ nano PKGBUILD

Run makepkg as normal user (with -s switch to install with automatic
dependency handling):

    $ makepkg -s

Note:Before complaining about missing (make) dependencies, remember that
the base group is assumed to be installed on all Arch Linux systems. The
group "base-devel" is assumed to be installed when building with
makepkg. See #Install tools.

Install as root:

    # pacman -U slim-1.3.0-2-i686.pkg.tar.xz

That's it. You have just built slim from source and cleanly installed it
to your system with pacman. Package removal is also handled by pacman
with pacman -R slim.

The ABS method adds a level of convenience and automation, while still
maintaining complete transparency and control of the build and
installation functions by including them in the PKGBUILD.

fakeroot

Essentially, the same steps are being executed in the traditional method
(generally including the ./configure, make, make install steps) but the
software is installed into a fake root environment. (A fake root is
simply a subdirectory within the build directory that functions and
behaves as the system's root directory. In conjunction with the fakeroot
program, makepkg creates a fake root directory, and installs the
compiled binaries and associated files into it, with root as owner.) The
fake root, or subdirectory tree containing the compiled software, is
then compressed into an archive with the extension .pkg.tar.xz, or a
package. When invoked, pacman then extracts the package (installs it)
into the system's real root directory (/).

Retrieved from
"https://wiki.archlinux.org/index.php?title=Arch_Build_System&oldid=250471"

Categories:

-   About Arch
-   Package development
-   Package management
