VCS PKGBUILD Guidelines
=======================

Package creation guidelines

* * * * *

CLR – Cross – Eclipse – Free Pascal – GNOME – Go – Haskell – Java – KDE
– Kernel – Lisp – MinGW – Nonfree – OCaml – Perl – Python – Ruby – VCS –
Web – Wine

Version control systems can be used for retrieval of source code for
both usual statically versioned packages and latest (trunk) version of
packages. This article covers both cases.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Prototypes                                                         |
| -   2 Guidelines                                                         |
|     -   2.1 VCS sources                                                  |
|     -   2.2 The pkgver() function                                        |
|         -   2.2.1 Git                                                    |
|         -   2.2.2 Subversion                                             |
|         -   2.2.3 Mercurial                                              |
|         -   2.2.4 Bazaar                                                 |
|         -   2.2.5 Fallback                                               |
|                                                                          |
| -   3 Tips                                                               |
|     -   3.1 A sample Git PKGBUILD                                        |
|     -   3.2 Removing VCS leftovers                                       |
|     -   3.3 SVN packages that try to get their revision number           |
|                                                                          |
| -   4 Troubleshooting                                                    |
|     -   4.1 Bazaar limitation                                            |
+--------------------------------------------------------------------------+

Prototypes
----------

The ABS package provides prototypes for cvs, svn, git, mercurial, and
darcs PKGBUILDs. When abs is installed, you can find them in
/usr/share/pacman. Latest versions can be found in the prototypes
directory in the ABS Git repository.

Guidelines
----------

-   Suffix pkgname with -cvs, -svn, -hg, -darcs, -bzr, -git etc. unless
    the package fetches a specific release.

-   If the resulting package is different after changing the
    dependencies, URL, sources, etc. increasing the pkgrel is mandatory.
    Touching the pkgver isn't.

-   --holdver can be used to prevent makepkg from updating the pkgver
    (see: makepkg(8))

-   Include what the package conflicts with and provides (e.g. for
    fluxbox-git: conflicts=('fluxbox') and provides=('fluxbox')).

-   replaces=() generally causes unnecessary problems and should be
    avoided.

-   When using the cvsroot, use anonymous:@ rather than anonymous@ to
    avoid having to enter a blank password or anonymous:password@, if
    one is required.

-   Include the appropriate VCS tool in makedepends=() (cvs, subversion,
    git, ...).

> VCS sources

Note:Pacman 4.1 supports the following VCS sources: bzr, git, hg and
svn. See the fragment section of man PKGBUILD or PKGBUILD(5) for a list
of supported VCS.

Starting with pacman 4.1, the VCS sources should be specified in the
source=() array and will be treated like any other source. makepkg will
clone/checkout/branch the repo into $SRCDEST (same as $startdir if not
set in makepkg.conf(5)) and copy it to $srcdir (in a specific way to
each VCS). The local repo is left untouched, thus invalidating the need
for a -build directory.

The general format of a VCS source=() array is:

    source=('[folder::][vcs+]url[#fragment]')

-   folder (optional) is used to change the default repo name to
    something more relevant (e.g. than trunk) or to preserve the
    previous sources
-   vcs+ is needed for URLs that do not reflect the VCS type, e.g.
    git+http://some_repo.
-   url is the URL to the distant or local repo
-   #fragment (optional) is needed to pull a specific branch or commit

An example Git source array:

    source=('project_name::git+http://project_url#branch=project_branch')

> The pkgver() function

The pkgver autobump is now achieved via a dedicated pkgver() function.
This allows for better control over the pkgver, and maintainers should
favor a pkgver that makes sense. Following are some examples showing the
intended output:

Git

Using the tag of the last commit:

    pkgver() {
      cd local_repo
      git describe --always | sed 's|-|.|g'
    }

    2.0.6

If there are no annotated tags:

    pkgver() {
      cd local_repo
      echo $(git rev-list --count HEAD).$(git rev-parse --short HEAD)
    }

    1142.a17a017

Subversion

    pkgver() {
      cd "$SRCDEST/local_repo"
      svnversion | tr -d [A-z]
    }

    8546

Note:The copy in $srcdir is made using svn export which does not create
working copies. Any svn related command has to be used in the local repo
in $SRCDEST.

Mercurial

    pkgver() {
      cd local_repo
      echo $(hg identify -n).$(hg identify -i)
    }

    2813.75881cc5391e

Bazaar

    pkgver() {
      cd local_repo
      bzr revno
    }

    830

Fallback

The current date can be used, in case no satisfactory pkgver can be
extracted from the repo:

    pkgver() {
      date +%Y%m%d
    }

    20130408

Tips
----

> A sample Git PKGBUILD

    # Maintainer: Dave Reisner <d@falconindy.com> 
    # Contributor: William Giokas (KaiSforza) <1007380@gmail.com>

    pkgname=expac-git
    _gitname=expac
    pkgver=0.0.0
    pkgrel=1
    pkgdesc="Pacman database extraction utility"
    arch=('i686' 'x86_64')
    url="https://github.com/falconindy/expac"
    license=('MIT')
    depends=('pacman')
    makedepends=('git' 'perl')
    conflicts=('expac')
    provides=('expac')
    # The git repo is detected by the 'git:' or 'git+' beginning. The branch
    # 'pacman41' is then checked out upon cloning, expediating versioning:
    #source=('git+https://github.com/falconindy/expac.git'
    source=('git://github.com/falconindy/expac.git'
            'expac_icon.png')
    # Because the sources are not static, skip Git checksum:
    md5sums=('SKIP'
             '020c36e38466b68cbc7b3f93e2044b49')

    pkgver() {
      cd $_gitname
      # Use the tag of the last commit
      git describe --always | sed 's|-|.|g'
    }

    build() {
      cd $_gitname
      make
    }

    package() {
      cd $_gitname
      make PREFIX=/usr DESTDIR="$pkgdir" install
      install -Dm644 "$srcdir/expac_icon.png" "$pkgdir/usr/share/pixmaps/expac.png"
    }

> Removing VCS leftovers

To make sure that there are no VCS leftovers use the following at the
end of the package() function (replacing .git with .svn, .hg, etc.):

    find "$pkgdir" -type d -name .git -exec rm -r '{}' +

> SVN packages that try to get their revision number

If the build system for the program you are packaging calls svnversion
or svn info to determine its revision number, you can add a prepare()
function similar to this one to make it work:

    prepare() {
      cp -a "$SRCDEST/$_svnmod/.svn" "$srcdir/$_svnmod/"
    }

Troubleshooting
---------------

> Bazaar limitation

Currently, only one type of bazaar URLs can be used in the source array,
which format is specific to the host. For example, Launchpad URLs will
need to start with http://bazaar.launchpad.net/, e.g.:

    source=('project_name::bzr+http://bazaar.launchpad.net/~project_team/project_path')

Also, lp: URLs are not supported at the moment. Failing to use the
correct URL will prevent makepkg from updating the local repo. The
correct URL for each host can be obtained by running:

    $ bzr config parent_location

inside the local repo.

Note:These issues will be fixed in pacman 4.1.1.

Retrieved from
"https://wiki.archlinux.org/index.php?title=VCS_PKGBUILD_Guidelines&oldid=255922"

Category:

-   Package development
