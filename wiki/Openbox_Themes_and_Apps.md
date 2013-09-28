Openbox Themes and Apps
=======================

Note:This article is a supplement to the main Openbox article.

This wiki article deals with customizing the appearance of Openbox in
Arch Linux. Helper programs such as panels and trays are also explained.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Themes and appearance                                              |
|     -   1.1 Openbox themes                                               |
|     -   1.2 X11 mouse cursors                                            |
|     -   1.3 GTK themes                                                   |
|     -   1.4 Desktop icons                                                |
|     -   1.5 Desktop wallpaper                                            |
|                                                                          |
| -   2 Recommended programs                                               |
|     -   2.1 Display managers                                             |
|     -   2.2 Desktop compositing                                          |
|     -   2.3 Desktop utilities                                            |
|         -   2.3.1 Panels                                                 |
|         -   2.3.2 Trays                                                  |
|         -   2.3.3 Pagers                                                 |
|                                                                          |
|     -   2.4 File managers                                                |
|     -   2.5 Application launchers                                        |
|     -   2.6 Clipboard managers                                           |
|     -   2.7 Volume managers                                              |
|     -   2.8 Battery & CPU                                                |
|     -   2.9 Keyboard layout switchers                                    |
|     -   2.10 Logout dialog                                               |
+--------------------------------------------------------------------------+

Themes and appearance
---------------------

With the exception of the Openbox Themes topic, the following section is
intended for users who have configured Openbox to run as a standalone
desktop, without the assistance of GNOME, KDE or Xfce.

> Openbox themes

Openbox themes control the appearance of window borders, including the
titlebar and titlebar buttons. They also determine the appearance of the
application menu and on-screen display (OSD).

Some themes are available for installation with the openbox-themes
package in the official repositories.

This package is by no means definitive. You can download more themes at
websites such as:

-   www.box-look.org
-   www.customize.org
-   www.minuslab.net
-   celo.wordpress.com
-   vault.openmonkey.com

Downloaded themes should be extracted to ~/.themes or
~/.local/share/themes and selected from obconf or lxappearance-obconf.
Theme selection can also be done manually by opening rc.xml and changing
the <name> key in the <theme> section.

Creating new themes is fairly easy and well-documented. For those who
prefer a GUI, obtheme is a very capable editor.

> X11 mouse cursors

See Cursor Themes.

> GTK themes

See GTK+#Themes.

> Desktop icons

Openbox does not provide a means to display icons on the desktop. To
provide this function, one can use:

-   Xfdesktop — The desktop manager for Xfce.

http://docs.xfce.org/xfce/xfdesktop/start || xfdesktop

-   PCManFM — An extremely fast and lightweight file manager used by the
    LXDE desktop.

http://pcmanfm.sourceforge.net/ || pcmanfm

-   ROX — A small and fast file manager which can optionally manage the
    desktop background and panels, part of the ROX Desktop.

http://roscidus.com/desktop/ || rox

-   IDesk — A simple tool that gives users of minimal wm's (Fluxbox,
    pekwm, Window Maker, Obenbox, etc) icons on their desktop.

http://idesk.sourceforge.net/html/index.html || idesk

-   Nautilus — The file manager of the GNOME desktop.

https://live.gnome.org/Nautilus || nautilus

-   Spacefm — A GTK multi-panel tabbed file manager.

http://ignorantguru.github.com/spacefm/ || spacefm

> Desktop wallpaper

Openbox itself does not include a way to change the wallpaper. This can
be done easily with programs like Feh or Nitrogen. Other options include
imagemagick, hsetroot, xsetbg and more advanced choices such as PCmanFM
or Xfdesktop.

You can disable the wallpaper loading in gnome-settings-daemon like
this:

    $ gconftool-2 --set /apps/gnome_settings_daemon/plugins/background/active --type bool False

In Gnome 3 use:

    $ gsettings set org.gnome.desktop.background draw-background false

One approach, using hsetroot is possible by placing the following
command in autostart:

    hsetroot -fill /path/to/image.file

A similar command for feh is:

    feh --bg-scale /path/to/image.file

Recommended programs
--------------------

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: This is          
                           completely subjective,   
                           so it likely belongs in  
                           a user namespace         
                           instead. (Discuss)       
  ------------------------ ------------------------ ------------------------

Note:The main Openbox article has information on installing Openbox, but
this additional section details specific lightweight applications you
may want to deploy after installing Openbox.

