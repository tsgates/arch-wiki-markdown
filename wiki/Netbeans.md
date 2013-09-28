Netbeans
========

Netbeans is an integrated development environment (IDE) for developing
with Java, JavaScript, PHP, Python, Ruby, Groovy, C, C++, Scala,
Clojure, and other languages.

From Wikipedia article:

"The NetBeans IDE is written in Java and can run anywhere a compatible
JVM is installed, including Windows, Mac OS, Linux, and Solaris. A JDK
is required for Java development functionality, but is not required for
development in other programming languages."

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Tips and tricks                                                    |
|     -   1.1 Font antialiasing in Netbeans                                |
|         -   1.1.1 Netbeans Specifically                                  |
|         -   1.1.2 Java Generally                                         |
|                                                                          |
|     -   1.2 GTK look and feel                                            |
|                                                                          |
| -   2 Troubleshooting                                                    |
|     -   2.1 OpenJDK vs Sun's JDK                                         |
|     -   2.2 Glassfish server - Can`t download Glassfish server I/O       |
|         Exception                                                        |
|     -   2.3 Netbeans doesn't start after its first start                 |
|     -   2.4 Netbeans starts with a completely grey window                |
+--------------------------------------------------------------------------+

Tips and tricks
---------------

Note:The global netbeans.conf /usr/share/netbeans/etc/netbeans.conf will
be overwritten during updates. To keep changes add them to your local
netbeans.conf ~/.netbeans/<ver>/etc/netbeans.conf (you will need to
create the etc dir and the .conf file).

-   Settings in local version of netbeans.conf override the same
    settings in the global copy of the file.
-   Command-line options override settings in either of the
    configuration files.

> Font antialiasing in Netbeans

Netbeans Specifically

Add -J-Dswing.aatext=TRUE -J-Dawt.useSystemAAFontSettings=on to the
'netbeans_default_options' line of your netbeans.conf file.

Java Generally

See Java#Better font rendering.

> GTK look and feel

To change Netbeans look and feel to GTK add switch
--laf com.sun.java.swing.plaf.gtk.GTKLookAndFeel to IDE command line by
appending it to ‘netbeans_default_options’ section of
/usr/share/netbeans/etc/netbeans.conf or editing .desktop file with
which you launch Netbeans.

Troubleshooting
---------------

> OpenJDK vs Sun's JDK

Netbeans 7.0-1 will not ALWAYS work with OpenJDK. Some reported issues
are:

-   Starting - In some cases, netbeans will not start.
-   Installation - The .sh script provided by netbeans will not launch
    wizard (any proofs?).
-   JavaFX module does not work (see FS#29843).

> Glassfish server - Can`t download Glassfish server I/O Exception

If you are trying add new Glassfish server, you can`t download the
server. Netbeans returns

    I/O Exception: http://java.net/download/glassgish/3.0.1/release/glassfish-3.0.1-ml.zip

Solution is:

-   Download GlassFish Server Open Source Edition manualy from official
    site, actual link is
    http://download.java.net/glassfish/3.0.1/release/glassfish-3.0.1-ml.zip
-   Extract from zip to any location

> Netbeans doesn't start after its first start

If you receive a message like this when executing from terminal:

    # netbeans -h

     Exception in thread "main" java.lang.UnsatisfiedLinkError: /usr/lib/jvm/java-6-openjdk/jre/lib/i386/libsplashscreen.so: libgif.so.4: cannot open shared object file: No such file or directory

You have two options:

-   You can start Netbeans using the --nosplash option:

    # netbeans --nosplash

-   Or, install the missing library (libungif), then starting Netbeans
    as usual will work.

Arch forum thread

> Netbeans starts with a completely grey window

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: most likely      
                           fixed in current         
                           versions of OpenJDK      
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

See Java#Impersonate Another Window Manager

This may not be quite 100% out of date; the problem occurred while using
NetBeans 7.2, OpenJDK 7.u7_2.3.2-2, "$ java -version" reporting
1.7.0_07. The following is robbed from Awesome's wiki (although I
experienced the problem using Xmonad), which fixed my all-grey window
problem:

    $ _JAVA_AWT_WM_NONREPARENTING=1; export _JAVA_AWT_WM_NONREPARENTING

Retrieved from
"https://wiki.archlinux.org/index.php?title=Netbeans&oldid=233791"

Category:

-   Development
