Java
====

Related articles

-   Java Package Guidelines

"Java is a programming language originally developed by Sun Microsystems
and released in 1995 as a core component of Sun Microsystems' Java
platform. The language derives much of its syntax from C and C++ but has
a simpler object model and fewer low-level facilities. Java applications
are typically compiled to bytecode that can run on any Java virtual
machine (JVM) regardless of computer architecture." — Wikipedia article

Contents
--------

-   1 Installation
    -   1.1 OpenJDK
        -   1.1.1 Flagging packages as out-of-date
    -   1.2 Oracle Java SE
        -   1.2.1 Java SE 6
        -   1.2.2 JDK-compat
    -   1.3 Oracle JRockit
    -   1.4 VMkit
    -   1.5 Parrot VM
-   2 Troubleshooting
    -   2.1 MySQL
    -   2.2 Java sound with PulseAudio
    -   2.3 Impersonate another window manager
    -   2.4 Illegible fonts
-   3 Tips and tricks
    -   3.1 Better font rendering
    -   3.2 GTK LookAndFeel
    -   3.3 Symlinks change

Installation
------------

The only supported JVM implementation in Arch Linux is the open source
OpenJDK. It is nearly perfect, and it should not be necessary to install
Oracle's proprietary version of Java. If you want to install Oracle Java
alongside OpenJDK, see #JDK-compat.

Note:After installation, the Java environment will need recognized by
the shell ($PATH variable and $JAVA_HOME). This can be done from the
command line by sourcing /etc/profile, and for Desktop Environments it
is likely a logout/login will be necessary.

> OpenJDK

The OpenJDK Java runtime environment (JRE) can be installed with the
package jre7-openjdk, available in the official repositories. There is
also a Java development kit (JDK) available with the package
jdk7-openjdk. Sources are available with the package openjdk7-src.

If you want Java functionality in browsers (Java applets and Java Web
Start), install icedtea-web-java7. For more details see Browser
plugins#Java (IcedTea).

Flagging packages as out-of-date

-   jre7-openjdk, jdk7-openjdk and jre7-openjdk-headless should be
    flagged as out-of-date based on the IcedTea version (e.g. 2.4.3),
    rather than on their Oracle version (e.g. u45).
-   icedtea-web-java7 should be flagged as out-of-date based on the
    IcedTea Web version (e.g. 1.4.1). This is independent of the IcedTea
    version.

> Oracle Java SE

The Oracle implementations of JRE and JDK are available in the AUR: jre
and jdk.

Java SE 6

The AUR contains jre6 and jdk6, which are the Oracle implementations of
Java SE 6.

JDK-compat

The Oracle JDK (6 and 7) can also be installed in parallel with another
Java installation (for example OpenJDK). The packages can be found in
the AUR: jdk6-compat and jdk7-compat.

> Oracle JRockit

JRockit is a JIT version of Java, provided by Oracle and available as
jrockit from the AUR.

> VMkit

VMkit is an LLVM-based framework for JIT virtual machines. J3 is a JVM
running on VMkit. The webpage can be found here: vmkit. J3 depends on
the GNU classpath libraries, but may also work with the Apache class
path libraries.

> Parrot VM

Parrot is a VM that offers experimental support for Java through two
different methods: Either as a Java VM bytecode translator or as a Java
compiler targeting the Parrot VM. parrot is available in the official
repositories and parrot-git in the AUR.

Troubleshooting
---------------

> MySQL

Due to the fact that the JDBC-drivers often use the port in the URL to
establish a connection to the database, it is considered "remote" (i.e.,
MySQL does not listen to the port as per its default settings) despite
the fact that they are possibly running on the same host, Thus, to use
JDBC and MySQL you should enable remote access to MySQL, following
instructions in MySQL article.

> Java sound with PulseAudio

Note:This procedure is likely to be relevant for previous version of
Java (Java 6) only.

By default, Java and PulseAudio do not get along very well with each
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
everyone that these hacks sometimes work perfectly, but are sometimes
very unstable as well.

> Impersonate another window manager

You may use the wmname from suckless.org to make the JVM believe you are
running a different window manager. This may solve a rendering issue of
Java GUIs occurring in window managers like Awesome or Dwm.

    $ wmname LG3D

You must restart the application in question after issuing the wmname
command.

This works because the JVM contains a hard-coded list of known,
non-re-parenting window managers. For maximum irony, some users prefer
to impersonate LG3D, the non-re-parenting window manager written by Sun,
in Java.

> Illegible fonts

In addition to the suggestions mentioned below in
#Better_font_rendering, some fonts may still not be legible afterwards.
If this is the case, there is a good chance Microsoft fonts are being
used. Install ttf-ms-fonts from the AUR.

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
swing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel.

Some stubborn Java programs insist on using the cross platform Metal
look and feel. In some of these cases you can force these apps to use
the GTK look and feel by setting the following property:

swing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel.

> Symlinks change

Typically, OpenJDK installation creates symlinks in /usr/bin for java,
javac ... etc. If you want to change these symlinks to any other JDK
(e.g. if you installed environment-compat packages of Oracle JDK), this
script might be handy for you.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Java&oldid=305944"

Category:

-   Programming language

-   This page was last modified on 20 March 2014, at 17:29.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
