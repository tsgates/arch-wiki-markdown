Kernel Module Package Guidelines
================================

Package creation guidelines

* * * * *

CLR – Cross – Eclipse – Free Pascal – GNOME – Go – Haskell – Java – KDE
– Kernel – Lisp – MinGW – Nonfree – OCaml – Perl – Python – Ruby – VCS –
Web – Wine

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Package Separation                                                 |
|     -   1.1 Guideline                                                    |
|     -   1.2 Rationale                                                    |
|                                                                          |
| -   2 File Placement                                                     |
+--------------------------------------------------------------------------+

Package Separation
------------------

Packages that contain kernel modules should be treated specially, to
support users who wish to have more than one kernel installed on a
system.

When packaging software containing a kernel module and other non-module
supporting files/utilities, it is important to separate the kernel
modules from the supporting files.

> Guideline

When packaging such software (using the NVIDIA drivers as an example)
the convention is:

-   create an nvidia package containing just the kernel modules built
    for the vanilla kernel
-   create an nvidia-utils package containing the supporting files
-   make sure nvidia depends on nvidia-utils (unless there's a good
    reason not to do so)
-   for another kernel like kernel26-mm, create nvidia-mm containing the
    kernel modules built against that kernel which provides nvidia and
    also depends on nvidia-utils
-   make sure nvidia depends on the current major kernel version, for
    example:

    depends=('kernel26>=2.6.24-2' 'kernel26<2.6.25-0' 'nvidia-utils')

Note that it is 2.6.24-2, not -1 in above example - this is because
there was a configuration change to important kernel subsystem that
required all modules to be rebuilt. You should always change depends
version in such cases, otherwise some people with out-of-sync kernel and
module version will report that module is broken.

> Rationale

While kernel modules built for different kernels always live in
different directories and can peacefully coexist, the supporting files
are expected to be found in one location. If one package contained
module and supporting files, you would be unable to install the modules
for more than one kernel because the supporting files in the packages
would cause pacman file conflicts.

The separation of modules and accompanying files allows multiple kernel
module packages to be installed for multiple kernels on the same system
while sharing the supporting files among them in the expected location.

File Placement
--------------

If a package includes a kernel module that is meant to override an
existing module of the same name, such module should be placed in the
/lib/modules/2.6.xx-ARCH/updates directory. When depmod is run, modules
in this directory will take precedence.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Kernel_Module_Package_Guidelines&oldid=205936"

Categories:

-   Package development
-   Kernel
