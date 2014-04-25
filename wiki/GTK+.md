GTK+
====

Related articles

-   Uniform Look for Qt and GTK Applications
-   Qt
-   GNU Project

From the GTK+ website:

GTK+, or the GIMP Toolkit, is a multi-platform toolkit for creating
graphical user interfaces. Offering a complete set of widgets, GTK+ is
suitable for projects ranging from small one-off tools to complete
application suites.

GTK+, The GIMP Toolkit, was initially made by the GNU Project for the
GIMP but is now a very popular toolkit with bindings for many languages.
This article will explore the tools used to configure the GTK+ theme,
style, icon, font and font size, and also detail manual configuration.

Contents
--------

-   1 Configuration programs
-   2 Themes
    -   2.1 GTK+ 1.x
    -   2.2 GTK+ 2.x
    -   2.3 GTK+ 3.x
    -   2.4 GTK+ and Qt
    -   2.5 GTK+ and HTML with Broadway
-   3 Configuration file
    -   3.1 Enabling Customizable Keyboard Shortcuts
    -   3.2 Speed up your GNOME menu
    -   3.3 Reduce widget sizes
-   4 Development
    -   4.1 Write a simple message dialog app
        -   4.1.1 Bash
        -   4.1.2 Boo
        -   4.1.3 C
        -   4.1.4 C++
        -   4.1.5 C#
        -   4.1.6 Genie
        -   4.1.7 Java
        -   4.1.8 JavaScript
        -   4.1.9 Perl
        -   4.1.10 Python
        -   4.1.11 Vala
        -   4.1.12 Visual Basic .NET
-   5 See also

Configuration programs
----------------------

These GUI programs allow theme selection and at least customising of a
font. They generally overwrite the ~/.gtkrc-2.0 file.

-   lxappearance: A configuration tool from the LXDE project, which does
    not require any other parts of LXDE or other desktop environment.
    More flexible customisation than the other programs.
-   gtk-chtheme
-   gtk-theme-switch2
-   gtk2_prefs

See also Uniform Look for Qt and GTK Applications#Changing styles in
each toolkit.

Themes
------

> GTK+ 1.x

There are loads of GTK+ 1.x themes in the AUR: search for gtk-theme. A
good start is gtk-smooth-engine.

Most major desktop environments provide tools to configure the GTK+
theme, icons, font and font size.

Alternatively, use gtk-theme-switch2. Run it with the switch command.

> GTK+ 2.x

There are loads of GTK+ 2.x themes in the AUR: search for gtk2-theme. A
good start is gtk-engines which includes the popular Clearlooks theme.

Most major desktop environments provide tools to configure the GTK+
theme, icons, font and font size.

Alternatively, GTK+ settings can be configured manually by editing
~/.gtkrc-2.0. A list of GTK+ settings can be found in the GNOME library.
To manually change the GTK+ theme, icons, font and font size, add the
following to ~/.gtkrc-2.0:

    ~/.gtkrc-2.0

    gtk-icon-theme-name = "[name-of-icon-theme]"
    gtk-theme-name = "[name-of-theme]"
    gtk-font-name = "[font-name] [size]"

For example:

    ~/.gtkrc-2.0

    gtk-icon-theme-name = "Tango"
    gtk-theme-name = "Murrine-Gray"
    gtk-font-name = "DejaVu Sans 8"

Note:The above example requires the packages ttf-dejavu,
tangerine-icon-theme, gtk-engine-murrine from the official repositories,
and gtk-theme-murrine-collection from the AUR.

> GTK+ 3.x

A good start is gnome-themes-standard which includes the popular Adwaita
theme.

If selected style has both GTK+ 2.x and GTK+ 3.x themes, they will be
used. If selected style has only GTK+ 2.x theme, it will be used for
GTK+ 2.x applications and (ugly) defaults will be used for GTK+ 3.x
applications. If selected style has only GTK+ 3.x theme, it will be used
for GTK+ 3.x applications and (ugly) defaults will be used for GTK+ 2.x
applications. Thus for uniform UI appearance and best experience one can
use style that has both GTK+ 2.x and GTK+ 3.x themes.

