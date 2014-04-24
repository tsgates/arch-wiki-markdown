Enlightenment
=============

Related articles

-   Desktop environment
-   Display manager
-   Window manager

From the Enlightenment wiki:

The Enlightenment desktop shell provides an efficient yet breathtaking
window manager based on the Enlightenment Foundation Libraries along
with other essential desktop components like a file manager, desktop
icons and widgets. It boasts an unprecedented level of theme-ability
while still being capable of performing on older hardware or embedded
devices.

Contents
--------

-   1 Enlightenment
    -   1.1 Installation
        -   1.1.1 From the AUR
    -   1.2 Starting Enlightenment
        -   1.2.1 Graphical log-in
        -   1.2.2 Starting Enlightenment manually
    -   1.3 Configuration
        -   1.3.1 Network
        -   1.3.2 Polkit agent
        -   1.3.3 GNOME Keyring integration
    -   1.4 Themes
    -   1.5 Modules and Gadgets
        -   1.5.1 "Extra" modules
    -   1.6 Troubleshooting
        -   1.6.1 Compositing
        -   1.6.2 Unreadable fonts
-   2 Enlightenment DR16
    -   2.1 To install E16
    -   2.2 Basic Configuration
        -   2.2.1 Background images
        -   2.2.2 Start/Restart/Stop Scripts
        -   2.2.3 Compositor
-   3 See also

Enlightenment
-------------

This is comprised of both the Enlightenment window manager and
Enlightenment Foundation Libraries (EFL), which provide additional
desktop environment features such as a toolkit, object canvas, and
abstracted objects. It has been under development since 2005, but in
February 2011 the core EFLs saw their first stable 1.0 release.

> Installation

Enlightenment can be installed with the package enlightenment, available
in the official repositories.

You might also want to install terminology, which is an EFL based
terminal emulator, and integrates well with Enlightenment.

From the AUR

Warning:Some of these PKGBUILDs use unstable development code. Use them
at your own risk.

Development PKGBUILDs which download and install the very latest
development code are available in the AUR as enlightenment-git and its
dependencies.

The following are EFL based applications, most in early stage of
development and not yet released:

-   ecrire-git – Ecrire text editor
-   emprint-git – Emprint screenshot tool
-   enjoy-git – Enjoy music player
-   eperiodique - Eperiodique periodic table viewer
-   ephoto-git – Ephoto picture viewer
-   epour & epour-git – Epour Bittorrent client
-   equate-git – Equate calculator
-   eruler-git – Eruler on-screen ruler and measurement tools
-   efbb-git – Escape from Booty Bay angry birds style game
-   elemines-git – Elemines minesweeper style game
-   espionage-git – Espionage D-Bus inspector
-   ev-git – ev simple picture viewer
-   eve-git – Eve web browser
-   rage-git - Rage video player

> Starting Enlightenment

Graphical log-in

Simply choose Enlightenment session from your favourite display manager.

> Entrance

Warning:Entrance is highly experimental, and does not have proper
systemd support. Use it at your own risk.

Enlightenment has a new display manager called Entrance, and is
available in the AUR under the entrance-git package. Entrance is quite
sophisticated and its configuration is controlled by /etc/entrance.conf.
It can be used by enabling entrance.service using systemd.

Starting Enlightenment manually

If you prefer to start Enlightenment manually from the console, add the
following line to your ~/.xinitrc file:

    ~/.xinitrc

    exec enlightenment_start

After that Enlightenment can be launched by typing startx. See xinitrc
for details.

> Configuration

Enlightenment has a sophisticated configuration system that can be
accessed from the Main menu's Settings submenu.

Network

> ConnMan

Enlightenment's preferred network manager is ConnMan available in the
official repositories as connman package. Follow the instructions on
Connman to do the configuration.

For extended configuration, you may also install EConnman (available in
AUR as econnman or econnman-git) and its associated dependencies.

> NetworkManager

