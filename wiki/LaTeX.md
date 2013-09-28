LaTeX
=====

Summary

Implementations of LaTeX in Arch Linux.

Related

TeX Live

TeX Live FAQ

TeX Live and CJK

LaTeX is a popular markup language and document preparation system,
often used in the sciences. The current implementation in Arch Linux is
TeX Live. See TeX Live for how to install and config it.

Editors and environments
------------------------

While LaTeX can be written in a simple text editor, many people wish to
edit LaTeX source in a specialized environment. The following editors,
which use various toolkits, are all available in the official
repositories and can be installed with pacman.

GTK+

-   gedit — Supports LaTeX syntax highlighting and also (via gedit-latex
    plugin) code-completion, compiling LaTeX documents and managing
    BibTeX bibliographies, it is included in gnome-extra.

http://www.gnome.org/ || Gedit

-   Winefish — A very lightweight LaTeX editing suite. It supports
    highlighting and code completion, compile-from-editor, among other
    things.

http://developer.berlios.de/projects/winefish/ || winefish

-   geany — An IDE that includes LaTeX syntax highlighting, building,
    and shows a list of environments/sections/labels in the sidebar.

http://www.geany.org/ || Geany

-   gummi — Lightweight LaTeX editor. It features a continuous preview
    mode, integrated BibTeX support, extendable snippet interface and
    multi-document support.

http://dev.midnightcoding.org/projects/gummi/ || gummi

KDE

-   Kile — A user friendly TeX/LaTeX front-end for KDE

http://kile.sourceforge.net/ || kile

-   Ktikz — GUI making diagrams with TikZ/PGF easier.

http://www.hackenberger.at/blog/ktikz-editor-for-the-tikz-language/ ||
ktikz

Other

-   Emacs — Emacs (AucTeX), together with auctex and RefTeX, provides a
    complete, powerful, and customizable LaTeX environment.

https://www.gnu.org/software/emacs/ || emacs

-   Emacs — Emacs (WhizzyTeX), together with whizzytex, provides a nice
    live preview editor for Emacs.

http://www.emacswiki.org/WhizzyTeX/ || emacs

-   Vim — Vim together with vim-latexsuite-git can be used as
    customizable LaTeX environment.

http://www.vim.org || vim

-   TeXMaker — A free, modern and cross-platform LaTeX editor for Linux,
    Mac OS X, and Windows systems that integrates many tools needed to
    develop documents with LaTeX, in just one application. Also check
    out TeXWorks.

http://www.xm1math.net/texmaker/ || texmaker

-   LyX — An advanced open-source WYSIWYM document processor.

http://www.lyx.org/ || lyx

-   JabRef — Java GUI frontend for managing BibTeX and other
    bibliographies. If you have issues with certain features not working
    in JabRef (like the "Find" command), it may be an incompatibility
    with Java 7. Try installing Java 6 (i.e. openjdk6). This will
    uninstall jdk7-openjdk and jre7-openjdk, and all features in JabRef
    should now work.

http://jabref.sourceforge.net/index.php || jabref-git

-   Zotero — This is a free, easy-to-use tool to help you collect,
    organize, cite, and share your research sources. There is a
    stand-alone version and a Firefox add-on available.

http://www.zotero.org/support/3.0/ || zotero

-   TeXmacs — WYSIWYW (what you see is what you want) editing platform
    with special features for scientists.

http://www.texmacs.org || texmacs

See the Wikipedia article on this subject for more information:
Comparison of TeX editors

Updating babelbib language definitions
--------------------------------------

If you have the very specific problem of babelbib not having the latest
language definitions that you need, and you don't want to recompile
everything, you can get them manually from
http://www.tug.org/texlive/devsrc/Master/texmf-dist/tex/latex/babelbib/
and put them in /usr/share/texmf-dist/tex/latex/babelbib/. For example:

    # cd /usr/share/texmf-dist/tex/latex/babelbib/ 
    # wget http://www.tug.org/texlive/devsrc/Master/texmf-dist/tex/latex/babelbib/romanian.bdf
    # wget [...all-other-language-files...]
    # wget http://www.tug.org/texlive/devsrc/Master/texmf-dist/tex/latex/babelbib/babelbib.sty

Afterwards, you need to run texhash to update the TeX database:

    # texhash

Retrieved from
"https://wiki.archlinux.org/index.php?title=LaTeX&oldid=254881"

Category:

-   TeX