For a more complete choice of applications available on Arch, look at
the List of Applications. You can also look at the list recommended on
the Openbox wiki, although most overlap with the following suggestions.

> Display managers

See the main article: Display Manager.

-   SLiM (Simple Login Manager) — A lightweight and elegant graphical
    login solution.

http://slim.berlios.de/ || slim

-   Qingy — An ultralight and very configurable graphical login
    independent on X Windows (uses DirectFB). It supports login to
    either a text console or an X session.

http://qingy.sourceforge.net/ || qingy

> Desktop compositing

-   Cairo Composite Manager — A versatile and extensible composite
    manager which uses Cairo for rendering.

http://cairo-compmgr.tuxfamily.org/ || cairo-compmgr-git

-   Compton — A fork of Xcompmgr containing many fixes.

https://github.com/chjj/compton || compton-git

-   Xcompmgr — A lightweight composite manager capable of rendering drop
    shadows, fading and simple window transparency within Openbox and
    other window managers.

http://cgit.freedesktop.org/xorg/app/xcompmgr/ || xcompmgr xcompmgr-dana
xcompmgr_tint2-git

> Desktop utilities

A number of utilities provide panels / taskbars, system trays, or pagers
to Openbox:

Panels

For more examples see: Common Applications#Taskbars.

-   Avant Window Navigator — A lightweight dock which sits at the bottom
    of the screen.

http://wiki.awn-project.org/ || avant-window-navigator

-   Bmpanel — A lightweight, NETWM compliant panel for the X11 system.

http://nsf.110mb.com/bmpanel/ || bmpanel

-   Cairo-Dock — A highly customizable dock/laucher.

http://www.glx-dock.org/ || cairo-dock

-   Docker — A docking application which acts as a system tray.

http://icculus.org/openbox/2/docker/ || docker

-   fbpanel — A lightweight, NETWM compliant desktop panel.

http://fbpanel.sourceforge.net/ || fbpanel

-   LXPanel — A lightweight X11 desktop panel and part of the LXDE DE.

http://lxde.org/ || lxpanel

-   Pancake — A highly configurable, modular panel for X.

http://www.failedprojects.de/pancake/ || pancake

-   Tint2 — Simple panel/taskbar developed specifically for Openbox.

http://code.google.com/p/tint2/ || tint2

-   wbar — A quick launch bar developed with speed in mind.

http://freecode.com/projects/wbar/ || wbar

-   GNOME Panel — The default Gnome panel.

https://live.gnome.org/GnomePanel || gnome-panel

-   PerlPanel — A lightweight panel that supports applets.

http://savannah.nongnu.org/projects/perlpanel || perlpanel

-   PyPanel — A lightweight panel/taskbar for X11 window managers
    written in Python.

http://pypanel.sourceforge.net/ || pypanel

-   Screenlets — A widget framework that consists of small owner-drawn
    applications (weather widget, clocks, system monitors, mail
    checkers, etc.).

http://screenlets.org/index.php/Home || screenlets

-   Xfce Panel — The default Xfce panel.

http://docs.xfce.org/xfce/xfce4-panel/start || xfce4-panel

Trays

-   Stalonetray — A stand-alone system tray with minimal dependecies.

http://stalonetray.sourceforge.net/ || stalonetray

-   Trayer — A lightweight GTK2-based systray.

https://gna.org/projects/fvwm-crystal/ || trayer

Pagers

-   IPager — A configurable pager with transparency, originally
    developed for Fluxbox.

http://useperl.ru/ipager/index.en.html || ipager

-   Neap — An non-intrusive and light pager that runs in the
    notification area of your panel.

http://code.google.com/p/neap/ || neap

-   Netwmpager — A NetWM/EWMH compatible pager.

http://sourceforge.net/projects/sf-xpaint/files/netwmpager/ ||
netwmpager

-   Pager — A highly configurable pager compatible with Openbox
    Multihead.

https://github.com/BurntSushi/pager-multihead || pager-multihead-git

If you wish to set desktop layout without using a pager, try the
obsetlayout package from AUR.

> File managers

For more examples see: Common Applications#File managers.

Three popular lightweight file managers are:

-   PCManFM — An extremely fast and lightweight file manager used by the
    LXDE desktop.

http://pcmanfm.sourceforge.net/ || pcmanfm

-   ROX — A small and fast file manager which can optionally manage the
    desktop background and panels, part of the ROX Desktop.

