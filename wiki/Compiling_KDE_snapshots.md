Compiling KDE snapshots
=======================

This article provides step-by-step guide how to compile your own KDE
git/svn snapshot from sources using kde-snapshots scripts. These scripts
are used for [kde-snapshots] repo.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Why?                                                               |
| -   3 Preparations                                                       |
|     -   3.1 Preparing build chroot                                       |
|         -   3.1.1 pacman.conf                                            |
|         -   3.1.2 makepkg.conf                                           |
|         -   3.1.3 sudoers                                                |
|                                                                          |
|     -   3.2 Build scripts                                                |
|     -   3.3 Folders Layout                                               |
|     -   3.4 Getting KDE sources                                          |
|     -   3.5 Setting KDE version                                          |
|                                                                          |
| -   4 Extra Packages                                                     |
| -   5 Building KDE                                                       |
|     -   5.1 Base packages                                                |
|         -   5.1.1 kdesupport                                             |
|         -   5.1.2 kdelibs                                                |
|         -   5.1.3 kdepimlibs                                             |
|         -   5.1.4 kdebase-runtime                                        |
|         -   5.1.5 kdebindings                                            |
|         -   5.1.6 kdebase-workspace                                      |
|         -   5.1.7 kdebase                                                |
|         -   5.1.8 kdegraphics                                            |
|         -   5.1.9 kdeedu                                                 |
|                                                                          |
|     -   5.2 Optional Packages                                            |
|         -   5.2.1 kdeaccessibility                                       |
|         -   5.2.2 kdeartwork                                             |
|         -   5.2.3 kdegames                                               |
|         -   5.2.4 kdemultimedia                                          |
|         -   5.2.5 kdenetwork                                             |
|         -   5.2.6 kdepim                                                 |
|         -   5.2.7 kdeplasma-addons                                       |
|         -   5.2.8 kdesdk                                                 |
|         -   5.2.9 kdetoys                                                |
|         -   5.2.10 kdeutils                                              |
|         -   5.2.11 kdewebdev                                             |
|                                                                          |
|     -   5.3 Final checks                                                 |
|                                                                          |
| -   6 Creating a repository                                              |
|     -   6.1 Advanced Configuration                                       |
|         -   6.1.1 packages file                                          |
+--------------------------------------------------------------------------+

Introduction
------------

The [kde-snapshots] used is an unofficial repository with weekly
development snapshots of KDE SC. After more the two years the repository
was abandoned due to lack of time of the original maintainer and later
picked up by member Zolnierz. The scripts are also available in git
repository and this article will show you how to use them to build your
own snapshots.

Compilation of entire KDE SC takes 4 to 5 hours on quad-core @2.8GHz
Intel Core i5 processor. When compiled with debug symbols
(RelWithDebInfo) and unstripped, packages have about 1.3 GiB, extracted
about 4.5 GiB.

Why?
----

KDE is a very big project. Every project contains lot of bugs and
issues. The bigger the project is the more bugs it contains. Repository
like [kde-snapshots] are important, because this way users can test the
software during development period and provide useful feedback to
developers, who can then fix and improve the software before official
release.

Another reason is that many people who are developing KDE applications
might find it useful to see what's coming in next official release and
thus adapt their software to possible API changes etc.

Preparations
------------

> Preparing build chroot

It is recommended to use a new clear build chroot for every new
snapshot. For purposes of this article, chroots will be located in
/home/build/chroots/{i686,x86_64}.

To prepare 32bit chroot, run

    $ CHROOTDIR=/home/build/chroots/i686
    $ mkdir -p ${CHROOTDIR}{/var/lib/pacman,home/build}
    $ pacman -Syy  -r ${CHROOTDIR} -b ${CHROOTDIR}/var/lib/pacman \
    >               --arch i686 --ignore linux \
    >               base base-devel cmake sudo svn git

It is recommended to have [testing] and [community-testing] repositories
enabled.

When chroot is installed, mount necessary folders into the chroot and
copy some configuration files

    $ mount /dev ${CHROOTDIR}/dev -o bind
    $ mount /proc ${CHROOTDIR}/proc -o bind
    $ mount none ${CHROOTDIR}/sys -t sysfs
    $ mount /home/build ${CHROOTDIR}/home/build -o bind
    $ cp /etc/resolv.conf ${CHROOTDIR}/etc/resolv.conf

Now you can switch to the chroot and create a new user build:

    $ screen
    $ linux32 chroot ${CHROOTDIR}
    # useradd -d /home/build -M -g build build

It is really good idea to run the chroot from screen, so that when you
accidentally close your terminal or X crashes the compilation won't be
interrupted.

