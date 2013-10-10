TeX Live
========

> Summary

Introduce how install and use TeX Live.

> Related

TeX Live FAQ

TeX Live and CJK

LaTeX

TeX Live is an "easy way to get up and running with the TeX document
production system. It provides a comprehensive TeX system with binaries
for most flavors of Unix, including GNU/Linux, and also Windows. It
includes all the major TeX-related programs, macro packages, and fonts
that are free software, including support for many languages around the
world."

For more information see: Category:TeX

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 texlive-most                                                 |
|     -   1.2 texlive-lang                                                 |
|     -   1.3 Alternative: TeX Live network install                        |
|                                                                          |
| -   2 Important information                                              |
|     -   2.1 Paper Size                                                   |
|     -   2.2 Error with "formats not generated" upon update               |
|     -   2.3 Fonts                                                        |
|                                                                          |
| -   3 TeXLive Local Manager                                              |
|     -   3.1 Recent "langukenglish" errors                                |
|                                                                          |
| -   4 Install .sty files                                                 |
|     -   4.1 Manual Installation                                          |
|     -   4.2 Using PKGBUILDs                                              |
+--------------------------------------------------------------------------+

Installation
------------

The TeX Live packages are arranged into two groups in the official
repositories:

-   texlive-most includes TeX Live applications.
-   texlive-lang provides various character sets and non-English
    features.

The essential package texlive-core contains the basic texmf-dist tree,
while texlive-bin contains the binaries, libraries, and the texmf tree.
texlive-core is based on the “medium” install scheme of the upstream
distribution. All other packages are based on the eponymous collections
in TeX Live. To determine which CTAN packages are included in each
package, lookup the files:

     /var/lib/texmf/arch/installedpkgs/<package>_<revnr>.pkgs

> texlive-most

+--------------------------+--------------------------+--------------------------+
| -   texlive-core         | -   texlive-genericextra | -   texlive-pictures     |
| -   texlive-bibtexextra  | -   texlive-htmlxml      | -   texlive-plainextra   |
| -   texlive-fontsextra   | -   texlive-humanities   | -   texlive-pstricks     |
| -   texlive-formatsextra | -   texlive-latexextra   | -   texlive-publishers   |
| -   texlive-games        | -   texlive-music        | -   texlive-science      |
+--------------------------+--------------------------+--------------------------+

> texlive-lang

-   texlive-langcjk
-   texlive-langcyrillic
-   texlive-langgreek
-   texlive-langextra

Note: texlive-langextra replaced the African, Arab, Armenian, Croatian,
Hebrew, Indic, Mongolian, Tibetan and Vietnamese packages.

> Alternative: TeX Live network install

Installing TeX Live manually honors the Arch Way in that it gives you
much more control and lets you understand the process. It's the only way
you can get a full-featured LaTeX distribution under 100 MB that fits
your needs without install a thousand of packages you will never use.

A detailed guide for TeX Live network install can be found on the LaTeX
Wikibook.

Information about making TeX Live network install :
http://tug.org/texlive/doc/texlive-en/texlive-en.html#x1-140003

A discussion of the pros and cons of making the TeX Live network
install.

For all those programs that require texlive to be installed (e.g. kile)
you can use the texlive-dummy package from AUR.

Important information
---------------------

-   The way to handle font mappings for updmap has been improved in
    Sept. 2009, and installation should now be much more reliable than
    in the past. In the meanwhile, if you encounter error messages about
    unavailable map file, simply remove them by hand from the updmap.cfg
    file (ideally using updmap-sys --edit). You can also run
    updmap-sys --syncwithtrees to automatically comment out outdated map
    lines from the config file.

-   The ConTeXt formats (for MKII and MKIV) are not automatically
    generated upon installation. See the ConTeXT wiki for instructions
    on how to do this.

-   The packages containing the documentation and sources are available
    in the [community] repository. You can also consult it online at
    http://tug.org/texlive/Contents/live/doc.html or on CTAN.

