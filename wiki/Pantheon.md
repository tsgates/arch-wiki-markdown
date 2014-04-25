Pantheon
========

Summary help replacing me

This article covers basic installation procedures and configuration
methods for Pantheon, the default desktop environment of elementary OS.

> Related

GNOME: A DE which is also based on GTK3.

Pantheon is the default desktop environment originally created for the
elementary OS distribution. It is written from scratch using Vala and
the GTK3 toolkit. With regards to usability and appearance, the desktop
has some similarities with GNOME Shell and Mac OS X.

Contents
--------

-   1 Installation
    -   1.1 Additional Info
        -   1.1.1 Unofficial repository
        -   1.1.2 Github repository
        -   1.1.3 Packages based on older evolution-data-server
-   2 Launching Pantheon
    -   2.1 Via a Display Manager
    -   2.2 Via .xinitrc
    -   2.3 Autostart applications
-   3 Configuration
    -   3.1 Pantheon Files
        -   3.1.1 Enable context menu entries
-   4 Known Issues
    -   4.1 No transparency in pantheon-terminal
    -   4.2 White icons in pantheon-files
    -   4.3 Wingpanel is transparent
    -   4.4 Corrupted graphics in canonical indicators
    -   4.5 Can't interact with the LightDM Pantheon greeter
-   5 Troubleshooting
    -   5.1 Gala crashes on start

Installation
------------

Pantheon is split into several packages which are available in the AUR.
To get a minimal desktop interface, you may start by installing
pantheon-session-bzr. This will pull the following core components:

-   cerbere: Watchdog service to keep core Pantheon apps running
-   gala-bzr: Window Manager
-   wingpanel: Top panel

Note:You will need to install at least one indicator, otherwise
wingpanel will not launch.

-   slingshot-launcher: Application launcher
-   plank: Dock

Additionally, you may install the following packages:

-   audience-bzr: Video player
-   contractor-bzr: Service for sharing data between apps
-   dexter-contacts-bzr: Contacts manager (does not build)
-   eidete-bzr: Simple screencaster
-   elementary-icon-theme: elementary icons
-   elementary-scan-bzr: Simple scan utility
-   gtk-theme-elementary: elementary GTK theme
-   feedler-bzr: RSS feeds reader (does not build)
-   footnote-bzr: Note taking app
-   geary: Email client
-   indicator-pantheon-session-bzr: Session indicator
-   lightdm-pantheon-greeter-bzr: LightDM greeter
-   maya-calendar-bzr: Calendar
-   midori-granite: Web browser
-   noise: Audio player
-   pantheon-calculator-bzr: Calculator
-   pantheon-files: File explorer
-   pantheon-notify-bzr: Notification daemon
-   pantheon-print-bzr: Print settings
-   pantheon-terminal: Terminal emulator
-   plank-theme-pantheon-bzr: Pantheon theme for plank
-   scratch-text-editor: Text editor
-   snap-photobooth-bzr: Webcam app
-   switchboard: Settings manager

Note:You will also need to install plugs, look for "switchboard-plug-*"
in the AUR.

-   webcontracts-bzr: Web services contracts for use with contractor-bzr

> Additional Info

Unofficial repository

I have set up an unofficial repository for pantheon packages:
http://pkgbuild.com/~alucryd/pantheon/. Add the following lines at the
top of your sources in /etc/pacman.conf:

    [pantheon]
    SigLevel = Optional
    Server = http://pkgbuild.com/~alucryd/$repo/$arch

Github repository

All Pantheon related PKGBUILDs can be found on my GitHub repository:
https://github.com/alucryd/aur-alucryd/tree/master/pantheon

Packages based on older evolution-data-server

dexter-contacts-bzr and feedler-bzr do not build because they are based
on evolution-data-server 3.2. Arch Linux provides version 3.10 which
uses a different Vala API.

Launching Pantheon
------------------

> Via a Display Manager