You can also use networkmanager to manage your network connections.
Follow the instructions on NetworkManager to do the configuration.

You probably also need network-manager-applet to help with your
settings. You may want to add it to the start up programs so every time
Enlightenment starts it appears on systray. For that you should go to
Settings Panel -> Apps -> Startup Applications -> System and activate
Network.

Polkit agent

Enlightenment does not have a graphical polkit authentication agent, so
if you want to access some privileged actions (e.g. mount a filesystem
on a system device), you have to install one, and autostart it. For that
you should go to Settings Panel -> Apps -> Startup Applications ->
System and activate it.

GNOME Keyring integration

It is possible to use gnome-keyring in Enlightenment. However, at the
time of writing, you need a small hack to make it work in full. First,
you must tell Enlightenment to autostart gnome-keyring. For that you
should go to Settings Panel -> Apps -> Startup Applications -> System
and activate Certificate and Key Storage, GPG Password Agent, SSH Key
Agent and "Secret Storage Service". After this, you should edit your
~/.profile and add the following:

      if [ -n "$DESKTOP_SESSION" ];then 
         # No point to start gnome-keyring-daemon if ssh-agent is not up 
         if [ -n "$SSH_AGENT_PID" ];then 
             eval $(gnome-keyring-daemon --start) 
             export SSH_AUTH_SOCK export GPG_AGENT_INFO
             export GNOME_KEYRING_CONTROL
         fi
     fi

This should export the variables you need for your key management at
your next log-in. A big thanks to [1] for finding the missing piece of
the puzzle!

More information on this topic in the GNOME Keyring article.

> Themes

More themes to customize the look of Enlightenment are available from:

-   exchange.enlightenment.org
-   e17-stuff.org
-   relighted.c0n.de for the default theme in 200 different colors
-   git.enlightenment.org (git clone the theme you like, run 'make' and
    you end up with a .edj theme file)
-   packages.bodhilinux.com has a good collection (you will need to
    extract the .edj file from the .deb; bsdtar will do this and is part
    of the base ArchLinux install). A nice catalog can be seen at their
    wiki.

You can install the themes (coming in .edj format) using the theme
configuration dialog or by moving them to ~/.e/e/themes.

Note:Enlightenment does not provide a stable theme API, and there have
been numerous theme API changes over the years, even after E17 was
released. Themes that have not been updated regularly are unlikely to
work.

> Modules and Gadgets

Module
    Name used in enlightenment to refer to the "backing" code for a
    gadget.
Gadget
    Front-end or user interface that should help the end users of
    Enlightenment do something.

Many Modules provide Gadgets that can be added to your desktop or on a
shelf. Some Modules (such as CPUFreq) only provide a single Gadget while
others (such as Composite) provide additional features without any
gadgets. Note that certain gadgets such as Systray can only be added to
a shelf while others such as Moon can only be loaded on the desktop.

"Extra" modules

Warning:These are 3rd party modules and not officially supported by the
Enlightenment developers. They are also pulled directly from git, so
they are development code that may or may not work at any time. Use at
your own risk.

Beyond the modules described here, more "extra" modules are available
from e-modules-extra-git.

> Places

Places is a gadget that will help you browse files on various devices
you might plug into your computer, like phones, cameras, or other
various storage devices you might plug into the usb port.

Available from places or places-git.

Note:This module is no longer required for auto-mounting external
devices in Enlightenment

Scale Windows

The Scale Windows module, which requires compositing to be enabled, adds
several features. The scale windows effect shrinks all open windows and
brings them all into view. This is known in Mac OS X as "Exposé". The
scale pager effect zooms out and shows all desktops as a wall, like the
compiz expo plugin. Both can be added to the desktop as a gadget or
bound to a key binding, mouse binding or screen edge binding.

Some people like to change the standard window selection key binding
ALT + Tab to use Scale Windows to select windows. To change this
setting, you navigate to Menu > Settings > Settings Panel > Input >
Keys. From here, you can set any key binding you would like.

