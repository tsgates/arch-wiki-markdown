Openbox
=======

> Summary

A comprehensive guide on the installation and use of the Openbox window
manager.

> Overview

The Xorg project provides an open source implementation of the X Window
System – the foundation for a graphical user interface. Desktop
environments such as Enlightenment, GNOME, KDE, LXDE, and Xfce provide a
complete graphical environment. Various window managers offer
alternative and novel environments, and may be used standalone to
conserve system resources. Display managers provide a graphical login
prompt.

Openbox is a lightweight and highly configurable window manager with
extensive standards support. Its features are documented at the official
website. This article pertains to installing Openbox under Arch Linux.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Upgrading to Openbox 3.5                                           |
| -   3 Openbox as a stand-alone WM                                        |
| -   4 Openbox as a WM for desktop environments                           |
|     -   4.1 GNOME 2.24 and 2.26                                          |
|     -   4.2 GNOME 2.26 redux                                             |
|     -   4.3 KDE                                                          |
|     -   4.4 Xfce4                                                        |
|                                                                          |
| -   5 Openbox for multihead users                                        |
| -   6 Configuration                                                      |
|     -   6.1 Manual configuration                                         |
|     -   6.2 ObConf                                                       |
|     -   6.3 Application customization                                    |
|                                                                          |
| -   7 Menus                                                              |
|     -   7.1 Manual configuration of menus                                |
|     -   7.2 Icons in the menu                                            |
|     -   7.3 MenuMaker                                                    |
|     -   7.4 Obmenu                                                       |
|         -   7.4.1 Obm-xdg                                                |
|                                                                          |
|     -   7.5 XDG-menu                                                     |
|     -   7.6 openbox-menu                                                 |
|     -   7.7 Python-based xdg menu script                                 |
|     -   7.8 Openbox menu generators                                      |
|         -   7.8.1 obmenugen                                              |
|         -   7.8.2 obmenu-generator                                       |
|                                                                          |
|     -   7.9 Pipe menus                                                   |
|                                                                          |
| -   8 Startup programs                                                   |
|     -   8.1 Enabling autostart                                           |
|     -   8.2 Autostart script                                             |
|     -   8.3 Autostart directory                                          |
|                                                                          |
| -   9 Themes and appearance                                              |
|     -   9.1 Openbox themes                                               |
|     -   9.2 Cursors, icons, wallpapers                                   |
|                                                                          |
| -   10 Recommended programs                                              |
| -   11 Tips and tricks                                                   |
|     -   11.1 Window snap behaviour                                       |
|     -   11.2 File associations                                           |
|     -   11.3 Copy and paste                                              |
|     -   11.4 Window transparency                                         |
|     -   11.5 Xprop values for applications                               |
|         -   11.5.1 Xprop for Firefox                                     |
|                                                                          |
|     -   11.6 Linking the menu to a button                                |
|     -   11.7 Running a terminal emulator as desktop background           |
|         -   11.7.1 ToggleShowDesktop exception                           |
|                                                                          |
|     -   11.8 Switching between keyboard layouts                          |
|     -   11.9 Keyboard volume control                                     |
|         -   11.9.1 ALSA                                                  |
|         -   11.9.2 Pulseaudio                                            |
|         -   11.9.3 OSS                                                   |
|                                                                          |
| -   12 Troubleshooting Openbox 3.5                                       |
|     -   12.1 X server crashes                                            |
|     -   12.2 Autostarting unwanted applications in 3.5                   |
|     -   12.3 SSH agent no longer starting                                |
|     -   12.4 Openbox not registering with D-Bus                          |
|     -   12.5 Windows load behind the active window                       |
|                                                                          |
| -   13 See also                                                          |
+--------------------------------------------------------------------------+

Installation
------------

Install openbox, available in the Official Repositories. After
installation, you should copy the default configuration files rc.xml,
menu.xml, autostart, and environment to ~/.config/openbox:

Note: Do this as a regular user, not as root.

    $ mkdir -p ~/.config/openbox
    $ cp /etc/xdg/openbox/{rc.xml,menu.xml,autostart,environment} ~/.config/openbox

These four files form the basis of your openbox configuration. Each file
addresses a unique aspect of your configuration and the role of each
file is as follows:

 rc.xml
    This is the main configuration file. It defines keyboard shortcuts,
    themes, virtual desktops, and more.

