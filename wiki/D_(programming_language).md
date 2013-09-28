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

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Testing the installation                                           |
| -   3 Considerations                                                     |
| -   4 Useful libraries, bindings, etc.                                   |
| -   5 Links                                                              |
+--------------------------------------------------------------------------+

Installation
------------

To program in D you will need two things - a D compiler and a library.
The official compiler is called DMD and is now available in arch's
community repository.

dmd is just the compiler, but also includes the standard library, which
is called Phobos.

The package dmd is version 2 of dmd, and can be installed from
[community]:

    # pacman -S dmd

This will pull libphobos in as a dependency.

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
The standard is dmd, but GDC (GNU D Compiler) and LDC (LLVM D Compiler)
are also popular. There are packages in the AUR for both of these should
you find it interesting.

The main difference is that the dmd's back end is not FOSS (licensed
from Symantec), while the others compilers are completely FOSS, both
back- and front-end.

Useful libraries, bindings, etc.
--------------------------------

-   DDT - Eclipse plugin for project and code management in D
-   QtD - Qt bindings for D
-   GtkD - An object oriented GTK+ wrapper for D
-   Derelict - Bindings for multimedia libraries, focused toward game
    development
-   Bindings - A project that houses a lot of bindings to different C
    libraries
-   Descent - An Eclipse plugin for programming in D
-   rdmd - A utility that allows one to execute D files like shell
    scripts.
-   Mono-D - An IDE addin for programming in D. (based on MonoDevelop)

Links
-----

-   Phobos source on github - The official Phobos repo
-   Digital Mars - The official home of D
-   dsource - An open source D community, hosts several open source
    projects
-   Planet D - A collection of blogs about D

Retrieved from
"https://wiki.archlinux.org/index.php?title=D_(programming_language)&oldid=206521"

Category:

-   Programming language
