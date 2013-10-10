Dracorp/sandbox/PKGBUILD
========================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: Strona nie w      
                           pełni przetłumaczona     
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Translation Status：This article is a localized version of PKGBUILD.
Last translation date: 9 November 2012‎. Click ID this link to check
English page changes after translation.

> Summary

PKGBUILD jest skryptem który opisuje jak skompilować oprogramowanie i
zbudować pakiet. Poniższy artykuł wyjaśnia znaczenie zmiennych PKGBUILDa
podczas tworzenia pakietów.

> Przegląd

Packages in Arch Linux are built using makepkg and a custom build script
for each package (known as a PKGBUILD). Once packaged, software can be
installed and managed with pacman. PKGBUILDs for software in the
official repositories are available from the ABS tree; thousands more
are available from the (unsupported) Arch User Repository.

> Powiązane

Arch Packaging Standards

Tworzenie Pakietów

Custom local repository

pacman Tips

> Resources

PKGBUILD(5) Strona Man

PKGBUILD jest plikiem Arch Linuksa opisującym proces budowania pakietu
używany podczas tworzenia pakietów.

Pakiety w Arch Linuksie budowane są za pomocą narzędzia makepkg i
informacji zawartych w PKGBUILDach. Kiedy makepkg jest uruchamiany,
szuka pliku PKGBUILD w aktualnym katalogu i postępuje zgodnie ze
wskazówkami w nim zawartymi aby skompilować źródła lub w jakikolwiek
inny sposób pobrać pliki potrzebne do zbudowania pliku pakietu
(pkgname.pkg.tar.xz). Wynikowy pakiet zawiera pliki binarne i instrukcje
instalacyjne, łatwo instalowane z pacmanem.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Zmienne                                                            |
|     -   1.1 pkgname                                                      |
|     -   1.2 pkgver                                                       |
|     -   1.3 pkgrel                                                       |
|     -   1.4 epoch                                                        |
|     -   1.5 pkgdesc                                                      |
|     -   1.6 arch                                                         |
|     -   1.7 url                                                          |
|     -   1.8 license                                                      |
|     -   1.9 groups                                                       |
|     -   1.10 depends                                                     |
|     -   1.11 makedepends                                                 |
|     -   1.12 checkdepends                                                |
|     -   1.13 optdepends                                                  |
|     -   1.14 provides                                                    |
|     -   1.15 conflicts                                                   |
|     -   1.16 replaces                                                    |
|     -   1.17 backup                                                      |
|     -   1.18 options                                                     |
|     -   1.19 install                                                     |
|     -   1.20 changelog                                                   |
|     -   1.21 source                                                      |
|     -   1.22 noextract                                                   |
|     -   1.23 md5sums                                                     |
|     -   1.24 sha1sums                                                    |
|     -   1.25 sha256sums, sha384sums, sha512sums                          |
|                                                                          |
| -   2 See also                                                           |
+--------------------------------------------------------------------------+

Zmienne
-------

Poniżej przedstawiono zmienne które mogą być użyte w pliku PKGBUILD.

Powszechną praktyką jest zdefiniowanie zmiennych w PKGBUILD w tej samej
kolejności, jak podano tutaj. Jednak nie jest to obowiązkowe, tak jak
poprawna składnia Bash (Polski) jest używana.

> pkgname

Nazwa pakietu. Powina składać się z alfanumerycznych i znaka myślnika
('-') i wszystkie litery muszą być małe. Dla zachowania spójności,
pkgname powinien pasować do nazwy archiwum źródła które pakujesz. Na
przykład, jeśli oprogramowanie jest w foobar-2.5.tar.gz, wartość pkgname
powinna być foobar. Katalog roboczy pliku PKGBUILD powinien także
pasować do pkgname.

> pkgver

Wersja pakiet. Wartość powinna być taka sama jak wersja źródeł
udostępnionych przez autora. Może zawierać litery, cyfry i kropki, ale
nie może zawierać dwukropka. Jeśli autor pakietu używa tego łącznika w
wersji systemu numeracji, zastąp go podkreśleniem. Na przykład, jeśli
wersja jest 0.99-10, powinna zostać zmieniona na 0.99_10. Jeśli zmienna
pkgver jest używana później w PKGBUILD wtedy podkreślenie można łatwo
zastąpić kreską, na przykład:

    source=($pkgname-${pkgver//_/-}.tar.gz)

> pkgrel

Ostateczna wersja pakietu specyficzna dla Arch Linuksa. Ta wartość
umożliwia użytkownikom odróżnić kolejne budowania tej samej wersji
pakietu. Kiedy nowa wersja pakietu jest pierwszą wypuszczana, wtedy
numer wersji zaczyna się od 1. Jeśli poprawki i optymalizacje są robione
dla pliku PKGBUILD, wtedy pakiety będzie re-released i numer wersji
zostanie zwiększony o 1. Kiedy nowa wersja pakietu źródłowego wyjdzie,
numer wersji resetowany jest do 1.

> epoch

An integer value, specific to Arch Linux, representing what 'lifetime'
to compare version numbers against. This value allows overrides of the
normal version comparison rules for packages that have inconsistent
version numbering, require a downgrade, change numbering schemes, etc.
By default, packages are assumed to have an epoch value of 0. Do not use
this unless you know what you are doing.

> pkgdesc

Opis pakietu. Opis powinien zawierać około 80 znaków lub mniej i nie
powinien zawierać nazwy pakietu. Dla przykładu, "Nedit jest edytorem
tekstu dla X11" powinien zostać zmieniony na "Edytor tekstu dla X11".

Note:Nie przestrzegaj tej zasady bezmyślnie kiedy wysyłasz pakiety do
AUR. Jeśli nazwa pakietu różni się od nazwy aplikacji z jakiś powodów,
dołączenie pełnej nazwy do opisu może być jedyną drogą do zapewnienia
aby pakiet został znaleziony podczas wyszukiwania.

> arch

Tablica architektur znanych plikowi PKGBUILD do zbudowania i pracowania
na nich. Aktualnie, powinna zawierać i686 i/lub x86_64,
arch=('i686' 'x86_64'). Wartość any może być użyta dla pakietów
niezależnych-architekturowo.

Dostęp do architektury masz przez zmienną $CARCH podczas budowania a
nawet przy definiowaniu zmiennych. Zobacz także FS#16352. Na przykład:

    depends=(foobar)
    if test "$CARCH" == x86_64; then
      depends=("${depends[@]}" lib32-glibc)
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

An array of files to be backed up as file.pacsave when the package is
removed. This is commonly used for packages placing configuration files
in /etc. The file paths in this array should be relative paths (e.g.
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
quickly and easily using the command makepkg -g in the directory that
contains the PKGBUILD file. Note that the MD5 algorithm is known to have
weaknesses, so you should consider using a stronger alternative.

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
"https://wiki.archlinux.org/index.php?title=Dracorp/sandbox/PKGBUILD&oldid=239543"

Categories:

-   Arch Linux (Polski)
-   Rozwój pakietów (Polski)
