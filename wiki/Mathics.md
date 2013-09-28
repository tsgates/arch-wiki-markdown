Mathics
=======

Summary

This article contains information about the installation, configuration
and use of Mathics.

Related

Matlab

Octave

Mathematica

Mathics is a free CAS (Computer Algebra System) for symbolic
mathematical computations that uses Python as its main language. It aims
at achieving a Mathematica-compatible syntax and functions. It relies
mostly on Sympy for most mathematical tasks and, optionally, Sage for
more advanced stuff.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Using Mathics                                                      |
|     -   2.1 Mathics CLI                                                  |
|     -   2.2 Mathics web interface                                        |
+--------------------------------------------------------------------------+

Installation
------------

Mathics can be installed with the package mathics, available in AUR.

Using Mathics
-------------

Mathics can be used through a CLI or a web interface

> Mathics CLI

Just execute from a command line:

    $ mathics

> Mathics web interface

Before you run mathics web interface you must execute in the command
line the following (as the user who will execute mathics):

    $ /usr/lib/python2.7/site-packages/mathics_initialize.py

Then execute from the command line:

    $ mathicsserver

Retrieved from
"https://wiki.archlinux.org/index.php?title=Mathics&oldid=250889"

Category:

-   Mathematics and science
