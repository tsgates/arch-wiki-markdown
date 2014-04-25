Uniform Look for Qt and GTK Applications
========================================

Related articles

-   GTK+
-   Qt

Qt and GTK+ based programs both use a different widget toolkit to render
the graphical user interface. Each come with different themes, styles
and icon sets by default, among other things, so the "look and feel"
differ significantly. This article will help you make your Qt and GTK+
applications look similar for a more streamlined and integrated desktop
experience.

To get a similar look between the two you will most likely have to
modify the following:

-   Theme: The custom appearance of an application, widget set, etc. It
    usually consists of a style, an icon theme and a color theme.
-   Style: The graphical layout and look of the widget set.
-   Icon Theme: A set of global icons.
-   Color Theme: A set of global colors that are used in conjunction
    with the style.

You can choose various approaches:

-   Modify GTK+ and Qt styles separately with the tools listed below for
    each toolkit and aim for choosing similarly looking themes (style,
    colors, icons, cursors, fonts).
-   Use a special theme engine, which intermediates the modification of
    the other graphical toolkit to match your main toolkit:
    -   if you work in KDE 4 desktop environment then a GTK-Qt engine is
        available, which updates GTK+ configuration files automatically
        so that GTK+ appearance is similar to the Qt one;
    -   similarly if you work in the Trinity desktop environment a
        GTK-Qt and GTK3-Qt engine is available.
    -   if you work in other desktop environments, you can choose the
        QGtkStyle engine (built in Qt), which forces Qt apps to use your
        GTK+ 2.x theme.

Should you use also GTK+ 3.x toolkit, follow the GTK+ 3.x wiki article
to find out how to make it look similar to GTK+ 2.x themes.

Contents
--------

-   1 Styles for both Qt and GTK+
    -   1.1 KDE4 Oxygen
        -   1.1.1 oxygen-gtk
            -   1.1.1.1 Automatic procedure
            -   1.1.1.2 Manual procedure
        -   1.1.2 Oxygen icons
    -   1.2 QtCurve
    -   1.3 Others
-   2 Changing styles in each toolkit
    -   2.1 Qt5 styles
    -   2.2 Qt4 styles
    -   2.3 Qt3 styles
    -   2.4 GTK+3 styles
    -   2.5 GTK+2 styles
    -   2.6 GTK+1 styles
-   3 Theme engines
    -   3.1 GTK+-Qt engine
    -   3.2 QGtkStyle
-   4 Tips and tricks
    -   4.1 KDE file dialogs for GTK+ applications
    -   4.2 aMSN with GTK+ or KDE dialogs
    -   4.3 Run an application with a specific theme
    -   4.4 Using a GTK+ icon theme in Qt apps
    -   4.5 Improve subpixel rendering of GTK apps under KDE
-   5 Troubleshooting
    -   5.1 gtk-qt-engine does not work with OpenOffice
    -   5.2 Qt applications do not use QGtkStyle
    -   5.3 Themes not working in GTK+ apps

Styles for both Qt and GTK+
---------------------------

There are widget style sets available for the purpose of integration,
where builds are written and provided for both Qt and GTK+, all major
versions included. With these, you can have one look for all
applications regardless of the toolkit they had been written with.

> KDE4 Oxygen

Oxygen is a Qt style that comes by default with KDE4. There are various
ways of mimicking its appearance that are described below.

oxygen-gtk

oxygen-gtk is a port of the Oxygen Qt Style to GTK+ done by the Oxygen
developers. Unlike other attempts, it is a native GTK+ style that does
not depend on Qt (via some Qt to GTK+ conversion engine) nor does it
render widget appearances via hard coded pixmaps. The style has the
primary goal to ensure visual consistency between GTK+ 2.x/3.x and
Qt-based applications running under KDE with a secondary objective to
also have a standalone, nice looking GTK+ theme that behaves well in
other desktop environments.

The style has GTK+ 2.x and GTK+ 3.x variants which can be installed with
the oxygen-gtk2 or oxygen-gtk3 packages, available in the official
repositories.