menu.xml
    This file defines the content of the right-click menu. It defines
    launchers for applications and other shortcuts. See the #Menus
    section.

autostart
    This file is read by openbox-session at startup. It contains the
    programs that are run at startup. It is typically used to set
    environment variables, launch panels/docks, set background image or
    execute other startup scripts. See the Openbox Wiki.

environment
    This file is sourced by openbox-session at startup. It contains
    environment variables to be set in Openbox's context. Any variables
    you set here will be visible to Openbox itself and anything you
    start from its menus.

Upgrading to Openbox 3.5
------------------------

If you are upgrading to Openbox 3.5 or later from an earlier release, be
aware of these changes:

-   There is a new config file called environment that you should copy
    from /etc/xdg/openbox to ~/.config/openbox.
-   The config file previously called autostart.sh is now just called
    autostart. You should rename yours to remove the .sh from the end of
    the name.
-   Some of the configuration grammar in rc.xml has changed. While
    Openbox appears to understand the old options, it would be wise to
    compare your configuration to the one in /etc/xdg/openbox and look
    for changes that affect you.

Openbox as a stand-alone WM
---------------------------

Openbox can be used as a stand-alone window manager (WM). This is
usually simpler to install and configure than using Openbox with desktop
environments. Running openbox alone may reduce your system's CPU and
memory load.

To run Openbox as a stand-alone window manager, append the following to
~/.xinitrc:

    exec openbox-session

See xinitrc for details, such as preserving the logind (and/or
consolekit) session.

If you used another window manager previously (such as Xfwm) and now
Openbox will not start after logging out of X, try moving the autostart
folder:

    mv ~/.config/autostart ~/.config/autostart.bak

Note: python2-xdg is required for Openbox's xdg-autostart

Openbox as a WM for desktop environments
----------------------------------------

Openbox can be used as a replacement window manager for full-fledged
desktop environments. The method for deploying Openbox depends on the
desktop environment.

> GNOME 2.24 and 2.26

Create /usr/share/applications/openbox.desktop with the following lines:

    [Desktop Entry]
    Type=Application
    Encoding=UTF-8
    Name=OpenBox
    Exec=openbox
    NoDisplay=true
    # name of loadable control center module
    X-GNOME-WMSettingsModule=openbox
    # name we put on the WM spec check window
    X-GNOME-WMName=OpenBox

In gconf, set /desktop/gnome/session/required_components/windowmanager
to openbox:

    $ gconftool-2 -s -t string /desktop/gnome/session/required_components/windowmanager openbox

Finally, choose the GNOME session from the GDM sessions menu.

> GNOME 2.26 redux

If the previous guide for GNOME 2.24 fails:

If, when attempting to log into a "Gnome/Openbox" session -- and it
consistently fails to start, try the following. This is one way of
achieving your goal of using Openbox as the WM anytime you open a Gnome
session:

1.  Log into your Gnome-only session (it should still be using Metacity
    as its window manager).
2.  Install Openbox if you have not done so already
3.  Navigate your menus to System → Preferences → Startup Applications
    (possibly named 'Session' in older Gnome versions)
4.  Open Startup Application, select '+ Add' and enter the text shown
    below. Omit the text after #.
5.  Click the 'Add' button for the data entry window. Make sure the
    checkbox beside your new entry is selected.
6.  Log out from your Gnome session and log back in
7.  You should now be running openbox as your window manager.

    Name:    Openbox Windox Manager          # Can be changed
    Command: openbox --replace               # Text should not be removed from this line, but possibly added to it
    Comment: Replaces metacity with openbox  # Can be changed

This creates a startup list entry which is executed by Gnome each time
the user's session is started.

> KDE

1.  If you use KDM, select the "KDE/Openbox" login option.
2.  Open System Settings > Default Applications (in the Workspace
    Appearance and Behaviour section), and change the default window
    manager to Openbox (this will also avoid having to log out and log
    back in again).
3.  If you use startx, add exec openbox-kde-session to ~/.xinitrc
4.  From the shell:

    $ xinit /usr/bin/openbox-kde-session

> Xfce4

Log into a normal Xfce4 session. From your terminal, type:

    $ killall xfwm4 ; openbox & exit

