D (programming language)
========================

From Wikipedia:D (programming language):

"The D programming language, also known simply as D, is an
object-oriented, imperative, multi-paradigm system programming language
by Walter Bright of Digital Mars. It originated as a re-engineering of
C++, but even though it is predominantly influenced by that language, it
is not a variant of it. D has redesigned some C++ features and has been
influenced by concepts used in other programming languages, such as
Java, C#, and Eiffel".

Contents
--------

-   1 Installation
-   2 Testing the installation
-   3 Considerations
-   4 Useful libraries and bindings
-   5 See Also

Installation
------------

To program in D you will need two things - a D compiler and a library.
Easiest way to get started fast is to install dlang-dmd package group.
It will provide the official compiler (dmd), standard lbrary
libphobos-devel and collection of small development tools dtools.

Testing the installation
------------------------

To make sure that everything is installed and set up correctly, a simple
Hello World program should suffice.

    import std.stdio;

    void main() {
       string yourName = "archer";
       writefln("Hello %s!", yourName);
    }

Paste the code into a file, name it hello.d, and run

    $ dmd hello.d

in the same directory as the file. You should then be able to execute
the program with:

    $ ./hello

You can also execute

    $ dmd -run hello.d

which will simply compile and run without leaving any object files in
the directory.

Considerations
--------------

There are however possible choices regarding the compiler you choose.
The standard (reference one) is dmd, but gdc (GNU D Compiler) and ldc
(LLVM D Compiler) are also popular. Those are also in [community].

The main difference is that the dmd's back end is not FOSS (licensed
from Symantec), while the others compilers are completely FOSS. All 3
compilers share same front-end code and thus have almost identical
support for language features (assuming same front-end version).

Useful libraries and bindings
-----------------------------

-   DDT - Eclipse plugin for project and code management in D
-   Mono-D - MonoDevelop addin for programming in D
-   QtD - Qt bindings for D
-   GtkD - An object oriented GTK+ wrapper for D
-   Derelict - Bindings for multimedia libraries, focused toward game
    development
-   Deimos - A project that houses a lot of bindings to different C
    libraries

See Also
--------

-   Phobos source on github - The official Phobos repo
-   The D Programming Language - The official home of D
-   Planet D - A collection of blogs about D

Retrieved from
"https://wiki.archlinux.org/index.php?title=D_(programming_language)&oldid=294501"

Category:

-   Programming language

-   This page was last modified on 26 January 2014, at 07:24.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
