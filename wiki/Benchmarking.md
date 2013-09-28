Benchmarking
============

Benchmarking is the act of measuring performance and comparing the
results to another system's results or a widely accepted standard
through a unified procedure. This unified method of evaluating system
performance can help answer questions such as:

-   Is the system performing as it should?
-   What driver version should be used to get optimal performance?
-   Is the system capable of doing task x?

Many tools can be used to determine system performance, the following
provides a list of tools available.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Stand alone tools                                                  |
|     -   1.1 glxgears (and why not to use this as a benchmark)            |
|     -   1.2 superpi                                                      |
|     -   1.3 interbench                                                   |
|     -   1.4 (n)ttcp                                                      |
|     -   1.5 time                                                         |
|     -   1.6 times                                                        |
|     -   1.7 hdparm                                                       |
|     -   1.8 unigine (Heavens, Tropics and Sanctuary OpenGL Benchmark)    |
|                                                                          |
| -   2 Software suites                                                    |
|     -   2.1 Bonnie++                                                     |
|     -   2.2 iozone                                                       |
|     -   2.3 Hardinfo                                                     |
|     -   2.4 Phoronix Test Suite                                          |
|     -   2.5 PTS Desktop Live 2010.1                                      |
|                                                                          |
| -   3 Related Links                                                      |
+--------------------------------------------------------------------------+

Stand alone tools
-----------------

> glxgears (and why not to use this as a benchmark)

    # pacman -S mesa-demos

Glxgears is a popular OpenGL test that renders a very simple OpenGL
performance and outputs the frame rate. Though glxgears can be useful as
a test of direct rendering capabilities of the graphics driver, glxgears
is an outdated tool that is not representative of the current state of
linux graphics and overall OpenGL possibilities.

So to summarize, glxgears only tests a small part of what you typically
see in a 3D game. You could have glxgears FPS performance increase, but
your 3D game performance decrease. Likewise, you could have glxgears
performance decrease and your 3D game performance increase. source

> superpi

http://myownlittleworld.com/miscellaneous/computers/pilargetable.html

> interbench

This benchmark application is designed to benchmark interactivity in
Linux.

It is designed to measure the effect of changes in Linux kernel design
or system configuration changes such as CPU, I/O scheduler and
filesystem changes and options. With careful benchmarking, different
hardware can be compared.

interbench is available in the AUR:
https://aur.archlinux.org/packages.php?ID=2093

> (n)ttcp

(n)ttcp measures point-to-point bandwidth over any network connection,
the binary must be provided on both nodes between which you want to
determine bandwidth. nttcp is a a much more convenient rewrite of ttcp.

nttcp is available on the AUR:
https://aur.archlinux.org/packages.php?ID=11469

> time

The time command provides timing statistics about the command run by
displaying the time that passed between invocation and termination. Time
is available on most basic linux systems.

    time tar -zxvf archive.tar.gz

> times

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: Obvious! Write   
                           sth and delete this. Or  
                           delete the heading.      
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

> hdparm

You can Benchmark storage media with Hdparm.

This can also be done with dd and Co. There is an Article about
Benchmarking disk wipes.

> unigine (Heavens, Tropics and Sanctuary OpenGL Benchmark)

Unigine[1] has produced several modern OpenGL benchmarks based on their
graphics engine with features such as:

    * Per-pixel dynamic lighting
    * Normal & parallax occlusion mapping
    * 64-bit HDR rendering
    * Volumetric fog and light
    * Powerful particle systems: fire, smoke, explosions
    * Extensible set of shaders (GLSL / HLSL)
    * Post-processing: depth of field, refraction, glow, blurring, color correction and much more.

unigine-heavens is available in the AUR:
https://aur.archlinux.org/packages.php?ID=35901

unigine-tropics is available in the AUR:
https://aur.archlinux.org/packages.php?ID=25420

unigine-sanctuary is available in the AUR:
https://aur.archlinux.org/packages.php?ID=45959

Software suites
---------------

> Bonnie++

This C++ rewrite of the original Bonnie benchmarking suite is aimed at
performing several tests of hard drive and filesystem performance.

Bonnie++ is available in package bonnie++.

> iozone

Iozone is useful for performing a broad filesystem analysis of a
vendor’s computer platform. See this thread:
https://bbs.archlinux.org/viewtopic.php?pid=969463

iozone is available in iozone.

> Hardinfo

HardInfo can gather information about your system's hardware and
operating system, perform benchmarks, and generate printable reports
either in HTML or in plain text formats. Hardinfo performs CPU and FPU
benchmarks and has a very clean GTK UI.

hardinfo is available in hardinfo.

> Phoronix Test Suite

The Phoronix Test Suite is the most comprehensive testing and
benchmarking platform available for the Linux operating system. This
software is designed to effectively carry out both qualitative and
quantitative benchmarks in a clean, reproducible, and easy-to-use
manner. This software is based upon the extensive Linux benchmarking
work and internal tools developed by Phoronix.com since 2004 along with
input from leading tier-one computer hardware vendors. This software is
open-source and licensed under the GNU GPLv3. The Phoronix Test Suite
consists of a lightweight processing core (pts-core) with each benchmark
consisting of an XML-based profile with related resource scripts. The
process from the benchmark installation, to the actual benchmarking, to
the parsing of important hardware and software components is heavily
automated and completely repeatable, asking users only for confirmation
of actions.

This suite can be Installed with the package phoronix-test-suite ,
available in the Official Repositories.

> PTS Desktop Live 2010.1

As an alternative to the installation of the Phoronix Test Suite to the
system, Phoronix also provides a Live-CD. This Live-CD offers all the
features of the Phoronix Test Suite and includes the latest ATI and
NVIDIA binary drivers. It will allow you to run 40+ benchmarks from a
live environment without the need to store anything on your hard drive
and includes a working GUI interface.

Website: http://www.phoronix-test-suite.com/?k=pts_desktop_live

Documentation:
http://www.phoronix-test-suite.com/documentation/2.4/pts_desktop_live.html

Related Links
-------------

-   Linux Benchmarking Homepage
-   Phoronix.com
-   Interbench Homepage
-   Unigine.com

Retrieved from
"https://wiki.archlinux.org/index.php?title=Benchmarking&oldid=239171"

Category:

-   Hardware