This kills xfwm4, runs Openbox, and closes the terminal. Log out, being
sure to check the "Save session for future logins" box. On your next
login, Xfce4 should use Openbox as its window manager.

Alternatively, you can chooose Settings -> Session and Startup from
menu, go to the Application Autostart tab and add openbox --replace to
the list of automatically started applications.

To enable exiting from a session using xfce4-session, edit
~/.config/openbox/menu.xml.  If the file is not there, copy it from
 /etc/xdg/openbox/.  Look for the following entry:

     <item label="Exit Openbox">
       <action name="Exit">
         <prompt>yes</prompt>
       </action>
     </item>

Change it to:

     <item label="Exit Openbox">
       <action name="Execute">
         <prompt>yes</prompt>
        <command>xfce4-session-logout</command>
       </action>
     </item>

Otherwise, choosing "Exit" from the root-menu causes Openbox to
terminate its execution, leaving you with no window manager.

If you have a problem changing virtual desktops with the mouse wheel
skipping over desktops, edit ~/.config/openbox/rc.xml. Move the mouse
binds with... actions "DesktopPrevious" and "DesktopNext" from context
Desktop to the context Root. Note that you may need to create a
definition for the Root context as well.

When using the Openbox root-menu instead of Xfce's menu, you may exit
the Xfdesktop with this terminal command:

    $ xfdesktop --quit

Xfdesktop manages the wallpaper and desktop icons, requiring you to use
other utilities such as ROX for these functions.

(When terminating Xfdesktop, the above issue with the virtual desktops
is no longer a problem.)

If you want have rc.xml separated than your default openbox session
rc.xml

Edit the ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml or
(to make the change for all XFCE users)
/etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml: Replace the
xfwm startup command,

    <property name="Client0_Command" type="array">
      <value type="string" value="xfwm4"/>
    </property>

with the following:

    <property name="Client0_Command" type="array">
           <value type="string" value="openbox"/>
           <value type="string" value="--config-file"/>
           <value type="string" value="~/.config/xfce4/openbox/rc.xml"/>
    </property>

and also the menu, you can set the separated menu ex: xfce4-menu.xml ,
change it to your custom xfce4 rc.xml , but notice that the menu must be
place at ~/.config/openbox/

Openbox for multihead users
---------------------------

While Openbox provides better than average multihead support on its own,
the openbox-multihead-git package from the AUR provides a development
branch called Openbox Multihead that gives multihead users per-monitor
desktops. This model is not commonly found in floating window managers,
but exists mainly in tiling window managers. It is explained well on the
Xmonad web site. Also, please see README.MULTIHEAD for a more
comprehensive description of the new features and configuration options
found in Openbox Multihead.

Openbox Multihead will function like normal Openbox when only a single
head is available.

A downside to using Openbox Multihead is that it breaks the EWMH
assumption that one and only one desktop is visible at any time. Thus,
existing pagers will not work well with it. To remedy this,
pager-multihead-git can be found in the AUR and is compatible with
Openbox Multihead. Screenshots.

Finally, a new version of PyTyle that will work with Openbox Multihead
can also be found in the AUR: pytyle3-git.

Both pytyle3 and pager-multihead-git will work without Openbox Multihead
if only one monitor is active.

Configuration
-------------

There are several options for configuring Openbox settings:

> Manual configuration

To configure Openbox manually, edit the ~/.config/openbox/rc.xml file
with a text editor. The file has explanatory comments throughout, for
more details about editing it see the Openbox wiki.

> ObConf

ObConf is an Openbox configuration tool. It is used to set most common
preferences such as themes, virtual desktops, window properties, and
desktop margins. It can be installed with the obconf package, available
in the official repositories.

ObConf cannot configure keyboard shortcuts and certain other features.
For these features edit rc.xml manually. Alternatively, you can try
obkey from the AUR.

> Application customization

Openbox allows per-application customizations. This lets you define
rules for a given program. For example:

-   Start your web browser on a specific virtual desktop.
-   Open your terminal program with no window decorations (window
    chrome).
-   Make your bit-torrent client open at a given screen position.

Per-application settings are defined in ~/.config/openbox/rc.xml.
Instructions are in the file's comments. More details are found in the
Openbox wiki.

Menus
-----

