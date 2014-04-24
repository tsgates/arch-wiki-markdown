Debug - Getting Traces
======================

Related articles

-   General Troubleshooting
-   Reporting Bug Guidelines
-   Step By Step Debugging Guide

This article aims to help in creating a debugging Arch package and using
it to provide trace and debug information for reporting software bugs to
developers.

Contents
--------

-   1 Discovering name of package(s)
    -   1.1 A few facts of debug messages
    -   1.2 Finding package
-   2 Obtaining PKGBUILD
    -   2.1 Using ABS
    -   2.2 Using AUR
-   3 Compilation settings
    -   3.1 Global settings
    -   3.2 One package settings only
    -   3.3 Qt
    -   3.4 KDE applications
-   4 Building and installing the package
-   5 Getting the trace
-   6 Conclusion
-   7 See also

Discovering name of package(s)
------------------------------

> A few facts of debug messages

When looking at debug message, such as:

    [...]
    Backtrace was generated from '/usr/bin/epiphany'

    (no debugging symbols found)
    Using host libthread_db library "/lib/libthread_db.so.1".
    (no debugging symbols found)
    [Thread debugging using libthread_db enabled]
    [New Thread -1241265952 (LWP 12630)]
    (no debugging symbols found)
    0xb7f25410 in __kernel_vsyscall ()
    #0  0xb7f25410 in __kernel_vsyscall ()
    #1  0xb741b45b in ?? () from /lib/libpthread.so.0
    [...]

you can see ?? at the place where debugging info is missing and also the
name of library or executable which called the function. Similarly, when
the line (no debugging symbols found) appears in a message, it means
that you have to look for a file whose name is stated.

> Finding package

Use Pacman to retrieve name of package:

    # pacman -Qo /lib/libthread_db.so.1
    /lib/libthread_db.so.1 is owned by glibc 2.5-8

We have found that package is called glibc in version 2.5-8. By
repeating this step, we are able to create a list of packages which we
have to compile ourselves to get full stack trace.

Obtaining PKGBUILD
------------------

In order to build a package from source, the PKGBUILD file is required.
The location from which you can obtain PKGBUILDs is, in general:

1.  ABS or
2.  AUR

> Using ABS

If the package is included in Arch's official repos, install ABS, fetch
the source for the package and then build it, e.g.:

    $ ABSROOT=. abs core/glibc
    $ cd core/glibc
    $ makepkg -s

> Using AUR

If the package is included in the AUR, use AUR search page to find the
package. Click on its name and download the Tarball. Use tar to extract
it and then build it:

    $ tar xvzf name_of_tarball.tar.gz
    $ cd name_of_tarball
    $ makepkg -s

Compilation settings
--------------------

At this stage, you can modify the global configuration file of makepkg
if you will be using it only for debug purposes. In other cases, you
should modify package's PKGBUILD file only for each package you would
like to rebuild.

> Global settings

As of pacman 4.1, /etc/makepkg.conf already has debug compilation flags
in DEBUG_CFLAGS and DEBUG_CXXFLAGS. To use them, enable the debug
makepkg option, and disable strip.

Modify makepkg's configuration file ~/.makepkg.conf to contain:

    OPTIONS+=(debug !strip)

These settings will force compilation with debugging information and
will disable the stripping of executables. (If you do not disable strip,
debugging information will be generated anyway, but moved to a separate
foo-debug package.)

> One package settings only

Modify foo's PKGBUILD file to contain the following lines:

    options=(debug !strip)

> Qt

In addition to the previous general settings you should pass
-developer-build option to the configure script in the PKGBUILD. Also
compiling Qt with qtwebkit installed may cause compilation errors. That
is why you would also want to remove qtwebkit package temporarily from
your system. Use the following command in order to ignore any
dependencies on qtwebkit.

    # pacman -Rdd qtwebkit

Do not forget to install qtwebkit after the compilation of Qt is
finished, otherwise the programs that depend on it will not work!

> KDE applications

KDE and software built with KDE technologies normally use CMake for
build. To build this software with debug symbols change the option
-DCMAKE_BUILD_TYPE to Debug.

Building and installing the package
-----------------------------------

Build the package from source using makepkg while in the PKGBUILD's
directory. This could take some time:

    # makepkg

Then install the built package:

    # pacman -U glibc-2.5-8-i686.pkg.tar.gz

Getting the trace
-----------------

The actual backtrace (or stack trace) can now be obtained via e.g. gdb,
the GNU Debugger. Run it either via:

    # gdb /path/to/file

or:

    # gdb
    (gdb) exec /path/to/file

The path is optional, if already set in the $PATH variable.

Then, within gdb, type run followed by any arguments you wish the
program to start with, e.g.:

    (gdb) run --no-daemon --verbose

to start execution of the file. Do whatever necessary to evoke the bug.
For the actual log, type the lines:

    (gdb) set logging file trace.log
    (gdb) set logging on

and then:

    (gdb) bt

to output the trace to trace.log into the directory gdb was started in.
To exit, enter:

    (gdb) set logging off
    (gdb) quit

Tip: To debug an application written in python:

    # gdb /usr/bin/python
    (gdb) run <python application>

You can also debug an already running application, e.g.:

     # gdb --pid=$(pidof firefox)
     (gdb) continue

Conclusion
----------

Use the complete stack trace to inform developers of a bug you have
discovered before. This will be highly appreciated by them and will help
to improve your favorite program.

See also
--------

-   Gentoo Linux Documentation — How to get meaningful backtraces in
    Gentoo

Retrieved from
"https://wiki.archlinux.org/index.php?title=Debug_-_Getting_Traces&oldid=285358"

Category:

-   Package development

-   This page was last modified on 30 November 2013, at 08:04.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
