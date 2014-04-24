Libcanberra
===========

Related articles

-   GTK+
-   Libnotify

Libcanberra is a simple abstract interface for playing event sounds. It
implements the XDG Sound Theme and Naming Specifications for generating
event sounds on free desktops, such as GNOME. Further description here

Contents
--------

-   1 Installation
-   2 Configuration
-   3 Systemd
-   4 Tips and tricks
    -   4.1 Write your own canberra app
        -   4.1.1 Bash
        -   4.1.2 C
        -   4.1.3 Genie
        -   4.1.4 Vala
-   5 See also

Installation
------------

Libcanberra can be installed with the package libcanberra, available in
the Official repositories. It contains the library and a GTK+ module.

You have to choose a backend to play sounds:

-   ALSA backend is included in libcanberra package
-   GStreamer backend can be installed with package
    libcanberra-gstreamer, available in the Official repositories.
-   PulseAudio backend can be installed with package libcanberra-pulse,
    available in the Official repositories.
-   OSS backend can be installed with the package libcanberra-oss,
    available in the Arch User Repository.

Also, you have to install a sound theme in order to hear any event
sound:

-   The default sound theme is 'freedesktop', which can be installed
    with the package sound-theme-freedesktop, available in the Official
    repositories.
-   Alternatively, you can install ubuntu-sounds, available in the Arch
    User Repository.

Configuration
-------------

By default, the GTK+ module is loaded automatically, when a GTK+
application launched. You can overwrite default settings in user's
GtkSettings file:

    $HOME/.gtkrc-2.0 and $XDG_CONFIG_HOME/gtk-3.0/settings.ini

    gtk-enable-event-sounds=true
    gtk-enable-input-feedback-sounds=true
    gtk-sound-theme-name=freedesktop

In GNOME, these settings are managed by gnome-settings-daemon, and the
configuration is available in GSettings under org.gnome.desktop.sound
schema.

Systemd
-------

To enable bootup, shutdown and reboot sounds using canberra, run:

# systemctl enable canberra-system-bootup.service

Tips and tricks
---------------

> Write your own canberra app

You can write your own libcanberra sound events easily in some
programming languages, or you can simply use bash.

Bash

-   Dependency: libcanberra

    hello_world.sh

    #!/bin/bash
    canberra-gtk-play -i phone-incoming-call -d "hello world"

C

-   Dependency: libcanberra
-   Build with:
    gcc hello_world.c -o hello_world `pkg-config --cflags --libs glib-2.0 libcanberra`

    hello_world.c

    #include <glib.h>
    #include <canberra.h>
    void main () {
    	ca_context * hello;
    	ca_context_create (&hello);
    	ca_context_play (hello, 0,
    		CA_PROP_EVENT_ID, "phone-incoming-call",
    		CA_PROP_EVENT_DESCRIPTION, "hello world",
    		NULL);
    	g_usleep (2000000);
    }

Genie

-   Dependency: libcanberra
-   Makedependency: vala
-   Build with: valac --pkg libcanberra hello_world.gs

    hello_world.gs

    uses
    	Canberra
    init
    	hello: Context
    	Context.create(out hello)
    	hello.play (0,
    		PROP_EVENT_ID, "phone-incoming-call",
    		PROP_EVENT_DESCRIPTION, "hello world")
    	Thread.usleep (2000000)

Vala

-   Dependency: libcanberra
-   Makedependency: vala
-   Build with: valac --pkg libcanberra hello_world.vala

    hello_world.vala

    using Canberra;
    public class HelloWorld {
    	static void main () {
    	Context hello;
    	Context.create(out hello);
    	hello.play (0,
    		PROP_EVENT_ID, "phone-incoming-call",
    		PROP_EVENT_DESCRIPTION, "hello world");
    	Thread.usleep (2000000);
    	}
    }

See also
--------

-   Libcanberra Reference Manual

Retrieved from
"https://wiki.archlinux.org/index.php?title=Libcanberra&oldid=301620"

Category:

-   Development

-   This page was last modified on 24 February 2014, at 11:59.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