Note:Before KDE 4.10, you needed to create the file
~/.kde4/share/config/gtkrc-2.0, or let it automatically create like
described below. But that is actually counter-productive with KDE 4.10’s
oxygen-gtk, and you should delete this file after upgrading to prevent
it from messing with your colors. Cleanup-removal of
~/.kde4/share/config/gtkrc might be necessary, too.

Automatic procedure

A few dedicated applications are available in the official repositories
that are able to change the GTK+ theme.

You can also install kde-gtk-config. After installation, it can be found
in System Settings > Application Appearance > GTK Configuration. It
allows you to configure the look and feel for both GTK+ 2.x and GTK+ 3.x
applications and is integrated with the KDE add-on installer (Get Hot
New Stuff), so you can also download and install other GTK+ themes.

Manual procedure

To manually change the GTK+ theme to oxygen-gtk, you need to create the
file ~/.kde4/share/config/gtkrc-2.0 with the following content:

    ~/.kde4/share/config/gtkrc-2.0

     include "/usr/share/themes/oxygen-gtk/gtk-2.0/gtkrc"

     style "user"
     { 
        fg[NORMAL] = "#1b1918"
        bg[NORMAL] = "#d5d1cf"
        text[NORMAL] = "#181615"
        base[NORMAL] = "#ffffff"
        fg[ACTIVE] = "#1b1918"
        bg[ACTIVE] = "#d5d1cf"
        text[ACTIVE] = "#181615"
        base[ACTIVE] = "#ffffff"
        fg[PRELIGHT] = "#1b1918"
        bg[PRELIGHT] = "#d5d1cf"
        text[PRELIGHT] = "#ffffff"
        base[PRELIGHT] = "#43ace8"
        fg[SELECTED] = "#1b1918"
        bg[SELECTED] = "#d5d1cf"
        text[SELECTED] = "#ffffff"
        base[SELECTED] = "#43ace8"
        fg[INSENSITIVE] = "#8d8a88"
        bg[INSENSITIVE] = "#ccc7c5"
        text[INSENSITIVE] = "#a6a5a5"
        base[INSENSITIVE] = "#f4f4f4"
        GtkTreeView::odd_row_color="#ffffff"
        GtkTreeView::even_row_color="#f8f7f6"
     }

     widget_class "*" style "user"

     style "tooltips"
     { 
        bg[NORMAL] = "#bedfff"
        fg[NORMAL] = "#252321"
     }

     widget "gtk-tooltips" style "tooltips"
     #gtk-theme-name="qt4"
     gtk-font-name="Sans Serif 9"
     gtk-icon-theme-name="gk4ico"
     gtk-icon-sizes = "panel-menu=16,16:panel=16,16:gtk-button=22,22:gtk-large-toolbar=22,22"

Then you need to create the symbolic link ~/.kde4/share/config/gtkrc:

    $ ln -s ~/.kde4/share/config/gtkrc-2.0 ~/.kde4/share/config/gtkrc

Oxygen icons

If you are using Oxygen icons and want a consistent look in GTK+
dialogs, you can install the oxygenrefit2-icon-theme icon theme from AUR
and set it as your GTK+ icon theme. To apply the theme you can use
lxappearance (or a similar program) or set it manually by adding the
following line to ~/.kde4/share/config/gtkrc-2.0:

    gtk-icon-theme-name="OxygenRefit2"

Another version of the Oxygen icon theme for GTK+ applications can be
installed with the oxygen-gtk-icons package from AUR.

> QtCurve

QtCurve is a highly popular and configurable set of widget styles for
GTK+ 2.x, Qt4, Qt5 and KDE4. QtCurve can be installed with the packages
from qtcurve group, available in the official repositories. It has many
controls for various options, ranging from the appearance of buttons to
the shape of sliders.

To manually change the GTK+ theme to QtCurve, you need to create the
file ~/.gtkrc-2.0-kde4 with the following content:

    include "/usr/share/themes/QtCurve/gtk-2.0/gtkrc"
    include "/etc/gtk-2.0/gtkrc"

    style "user-font"
    {
        font_name="Sans Serif"
    }
    widget_class "*" style "user-font" 
    gtk-theme-name="QtCurve"

