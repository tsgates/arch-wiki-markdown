PekWM
=====

The Pek Window Manager is written by Claes Nästen. The code is based on
the aewm++ window manager, but it has evolved enough that it no longer
resembles aewm++ at all. It also has an expanded feature-set, including
window grouping (not unlike to ion3, pwm, or even fluxbox), auto
properties, xinerama and keygrabber that supports keychains, and much
more.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Start                                                              |
|     -   2.1 Method 1: kdm/gdm                                            |
|     -   2.2 Method 2: xinitrc                                            |
|                                                                          |
| -   3 Configuring PekWM                                                  |
|     -   3.1 Menus                                                        |
|         -   3.1.1 MenuMaker                                              |
|         -   3.1.2 Manually                                               |
|                                                                          |
|     -   3.2 Hotkeys                                                      |
|     -   3.3 Mouse                                                        |
|     -   3.4 Startup Programs                                             |
|     -   3.5 Variables                                                    |
|     -   3.6 Autoproperties                                               |
|                                                                          |
| -   4 Themes                                                             |
|     -   4.1 GTK Appearance                                               |
|                                                                          |
| -   5 Setting a Wallpaper                                                |
| -   6 Common Problems                                                    |
|     -   6.1 When using Nvidia TwinView, Windows maximize across both     |
|         screens                                                          |
|     -   6.2 Compositing/transparency does not work properly              |
|                                                                          |
| -   7 External Links                                                     |
+--------------------------------------------------------------------------+

Installation
------------

Install PekWM from the repositories.

    pacman -S pekwm

Start
-----

> Method 1: kdm/gdm

First install and enable kdm or gdm. For instructions on how to enable
login managers, see the Display Manager page.

PekWM be added to the session types. Select PekWM from the session menu
right before logging in.

> Method 2: xinitrc

In your home folder add the code below to your .xinitrc file
(~/.xinitrc)

    exec pekwm

Configuring PekWM
-----------------

The main config is stored in the file ~/.pekwm/config. It controls all
of the rest of your config. It controls the workspace and viewports
settings, the menu and harbour behaviour, window edge resistance, and
more. There is an example file with complete documentation to be found
in the PekWM documentation here.

> Menus

PekWM will by default when installed from the arch repositiories come
with some pre-created menus. These do not reflect what exists on your
system and as such are highly likely to be very inaccurate to what you
actually have installed. These are to be seen as an example and not
something that you should use without editing.

Your menus are stored in .pekwm/menu in your home directory
(~/.pekwm/menu)

MenuMaker

One way to automatically set up menus for your installed applications is
Menumaker. To set up menus of all your installed applications run it
with the following command:

    mmaker --no-desktop pekwm

Note:Note that this will not overwrite your existing menu file. If you
want it to overwrite, add the -f flag to the above command.

To see a full list of options, run mmaker --help

This will give you a pretty thorough menu. Now you can modify the menu
file by hand, or simply regenerate the list whenever you install new
software.

Manually

As I've already mentioned the menu file is ~/.pekwm/menu. The syntax for
the menu file is fairly straightforward. A simple entry has the
following structure:

    Entry = "NAME" { Actions = "Exec COMMAND &" }

A submenu has the following syntax:

    Submenu = "NAME" {
         Entry = "NAME" { Actions = "Exec COMMAND &" }
         Entry = "NAME" { Actions = "Exec COMMAND &" }
    }

(Make sure these brackets are always closed, or you will have errors and
your menu will not display)

To add a separator line to the menu, use the following:

    Separator {}

PekWM also supports dynamic menus. These are basically menu entries or
submenus that display the output of a script that is run every time the
entry or submenu is accessed.

You can find some dynamic menus online. Check the exact syntax the menu
requires, as they can vary. There are not that many dynamic menu scripts
around, unfortunately. You can find dynamic menus for Gmail and network
connections here, and one to display the time and date here. There is
also a project called pekwm_menu_tools which aim to be a set of useful
applications for generating dynamic menus for PekWM.

> Hotkeys

The hotkey settings are stored in ~/.pekwm/keys. This file controls all
the keyboard bindings and keychains used in PekWM. You can add keyboard
bindings to launch programs or to perform actions in PekWM, such as show
a menu, move a window, switch desktops, etc. For a full list of PekWM's
actions, see the documentation.

You can have more than one action assigned to one key combination. To do
so, just separate the actions by a semicolon. Here is an example:

    KeyPress = "Ctrl Mod1 R" { Actions = "Exec osdctl -s 'Reconfiguring'; Reload" }

