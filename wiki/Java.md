Java
====

> Summary

This article explains how to install and configure JRE/JDK.

> Related

Java Package Guidelines

"Java is a programming language originally developed by Sun Microsystems
and released in 1995 as a core component of Sun Microsystems' Java
platform. The language derives much of its syntax from C and C++ but has
a simpler object model and fewer low-level facilities. Java applications
are typically compiled to bytecode that can run on any Java virtual
machine (JVM) regardless of computer architecture." — Wikipedia article

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 OpenJDK JVM                                                  |
|         -   1.1.1 Flagging OpenJDK packages as out-of-date               |
|                                                                          |
|     -   1.2 Oracle JVM                                                   |
|     -   1.3 Oracle JVM (Java 6)                                          |
|     -   1.4 Kaffe (Discontinued)                                         |
|     -   1.5 BEA JRockit JIT JVM (+JDK)                                   |
|     -   1.6 VMkit LLVM-based JIT VM                                      |
|     -   1.7 Parrot VM                                                    |
|                                                                          |
| -   2 Troubleshooting                                                    |
|     -   2.1 MySQL                                                        |
|     -   2.2 Java sound with Pulseaudio                                   |
|     -   2.3 Impersonate Another Window Manager                           |
|     -   2.4 Fonts are Illegible                                          |
|                                                                          |
| -   3 Tips and tricks                                                    |
|     -   3.1 Better font rendering                                        |
|     -   3.2 GTK LookAndFeel                                              |
|     -   3.3 Symlinks change                                              |
+--------------------------------------------------------------------------+

Installation
------------

The only JVM implementation in supported repositories is the open source
OpenJDK. Additional Java implementations are available via the AUR. Keep
in mind that the open-source and closed-source versions cannot be
installed simultaneously. The open-source version is nearly perfect at
the time of writing, and there is mostly no need anymore to install
Oracle's proprietary version of Java.

Note:After installation, the Java environment will need recognized by
the shell ($PATH variable and $JAVA_HOME). This can be done from the
command line by sourcing /etc/profile, and for Desktop Environments it
is likely a logout/login will be necessary.

> OpenJDK JVM

To be able to run Java programs, you can install Java runtime with the
package jre7-openjdk, available in the official repositories. There is
also a Java Development Kit in jdk7-openjdk. As of March 2013 openjdk6
is no longer available.

