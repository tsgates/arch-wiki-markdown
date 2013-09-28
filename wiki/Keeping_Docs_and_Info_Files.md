Keeping Docs and Info Files
===========================

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Aim of the Howto                                                   |
| -   2 How to rebuild /usr/share/info/dir ?                               |
| -   3 Where Are My Info files?                                           |
| -   4 I want my Info files!                                              |
| -   5 ABS                                                                |
|     -   5.1 Installing ABS                                               |
|                                                                          |
| -   6 Building the Packages                                              |
|     -   6.1 Global Change                                                |
|         -   6.1.1 Makepkg                                                |
|                                                                          |
| -   7 Changing a Single Package                                          |
| -   8 Where to from here?                                                |
+--------------------------------------------------------------------------+

Aim of the Howto
================

This is a short Howto aimed at those users who may want to keep the
documentation that comes with their packages. Please note, this Howto
requires an understanding of the Arch Build System, ABS and the makepkg
command. Please visit the relevant ArchWiki page and familiarise
yourself with these before continuing. For those of you who just want to
get Info files installed on a required package a short ABS walk-through
is provided later on.

The Howto will be split into two sections. The first will inform you how
to keep documentation for all your custom built packages, the second is
aimed at those who wish to have documents for only some of their
packages.

How to rebuild /usr/share/info/dir ?
====================================

        for j in $( { for i in /usr/share/info/*.info /usr/share/info/*.gz; do echo "$i" | sed -r 's/-([0-9]+)\.gz$/\.gz/g'; done; } | uniq) ; do install-info "$j" /usr/share/info/dir; done

Where Are My Info files?
========================

The Arch Way is one of simplicity. In this regard many 'Archers' find
the extra documentation bundled with various programs to be unnecessary.
It is for this reason that the binary packages downloaded from the
repositories come with most, if not all, documents removed. This helps
to reduce bloat on the system, as befitting the Arch philosophy.

I want my Info files!
=====================

Some programs, however do come with useful information. Gnu Emacs, for
example, contains useful Info pages, that can make using this hard to
learn text editor that little bit easier. So, taking Emacs as an example
this Howto will now guide you through the simple steps required to build
your own package using the makepkg utility and install it on your
machine.

ABS
===

The Arch Build System (ABS) is a way of building your own packages and
installing them on your machine. A full introduction is beyond the scope
of this Howto so please visit the ABS Wiki page to gain more details.

Installing ABS
--------------

For those of you who may not have an ABS Tree currently set up on your
system here's a quick walkthrough.

Open a terminal, then run as root:

        pacman -S abs

then:

        abs

Building the ABS tree may take a while, depending on your hardware, so
please be patient. When the ABS directory tree has been finalised
continue with the next steps.

Building the Packages
=====================

At this point the tutorial, as stated earlier deviates into two parts.
The first shows you how to change the global settings, allowing all
packages built with ABS to be installed with documentation. The second
is aimed at those who wish only a select few of their ABS built packages
to be built in this way.

Global Change
-------------

> Makepkg

We will now use the makepkg command to build the Emacs package with info
files. Of course you can substitute Emacs for whichever package you
require the documentation for. Note, as with ABS this Howto advises you
to have a basic understanding of Makepkg, information for which can be
obtained through the man pages or the makepkg ArchWiki page.

In your terminal as root using a text editor (in this case vi);

        vi /etc/makepkg.conf

Then find the line which reads;

        OPTIONS=(strip !docs libtools emptydirs)

See that exclamation mark before docs? Delete it. Now makepkg will build
Emacs (and all subsequent packages with documentation. Save the file.

Next, locate the PKGBUILD of your required package. In this case
/var/abs/local/extras/editors/emacs/PKGBUILD and copy it to a ~/build
directory.

As normal user;

       mkdir ~/build
       cp /var/abs/extras/editors/emacs/PKGBUILD ~/build
       cd ~/build

        makepkg emacs

If all is well Makepkg will now proceed with the build. Please note that
both Makepkg and Emacs may require the installation of specific packages
before it builds. (This may also be the case for your chosen package).
This will lead to an error and the package creation will abort. If this
happens simply install the required packages using Pacman and then redo
the above command.

as root;

        pacman -U emacs*.pkg.tar.gz

The normally deleted Docs and Info should now be at your disposal. Go on
have a look! Read on to find out how to change just one individual
package.

Changing a Single Package
=========================

Locate the PKGBUILD of your required package. In this case
/var/abs/local/extras/editors/emacs/PKGBUILD and copy it to a ~/build
directory.

As normal user;

       mkdir ~/build
       cp /var/abs/extras/editors/emacs/PKGBUILD ~/build
       cd ~/build

Next we need to edit the PKGBUILD. Using your favourite text editor;

       vi PKGBUILD

If you've never viewed a PKGBUILD before it may seem a bit confusing,
you are advised to visit Creating Packages to gain a better insight.

The line we need to add is;

       Options=('docs')

NB For simplicity sake add the line after the md5sums line.

It maybe possible that you can already see this line, perhaps with the
doc option or others, if this is the case simply leave the PKGBUILD as
is or append the 'doc' option, leaving a space between it and other
options. For example.

       Options=('strip' 'docs')

Save the file then;

       makepkg emacs

If all is well Makepkg will now proceed with the build. Please note that
both Makepkg and Emacs may require the installation of specific packages
before it builds. (This may also be the case for your chosen package).
This will lead to an error and the package creation will abort. If this
happens simply install the required packages using Pacman and then redo
the above command.

as root;

        pacman -U emacs*.pkg.tar.gz

The package, and only this package will now have the required
documentation.

Where to from here?
===================

There are a variety of other things that you can do to make the process
of building Packages with Docs a little easier. What happens for example
if Pacman updates your package with a new binary? Your installed info
pages disappear! However using the srcpac wrapper, for Pacman, to build
your packages will allow you to upgrade through the above process of
Makepkg, leaving your info files intact. Srcpac can be downloaded
through pacman and does the same job, with a few added extras. See the
man pages for details.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Keeping_Docs_and_Info_Files&oldid=205978"

Category:

-   Package management
