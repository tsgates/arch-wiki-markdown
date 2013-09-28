Mono
====

Mono is an open source, cross-platform, implementation of C# and the CLR
that is binary compatible with Microsoft.NET.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Running Mono Applications                                          |
| -   3 Testing Mono                                                       |
| -   4 Development                                                        |
| -   5 Troubleshooting                                                    |
|     -   5.1 Q: I get an error when I try to run Mono binaries directly:  |
|         "cannot execute binary file"                                     |
|                                                                          |
| -   6 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Mono can be installed with the package mono, available in the Official
Repositories.

If you need VisualBasic.Net support you have to install the
VisualBasic.Net interpreter with the package mono-basic, available in
the Official Repositories.

Running Mono Applications
-------------------------

You can execute Mono binaries by calling mono manually:

    mono programsname.exe

You can also execute Mono binaries directly, just like native binaries:

    chmod 755 exefile.exe
    ./exefile.exe

Testing Mono
------------

Make a new file; test.cs

    using System;

    public class Test {
     public static void Main(string[] args) {
      Console.WriteLine("Hello World!");
     }
    }

Then run:

    $ mcs test.cs
    $ mono test.exe
    Hello world!

Development
-----------

Starting to develop in Mono/C# is very easy. Just install the
MonoDevelop IDE and debugger support with packages monodevelop,
monodevelop-debugger-gdb, available in the Official Repositories.

If you want the API documentation browser and some testing and
development tools you have to install mono-tools.

Troubleshooting
---------------

Q: I get an error when I try to run Mono binaries directly: "cannot execute binary file"

A: The binfmt_misc handler for Mono has not yet been set up, as
explained in detail on the Mono Project website.

To fix this, restart the systemd-binfmt service:

    # systemctl restart systemd-binfmt

See also
--------

-   Official Mono website
-   The Mono Handbook
-   The API reference of Mono
-   ECMA-334: C# Language Specification
-   ECMA-335: Common Language Infrastructure (CLI)
-   Instructions for running Mono applications

Retrieved from
"https://wiki.archlinux.org/index.php?title=Mono&oldid=241005"

Category:

-   Development