Most major desktop environments provide tools to configure the GTK+
theme, icons, font and font size. If you use GNOME, use GNOME Tweak
Tool: install gnome-tweak-tool. If you use Xfce, use the Appearance
tool: go to Settings > Appearance.

An alternative without huge dependencies is lxappearance.

If you prefer not to install a theme manager at all, your theme can be
set manually in $XDG_CONFIG_HOME/gtk-3.0/settings.ini (this is usually
~/.config/gtk-3.0/settings.ini). An example settings.ini file:

    $XDG_CONFIG_HOME/gtk-3.0/settings.ini

    [Settings]
    gtk-application-prefer-dark-theme = false
    gtk-theme-name = Zukitwo
    gtk-fallback-icon-theme = gnome
    gtk-icon-theme-name = [icon theme name]
    gtk-font-name = [font name] [font size]

If it still does not change, delete old gtk-3.0 folder in
$XDG_CONFIG_HOME and copy gtk-3.0 folder from /path/to/theme to
$XDG_CONFIG_HOME. Example:

    $ rm -r ~/.config/gtk-3.0/
    $ cp -r /usr/share/themes/Zukitwo/gtk-3.0/ ~/.config/  

  
 After this, you need to set the same theme in your DE's appearance
configuration tool. There are only a few themes which provide a uniform
look for GTK+ 3.x and GTK+ 2.x apps. A few examples:

1.  Adwaita (part of gnome-themes-standard)
2.  Clearlooks-Phenix (AUR: clearlooks-phenix-gtk-theme)
3.  Newlooks for GTK+ 3 and Clearlooks for GTK+ 2
4.  Zukitwo
5.  Elegant Brit
6.  Atolm
7.  Hope
8.  OMG

> Note:

-   Some themes may require librsvg to display correctly, but not all
    specify it as a dependency. Try installing it if the chosen theme
    looks broken.
-   There probably are other themes. Some of these themes are available
    in the AUR. Also, some of them are not usable as-is for displaying a
    GTK+ 2.x panel (light text over light background), so you need to
    use the provided panel background.

You could find what themes installed on your system have both an GTK+
2.x and GTK+ 3.x version by using this command (don't work with names
containing spaces):

    find $(find ~/.themes /usr/share/themes/ -wholename "*/gtk-3.0" | sed -e "s/^\(.*\)\/gtk-3.0$/\1/")\
    -wholename "*/gtk-2.0" | sed -e "s/.*\/\(.*\)\/gtk-2.0/\1"/

> GTK+ and Qt

If you have GTK+ and Qt (KDE) applications on your desktop then you know
that their looks do not blend well. If you wish to make your GTK+ styles
match your Qt styles please read Uniform Look for Qt and GTK
Applications.

> GTK+ and HTML with Broadway

The GDK Broadway backend provides support for displaying GTK+
applications in a web browser, using HTML5 and web sockets. [1]

When using broadwayd, specify the display number to use, prefixed with a
colon, similar to X. The default display number is 1.

    $ display_number=:5

Start it.

    $ broadwayd $display_number 

Port Used on default

    port = 8080 + ($display_number - 1)

Point your browser to http://localhost:port

To Start apps

    $ GDK_BACKEND=broadway BROADWAY_DISPLAY=$display_number <<app>>

Alternatively can set address and port

    $ broadwayd --port $port_number --address $address $display_number

Configuration file
------------------

Note:See the GtkSettings properties in the GTK+ programming reference
manual for the full list of GTK configuration options.

The purpose of this section is to collect GTK+ configuration settings
which can e.g. be used within one's GTK+ configuration files.

There are two relevant locations for GTK+ configuration files (which are
in an ini format) : $XDG_CONFIG_HOME/gtk-3.0/ (usually
~/.config/gtk-3.0/) and /etc/gtk-3.0/. The former is reserved for user
wide settings, and the latter for system wide settings.

> Enabling Customizable Keyboard Shortcuts

You can customize your GTK+ applications' keyboard shortcuts (those are
called accelerators in GTK+ terminology) by hovering your mouse over a
menu item and pressing your desired key combination. However, this
feature is disabled by default. To enable it, set

    gtk-can-change-accels = 1

> Speed up your GNOME menu

