Eclipse
=======

Eclipse is an open source community project, which aims to provide a
universal development platform. The Eclipse project is most widely known
for its cross-platform integrated development environment (IDE). The
Arch Linux packages (and this guide) relate specifically to the IDE.

The Eclipse IDE is largely written in Java but can be used to develop
applications in a number of languages, including Java, C/C++, PHP, Perl
and Python. The IDE can also provide subversion support (see below) and
task management (either through its built-in TODO list or through the
eclipse-mylyn package).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Plugins                                                            |
|     -   2.1 C/C++ support                                                |
|         -   2.1.1 Eclipse CDT                                            |
|                                                                          |
|     -   2.2 Perl support                                                 |
|         -   2.2.1 EPIC                                                   |
|                                                                          |
|     -   2.3 PHP support                                                  |
|         -   2.3.1 Eclipse PDT                                            |
|         -   2.3.2 PHPEclipse                                             |
|         -   2.3.3 Aptana PHP                                             |
|                                                                          |
|     -   2.4 Python support                                               |
|         -   2.4.1 PyDev                                                  |
|                                                                          |
|     -   2.5 Web development (HTML, CSS, JavaScript...)                   |
|         -   2.5.1 Aptana Studio                                          |
|                                                                          |
|     -   2.6 Subversion support                                           |
|         -   2.6.1 Subclipse                                              |
|         -   2.6.2 Eclipse Subversive                                     |
|                                                                          |
|     -   2.7 Git support                                                  |
|         -   2.7.1 EGit                                                   |
|                                                                          |
|     -   2.8 Mercurial support                                            |
|         -   2.8.1 MercurialEclipse                                       |
|                                                                          |
|     -   2.9 LaTeX support                                                |
|         -   2.9.1 TeXlipse                                               |
|                                                                          |
| -   3 Updates                                                            |
| -   4 Enable javadoc integration                                         |
|     -   4.1 Online Version                                               |
|     -   4.2 Offline Version                                              |
|                                                                          |
| -   5 Troubleshooting                                                    |
|     -   5.1 Autocompletion and javadoc render crash                      |
|     -   5.2 Crash on first boot or when choosing "Help -> Welcome"       |
|     -   5.3 Ctrl+X closes Eclipse                                        |
|     -   5.4 Eclipse 4.2.0 not respecting dark/custom gtk themes          |
|         resulting in white background                                    |
|     -   5.5 Tooltips have dark background color with Gnome 3.6 Adwaita   |
|         theme                                                            |
|     -   5.6 Toggle buttons states are the same for selected/not selected |
+--------------------------------------------------------------------------+

Installation
------------

It is very easy to install the Eclipse SDK in Arch Linux, just install
the eclipse package from the official repositories.

This base package has Java development support built in.

Plugins
-------

There are two methods to install plugins for Eclipse:

-   using pacman to install plugins packaged in Arch repositories (see
    Eclipse plugin package guidelines for further informations);
-   using Eclipse's plugin manager to download and install plugins from
    their original repositories; in this case you have to find the
    needed repository in the plugin's website, then go to Help ->
    Install New Software..., enter the repository in the Work with
    field, select the plugin to install from the list below and follow
    the instructions. Make sure that you first add the default update
    site for your installed version of Eclipse so that plugin
    dependencies can automatically be installed. The most current
    version of Eclipse is Juno and the default update site for Juno is:
    http://download.eclipse.org/releases/juno

Warning:

-   If you install plugins with Eclipse's plugin manager, you are
    advised to launch Eclipse as root: this way the plugins will be
    installed in /usr/share/eclipse/plugins/; if you installed them as
    normal user, they would be stored in a version-dependent folder
    inside ~/.eclipse/, and, after upgrading Eclipse, they wouldn't be
    recognized any longer.
-   Do not use Eclipse as root for your everyday work.

> C/C++ support

Eclipse CDT

-   Project homepage: http://www.eclipse.org/cdt/
-   Package in [extra]: eclipse-cdt

> Perl support

EPIC

-   Project homepage: http://www.epic-ide.org/
-   Package in AUR: eclipse-epic

> PHP support

Eclipse PDT

-   Project homepage: http://www.eclipse.org/pdt/
-   Instructions for the Eclipse plugin version:
    http://wiki.eclipse.org/PDT/Installation
-   Package in AUR: eclipse-pdt

PHPEclipse

-   Project homepage: http://www.phpeclipse.com/
-   Package in AUR: eclipse-phpeclipse

Aptana PHP

See Aptana Studio further down.

> Python support

PyDev

-   Project homepage: http://pydev.org/
-   Package in AUR: eclipse-pydev

> Web development (HTML, CSS, JavaScript...)

Aptana Studio

