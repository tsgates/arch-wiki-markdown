Libnotify
=========

Summary

This article discusses how to install, configure and use libnotify for
application development.

Related

GTK+

Libcanberra

Libnotify is an easy way to display desktop notifications and
information in a small dialog. It implements the Desktop Notifications
Specification and it is already used by many open source apps like
Evolution, Pidgin, etc. It has support for GTK+ and Qt applications and
is desktop independent.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 Builtin servers                                              |
|     -   1.2 Other servers                                                |
|                                                                          |
| -   2 Tips and tricks                                                    |
|     -   2.1 Write your own notify app                                    |
|         -   2.1.1 Bash                                                   |
|         -   2.1.2 Boo                                                    |
|         -   2.1.3 C                                                      |
|         -   2.1.4 C++                                                    |
|         -   2.1.5 C#                                                     |
|         -   2.1.6 Genie                                                  |
|         -   2.1.7 Java                                                   |
|         -   2.1.8 JavaScript                                             |
|         -   2.1.9 Perl                                                   |
|         -   2.1.10 Python                                                |
|         -   2.1.11 Ruby                                                  |
|         -   2.1.12 Vala                                                  |
|         -   2.1.13 Visual Basic .NET                                     |
|                                                                          |
| -   3 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Libnotify can be installed with the package libnotify, available in the
official repositories.

In order to use libnotify, you have to install a notification server:

> Builtin servers

Cinnamon, GNOME Shell and KDE use their own implementations to display
notifications, and you can't replace them. Their notification servers
are started automatically on login to receive notifications from
applications via DBus.

-   cinnamon provides a notification server itself. Notifications are
    displayed at the top right corner of the screen.
-   gnome-shell provides a notification server itself. Notifications are
    displayed at the bottom of the screen.
-   KDE uses knotify4 from package kdebase-runtime to display
    notifications. Notifications are displayed at the bottom right
    corner of the screen.

> Other servers

In other desktop environments, the notification server is launched on
the first call via DBus. You can choose one of the following
implementations:

-   notification-daemon is the notification server used by GNOME in
    Fallback Mode. Notifications are displayed at the top right corner
    of the screen.

Note:notification-daemon doesn't have a DBus service file, so you have
to autostart it. (Already done in GNOME Fallback Mode.) To start the
daemon manually, execute the following command:
/usr/lib/notification-daemon-1.0/notification-daemon.

-   xfce4-notifyd is a notification server for Xfce, available in the
    official repositories.

Tip:To configure xfce4-notifyd, run the following command in the
terminal: xfce4-notifyd-config.

-   dunst is a minimalistic notification daemon for Linux designed to
    fit nicely into minimalistic windowmanagers like dwm.
-   notify-osd is a notification server for Unity, available in the
    official repositories.
-   awn-extras-applets contains a notification-daemon applet for the
    Avant Window Navigator, available in the official repositories.
-   statnot is a small, lightweight notification daemon that can output
    notifications to the root window's title, stdout or FIFO pipes,
    making it integrate very well with tiling window managers. It's
    available in the Arch User Repository or as a git repo.
-   twmn is a notification system for tiling window managers. It's
    available in the Arch User Repository or as a git repo.

Tips and tricks
---------------

> Write your own notify app

You can write your own libnotify display messages easily in many
programming languages through GObject-Introspection or bindings, or you
can simply use bash.

The following examples display simple a "Hello world" notification.

Bash

-   Dependency: libnotify

    hello_world.sh

    #!/bin/bash
    notify-send 'Hello world!' 'This is an example notification.' --icon=dialog-information

Boo

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

C

-   Dependency: libnotify
-   Build with:
    gcc -o hello_world `pkg-config --cflags --libs libnotify` hello_world.c

    hello_world.c

    #include <libnotify/notify.h>
    void main () {
    	notify_init ("Hello world!");
    	NotifyNotification * Hello = notify_notification_new ("Hello world", "This is an example notification.", "dialog-information");
    	notify_notification_show (Hello, NULL);
    }

C++

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

C#

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

Genie

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

Java

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

JavaScript

-   Dependencies: libnotify, gjs (works also with seed)

    hello_world.js

    #!/usr/bin/gjs
    Notify = imports.gi.Notify;
    Notify.init ("Hello world");
    Hello=new Notify.Notification ({summary: "Hello world!",
                                    body: "This is an example notification.",
                                    "icon-name": "dialog-information"});
    Hello.show ();

Perl

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

Python

-   Dependencies: libnotify, python-gobject

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

Ruby

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

Vala

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

Visual Basic .NET

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
"https://wiki.archlinux.org/index.php?title=Libnotify&oldid=254579"

Category:

-   Development
