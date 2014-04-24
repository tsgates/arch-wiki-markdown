Eclipse
=======

Eclipse is an open source community project, which aims to provide a
universal development platform. The Eclipse project is most widely known
for its cross-platform integrated development environment (IDE). The
Arch Linux packages (and this guide) relate specifically to the IDE.

The Eclipse IDE is largely written in Java but can be used to develop
applications in a number of languages, including Java, C/C++, PHP, Perl
and Python. The IDE can also provide subversion support and task
management.

Contents
--------

-   1 Installation
    -   1.1 Eclipse for Java
-   2 Plugins
    -   2.1 Add the default update site
    -   2.2 Eclipse Marketplace
    -   2.3 Plugin manager
        -   2.3.1 Updates via plugin manager
    -   2.4 List of plugins
-   3 Enable javadoc integration
    -   3.1 Online version
    -   3.2 Offline version
-   4 Troubleshooting
    -   4.1 Crash on first boot or when choosing Help > Welcome
    -   4.2 Ctrl+X closes Eclipse
    -   4.3 Eclipse 4.2.0 not respecting dark/custom gtk themes
        resulting in white background
    -   4.4 Tooltips have dark background color with Gnome 3.6 Adwaita
        theme
    -   4.5 Toggle buttons states are the same for selected/not selected
    -   4.6 Change Default Window Title Font Size
-   5 See also

Installation
------------

Install the eclipse package from the official repositories. This base
package has Java development support built in.

> Eclipse for Java

The Eclipse IDE for Java Developers can be installed with the
eclipse-java package from AUR.

Plugins
-------

Many plugins are easily installed using pacman (see Eclipse plugin
package guidelines for further informations). This will also keep them
up-to-date. Alternatively, you can choose either the Eclipse Marketplace
or the internal plugin manager.

> Add the default update site

Make sure that you check that the default update site for your version
of Eclipse is configured so that plugin dependencies can automatically
be installed. The most current version of Eclipse is Kepler and the
default update site for Kepler is:
http://download.eclipse.org/releases/kepler. Go to Help > Install new
Software > Add, fill the name to easily identify the update site later -
for instance, Kepler Software Repository - and fill the location with
the url.

> Eclipse Marketplace

Note:make sure you've followed the Add the default update site section.

To use the Eclipse Marketplace, first you need to install it (hey, that
feels familiar. I wonder why?). Go to Help > Install new software >
switch to the default update site > General Purpose Tools > Marketplace
Client. Restart Eclipse and it will be available in Help > Eclipse
Marketplace.

> Plugin manager

Note:make sure you've followed the Add the default update site section.

Use Eclipse's plugin manager to download and install plugins from their
original repositories: in this case you have to find the needed
repository in the plugin's website, then go to Help > Install New
Software..., enter the repository in the Work with field, select the
plugin to install from the list below and follow the instructions.

> Note:

-   If you install plugins with Eclipse's plugin manager, you are
    advised to launch Eclipse as root: this way the plugins will be
    installed in /usr/share/eclipse/plugins/; if you installed them as
    normal user, they would be stored in a version-dependent folder
    inside ~/.eclipse/, and, after upgrading Eclipse, they wouldn't be
    recognized any longer.
-   Do not use Eclipse as root for your everyday work.

Updates via plugin manager

Run Eclipse and select Help > Check for Updates. If you have installed
them as root as advised in the section above, you have to run Eclipse as
root.

For plugins to be updated, you should check to have their update
repositories enabled in Window > Preferences > Install/Update >
Available Software Sites: you can find each plugin's repository(es) on
the respective project website. To add, edit, remove... repositories
just use the buttons on the right of the Available Software Sites panel.
For Eclipse 4.2 (Juno), check you have enabled this repository:

    http://download.eclipse.org/releases/juno

To receive update notifications, go to Window > Preferences >
Install/Update > Automatic Updates. If you want to receive notifications
for plugins installed as root, you should run Eclipse as root, go to
Window > Preferences > Install/Update > Available Software Sites, select
the repositories related to the installed plugins and Export them, then
run Eclipse as normal user and Import them in the same panel.

> List of plugins

-   AVR — AVR microcontroller plugin.

http://avr-eclipse.sourceforge.net/wiki/index.php/The_AVR_Eclipse_Plugin
|| eclipse-avr

-   Aptana — HTML5/CSS3/JavaScript/Ruby/Rails/PHP/Pydev/Django support.
    Also available as standalone application.

http://www.aptana.com/ || eclipse-aptana aptana-studio

-   Eclipse CDT — C/C++ support.

http://www.eclipse.org/cdt/ || eclipse-cdt

-   Eclipse PDT — PHP support.

http://www.eclipse.org/pdt/ || eclipse-pdt

-   EGit — Git support.

http://www.eclipse.org/egit || eclipse-egit