This setting controls the delay between you pointing the mouse at a menu
and that menu opening in GNOME. Change this to a setting you prefer. I
guess the number is in milliseconds, e.g. 250 being a quarter of a
second.

    gtk-menu-popup-delay = 0

> Reduce widget sizes

If you have a small screen or you just do not like big icons and
widgets, you can resize things easily. To have icons without text in
toolbars, use

    gtk-toolbar-style = GTK_TOOLBAR_ICONS

To use smaller icons, use a line like this:

    gtk-icon-sizes = "panel-menu=16,16:panel=16,16:gtk-menu=16,16:gtk-large-toolbar=16,16\
    :gtk-small-toolbar=16,16:gtk-button=16,16"

Or to remove icons from buttons completely:

    gtk-button-images = 0

You can also remove icons from menus:

    gtk-menu-images = 0

There is some more tweaking to do in your themes gtkrc like explained
here and there's another theme that does it all.

Development
-----------

When writing a start-from-scratch GTK+ 3 program with C, it's necessary
to add CFLAGS for gcc:

    $ gcc -g -Wall $(pkg-config --cflags --libs gtk+-3.0) -o base base.c

-g and -Wall parameters are not necessary since they are only for
verbose debugging outputs. You may try out the official Hello World
example.

> Write a simple message dialog app

You can write your own GTK+ 3 message dialog easily in many programming
languages through GObject-Introspection or bindings, or you can simply
use bash.

The following examples display a simple "Hello world" in a message
dialog.

Bash

-   Dependency: zenity

    hello_world.sh

    #!/bin/bash
    zenity --info --title='Hello world!' --text='This is an example dialog.'

Boo

-   Dependency: gtk-sharp-3 from AUR (boo)
-   Makedependency: boo
-   Build with: booc hello_world.boo
-   Run with: mono hello_world.exe (or booi hello_world.boo)

    hello_world.boo

    import Gtk from "gtk-sharp"
    Application.Init()
    Hello = MessageDialog(null, DialogFlags.Modal, MessageType.Info, ButtonsType.Close, "Hello world!")
    Hello.SecondaryText = "This is an example dialog."
    Hello.Run()

C

-   Dependency: gtk3 and pkg-config
-   Build with:
    gcc -o hello_world $(pkg-config --cflags --libs gtk+-3.0) hello_world.c

    hello_world.c

    #include <gtk/gtk.h>
    void main (int argc, char *argv[]) {
    	gtk_init (&argc, &argv);
            GtkWidget *hello = gtk_message_dialog_new (NULL, GTK_DIALOG_MODAL, GTK_MESSAGE_INFO, GTK_BUTTONS_OK, "Hello world!");
    	gtk_message_dialog_format_secondary_text (GTK_MESSAGE_DIALOG (hello), "This is an example dialog.");
            gtk_dialog_run(GTK_DIALOG (hello));
    }

C++

-   Dependency: gtkmm3
-   Build with:
    g++ -o hello_world $(pkg-config --cflags --libs gtkmm-3.0) hello_world.cc

    hello_world.cc

    #include <gtkmm/main.h>
    #include <gtkmm/messagedialog.h>
    int main(int argc, char *argv[]) {
    	Gtk::Main kit(argc, argv);
    	Gtk::MessageDialog Hello("Hello world!", false, Gtk::MESSAGE_INFO, Gtk::BUTTONS_OK);
    	Hello.set_secondary_text("This is an example dialog.");
    	Hello.run();
    }

C#

-   Dependency: gtk-sharp-3 from AUR
-   Build with: mcs -pkg:gtk-sharp-3.0 hello_world.cs
-   Run with: mono hello_world.exe

    hello_world.cs

    using Gtk;
    public class HelloWorld {
    	static void Main() {
    		Application.Init ();
    		MessageDialog Hello = new MessageDialog (null, DialogFlags.Modal, MessageType.Info, ButtonsType.Close, "Hello world!");
    		Hello.SecondaryText="This is an example dialog.";
    		Hello.Run ();
    	}
    }

Genie

