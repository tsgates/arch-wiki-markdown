Patching in ABS
===============

There have been quite a few questions about creating and/or applying
patches to packages when using ABS. This document outlines the steps and
options required to do these tasks.
http://www.kegel.com/academy/opensource.html also has some useful
information on patching files.

Creating patches
----------------

If you are attempting to use a patch that you got from elsewhere (ie:
you downloaded a patch to the Linux kernel), you can skip to the next
section. However, if you need to edit source code, make files,
configuration files, etc, you will need to be able to create a patch.

Note: If you need only to change one or two lines in a file (ie: a
Makefile), you may be better off investigating the properties of sed
instead.

Creating a patch for a package involves creating two copies of the
package, editing the new copy, and creating a unified diff between the
two files. When creating an Arch Linux package, this can be done as
follows:

1.  Add the download source of the file to the source array of the
    PKGBUILD you are creating. Of course, if you are altering an
    existing PKGBUILD, this step is taken care of.
2.  Create a dummy (empty, or containing a single echo command is good)
    build() function. If you are altering an existing PKGBUILD, you
    should comment out most of the lines of the build function, as
    you're likely going to be running makepkg several times, and you
    won't want to spend a lot of time waiting for a broken package to
    build.
3.  Run makepkg -o This will download the source files you need to edit
    into the src directory.
4.  Change to the src directory. In standard cases, there will be a
    directory containing a bunch of files that were unzipped or untarred
    from a downloaded archive there (Sometimes it's a single file, but
    diffs work on multiple files too!) You should make two copies of
    these directories. One is a pristine copy that makepkg won't be
    allowed to manipulate, and one will be the new copy that you will
    create a patch from. You can name the two copies package.pristine
    and package.new or something similar.
5.  Change into the package.new directory. Edit whichever files need to
    be edited. The changes needed depend on what the patch has to do; it
    might correct a Makefile paths, it may have to correct source errors
    (for example, to agree with gcc 3.4), and so on. You can also edit
    files in subfolders of the package.new directory, of course. Do not
    issue any commands that will inadvertently create a bunch of files
    in the package.new directory; ie: do not try to compile the program
    to make sure your changes work. The problem is that all the new
    files will show up in the patch, and you do not want that. Instead,
    apply the patch to another copy of the directory (not the pristine
    directory), either manually with the patch command, or in the
    PKGBUILD (described below) and test the changes from there.
6.  Change back to the src directory.
7.  Run diff -aur package.pristine package.new This will output all the
    changes you made in unified diff format. You can scan these to make
    sure the patch is good.
8.  Run diff -aur package.pristine package.new > package.patch to
    capture all the changes in a file named package.patch. This is the
    file that will be used by patch. You may now apply the changes to a
    copy of the original directory and make sure they are working
    properly. You should also check to ensure that the patch does not
    contain any extraneous details. For example, you do not want the
    patch to convert all tabs in the files you edited to spaces because
    your text editor did that behind your back. You can edit the patch
    either using a text editor, or to be safer (and not accidentally
    introduce errors into the diff file), edit the original files and
    create the patch afresh.

Applying patches
----------------

This section outlines how to apply patches you created or downloaded
from the Internet from within a PKGBUILD's build() function. Follow
these steps:

1.  Add an entry to the source array of the PKGBUILD for the patch file,
    separated from the original source url by a space. If the file is
    available online, you can provide the full URL and it will
    automatically be downloaded and placed in the src directory. If it
    is a patch you created yourself, or is otherwise not available, you
    should place the patch file in the same directory as the PKGBUILD
    file, and just add the name of the file to the source array so that
    it is copied into the src directory. If you redistribute the
    PKGBUILD, you should, of course, include the patch with the
    PKGBUILD.
2.  Then use updpkgsums to update the md5sums array. Or manually add an
    entry to the md5sums array; you can generate sum of your patch using
    md5sum tool.
3.  Create the build() function in the PKGBUILD. In most cases you will
    want to apply the patch first thing in the function, but you will
    know best where the patch lines need to be applied.
4.  The first step is to change into the directory that needs to be
    patched (in the build() function, not on your terminal! You want to
    automate the process of applying the patch). You can do this with
    something like cd $srcdir/$pkgname-$pkgver or something similar.
    $pkgname-$pkgver is often the name of a directory created by
    untarring a downloaded source file, but not in all cases.
5.  Now you simply need to apply the patch from within this directory.
    This is very simply done by adding

    patch -p1 -i $srcdir/pkgname.patch 

to your build() function, changing pkgname.patch to the name of the file
containing the diff (the file that was automatically copied into your
src directory because it was in the source array of the PKGBUILD file).

An example build array with patch function:

    build() {
     cd "${srcdir}"/${pkgname}-${pkgver}
     patch -Np1 -i ../eject.patch
     ./configure --prefix=/usr --sysconfdir=/etc --libexecdir=/usr/lib/xfce4 \
       --localstatedir=/var --disable-static \
       --enable-mcs-plugin --enable-python
     make
    }

Run makepkg (from the terminal now). If all goes well, the patch will be
automatically applied, and your new package will contain whatever
changes were included in the patch. If not, you may have to experiment
with the -p option of patch. read man patch for more information.
Basically it works as follows. If the diff file was created to apply
patches to files in myversion/, the diff files will be applied to
myversion/file. You are running it from within the yourversion/
directory (because you cd'd into that directory in the PKGBUILD), so
when patch applies the file, you want it to apply it to the file file,
taking off the myversion/ part. -p1 does this, by removing one directory
from the path. However, if the developer patched in myfiles/myversion,
you need to remove two directories, so you use -p2.

If you do not apply a -p option, it will take off all directory
structure. This is ok if all the files are in the base directory, but if
the patch was created on myversion/ and one of the edited files was
myversion/src/file, and you run the patch without a -p option from
within yourversion, it will try to patch a file named yourversion/file.

Most developers create patches from the parent directory of the
directory that is being patched, so -p1 will usually be right.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Patching_in_ABS&oldid=286463"

Category:

-   Package management

-   This page was last modified on 6 December 2013, at 10:21.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
