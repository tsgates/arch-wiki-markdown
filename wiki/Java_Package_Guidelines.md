Java Package Guidelines
=======================

Package creation guidelines

* * * * *

CLR – Cross – Eclipse – Free Pascal – GNOME – Go – Haskell – Java – KDE
– Kernel – Lisp – MinGW – Nonfree – OCaml – Perl – Python – Ruby – VCS –
Web – Wine

This document defines a proposed standard for packaging Java programs
under Arch Linux. Java programs are notoriously difficult to package
cleanly without overlapping dependencies. This document describes a way
to remedy this situation. These guidelines are flexible in order to
cover the many different scenarios that arise when dealing with Java
applications.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Structure of a Typical Java Application                            |
| -   3 Arch Java Packaging                                                |
|     -   3.1 Multiple API implementations                                 |
|     -   3.2 Example Directory Structure                                  |
|     -   3.3 Dependencies                                                 |
+--------------------------------------------------------------------------+

Introduction
------------

Arch Linux packagers cannot seem to agree on how to handle Java
packages. Various methods are used in PKGBUILDs across the official and
unofficial repositories and in the AUR. These solutions include placing
the whole mess in /opt with shell scripts in /usr/bin or profiles placed
in /etc/profile. Others are placed in directories in /usr/share with
scripts placed in /usr/bin. Many add unnecessary files to the system
CLASSPATH and PATH.

Structure of a Typical Java Application
---------------------------------------

Most Desktop Java applications have a similar structure. They are
installed from a system-independent (but package dependent!) installer.
This usually installs everything in a single directory with
subdirectories called bin, lib, jar, conf, etc. There is usually a main
jar file containing the main executable classes. A shellscript is
usually provided to run the main class so users do not have to invoke
the Java interpreter directly. This shell script is usually quite
complex, as it is generic across distros, and often includes special
cases for different systems (ie: CYGWIN).

The lib directory, often contains bundled jar files that satisfy
dependencies of the Java application. This makes it simple for a user to
install the program (all dependencies included), but is a package
developer's nightmare. It is a waste of space when several packages
bundle the same dependency. This was not a big issue in the past when
there were fewer desktop Java applications and libraries, and those that
existed tended to be very large anyway. Things are different now...

Other files necessary to run the program are usually stored in the same
folder as the main jar file, or a subdirectory thereof. Since Java
programs do not know where their classes were loaded from, they usually
need to be run from within this directory (i.e. the shell script should
cd into the directory), or an environment variable is set to indicate
the directory's location.

Arch Java Packaging
-------------------

Packaging Java applications in Arch is going to take quite a bit more
work for packagers than it currently does. The effort will be worth it,
however, resulting in a cleaner filesystem and fewer bundled
dependencies (as more and more Java libraries are refactored into their
own packages, packaging will become easier). The following guidelines
should be followed in creating an Arch Linux Java package:

-   If a Java library has a generic name, the package name should be
    prepended with the title java- to help distinguish it from other
    libraries. This is not necessary with uniquely named packages (like
    JUnit), end-user programs (like Eclipse), or libraries that can be
    uniquely described with another prefix (like
    jakarta-commons-collections or apache-ant).

-   You do not need to compile Java applications from source. Very
    little optimization goes into the compile process, as with gcc
    created binaries. If the source package provides an easy way to
    build from source go ahead and use it, but if its easier to just
    grab a binary release of a jar file or an installer you may use that
    as well.

-   Place all jar files (and no other files) distributed with the
    program in a /usr/share/java/myprogram directory. This includes all
    dependency jar files distributed with the application. However,
    effort should be made to place common or large dependency libraries
    into their own packages. This can only happen if the program does
    not depend on a specific version of a dependency library.

This rule makes it possible to iteratively refactor dependencies. That
is, the package and all its dependencies can be placed into one
directory at first. After this has been tested, major dependencies can
be refactored out one at a time. Note that some applications include
bundled dependencies inside the main jar file. That is, they unjar the
bundled dependencies and include them in the main jar. Such dependencies
are usually very small and there is little point in refactoring them.

-   If the program is meant to be run by the user, write a custom shell
    script that runs the main jar file. This script should be placed in
    /usr/bin. Libraries generally do not require shell scripts. Write
    the shell script from scratch, rather than using one that is bundled
    with the program. Remove code that tests for custom environments
    (like CYGWIN), and code that tries to determine if JAVA_HOME has
    been set (The J2RE package ensures JAVA_HOME has been properly set,
    so we do not need to test for it).

such script should look like this for jars:

    #!/bin/sh
    "$JAVA_HOME/bin/java" -jar '/usr/share/java/PROGRAMNAME/PROGRAMNAME.jar'

and like this for single class files:

    #!/bin/sh
    "$JAVA_HOME/bin/java" '/usr/share/java/PROGRAMNAME/PROGRAMCLASSNAME'

-   Set the CLASSPATH using the -cp option to the Java interpreter
    unless there is an explicit reason not to (ie: the CLASSPATH is used
    as a plugin mechanism). The CLASSPATH should include all jar files
    in the /usr/share/java/myprogram direcory, as well as jar files that
    are from dependency libraries that have been refactored to other
    directories. You can use something like the following code:

    for name in /usr/share/java/myprogram/*.jar ; do
      CP=$CP:$name
    done
    CP=$CP:/usr/share/java/dep1/dep1.jar
    java -cp $CP myprogram.java.MainClass

-   Make sure the shellscript is executable!

-   Other files distributed with the package should be stored in a
    directory named after the package under /usr/share. You may need to
    set the location of this directory in a variable like MYPROJECT_HOME
    inside the shellscript. This guideline assumes that the program
    expects all files to be in the same directory (as is standard with
    Java packages). If it seems more natural to put a configuration file
    elsewhere (for example, logs in /var/log), then feel free to do so.

Bear in mind that /usr may be mounted as read-only on some systems. If
there are files in the shared directory that need to be written by the
application, they may have to be relocated to /etc, /var, or the user's
home directory.

-   As is standard with Arch Linux packages, if the above standards
    cannot be adhered to without a serious amount of work, the package
    should be installed in its preferred manner, with the resulting
    directory located in /opt. This is useful for programs that bundle
    JREs or include customized versions of dependencies, or do other
    strange or painful tasks.

> Multiple API implementations

If your package distributes commonly used api implementation(like jdbc
driver) you should place the library under /usr/share/java/apinam. So
that applications that allow user to select from various implementations
will know where to look for them. Use this location only for raw library
packages. If such a implementation is part of distribution of
application, do not place this jarfile under common location, but use
ordinary package structure.

> Example Directory Structure

To clarify, here is an example directory structure for a hypothetical
program called foo. Since foo is a common name, the package is named
java-foo, but notice this is not reflected in the directory structure:

-   /usr/share/java/foo/
-   /usr/share/java/foo/foo.jar
-   /usr/share/java/foo/bar.jar (included dependency of java-foo)
-   /usr/share/foo/
-   /usr/share/foo/*.* (some general files required by java-foo)
-   /usr/bin/foo (executable shell script)

> Dependencies

Java packages might specify java-runtime or java-environment as
dependency, based on what they need.

For most packages, java-runtime is what is needed to simply run software
written in Java. java-runtime is a virtual dependency provided by:

-   jre7-openjdk (free)
-   java-gcj-compat (free)
-   jre (non-free)

java-environment (e.g. JDK) is needed by packages that will need to
compile Java source code into bytecode. java-environment is a virtual
dependency provided by:

-   jdk7-openjdk (free)
-   jdk (non-free)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Java_Package_Guidelines&oldid=250668"

Category:

-   Package development
