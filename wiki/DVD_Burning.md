DVD Burning
===========

> Summary

An overview of DVD writing tools and methods.

> Series

DVD Playing

DVD Ripping

DVD Burning

Related articles

CD Burning Tips

Video2dvdiso

Writing (or "burning") DVDs requires a different approach than burning
CDs. DVDs offer much higher capacities, and the standard CD writing
tools will not suffice.

This HOWTO covers a narrow scope for now: writing data onto DVDs using
the command line.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Required packages                                                  |
| -   2 Procedure                                                          |
|     -   2.1 Overview                                                     |
|     -   2.2 Example                                                      |
|                                                                          |
| -   3 Re-writable DVDs                                                   |
+--------------------------------------------------------------------------+

Required packages
-----------------

1.  You still need the standard CD writing tools known as cdrtools
    (which can be replaced by cdrkit, if desired).
2.  You also need the new DVD writing tools known as dvd+rw-tools found
    in the official repositories.

Note:Do not install the package known as dvdrtools. It conflicts with
cdrtools, and dvd+rw-tools is the superior DVD writing package.

Note:cdrtools provides all the functionality of dvd+rw-tools, as
growisofs depends on mkisofs. Also the development of dvd+rw-tools seems
to be stalled for the past 5 years (the last release was in 2008)

Tip:If you wish to use a graphical front-end, install k3b or brasero,
and you need to read no further.

Procedure
---------

This HOWTO will use the command growisofs from the dvd+rw-tools package.
If you have ever written CDs from the command line before, you will know
the process of first creating an iso9660 file (mkisofs), and then
burning it to CD (cdrecord). growisofs merges these steps, so you do not
need extra storage space for the ISO file anymore. Another advantage is
that multisession writing has been simplified.

> Overview

Essentially, writing a new DVD follows this procedure:

    $ growisofs -Z /dev/sr0 -r -J /path/to/files

where /dev/sr0 is your DVD writer device.

To continue a DVD (write an additional session), you use:

    $ growisofs -M /dev/sr0 -r -J /path/to/files

To burn an ISO image to disc, use:

    $ growisofs -dvd-compat -Z /dev/sr0 /path/to/iso

To create a video DVD, use the following:

    $ growisofs -Z /dev/sr0 -dvd-video /path/to/video

 -Z
    start at the beginning of the DVD using the following device
 -M
    start after the last session on the disc using the following device
 -r
    Rock Ridge support with sane permission settings (recommended,
    extended Unix info)
 -J
    Joliet support (recommended, extended info for Windows NT and
    Windows 95)

Note:-r will choose different permissions than the real ones; to use the
exact permissions use -R instead. See the man page of mkisofs for more
information.

Tip:If you want to copy an existing DVD, one way that works is to make
an ISO using readcd:

    $ readcd -v dev=/dev/sr0 -f image.iso

as per CD Burning Tips, then use the growisofs example above to burn the
ISO to a new blank disc.

> Example

Although the above might suffice for you, some users require extra
settings to successfully write DVDs.

A simple DVD writing template:

    $ growisofs -Z /dev/cdrw -v -l -dry-run -iso-level 3 -R -J -speed=2 -joliet-long -graft-points /files/=/path/to/files/

 -Z
    as seen above, this starts a new DVD; to continue a multisession
    DVD, use -M
 -v
    increase verbosity level (more output)
 -l
    breaks DOS compatibility but allows for longer filenames
 -dry-run
    simulate writing (remove this flag if you are sure that everything
    is set up correctly)
 -iso-level 3
    defines how strict you want to adhere to the iso9660 standard
    (-iso-level 1 is very strict while -iso-level 4 is very loose)
 -R
    see above
 -J
    see above
 -speed=2
    start burning at 2X speed
 -joliet-long
    allows longer Joliet file names

The final part needs more explanation:

    -graft-points /files/=/path/to/files/

This specifies that files will be stored in the subdirectory /files
rather than the DVD root. See the mkisofs manual for details.

Note:growisofs is basically just a front-end to mkisofs. That means that
any option for mkisofs also works with growisofs. See the mkisofs man
page for details.

Re-writable DVDs
----------------

The process for burning re-writable discs is almost the same as for
normal DVDs. However, keep in mind that virgin DVD+RW media needs to be
initially formatted ("blanked") prior to usage. Blanking can be done
using the program dvd+rw-format like this:

    $ dvd+rw-format /dev/cdrw

where /dev/cdrw is your DVD writer device.

Retrieved from
"https://wiki.archlinux.org/index.php?title=DVD_Burning&oldid=256176"

Category:

-   Optical
