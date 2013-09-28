Default Applications
====================

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: It would be good 
                           to have detailed         
                           explanations for other   
                           DEs as well. (Discuss)   
  ------------------------ ------------------------ ------------------------

There are numerous places to configure default applications on Linux.
This page will attempt to address problems related to the following
issues:

-   You need to change a certain default application (e.g. after
    switching desktop environments), but there appears to be nowhere to
    configure it, or an application ignores your configuration
-   You regularly switch back and forth between several desktop
    environments, and need to configure some applications (e.g. file
    manager) on a per-desktop-environment basis, but need to configure
    others (e.g. web browser) globally

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Changing a default application                                     |
|     -   1.1 xdg-open                                                     |
|         -   1.1.1 Exactly how it works                                   |
|         -   1.1.2 How it should work                                     |
|                                                                          |
|     -   1.2 Gnome 3                                                      |
|         -   1.2.1 GConf                                                  |
|         -   1.2.2 Terminal                                               |
|         -   1.2.3 Web browser                                            |
|                                                                          |
| -   2 Custom File Associations                                           |
| -   3 Maintaining settings for multiple desktop environments             |
| -   4 Troubleshooting                                                    |
|     -   4.1 Applications don't appear in the Open With... context menu   |
|         (of a file manager)                                              |
+--------------------------------------------------------------------------+

Changing a default application
------------------------------

> xdg-open

xdg-open is a desktop-independent tool for configuring default
applications.

Exactly how it works

This is currently very shaky because the standard in question (relevant
freedesktop.org document, "Default application ordering" section) is
still not finalised and it is even less correctly implemented.

What happens with the current version of xdg-open (extra/xdg-utils
1.1.0rc1-3) is the following: xdg-open uses xdg-mime (among other
things; if you use a mainstream DE like GNOME, KDE or LXDE, xdg-open
might try using their specific tools before xdg-mime) to find the MIME
type of the file that is to be opened and the default application
associated with that MIME type. xdg-mime looks for the default
application in the following files:

    /usr/share/applications/defaults.list      (global)
    ~/.local/share/applications/defaults.list  (per user, overrides global)

The syntax of these files is:

    [Default Applications]
    mimetype=desktopfile1;desktopfile2;...;desktopfileN

E.g.

    [Default Applications]
    text/html=firefox.desktop;chromium.desktop

The intent is to be able to specify applications in order of preference
so the next would be selected if the previous is unavailable. However,
xdg-open is currently broken and specifying more than one application
for a single MIME type will result in none being used. Be sure to
specify only one application per MIME type.

Also see xdg-open for more information on what affects its behaviour.
This information is sufficient for a user to configure default
applications on Arch currently.

How it should work

However, the behaviour described in the previous section is actually
wrong according to the quoted standard draft. defaults.list should only
be used by distributions/DEs to specify sane defaults for that
particular environment. This file should only be placed in
/usr/share/applications/, it should be a system-wide setting and it
should not be changed by users. Instead, users should use the files
/usr/share/applications/mimeapps.list (global) and
~/.local/share/applications/mimeapps.list (per user, overrides global)
to specify custom file associations. The syntax of these files is as
follows:

    mimeapps.list

    [Added Associations]
    mimetype=desktopfile1;desktopfile2;...;desktopfileN
    ...
    [Removed Associations]
    mimetype=desktopfile1;desktopfile2;...;desktopfileN

The [Added Associations] section is used to specify preferred (default)
applications in decreasing order of preference for the specified MIME
type. The [Removed Associations] section is used to explicitly remove
any previously inherited associations.

Note that the upstream, yet unreleased xdg-utils were fixed to use
mimeapps.list instead of defaults.list but the xdg-open bug (specifying
multiple applications breaks it completely) still remains.

Currently, the best option is to use mimeo, which implements everything
explained above correctly. There is also xdg-utils-mimeo which provides
a patched xdg-open to use mimeo. Both are available in AUR.

> Gnome 3

The xdg-open settings are usually recognized by Gnome, but if they
aren't, there are still other methods.

GConf

As far as I can tell, on Gnome 3, there are two configuration systems,
GConf (older) and dconf (newer). GConf can be configured with
gconf-editor; in particular, you can try messing with the
/desktop/gnome/applications/ key, but changing settings there didn't fix
any problems I had. dconf can be configured with the gsettings command.

Terminal

To configure the default terminal for the package nautilus-open-terminal
to Konsole, use

    $ gsettings set org.gnome.desktop.default-applications.terminal exec konsole
    $ gsettings set org.gnome.desktop.default-applications.terminal exec-arg "'-e'"

The second command tells konsole to expect a command to be passed to it
as part of the invocation. nautilus-open-terminal needs this because it
passes a cd command in order to switch to the appropriate directory. For
example, opening a terminal in your ~/Desktop directory will invoke
something like

    $ konsole -e cd "~/Desktop"

Web browser

To configure the web browser used by the AUR package
gnome-gmail-notifier, run

    $ gconf-editor

and edit the /desktop/gnome/url-handlers/http/ key. You may want to
change https/, about/, and unknown/ keys while you're at it.

Custom File Associations
------------------------

The following method creates a custom mime type and file association
manually. This is useful if your desktop does not have a mime type/file
association editor installed. In this example, a fictional multimedia
application 'foobar' will be associated with all '*.foo' files. This
will be done a per user basis (as opposed to system-wide).

-   First, create the file
    ~/.local/share/mime/packages/application-x-foobar.xml:

    $ mkdir -p ~/.local/share/mime/packages
    $ cd ~/.local/share/mime/packages
    $ touch application-x-foobar.xml

-   Then edit ~/.local/share/mime/packages/application-x-foobar.xml and
    add this text:

    <?xml version="1.0" encoding="UTF-8"?>
    <mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
    	<mime-type type="application/x-foobar">
    		<comment>foo file</comment>
    		<icon name="application-x-foobar"/>
    		<glob-deleteall/>
    		<glob pattern="*.foo"/>
    	</mime-type>
    </mime-info>

Note that you can use any icon, including one for another application.

-   Next, edit or create the file
    ~/.local/share/applications/foobar.desktop to contain something
    like:

    [Desktop Entry]
    Name=Foobar
    Exec=/usr/bin/foobar
    MimeType=application/x-foobar
    Icon=foobar
    Terminal=false
    Type=Application
    Categories=AudioVideo;Player;Video;
    Comment=

Note that Categories should be set appropriately for the application
type (in this example, a multimedia app).

-   Now update the mime database with:

    $ update-mime-database ~/.local/share/mime

Programs that use mime types, such as file managers, should now open
'*.foo' files with foobar. (You may need to restart your file manager to
see the change.)

Maintaining settings for multiple desktop environments
------------------------------------------------------

The OnlyShowIn field of a .desktop file may be useful; see this page. I
haven't tried setting this field yet; please update this wiki page if
you have any info about using OnlyShowIn.

Troubleshooting
---------------

> Applications don't appear in the Open With... context menu (of a file manager)

Sometimes, a certain application will not appear in the right-click Open
With... dialog. To fix this problem, locate the .desktop file in
/usr/share/applications, edit it as root, and add %U to the end of the
Exec= line. For example, Kile currently has this problem; you need to
edit /usr/share/applications/kde4/kile.desktop and change the line
reading Exec=kile to read Exec=kile %U. Also, please file a bug against
the upstream project if you notice this problem.

You may also have to edit the MimeTypes list in the .desktop file if you
install extensions that allow an application to handle additional MIME
types.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Default_Applications&oldid=253464"

Category:

-   Desktop environments
