p7zip
=====

p7zip is command line port of 7-Zip for POSIX systems, including Linux.

Contents
--------

-   1 Installation & Use
-   2 Examples
-   3 Differences between 7z, 7za and 7zr binaries
-   4 External Links

Installation & Use
------------------

Install the p7zip package which is available in the official
repositories.

The command to run the program is simply the following:

    # 7z

Examples
--------

To simply extract all files from an archive to the current directory
without using directory names, use the following command:

    # 7za e <archive name>

To extract with full paths, use the following command:

    # 7za x <archive name>

Differences between 7z, 7za and 7zr binaries
--------------------------------------------

The package includes three binaries, /usr/bin/7z, /usr/bin/7za, and
/usr/bin/7zr. Their manual pages explain the differences:

-   7z uses plugins to handle archives.
-   7za is a stand-alone executable. 7za handles fewer archive formats
    than 7z, but does not need any others.
-   7zr is a stand-alone executable. 7zr handles fewer archive formats
    than 7z, but does not need any others. 7zr is a "light-version" of
    7za that only handles 7z archives.

External Links
--------------

Homepage.

7zip homepage.

Retrieved from
"https://wiki.archlinux.org/index.php?title=P7zip&oldid=305772"

Category:

-   Data compression and archiving

-   This page was last modified on 20 March 2014, at 02:10.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
