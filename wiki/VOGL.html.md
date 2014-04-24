VOGL
====

Related articles

-   Step By Step Debugging Guide
-   Debug - Getting Traces

VOGL is a tool created by Valve Software and RAD Game Tools for OpenGL
debugging. It is able to capture, replay and inspect OpenGL call
tracefiles.

Contents
--------

-   1 Installation
-   2 Capturing a tracefile
-   3 Trimming the tracefile
-   4 Replaying the tracefile
-   5 Inspecting the tracefile
-   6 Limitations

Installation
------------

The development version vogl-git is available on the AUR.

To capture and debug 32-Bit applications you need libvogltrace32.so,
voglreplay32 and vogleditor32 from bin32-vogl-git.

Capturing a tracefile
---------------------

To obtain a tracefile run the following command.

    $ VOGL_CMD_LINE="--vogl_debug --vogl_dump_stats --vogl_tracefile /tmp/vogltrace.bin" LD_PRELOAD=/usr/lib/libvogltrace64.so <command>

Where <command> is the command to launch your OpenGL application. Your
tracefile will be created in your /tmp directory.

Warning: These files get big very fast! 1-2 minutes result in about 1GB
of captured calls.

VOGL ships with various OpenGL samples that can be used for testing in
its sources. These are not part of the package but they can be built
manually. You can also grab the latest OpenGL samples from the OpenGL
Samples Pack or from OpenGL SuperBible.

Trimming the tracefile
----------------------

If you want to create a smaller tracefile from your captured trace
containing X amount of frames starting at frame Y use:

    $ voglreplay64 original_trace.bin --trim_file trimmed_trace.bin --trim_len X --trim_frame Y

Replaying the tracefile
-----------------------

To replay your trace launch the voglreplayer from within your vogl
directory.

    $ voglreplay64 /tmp/vogltrace.bin

To get verbose debugging output for your trace:

    $ voglreplay64 --debug --verbose vogltrace.bin

To get GL call and extension statistics:

    $ voglreplay64 --info vogltrace.bin

Inspecting the tracefile
------------------------

Launch the vogleditor binary and open the tracefile.bin with the "File -
Open Trace" menu.

    $ vogleditor64

Limitations
-----------

Read about the limitations on this blog post.

Retrieved from
"https://wiki.archlinux.org/index.php?title=VOGL&oldid=305521"

Categories:

-   Development
-   Graphics

-   This page was last modified on 18 March 2014, at 19:14.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
