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

Contents
--------

-   1 Installation
-   2 Tips and tricks
    -   2.1 Font antialiasing in Netbeans
        -   2.1.1 Netbeans Specifically
        -   2.1.2 Java Generally
    -   2.2 Look and feel
-   3 Integrate with tomcat
-   4 Troubleshooting
    -   4.1 OpenJDK vs Sun's JDK
    -   4.2 Glassfish server - Can`t download Glassfish server I/O
        Exception
    -   4.3 Netbeans doesn't start after its first start
    -   4.4 Netbeans starts with a completely grey window
    -   4.5 Integrate Netbeans with kwallet

Installation
------------

Install the netbeans package which is available in the official
repositories.

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

> Look and feel

To change Netbeans look and feel, add switch --laf yourLookAndFeel to
IDE command line by appending it to ‘netbeans_default_options’ section
of /usr/share/netbeans/etc/netbeans.conf or editing .desktop file with
which you launch Netbeans.

For GTK: --laf com.sun.java.swing.plaf.gtk.GTKLookAndFeel

For Nimbus: --laf com.sun.java.swing.plaf.nimbus.NimbusLookAndFeel

Integrate with tomcat
---------------------

It is possible to debug web applications running on tomcat within
netbeans:

First install, tomcat.

You will need to create a configuration and deployment folder for your
user, for example in /home/USER_NAME/.tomcat7

Copy /etc/tomcat7/ in /home/USER_NAME/.tomcat7/conf and check that you
give read/write access to your user.

    # sudo cp -r /etc/tomcat7/ /home/USER_NAME/.tomcat7/conf
    # sudo chown -R USER_NAME:USER_NAME /home/USER_NAME/.tomcat7/conf

Make sure to configure /home/USER_NAME/.tomcat7/conf/tomcat-users.xml
with a user having tomcat admin permissions so that netbeans can deploy
applications.

Copy /var/lib/tomcat7/webapps in /home/USER_NAME/.tomcat7/webapps

  

Then, in netbeans go to Tools>Servers>Add Server and select Apache
Tomcat.

In server location specify /usr/share/tomcat7

Check "Use Private Configuration Folder (Catalina Base)" and specify
/home/USER_NAME/.tomcat7

Finally, set the username and password you configured in
/etc/tomcat7/tomcat-users.xml

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

> Integrate Netbeans with kwallet

Netbeans may need to store some passwords. It can do that in kwallet.
See netbeans' wiki [[1]]

However, you need to install and configure qtchooser so that netbeans
find the qdbus command:

    $ pacman -S qtchooser
    $ ln -sf /etc/xdg/qtchooser/4.conf /etc/xdg/qtchooser/default.conf

See forum discussion [[2]]

Retrieved from
"https://wiki.archlinux.org/index.php?title=Netbeans&oldid=305523"

Category:

-   Development

-   This page was last modified on 18 March 2014, at 19:36.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
