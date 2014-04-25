GPGPU
=====

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: With new         
                           versions of OpenCL, the  
                           things have changed a    
                           little bit. (Discuss)    
  ------------------------ ------------------------ ------------------------

Summary help replacing me

Installation and usage of OpenCL and CUDA, the two major Linux GPGPU
frameworks

> Related

Catalyst

Nvidia

GPGPU stands for General-purpose computing on graphics processing units.
In Linux, there are currently two major GPGPU frameworks: OpenCL and
CUDA  
  

Contents
--------

-   1 OpenCL
    -   1.1 Overview
    -   1.2 OpenCL library
    -   1.3 The OpenCL ICD model
    -   1.4 Implementations
        -   1.4.1 AMD
        -   1.4.2 Mesa (Gallium)
        -   1.4.3 Nvidia
        -   1.4.4 Intel
    -   1.5 Development
        -   1.5.1 Language bindings
-   2 CUDA
    -   2.1 Development
    -   2.2 Language bindings
    -   2.3 Driver issues
-   3 List of OpenCL and CUDA accelerated software
-   4 Links and references

OpenCL
------

> Overview

OpenCL (Open Computing Language) is an open, royalty-free parallel
programming framework developed by the Khronos Group, a non-profit
consortium.

Distribution of the OpenCL framework generally consists of:

-   Library providing OpenCL API, known as libCL or libOpenCL
    (libOpenCL.so in linux)
-   OpenCL implementation(s), which contain:
    -   Device drivers
    -   OpenCL/C code compiler
    -   SDK *
-   Header files *

* only needed for development

> OpenCL library

There are several choices for the libCL. In general case, installing
libcl from [extra] should do :

    # pacman -S libcl

However, there are situations when another libCL distribution is more
suitable. The following paragraph covers this more advanced topic.

> The OpenCL ICD model

OpenCL offers the option to install multiple vendor-specific
implementations on the same machine at the same time. In practice, this
is implemented using the Installable Client Driver (ICD) model. The
center point of this model is the libCL library which in fact
imeplements ICD Loader. Through the ICD Loader, an OpenCL application is
able to access all platforms and all devices present in the system.

Although itself vendor-agnostic, the ICD Loader still has to be provided
by someone. In Archlinux, there are currently two options:

-   extra/libcl by Nvidia. Provides OpenCL version 1.0 (even in the
    current version) and is thus slightly outdated. Its behaviour with
    OpenCL 1.1 code has not been tested as of yet.
-   unsupported/libopencl by AMD. Provides up to date version 1.1 of
    OpenCL. It is currently distributed by AMD under a restrictive
    license and therefore could not have been pushed into official repo.

(There is also Intel's libCL, this one is currently not provided in a
separate package though.)

Note:ICD Loader's vendor is mentioned only to identify each loader, it
is otherwise completely irrelevant. ICD Loaders are vendor-agnostic and
may be used interchangeably  
(as long as they are implemented correctly)

For basic usage, extra/libcl is recommended as its installation and
updating is convenient. For advanced usage, libopencl is recommended.
Both libcl and libopencl should still work with all the implementations.

> Implementations

To see which OpenCL implementations are currently active on your system,
use the following command:

    $ ls /etc/OpenCL/vendors

AMD

OpenCL implementation from AMD is known as AMD APP SDK, formerly also
known as AMD Stream SDK or ATi Stream.

For Arch Linux, AMD APP SDK is currently available in AUR as amdapp-sdk.
This package is installed as /opt/AMDAPP and apart from SDK files it
also contains a number of code samples (/opt/AMDAPP/SDK/samples/). It
also provides the clinfo utility which lists OpenCL platforms and
devices present in the system and displays detailed information about
them.

As AMD APP SDK itself contains CPU OpenCL driver, no extra driver is
needed to use execute OpenCL on CPU devices (regardless of its vendor).
GPU OpenCL drivers are provided by the catalyst package (an optional
dependency), the open-source driver (xf86-video-ati) does not support
OpenCL.

Code is compiled using llvm (dependency).

Mesa (Gallium)

