Core dump
=========

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: Nedd a short     
                           introduction about what  
                           core dump is. (Discuss)  
  ------------------------ ------------------------ ------------------------

Contents
--------

-   1 Making a Core Dump
-   2 Always dump core by default
    -   2.1 Where do they go?
-   3 What do I do with them?

Making a Core Dump
------------------

You can easily generate a core dump of any process. First install gdb:

    $ pacman -Syu gdb

Find the PID of the running process. You might use top or htop or pstree
(psmisc) or ps (procps-ng). For example, to find the PID of firefox:

    $ ps -o pid= -o args= -C firefox
    2071 firefox

Attach to the process:

    $ gdb -p 2071

Then at the (gdb) prompt, type this:

    (gdb) generate-core-file
    Saved corefile core.2071
    (gdb) quit

Now you have a coredump file called core.2071.

Always dump core by default
---------------------------

Global settings are in /etc/security/limits.conf.

Bash settings are in ulimit -c.

> Where do they go?

The kernel.core_pattern sysctl decides where automatic core dumps go:

    $ cat /proc/sys/kernel/core_pattern 
    |/usr/lib/systemd/systemd-coredump %p %u %g %s %t %e

The default set in /usr/lib/sysctl.d/50-coredump.conf sends all core
dumps to journald as part of the system logs.

Note: If you don't have full-disk encryption, this means your program's
memory will be written to raw disk! This is a potential information leak
even if you have encrypted swap.

To retreive a coredump from the journal, see man systemd-coredumpctl

What do I do with them?
-----------------------

todo

Retrieved from
"https://wiki.archlinux.org/index.php?title=Core_dump&oldid=305403"

Category:

-   Development

-   This page was last modified on 18 March 2014, at 05:29.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