The default Openbox menu includes a variety of menu items to get you
started. Many of these items launch applications you do not want, have
not installed yet, or never intend to install. You will surely want to
customize menu.xml at some point. There are a number of ways to do so.

> Manual configuration of menus

You can edit ~/.config/openbox/menu.xml with a text editor. Many of the
settings are self-explanatory. The article Help:Menus in the Openbox
wiki has extensive details.

> Icons in the menu

Since version 3.5.0 you can have icons next to your menu entries. To do
that :

1.  add <showIcons>yes</showIcons> in the <menu> section of the rc.xml
    file
2.  edit the menu entries in menu.xml and add icons="<path>" like this :

    <menu id="apps-menu" label="SomeApp" icon="/home/user/.icons/application.png">

then openbox --reconfigure or openbox --restart if the menus do not
update properly.

> MenuMaker

MenuMaker creates XML menus for several window managers including
Openbox. MenuMaker searchs your computer for executable programs and
creates a menu file from the result. It can be configured to exclude
certain application types (GNOME, KDE, etc) if you desire. It can be
installed with the menumaker package available in the official
repositories.

Once installed, generate a menu file (named menu.xml) by running the
program.

    $ mmaker -v OpenBox3     #  Will not overwrite an existing menu file.
    $ mmaker -vf OpenBox3    #  Force option permits overwriting the menu file.
    $ mmaker --help          #  See the full set of options for MenuMaker.

MenuMaker creates a comprehensive menu.xml. You may edit this file by
hand or regenerate it after installing software.

> Obmenu

Obmenu is a menu editor for Openbox. This GUI application is the best
choice for those who dislike editing XML code. Obmenu can be installed
with the package obmenu, available in the official repositories.

Once installed, run obmenu then add and remove applications as desired.

  

Obm-xdg

obm-xdg is a command-line tool that comes with Obmenu. It generates a
categorized sub-menu of installed GTK/GNOME applications.

To use obm-xdg with other menus, add the following line to
~/.config/openbox/menu.xml:

    <menu execute="obm-xdg" id="xdg-menu" label="xdg"/>

Then add the following line under your root-menu entry where you want to
have the menu appear:

    <menu id="xdg-menu"/>

Then run openbox --reconfigure to refresh the Openbox menu. You should
now see a sub-menu labeled xdg in your menu.

To use obm-xdg by itself, create ~/.config/openbox/menu.xml and add
these lines:

    <openbox_menu>
     <menu execute="obm-xdg" id="root-menu" label="apps"/>
    </openbox_menu>

Note:If you do not have GNOME installed, you need to install the package
gnome-menus for obm-xdg.

> XDG-menu

The archlinux-xdg-menu package in official repositories can
automatically generate a menu for Openbox from XDG files. For a guide on
using XDG-menu, see the Xdg-menu#OpenBox article.

> openbox-menu

Openbox-menu uses menu-cache from the LXDE Project to create dynamic
menus for Openbox.

If you get an error while trying to open this menu try adding icons to
the Openbox menu.

It can be installed with the package openbox-menu, available in the AUR.

> Python-based xdg menu script

This script is found in Fedora's Openbox package. You have only to put
the script somewhere and create a menu entry. The latest version of the
script can be found here.

Download the script from the above repository and Place int into any
directory you want.

Open menu.xml with your text editor and add the following entry. Of
course, you can modify the label as you see fit.

    <menu id="apps-menu" label="xdg-menu" execute="python2 /path/to/xdg-menu"/>

Save the file and run openbox --reconfigure.

Note:If you do not have GNOME installed, you need to install the package
gnome-menus for xdg-menu.

> Openbox menu generators

obmenugen

Obmenugen can be installed with the package obmenugen, available in the
AUR. creates the menu file from .desktop files. Obmenugen provides a
text file which filters (hides) menu items using basic regular
expressions.

    $ obmenugen               # Create a menu file
    $ openbox --reconfigure   # To see the menu you generated

obmenu-generator

Obmenu-generator is a pipe/static menu generator for Openbox with icon
support. You can install obmenu-generator from AUR.

The following command generates a pipe menu with icons:

    $ obmenu-generator -p -i

To see a list of options type this:

    $ obmenu-generator -h

> Pipe menus

Like other window managers, Openbox allows for scripts to dynamically
build menus (menus on-the-fly). Examples are system monitors, media
player controls, or weather monitors. Pipe menu script examples are
found in the Openbox:Pipemenus page at Openbox's site.