-   Dependency: gtk3
-   Makedependency: vala
-   Build with: valac --pkg gtk+-3.0 hello_world.gs

    hello_world.gs

    uses 
    	Gtk
    init
    	Gtk.init (ref args)
    	var Hello=new MessageDialog (null, Gtk.DialogFlags.MODAL, Gtk.MessageType.INFO, Gtk.ButtonsType.OK, "Hello world!")
    	Hello.format_secondary_text ("This is an example dialog.")
    	Hello.run ()

Java

-   Dependency: java-gnome from AUR
-   Makedependency: java-environment
-   Build with:
    mkdir HelloWorld && javac -classpath /usr/share/java/gtk.jar -d HelloWorld HelloWorld.java
-   Run with:
    java -classpath /usr/share/java/gtk.jar:HelloWorld HelloWorld

    HelloWorld.java

    import org.gnome.gtk.Gtk;
    import org.gnome.gtk.Dialog;
    import org.gnome.gtk.InfoMessageDialog;

    public class HelloWorld
    {
        public static void main(String[] args) {
            Gtk.init(args);
            Dialog Hello = new InfoMessageDialog(null, "Hello world!", "This is an example dialog.");
            Hello.run();
        }
    }

JavaScript

-   Dependencies: gtk3, gjs (works also with seed)

    hello_world.js

    #!/usr/bin/gjs
    Gtk = imports.gi.Gtk
    Gtk.init(null, null)
    Hello = new Gtk.MessageDialog({type: Gtk.MessageType.INFO,
                                   buttons: Gtk.ButtonsType.OK,
                                   text: "Hello world!",
                                   "secondary-text": "This is an example dialog."})
    Hello.run()

Perl

-   Dependency: perl-gtk3 from AUR

    hello_world.pl

    #!/usr/bin/perl
    use Gtk3 -init;
    my $hello = Gtk3::MessageDialog->new (undef, 'modal', 'info', 'ok', "Hello world!");
    $hello->set ('secondary-text' => 'This is an example dialog.');
    $hello->run;

Python

-   Dependencies: gtk3, python-gobject

    hello_world.py

    #!/usr/bin/python
    from gi.repository import Gtk
    Gtk.init(None)
    Hello=Gtk.MessageDialog(None, Gtk.DialogFlags.MODAL, Gtk.MessageType.INFO, Gtk.ButtonsType.CLOSE, "Hello world!")
    Hello.format_secondary_text("This is an example dialog.")
    Hello.run()

Vala

-   Dependency: gtk3
-   Makedependency: vala
-   Build with: valac --pkg gtk+-3.0 hello_world.vala

    hello_world.vala

    using Gtk;
    public class HelloWorld {
    	static void main (string[] args) {
    		Gtk.init (ref args);
    		var Hello=new MessageDialog (null, Gtk.DialogFlags.MODAL, Gtk.MessageType.INFO, Gtk.ButtonsType.OK, "Hello world!");
    		Hello.format_secondary_text ("This is an example dialog.");
    		Hello.run ();
    	}
    }

Visual Basic .NET

-   Dependency: gtk-sharp-3 from AUR
-   Makedependency: mono-basic
-   Build with:
    vbnc -r:/usr/lib/mono/gtk-sharp-3.0/gio-sharp.dll -r:/usr/lib/mono/gtk-sharp-3.0/glib-sharp.dll -r:/usr/lib/mono/gtk-sharp-3.0/gtk-sharp.dll hello_world.vb
-   Run with: mono hello_world.exe

    hello_world.vb

    Imports Gtk
    Public Class Hello
    	Inherits MessageDialog
    	Public Sub New
    		MyBase.New(Me, DialogFlags.Modal, MessageType.Info, ButtonsType.Close, "Hello world!")
    		Me.SecondaryText = "This is an example dialog."
    	End Sub
    	Public Shared Sub Main
    		Application.Init
    		Dim Dialog As New Hello
    		Dialog.Run
    	End Sub
    End Class

See also
--------

-   The official GTK+ website
-   Wikipedia article about GTK+
-   GTK+ 2.0 Tutorial
-   GTK+ 3 Reference Manual
-   gtkmm Tutorial
-   gtkmm Reference Manual

Retrieved from
"https://wiki.archlinux.org/index.php?title=GTK%2B&oldid=305931"

Category:

-   Widget Toolkits

-   This page was last modified on 20 March 2014, at 17:28.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