Then you need to create the symbolic link ~/.gtkrc-2.0:

    ln -s .gtkrc-2.0-kde4 .gtkrc-2.0

If you want also specify a font, you can add (and adapt) the following
line to the file:

     gtk-font-name="Sans Serif 9"

> Others

Similar style sets are those that look like each other - written and
provided for both Qt and GTK+ - but are not necessarily from the same
developers. You may have to do some minor tweaking to make them look the
same (e.g. kdestyle-klearlook for Qt4/KDE4 and the Clearlooks GTK+
theme).

Changing styles in each toolkit
-------------------------------

You can use the following methods to change the theme used in each
environment.

> Qt5 styles

Qt5 decides the style to use based on what desktop environment is used.
If it doesn't recognize the desktop environment, it falls back to a
generic style. To force a specific style, you can set the
QT_STYLE_OVERRIDE environment variable. Specifically, set it to gtk if
you want to use the gtk theme. Qt5 applications also support the -style
flag, which you can use to launch a Qt5 application with a specific
style.

> Qt4 styles

Qt4 styles can be changed in a similar way:

-   Using the KDE4 System Settings (systemsettings), the settings can be
    found in Common Appearance and Behavior > Application Appearance >
    Style > Widget Style
-   Using the command-line tool
    $ kwriteconfig --file kdeglobals --group General --key widgetStyle [name of style].
-   Using the Qt Configuration (qtconfig-qt4) application, the settings
    can be found in Appearance > Select GUI Style.

Note that while Qt Configuration allows you to choose the theme, font,
etc. for Qt apps, you can modify more settings with KDE4 System Settings
(e.g. font antialiasing and hinting).

> Qt3 styles

Qt3 styles can be changed in the following ways:

-   Using the KDE3 Control Center (kcontrol), the settings can be found
    in Appearance & Themes > Style > Widget Style.
-   Using the command-line tool kde-config --style [name of style].
-   Using the default Qt Configuration (qt3config) application, the
    settings can be found in Appearance > Select GUI Style.

> GTK+3 styles

Some applications and methods are available to change the GTK+ 3.x
styles:

-   kde-gtk-config — Application that allows you to change style and
    font of GTK+2 and Gtk+3 applications.

https://projects.kde.org/kde-gtk-config || kde-gtk-config

After installation, kde-gtk-config can also be found in System Settings
> Application Appearance > GTK.

-   LXAppearance — Desktop independent GTK+2 and GTK+3 style
    configuration tool from the LXDE project (it does not require other
    parts of the LXDE desktop).

http://wiki.lxde.org/en/LXAppearance || lxappearance

> GTK+2 styles

Various applications and methods are available to change the GTK+ 2.x
styles: (See GTK+3 section above for more.)

-   gtk-kde4 — Application that allows you to change style and font of
    GTK+2 applications in KDE4.

http://kde-look.org/content/show.php?content=74689 || gtk-kde4

After installation, gtk-kde4 can also be found in System Settings > Lost
and Found > GTK style.

-   GTK+ Change Theme — Little program that lets you change your GTK+
    2.0 theme (considered a better alternative to switch2).

http://plasmasturm.org/code/gtk-chtheme/ || gtk-chtheme

-   GTK+ Preference Tool — GTK+ theme selector and font switcher.

http://gtk-win.sourceforge.net/home/index.php/Main/GTKPreferenceTool ||
gtk2_prefs

-   GTK+ Theme Switch — Simple GTK+ theme switcher.

http://muhri.net/nav.php3?node=gts || gtk-theme-switch2

-   For manual configuration see the GTK+ page.

> GTK+1 styles

To change GTK1 styles you can install the gtk-theme-switch package from
the AUR.

Theme engines
-------------

A Theme Engine can be thought of as a thin layer API which translates
themes (excluding icons) between one or more toolkits. These engines add
some extra code in the process and it is arguable that this kind of a
solution is not as elegant and optimal as using native styles.