Some interesting pipe menus provided by Openbox users:

-   obfilebrowser — A pipe menu file browser.

http://xyne.archlinux.ca/projects/obfilebrowser/ || obfilebrowser

-   wifi-pipe — A pipe menu for scanning and connecting to wireless hot
    spots using netcfg.

https://github.com/pbrisbin/wifi-pipe || not packaged? (search in AUR)

-   obdevicemenu — A pipe menu for managing removable devices using
    Udisks.

https://bbs.archlinux.org/viewtopic.php?id=114702 || obdevicemenu

Startup programs
----------------

Openbox supports running programs at startup. This is provided by
command openbox-session.

> Enabling autostart

There are two ways to enable autostart:

1.  When using startx or xinit to begin a session, edit ~/.xinitrc.
    Change the line that executes openbox to openbox-session.
2.  When using GDM or KDM, selecting an Openbox session automatically
    runs the autostart script.

> Autostart script

Openbox provides a system-wide startup script which applies to all users
and is located at /etc/xdg/openbox/autostart. A user may also create his
own startup script to be executed after the system-wide script by
creating the file ~/.config/openbox/autostart. This file is not provided
by default and must be created by the user.

Further instructions are available in the Help:Autostart article at the
official Openbox site.

Note:The autostart files used to be named autostart.sh prior to OpenBox
3.5.0. While these scripts will presently still work, users who are
upgrading are advised to drop the .sh extension.

Note:All the programs in the autostart file should be run as daemons or
run in the background,otherwise the items in /etc/xdg/autostart/ won't
be started!

> Autostart directory

Openbox also starts any *.desktop files in /etc/xdg/autostart - this
happens regardless of whether a user startup script is present.
nm-applet, for example, installs a file at this location, and may cause
it to run twice for users with the usual
(sleep 3 && /usr/bin/nm-applet --sm-disable) & in their startup script.
There is a discussion on managing the effects of this at [1].

Themes and appearance
---------------------

See the main article: Openbox Themes and Apps#Themes and appearance

> Openbox themes

Themes control the appearance of windows, titlebars, and buttons. They
also control menu appearance and on-screen display (OSD). Some Openbox
themes can be installed with the package openbox-themes, available in
the official repositories.

> Cursors, icons, wallpapers

Xcursor themes can be installed with the package xcursor-themes,
available in the official repositories, or with other packages from such
as xcursor-bluecurve, xcursor-vanilla-dmz or xcursor-pinux. Many other
themes can be found in the official repositories or the AUR.

Icon themes are also available in the repositories, for example
lxde-icon-theme, tangerine-icon-theme or gnome-icon-theme can be found
in the official repositories with many more in the AUR.

Wallpapers are easily set with utilities such as Nitrogen, Feh or
hsetroot.

Please see Openbox Themes and Apps for information on these GUI
customizations.

Recommended programs
--------------------

See the main article: Openbox Themes and Apps#Recommended programs

Tips and tricks
---------------

> Window snap behaviour

Windows 7 and other VMs supports a window behaviour to snap windows when
they are moved to the edge of the screen. This effect can also be
achieved through an Openbox keybinding. Openbox supports specifying
percentages, and actions. To simulate Aero Snap:

    ~/.config/openbox/rc.xml

    <keybind key="W-Left">
        <action name="UnmaximizeFull"/>
        <action name="MaximizeVert"/>
        <action name="MoveResizeTo">
            <width>50%</width>
        </action>
        <action name="MoveToEdge"><direction>west</direction></action>
    </keybind>
    <keybind key="W-Right">
        <action name="UnmaximizeFull"/>
        <action name="MaximizeVert"/>
        <action name="MoveResizeTo">
            <width>50%</width>
        </action>
        <action name="MoveToEdge"><direction>east</direction></action>
    </keybind>

The only issue with any methods around, is that once maximized to an
edge - it stays full (vertically) until you maximize and restore. So you
can add the next few lines to simulate the other windows behaviors
(maximize, restore). That will speed up pulling a window from a screen
edge as well.

    ~/.config/openbox/rc.xml

    <keybind key="W-Down">
        <action name="Unmaximize"/>
    </keybind>
    <keybind key="W-Up">
        <action name="Maximize"/>
    </keybind>

