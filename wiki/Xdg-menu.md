Xdg-menu
========

xdg-menu generates menus for WMs using the Free Desktop menu standard.
You can install archlinux-xdg-menu from the official repositories.

The following WMs are supported:

-   twm
-   ion3
-   WindowMaker
-   fvwm2
-   icewm
-   blackbox
-   fluxbox
-   openbox
-   awesome

KDE, Gnome, Xfce, Enlightenment are already XDG compatible.

Contents
--------

-   1 Menu hierarchy
-   2 Configuration
-   3 Usage
    -   3.1 xdg_menu
    -   3.2 update-menus
-   4 Examples
    -   4.1 Awesome
        -   4.1.1 With xdg_menu
    -   4.2 IceWM
        -   4.2.1 With xdg_menu
        -   4.2.2 With update-menus
    -   4.3 Ion3
        -   4.3.1 With xdg_menu
        -   4.3.2 With update-menus
    -   4.4 FluxBox
        -   4.4.1 With xdg_menu
        -   4.4.2 With update-menus
    -   4.5 OpenBox
        -   4.5.1 With xdg_menu
        -   4.5.2 With update-menus
    -   4.6 Twm
        -   4.6.1 With xdg_menu
        -   4.6.2 With update-menus
    -   4.7 WindowMaker
        -   4.7.1 With xdg_menu
        -   4.7.2 With update-menus
    -   4.8 Fvwm2
        -   4.8.1 With xdg_menu
        -   4.8.2 With update-menus
    -   4.9 BlackBox
        -   4.9.1 With xdg_menu
        -   4.9.2 With update-menus
-   5 See also

> Menu hierarchy

-   Applications
    -   Accessibility
    -   Accessories
    -   Development
    -   Education
    -   Games
    -   Graphics
    -   Internet
    -   Multimedia
    -   Office
    -   Other
    -   Science
    -   System

Configuration
-------------

Xdg_menu relies on three sets of information to generate menus: a root
menu or in other words an XML menu template generally passed on the
command line, information cached when it was last run, and a series of
configuration files.

-   You can find some XML menu templates in /etc/xdg/menus.
-   If altering the code in xdg_menu to change layout, make sure you
    delete everything in ~/.xdg_menu_cache or you will spend hours
    trying to figure out why your changes to the perl script don't take.
-   You can find individual application configurations in
    /usr/share/applications

Other configuration file directories can be found under /usr/share. In
most cases you will not need to touch these. However if you want to
change how your menu is layed out you can alter the menu template for
minor changes. Major changes require tweaking the actual xdg_menu perl
script. If you find that applications do not appear or that they are
called strange things, then you will need to look at the .desktop file
in /usr/share/applications. Check this standards file.

Usage
-----

> xdg_menu

    xdg_menu [--format <format>] [--desktop <desktop>] 
             [--charset <charset>] [--language <language>]  
    	 [--root-menu <root-menu>] [--die-on-error]
    	 [--fullmenu] [--help]
    		 
    	format - output format
    	         possible formats: twm, WindowMaker, fvwm2, icewm, ion3
    	                           blackbox, fluxbox, openbox, 
    				   xfce4, openbox3, openbox3-pipe, awesome
    				   readable
    		 default: WindowMaker
    		
     	fullmenu  - output a full menu and not only a submenu

    	desktop - desktop name for NotShowIn and OnlyShowIn
    		 default: the same as format
    			 
    	charset - output charset
    		 default: <locale>
    			 
    	language - output language
    		 default: <locale>
    			 
    	root-menu - location of root menu file
    		 default: /opt/gnome/etc/xdg/menus/applications.menu
    			 
    	die-on-error - abort execution on any error, 
    		 default: try to continue

    	verbose - print debugging information
    		 
    	help - print this text

> update-menus

update-menus updates WMs menus from XDG stuff and can do it automaticaly
using config.

This is a script wrapper around xdg_menu that relies on
/etc/update-menus.conf

You need to install package: archlinux-xdg-menu (xdg_menu)

/etc/update-menus.conf selects from a list of window managers for which
the menu should be generated. Comments with # are allowed.

All generated menus placed in /var/cache/xdg-menu/. See wm-specific
Examples section of this page to get more information.

Examples
--------

> Awesome

With xdg_menu

    $ xdg_menu --format awesome --root-menu /etc/xdg/menus/arch-applications.menu >~/.config/awesome/archmenu.lua

Then edit your rc.lua as shown below

-   Add a require statment for your new menu.lua file
-   Add an entry to your awful.menu object for your new menu which calls
    xdgmenu

    ...
    xdg_menu = require("archmenu")
    ...

    ...
    mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                        { "Applications", xdgmenu },
                                        { "open terminal", terminal }
                                      }
                            })
    ...

> IceWM

With xdg_menu

    $ xdg_menu --format icewm --fullmenu --root-menu /etc/xdg/menus/arch-applications.menu >>~/.icewm/programs

With update-menus

-   Uncomment icewm in /etc/update-menus.conf
-   run update-menus as root
-   make symlink to /var/cache/xdg-menu/icewm/programs in
    ~/.icewm/programs

> Ion3

With xdg_menu

    $ xdg_menu --format ion3  --root-menu /etc/xdg/menus/arch-applications.menu >~/.ion3/default-session--0/_xdg-menu.lua