> GTK+-Qt engine

This one is for use by GTK+ applications running in KDE, which basically
means this does not work in other desktop environments. It applies all
Qt settings (styles, fonts, not icons though) to the GTK+ applications
and uses the style plugins directly. This engine can be installed with
the gtk-qt-engine package, available in the AUR.

Note:There are rendering issues with some Qt styles.

You can access it from the KDE System Settings under Lost and Found >
GTK Styles and Fonts.

If you want to remove the engine entirely you need to uninstall it and
also delete the following files:

    $ rm ~/.gtkrc2.0-kde
    $ rm ~/.kde4/env/gtk-qt-engine.rc.sh
    $ rm ~/gtk-qt-engine.rc

> QGtkStyle

This is a Qt style which intends to make applications blend perfectly
into the GNOME desktop environment by using GTK+ to render all
components. To use this style you must have at least GTK+ 2.0 and Qt
4.3, although Qt 4.4 or higher is preferred. To enable this style, use:

-   Qt Configuration: choose "GTK+" under Appearance > GUI Style.
-   KDE4 System Settings: choose "GTK+ Style" under Application
    Appearance > Style > Applications.
-   the command-line: edit the ~/.config/Trolltech.conf file by adding:

    ~/.config/Trolltech.conf

    ...
    [Qt]
    style=GTK+
    ...

Note:Beginning with version 4.5 this style is included in Qt and does
not require a separate package anymore.

Tips and tricks
---------------

> KDE file dialogs for GTK+ applications

KGtk is a wrapper script that uses LD_PRELOAD to force KDE file dialogs
(open, save, etc.) in GTK+ 2.x apps. If you use KDE and prefer its file
dialogs over GTK+'s then you can install kgtk from the AUR. Once
installed you can run GTK+ 2.x applications with kgtk-wrapper in two
ways (using Gimp in the examples):

-   Calling kgtk-wrapper directly and using the GTK+ 2.x binary as an
    argument:

    $ /usr/bin/kgtk-wrapper gimp

-   Modifying the KDE .desktop shortcuts files you can find at
    /usr/share/applications/ to prefix the Exec statement with
    kgtk-wrapper.

e.g. with GIMP, edit the /usr/share/applications/gimp.desktop shortcut
file and replace Exec=gimp-2.8 %U by Exec=kgtk-wrapper gimp-2.8 %U.

Note:Some GTK+ applications may not be compatible with KGtk-wrapper
(e.g. Chromium), sometimes the wrapper makes the application crash (e.g.
Firefox) and even other applications like KDM (when used with e.g.
Thunderbird).

> aMSN with GTK+ or KDE dialogs

aMSN's uses the Tk toolkit for its user interface. To make it use GTK+
or KDE dialogs install the amsn-plugins-desktopintegration plugin
available in the AUR. Other plugins can be found on aMSN's Plugin Page.

> Run an application with a specific theme

You can use custom styles for specific GTK+ 2.x applications. To run an
application with a specific theme use:

    GTK2_RC_FILES=/usr/share/themes/QtCurve/gtk-2.0/gtkrc firefox

This will launch Firefox with the QtCurve theme.

> Using a GTK+ icon theme in Qt apps

If you are not using GNOME, run gconf-editor, look under desktop > gnome
> interface for the icon_theme key and change it to your preference. As
you're not using GNOME it's possible that you will have to set
export DESKTOP_SESSION=gnome somewhere in your ~/.xinitrc.

> Improve subpixel rendering of GTK apps under KDE

If the subpixel rendering in GTK apps is not as sharp as in native KDE
Qt applications, try to add the following lines to your
$XDG_CONFIG_HOME/fontconfig/fonts.conf (between the <fontconfig> tags):

    <match target="font">
        <edit mode="assign" name="lcdfilter">
            <const>lcddefault</const>
        </edit>
    </match>

Troubleshooting
---------------

> gtk-qt-engine does not work with OpenOffice

