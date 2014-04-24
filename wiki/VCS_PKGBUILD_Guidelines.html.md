VCS PKGBUILD Guidelines
=======================

Package creation guidelines

* * * * *

CLR – Cross – Eclipse – Free Pascal – GNOME – Go – Haskell – Java – KDE
– Kernel – Lisp – MinGW – Nonfree – OCaml – Perl – Python – Ruby – VCS –
Web – Wine

Version control systems can be used for retrieval of source code for
both usual statically versioned packages and latest (trunk) version of a
development branch. This article covers both cases.

Contents
--------

-   1 Prototypes
-   2 Guidelines
    -   2.1 VCS sources
    -   2.2 The pkgver() function
        -   2.2.1 Git
        -   2.2.2 Subversion
        -   2.2.3 Mercurial
        -   2.2.4 Bazaar
        -   2.2.5 Fallback
-   3 Tips
    -   3.1 A sample Git PKGBUILD
    -   3.2 Git Submodules

Prototypes
----------

Warning:The prototype files provided in the abs package and in the ABS
Git repository are significantly out-of-date. Do not consider the
prototypes to be authoritative in any way. See FS#34485.

The abs package for the Arch Build System provides prototypes for CVS,
SVN, Git, Mercurial, and Darcs PKGBUILDs. When abs is installed, you can
find them in /usr/share/pacman. Latest versions can be found in the
prototypes directory in the ABS Git repository.

Guidelines
----------

-   Suffix pkgname with -cvs, -svn, -hg, -darcs, -bzr, -git etc. unless
    the package fetches a specific release.

-   If the resulting package is different after changing the
    dependencies, URL, sources, etc. increasing the pkgrel is mandatory.
    Touching the pkgver is not.

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
-   #fragment (optional) is needed to pull a specific branch or commit.
    See man PKGBUILD for more information on the fragments available for
    each VCS.

An example Git source array:

    source=('project_name::git+http://project_url#branch=project_branch')

> The pkgver() function

The pkgver autobump is now achieved via a dedicated pkgver() function.
This allows for better control over the pkgver, and maintainers should
favor a pkgver that makes sense.

It is recommended to have following version format: RELEASE.rREVISION
where REVISION is a monotonically increasing number that uniquely
identifies the source tree (VCS revisions do this). The last VCS tag can
be used for RELEASE. If there are no public releases and no repository
tags then zero could be used as a release number or you can drop RELEASE
completely and use version number that looks like rREVISION. If there
are public releases but repo has no tags then developer should get the
release version somehow e.g. by parsing the project files.

Following are some examples showing the intended output:

Git

Using the most recent annotated tag reachable from the last commit:

    pkgver() {
      cd "$srcdir/repo"
      git describe --long | sed -r 's/([^-]*-g)/r\1/;s/-/./g'
    }

    2.0.r6.ga17a017

Using the most recent unannotated tag reachable from the last commit:

    pkgver() {
      cd "$srcdir/repo"
      git describe --long --tags | sed -r 's/([^-]*-g)/r\1/;s/-/./g'
    }

    0.71.r115.gd95ee07

In case if the git tag does not contain dashes then one can use simpler
sed expression sed 's/-/.r/; s/-/./'.

If tag contains a prefix, like v or project name then it should be cut
off:

    pkgver() {
      cd "$srcdir/repo"
      # cutting off 'foo-' prefix that presents in the git tag
      git describe --long | sed -r 's/^foo-//;s/([^-]*-g)/r\1/;s/-/./g'
    }

    6.1.r3.gd77e105

If there are no tags then use number of revisions since beginning of the
history:

    pkgver() {
      cd "$srcdir/repo"
      printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
    }

    r1142.a17a017

Note:SHA1 (in this case a17a017) is not used in the version comparison
and can be omitted, although it allows quick identification of the exact
revision used and might be useful during debugging.

Subversion

    pkgver() {
      cd "$srcdir/repo"
      local ver="$(svnversion)"
      printf "r%s" "${ver//[[:alpha:]]}"
    }

    r8546

Note:If the project has releases you should use them instead of the 0..

Mercurial

    pkgver() {
      cd "$srcdir/repo"
      printf "r%s.%s" "$(hg identify -n)" "$(hg identify -i)"
    }

    r2813.75881cc5391e

Bazaar

    pkgver() {
      cd "$srcdir/repo"
      printf "r%s" "$(bzr revno)"
    }

    r830

Fallback

The current date can be used, in case no satisfactory pkgver can be
extracted from the repository:

    pkgver() {
      date +%Y%m%d
    }

    20130408

Although it does not identify source tree state uniquely, so avoid it if
possible.

Tips
----

> A sample Git PKGBUILD

    # Maintainer: Dave Reisner <d@falconindy.com> 
    # Contributor: William Giokas (KaiSforza) <1007380@gmail.com>

    pkgname=expac-git
    pkgver=0.0.0
    pkgrel=1
    pkgdesc="Pacman database extraction utility"
    arch=('i686' 'x86_64')
    url="https://github.com/falconindy/expac"
    license=('MIT')
    depends=('pacman')
    makedepends=('git')
    conflicts=('expac')
    provides=('expac')
    # The git repo is detected by the 'git:' or 'git+' beginning. The branch
    # '$pkgname' is then checked out upon cloning, expediating versioning:
    #source=('git+https://github.com/falconindy/expac.git'
    source=("$pkgname"::'git://github.com/falconindy/expac.git'
            'expac_icon.png')
    # Because the sources are not static, skip Git checksum:
    md5sums=('SKIP'
             '020c36e38466b68cbc7b3f93e2044b49')

    pkgver() {
      cd "$srcdir/$pkgname"
      # Use the tag of the last commit
      git describe --long | sed -E 's/([^-]*-g)/r\1/;s/-/./g'
    }

    build() {
      cd "$srcdir/$pkgname"
      make
    }

    package() {
      cd "$srcdir/$pkgname"
      make PREFIX=/usr DESTDIR="$pkgdir" install
      install -Dm644 "$srcdir/expac_icon.png" "$pkgdir/usr/share/pixmaps/expac.png"
    }

> Git Submodules

Git submodules are a little tricky to do. The idea is to add the URLs of
the submodules themselves directly to the sources array and then
reference them during prepare(). This could look like this:

    source=("git://somewhere.org/something/something.git"
            "git://somewhere.org/mysubmodule/mysubmodule.git")

    prepare() {
        cd something
        git submodule init
        git config submodule.mysubmodule.url $srcdir/mysubmodule
        git submodule update
    }

Retrieved from
"https://wiki.archlinux.org/index.php?title=VCS_PKGBUILD_Guidelines&oldid=296261"

Category:

-   Package development

-   This page was last modified on 5 February 2014, at 06:25.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