After that, change your cfg_menus.lua to include _xdg-menu.lua file and
add menu into mainmenu. For example:

    ...

    dopath("_xdg-menu")

    -- Main menu
    defmenu("mainmenu", {
        submenu("XDG Menu",         "<NAME-OF-FIRST-MENU-IN-_xdg-menu.lua-FILE>"),
        submenu("Programs",         "appmenu"),
        menuentry("Lock screen",    "ioncore.exec_on(_, 'xlock')"),
        menuentry("Help",           "mod_query.query_man(_)"),
        menuentry("About Ion",      "mod_query.show_about_ion(_)"),
        submenu("Styles",           "stylemenu"),
        submenu("Session",          "sessionmenu"),
    })

    ...

With update-menus

-   Uncomment ion3 in /etc/update-menus.conf
-   run update-menus as root
-   change your cfg_menus.lua to include xdg-menu.lua file and add menu
    into mainmenu.

For example:

    ...

    dopath("/var/cache/xdg-menu/ion3/xdg-menu.lua")

    -- Main menu
    defmenu("mainmenu", {
        submenu("XDG Menu",         "<NAME-OF-FIRST-MENU-IN-xdg-menu.lua-FILE>"),
        submenu("Programs",         "appmenu"),
        menuentry("Lock screen",    "ioncore.exec_on(_, 'xlock')"),
        menuentry("Help",           "mod_query.query_man(_)"),
        menuentry("About Ion",      "mod_query.show_about_ion(_)"),
        submenu("Styles",           "stylemenu"),
        submenu("Session",          "sessionmenu"),
    })

    ...

> FluxBox

With xdg_menu

    $ xdg_menu --format fluxbox  --root-menu /etc/xdg/menus/arch-applications.menu >~/.fluxbox/my-menu

Change your menu file to include generated menu.

For example add line:

          [include] (my-menu)

With update-menus

-   Uncomment fluxbox in /etc/update-menus.conf
-   run update-menus as root
-   change your menu file to include generated menu.

For example add line:

          [include] (/var/cache/xdg-menu/fluxbox/boxrc)

> OpenBox

With xdg_menu

Generate menu with

    $ xdg_menu --format openbox3 --root-menu /etc/xdg/menus/arch-applications.menu >xdg-menu.xml

and manually add it into your menu.xml. For example, put xdg-menu.xml
into menu.xml and add:

    <menu id="Applications" />

into root-menu.

With update-menus

-   Uncomment openbox in /etc/update-menus.conf
-   run update-menus as root
-   change your menu.xml file to include generated menu.

For example, add following to root-menu:

    <menu id="xdg-menu" label="XDG Menu" execute="cat /var/cache/xdg-menu/openbox/menu.xml"/>

> Twm

With xdg_menu

Use

    $ xdg_menu --format twm --root-menu /etc/xdg/menus/arch-applications.menu >my-twm-menu

and add it into twmrc manually. In the case of twm derivatives with m4
preprocessing such as vtwm or ctwm it can be included by adding

    sinclude(`/PATH/TO/my-twm-menu')

to *twmrc.

With update-menus

-   Uncomment twm in /etc/update-menus.conf
-   Add into /etc/X11/twm/system.twmrc file applications menu (add
    following line:

     "apps"          f.menu "Applications"

into defops menu)

-   run update-menus as root
-   run twm -f /var/cache/xdg-menu/twm/twmrc

(You will also want to add your other customizations to
/etc/X11/twm/system.twmrc.)

> WindowMaker

With xdg_menu

Use

    $ xdg_menu --format WindowMaker --root-menu /etc/xdg/menus/arch-applications.menu >my-wm-menu

and add

    #include "my-wm-menu"

into your WindowMaker menu file.

You can also use the WPrefs "Application Menu Definitions", and add the
xdg command as a parameter in a "Generated Submenu" object.

With update-menus

-   Uncomment WindowMaker in /etc/update-menus.conf
-   run update-menus as root
-   add

    #include "/var/cache/xdg-menu/WindowMaker/wmrc"

into your menu file.

> Fvwm2

With xdg_menu

Generate menu

    $ xdg_menu --format fvwm2 --root-menu /etc/xdg/menus/arch-applications.menu >fvwm2-menu

and add menu into root menu

    read fvwm2-menu

    AddToMenu MenuFvwmRoot  "Root Menu"             Title
    +                       "&0. XDG Menu"          Popup xdg_menu

With update-menus

-   Uncomment fvwm2 in /etc/update-menus.conf
-   run update-menus as root
-   change your .fvwm2rc file to include generated menu. For example:

    AddToMenu MenuFvwmRoot  "Root Menu"             Title
    +                       "&0. XDG Menu"          Popup xdg_menu

    read /var/cache/xdg-menu/fvwm2/fvwm2rc

> BlackBox

With xdg_menu

    $ xdg_menu --format blackbox  --root-menu /etc/xdg/menus/arch-applications.menu >my-menu

Change your menu file to include generated menu.

For example add line:

    [include] (my-menu)

With update-menus

-   Uncomment blackbox in /etc/update-menus.conf
-   run update-menus as root
-   change your menu file to include generated menu.

For example add line:

    [include] (/var/cache/xdg-menu/blackbox/boxrc)

See also
--------

-   archlinux-xdg-menu
-   Free Desktop menu standard
-   A workaround for sawfish

Retrieved from
"https://wiki.archlinux.org/index.php?title=Xdg-menu&oldid=291490"

Category:

-   Desktop environments

-   This page was last modified on 3 January 2014, at 14:23.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
