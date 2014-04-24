Stress Test
===========

Contents
--------

-   1 Introduction
-   2 Discovering Errors
-   3 CPU Stressing Programs
-   4 Memory Stressing Programs
    -   4.1 Memtest86+
-   5 Stressing CPU and Memory
    -   5.1 Mprime (Prime95 for Windows and MacOS)
    -   5.2 Linpack
    -   5.3 Systester (AKA SuperPi for Windows)
-   6 Stressing Memory
    -   6.1 Running Memtest86+

Introduction
------------

Running an overclocked PC is totally fine provided that the PC is stable
at the overclock settings. There are several programs available to
assess system stability through stress testing the system and thereby
the overclock level. The steps of overclocking a PC are beyond the scope
of this article, but there is pretty inclusive guide written by graysky
on the topic: [Overclocking guide].

Note:The linked guide is a bit dated. More contemporary guides are
recommended for modern hardware.

Discovering Errors
------------------

Some stressing applications like mprime and linpack (see below) have
built in consistency checks to discover errors due to non-matching
results. A more general and simple method for measuring hardware
instabilities can be found in the kernel itself. To use it, simply watch
the output from the kernel ring buffer by this command:

    # cat /proc/kmsg

The key error to watch for looks like this:

    [Hardware Error]: Machine check events logged

The kernel can throw these errors during an mprime run before mprime
itself finishes the calculate and reports the error thus providing a
very sensitive method to assess stability.

CPU Stressing Programs
----------------------

These are listed in two categories: 'higher demand voltage' and 'medium
demand voltage'. It is important to use some from each category to
evaluate system stability. Ironically, machines can be more sensitive to
selections from the 'medium demand' category than from the 'high demand'
category. 'Higher demand voltage' programs demand the most vcore when
run due to intense hardware usage. 'Medium demand voltage' programs do
not always call for the highest vcore when running and as such can be
more prone to throwing errors for systems that are undervolted relative
to the clock speed requested.

Example on an overclocked i7-3770K (4.50 GHz); vcore is +0.020 V in
offset mode with all powersaving features enabled.

    Idle: 0.7440 V - 0.8320 V (varies).
    Mprime small FFTs: 1.2880 V (steady).
    Mprime large FFTs: 1.3040 V (steady).
    Mprime blend: 1.2960 V (steady).
    Linpack: 1.2320 V - 1.2720 V (varies).
    x264 encoding: 1.2320 V - 1.2720 V (varies).
    gcc compiling: 1.2720 V (steady).

This machine running with a vcore of +0.005 (in offset mode) remains
stable in both mprime and linpack for hours, but throws errors under
both x264 and gcc after only several minutes.

Voltage Demand

Program

Description

> Medium

Cc/Gcc

Both cc/gcc compilation is a great method of stress testing. Both are
available in the base-devel group.

HandBrake-cli

handbrake-cli can be used to encode using high quality settings.

Systester

systester Systester is a multithreaded piece of software capable of
deriving values of pi out to 128,000,000 decimal places. It has built in
check for system stability.

> High

mprime

mprime-bin factors large numbers and is an excellent way to stress CPU
and memory.

linpack

linpack - Linpack makes use of the BLAS (Basic Linear Algebra
Subprograms) libraries for performing basic vector and matrix
operations. and is an excellent way to stress CPUs for stability.

Memory Stressing Programs
-------------------------

> Memtest86+

Memtest86+ is a standard memory testing util and is packaged in [extra].

Stressing CPU and Memory
------------------------

> Mprime (Prime95 for Windows and MacOS)

Prime95 is recognized universally as one defacto measure of system
stability. Mprime under torture test mode will preform a series of very
CPU intensive calculations and compare the values it gets to known good
values.

Prime95 for Linux is called mprime and is available in the AUR.

Warning:Before proceeding, it is HIGHLY recommended that users have some
means to monitor the CPU temperature. Packages such as Lm_sensors can do
this.

To run mprime, simply open a shell and type "mprime"

    $ mprime

Note: If using a cpu-frequency scaler such as cpufrequtils or powernowd
sometimes, users need to manually set the processor to run with its
highest multiplier because mprime uses a nice value that doesn't always
trip the step-up in multiplier.

When the software loads, simply answer 'N' to the first question to
begin the torture testing:

    Main Menu

    1.  Test/Primenet
    2.  Test/Worker threads
    3.  Test/Status
    4.  Test/Continue
    5.  Test/Exit
    6.  Advanced/Test
    7.  Advanced/Time
    8.  Advanced/P-1
    9.  Advanced/ECM
    10.  Advanced/Manual Communication
    11.  Advanced/Unreserve Exponent
    12.  Advanced/Quit Gimps
    13.  Options/CPU
    14.  Options/Preferences
    15.  Options/Torture Test
    16.  Options/Benchmark
    17.  Help/About
    18.  Help/About PrimeNet Server

There are several options for the torture test (menu option 15).

-   Small FFTs (option 1) to stress the CPU (option 1)
-   In-place large FFTs (option 1) to test the CPU and memory controller
-   Blend (option 3) is the default and constitutes a hybrid mode which
    stresses the CPU and RAM.

Errors will be reported should they occur both to stdout and to
~/results.txt for review later. Many do not consider a system as
'stable' unless it can run the Large FFTs for a 24 hour period.

Example ~/results.txt; note that the two runs from 26-June indicate a
hardware failure. In this case, due to insufficient vcore to the CPU:

    [Sun Jun 26 20:10:35 2011]
    FATAL ERROR: Rounding was 0.5, expected less than 0.4
    Hardware failure detected, consult stress.txt file.
    FATAL ERROR: Rounding was 0.5, expected less than 0.4
    Hardware failure detected, consult stress.txt file.
    [Sat Aug 20 10:50:45 2011]
    Self-test 480K passed!
    Self-test 480K passed!
    [Sat Aug 20 11:06:02 2011]
    Self-test 128K passed!
    Self-test 128K passed!
    [Sat Aug 20 11:22:10 2011]
    Self-test 560K passed!
    Self-test 560K passed!
    ...

Note:Users suspecting bad memory or memory controllers should try the
blend test first as the small FFT test uses very little memory.

> Linpack

Linpack makes use of the BLAS (Basic Linear Algebra Subprograms)
libraries for performing basic vector and matrix operations. and is an
excellent way to stress CPUs for stability. linpack is available from
the AUR. After installation, users should adjust /etc/linpack.conf
according to the amount of memory on the target system.

> Systester (AKA SuperPi for Windows)

Systester is available in the AUR in both cli and gui version. It tests
system stability by calculating up to 128 millions of Pi digits and
includes error checking. Note that one can select from two different
calculation algorithms: Quadratic Convergence of Borwein and
Gauss-Legendre. The latter being the same method that the popular
SuperPi for Windows uses.

A cli example using 8 threads is given:

    $ systester-cli -gausslg 64M -threads 8

Stressing Memory
----------------

A very good program for stress testing memory is [Memtest86+]. It is
based on the well-known original memtest86 written by Chris Brady.
Memtest86+ is, like the original, released under the terms of the GNU
General Public License (GPL). No restrictions for use, private or
commercial exist other than the ones mentioned in the GNU GPL.

> Running Memtest86+

Either download and burn the ISO to a CD and boot from it, or install
memtest86+ from [extra] and update GRUB which will auto-detect the
package and allow users to boot directly to it.

Tip:Allowing Memtest86+ to run for >10 cycles without errors is usually
sufficient.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Stress_Test&oldid=279103"

Category:

-   CPU

-   This page was last modified on 19 October 2013, at 14:15.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