http://roscidus.com/desktop/ || rox

-   Thunar — The file manager of the Xfce Desktop with many plugins and
    features.

http://thunar.xfce.org/ || thunar

For even lighter options, consider:

-   Gentoo — A lightweight file manager for GTK.

http://www.obsession.se/gentoo/ || gentoo

-   emelFM2 — A file manager that implements the popular two-pane
    design.

http://emelfm2.net/ || emelfm2

-   Xfe — A Microsoft Explorer-like file manager for X (X File
    Explorer).

http://sourceforge.net/projects/xfe/ || xfe

-   muCommander — A lightweight, cross-platform file manager with a
    dual-pane interface written in Java.

http://www.mucommander.com/ || mucommander

Alternatively, you may use GNOME's Nautilus as your file manager. It is
heavier and slower than the previous solutions, but Nautilus has many
helpful features such as virtual file systems, allowing folder access
via SSH, FTP, or Samba.

> Application launchers

For more examples see: Common Applications#Application Launchers.

-   gmrun — A lightweight GTK based application launcher, with ability
    to run programs inside a terminal and other handy features. To
    enable Alt+F2 functionality add the following to the <keyboard>
    section:

    ~/.config/openbox/rc.xml

    <keybind key="A-F2">
        <action name="execute"><execute>gmrun</execute></action>
    </keybind>

http://sourceforge.net/projects/gmrun/ || gmrun

-   dmenu — A fast and lightweight dynamic menu for X, which is also
    useful as an application launcher. To enable Alt+F2 functionality
    add the following to the <keyboard> section:

    ~/.config/openbox/rc.xml

    <keybind key="A-F2">
        <action name="execute"><execute>dmenu_run</execute></action>
    </keybind>

http://tools.suckless.org/dmenu/ || dmenu

-   Bashrun2 — Provides a different, barebones approach to a run dialog,
    using a specialized Bash session within a small xterm window. To
    enable Alt+F2 functionality add the following to the <keyboard>
    section:

    ~/.config/openbox/rc.xml

    <keybind key="A-F2">
        <action name="execute"><execute>bashrun2</execute></action>
    </keybind>

To make Bashrun2 act more like a traditional run dialog add the
following to the <applications> section:

    ~/.config/openbox/rc.xml

    <application name="bashrun2-run-dialog">
        <desktop>all</desktop>
        <decor>no</decor>  # switch to yes if you prefer a bordered window
        <focus>yes</focus>
        <skip_pager>yes</skip_pager>
        <layer>above</layer>
    </application>

https://code.google.com/p/bashrun2/ || bashrun2

-   Kupfer — A launcher inspired by Quicksilver, written in Python. To
    enable Alt+F2 functionality add the following to the <keyboard>
    section:

    ~/.config/openbox/rc.xml

    <keybind key="A-F2">
        <action name="execute"><execute>kupfer</execute></action>
    </keybind>

http://engla.github.com/kupfer/ || kupfer

-   Launchy — A less minimalistic approach; it is skinnable and offers
    more functionality such as a calculator, checking the weather, etc.
    It is launched with the Ctrl+Space key combination.

http://www.launchy.net/ || launchy

-   LXPanel — A lightweight X11 desktop panel and part of the LXDE DE.
    The run dialog can be executed with:

    $ lxpanelctl run

http://lxde.org/ || lxpanel

-   GNOME Panel — The default Gnome panel. The run dialog of the GNOME
    Panel can be executed with:

    $ gnome-panel-control --run-dialog

https://live.gnome.org/GnomePanel || gnome-panel

> Clipboard managers

For more examples see: Common Applications#Clipboard managers.

You may wish to install a clipboard manager for a richer copy/paste
experience. The following are the more lightweight options:

-   Clipman — A clipboard manager for Xfce. It keeps the clipboard
    contents around while it is usually lost when you close an
    application. It is able to handle text and images, and has a feature
    to execute actions on specific text selections by matching them
    against regular expressions.

http://goodies.xfce.org/projects/panel-plugins/xfce4-clipman-plugin ||
xfce4-clipman-plugin

-   Glipper — A clipboard manager for GNOME with more features and
    plugin support.

https://launchpad.net/glipper || glipper

-   Parcellite — A lightweight yet feature-rich clipboard manager.

http://parcellite.sourceforge.net/ || parcellite

-   ClipIt — A fork of Parcellite with additional features and bugfixes.

