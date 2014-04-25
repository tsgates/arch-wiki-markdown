Internationalization
====================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This is the main article on the internationalisation in Arch Linux. It
should offer an explaination on how to work with any supported language
in Arch Linux.

OpenI18N Diagram

Contents
--------

-   1 Fonts
-   2 Locales
-   3 Keyboard layouts
-   4 Input methods in Xorg
    -   4.1 GTK immodule
        -   4.1.1 Disabling GTK IM modules (without uninstalling)
    -   4.2 QT immodule (> QT 4.0.0)
        -   4.2.1 Disabling QT IM modules (without uninstalling)
-   5 See also

Fonts
-----

For the list of available font packages in Arch Linux see the Fonts
article.

Locales
-------

See Locale

Keyboard layouts
----------------

See Keyboard Configuration in Console and Keyboard Configuration in
Xorg.

Input methods in Xorg
---------------------

-   gcin
-   fcitx
-   SCIM with the x11 FrontEnd module
-   uim (Japanese)
-   IBus

> GTK immodule

-   scim with the socket FrontEnd module binds to the GTK Im-Module
-   uim (Japanese)
-   fcitx

Disabling GTK IM modules (without uninstalling)

First some background information on how GTK loads and selects IM
modules:

-   Specifying an IM module

1.  GTK_IM_MODULE environment variable
    1.  GTK_IM_MODULE="scim" gedit

2.  XSETTINGS value of Gtk/IMModule

-   File listing possible IM modules

1.  GTK_IM_MODULE_FILE environment variable
2.  RC files
3.  /etc/gtk-2.0/gtk.immodules

If no IM module is specified (either via GTK_IM_MODULE or in XSETTINGS),
then GTK will automatically choose a suitable immodule from an internal
listing (GTK_IM_MODULE_FILE... etc). This chosen IM module will depend
on the software installed, and will be picked in a completely arbirtrary
order.

For a listing of installed GTK+ immodules, see

-   "/usr/lib/gtk-2.0/modules/"
-   "/usr/lib/gtk-2.0/2.10.0/immodules/"

XSETTINGS provides a common API to configure common desktop settings.
Similar database configuration systems such as gnome-config, GConf,
liproplist and the kde configuration system already exist, however
XSETTINGS unifies these systems. XSETTINGS daemons, such as
gnome-settings-daemon from gnome, xfce-mcs-manager from xfce4, and other
from openbox, etc, push desktop-environment-specific data to the
XSETTINGS database. Technically, XSETTINGS is a simple storage medium
intended to store only strings, integers and colors. When an XSETTINGS
manager quits, the clients restore all settings to their default values.

The if GTK+ has debugging enabled, the loaded modules can be seen by

    application --gtk-debug modules

Otherwise, the modules can be seen by scanning the linked libraries in
gdb after attaching to the process.

To prevent GTK+ from loading any IM modules

-   set GTK_IM_MODULE to the empty string
-   set GTK_IM_MODULE to "gtk-im-context-simple"

> QT immodule (> QT 4.0.0)

-   scim with the socket FrontEnd module binds to the QT Im-Module
-   uim (Japanese)
-   fcitx

Disabling QT IM modules (without uninstalling)

QT will load the IM module specified in QT_IM_MODULE, and if unset
attempt to fall back on XIM.

1.  QT_IM_MODULE environment variable
2.  XIM

To disable input method module loading in QT, export
QT_IM_MODULE="simple".

See also
--------

-   Free Standards Group OpenI18N
-   XSETTINGS 0.5 Specification
-   Running and Debugging GTK+ Applications

Retrieved from
"https://wiki.archlinux.org/index.php?title=Internationalization&oldid=275651"

Category:

-   Internationalization

-   This page was last modified on 15 September 2013, at 12:37.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
