PKGBUILD
========

Summary

This article provides an explanation of PKGBUILD variables used when
creating packages. A PKGBUILD is a script that describes how software is
to be compiled and packaged. Writing installation functions and general
packaging information is covered in Creating Packages and other package
development articles

Overview

Packages in Arch Linux are built using makepkg and a custom build script
for each package (known as a PKGBUILD). Once packaged, software can be
installed and managed with pacman. PKGBUILDs for software in the
official repositories are available from the ABS tree; thousands more
are available from the (unsupported) Arch User Repository.

Related

Arch Packaging Standards

Creating Packages

Custom local repository

pacman Tips

PKGBUILD Templates

Resources

PKGBUILD(5) Manual Page

A PKGBUILD is an Arch Linux package build description file (actually it
is a shell script) used when creating packages.

Packages in Arch Linux are built using the makepkg utility and
information stored in PKGBUILDs. When makepkg is run, it searches for a
PKGBUILD in the current directory and follows the instructions therein
to either compile or otherwise acquire the files to build a package file
(pkgname.pkg.tar.xz). The resulting package contains binary files and
installation instructions, readily installed with pacman.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Variables                                                          |
|     -   1.1 pkgname                                                      |
|     -   1.2 pkgver                                                       |
|     -   1.3 pkgrel                                                       |
|     -   1.4 pkgdir                                                       |
|     -   1.5 epoch                                                        |
|     -   1.6 pkgbase                                                      |
|     -   1.7 pkgdesc                                                      |
|     -   1.8 arch                                                         |
|     -   1.9 url                                                          |
|     -   1.10 license                                                     |
|     -   1.11 groups                                                      |
|     -   1.12 depends                                                     |
|     -   1.13 makedepends                                                 |
|     -   1.14 checkdepends                                                |
|     -   1.15 optdepends                                                  |
|     -   1.16 provides                                                    |
|     -   1.17 conflicts                                                   |
|     -   1.18 replaces                                                    |
|     -   1.19 backup                                                      |
|     -   1.20 options                                                     |
|     -   1.21 install                                                     |
|     -   1.22 changelog                                                   |
|     -   1.23 source                                                      |
|     -   1.24 noextract                                                   |
|     -   1.25 md5sums                                                     |
|     -   1.26 sha1sums                                                    |
|     -   1.27 sha256sums, sha384sums, sha512sums                          |
|                                                                          |
| -   2 See also                                                           |
+--------------------------------------------------------------------------+

Variables
---------

The following are variables that can be filled out in the PKGBUILD file.

It is common practice to define the variables in the PKGBUILD in same
order as given here. However, this is not mandatory, as long as correct
Bash syntax is used.

> pkgname

The name of the package. It should consist of alphanumeric and any of
the following characters @ . _ + - (at symbol, dot, underscore, plus,
hyphen). All letters should be lowercase and names are not allowed to
start with hyphens. For the sake of consistency, pkgname should match
the name of the source tarball of the software you are packaging. For
instance, if the software is in foobar-2.5.tar.gz, the pkgname value
should be foobar. The present working directory the PKGBUILD file is in
should also match the pkgname.

> pkgver