-   Project homepage: http://www.aptana.org/
-   For the Eclipse plugin version, use Eclipse's plugin manager
-   For the standalone version, there is a package in AUR: aptana-studio

> Subversion support

Subclipse

-   Project homepage: http://subclipse.tigris.org/
-   Package in AUR: eclipse-subclipse
-   How to use Subversion with Eclipse

Eclipse Subversive

-   Project homepage: http://www.eclipse.org/subversive/
-   Package in AUR: eclipse-subversive

> Git support

EGit

-   Project homepage: http://www.eclipse.org/egit
-   Eclipse Update Link: http://download.eclipse.org/egit/updates
-   Package in AUR: eclipse-egit

> Mercurial support

MercurialEclipse

-   Project homepage:
    http://code.google.com/a/eclipselabs.org/p/mercurialeclipse/
-   Eclipse Update Link:
    http://mercurialeclipse.eclipselabs.org.codespot.com/hg.wiki/update_site/stable
-   Package in AUR: eclipse-mercurial

> LaTeX support

TeXlipse

-   Project homepage: http://texlipse.sourceforge.net/
-   Eclipse Update Link: http://texlipse.sourceforge.net

Updates
-------

-   Eclipse and the plugins installed with pacman are obviously updated
    with pacman itself.
-   For plugins installed with Eclipse's plugin manager, run Eclipse and
    select Help -> Check for Updates (if you have installed them as root
    as advised in the section above, you have to run Eclipse as root).

For plugins to be updated, you should check to have their update
repositories enabled in Window -> Preferences -> Install/Update ->
Available Software Sites: you can find each plugin's repository(es) on
the respective project website. To add, edit, remove... repositories
just use the buttons on the right of the Available Software Sites panel.
For Eclipse 4.2 (Juno), check you have enabled this repository:

    http://download.eclipse.org/releases/juno

To receive update notifications, go to Window -> Preferences ->
Install/Update -> Automatic Updates. If you want to receive
notifications for plugins installed as root, you should run Eclipse as
root, go to Window -> Preferences -> Install/Update -> Available
Software Sites, select the repositories related to the installed plugins
and Export them; then run Eclipse as normal user and Import them in the
same panel.

Enable javadoc integration
--------------------------

Want to see API entries when hovering the mouse pointer over standard
Java methods?

> Online Version

If you have constant internet access on your machine, you can use the
on-line documentation provided by sun. Just follow these instructions:

1.  Go to Window/Preferences, then go to Java/Installed JREs.
2.  There should be one named "java" with the type "Standard VM". Select
    this and click Edit.
3.  Select the /opt/java/jre/lib/rt.jar item under "JRE system
    libraries:", then click "Javadoc Location...".
4.  Enter "http://java.sun.com/javase/6/docs/api/" in the "Javadoc
    location path:" text field.
5.  Done!

> Offline Version

If you have no internet connection on your development machine or do not
want to constantly consume bandwidth for the documentation, you can
store the documentation locally, by installing the openjdk[version]-src
package. Eclipse should find the javadocs automatically.

Troubleshooting
---------------

> Autocompletion and javadoc render crash

For some reason, libxul may crash Eclipse with a Traceback like

    # Problematic frame:
    # C  [libxul.so+0xd07552]  NS_InvokeByIndex_P+0x5e9a

To fix this issue, you can try installing libwebkit and adding the
following lines in your /usr/share/eclipse/eclipse.ini:

    -Dorg.eclipse.swt.browser.UseWebKitGTK=true

If that does not work (or if you do not want to use libwebkit) try this:

1. Download
http://ftp.mozilla.org/pub/mozilla.org/xulrunner/releases/1.9.0.17/runtimes/xulrunner-1.9.0.17.en-US.linux-i686.tar.bz2

2. Unpack it into /home/<Username>/.xulrunner (or another location)

3. Add this line to your Eclipse configuration file
/usr/share/eclipse/eclipse.ini:

    -Dorg.eclipse.swt.browser.XULRunnerPath=/home/<Username>/.xulrunner

Now everything should just work fine and tooltips should display
correctly.

> Crash on first boot or when choosing "Help -> Welcome"

See above.

> Ctrl+X closes Eclipse

Part of this bug. Just look in
~/workspace/.metadata/.plugins/org.eclipse.e4.workbench/workbench.xmi
and delete the wrong Ctrl+X combination. Usually it is the first one.

> Eclipse 4.2.0 not respecting dark/custom gtk themes resulting in white background

Remove or move to backup sub folder all of the .css files from:
/usr/share/eclipse/plugins/org.eclipse.platform_4.2.0.v201206081400/css/

Solution source: http://www.eclipse.org/forums/index.php/m/872214/

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

Retrieved from
"https://wiki.archlinux.org/index.php?title=Eclipse&oldid=245292"

Category:

-   Development