-   TeX Live (upstream) now provides a tool for incremental updates of
    CTAN packages. On that basis, we also plan to update our packages on
    a regular basis (we have written tools that almost automate that
    task).

-   Some tools and utilities included in TeX Live rely on ghostscript,
    perl, and ruby.

-   For help and information about TeX Live see:
    http://tug.org/texlive/doc.html and
    http://tug.org/texlive/doc/texlive-en/texlive-en.html

-   System-wide configuration files are under /usr/share/texmf-config.
    User-specific ones should be put under ~/.texlive/texmf-config.
    $TEXMFHOME is ~/texmf and $TEXMFVAR is ~/.texlive/texmf-var.

-   A skeleton of a local texmf tree is at /usr/local/share/texmf: this
    directory is writable for members of the group tex.

> Paper Size

American users are advised to run

    $ texconfig

in order to set the default page size to "Letter", as opposed to A4, the
current default. This command is also capable of changing other useful
settings. Not changing this setting can result in slightly flawed
output, as the right margin will be bigger than the left.

> Error with "formats not generated" upon update

See this bug report. (Note that if you do not use the experimental
engine LuaTeX, you can ignore this.) This situation typically occurs
when the configuration files language.def and/or language.dat for
hyphenation patterns contain references to files from earlier releases
of texlive-core, in particular to the latest experimental hyphenation
patterns for German, whose file name changes frequently. Currently they
should point to dehyph{n,t}-x-2009-06-19.tex.

To solve this, you need to either remove these files:
/usr/share/texmf-config/tex/generic/config/language.{def,dat} or update
them using the newest version under:
/usr/share/texmf/tex/generic/config/language.{def,dat} and then run

    # fmtutil-sys --missing

> Fonts

By default, the fonts that come with the various TeX Live packages are
not automatically available to Fontconfig. If you want to use them with,
say XeTeX or LibreOffice, the easiest approach is to make symlinks as
follows:

     ln -s /usr/share/texmf-dist/fonts/opentype/public/<some_fonts_you_want> ~/.fonts/OTF/ (or TTF or Type1) 

To make them available to fontconfig, run:

     fc-cache ~/.fonts
     mkfontscale ~/.fonts/OTF (or TTF or Type1) 
     mkfontdir ~/.fonts/OTF (or TTF or Type1)

Alternatively, texlive-bin contains the file
/etc/fonts/conf.avail/09-texlive-fonts.conf that contains a list of the
font directories used by TeX Live. You can use this file with:

    # ln -s /etc/fonts/conf.avail/09-texlive-fonts.conf /etc/fonts/conf.d/09-texlive-fonts.conf

And then update fontconfig:

    # fc-cache && mkfontscale && mkfontdir

Note:This may cause conflicts with XeTeX/XeLaTeX if the same fonts are
(separately) available to both TeX and Fontconfig, i.e. if multiple
copies of the same font are available on the search path.

TeXLive Local Manager
---------------------

