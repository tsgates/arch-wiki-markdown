Creating packages for Brother drivers
=====================================

Contents
--------

-   1 Really short overview of CUPS
-   2 About Brother drivers
-   3 Preparing PKGBUILD
    -   3.1 Other changes
-   4 Arch64

Really short overview of CUPS
-----------------------------

Basically CUPS needs two things to handle printers properly: a .ppd file
and a filter binary. If you have those two in the right places, then you
must register the printer in CUPS. You can do this in the CUPS web
interface at: http://localhost:631/

or using the command line:

     URL=$(lpinfo -v | grep -i 'Brother')	#  if you have more than one Brother printer, you must be more precise in grep
     lpadmin -p HL2030 -E -v $URL -P

Look at this Samsung driver from the AUR: samsung2010p. It is quite
simple. It does not even have automatic printer registration, but that
AUR package shows exactly what is being referred to.

About Brother drivers
---------------------

Three problems with Brother drivers are:

1.  The cups driver is built on top of the lpr driver.
2.  The cups driver package contains a single installation shell script
    with an embedded *.ppd and a filter. It is executed by rpm during
    installation. It extracts *.ppd and a filter and performs some
    installation procedures in a Red Hat-specific way.
3.  It uses paths that are not compliant to Arch Packaging Standards.

Preparing PKGBUILD
------------------

You can deal with each of the above problems as follows:

1.  Extract the lpr driver's RPM file. You do not have to mimic the lpr
    driver installation procedure in your PKGBUILD because it is not
    needed. The cups driver just needs the files in place.
2.  Extract the cups driver's RPM. There should be single shell script.
    If you look in the patch of my HL-2030 driver (brother-hl2030), you
    can see that I have made three kinds of changes in this script:
    1.  I have changed the paths.
    2.  I have disabled all commands except "cat <<EOF" or "echo > ..."
        or whatever there is that emits *.ppd or filter to separate
        file. It was done by wrapping irrelevant instructions by
        if false; then ... fi.
    3.  I have changed target file names for *.ppd and filter so they
        are emitted to the directory your PKGBUILD is working in
        (relative path not absolute). Note that paths were changed also
        in the source of the embedded filter.

3.  This is optional if you do not care about the Arch Packaging
    Standards. Just change all of the paths. You can use sed on all text
    files unpacked from both the lpr and cups Brother drivers. Look at
    the patch in the brother-hl2030 package to check which files are
    affected.

Effectively after changes described above you will receive a script that
will just emit embedded *.ppd and filter to some known location. All you
need to do is to copy them to the proper CUPS directories in
$stardir/pkg:

     install -m 644 -D ppd_file "$pkgdir/usr/share/cups/model/HL2030.ppd"
     install -m 755 -D wrapper  "$pkgdir/usr/lib/cups/filter/brlpdwrapperHL2030"

Remember also to copy lpr driver files to $pkgdir!

> Other changes

Below are some other changes you may need in your patch.

Change:

     -#PSTOPSFILTER=`which pstops`
     +PSTOPSFILTER='/usr/lib/cups/filter/pstops'

I have just hard-coded the path to "pstops", because it will not be
found by the algorithm that is present there.

There is also this change:

     +[psconvert2]
     +pstops=/usr/lib/cups/filter/pstops

I cannot tell you what it does because I do not remember. Probably I
have encountered some problem during tests and found a solution on the
Internet. You also may need it.

Arch64
------

The driver can be used on Arch64 as long as the 32 bit version of glibc
(lib32-glibc) is installed.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Creating_packages_for_Brother_drivers&oldid=196832"

Category:

-   Printers

-   This page was last modified on 23 April 2012, at 13:27.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
