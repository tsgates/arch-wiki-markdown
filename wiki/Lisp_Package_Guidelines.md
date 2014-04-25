Lisp Package Guidelines
=======================

Package creation guidelines

* * * * *

CLR – Cross – Eclipse – Free Pascal – GNOME – Go – Haskell – Java – KDE
– Kernel – Lisp – MinGW – Nonfree – OCaml – Perl – Python – Ruby – VCS –
Web – Wine

At the moment, there are relatively few Lisp packages available in the
Arch repositories. This means that at some point or another, more will
likely appear. It is useful, therefore, to figure out now, while there
are few packages, how they should be packaged.

Contents
--------

-   1 Directory structure and naming
-   2 ASDF
-   3 Lisp-specific packaging
-   4 Things you, the reader, can do

Directory structure and naming
------------------------------

There is at least one package in the base repository (libgpg-error) that
includes lisp files, which are placed in
/usr/share/common-lisp/source/gpg-error. In keeping with this, other
lisp packages should also place their files in
/usr/share/common-lisp/source/pkgname.

The package directory should be the name of the lisp package, not what
it's called in the Arch repository (or AUR). This applies even to
single-file packages.

For example, a Lisp package called "cl-ppcre" should be called cl-ppcre
in AUR and reside in /usr/share/common-lisp/source/cl-ppcre. A Lisp
package called "alexandria" should be called cl-alexandria in AUR and
reside in /usr/share/common-lisp/source/alexandria.

ASDF
----

Try to avoid the usage of ASDF-Install as a means of installing these
system-wide packages.

ASDF itself may be necessary or helpful as a means of compiling and/or
loading packages. In that case, it is suggested that the directory used
for the central registry (the location of all of the symlinks to *.asd)
be /usr/share/common-lisp/systems/.

However, I have observed problems with doing the compilation with asdf
as a part of the package compilation process. However, it does work
during an install, through use of a package.install file. Such a file
might look like this:

    cl-ppcre.install

    # arg 1:  the new package version
    post_install() {
        echo "---> Compiling lisp files <---"

        clisp --silent -norc -x \
            "(load #p\"/usr/share/common-lisp/source/asdf/asdf\") \
            (pushnew #p\"/usr/share/common-lisp/systems/\" asdf:*central-registry* :test #'equal) \
            (asdf:operate 'asdf:compile-op 'cl-ppcre)"

        echo "---> Done compiling lisp files <---"

        cat << EOM

        To load this library, load asdf and then place the following lines
        in your ~/.clisprc.lisp file:

        (push #p"/usr/share/common-lisp/systems/" asdf:*central-registry*)
        (asdf:operate 'asdf:load-op 'cl-ppcre)
    EOM
    }

    post_upgrade() {
        post_install $1
    }

    pre_remove() {
        rm /usr/share/common-lisp/source/cl-ppcre/{*.fas,*.lib}
    }

    op=$1
    shift

    $op $*

Of course, for this example to work, there needs to be a symlink to
package.asd in the asdf system directory. During package compilation, a
stanza such as this will do the trick...

    pushd ${_lispdir}/systems
    ln -s ../source/cl-ppcre/cl-ppcre.asd .
    ln -s ../source/cl-ppcre/cl-ppcre-test.asd .
    popd

...where $_lispdir is $pkgdir/usr/share/common-lisp. By linking to a
relative, rather than an absolute, path, it's possible to guarantee that
the link will not break post-install.

Lisp-specific packaging
-----------------------

When possible, do not make packages specific to a single lisp
implementation; try to be as cross-platform as the package itself will
allow. If, however, the package is specifically designed for a single
lisp implementation (i.e., the developers haven't gotten around to
adding support for others yet, or the package's purpose is specifically
to provide a capability that is built in to another lisp
implementation), it is appropriate to make your Arch package
lisp-specific.

To avoid making packages implementation-specific, ideally all
implementation packages (SBCL, cmucl, clisp) would be built with the
PKGBUILD field common-lisp. However, that's not the case (and that would
likely cause problems for people who prefer to have multiple lisps at
their fingertips). In the meantime, you could (a) not make your package
depend on *any* lisp and include a statement in the package.install file
telling folks to make sure they have a lisp installed (not ideal), or
(b) Take direction from the sbcl PKGBUILD and include a conditional
statement to figure out which lisp is needed (which is hackish and,
again, far from ideal). Other ideas are welcome.

Also note that if ASDF is needed to install/compile/load the package,
things could potentially get awkward as far as dependencies go, since
SBCL comes with asdf installed, clisp does not but there is an AUR
package, and CMUCL may or may not have it (the author of this doc. knows
next to nothing about CMUCL; sorry).

People currently maintaining lisp-specific packages that do not need to
be lisp-specific should consider doing at least one of the following:

-   Editing their PKGBUILDs to be cross-platform, provided someone else
    is not already maintaining the same package for a different lisp.

-   Offering to take over maintenance or help with maintenance of the
    same package for a different lisp, and then combining them into a
    single package.

-   Offering up their package to the maintainer of a different lisp's
    version of the same package, so as to allow that person to combine
    them into a single package.

(Note that joyfulgirl, the author of this doc., currently maintains
clisp versions of cl-ppcre and of stumpwm; she is open to either giving
up the packages to the maintainers of the SBCL versions or to maintain
the new, cross-platform versions herself if the SBCL-version maintainers
do not want to).

Things you, the reader, can do
------------------------------

-   Maintain lisp packages following these guidelines
-   Update and fix problems with these guidelines
-   Keep up with what's changed here
-   Provide (polite) thoughts, feedback, and suggestions both on this
    document and to people's work.
-   Translate this page and future updates to this page.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Lisp_Package_Guidelines&oldid=301508"

Category:

-   Package development

-   This page was last modified on 24 February 2014, at 11:48.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