Then reconfigure Openbox and try it.

openbox --reconfigure

  
 As an alternative/extension you can use opensnap. It provides Aero Snap
like functionality and resizes windows if you drag them to an edge of
the screen. It does not provide keyboard shortcuts however.

> File associations

Because Openbox and the applications you use with it are not
well-integrated you might run into the issues with your browser. Your
browser may not know which program it is supposed to use for certain
types of files.

A package in the AUR called gnome-defaults-list contains a list of
file-types and programs specific to the Gnome desktop. The list is
installed to /etc/gnome/defaults.list.

Open this file with your text editor. Here you can replace a given
application with the name of the program of your choosing. For example,
replace totem with vlc  or  eog with mirage. Save the file to
~/.local/share/applications/defaults.list.

Another way of setting file associations is to install package
perl-file-mimeinfo from the official repositories and invoke mimeopen
like this:

    mimeopen -d /path/to/file

You are asked which application to use when opening /path/to/file:

    Please choose a default application for files of type text/plain
           1) notepad  (wine-extension-txt)
           2) Leafpad  (leafpad)
           3) OpenOffice.org Writer  (writer)
           4) gVim  (gvim)
           5) Other...

Your answer becomes the default handler for that type of file. Mimeopen
is installed as /usr/bin/perlbin/vendor/mimetype.

> Copy and paste

From a terminal Ctrl+Ins for copy and Shift+Ins for paste.

Also Ctrl+Shift+c for copy and mouse middle-click for paste (in
terminals).

Other applications most likely use the conventional keyboard shortcuts
for copy and paste.

> Window transparency

The program transset-df is available in the official repositories. With
transset-df you can enable window transparency on-the-fly.

For instance by placing the following in the <mouse> section you can
have your mouse adjust window transparency by scrolling while hovering
over the title bar:

    ~/.config/openbox/rc.xml

    <context name="Titlebar">
        . . .
        <mousebind button="Up" action="Click">
            <action name= "Execute" >
            <execute>transset-df -p .2 --inc  </execute>
            </action>
        </mousebind>
        <mousebind button="Down" action="Click">
            <action name= "Execute" >
            <execute>transset-df -p .2 --dec </execute>
            </action>
        </mousebind>
          . . .
    </context>

Warning:It appears to work only when no additional actions are defined
within the action group.

> Xprop values for applications

Xprop can be installed with the package xorg-xprop, available in the
official repositories.

If you use per-application settings frequently, you might find this bash
alias handy:

    alias xp='xprop | grep "WM_WINDOW_ROLE\|WM_CLASS" && echo "WM_CLASS(STRING) = \"NAME\", \"CLASS\""'

To use, run xp and click on the running program that you would like to
define with per-app settings. The result displays only the info that
Openbox requires, namely the WM_WINDOW_ROLE and WM_CLASS (name and
class) values:

    $ xp
    WM_WINDOW_ROLE(STRING) = "roster"
    WM_CLASS(STRING) = "gajim.py", "Gajim.py"
    WM_CLASS(STRING) = "NAME", "CLASS"

Xprop for Firefox

For whatever reason, Firefox and like-minded equivalents ignore
application rules (e.g. <desktop>) unless class="Firefox*" is used. This
applies irrespective of whatever values xprop may report for the
program's WM_CLASS.

> Linking the menu to a button

Some people want to link the Openbox menu (or any menu) to an object.
This is useful for creating a panel button to pop up a menu. Although
Openbox does not provide this, a program called xdotool simulates a
keypress. Openbox can be configured to bind that keypress to the
ShowMenu action.

After installing xdotool, add the following to the <keyboard> section:

    ~/.config/openbox/rc.xml

    <keybind key="A-C-q">
        <action name="ShowMenu">
            <menu>root-menu</menu>
        </action>
    </keybind>

Then execute openbox --reconfigure or openbox --restart to use the new
configuration. The following command summons a menu at your cursor
position. The command may given as-is, linked to an object, or placed in
a script.

    $ xdotool key ctrl+alt+q

