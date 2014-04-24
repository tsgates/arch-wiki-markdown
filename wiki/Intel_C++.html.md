Intel C++
=========

Summary help replacing me

Installation and basic usage of Intel® C++ Composer XE (formerly Intel®
C++ Compiler Professional Edition) for Linux on Arch.

> Related

ABS

Creating Packages

Makepkg

Contents
--------

-   1 Before you begin
-   2 Setup and installation
-   3 Using icc with makepkg
    -   3.1 Method 1 (12/08/2012)
-   4 icc CFLAGS
    -   4.1 -xX
    -   4.2 -Ox
    -   4.3 -w
-   5 Software compiled with Intel C / C++

Before you begin
----------------

Note:Packages that have been compiled by icc will depend on the
associated libs contained in the intel-openmp package in order to run.
Since intel-openmp depends on intel-compiler-base, users MUST have both
packages installed at all times!

Setup and installation
----------------------

intel-parallel-studio-xe are available in the AUR. To build the package,
one needs a license file which is free for personal and for
non-commercial use. The requisite license file is emailed to users upon
[registration] and should be copied into the $startdir prior to running
makepkg. The current PKGBUILD assembles 7 or 8 packages:

-   intel-compiler-base - Intel C/C++ compiler and base libs
-   intel-fortran-compiler - Intel fortran compiler and base libs (only
    Parallel Studio XE)
-   intel-openmp - Intel OpenMP Library
-   intel-idb- Intel C/C++ debugger
-   intel-ipp - Intel Integrated Performance Primitives
-   intel-mkl - Intel Math Kernel Library (Intel® MKL)
-   intel-sourcechecker - Intel Source Checker
-   intel-tbb - Intel Threading Building Blocks (TBB)

Note:A minimal working environment requires the intel-compiler-base and
intel-openmp packages; if you want also the fortran compiler you must
install intel-fortran-compiler.

Using icc with makepkg
----------------------

Note:Not every package will successfully compile with icc without heavy
modifications to the underlying source.

There is currently no official guide to using icc with makepkg. This
section is meant to capture various methods suggested by users. Please
make a new sub-section with your suggested method titled as such.

> Method 1 (12/08/2012)

Modify /etc/makepkg.conf inserting the following code under the existing
line defining CXXFLAGS to enable makepkg to use icc. No special switches
are needed when calling makepkg to build.

    _CC=icc
    if [ $_CC = "icc" ]; then
    export CC="icc"
    export CXX="icpc"
    export CFLAGS="-march=native -O3 -no-prec-div -fno-alias -pipe"
    export CXXFLAGS="${CFLAGS}"
    export LDFLAGS="-Wl,-O1,--sort-common,--as-needed"
    export AR="xiar"
    export LD="xild"
    fi

> Note:

-   To toggle between the native gcc and icc, simple comment or
    uncomment the newly created _CC variable.
-   In some case the compilation method described above fails and the
    compilation will be performed with gcc, so you should test if yours
    application has been effectively compiled with icc.

To test if your package has been really compiled with icc:

-   Type the command ldd [your_app] | grep intel If the application is
    linked to a shared object located in the directory /opt/intel/lib/
    it's mind that has been complied with icc.

-   Another method is to observe the build output and watch if it's
    using the icc or icpc command.

-   The last method is to watch if the warnings are in icc style or not.

icc CFLAGS
----------

In general, icc supports many of the same CFLAGS gcc supports and is
also pretty tolerant to gcc flags it cannot use. In most cases it will
happily ignore the flag warning the user and moving on. For an
exhaustive list and explanation of available compiler flags, consult the
icc manpage or better yet by invoking the compiler with the help flag:

    icc --help

> -xX

Use to generate specialized code to run exclusively on processors
supporting it. If unsure which option to use, simply inspect the flags
section of /proc/cpuinfo. In the example below, SSE4.1 would be the
correct selection:

    $ grep -m 1 flags /proc/cpuinfo

    flags: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush 
    dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs 
    bts rep_good nopl aperfmperf pni dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr
    pdcm sse4_1 lahf_lm dts tpr_shadow vnmi flexpriority

-   -xHost
-   -xSSE2
-   -xSSE3
-   -xSSSE3
-   -xSSE4.1
-   -xSSE4.2
-   -xAVX
-   -xCORE-AVX-I
-   -xSSSE3_ATOM

Tip:Use the -xHost flag if unsure what your specific processor supports.

> -Ox

Same behavior as gcc. x is one of the following options:

-   0 - disables optimizations
-   1 - optimize for maximum speed, but disable some optimizations which
    increase code size for a small speed benefit
-   2 - optimize for maximum speed (DEFAULT)
-   3 - optimize for maximum speed and enable more aggressive
    optimizations that may not improve performance on some programs
    (recommended for math intensive looping programs)

> -w

Similar to the gcc:

-   -w - disable all warnings (recommended for the package compilation)
-   -Wbrief - print brief one-line diagnostics
-   -Wall - enable all warnings
-   -Werror - force warnings to be reported as errors

Software compiled with Intel C / C++
------------------------------------

In the following table we report a list of packages from the officials
repository that we have tried to compile with the intel C/C++ compiler.
The compilation should be done by using the PKGBUILD from ABS.

  

  Application    Compile        Comments
  -------------- -------------- --------------------------------------------------------------------------------
  xvidcore       OK             Works with the Method 1
  kdebase        OK             Works with the Method 1
  conky 1.9.0    OK             Works with the Method 1
  nginx 1.4.2    OK             Works with the Method 1
  gzip 1.6       OK             Works with the Method 1
  xz             OK             Works with the Method 1
  lz4            OK             We must edit the PKGBUILD.
  minetest       OK             Works with the Method 1
  opus           OK             Works with the Method 1
  zlib 1.2.8     OK             Works with the Method 1
  Gimp 2.8       OK             Works with the Method 1
  Pacman 4.0.3   OK             Works with the Method 1
  x264           OK             Works with the Method 1
  MySql          OK             Works with the Method 1
  SqlLite        OK             Works with the Method 1
  lame           OK             Works with the Method 1
  xaos           OK             Works with the Method 1
  VLC            Unsuccessful   There's some problem with the compiler flags
  bzip2          Unsuccessful   There's some problem with the compiler flags
  mplayer        Out of date    It don't recognize the Intel compiler
  optipng        OK             Works with the Method 1. Comment out LD=xild in makepkg.conf
  python-numpy   OK             We must edit the PKGBUILD. python-numpy-mkl
  python-scipy   OK             We must edit the PKGBUILD. python-scipy-mkl
  Qt             OK             We must add the option -platform linux-icc-64 (or 32) in the configure command
  systemd        Fail           undefined reference to `server_dispatch_message'

> Legend:

  ----------------- ------------------------------------------------------------------------------------------------------------------------------------
  OK                The compilation with ICC works!
  OK                The compilation works but is needed an editing of the PKGBUILD
  Unsuccessful      The compilation may work, but there are some compilations errors.
  Not recommended   The compilation works, but is not recommended
  Fail              It's impossible to compile the PKG with ICC.
  Out of date       It's unsuccessful or fails with older CFLAGS. You can try compiling it with new Method 1.(Don't forget to paste your result here!)
  ----------------- ------------------------------------------------------------------------------------------------------------------------------------

Retrieved from
"https://wiki.archlinux.org/index.php?title=Intel_C%2B%2B&oldid=280121"

Category:

-   Development

-   This page was last modified on 28 October 2013, at 10:56.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