When you press Ctrl+Alt+R Pekwm will display on the screen the text
'Reconfiguring' (osdctl -s 'Reconfiguring') and reconfigure (Reload).
(Note that this requires osdsh to be installed)

You can also do "chains" of keys, so for example the code

    Chain = "Ctrl Mod1 C" {
         KeyPress = "Q" { Actions = "MoveToEdge TopLeft" }
         KeyPress = "W" { Actions = "MoveToEdge TopCenterEdge" }
    }

Would make it so that if you first press Ctrl+Alt+C and then Q you move
the active window to the top left corner of the screen, and if you press
Ctrl+Alt+C and then W you move the window to the top center edge.

> Mouse

The Mouse settings are stored in ~/.pekwm/mouse. This file is also
rather self-explanatory in it's layout. For example:

    FrameTitle {
         ButtonRelease = "1" { Actions = "Raise; Focus" }
    }

means that if you release button 1 (usually left mouse button) over the
frame title of a window the window will be "Raised" above the other
windows and it will become the focused window.

One of the things PekWM is set up to do by default is to focus windows
when the mouse moves over them (as opposed to the "click to focus"
style). This is one thing that quite a few users would like to change to
the more "traditional" way. To change this, look for the following lines
in the file and do what they say (there are quite a few of the first,
but only one occurrence of the second):

    # Remove the following line if you want to use click to focus.
    # Uncomment the following line if windows should raise when clicked.

> Startup Programs

The startup programs file is ~/.pekwm/start. If you'd like to display a
wallpaper or launch a panel whenever Pekwm is started, you can add
entries for these things in that file. Note, though, that these
applications are run every time Pekwm is started -- including when you
run 'Restart' in the root menu. The commands are executed only after
Pekwm is started.

To add an application, use the following structure:

    nameofapplication &

The & at the end is crucial, or anything after it won't be run. To give
you an example of what this file could look like, here is mine:

    xfce4-panel &
    conky &
    hsetroot -fill ~/images/darkwood.jpg &

Before you can use this file, you will have to make it executable with
the following command:

    chmod +x ~/.pekwm/start

> Variables

The Variables file contains the general variables used in PekWM, the
default entry should explain it quite clearly:

    $TERM="xterm -fn fixed +sb -bg white -fg black"

Whenever the variable $TERM is used in any of PekWM's configuration
files, the command xterm -fn fixed +sb -bg white -fg black will be run.
For example changing it to:

    $TERM="urxvt"

would mean that urxvt would be loaded for terminal commands.

> Autoproperties

If you'd like certain applications to open on certain workspaces, have a
certain title, skip the (window) menus, or be automatically tabbed
together, you can specify all that here. It is probably the most
confusing configuration file in PekWM, but it is also the most powerful
file. The amount of things that can be set in this file are far too
great to fit here, but it is explained in detail in the autoproperties
page of the documentation. The default ~/.pekwm/autoproperties file also
contains a crash course to autopropping.

Themes
------

Links to some theme sites are provided below. To install a theme extract
the archive to a themesdir the default ones are:

-   global - /usr/share/pekwm/themes
-   user only - ~/.pekwm/themes

> GTK Appearance

To customize the look of GTK applications you can use LXAppearance
(available in the repos).

Setting a Wallpaper
-------------------

Since PekWM is just a window manager it requires you to use a separate
program to set a desktop wallpaper. Some popular ones are:

-   feh
-   Nitrogen
-   xli
-   esetroot
-   hsetroot
-   habak

Common Problems
---------------

> When using Nvidia TwinView, Windows maximize across both screens

Edit ~/.pekwm/config and look for the line:

    HonourRandr = "True"

and change it to

    HonourRandr = "False"

Source

> Compositing/transparency does not work properly

As of v0.1.11, PekWM does not appear to correctly support compositing.
Basic xcompmgr works, but transparent docks and panels do not, and
shading windows creates graphical glitches, to fix that you can set the
transparency of every window to .999 (or any other value) with devilspie
and transset-df, then shading windows works normally.

An example of a devilspie script setting the transparency of every
window to .999 with transset-df:

    (spawn_async (str "transset-df -i " (window_xid) " .999" ))

External Links
--------------

-   Pekwm Homepage
-   gentoo-wiki PekWM page
-   Box-Look PekWM Themes
-   Hewphoria PekWM Themes
-   Freshmeat PekWM Themes

Retrieved from
"https://wiki.archlinux.org/index.php?title=PekWM&oldid=252272"

Category:

-   Stacking WMs
