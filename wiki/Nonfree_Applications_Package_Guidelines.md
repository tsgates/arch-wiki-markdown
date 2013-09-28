Nonfree Applications Package Guidelines
=======================================

Package creation guidelines

* * * * *

CLR – Cross – Eclipse – Free Pascal – GNOME – Go – Haskell – Java – KDE
– Kernel – Lisp – MinGW – Nonfree – OCaml – Perl – Python – Ruby – VCS –
Web – Wine

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: cover about      
                           encrypting archives,     
                           symlinking etc.          
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

For many applications (most of which are Windows ones) there are neither
sources nor tarballs available. Many of such applications can not be
freely distributed because of license restrictions and/or lack of legal
ways to obtain installer for no fee. Such software obviously can not be
included into the official repositories but due to nature of AUR it is
still possible to privately build packages for it, manageable with
pacman.

Note:All information here is package-agnostic, for information specific
to the most typical nonfree software see Wine PKGBUILD guidelines.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Rationale                                                          |
| -   2 Common rules                                                       |
|     -   2.1 Avoid nonfree software when possible                         |
|     -   2.2 Use open source variants where possible                      |
|     -   2.3 Keep it simple                                               |
|                                                                          |
| -   3 Package Naming                                                     |
| -   4 File placement                                                     |
| -   5 Missing files                                                      |
| -   6 Advanced topics                                                    |
|     -   6.1 Custom DLAGENTS                                              |
|     -   6.2 Unpacking                                                    |
|     -   6.3 Getting icons for .desktop files                             |
+--------------------------------------------------------------------------+

Rationale
---------

There are multiple reasons for packaging even non-packageable software:

-   Simplification of installation/removal process

This is applicable even to the simplest of apps, which consist of a
single script to be installed into /usr/bin. Instead of issuing:

    $ chmod +x filename

    # cp filename /usr/bin/

you can type just

    # makepkg -i

Most non-free applications are obviously much more complicated, but the
burden of downloading an archive/installer from a homepage (often full
of advertising), unpacking/decrypting it, hand-writing stereotypical
launcher scripts and doing other similar tasks can be effectively
lightened by a well-written packaging script.

-   Utilizing pacman capabilities

The ability to track state, perform automatic updates of any installed
piece of software, determine ownership of every single file, and store
compressed packages in a well-organized cache is what makes GNU/Linux
distributions so powerful.

-   Sharing code and knowledge

It is simpler to apply tweaks, fix bugs and seek/provide help in a
single public place like AUR versus submitting patches to proprietary
developers who may have ceased support or asking vague questions on
general purpose forums.

Common rules
------------

> Avoid nonfree software when possible

Yes, it's better to leave this guide and spend some time searching (or
maybe even creating) alternatives to an application you wanted to
package because:

1.  Packaging nonfree software is often messy and often against The Arch
    Way
2.  It is better to support software that is owned by us all than
    software that is owned by a company
3.  It is better to support software that is actively maintained
4.  It is better to support software that can be fixed if just one
    person out of millions care enough

> Use open source variants where possible

Many commercial games (some are listed in this Wiki) have open source
engines and many old games can be played with emulators such as ScummVM.
Using open source engines together with the original game assets gives
users access to bug fixes and eliminates several issues caused by binary
packages.

> Keep it simple

If the packaging of some program requires more effort and hacks than
buying and using the original version - do the simplest thing, it is
Arch!

Package Naming
--------------

Before choosing a name on your own, search in AUR for existing versions
of the software you want to package. Try to use established naming
conversion (e.g. do not create something like gish-hb when there are
already aquaria-hib-hg, penumbra-overture-hib and uplink-hib). Use
suffix -bin always unless you are sure there will never be source-based
package – its creator would have to ask you (or in worst case TUs) to
orphan existing package for him and you both will end up with PKGBUILDs
cluttered with additional replaces and conflicts.

File placement
--------------

Again, analyze existing packages (if present) and decide whether or not
you want to conflict with them. Do not place things under /opt unless
you want to use some ugly hacks like giving ownership root:games to the
package directory (so users in group games running the game can write
files in the game's own folder).

Missing files
-------------

For most commercial games there is no way to (legally) download game
files, which is the preferable way to get them for normal packages. Even
when it is possible to download files after providing a password (like
with all Humble Indie Bundle games) asking user for this password and
downloading somewhere in build function is not recommended for a variety
of reasons (for example, the user may have no Internet access but have
all files downloaded and stored locally). The following options should
be considered:

-   There is only one way to obtain files

-   Software is distributed in archive/installer

Add the required file to sources array:

    sources=(... "originalname::file://originalname")

This way the link to file in AUR web interface will look different from
names of files included in source tarball.

Add following comment on package page:

    Need archive/installer to work.

and explain the details in PKGBUILD source.

-   Software is distributed on compact-disk

Add installer script and .install file to package contents, like in
package tsukihime-en.

-   There are several ways to obtain files

Copying files from disk / downloading from Net / getting from archive
during build phase may look like a good idea but it is not recommended
because it limits the user's possibilities and makes package
installation interactive (which is generally discouraged and just
annoying). Again, a good installer script and .install file can work
instead.

Few examples of various strategies for obtaining files required for
package:

-   worldofgoo – dependency on user-provided file
-   umineko-en – combining files from freely available patch and
    user-provided compact-disk
-   worldofgoo-demo – autonomic fetching installer during build phase
-   ut2004-anthology – searching for disk via mountpoints

Advanced topics
---------------

> Custom DLAGENTS

Some software authors aggressively protect their software from automatic
downloading: ban certain "User-Agent" strings, create temporary links to
files etc. You can still conveniently download this files by using
DLAGENTS variable in PKGBUILD (see man makepkg.conf). This is used by
some packages in official repositories, for example ttf-baekmuk.

Following one-liner disguises curl as the most popular browser among
novice computer users:

    DLAGENTS=("http::/usr/bin/curl -A 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1)' -fLC - --retry 3 --retry-delay 3 -o %o %u")

And following allows to extract temporary link to file from download
page:

    DLAGENTS=("http::/usr/bin/wget -r -np -nd -H %u")

> Unpacking

Many proprietary programs are shipped in nasty installers which
sometimes do not even run in Wine. Following tools may be of some help:

-   unzip and unrar unpack executable SFX archives, based on this
    formats
-   cabextract can unpack most .cab files (including ones with .exe
    extension)
-   unshield can extract CAB files from InstallShield installers
-   7z unpacks not only many archive formats but also NSIS-based .exe
    installers
    -   it even can extract single sections from common PE (.exe & .dll)
        files!

-   upx is sometimes used to encrypt above-listed executables and can be
    used for decryption as well
-   innoextract can unpack .exe installers created with Inno Setup (used
    for example by GOG.com games)

In order to determine exact type of file run file file_of_unknown_type.

> Getting icons for .desktop files

Proprietary software often have no separate icon files, so there is
nothing to use in .desktop file creation. Happily .ico files can be
easily extracted from executables with programs from icoutils package.
You can even do it on fly during build phase (example can be found in
sugarsdelight).

Retrieved from
"https://wiki.archlinux.org/index.php?title=Nonfree_Applications_Package_Guidelines&oldid=247940"

Category:

-   Package development