The TeXLive Local Manager is a utility provided by Firmicus which allows
to conveniently manage a TeX Live installation on Arch Linux. See
texlive-localmanager-git in the AUR.

    Usage: tllocalmgr  
           tllocalmgr [options] [command] [args]

           Running tllocalmgr alone starts the TeXLive local manager shell 
           for Arch Linux. This shell is capable of command-line completion!
           There you can look at the available updates with the command 'status' 
           and you can install individual CTAN packages using 'install' or 'update'
           under $TEXMFLOCAL. This is done by creating a package texlive-local-<pkg>
           and installing it with pacman. Note that this won’t interfere with your 
           standard texlive installation, but files under $TEXMFLOCAL will take
           precedence.  
           
           Here are the commands available in the shell:

    Commands:       
                  status   --   Current status of TeXLive installation
               shortinfo * --   Print a one-liner description of CTAN packages
                    info * --   Print info on CTAN packages
                  update * --   Locally update CTAN packages
                 install * --   Locally install new CTAN packages
              installdoc * --   Locally install documentation of CTAN packages
              installsrc * --   Locally install sources of CTAN packages
               listfiles * --   List all files in CTAN packages
                  search * --   Search info on CTAN packages
             searchfiles * --   Search for files in CTAN packages
                 texhash   --   Refresh the TeX file database
                   clean   --   Clean local build tree
                    help   --   Print helpful information
                    quit   --   Quit tllocalmgr

            The commands followed by * take one of more package names as arguments.
            Note that these can be completed automatically by pressing TAB.

            You can also run tllocalmgr as a standard command-line program, with
            one of the above commands as argument, then the corresponding task will
            be performed and the program will exit (except when the command is 'status').

            tllocalmgr accepts the following options:

    Options:     --help          Shows this help
                 --version       Show the version number
                 --forceupdate   Force updating the TeXLive database
                 --skipupdate    Skip updating the TeXLive database
                 --localsearch   Search only installed packages
                 --location      #TODO?
                 --mirror        CTAN mirror to use (default is mirror.ctan.org)
                 --nocolor       #TODO

> Recent "langukenglish" errors

For issues involving this error when trying to run tllocalmgr commands,

    Can't get object for collection-langukenglish at /usr/bin/tllocalmgr line 103

See ary0's solution at the AUR: texlive-localmanager. In summary, edit
/usr/share/texmf-var/arch/tlpkg/TeXLive/Arch.pm and remove
"langukenglish" from the section of the file shown here:

    my @core_colls =
    qw/ basic context genericrecommended fontsrecommended langczechslovak
    langdutch langfrench langgerman langitalian langpolish langportuguese
    langspanish **langukenglish** latex latexrecommended luatex mathextra metapost
    texinfo xetex /;

Install .sty files
------------------

TeX Live (and teTeX) uses its own directory indexes (files named ls-R),
and you need to refresh them after you copy something into one of the
TeX trees. Or TeX can not see them. Magic command:

    mktexlsr

or

    texhash

or

    texconfig[-sys] rehash

A command line program to search through these indexes is

    kpsewhich

Hence you can check that TeX can find a particular file by running

    kpsewhich <filename>

The output should be full path to that file.

> Manual Installation

Normally, new .sty files go in
/usr/share/texmf-dist/tex/latex/<package name>/*. Create this directory
if you do not have it. This directory will automatically be searched
when *tex is executed. Further discussion can be found here:
https://bbs.archlinux.org/viewtopic.php?id=85757

> Using PKGBUILDs

To install a LaTeX package on a global level, you should use a PKGBUILD
for the sake of simplifying maintenance. Look at this example.

    # Original autor: Martin Kumm <pluto@ls68.de> 
    # Maintainer: masterkorp  <masterkorp@gmail.com>    irc: masterkorp at freenode.org
    # Last edited: 2nd April 2011

    pkgname=texlive-gantt
    pkgver=1.3
    pkgrel=1
    license=('GPL')
    depends=('texlive-core')
    pkgdesc="A LaTeX package for drawing gantt plots using pgf/tikz"
    url="http://www.martin-kumm.de/tex_gantt_package.php"
    arch=('any')
    install=texlive-gantt.install
    source=(http://www.martin-kumm.de/tex/gantt.sty)
    md5sums=('e942191eb0024633155aa3188b4bbc06')

    build()
    {
      mkdir -p $pkgdir/usr/share/texmf/tex/latex/gantt
      cp $srcdir/gantt.sty $pkgdir/usr/share/texmf/tex/latex/gantt
    }

And the .install file:

    post_install() {
      post_remove
      echo "The file was installed in:"
      kpsewhich gantt.sty
    }

    post_upgrade() {
      post_install
    }

    post_remove() {
      echo "Upgrading package database..."
      mktexlsr
    }

From the texlive-gantt package in the AUR.

Retrieved from
"https://wiki.archlinux.org/index.php?title=TeX_Live&oldid=251936"

Category:

-   TeX
