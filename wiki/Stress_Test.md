Stress Test
===========

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Stress test programs                                               |
|     -   2.1 Mprime (prime95)                                             |
|     -   2.2 Linpack                                                      |
|     -   2.3 Systester                                                    |
|     -   2.4 Memtest86+                                                   |
|                                                                          |
| -   3 Stressing CPU and Memory                                           |
|     -   3.1 Mprime (Prime95 for Windows and MacOS)                       |
|     -   3.2 Linpack                                                      |
|     -   3.3 Systester (SuperPi for Windows)                              |
|                                                                          |
| -   4 Stressing Memory                                                   |
|     -   4.1 Running Memtest86+                                           |
+--------------------------------------------------------------------------+

Introduction
------------

Running an overclocked PC is totally fine provided that the PC is stable
at the overclock settings. There are several programs available to
assess system stability through stress testing the system and thereby
the overclock level. The steps of overclocking a PC are beyond the scope
of this article, but there is pretty inclusive guide written by graysky
on the topic: [Overclocking guide].

Stress test programs
--------------------

> Mprime (prime95)

mprime-bin - Mprime factors large numbers and is an excellent way to
stress CPU and memory.

> Linpack

linpack - Linpack makes use of the BLAS (Basic Linear Algebra
Subprograms) libraries for performing basic vector and matrix
operations. and is an excellent way to stress CPUs for stability. Only
runs on Intel processors (?).

> Systester

systester - Systester is a multithreaded piece of software capable of
deriving values of pi out to 128,000,000 decimal places. It has built in
check for system stability.

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

> Systester (SuperPi for Windows)

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
"https://wiki.archlinux.org/index.php?title=Stress_Test&oldid=246337"

Category:

-   CPU