Of course, change the key shortcut to your liking. Here is a snippet
from a Tint2 configuration file which pops up a menu when the clock area
is clicked. Each key combination is set to open a menu within Openbox's
rc.xml configuration file. The right‑click menu is different from the
left‑click menu:

    clock_rclick_command = xdotool key --clearmodifiers "ctrl+XF86PowerOff"
    clock_lclick_command = xdotool key --clearmodifiers "alt+XF86PowerOff"

> Running a terminal emulator as desktop background

With Openbox, running a terminal as desktop background is easy. You will
not need devilspie here.

The following example shows how to run the terminal emulator Urxvt as
desktop background:

First you must enable transparency, open your ~/.Xdefaults file (if it
does not exist yet, create it).

    URxvt*transparent:true
    URxvt*scrollBar:false
    URxvt*geometry:124x24    #I do not use the whole screen, if you want a full screen term do not bother with this and see below.
    URxvt*borderLess:true
    URxvt*foreground:Black   #Font color. My wallpaper is White, you may wish to change this to White.

Then add the following to the <applications> section:

    ~/.config/openbox/rc.xml

    <application name="urxvt">
        <decor>no</decor>
        <focus>yes</focus>
        <position>
            <x>center</x>
            <y>20</y>
        </position>
        <layer>below</layer>
        <desktop>all</desktop>
        <maximized>true</maximized> #Only if you want a full size terminal.
    </application>

The magic comes from the <layer>below</layer> line, which place the
application under all others. Here urxvt is displayed on all desktops,
change it to your convenience.

Tip:Instead of using <application name="urxvt">, you can use another
name ("urxvt-bg" for example), and use the -name option when starting
uxrvt. That way, only the urxvt terminals which you choose to name
urxvt-bg would be captured and modified by the application rule in
rc.xml. For example:

    $ urxvt -name urxvt-bg

ToggleShowDesktop exception

If you use ToggleShowDesktop to minimize all your application and show
the desktop it will also minimize the urxvt window. Several methods are
available to bypass this, but none works properly:

-   one method is explained in this forum post. This involves editing
    Urxvt's source code.

Warning:This method seems to have been broken in a recent update, now
leading to a memory leak when the patched Urxvt is run.

-   the best method is outlined here. It still has a big disadvantage:
    it makes ToggleShowDesktop a one-way action, not restoring the other
    desktop applications when ToggleShowDesktop is run for a second
    time. It does create the opportunity to use a different terminal
    emulator than Urxvt, however.

> Switching between keyboard layouts

If you don't want to use a separate program for managing keyboard
layouts, you can manually configure X to switch layouts on certain key
combinations. See Xorg#Switching_between_keyboard_layouts for
instructions.

> Keyboard volume control

ALSA

If you use ALSA for sound, you can use the amixer program (part of the
alsa-utils package) to adjust the sound volume. You can use Openbox's
keybindings to map different shortcuts to actions. If you want to use
the multimedia keys, but do not know their names, you could look at the
Multimedia Keys page to find out.

For example, add the following in the <keyboard> section:

    ~/.config/openbox/rc.xml

    <keybind key="W-Up">
        <action name="Execute">
            <command>amixer set Master 5%+</command>
        </action>
    </keybind>

This binds Super+↑ to increase your master ALSA volume by 5%.
Corresponding binding for volume down:

    ~/.config/openbox/rc.xml

    <keybind key="W-Down">
        <action name="Execute">
            <command>amixer set Master 5%-</command>
        </action>
    </keybind>

As another example you can also use the XF86Audio* keybindings:

    ~/.config/openbox/rc.xml

    <keybind key="XF86AudioRaiseVolume">
        <action name="Execute">
            <command>amixer set Master 5%+ unmute</command>
        </action>
    </keybind>
    <keybind key="XF86AudioLowerVolume">
        <action name="Execute">
            <command>amixer set Master 5%- unmute</command>
        </action>
    </keybind>
    <keybind key="XF86AudioMute">
        <action name="Execute">
            <command>amixer set Master toggle</command>
        </action>
    </keybind>

The above example should work for the majority of multimedia keyboards.
It should enable to raise, lower and mute the Master control of your
audio device by using the respective multimedia keyboard keys. Notice
also that in this example:

-   The "Mute" key should unmute the Master control if it is already in
    mute mode.
-   The "Raise" and "Lower" keys should unmute the Master control if it
    is in mute mode.

Pulseaudio

