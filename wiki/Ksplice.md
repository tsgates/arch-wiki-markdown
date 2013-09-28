Ksplice
=======

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Ksplice is an open source extension of the Linux kernel which allows
system administrators to apply security patches to a running kernel
without having to reboot the operating system.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
| -   3 Usage                                                              |
| -   4 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Install the ksplice package from the Arch User Repository.

Configuration
-------------

Usage
-----

Note:The following steps have only been tested on a custom Arch kernel.

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: KSplice          
                           currently compiles       
                           outdated kmod utilities  
                           and needs to be patched  
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

First, you need some files from the previous kernel build: System.map
and .config.

This example makes use of the --diffext option which creates a patch
based on the differences between the old and the new source files.

Make a ksplice directory in the kernel source tree:

    # mkdir -p src/ksplice

Copy System.map over from the previous build:

    # cp System.map src/ksplice

Copy .config into the tree if it is not already in the source tree:

    # cp .config src/

Create a ksplice patch and wait for the kernel to rebuild:

    # ksplice-create --diffext=new src/

Apply the newly generated patch to the running kernel:

    # ksplice-apply ksplice-*.tar.gz

See also
--------

-   Offical website of Ksplice
-   Ksplice on Wikipedia
-   How to use the Ksplice raw utilities

Retrieved from
"https://wiki.archlinux.org/index.php?title=Ksplice&oldid=247105"

Categories:

-   Kernel
-   Security
