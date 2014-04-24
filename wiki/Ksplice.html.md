Ksplice
=======

Ksplice is an open source extension of the Linux kernel which allows
system administrators to apply security patches to a running kernel
without having to reboot the operating system.

Installation
------------

Install the ksplice-git package from the Arch User Repository.

Usage
-----

First, you need the kernel source tree for the kernel you are currently
running, and some files from the previous kernel build: System.map and
.config.

This example makes use of the --diffext option which creates a patch
based on the differences between the old and the new source files.

Make a ksplice directory in the kernel source tree, copy System.map over
from the previous build, and copy .config into the tree if it is not
already in the source tree:

    # mkdir -p src/ksplice
    # cp System.map src/ksplice
    # cp .config src/

Create a ksplice patch and wait for the kernel to rebuild. All files
that end with new will be compiled into the ksplice patch. C source
files, for example, should end in .cnew as the diffext is appended
directly.

    # ksplice-create --diffext=new src/

Apply the newly generated patch to the running kernel:

    # ksplice-apply ksplice-*.tar.gz

See man pages for ksplice-apply, ksplice-create, ksplice-view, and
ksplice-undo.

See also
--------

-   Ksplice GitHub
-   Ksplice on Wikipedia
-   Offical website of Ksplice Uptrack (proprietary, owned by Oracle)
-   How to use the Ksplice raw utilities

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ksplice&oldid=282372"

Categories:

-   Kernel
-   Security

-   This page was last modified on 11 November 2013, at 18:24.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