-   EPIC — Perl support.

http://www.epic-ide.org/ || eclipse-epic

-   IvyDE — IvyDE dependency Manager.

https://ant.apache.org/ivy/ivyde/ || eclipse-ivyde

-   Markdown — Markdown editor plugin for Eclipse.

http://www.winterwell.com/software/markdown-editor.php ||
eclipse-markdown

-   MercurialEclipse — Mercurial support.

https://bitbucket.org/mercurialeclipse/main/wiki/Home ||
eclipse-mercurial

-   Mylyn — Task lists support.

http://www.eclipse.org/mylyn/ || eclipse-mylyn

-   PHPEclipse — Alternative PHP support.

http://www.phpeclipse.com/ || eclipse-phpeclipse

-   PyDev — Python support.

http://pydev.org/ || eclipse-pydev

-   Subclipse — Subversion support.

http://subclipse.tigris.org/ || eclipse-subclipse

-   Subversive — Alternative Subversion support.

http://www.eclipse.org/subversive/ || eclipse-subversive

-   TestNG — TestNG support.

http://testng.org/doc/eclipse.html || eclipse-testng

-   TeXlipse — LaTeX support.

http://texlipse.sourceforge.net/ || texlipse

-   Eclipse PTP — Parallel Programming C/C++ support.

http://www.eclipse.org/ptp/ || eclipse-ptp

Enable javadoc integration
--------------------------

Want to see API entries when hovering the mouse pointer over standard
Java methods?

> Online version

If you have constant Internet access on your machine, you can use the
on-line documentation:

1.  Go to Window > Preferences, then go to Java > Installed JREs.
2.  There should be one named "java" with the type "Standard VM". Select
    this and click Edit.
3.  Select the /opt/java/jre/lib/rt.jar item under "JRE system
    libraries:", then click Javadoc Location....
4.  Enter "http://docs.oracle.com/javase/7/docs/api/" in the "Javadoc
    location path:" text field.

> Offline version

You can store the documentation locally by installing the openjdk7-doc
package. Eclipse may be able to find the javadocs automatically. If that
doesn't work, set Javadoc location for rt.jar to
file:/usr/share/doc/openjdk7-doc/api.

Troubleshooting
---------------

> Crash on first boot or when choosing Help > Welcome

Add the following line to /usr/share/eclipse/eclipse.ini:

    -Dorg.eclipse.swt.browser.UseWebKitGTK=true

If Firefox is installed try also:

    -Dorg.eclipse.swt.browser.DefaultType=mozilla

> Ctrl+X closes Eclipse

Part of this bug. Just look in
~/workspace/.metadata/.plugins/org.eclipse.e4.workbench/workbench.xmi
and delete the wrong Ctrl+X combination. Usually it is the first one.

> Eclipse 4.2.0 not respecting dark/custom gtk themes resulting in white background

Remove or move to backup sub folder all of the .css files from:
/usr/share/eclipse/plugins/org.eclipse.platform_4.2.0.v201206081400/css/

Solution source: http://www.eclipse.org/forums/index.php/m/872214/

This also works with version 4.3.x (Kepler) by backing up the css folder
from /usr/share/eclipse/plugins/org.eclipse.platform_4.3.xxx/css/

> Tooltips have dark background color with Gnome 3.6 Adwaita theme

Comment out the second-to-last line in
/usr/share/themes/Adwaita/gtk-2.0/gtkrc like this

    #widget "gtk-tooltip*"  style "tooltips"

Related bugs:

-   https://bugzilla.gnome.org/show_bug.cgi?id=688285
-   https://bugs.eclipse.org/bugs/show_bug.cgi?id=381010 (WONTFIX)

> Toggle buttons states are the same for selected/not selected

Comment out the last line in /usr/share/themes/Adwaita/gtk-2.0/gtkrc
like this

    #widget "*swt*toolbar*" style "null"

To apply the fixed theme, use gnome-tweak-tool to select a different
theme and cycle back to Adwaita.

Related bugs:

-   https://bugzilla.gnome.org/show_bug.cgi?id=687519

> Change Default Window Title Font Size

You can't change the window title font size using the Eclipse
preferences, you must edit the actual theme .css files. Note, that you
will have to redo this when you upgrade eclipse. They are located under

    /usr/share/eclipse/plugins/org.eclipse.platform_4.3.<your version number>/css

Open the appropriate file with your text editor, ie e4_default_gtk.css
if you are using the "GTK theme". Search for .MPartStack, and change the
font-size to your desired size

    .MPartStack {
           font-size: 9;
           swt-simple: false;
           swt-mru-visible: false;
    }

See also
--------

-   How to use Subversion with Eclipse

Retrieved from
"https://wiki.archlinux.org/index.php?title=Eclipse&oldid=305851"

Category:

-   Development

-   This page was last modified on 20 March 2014, at 13:02.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
