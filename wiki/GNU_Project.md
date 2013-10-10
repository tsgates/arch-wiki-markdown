GNU Project
===========

> Summary

This article describes the GNU Project and lists some of the essential
tools that qualify Arch Linux as a GNU/Linux distribution.

> Overview

The aim of the GNU Project is to produce a totally free operating
system. While the GNU kernel has not reached a stable version, the
project has resulted in the creation of many tools that power most
Unix-like operating systems. Arch Linux is such a system, using GNU
software like the GRUB bootloader, Bash shell, and numerous other
utilities and libraries.

> Related

Arch Linux

Core Utilities

From http://www.gnu.org/

The GNU Project was launched in 1984 to develop the GNU operating
system, a complete Unix-like operating system which is free
software—software which respects your freedom.

Unix-like operating systems are built from a software collection of
applications, libraries, and developer tools—plus a program to allocate
resources and talk to the hardware, known as a kernel. [...]

The combination of GNU and Linux is the GNU/Linux operating system, now
used by millions and sometimes incorrectly called simply “Linux”.

The name “GNU” is a recursive acronym for “GNU's Not Unix!”

Since Arch Linux is a GNU/Linux based distribution, many of its basic
tools are from the GNU Project. This article will give a brief
description of the core components, as well as some other useful
applications.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 The Base System                                                    |
|     -   1.1 Kernel                                                       |
|     -   1.2 Software Collection                                          |
|                                                                          |
| -   2 Development Tools                                                  |
| -   3 Other Tools                                                        |
| -   4 Links                                                              |
+--------------------------------------------------------------------------+

The Base System
---------------

At the end of the installation process, an Arch system is nothing more
than the Linux Kernel, the GNU toolchain, and a few other useful command
line tools. The minimal install normally contains the entire base group.

> Kernel

While Hurd, the GNU Kernel, is under active development, there is not
yet a stable version. For this reason Arch and most other GNU based
systems use the Linux Kernel. The Arch Hurd Project aims to port Arch
Linux to the Hurd kernel.

> Software Collection

bootloader: GRUB is the standard bootloader for Arch Linux, which is now
maintained by GNU.

C library: glibc is "the library which defines the `system calls' and
other basic facilities such as open, malloc, printf, exit..."[1]

binary utilities: binutils provides the "collection of programming tools
for the manipulation of object code in various object file formats"[2].

shell: Bash, another GNU based application[3], is the default shell.

core utilities: The coreutils package contains "the basic file, shell
and text manipulation utilities"[4].

compression: gzip and Tar handle many packages for GNU/Linux systems.
For example, those from the Arch User Repository come as Gzipped
tarballs.

Development Tools
-----------------

Though not necessary, users have the option of installing the base-devel
group for some software development tools. This group is a requirement
for building packages from the Arch User Repository.

Among base-devel are several members of the GNU toolchain, a "suite of
tools used in a serial manner [...] for developing applications and
operating systems". The key components of this toolchain are:

compilation and build: make

compiler collection: gcc

linker, assembler and other tools: binutils

parser generator: bison

macro processor: m4

GNU Build System (autotools):

automatically configure source code: autoconf

automatically create Makefiles: automake

library support script: libtool

Other Tools
-----------

Many other optional GNU tools are available in the official
repositories:

widget toolkit: GTK+

desktop environment: GNOME

flash player: gnash

spreadsheet: Gnumeric

image editor: GIMP

full-screen window manager: GNU Screen

Links
-----

For a list of all current GNU projects, see All GNU Packages

Retrieved from
"https://wiki.archlinux.org/index.php?title=GNU_Project&oldid=239505"

Categories:

-   Development
-   System administration