If you are using PulseAudio with ALSA as a backend the above keybinding
are slightly different as amixer must be told to use PulseAudio. As
always, add the following to the <keyboard> section to get the proper
behaviour:

    ~/.config/openbox/rc.xml

    <keybind key="XF86AudioRaiseVolume">
        <action name="Execute">
            <command>amixer -D pulse set Master 5%+ unmute</command>
        </action>
    </keybind>
    <keybind key="XF86AudioLowerVolume">
        <action name="Execute">
            <command>amixer -D pulse set Master 5%- unmute</command>
        </action>
    </keybind>
    <keybind key="XF86AudioMute">
        <action name="Execute">
            <command>amixer set Master toggle</command>
        </action>
    </keybind>

This keybindings should work for most of the systems. Other examples can
be found here.

OSS

With OSS, you can use keybindings to raise or lower specific mixers.
This is useful in cases where you wish to change the volume of a
specific application (such as an audio player) without changing the
system's volume. Note that the application must be first set up to use
its own mixer. In this example, MPD is configured to have its own mixer,
named mpd:

    ~/.config/openbox/rc.xml

    <keybind key="KEY_BINDING">
        <action name="Execute">
            <command>ossmix -- mpd -1</command>
        </action>
    </keybind>

This example decreases the volume of the mpd mixer by one dB. To
increase the volume, replace the mixer value (-1) with a positive one.
The -- that appears after ossmix are added, as listed in ossmix's man
page, to prevent any negative value from being treated as an argument.

Troubleshooting Openbox 3.5
---------------------------

> X server crashes

Problems have been detected after upgrade to version 3.5, that the X
server might crash in attempt to start Openbox, ending with this error
message:

    (metacity:25137): GLib-WARNING **: In call to g_spawn_sync(), exit status of a child process \
                       was requested but SIGCHLD action was set to SIG_IGN and ECHILD was received by waitpid(), so exit \
                       status can't be returned. This is a bug in the program calling g_spawn_sync(); either do not request \
                       the exit status, or do not set the SIGCHLD action.
    xinit: connection to X server lost
    waiting for X server to shut down

In this particular case, some problem with metacity package has been
identified as the cause of the X server crash issue. To solve the
problem reinstall the metacity and compiz-decorator-gtk packages. If
that does not solve the problem, try removing them.

Also, plenty of similar cases have been found on the Internet, that not
only metacity package might be causing the X server to crash. Thus,
whatever else instead of metacity you get in the error output message,
try to reinstall it (or remove if necessary) in an attempt to get rid of
this X server crash.

> Autostarting unwanted applications in 3.5

If unwanted applications start with your Openbox session even though
they are not listed in your ~/.config/openbox/autostart, check the
~/.config/autostart/ directory, it might contain the residues from your
previously used desktop environment (GNOME, KDE, etc.), and remove
unwanted files.

> SSH agent no longer starting

Whereas Openbox 3.4.x allowed launching an SSH agent from
~/.config/openbox/autostart, with 3.5 that no longer seems to work. You
need to put the following code in ~/.config/openbox/environment:

    SSHAGENT="/usr/bin/ssh-agent"
    SSHAGENTARGS="-s"
    if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
            eval `$SSHAGENT $SSHAGENTARGS`
            trap "kill $SSH_AGENT_PID" 0
    fi

> Openbox not registering with D-Bus

Just like with SSH agent, lots of people used to have D-Bus code in
~/.config/openbox/autostart - which no longer works (e.g. Thunar does
not see any removable devices anymore).

> Windows load behind the active window

Some application windows (such as Firefox windows) may load behind the
currently active window, causing you to need to switch to the window you
just created to focus it. To fix this behavior add this to your
~/.config/openbox/rc.xml file, inbetween the <openbox_config> and
</openbox_config> tags:

    <applications>
      <application class="*">
        <focus>yes</focus>
      </application>
    </applications>

See also
--------

-   Openbox Website – The official website
-   Planet Openbox – Openbox news portal
-   Box-Look.org – A good resource for themes and related artwork
-   Openbox Hacks and Configs Thread @ Arch Linux Forums
-   Openbox Screenshots Thread @ Arch Linux Forums
-   Using GNOME 3 with Openbox Tutorial

Retrieved from
"https://wiki.archlinux.org/index.php?title=Openbox&oldid=252386"

Category:

-   Stacking WMs
