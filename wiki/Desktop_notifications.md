Desktop notifications
=====================

Related articles

-   GTK+
-   Libcanberra

Desktop notifications are small, passive popup dialogs that notify the
user of particular events in an asynchronous manner.

Contents
--------

-   1 Libnotify
-   2 Notification servers
    -   2.1 Built-in
    -   2.2 Standalone
-   3 Usage in programming
    -   3.1 Bash
    -   3.2 Boo
    -   3.3 C
    -   3.4 C++
    -   3.5 C#
    -   3.6 Genie
    -   3.7 Java
    -   3.8 JavaScript
    -   3.9 Perl
    -   3.10 Python
    -   3.11 Ruby
    -   3.12 Vala
    -   3.13 Visual Basic .NET
-   4 See also

Libnotify
---------

Libnotify is an implementation of the Desktop Notifications
Specification which provides support for GTK+ and Qt applications and is
desktop independent: it is already used by many open source apps like
Evolution and Pidgin. Libnotify can be installed with the package
libnotify, available in the official repositories.

In order to use libnotify, you have to install a notification server.

Notification servers
--------------------

> Built-in

The following desktop environments use their own implementations to
display notifications, and you cannot replace them. Their notification
servers are started automatically on login to receive notifications from
applications via DBus.

-   Avant Window Navigator has a notification-daemon applet provided by
    awn-extras-applets.
-   Cinnamon provides a notification server itself. Notifications are
    displayed at the top right corner of the screen.
-   Enlightenment provides a notification server through its
    Notification module. Notifications are displayed at the top right
    corner of the screen.
-   GNOME provides a notification server itself. Notifications are
    displayed at the bottom of the screen.
-   KDE uses knotify4 from package kdebase-runtime to display
    notifications. Notifications are displayed at the bottom right
    corner of the screen.

> Standalone

In other desktop environments, the notification server is launched on
the first call via DBus. You can choose one of the following
implementations:

-   dunst is a minimalistic notification daemon for Linux designed to
    fit nicely into minimalistic windowmanagers like dwm.
-   notification-daemon is the notification server used by GNOME
    Flashback. It does not have a D-Bus service file by default. To use
    it outside from GNOME Flashback, create the following file:

    /usr/share/dbus-1/services/org.gnome.Notifications.service

    [D-BUS Service]
    Name=org.freedesktop.Notifications
    Exec=/usr/lib/notification-daemon-1.0/notification-daemon

-   mate-notification-daemon is a notification server for MATE,
    available in the official repositories.
-   notify-osd is a notification server for Unity, available in the
    official repositories.
-   statnot is a small, lightweight notification daemon that can output
    notifications to the root window's title, stdout or FIFO pipes,
    making it integrate very well with tiling window managers. It's
    available in the Arch User Repository or as a git repo.
-   twmn-git is a notification system for tiling window managers. It's
    available in the Arch User Repository or as a git repo.
-   xfce4-notifyd is a notification server for Xfce, available in the
    official repositories.

Tip:To configure xfce4-notifyd, run the following command in the
terminal: xfce4-notifyd-config.

Usage in programming
--------------------

You can write your own libnotify display messages easily in many
programming languages through GObject-Introspection or bindings, or you
can simply use bash.

The following examples display simple a "Hello world" notification.

> Bash

-   Dependency: libnotify

    hello_world.sh

    #!/bin/bash
    notify-send 'Hello world!' 'This is an example notification.' --icon=dialog-information

> Boo

-   Dependency: notify-sharp (boo)
-   Makedependency: boo
-   Build with: booc hello_world.boo
-   Run with: mono hello_world.exe (or booi hello_world.boo)

    hello_world.boo

    import Notifications from "notify-sharp"
    Hello = Notification()
    Hello.Summary  = "Hello world!"
    Hello.Body     = "This is an example notification."
    Hello.IconName = "dialog-information"
    Hello.Show()

> C

-   Dependency: libnotify
-   Build with:
    gcc -o hello_world `pkg-config --cflags --libs libnotify` hello_world.c

    hello_world.c

    #include <libnotify/notify.h>
    void main () {
    	notify_init ("Hello world!");
    	NotifyNotification * Hello = notify_notification_new ("Hello world", "This is an example notification.", "dialog-information");
    	notify_notification_show (Hello, NULL);
    	g_object_unref(G_OBJECT(Hello));
    	notify_uninit();
    }

> C++

-   Dependency: libnotifymm from AUR
-   Build with:
    g++ -o hello_world `pkg-config --cflags --libs libnotifymm-1.0` hello_world.cc

    hello_world.cc

    #include <libnotifymm.h>
    int main(int argc, char *argv[]) {
    	Notify::init("Hello world!");
    	Notify::Notification Hello("Hello world", "This is an example notification.", "dialog-information");
            Hello.show();
    }

> C#