You will likely need the icedtea-web-java7 package for Java
functionality in browsers, namely applets and Web Start (for more
details see Browser Plugins#Java (IcedTea)).

Flagging OpenJDK packages as out-of-date

Please flag packages jre7-openjdk-headless, jre7-openjdk and
jdk7-openjdk as out-of-date based on their IcedTea version (2.3.4)
rather than on their Oracle version (u9). IcedTea-web projects (packages
icedtea-web and icedtea-web-java7) have version numbers that are
independant from the IcedTea one (packages jre7-openjdk-headless,
jre7-openjdk and jdk7-openjdk) so please flag each package based on its
right version number.

> Oracle JVM

Prior to the retirement of the Oracle DLJ, it was possible to simply
install the jre and jdk packages from the repositories. However, now
Arch Linux (and any other GNU/Linux distribution) can no longer package
the Oracle implementation of Java. The OpenJDK packages are the
recommended providers of java-runtime and java-environment.

> Oracle JVM (Java 6)

AUR contains package for jre6 and jdk6, which are the Oracle
implementations of Java SE 6. These packages conflict with the other
java packages, so there are also jre6-compat and jdk6-compat which can
be used along side other java installations.

> Kaffe (Discontinued)

Kaffe is another clean-room implementation of a Java VM without official
endorsement from Sun/Oracle. A git package of Kaffe can be found in the
AUR here: kaffe-git. The Kaffe VM is redistributed according to the GPL
license.

> BEA JRockit JIT JVM (+JDK)

JRockit is JIT version of Java, provided by Oracle and available from
the AUR here: jrockit.

> VMkit LLVM-based JIT VM

VMkit is an LLVM-based framework for JIT virtual machines. J3 is a JVM
running on VMkit. The webpage can be found here: [vmkit]. J3 depends on
the GNU classpath libraries, but may also work with the Apache class
path libraries.

> Parrot VM

The Parrot VM offers experimental support for Java through two different
methods: Either as a Java VM bytecode translator or as a Java compiler
targeting the Parrot VM. Available in the AUR package parrot-git.

Troubleshooting
---------------

> MySQL

Due to the fact that the JDBC-drivers often use the port in the URL to
establish a connection to the database, it is considered "remote" (i.e.,
MySQL does not listen to the port as per its default settings) despite
the fact that they are possibly running on the same host, Thus, to use
JDBC and MySQL you should enable remote access to MySQL, following
instructions in MySQL article.

> Java sound with Pulseaudio

Note:This procedure is likely to be relevant for previous version of
Java (Java 6) only.

By default, Java and Pulseaudio do not get along very well with each
other, but this is easy to fix using padsp.

(These paths are correct for Sun's Java, you will need to change the
paths for OpenJDK)

First, rename the java binary to java.bin

    # mv /opt/java/jre/bin/java /opt/java/jre/bin/java.bin

Then, create a new launcher script at /opt/java/jre/bin/java

    #!/bin/sh
    padsp /opt/java/jre/bin/java.bin "$@"

Finally, make the launcher script executable

    # chmod +x /opt/java/jre/bin/java

You will need to redo this process on each update of Java.

You can also try replacing padsp with aoss, which can also fix it under
standard ALSA as well as in Pulse, do what works best. I must warn
everyone that these hacks sometimes work perfect, but are sometimes very
unstable as well.

> Impersonate Another Window Manager

You may use the wmname from suckless.org to make the JVM believe you are
running a different window manager. This may solve a rendering issue of
Java GUIs occuring in window managers like Awesome or Dwm.

    $ wmname LG3D

(You must restart the application in question after issuing the wmname
command.)

This works because the JVM contains a hard-coded list of known
non-re-parenting window managers. For maximum irony, many users prefer
to impersonate “LG3D,” the non-re-parenting window manager written by
Sun, in Java.

> Fonts are Illegible

In addition to the suggestions mentioned below in [tips and tricks] some
fonts may still not be legible afterwards. If this is the case there is
a good chance ms-fonts are being used. Install ttf-ms-fonts from the
AUR.

Tips and tricks
---------------

Note:Suggestions in this section are applicable to all applications,
using explicitly installed (external) Java runtime. Some applications
are bundled with own (private) runtime or use own mechanics for GUI,
font rendering, etc., so none of written below is guaranteed to work.

Behavior of most Java applications can be controlled by supplying
predefined variables to Java runtime. From this forum post, a way to do
it consists of adding the following line in your ~/.bashrc (or
/etc/profile.d/jre.sh to affect all users):

    export _JAVA_OPTIONS="-D<option 1> -D<option 2>..."

For example, to use system anti-aliased fonts and make swing use the GTK
look and feel:

    export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'

> Better font rendering

Both closed source and open source implementations of Java are known to
have improperly implemented anti-aliasing of fonts. This can be fixed
with the following options: awt.useSystemAAFontSettings=on,
swing.aatext=true

> GTK LookAndFeel

If your Java programs look ugly, you may want to set up the default look
and feel for the swing components:
-Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel.

Some stubborn Java programs insist on using the cross platform Metal
look and feel. In some of these cases you can force these apps to use
the GTK look and feel by setting the following property:

-Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel.

> Symlinks change

Typically, OpenJDK installation creates symlinks in /usr/bin for java,
javac ... etc. If you want to change these symlinks to any other JDK
(e.g. if you installed environment-compat packages of Oracle JDK), this
script might be handy for you.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Java&oldid=255866"

Category:

-   Programming language