To make OpenOffice respect the Qt theme chosen with the GTK+-Qt Engine
you need to add the following line to /etc/profile (as root):

    export SAL_GTK_USE_PIXMAPPAINT=1

Also make sure to select "Use my KDE style in GTK applications" in KDE4
System Settings under Lost and Found > GTK Styles and Fonts.

> Qt applications do not use QGtkStyle

Qt will not apply QGtkStyle correctly if GTK+ is using the GTK+-Qt
Engine. Qt determines whether the GTK+-Qt Engine is in use by reading
the GTK+ configuration files listed in the environmental variable
GTK2_RC_FILES. If the environmental variable is not set properly, Qt
assumes you are using the engine, sets QGtkStyle to use the style GTK+
style Clearlooks, and outputs an error message:

    QGtkStyle cannot be used together with the GTK_Qt engine.

Another error you may get after launching qtconfig from a shell and
selecting the GTK+ style is:

    QGtkStyle was unable to detect the current GTK+ theme.

According to this thread, you may simply have to install libgnomeui to
solve this issue. This has the added benefit that you don't need to edit
a file every time you change your theme via a graphical tool, like the
one provided by xfce.

Users of Openbox and other non-GNOME environments may encounter this
problem. To solve this, first add the following to your .xinitrc file:

    .xinitrc

    ...
    export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
    ...

> Note:

-   Make sure to add this line before invoking the window manager.
-   You can add multiple paths by separating them with colons.
-   Make sure to use $HOME instead of ~ as it will not properly expand
    to the user's home directory.

Then specify the theme you want in the ~/.gtkrc-2.0 file using a
dedicated application or manually, by adding:

    .gtkrc-2.0

    ...
    gtk-theme-name="[name of theme]"
    ...

Some tools only insert the following include directive in ~/.gtkrc-2.0:

    .gtkrc-2.0

    ...
    include "/usr/share/themes/SomeTheme/gtk-2.0/gtkrc"
    ...

which apparently is not recognized by all versions of QGtkStyle. You can
hotfix this problem by inserting the gtk-theme-name manually in your
~/.gtkrc-2.0 file like above.

Note:Style-changing applications will most probably rewrite the
~/.gtkrc-2.0 file the next time you change themes.

If these steps do not work, install gconf and run this command:

    gconftool-2 --set --type string /desktop/gnome/interface/gtk_theme [name of theme]

If you further want to set the same icon and cursor theme, then you have
to specify them, too.

    gconftool-2 --set --type string /desktop/gnome/interface/icon_theme Faenza-Dark

This sets the icon theme to Faenza-Dark located in
/usr/share/icons/Faenza-Dark. For the cursor theme you first have to set
the gconf value.

    gconftool-2 --set --type string /desktop/gnome/peripherals/mouse/cursor_theme Adwaita

Then you will have to create the file
/usr/share/icons/default/index.theme with the following lines:

    [Icon Theme]
    Inherits=Adwaita

> Themes not working in GTK+ apps

If the style or theme engine you set up is not showing in your GTK
applications then it's likely your GTK+ settings files are not being
loaded for some reason. You can check where your system expects to find
these files by doing the following..

    $ export | grep gtk

Usually the expected files should be ~/.gtkrc for GTK1 and ~/.gtkrc2.0
or ~/.gtkrc2.0-kde for GTK+ 2.x.

Newer versions of gtk-qt-engine use ~/.gtkrc2.0-kde and set the export
variable in ~/.kde/env/gtk-qt-engine.rc.sh. If you recently removed
gtk-qt-engine and are trying to set a GTK+ theme then you must also
remove ~/.kde/env/gtk-qt-engine.rc.sh and reboot. Doing this will ensure
that GTK+ looks for it's settings in the standard ~/.gtkrc2.0 instead of
the ~/.gtkrc2.0-kde file.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Uniform_Look_for_Qt_and_GTK_Applications&oldid=305938"

Categories:

-   Widget Toolkits
-   Eye candy

-   This page was last modified on 20 March 2014, at 17:29.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