pantheon-session-bzr provides a session entry for display managers such
as gdm or lightdm.

Note:Either use the bzr version of cerbere or add 'gala' to the
monitored processes for this to work.

> Via .xinitrc

You can also use ~/.xinitrc with slim to launch the Pantheon shell. The
following code will successfully launch a Pantheon session:

    #!/bin/sh
     
    if [ -d /etc/X11/xinit/xinitrc.d ]; then
      for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
      done
      unset f
    fi

    gsettings-data-convert &
    xdg-user-dirs-gtk-update &
    /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
    /usr/lib/gnome-settings-daemon/gnome-settings-daemon &
    /usr/lib/gnome-user-share/gnome-user-share &
    eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg)
    export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK
    exec cerbere

Note:Either use the bzr version of cerbere or add 'gala' to the
monitored processes for this to work.

> Autostart applications

Pantheon, when launched via ~/.xinitrc, does not support XDG autostart.
However, there are 3 other ways to achieve this for applications which
do not provide a systemd unit:

-   You may add any program to your ~/.xinitrc, preferably right before
    the exec cerbere line. This is the better choice for one-shot
    programs.
-   Or you may edit the org.pantheon.cerbere.monitored-processes key
    using dconf-editor and add the programs of your choice. This method
    is best for applications which keep running in the background.
-   Or you may use a program like dapper, dex-git, or fb-autostart to
    add support for XDG autostart in your ~/.xinitrc.

Note:Keep in mind that applications started via cerbere cannot be
terminated, they will keep respawning.

Configuration
-------------

Configuring Pantheon is done via switchboard-bzr and its plugs, most are
available in the AUR and the custom repo. All pantheon settings can also
be altered via dconf, they are located in the org.pantheon key. Use
dconf-editor for easy editing.

Part of the configuration is handled by gnome-control-center via a
dedicated plug, which unfortunately only supports GNOME up to 3.6. Use
gnome-control-center itself and gnome-tweak-tool instead.

> Pantheon Files

Enable context menu entries

If you want to enable context menu entries such as for file-roller to
extract/compress archives, then you have to additionally install
contractor-bzr.

Known Issues
------------

> No transparency in pantheon-terminal

Transparency in pantheon-terminal is not functional. It appears to work
briefly at start then background becomes opaque. See bug report:
https://bugs.launchpad.net/pantheon-terminal/+bug/1260383

> White icons in pantheon-files

Currently there seems to be a bug which displays the view icons in the
top location in a white colour instead of black. This can be fixed by
adding the following line to gtk-widgets.css or gtk-widgets.css of your
gtk-theme-elementary theme:

    GtkToolItem { color: @text_color; }

> Wingpanel is transparent

Depending on your GTK theme, wingpanel can be completely transparent.
This is the case for the elementary theme for example. The Numix theme
seems to produce a solid panel, however it will become transparent upon
certain events, reloading wingpanel makes it solid again.

> Corrupted graphics in canonical indicators

Indicators behave incorrectly with every theme I've tried. They are very
ancient, all of them date back to 2012 because the newer indicators
depend on Ubuntu patches, and they should be killed with fire anyway.
Wingpanel is doing just that and I hope the next major release will ship
their new plugin system.

> Can't interact with the LightDM Pantheon greeter

The Pantheon greeter needs to be run as root, edit
/etc/lightdm/lightdm.conf accordingly. See bug report:
https://bugs.launchpad.net/pantheon-greeter/+bug/1282148

Troubleshooting
---------------

> Gala crashes on start

It appears that unconfigured gala tries to use default gnome wallpaper
as a background. However, the corresponding file is absent unless you
have gnome-themes-standard installed. Thus, install
gnome-themes-standard to workaround the crash. It is safe to remove this
package after you configure pantheon in a way you want.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Pantheon&oldid=306101"

Category:

-   Desktop environments

-   This page was last modified on 20 March 2014, at 17:42.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