http://sourceforge.net/projects/gtkclipit/ || clipit

Make sure you add your chosen clipboard manager to
~/.config/openbox/autostart.

> Volume managers

-   GVolWheel — An audio mixer which lets you control the volume through
    a tray icon.

http://sourceforge.net/projects/gvolwheel/ || gvolwheel

-   GVTray — A master volume mixer for the system tray.

http://code.google.com/p/gtk-tray-utils/ || gvtray

-   Obmixer — A GTK mixer applet for Openbox that runs in the system
    tray. It is lightweight and works with both pulseaudio and alsa, has
    mute/umute feature which remembers your previous volume.

http://jpegserv.com/obmixer/ || obmixer

-   PNMixer — A fork of Obmixer. It has many new features such as ALSA
    channel selection, connect/disconnect detection, shortcuts, etc.

https://github.com/nicklan/pnmixer/wiki || pnmixer

-   Volti — A GTK application for controlling audio volume from system
    tray with an internal mixer and support for multimedia keys that
    uses only ALSA.

http://code.google.com/p/volti/ || volti

-   VolumeIcon — Another volume control for your system tray with
    channel selection, themes and an external mixer.

http://softwarebakery.com/maato/volumeicon.html || volumeicon

-   VolWheel — A little application which lets you control the sound
    volume easily through a tray icon you can scroll on.

http://oliwer.net/b/volwheel.html || volwheel

> Battery & CPU

For more examples see: Common Applications#System Monitoring.

-   Trayfreq — A light battery monitor and a CPU frequency scaler.

http://trayfreq.sourceforge.net || trayfreq

> Keyboard layout switchers

-   fbxkb — A NETWM compliant keyboard indicator and switcher. It shows
    a flag of current keyboard in a systray area and allows you to
    switch to another one.

http://fbxkb.sourceforge.net/ || fbxkb

-   xxkb — A lightweight keyboard layout indicator and switcher.

http://sourceforge.net/projects/xxkb/ || xxkb

-   qxkb — A keyboard switcher written in Qt.

http://code.google.com/p/qxkb/ || qxkb

-   X Neural Switcher — A text analyser, it detects the language of the
    input and corrects the keyboard layout if needed.

http://www.xneur.ru/ || xneur, gxneur (GUI)

> Logout dialog

A few simple shutdown managers are available:

-   exitx — A logout dialog for Openbox that uses Sudo.

http://www.linuxsir.com/bbs/lastpostinthread350740.html || exitx

-   exitx-polkit — A GTK logout dialog for Openbox with PolicyKit
    support.

https://github.com/z0id/exitx-polkit || exitx-polkit-git

-   exitx-systemd — A GTK logout dialog for Openbox with systemd
    support.

https://github.com/z0id/exitx-systemd || exitx-polkit-git

-   obshutdown — A great GTK/Cairo based shutdown manager for Openbox
    and other window managers.

https://github.com/panjandrum/obshutdown || obshutdown

Alternatively, you can also use Openbox's menus to create a simple
dialog. Which can also be binded to a key for easy access.

An example with exit-menu as the id and Exit as the label in a local
systemd-logind user session:

    <menu id="exit-menu" label="Exit">
    	<item label="Log Out">
    		<action name="Execute">
    			<command>openbox --exit</command>
    		</action>
    	</item>
    	<item label="Shutdown">
    		<action name="Execute">
    			<command>systemctl poweroff</command>
    		</action>
    	</item>
    	<item label="Restart">
    		<action name="Execute">
    		        <command>systemctl reboot</command>
    		</action>
    	</item>
    	<item label="Suspend">
    		<action name="Execute">
    		        <command>systemctl suspend</command>
    		</action>
    	</item>
    	<item label="Hibernate">
    		<action name="Execute">
    		        <command>systemctl hibernate</command>
    		</action>
    	</item>
    </menu>

Add this to your ~/.config/openbox/menu.xml, then later in your menu or
pipemenu of choice add:

    <menu id="exit-menu"/>

If you would like to bind this to a key, simply add this example keybind
to the <keyboard> section:

    ~/.config/openbox/rc.xml

    <keybind key="XF86PowerOff">
      <action name="ShowMenu">
          <menu>exit-menu</menu>
      </action>
    </keybind>

This will bind it to your power button, if you prefer otherwise change
XF86PowerOff to your preferred key.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Openbox_Themes_and_Apps&oldid=252799"

Category:

-   Stacking WMs
