ABS FAQ
=======

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with ABS.        
                           Notes: please use the    
                           second argument of the   
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

> Summary

Very simple answers to questions about the Arch Build System and making
your own Arch Linux packages.

> Related

Arch Build System

Arch User Repository

Creating Packages

pacman

PKGBUILD

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 What is the ABS?                                                   |
| -   2 What do people mean when they say "Use ABS"?                       |
| -   3 How do the Arch Linux developers create all of those binary        |
|     packages that I install using pacman?                                |
| -   4 Can I get a copy of the PKGBUILD files that the Arch Linux         |
|     developers use?                                                      |
| -   5 What do I do to make a package?                                    |
| -   6 What are all of those other files under /var/abs?                  |
| -   7 How do I install the package I just made?                          |
| -   8 How do I make my own PKGBUILD file?                                |
| -   9 Can somebody make a PKGBUILD file for me for a piece of software I |
|     want to use?                                                         |
+--------------------------------------------------------------------------+

What is the ABS?
----------------

"ABS" stands for Arch Build System. It is a convenient way to create and
install Arch Linux packages.

What do people mean when they say "Use ABS"?
--------------------------------------------

They mean, "Make and install an Arch Linux package using the provided
Arch Linux tools". If you want to learn how to do this yourself, then
keep reading. It's easy!

How do the Arch Linux developers create all of those binary packages that I install using pacman?
-------------------------------------------------------------------------------------------------

Arch Linux packages are created by first writing a PKGBUILD file. A
PKGBUILD file is a Bash script that contains:

-   The name of the package, the version number, and lots of other
    information.
-   Instructions for downloading, compiling, and installing the software
    package.

The newly written PKGBUILD file is then used by the makepkg program
which uses the instructions contained within it to create a
pacman-installable, binary package with the extenstion '.pkg.tar.xz'.

Can I get a copy of the PKGBUILD files that the Arch Linux developers use?
--------------------------------------------------------------------------

Sure! Install the program abs:

    # pacman -S abs

And then run it as root:

    # abs

You now have every official Arch Linux PKGBUILD file in /var/abs.

What do I do to make a package?
-------------------------------

First, make sure you have all of the development tools installed:

    # pacman -S base-devel

Now, all you need is a PKGBUILD file. I recommend that you make packages
in a new directory. Let's say you want to make your own package for vi,
just like the one you can install using pacman. Copy the PKGBUILD from
/var/abs to a new directory:

    $ cp -r /var/abs/core/vi ~/vi

Go to your new directory, and edit the PKGBUILD to your desired
specifications with your text editor of choice.

Use the makepkg command to make a package:

    $ makepkg

That's it! You now have a .pkg.tar.xz package for vi.

What are all of those other files under /var/abs?
-------------------------------------------------

Sometimes a PKGBUILD uses patches, or includes default settings files
and examples.

How do I install the package I just made?
-----------------------------------------

Use pacman:

    # pacman -U yourpackagename.pkg.tar.gz

The actual name of the file depends on the name of the package, the
version number, and what processor architecture you are using.

How do I make my own PKGBUILD file?
-----------------------------------

You can copy an example PKGBUILD file from /usr/share/pacman or /var/abs
and modify it. You can read more about PKGBUILD files here.

Can somebody make a PKGBUILD file for me for a piece of software I want to use?
-------------------------------------------------------------------------------

There is a good chance someone already did! Look in the "AUR", or Arch
User Repository. You will find PKGBUILD files that other Arch Linux
users made. You can also submit PKGBUILD files that you make yourself.

Retrieved from
"https://wiki.archlinux.org/index.php?title=ABS_FAQ&oldid=251286"

Categories:

-   Package development
-   About Arch