If you want to have full access to the buildroot even from outside the
chroot, it's good practice to create a user with the same UID and GID as
your normal user. This can make things easier later.

pacman.conf

At this point you need to configure pacman mirrors in
/etc/pacman.d/mirrorlist. You can also enable [testing] and
[community-testing] repositories. Sometimes the git snapshots depend on
a pre-release or brand new release of some library or program. Thanks to
our great devs and TUs, these updates are usually already waiting for
you in testing repositories, so it's good to have them enabled.

makepkg.conf

If you intend to use the packages only on your computer, you can change
CFLAGS and CXXFLAGS to match your processor. There is a very nice page
with safe CFLAGS for individual processors on Gentoo Wiki - Intel, AMD.

See the Gentoo Linux Wiki article on this subject for more information:
CFLAGS

Also to speed up packaging, you can change PKGEXT to pkg.tar.gz.
Gzipp'ed tarballs are bigger then XZ'ed, but it takes much less time to
compress and decompress them.

To achieve maximum performance during compilations, set MAKEFLAGS to
number of your cores + 1.

If you want to publish your packages somewhere, it is good to set
PACKAGER variable too.

sudoers

Since we are in a chroot, we can allow some little security risks. We
will grant unlimited password-less sudo privileges to the build user by
adding following line to /etc/sudoers:

    build ALL=(ALL) NOPASSWD:ALL

If you are really paranoid, you can use

    build ALL=NOPASSWD: /usr/bin/pacman

to limit the 'unlimited' access only to pacman.

> Build scripts

To automate the build process a bit, the kde-build scripts were
originally taken and modified to work with the latest development
snapshots. The "new" scripts can be obtained from their gitorious page
by command

    git clone https://git.gitorious.org/kde-snapshots-repo/kde-snapshots-repo.git

Here are the most important scripts and files:

-   build-packages - the main script that will compile all the packages.
-   create-sources - this script fetches sources from KDE git and SVN
    repos
-   config - main configuration
-   extra/ - this folder contains additional extra packages (see Extra
    Packages section)
-   packages - contains list of GIT and SVN packages and their
    submodules
-   run-namcap - runs namcap on all packages
-   setup-chroot - not-completely-working script to automatically
    prepare and setup build chroot
-   update-pkgbuilds - updates pkgver and resets pkgrel in all PKGBUILDS

There are other scripts as well, but they mostly not working against the
current config and packages file. since I didn't use them when making
the repository, they are left after the original kde-build scripts.

> Folders Layout

By default, the scripts expect following directory structure:

    /home
      `- build
         |- build            # here will the compilations take place
         |- build-scripts    # build scripts and PKGBUILDS
         |  |- build         # contains subfolders with PKGBUILDs
         |  |- extra         # extra packages needed to build KDE
         |- logs             # makepkg logs
         |- namcap           # namcap logs (optional)
         |- packages         # new packages are moved in here
         `- sources          # sources of KDE

You can adjust the layout to your needs in the config file by modifying
$*dir variables. It is suggested to change only $buildroot, because the
scripts are not tested with another folder layout and may not work
properly.

> Getting KDE sources

You may want to check packages file first and make sure that no new
modules were migrated from SVN to git. Syntax of the file is explained
in detail in the Advanced Configuration section at the end of this
article.

To pull sources from SVN and git repositories, enter the scripts dir and
run

    $ ./create-sources

Despite it's name, the script will only call git pull or svn up if a
source is already available. The initial cloning will take some time
though, so you can go get your first coffee.

> Setting KDE version

Before you can start building, it's good to specify a version of KDE
snapshot. You can find current version of the KDE SC in
kdelibs/CMakeLists.txt. The snapshots are usually numbered 4.X.Y where X
is next release - 1 and Y is development snapshot version, somewhere
between 40 and 60 or 70. Beta releases are usually between 80 and 90,
Alphas and RCs are 90 through 99.

The version is specified in config file in {codeline|kdever}} variable.
Update it to match the KDE version and update the git date as well. When
you do it, save the changes and run

    $ ./update-pkgbuilds

This script will update pkgver in all PKGBUILDS to the value you just
set and will reset all pkgrel's to 1. It will also add options=(!strip)
to every PKGBUILD. If you do not want to have debug symbols in your KDE,
you need to comment it in the update-pkgbuilds script.

Note:Installed KDE with full debug symbols has about 4.2 GiB, KDE from
[extra] has about 600 MiB. If you can, please build KDE with full debug
symbols. You will get more useful backtraces from crashed programs which
can be very helpful to KDE developers. Testing and providing feedback
during the development cycle is very important, this way many bugs can
be found and fixed before official release.