The version of the package. The value should be the same as the version
released by the author of the package. It can contain letters, numbers,
periods and underscore but CANNOT contain a hyphen. If the author of the
package uses a hyphen in their version numbering scheme, replace it with
an underscore. For instance, if the version is 0.99-10, it should be
changed to 0.99_10. If the pkgver variable is used later in the PKGBUILD
then the underscore can easily be substituted for a dash on usage e.g.:

    source=($pkgname-${pkgver//_/-}.tar.gz)

> pkgrel

The release number of the package specific to Arch Linux. This value
allows users to differentiate between consecutive builds of the same
version of a package. When a new package version is first released, the
release number starts at 1. As fixes and optimizations are made to the
PKGBUILD file, the package will be re-released and the release number
will increment by 1. When a new version of the package comes out, the
release number resets to 1.

> pkgdir

Don't worry about this. It defaults to the location where makepkg is
being executed.

> epoch

An integer value, specific to Arch Linux, representing what 'lifetime'
to compare version numbers against. This value allows overrides of the
normal version comparison rules for packages that have inconsistent
version numbering, require a downgrade, change numbering schemes, etc.
By default, packages are assumed to have an epoch value of 0. Do not use
this unless you know what you are doing.

> pkgbase

An optional global directive is available when building a split package,
pkgbase is used to refer to the group of packages in the output of
makepkg and in the naming of source-only tarballs. If not specified, the
first element in the pkgname array is used. All options and directives
for the split packages default to the global values given in the
PKGBUILD. Nevertheless, the following ones can be overridden within each
split package's packaging function: pkgver, pkgrel, epoch, pkgdesc,
arch, url, license, groups, depends, optdepends, provides, conflicts,
replaces, backup, options, install and changelog. The variable is not
allowed to begin with a hyphen.

> pkgdesc

The description of the package. The description should be about 80
characters or less and should not include the package name in a
self-referencing way. For instance, "Nedit is a text editor for X11"
should be written as "A text editor for X11."

Note:Do not follow this rule thoughtlessly when submitting packages to
AUR. If package name differs from application name for some reason,
inclusion of full name into description can be the only way to ensure
that package can be found during search.

> arch

An array of architectures that the PKGBUILD file is known to build and
work on. Currently, it should contain i686 and/or x86_64,
arch=('i686' 'x86_64'). The value any can also be used for
architecture-independent packages.

You can access the target architecture with the variable $CARCH during a
build, and even when defining variables. See also FS#16352. Example:

    depends=(foobar)
    if test "$CARCH" == x86_64; then
      depends+=(lib32-glibc)
    fi

> url

The URL of the official site of the software being packaged.

> license

The license under which the software is distributed. A licenses package
has been created in [core] that stores common licenses in
/usr/share/licenses/common, e.g. /usr/share/licenses/common/GPL. If a
package is licensed under one of these licenses, the value should be set
to the directory name, e.g. license=('GPL'). If the appropriate license
is not included in the official licenses package, several things must be
done:

1.  The license file(s) should be included in:
    /usr/share/licenses/pkgname/, e.g.
    /usr/share/licenses/foobar/LICENSE.
2.  If the source tarball does NOT contain the license details and the
    license is only displayed elsewhere, e.g. a website, then you need
    to copy the license to a file and include it.
3.  Add custom to the license array. Optionally, you can replace custom
    with custom:name of license. Once a license is used in two or more
    packages in an official repository (including [community]), it
    becomes a part of the licenses package.

-   The BSD, MIT, zlib/png and Python licenses are special cases and
    could not be included in the licenses package. For the sake of the
    license array, it is treated as a common license (license=('BSD'),
    license=('MIT'), license=('ZLIB') and license=('Python')) but
    technically each one is a custom license because each one has its
    own copyright line. Any packages licensed under these four should
    have its own unique license stored in /usr/share/licenses/pkgname.
    Some packages may not be covered by a single license. In these
    cases, multiple entries may be made in the license array, e.g.
    license=('GPL' 'custom:name of license').
-   Additionally, the (L)GPL has many versions and permutations of those
    versions. For (L)GPL software, the convention is:
    -   (L)GPL - (L)GPLv2 or any later version
    -   (L)GPL2 - (L)GPL2 only
    -   (L)GPL3 - (L)GPL3 or any later version

-   If after researching the issue no license can be determined,
    PKGBUILD.proto suggests using unknown. However, upstream should be
    contacted about the conditions under which the software is (and is
    not) available.

Tip:Some software authors do not provide separate license file and
describe distribution rules in section of common ReadMe.txt. This
information can be extracted in separate file during build phase with
something like this:
sed -n '/This software/,/  thereof./p' ReadMe.txt > LICENSE.

> groups

The group the package belongs in. For instance, when you install the
kdebase package, it installs all packages that belong in the kde group.

> depends

An array of package names that must be installed before this software
can be run. If a software requires a minimum version of a dependency,
the >= operator should be used to point this out, e.g.
depends=('foobar>=1.8.0'). You do not need to list packages that your
software depends on if other packages your software depends on already
have those packages listed in their dependency. For instance, gtk2
depends on glib2 and glibc. However, glibc does not need to be listed as
a dependency for gtk2 because it is a dependency for glib2.

> makedepends

An array of package names that must be installed to build the software
but unnecessary for using the software after installation. You can
specify the minimum version dependency of the packages in the same
format as the depends array.

Note:Specifying packages that are already in depends is not necessary.

Warning:The group base-devel is assumed already installed when building
with makepkg . Members of "base-devel" should not be included in
makedepends arrays.

> checkdepends

An array of packages this package depends on to run its test suite but
are not needed at runtime. Packages in this list follow the same format
as depends. These dependencies are only considered when the check()
function is present and is to be run by makepkg.

> optdepends

An array of package names that are not needed for the software to
function but provides additional features. A short description of what
each package provides should also be noted. An optdepends may look like
this:

    optdepends=('cups: printing support'
    'sane: scanners support'
    'libgphoto2: digital cameras support'
    'alsa-lib: sound support'
    'giflib: GIF images support'
    'libjpeg: JPEG images support'
    'libpng: PNG images support')

> provides

An array of package names that this package provides the features of (or
a virtual package such as cron or sh). Packages that provide the same
things can be installed at the same time unless conflict with each other
(see below). If you use this variable, you should add the version
(pkgver and perhaps the pkgrel) that this package will provide if
dependencies may be affected by it. For instance, if you are providing a
modified qt package named qt-foobar version 3.3.8 which provides qt then
the provides array should look like provides=('qt=3.3.8'). Putting
provides=('qt') will cause to fail those dependencies that require a
specific version of qt. Do not add pkgname to your provides array, this
is done automatically.

> conflicts

An array of package names that may cause problems with this package if
installed. Package with this name and all packages which provides
virtual packages with this name will be removed. You can also specify
the version properties of the conflicting packages in the same format as
the depends array.

> replaces

An array of obsolete package names that are replaced by this package,
e.g. replaces=('ethereal') for the wireshark package. After syncing with
pacman -Sy, it will immediately replace an installed package upon
encountering another package with the matching replaces in the
repositories. If you are providing an alternate version of an already
existing package, use the conflicts variable which is only evaluated
when actually installing the conflicting package.

> backup

An array of files that can contain user-made changes and should be
preserved during upgrade or removal of a package, primarily intended for
configuration files in /etc.

When updating, new version may be saved as file.pacnew to avoid
overwriting a file which already exists and was previously modified by
the user. Similarly, when the package is removed, user-modified file
will be preserved as file.pacsave unless the package was removed with
pacman -Rn command.

The file paths in this array should be relative paths (e.g.
etc/pacman.conf) not absolute paths (e.g. /etc/pacman.conf). See also
Pacnew and Pacsave Files.

> options

This array allows you to override some of the default behavior of
makepkg, defined in /etc/makepkg.conf. To set an option, include the
option name in the array. To reverse the default behavior, place an ! at
the front of the option. The following options may be placed in the
array:

-   strip - Strips symbols from binaries and libraries. If you
    frequently use a debugger on programs or libraries, it may be
    helpful to disable this option.
-   docs - Save /doc directories.
-   libtool - Leave libtool (.la) files in packages.
-   emptydirs - Leave empty directories in packages.
-   zipman - Compress man and info pages with gzip.
-   purge - Remove files specified by the PURGE_TARGETS variable from
    the package.
-   upx - Compress binary executable files using UPX. Additional options
    can be passed to UPX by specifying the UPXFLAGS variable.
-   ccache - Allow the use of ccache during build. More useful in its
    negative form !ccache with select packages that have problems
    building with ccache.
-   distcc - Allow the use of distcc during build. More useful in its
    negative form !distcc with select packages that have problems
    building with distcc.
-   buildflags - Allow the use of user-specific buildflags (CFLAGS,
    CXXFLAGS, LDFLAGS) during build. More useful in its negative form
    !buildflags with select packages that have problems building with
    custom buildflags.
-   makeflags - Allow the use of user-specific makeflags during build.
    More useful in its negative form !makeflags with select packages
    that have problems building with custom makeflags.

> install

The name of the .install script to be included in the package. pacman
has the ability to store and execute a package-specific script when it
installs, removes or upgrades a package. The script contains the
following functions which run at different times:

-   pre_install - The script is run right before files are extracted.
    One argument is passed: new package version.
-   post_install - The script is run right after files are extracted.
    One argument is passed: new package version.
-   pre_upgrade - The script is run right before files are extracted.
    Two arguments are passed in the following order: new package
    version, old package version.
-   post_upgrade - The script is run after files are extracted. Two
    arguments are passed in the following order: new package version,
    old package version.
-   pre_remove - The script is run right before files are removed. One
    argument is passed: old package version.
-   post_remove - The script is run right after files are removed. One
    argument is passed: old package version.

Each function is run chrooted inside the pacman install directory. See
this thread.

Tip:A prototype .install is provided at /usr/share/pacman/proto.install.

> changelog

The name of the package changelog. To view changelogs for installed
packages (that have this file):

    pacman -Qc pkgname

Tip:A prototype changelog file is provided at
/usr/share/pacman/ChangeLog.proto.

> source

An array of files which are needed to build the package. It must contain
the location of the software source, which in most cases is a full HTTP
or FTP URL. The previously set variables pkgname and pkgver can be used
effectively here (e.g.
source=(http://example.com/$pkgname-$pkgver.tar.gz))

Note:If you need to supply files which are not downloadable on the fly,
e.g. self-made patches, you simply put those into the same directory
where your PKGBUILD file is in and add the filename to this array. Any
paths you add here are resolved relative to the directory where the
PKGBUILD lies. Before the actual build process is started, all of the
files referenced in this array will be downloaded or checked for
existence, and makepkg will not proceed if any are missing.

Tip:You can specify a different name for the downloaded file - if the
downloaded file has a different name for some reason like the URL had a
GET parameter - using the following syntax: filename::fileuri, for
example
$pkgname-$pkgver.zip::http://199.91.152.193/7pd0l2tpkidg/jg2e1cynwii/Warez_collection_16.4.exe

> noextract

An array of files listed under the source array which should not be
extracted from their archive format by makepkg. This most commonly
applies to certain zip files which cannot be handled by /usr/bin/bsdtar
because libarchive processes all files as streams rather than random
access as unzip does. In these situations unzip should be added in the
makedepends array and the first line of the build() function should
contain:

    cd "$srcdir/$pkgname-$pkgver"
    unzip [source].zip

Note that while the source array accepts URLs, noextract is just the
file name portion. So, for example, you would do something like this
(simplified from grub2's PKGBUILD):

    source=("http://ftp.archlinux.org/other/grub2/grub2_extras_lua_r20.tar.xz")
    noextract=("grub2_extras_lua_r20.tar.xz")

To extract nothing, you can do something fancy like this (taken from
firefox-i18n):

    noextract=(${source[@]##*/})

Note:More conservative Bash substitution would include quotes, or
possibly even a loop that calls basename. If you have read this far, you
should get the idea.

> md5sums

An array of MD5 checksums of the files listed in the source array. Once
all files in the source array are available, an MD5 hash of each file
will be automatically generated and compared with the values of this
array in the same order they appear in the source array. While the order
of the source files itself does not matter, it is important that it
matches the order of this array since makepkg cannot guess which
checksum belongs to what source file. You can generate this array
quickly and easily using the commands updpkgsums or makepkg -g in the
directory that contains the PKGBUILD file. Note that the MD5 algorithm
is known to have weaknesses, so you should consider using a stronger
alternative.

> sha1sums

An array of SHA-1 160-bit checksums. This is an alternative to md5sums
described above, but it is also known to have weaknesses, so you should
consider using a stronger alternative. To enable use and generation of
these checksums, be sure to set up the INTEGRITY_CHECK option in
/etc/makepkg.conf. See man makepkg.conf.

> sha256sums, sha384sums, sha512sums

An array of SHA-2 checksums with digest sizes 256, 384 and 512 bits
respectively. These are alternatives to md5sums described above and are
generally believed to be stronger. To enable use and generation of these
checksums, be sure to set up the INTEGRITY_CHECK option in
/etc/makepkg.conf. See man makepkg.conf.

See also
--------

-   Example PKGBUILD file
-   Example .install file

Retrieved from
"https://wiki.archlinux.org/index.php?title=PKGBUILD&oldid=253211"

Category:

-   Package development