-   Dependency: notify-sharp
-   Build with: mcs -pkg:notify-sharp hello_world.cs
-   Run with: mono hello_world.exe

    hello_world.cs

    using Notifications;
    public class HelloWorld {
    	static void Main() {
    		var Hello = new Notification();
    		Hello.Summary  = "Hello world!";
    		Hello.Body     = "This is an example notification.";
    		Hello.IconName = "dialog-information";
    		Hello.Show();
    	}
    }

> Genie

-   Dependency: libnotify
-   Makedependency: vala
-   Build with: valac --pkg libnotify hello_world.gs

    hello_world.gs

    uses 
    	Notify

    init
    	Notify.init ("Hello world")
    	var Hello=new Notification ("Hello world!","This is an example notification.","dialog-information")
    	Hello.show ()

> Java

-   Dependency: java-gnome from AUR
-   Makedependency: java-environment
-   Build with:
    mkdir HelloWorld && javac -classpath /usr/share/java/gtk.jar -d HelloWorld HelloWorld.java
-   Run with:
    java -classpath /usr/share/java/gtk.jar:HelloWorld HelloWorld

    HelloWorld.java

    import org.gnome.gtk.Gtk;
    import org.gnome.notify.Notify;
    import org.gnome.notify.Notification;

    public class HelloWorld
    {
        public static void main(String[] args) {
            Gtk.init(args);
            Notify.init("Hello world");
            Notification Hello = new Notification("Hello world!", "This is an example notification.", "dialog-information");
            Hello.show();
        }
    }

> JavaScript

-   Dependencies: libnotify, gjs (works also with seed)

    hello_world.js

    #!/usr/bin/gjs
    Notify = imports.gi.Notify;
    Notify.init ("Hello world");
    Hello=new Notify.Notification ({summary: "Hello world!",
                                    body: "This is an example notification.",
                                    "icon-name": "dialog-information"});
    Hello.show ();

> Perl

-   Dependencies: libnotify, perl-glib-object-introspection from AUR

    hello_world.pl

    #!/usr/bin/perl
    use Glib::Object::Introspection;
    Glib::Object::Introspection->setup (
    	basename => 'Notify',
    	version => '0.7',
    	package => 'Notify');
    Notify->init;
    my $hello = Notify::Notification->new("Hello world!", "This is an example notification.", "dialog-information");
    $hello->show;

Or you can use the old, static perl-gtk2-notify bindings:

-   Dependency: perl-gtk2-notify from AUR

    hello_world.pl

    #!/usr/bin/perl
    use Gtk2::Notify -init, "Hello world";
    my $hello = Gtk2::Notify->new("Hello world!", "This is an example notification.", "dialog-information");
    $hello->show;

> Python

-   Dependencies: libnotify, python-gobject (or python2-gobject for
    Python 2)

    hello_world.py

    #!/usr/bin/python
    from gi.repository import Notify
    Notify.init ("Hello world")
    Hello=Notify.Notification.new ("Hello world","This is an example notification.","dialog-information")
    Hello.show ()

Or you can use the old, static python-notify bindings:

-   Dependency: python2-notify

    hello_world.py

    #!/usr/bin/python2
    import pynotify
    pynotify.init ("Hello world")
    Hello=pynotify.Notification ("Hello world!","This is an example notification.","dialog-information")
    Hello.show ()

> Ruby

-   Dependencies: libnotify, ruby-gir-ffi from AUR

    hello_world.rb

    #!/usr/bin/ruby
    require 'gir_ffi'
    GirFFI.setup :Notify
    Notify.init("Hello world")
    Hello = Notify::Notification.new("Hello world!", "This is an example notification.", "dialog-information")
    Hello.show

Or you can use the old, static ruby-libnotify bindings:

-   Dependency: ruby-libnotify from AUR

    hello_world.rb

    #!/usr/bin/ruby
    require 'RNotify'
    Notify.init("Hello world")
    Hello = Notify::Notification.new("Hello world!", "This is an example notification.", "dialog-information")
    Hello.show

> Vala

-   Dependency: libnotify
-   Makedependency: vala
-   Build with: valac --pkg libnotify hello_world.vala

    hello_world.vala

    using Notify;
    public class HelloWorld {
    	static void main () {
    		Notify.init ("Hello world");
    		var Hello = new Notification("Hello world!", "This is an example notification.", "dialog-information");
    		Hello.show ();
    	}
    }

> Visual Basic .NET

-   Dependency: notify-sharp
-   Makedependency: mono-basic
-   Build with:
    vbnc -r:/usr/lib/mono/notify-sharp/notify-sharp.dll hello_world.vb
-   Run with: mono hello_world.exe

    hello_world.vb

    Imports Notifications
    Public Class Hello
    	Public Shared Sub Main
    		Dim Hello As New Notification
    		Hello.Summary  = "Hello world!"
    		Hello.Body     = "This is an example notification."
    		Hello.IconName = "dialog-information"
    		Hello.Show
    	End Sub
    End Class

See also
--------

-   Libnotify Reference Manual
-   C example
-   Python example (french article)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Desktop_notifications&oldid=302391"

Category:

-   Development

-   This page was last modified on 28 February 2014, at 13:55.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
