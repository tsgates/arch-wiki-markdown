Guake
=====

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

  Summary
  -----------------------------------------------------
  This article demonstrates the installation of Guake

Guake is a top-down terminal for GNOME (in the style of Yakuake for KDE,
Tilda or the terminal used in Quake).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Usage                                                              |
| -   3 Autostartup                                                        |
| -   4 Window width                                                       |
| -   5 Dual monitor workaround                                            |
| -   6 'Ctrl' Keybind Problem                                             |
+--------------------------------------------------------------------------+

Installation
------------

Install guake, available in the official repositories.

Also the development version is available and in the AUR: guake-git.

Usage
-----

Once installed, you can start Guake from the terminal with:

    $ guake

After guake has started you can right click on the interface and select
Preferences to change the hotkey to drop the terminal automatically, by
default it is set to F12.

Autostartup
-----------

You may want Guake to load on starting up Desktop Environment. To do
this, you need to

    # cp /usr/share/applications/guake.desktop /etc/xdg/autostart/

See Autostarting for more info.

Window width
------------

Guake takes all the width of your display by default and there's no such
option in "Preferences". To change width you can edit the program itself
which is python script.

    # nano /usr/bin/guake

Find that string

    width = 100

It is width value in percents, change it to whatever you like.

If you want to align new "narrowed" window left or right find string

    if halignment == ALIGN_CENTER:

and replace CENTER with LEFT or RIGHT.

Dual monitor workaround
-----------------------

The traditional patch for dual monitors is no longer available, but a
workaround is to define the start points for the window.

    # nano /usr/bin/guake

Find that string

    window_rect.y = 0 

is the default point in Y coordinate if you need change for the width of
top desktop bar (or the long from the top of the bar to below), if you
use it, and add the default x coordinate in the line below, for
positioned the window I use

                      window_rect.x = total_width - window_rect.width
            window_rect.y = 24 
            window_rect.x = 1024 
            return window_rect

My first window is 1024 pixels and my second window is 1280 pixels, so
guake get size of the first window from left to right which is why I
must increase the width by a percentage

Find that string

    width = 100

Change de value 100 for a more greater, in my case 125 ( 1280 divided by
1024 and multiplicated by 100)

  

'Ctrl' Keybind Problem
----------------------

As of guake 0.4.2-7, there has been a noted bug affecting multiple users
concerning the use of the 'Ctrl' key on the Keyboard Shortcuts to toggle
guake visibility in the "Keyboard shortcuts" tab of guake-prefs (i.e.
Users that setup 'Ctrl+Shift+z' to open the guake console can open it by
pressing 'Shift+z', hence having the Ctrl key-bind irrelevant.
••••••••••• There is a bug in the program that stores the settings in
Toggle Guake Visibility that places the Ctrl string as "<Primary>"
instead of "<Control>".

The workaround is to use the command-line gconftool-2 from gconf
package, get the current string shortcut string from
/apps/guake/keybindings/global/show_hide, and replace all instances of
"<Primary>" to "<Control>".

To get what the current keyboard shortcut string is:

    # gconftool-2 -g /apps/guake/keybindings/global/show_hide

To activate the guake console with Ctrl+Shift+z for example:

    # gconftool-2 -t string -s /apps/guake/keybindings/global/show_hide "<Control><Shift>z"

It would be easier to use the graphical gconftool equivalent
gconf-editor to browse for and edit the
/apps/guake/keybindings/global/show_hide string. Replace "<Primary>" in
the string with "<Control>".

Alternatively you can use this script to replace instances of <Primary>
with <Control> in the /apps/guake/keybindings/global/show_hide string:

    ~/replaceit.sh

    if which gconftool-2 &> /dev/null
     then
      val=$(printf "%s" $(gconftool-2 -g /apps/guake/keybindings/global/show_hide))
      newval=${val/"<Primary>"/"<Control>"}
      if [ "$newval" = "$val" ]
        then echo "No changes made. Could not find or replace <Primary> in your settings."
       else
        echo "Replacing old string $val with new string:$newval"
        gconftool-2 -t string -s /apps/guake/keybindings/global/show_hide "$newval"
      fi
     else
      echo "gconftool-2 not found. Please install gconf. Exiting..."
    fi

Retrieved from
"https://wiki.archlinux.org/index.php?title=Guake&oldid=240326"

Category:

-   Terminal emulators