Extra Packages
--------------

The extra subfolder contains some packages that might be needed to
successfully compile KDE or that provide additional useful or
interesting KDE-related packages.

You may want to compile and install create-svn, dbusmenu-qt-git,
gluon-git, kwebkitpart-git, libktorrent-git and {{ic|qhull} packages
before building KDE. It is very well possible, that you will have no
troubles compiling against packages from official repositories.

Building KDE
------------

Before starting the compilation make sure you do not have any old KDE
packages installed in the chroot. You can verify this by running

    $ ./uninstall-packages

Now we can finally start the compilation:

    $ ./build-packages

  

> Base packages

kdesupport

Sometimes kdesupport-phonon-{gstreamer,vlc} won't compile, unless an
older version of the package is already installed. You can work around
this by installing kdesupport-phonon from your previous snapshot, or
phonon from [extra] if you are build snapshot for the very first time.

Possible fix: split the kdesupport-phonon to a separate PKGBUILD so that
it would be installed before the backends will be compiled.

kdelibs

Usually compiles without problems.

kdepimlibs

No problems here.

kdebase-runtime

OK.

kdebindings

Make sure you do not have qwt installed in the chroot.
kdebindings-smokegen will compile against Qwt, but Qt bindings (for any
language) will fail with Qwt 6. There seems to be no switch to make
smokegen ignore Qwt, so the only solution is to have it not installed.

Note:Please update this section when Qt bindings will compile against
Qwt 6

kdebase-workspace

Builds without trouble.

kdebase

Smooth and soft...

kdegraphics

Works like a charm.

kdeedu

Some submodules (namely kanagram, khangman, parley and kwordquiz) use
hardcoded location of libkeduvocdocument.so and libkdeedu include
directory. This values are modified in the source codes from PKGBUILD
during compilation. Make sure you will never compile kdeedu for both
architectures at the same time. The compilations are running on top of
same sources (symlinked from /home/build/sources), so they would be
overwriting the changes each other.

  
 Possible fix: move libkdeedu to separate PKGBUILD that would be
installed before compiling other kdeedu submodules.

Note:Please update this section when the locations can be set manually
or when libkdeedu is moved to a separate PKGBUILD

> Optional Packages

kdeaccessibility

Builds OK.

kdeartwork

Builds OK.

kdegames

Builds OK.

kdemultimedia

Builds OK.

kdenetwork

Builds OK.

kdepim

Builds OK.

Fails to compile when kdelibs are built without Nepomuk, so make sure
Nepomuk is properly compiled.

kdeplasma-addons

Builds OK.

kdesdk

Builds OK.

kdetoys

Builds OK.

kdeutils

Builds OK.

kdewebdev

Builds OK.

> Final checks

Cool, your own KDE snapshot is now compiled. If some of the optional
packages failed to compile, check the logs for errors and try to rebuild
them manually.

Creating a repository
---------------------

This is an optional step. If you want to have a (not necessarily public)
repository with KDE, enter the packages directory in build root and in
the architecture sub folder run

    $ repo-add my-repo-name.db.tar.gz *.pkg.tar.xz

This will create a DB file to be fetched by pacman. Now just upload it
somewhere together with the packages and you are done.

  

> Advanced Configuration

packages file

Since KDE is now in the middle of SVN->git migration, it's necessary to
check packages file before pulling sources. The syntax of the file is
quite simple:

-   base_pkgs - Packages that are mandatory and other packages depend on
    them. When compilation of a base_pkg fails, the entire compilation
    process is interrupted.
-   opt_pkgs - Packages that are not mandatory. When compilation of a
    opt_pkg fails, the scripts will automatically proceed to next
    package. After all packages are compiled, you will be displayed list
    of broken packages.
-   ${pkgbase}_${scm}_pkgs is array of ${pkgbase}'s submodules located
    in ${scm} (git or svn) repository. For example, all kdesupport
    submodules are in git already, so the array kdesupport_git_pkgs will
    fetch all submodules from git://anongit.kde.org/${submodule} to
    ${srcdir}/${pkgbase}/${submodule}. When the submodule is named like
    ${submodule}:${alternative_name}, it will be cloned from
    git://anongit.kde.org/${submodule} to
    ${srcdir}/${pkgbase}/${alternative_name}. You can specify
    alternative URL of a submodule by entering
    @git://alternative.git/repository. When the base package does not
    have any submodules, like for example kdelibs, a @${pkgbase} must be
    provided in the submodules.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Compiling_KDE_snapshots&oldid=249452"

Category:

-   Desktop environments