OpenCL support from Mesa is in development (see
http://www.x.org/wiki/GalliumStatus/). AMD Radeon cards are supported by
the r600g driver.

Arch Linux does currently (October 2013; Mesa 9.2.2; LLVM 3.3) not build
Mesa with OpenCL support. See
http://dri.freedesktop.org/wiki/GalliumCompute/ for installation
instructions (use the development branches of LLVM and Mesa for optimal
results).

You could also use lordheavy's repo. Install these packages:

-   ati-dri-git
-   opencl-mesa-git
-   libclc-git

Surprisingly, pyrit performs 20% better with radeon+r600g compared to
Catalyst 13.11 Beta1 (tested with 7 other CPU cores):

    catalyst     #1: 'OpenCL-Device 'Barts'': 21840.7 PMKs/s (RTT 2.8)
    radeon+r600g #1: 'OpenCL-Device 'AMD BARTS'': 26608.1 PMKs/s (RTT 3.0)

At the time of this writing (30 October 2013), one must apply patches
[1] and [2] on top of Mesa commit
ac81b6f2be8779022e8641984b09118b57263128 to get this performance
improvement. The latest unpatched LLVM trunk was used (SVN rev 193660).

Nvidia

The Nvidia implementation is available in extra/opencl-nvidia. It only
supports Nvidia GPUs running the nvidia kernel module (nouveau does not
support OpenCL yet).

Intel

The Intel implementation, named simply Intel OpenCL SDK, provides
optimized OpenCL performance on Intel CPUs (mainly Core and Xeon) and
CPUs only. Package is available in AUR: intel-opencl-sdk. OpenCL for
integrated graphics hardware is available in the AUR through beignet for
Ivy Bridge and newer hardware.

> Development

For development of OpenCL-capable applications, full installation of the
OpenCL framework including implementation, drivers and compiler plus the
opencl-headers package is needed. Link your code against libOpenCL.

Language bindings

-   C++: A binding by Khronos is part of the official specs. It is
    included in opencl-headers
-   C++/Qt: An experimental binding named QtOpenCL is in Qt Labs - see
    Blog entry for more information
-   JavaScript/HTML5: WebCL
-   Python: There are two bindings with the same name: PyOpenCL. One is
    in [extra]: python2-pyopencl, for the other one see sourceforge
-   D: cl4d
-   Haskell: The OpenCLRaw package is available in AUR:
    haskell-openclraw
-   Java: JOCL (a part of JogAmp)
-   Mono/.NET: Open Toolkit

CUDA
----

CUDA (Compute Unified Device Architecture) is Nvidia's proprietary,
closed-source parallel computing architecture and framework. It is made
of several components:

-   required:
    -   proprietary Nvidia kernel module
    -   CUDA "driver" and "runtime" libraries
-   optional:
    -   additional libraries: CUBLAS, CUFFT, CUSPARSE, etc.
    -   CUDA toolkit, including the nvcc compiler
    -   CUDA SDK, which contains many code samples and examples of CUDA
        and OpenCL programs

The kernel module and CUDA "driver" library are shipped in extra/nvidia
and extra/opencl-nvidia. The "runtime" library and the rest of the CUDA
toolkit are available in community/cuda. The library is available only
in 64-bit version.

> Development

When installing cuda package you get the directory /opt/cuda created
where all of the components "live". For compiling cuda code add
/opt/cuda/include to your include path in the compiler instructions. For
example this can be accomplished by adding -I/opt/cuda/include to the
compiler flags/options.

> Language bindings

-   Fortran: FORTRAN CUDA, PGI CUDA Fortran Compiler
-   Python: In AUR: pycuda, also Kappa
-   Perl: Kappa, CUDA-Minimal
-   Haskell: The CUDA package is available in AUR: haskell-cuda. There
    is also The accelerate package
-   Java: jCUDA, JCuda
-   Mono/.NET: CUDA.NET, CUDAfy.NET
-   Mathematica: CUDAlink
-   Ruby, Lua: Kappa

> Driver issues

It might be necessary to use the legacy driver nvidia-304xx or
nvidia-304xx-lts to resolve permissions issues when running CUDA
programs on systems with multiple GPUs.

List of OpenCL and CUDA accelerated software
--------------------------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

-   Bitcoin
-   GIMP (development in progress - see this notice)
-   Pyrit
-   aircrack-ng
-   cuda_memtest - a GPU memtest. Despite its name, is supports both
    CUDA and OpenCL

Links and references
--------------------

-   OpenCL official homepage
-   CUDA official homepage
-   The ICD extension specification
-   AMD APP SDK homepage
-   CUDA Toolkit homepage
-   Intel OpenCL SDK homepage

Retrieved from
"https://wiki.archlinux.org/index.php?title=GPGPU&oldid=302802"

Categories:

-   Development
-   Graphics

-   This page was last modified on 1 March 2014, at 21:52.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