To replace the window selection key binding functionality with Scale
Windows, scroll through the left panel until you find the ALT section
and then find and select ALT + Tab. Then, scroll through the right panel
looking for the "Scale Windows" section and choose either Select Next or
Select Next (All) depending on whether you would like to see windows
from only the current desktop or from all desktops and click Apply to
save the binding.

Available from comp-scale-git.

> Engage

Engage is CairoDock/GLX-Dock style docking bar for both application
launchers and open applications. It requires compositing to be enabled
and has full controls for transparency, size, zoom levels, and more.

Available from engage-git.

> Troubleshooting

If you find some unexpected behavior, there are a few things you can do:

1.  try to see if the same behavior exists with the default theme
2.  disable any 3rd party modules you may have installed
3.  backup ~/.e and remove it (e.g. mv ~/.e ~/.e.back)

If you are sure you found a bug please report it directly upstream.

Compositing

When the configuration is messed up and the settings windows can no
longer be approached, configuration for the compositor can be reset by
the hardcoded keybinding Ctrl + Alt + Shift + Home.

Unreadable fonts

If fonts are too small and your screen is unreadable, be sure the right
font packages are installed. ttf-dejavu and ttf-bitstream-vera are valid
candidates.

You can set scaling under Settings -> Settings Panel -> Look -> Scaling.

Enlightenment DR16
------------------

Enlightenment, Development Release 16 was first released in 2000, and
went 1.0 in 2009. Originally, the DR16 stood for the 0.16 version of the
Enlightenment project. As simply "Enlightenment" now in the Arch
repositories, it is still under development today, regularly updated by
its maintainer Kim 'kwo' Woelders. With compositing, shadows and
transparencies, E16 kept all of the speed that presided over its
foundation by original author Carsten "Rasterman" Haitzler but with up
to date refinement.

> To install E16

Install enlightenment16.

E16 can be quite different from the other WM's out there, read
/usr/share/doc/e16/e16.html after installation to learn more. The man
page is at man e16, not man enlightenment, and only gives startup
options.

> Basic Configuration

Most everything in E16 resides in ~/.e16 and is text-based, editable at
will. That includes the Menus too.

Shortcut keys can be either modified by hand, or with the e16keyedit
software provided as source on the sourceforge page of the e16 project,
or from the e16keyedit AUR package.

Background images

You have to copy the desired wallpapers into ~/.e16/backgrounds/

MMB or RMB anywhere on the desktop will give access to the settings,
select /Desktop/Backgrounds/

Any new image copied in the ~/.e16/backgrounds/ folder will get the list
of available backgrounds auto-updated. Select desired wallpaper from
drop-down menu. Inside the appropriate tabs in the global e16 settings,
you can adjust things like tiling of the background image, filling
screen and such.

Start/Restart/Stop Scripts

Create an Init, a Start and a Stop folder in your ~/.e16 folder: any .sh
script found there will either be executed at Startup (from Init
folder), at each Restart (from Start folder), or at Shutdown (from Stop
folder); provided you allowed it trough the MMB / settings / session /
<enable scripts> button and made them executable with
chmod +x yourscript.sh. Typical examples involves starting pulseaudio or
your favorite network manager applet.

Compositor

Shadows, Transparent effects et all can be found in MMB or RMB
/Settings, under Composite .

See also
--------

-   Enlightenment Homepage
-   Enlightenment Exchange
-   Enlightenment Developer Documentation
-   Bodhi Guide to Enlightenment
-   E17-Stuff
-   DR16 download resource
-   Enlightenment users mail list
-   Enlightenment developer mail list
-   irc://irc.freenode.net#e

Retrieved from
"https://wiki.archlinux.org/index.php?title=Enlightenment&oldid=305140"

Category:

-   Desktop environments

-   This page was last modified on 16 March 2014, at 16:20.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
