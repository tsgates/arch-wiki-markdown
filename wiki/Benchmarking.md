Benchmarking
============

Related articles

-   Maximizing performance

Benchmarking is the act of measuring performance and comparing the
results to another system's results or a widely accepted standard
through a unified procedure. This unified method of evaluating system
performance can help answer questions such as:

-   Is the system performing as it should?
-   What driver version should be used to get optimal performance?
-   Is the system capable of doing task x?

Many tools can be used to determine system performance, the following
provides a list of tools available.

Contents
--------

-   1 Stand alone tools
    -   1.1 glxgears
    -   1.2 superpi
        -   1.2.1 See also
    -   1.3 interbench
        -   1.3.1 See also
    -   1.4 ttcp
        -   1.4.1 See also
    -   1.5 iperf
    -   1.6 time
    -   1.7 hdparm
        -   1.7.1 See also
    -   1.8 Unigine Engine
        -   1.8.1 See also
-   2 Software suites
    -   2.1 Bonnie++
        -   2.1.1 See also
    -   2.2 IOzone
        -   2.2.1 See also
    -   2.3 HardInfo
        -   2.3.1 See also
    -   2.4 Phoronix Test Suite
    -   2.5 PTS Desktop Live
        -   2.5.1 See also
-   3 See also

Stand alone tools
-----------------

> glxgears

glxgears is a popular OpenGL test that renders a very simple OpenGL
performance and outputs the frame rate. Though glxgears can be useful as
a test of direct rendering capabilities of the graphics driver, it is an
outdated tool that is not representative of the current state of
GNU/Linux graphics and overall OpenGL possibilities. glxgears only tests
a small segment of the OpenGL capabilities that might be used in a game.
Performance increases noted in glxgears will not necessarily be realized
in any given game. See here for more information.

glxgears can be installed via the mesa-demos and lib32-mesa-demos (for
Multilib) packages.

> superpi

A superpi package is available in the AUR: super_pi.

Warning:The AUR package may not be GPL compatible and may not work with
x86_64.

Note:The AUR package is possibly out of date as of 2013/08/22.

See also

-   http://h2np.net/pi/
-   http://myownlittleworld.com/miscellaneous/computers/pilargetable.html

> interbench

interbench is an application designed to benchmark interactivity in
Linux. It is designed to measure the effect of changes in Linux kernel
design or system configuration changes such as CPU, I/O scheduler and
filesystem changes and options.

Tip:With careful benchmarking, different hardware can be compared.

interbench is available in the AUR: interbench.

See also

-   Realtime process management
-   Advanced Traffic Control
-   Linux-ck
-   Linux-pf

> ttcp

(n)(nu)ttcp measures point-to-point bandwidth over any network
connection. The program must be provided on both nodes between which
bandwidth is to be determined.

Various flavors of ttcp can be found in the AUR (see links below).

See also

-   ttcp
-   nttcp
-   nuttcp

> iperf

iperf is an easy to use point-to-point bandwidth testing tool that can
use either TCP or UDP. It has nicely formatted output and a parallel
test mode.

iperf can be installed from the Official repositories or a different
version of iperf is available in the AUR: iperf3.

> time

The time command provides timing statistics about the command run by
displaying the time that passed between invocation and termination. Time
is available on most basic linux systems.

    $ time tar -zxvf archive.tar.gz

> hdparm

Storage media can be benchmarked with Hdparm (hdparm).

See also

-   Benchmarking disk wipes

> Unigine Engine

Unigine corp. has produced several modern OpenGL benchmarks based on
their graphics engine with features such as:

-   Per-pixel dynamic lighting
-   Normal & parallax occlusion mapping
-   64-bit HDR rendering
-   Volumetric fog and light
-   Powerful particle systems: fire, smoke, explosions
-   Extensible set of shaders (GLSL / HLSL)
-   Post-processing: depth of field, refraction, glow, blurring, color
    correction and much more.

Unigine benchmarks have found recent usage by those looking to overclock
their systems. Heaven especially has been used for initial stability
testing of overclocks.

These benchmarks can be found in the AUR (see links below).

See also

-   unigine-heaven
-   unigine-tropics
-   unigine-sanctuary
-   unigine-valley

Software suites
---------------

> Bonnie++

This C++ rewrite of the original Bonnie benchmarking suite is aimed at
performing several tests of hard drive and filesystem performance.

Note:The original Bonnie suite does not appear to have been released
under the GPL or other compatible license.

bonnie++ is available in the Official repositories.

See the Wikipedia article on this subject for more information: Bonnie++

See also

-   Author's site

> IOzone

IOzone is useful for performing a broad filesystem analysis of a
vendor’s computer platform. See this thread:

This program is available in the AUR: iozone.

See also

-   BBS Article: iozone to evaluate I/O schedulers... results NOT what
    you'd expect!

> HardInfo

HardInfo can gather information about your system's hardware and
operating system, perform benchmarks, and generate printable reports
either in HTML or in plain text formats. HardInfo performs CPU and FPU
benchmarks and has a very clean GTK-based interface.

hardinfo is available in Official repositories .

See also

-   Author's site

> Phoronix Test Suite

The Phoronix Test Suite is the most comprehensive testing and
benchmarking platform available that provides an extensible framework
for which new tests can be easily added. The software is designed to
effectively carry out both qualitative and quantitative benchmarks in a
clean, reproducible, and easy-to-use manner.

The Phoronix Test Suite is based upon the extensive testing and internal
tools developed by Phoronix.com since 2004 along with support from
leading tier-one computer hardware and software vendors. This software
is open-source and licensed under the GNU GPLv3.

Originally developed for automated Linux testing, support to the
Phoronix Test Suite has since been added for OpenSolaris, Apple Mac OS
X, Microsoft Windows, and BSD operating systems. The Phoronix Test Suite
consists of a lightweight processing core (pts-core) with each benchmark
consisting of an XML-based profile and related resource scripts. The
process from the benchmark installation, to the actual benchmarking, to
the parsing of important hardware and software components is heavily
automated and completely repeatable, asking users only for confirmation
of actions.

The Phoronix Test Suite interfaces with OpenBenchmarking.org as a
collaborative web platform for the centralized storage of test results,
sharing of test profiles and results, advanced analytical features, and
other functionality. Phoromatic is an enterprise component to
orchestrate test execution across multiple systems with remote
management capabilities.

This suite can be Installed with the package phoronix-test-suite, which
is available in the Official repositories. There is also a developmental
version available in the AUR: phoronix-test-suite-devel.

> PTS Desktop Live

Warning:The live image does not look like it has been maintained since
2010.

As an alternative to the installation of the Phoronix Test Suite to the
system, Phoronix also provides a Live-CD. This Live-CD offers all the
features of the Phoronix Test Suite and includes the latest ATI and
NVIDIA binary drivers. It will allow you to run 40+ benchmarks from a
live environment without the need to store anything on your hard drive
and includes a working GUI interface.

See also

-   Official link
-   Documentation

See also
--------

-   Linux Benchmarking Homepage
-   Phoronix.com
-   Interbench Homepage
-   Unigine.com

Retrieved from
"https://wiki.archlinux.org/index.php?title=Benchmarking&oldid=305979"

Category:

-   Hardware

-   This page was last modified on 20 March 2014, at 17:32.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
