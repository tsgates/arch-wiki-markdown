Step By Step Debugging Guide
============================

Related articles

-   General Troubleshooting
-   Reporting Bug Guidelines
-   Debug - Getting Traces
-   Boot Debugging

This page is mainly about how to gather more information in connection
with bug reports. Even though the word "debug" is used, it's not
intended as a guide for how to debug programs while developing.

Contents
--------

-   1 When an application fails
    -   1.1 Run it from the commandline
    -   1.2 Check if the application segfaults
-   2 How to investigate a segfault
    -   2.1 Technique #1 - gdb
    -   2.2 Technique #2 - even better gdb output
    -   2.3 Technique #3 - valgrind
-   3 How to investigate missing files or libraries
    -   3.1 Technique #1 - strace
    -   3.2 Technique #2 - LD_DEBUG
    -   3.3 Technique #3 - readelf
-   4 If it's not written in C or C++, but perhaps in Python
-   5 Finally - report the bug
-   6 See also

When an application fails
-------------------------

> Run it from the commandline

If an application suddenly crashes, try running it from a terminal
emulator like gnome-terminal or urxvt. Try typing in the name of the
application in lowercase letters. If you don't know the name of the
executable, only the name of the package, the following command can be
useful to find the name of the executable. Replace "packagename" with
the name of the package:

    for f in `pacman -Ql packagename | grep "/bin/" | cut -d" " -f2`; do file $f 2>/dev/null | grep -q executable && basename $f; done

> Check if the application segfaults

If you see the word "segfault" or the phrase "segmentation fault", see
if there is a file named "core" as well.

    ls core

If there is, the application has segfaulted. The "core" file can, if the
application is compiled in a debug-friendly way, be used to find out
where things went wrong. Sometimes the core file ends up in one of the
directories the application has visited instead of the current
directory.

If you can't find the "core" file, it may be the case that core dumping
is disabled by default. Simply do ulimit -c unlimited before executing
the faulty program, you may also add this into your .bashrc to aid in
future debugging.

How to investigate a segfault
-----------------------------

There are a couple of techniques that can be used to figure out what
went wrong. Put your detective hat on. 🔎

> Technique #1 - gdb

gdb is an ancient and well tested application for debugging
applications. Try running the application with gdb (replace "appname"
with the name of your executable):

    gdb appname
    r
    (wait for segfault)
    bt full

Now post the output to one of the many pastebin sites on the web and
include the URL in your bug report (if end up filing one).

> Technique #2 - even better gdb output

First recompile the application in question with the -g, -O0 and
-fbuiltin flags. Make sure "!strip" is in the options array in the
PKGBUILD, then install the package and try running it again with gdb,
like above.

This is how the options line can look:

     options=('!strip')

One way of enabling -g, -O0 and -fbuiltin is to put these two lines at
the very beginning of the build() function in the relevant PKGBUILD:

    export CFLAGS="$CFLAGS -O0 -fbuiltin -g"
    export CXXFLAGS="$CXXFLAGS -O0 -fbuiltin -g"

The meaning of the flags is the following: -g enables debug symbols and
-O0 turns off optimizations. (-O2 is the most common optimization level.
(-O3 is usually overkill and -O4 and above behaves exactly like -O3).

If you have a "core" file, it can be used together with gdb to get a
backtrace:

    gdb appname core
    bt full

> Technique #3 - valgrind

Assuming you have an unstripped binary without inlined functions, it's
usually a good idea to also run that program through valgrind. valgrind
is a tool that emulates a CPU and can usually help you show where things
go wrong or provide additional info on top of gdb's output.

If you run

    valgrind appname

it will provide a lot of helpful debug output if there is a crash.
Consider -v and --leak-check=full to get even more info.

Alternatively, you can use

    valgrind --tool=callgrind appname

and run the output through kcachegrind to graphically explore the
functions the program uses. This is especially useful if the program
hangs somewhere as you can see where it spends all that time which makes
it easier to pinpoint the error location.

How to investigate missing files or libraries
---------------------------------------------

> Technique #1 - strace

Strace is great for finding out, in detail, what an application is
actually doing. If an application tries to open a file that just isn't
there, it can be discovered by strace.

For finding which files a program named "appname" tries to open:

    $ strace -eopen appname

Again, save the output, post it to a pastebin site and keep the URL in
handy.

  

Tip:If you wish to grep the output from strace, you can try:
strace -o /dev/stdout appname | grep something

> Technique #2 - LD_DEBUG

Setting LD_DEBUG to "files" is another way to get an overview of which
files an application are looking for. For an application named
"appname":

    LD_DEBUG=files appname > appname.log 2>&1

The output will end up in appname.log.

For more information about this:

    man ld-linux

> Technique #3 - readelf

If you get "no such file or directory" when running an application, try
the following command:

    readelf -a /usr/bin/appname | grep interp

(replace /usr/bin/appname with the location of your executable)

Make sure the interpreter in question (like /lib/ld-linux-x86-64.so.2)
actually exists. Install ld-lsb from AUR if you have to.

If it's not written in C or C++, but perhaps in Python
------------------------------------------------------

Use "file" on the executable to get more information (replace "appname"
with your executable):

    file /usr/bin/appname

If it says "ELF" it's a binary exectuable and is usually written in C or
C++. If it says "Python script" you know you're dealing with an
application written in Python.

If it's a shell script, open up the shell script in a text editor and
see (usually at the bottom of the file) if you can find the name of the
real application (ELF file). You can then temporarily put "gdb" right in
the shellscript, before the name of the executable, for debugging
purposes. See the sections about gdb further up.

For Python applications, the output will often say which file and line
number the crash occured at. If you're proficient with Python, you can
try to fix this and include the fix in the bug report.

Finally - report the bug
------------------------

Please report a bug at https://bugs.archlinux.org and possibly also
directly to the developers of the application in question, then include
a link in the Arch Linux bug report. This helps us all.

However, if you think there's something wrong with the application
itself, and not with how it is packaged, report the bug directly to
upstream (which means the developers of the application). Normally,
software streams from developers, through packagers/maintainers and down
to users. Upstream means the other way, so for this case: directly to
the developers of an application.

See also
--------

-   Gentoo guide for getting useful backtraces

Retrieved from
"https://wiki.archlinux.org/index.php?title=Step_By_Step_Debugging_Guide&oldid=285361"

Category:

-   Development

-   This page was last modified on 30 November 2013, at 08:07.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
