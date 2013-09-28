JWM
===

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: excessive use of 
                           unordered (bulleted)     
                           lists. (Discuss)         
  ------------------------ ------------------------ ------------------------

  Summary
  -----------------------------------------------------------------------------------------------------------
  This article attempts to walk users through the installation and configuration of the JWM window manager.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Introduction                                                       |
| -   2 Package installation                                               |
| -   3 Starting JWM                                                       |
| -   4 Configuration                                                      |
|     -   4.1 Creating ~/.jwmrc                                            |
|     -   4.2 Overview of Selected Tags                                    |
|         -   4.2.1 <StartupCommand>                                       |
|         -   4.2.2 <Program>                                              |
|         -   4.2.3 <Menu>                                                 |
|         -   4.2.4 <RootMenu>                                             |
|         -   4.2.5 <Groups>                                               |
|             -   4.2.5.1 Window Class                                     |
|                                                                          |
|         -   4.2.6 <TrayButton>                                           |
|         -   4.2.7 <Swallow>                                              |
|         -   4.2.8 <Tray>                                                 |
|         -   4.2.9 <Key>                                                  |
|         -   4.2.10 <Include>                                             |
|         -   4.2.11 <RestartCommand>                                      |
|         -   4.2.12 <ShutdownCommand>                                     |
|                                                                          |
|     -   4.3 Verifying configuration changes                              |
|     -   4.4 Additional troubleshooting                                   |
|                                                                          |
| -   5 Useful tips & tricks                                               |
|     -   5.1 Additional applications                                      |
|     -   5.2 Xinitrc startup applications                                 |
|     -   5.3 Improve <Tasklist> contrast                                  |
|     -   5.4 Power & event management                                     |
|     -   5.5 Logout & Refresh                                             |
|         -   5.5.1 Reboot & shutdown                                      |
|                                                                          |
|     -   5.6 Custom minimal build                                         |
|         -   5.6.1 Minimal PKGBUILD example                               |
|                                                                          |
|     -   5.7 Minimal font suggestions                                     |
|     -   5.8 Manual tiling support                                        |
|                                                                          |
| -   6 Package removal                                                    |
| -   7 Additional resources                                               |
+--------------------------------------------------------------------------+

Introduction
------------

JWM (Joe's Window Manager) is a featherweight window manager for the X11
Window System written in C; it's under active development and is
maintained by Joe Wingbermuehle. JWM uses approximately 5 MB of resident
memory under normal operating conditions. As of January 2009, the size
of the version present in the official Arch Linux repositories is under
76 KB packaged (compare to dwm at under 17 KB) and under 171 KB
installed (compare to dwm at 68 KB). A minimally compiled version
consumes approximately 136 KB of disk space and occupies under 1500 KB
of resident memory.

JWM is generally regarded as the lightest and fastest stacking window
manager available for X11 and is the default window manager base for
distributions such as Puppy Linux and Damn Small Linux. Numerous options
allow for great flexibility of layout. Some of the more outstanding
features of JWM include ease of configuration (a single XML file),
native support for customizable panels and buttons and its inclusion of
a system tray dock.

Package installation
--------------------

jwm is part of the official Arch Linux [community] repository.

    # pacman -S jwm

Warning:Recent SVN snapshots (e.g. 500) have migrated to Mod key masks
(e.g. H to 4).

Starting JWM
------------

-   Run the xinit program to start the X server and the JWM client
    program:

    $ xinit /usr/bin/jwm

-   Alternatively, add the appropriate entry (e.g. /usr/bin/jwm or
    exec /usr/bin/jwm) in your .xinitrc file and run:

    $ startx

-   See the ArchWiki entry Start X at Boot for additional details.

Configuration
-------------

> Creating ~/.jwmrc

In adherence to the principles of The Arch Way, the look, feel and
function of the JWM desktop is controlled by way of a single
configuration file: ~/.jwmrc  
 A sample configuration file is installed upon program installation and
is located at /etc/system.jwmrc. Create ~/.jwmrc:

    $ touch ~/.jwmrc

or

    $ cp -i /etc/system.jwmrc ~/.jwmrc

All that is left at this point is to establish the environment by
editing the XML .jwmrc file.

-   JWM Configuration details the complete list of tags, attributes and
    values available for JWM.

Note:The rolling content of JWM Configuration is based on the latest SVN
snapshot and may not reflect the options available in the the current
release.

> Overview of Selected Tags

<StartupCommand>

-   Load and fork Parcellite as a background daemon when JWM starts:

     <StartupCommand>parcellite -d</StartupCommand>

-   Quietly connect to and fork the urxvtd daemon to the current
    $DISPLAY when JWM starts:

     <StartupCommand>urxvtd -q -o -f</StartupCommand>

-   Recursively force the removal of selected directories as a general
    housekeeping measure when JWM starts:

    <StartupCommand>rm -rf $HOME/.adobe $HOME/.cache $HOME/.local/share/Trash $HOME/.macromedia $HOME/.recently-used.xbel $HOME/.Xauthority</StartupCommand>

-   Enable DPMS (Energy Star) to turn monitor 0:0 off to its lowest
    state of power consumption state after 900 seconds of screen idle
    after JWM starts:

     <StartupCommand>xset -display :0.0 dpms 0 0 900</StartupCommand>

-   Enable devmon as a daemon after JWM starts:

     <StartupCommand>/usr/bin/devmon</StartupCommand>

Note:<StartupCommand> commands are spawn as ConsoleKit sessions so long
as JWM is launched within a ConsoleKit session.

Note:Run the xdpyinfo command (owned by xorg-utils) to reveal the name
of the current display.

<Program>

-   Open Thunar in a specified directory:

    <Program label="Thunar">thunar ~/Desktop</Program>

-   Connect to the local CUPS web interface using the preferred web
    application (xdg-open):

    <Program label="CUPS Printing">xdg-open http://localhost:631</Program>

-   Iconize and start FileZilla with Site Manager opened:

    <Program icon="filezilla.png">filezilla -s</Program>

<Menu>

-   Create containers for a list of additional programs to display as a
    submenus under <RootMenu>:

    <Menu label="Sample">
      <Program label="Xfburn">xfburn -d</Program>
      <Program label="urxvt Client">urxvtc</Program>
    </Menu>

    <Menu label="Example">
      <Program label="Opera">opera -nolirc -nomail</Program>
      <Program label="Writer">/opt/openoffice.org3/program/swriter -nologo</Program>
    </Menu>

<RootMenu>

-   Create a menu container displaying the label="Test" of height="24"
    pixels and bound to the left mouse button onroot="1" under
    <RootMenu>:

    <RootMenu labeled="true" label="Test" height="24" onroot="1">
        <Program label="Thunar">thunar ~/Desktop</Program>
        <Program label="CUPS Printing">xdg-open http://localhost:631</Program>
        <Program icon="filezilla.png">filezilla -s</Program>
      <Menu label="Sample">
        <Program label="Xfburn">xfburn -d</Program>
        <Program label="urxvt Client">urxvtc</Program>
      </Menu>
      <Menu label="Example">
        <Program label="Opera">opera -newprivatetab -noargb -nolirc -nomail</Program>
        <Program label="Writer">/usr/lib/openoffice.org3/program/swriter -nologo</Program>
      </Menu>
    </RootMenu>

-   Create a nested menu container with no label, of height="32" pixels,
    and bound to the right mouse button onroot="3" under <RootMenu>:

    <RootMenu height="32" onroot="3">
        <Program label="Thunar">thunar ~/Desktop</Program>
        <Program label="CUPS Printing">xdg-open http://localhost:631</Program>
        <Program icon="filezilla.png" label="FileZilla">filezilla -s</Program>
      <Menu label="Sample">
        <Program label="Xfburn">xfburn -d</Program>
        <Program label="urxvt Client">urxvtc</Program>
      <Menu label="Example">
        <Program label="Opera">opera -newprivatetab -noargb -nolirc -nomail</Program>
        <Program label="Writer">/usr/lib/openoffice.org3/program/swriter -nologo</Program>
      </Menu>
      </Menu>
    </RootMenu>

<Groups>

-   Preserve panel space by not displaying Squeeze and Xarchiver within
    the <Tasklist>:

    <Group>
      <Class>Squeeze</Class>
      <Class>Xarchiver</Class>
        <Option>nolist</Option>
    </Group>

-   Always start Firefox maximized on desktop:2 without a title bar:

    <Group>
      <Class>Firefox</Class>
        <Option>maximized</Option>
        <Option>desktop:2</Option>
        <Option>notitle</Option>
    </Group>

Window Class

The xprop utility displays window and font properties in an X server.

-   Set xprop to display the window class name of an application:

    xprop WM_CLASS 

-   Click on the desired application window to display the string name
    of the window class:

    WM_CLASS(STRING) = "urxvt", "URxvt"

xprop is part of the xorg-utils package in the Arch Linux [extra]
repository.

    # pacman -S xorg-utils

<TrayButton>

-   Create a panel <TrayButton> displaying the label="Pattern" which
    launches the root:1 menu:

    <TrayButton label="Pattern">root:1</TrayButton>

<Swallow>

-   Integrate, or <Swallow> into the tray the program whose
    name=wicd-gtk and allow the named program to execute the command
    wicd-gtk

    <Swallow name="wicd-gtk">
      wicd-gtk
    </Swallow>

<Tray>

-   Create a panel <Tray> of height="24" pixels offset x="0" pixels from
    the left of the screen and y="0" from the top of the screen. Display
    within the panel:

1.  A menu <TrayButton> which displays the root:1 menu.
2.  A <TaskList/> which displays running applications within the current
    desktop.
3.  A <TrayButton> with the text label="X" that minimizes open windows
    to show the root window, or desktop.
4.  A virtual desktop <Pager/> showing available workspaces.
5.  The <Swallow> integration of the Wicd network applet.
    1.  It is currently recommended to set wicd-gtk within the
        <StartupCommand> tag.

6.  For supported applications, a system tray area for programs to
    <Dock/>.
7.  A <Clock> which displays the date and time in the specified format.
    1.  Man strftime for time and date character conversion
        specifications.

    <Tray x="0" y="0" height="24">
      <TrayButton label="Pattern">root:1</TrayButton>
      <TaskList/> 
      <TrayButton label="X">showdesktop</TrayButton>
      <Pager/>
      <Swallow name="wicd-gtk">
        wicd-client
      </Swallow>
      <Dock/>
      <Clock format="%a %b %d %l:%M %p"></Clock>
    </Tray>

<Key>

-   Bind the F1 key to launch and display the root:3 menu:

    <Key key="F1">root:1</Key>

-   Bind the Super+l key combination to lock the screen (XScreenSaver)

    <Key mask="S" key="l">exec:xscreensaver-command -lock</Key>

Note: Run the xev command (owned by xorg-utils) to print the contents of
keybound X events to standard output.

<Include>

Elaborate configurations often <Include> files for ease of maintenance
and control

    <Key key="F1">root:1</Key>
    <Include>./.jwmrc-super-hyper-keys</Include> 
    <Key mask="S" key="l">exec:xscreensaver-command -lock</Key>

Contents of an example ~/.jwmrc-super-hyper-keys:

    <Key mask="PH" key="t">exec:thunderbird -addressbook</Key>
    <Key mask="PH" key="h">exec:htop -d 10 -u USER</Key>
    <Key mask="PH" key="c">exec:catfish --hidden --path=/usr</Key>

<RestartCommand>

-   Call sync to flush file system buffers before dismounting all
    mounted TrueCrypt volumes when the user logs out of the current X
    session:

    <RestartCommand>sync; truecrypt -d</RestartCommand>

-   The <RestartCommand> complements, or can take the place of
    $HOME/.bash_logout for users working in an X environment.

<ShutdownCommand>

-   Recursively force the removal of the contents of the Trash folder
    when JWM shuts down

     <ShutdownCommand>rm -rf ~/.local/share/Trash/*</ShutdownCommand>

Note:<ShutdownCommand> does not appear to behave as expected when using
dbus-send Shutdown or Stop commands.

> Verifying configuration changes

    $ jwm -p

Runs the native configuration file checking utility of JWM and returns
syntax errors (including associated line numbers) present in the
configuration file, if any. If the syntax is correct and the
configuration file is deemed properly marked up, there is no error code
returned. Changes in the configuration file are available immediately
after restarting, or refreshing JWM via the <Restart/> command. There is
no need to restart the X server for changes to apply. The <Restart/>
command is made available to the user as a command on the initial root
menu. Users are recommended to use this tool in between configuration
changes in order to ensure valid markup and a stable environment.

> Additional troubleshooting

If X is not already running on tty1, Ctrl+Alt+F1 will allow you to
review standard output errors and messages. Man the script command for
details on how to create a typescript of what is printed to the
terminal.

Useful tips & tricks
--------------------

> Additional applications

-   pal can be run within <Clock> to provide calendaring support and
    todo and event lists features.

    <Clock format="%a %b %d %l:%M %p">xterm -hold -e pal</Clock>

-   Orage can be run within <Clock> to provide calendaring support and
    todo and event lists features.
-   slock can be bound to <Program> and/or <Key> to provide a
    featherweight X screen lock solution.
-   Parcellite can be swallowed within a tray(s) to serve as a
    lightweight X11 clipboard manager.
-   Conky can be run within the <StartupCommand> to provide the display
    of various data streams (e.g. battery life and AC adapter status for
    notebooks).
-   PCMan File Manager can be used to manage the desktop. The advantage
    of using PCMan File Manager is that it also doubles as a powerful
    GUI file manager.
-   Xfce Desktop Manager (or xfdesktop) can be used to manage the
    desktop. To circumvent the issue of xfdesktop redrawing over the
    root desktop window of Conky:

1.  Review the Conky FAQ for workarounds in ~/.conkyrc
2.  <Group> Conky and specify the following <Option> tags in ~/.jwmrc

    <Group>
    <Class>Conky</Class>
    <Option>nolist</Option>
    <Option>noborder</Option>
    <Option>notitle</Option>
    <Option>sticky</Option>
    </Group>

-   volumeicon, runned as a <StartupCommand>, provides a volume control
    in the tray, gives quick access to alsamixer by default, and lets
    the user to choose another mixer if wanted.

> Xinitrc startup applications

Startup applications can be executed outside of the <StartupCommand> by
including the appropriate options in ~./xinitrc

    #!/bin/bash

    /usr/bin/parcellite -d &
    /usr/bin/Thunar --daemon &
    /usr/bin/urxvtd -q -f -o &
    /usr/bin/xcalib -d :0 /usr/share/color/icc/P221W-Native.icc &
    /usr/bin/nvidia-settings -a GPUOverclockingState=1 -a GPU2DClockFreqs=640,655 -a GPU3DClockFreqs=640,655 &
    /usr/bin/setxkbmap -option terminate:ctrl_alt_bksp &
    export OPERAPLUGINWRAPPER_PRIORITY=0
    export OPERA_KEEP_BLOCKED_PLUGIN=0
    exec ck-launch-session /usr/bin/jwm

> Improve <Tasklist> contrast

Change the default <Tasklist> settings to match the improved contrast
style of the default <MenuStyle> and active <WindowStyle>

    <TaskListStyle>
      <ActiveForeground>black</ActiveForeground>
      <ActiveBackground>gray90:gray70</ActiveBackground>
    </TaskListStyle>

    <TaskListStyle>
      <ActiveForeground>white</ActiveForeground>
      <ActiveBackground>#70849d:#2e3a67</ActiveBackground>
    </TaskListStyle>

> Power & event management

Power and event management commands can be run within <Key> and/or
<Program> tags.  

> Logout & Refresh

<Exit/> (Logout) is the menu command to cleanly log out of the current X
server.  
 <Restart/> (Refresh) is the menu command tag which reinitializes the
configuration file and updates menus and keybindings accordingly.  
 <Restart/> and <Exit/> can be bound to the Ctrl+Alt modified keys
following the example syntax below:

    <Key mask="CA" key="r">exec:jwm -restart</Key>
    <Key mask="CA" key="e">exec:jwm -exit</Key>

Reboot & shutdown

A system with sudo installed and properly configured can be rebooted
with the Restart and Poweroff menu options.

    <Program label="Restart">sudo reboot</Program>
    <Program label="Poweroff">sudo poweroff</Program>

See the ArchWiki entry regarding allowing users to shutdown for
additional information.

Note:For users wishing to power down a system, 'poweroff' or 'shutdown
-P now' may be preferable to 'shutdown -h now' as it leaves no doubt as
to the intention of the user initiated command.

System power and event management can also be handled by HAL via
dbus-send message signals without the need to modify the sudoers file.

    <Program label="Restart">dbus-send --system --print-reply --dest=org.freedesktop.Hal /org/freedesktop/Hal/devices/computer org.freedesktop.Hal.Device.SystemPowerManagement.Reboot</Program>
    <Program label="Shutdown">dbus-send --system --print-reply --dest=org.freedesktop.Hal /org/freedesktop/Hal/devices/computer org.freedesktop.Hal.Device.SystemPowerManagement.Shutdown</Program>

    <Key mask="H" key="F4">exec:dbus-send --system --print-reply --dest=org.freedesktop.Hal /org/freedesktop/Hal/devices/computer org.freedesktop.Hal.Device.SystemPowerManagement.Suspend int32:0</Key
    <Key mask="H" key="F12>exec:dbus-send --system --print-reply --dest=org.freedesktop.Hal /org/freedesktop/Hal/devices/computer org.freedesktop.Hal.Device.SystemPowerManagement.Hibernate</Key>

System power management can also be handled by ConsoleKit and UPower via
dbus-send message signals without the need to modify the sudoers file.
HAL is not required in this case.

    <Program label="Restart">dbus-send --system --print-reply --dest=org.freedesktop.ConsoleKit /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Restart</Program>
    <Program label="Poweroff">dbus-send --system --print-reply --dest=org.freedesktop.ConsoleKit /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Stop</Program>

    <Key mask="H" key="F4">exec:dbus-send --print-reply --system --dest=org.freedesktop.UPower /org/freedesktop/UPower org.freedesktop.UPower.Suspend</Key>
    <Key mask="H" key="F12>exec:dbus-send --print-reply --system --dest=org.freedesktop.UPower /org/freedesktop/UPower org.freedesktop.UPower.Hibernate</Key>

> Custom minimal build

Gains in UI response can be gleaned by not using menu icons and by
disabling the use of Xft fonts. Further gains can be accomplished by
removing support for external libraries with a custom build. The result
is also a reduction in resource requirements. A minimal build compiled
with Xft support and using Xft fonts is allocated approximately 3 MB of
resident and 1.5 MB of shared memory. The same build compiled without
Xft support is allocated under 1.5 MB and approximately 1.2 MB,
respectively. See the Arch Build System page for further details.

Minimal PKGBUILD example

    PKGBUILD

    pkgname=jwm
    pkgver=2.0.1
    pkgrel=100
    pkgdesc="A lightweight window manager for the X11 Window System"
    arch=('i686' 'x86_64')
    url="http://joewing.net/programs/jwm/"
    license=('GPL2')
    depends=('libx11')
    backup=('etc/system.jwmrc')
    source=(http://joewing.net/programs/jwm/releases/jwm-$pkgver.tar.bz2)
    md5sums=('48f323cd78ea891172b2a61790e8c0ec')

    build() {
      cd ${srcdir/${pkgname}-${pkgver}

      ./configure --disable-confirm --disable-icons --disable-png  \ 
      --disable-xpm --disable-jpeg --disable-fribidi --disable-xinerama  \
      --disable-shape --disable-xft --disable-xrender --disable-debug  \ 
      --prefix=/usr --sysconfdir=/etc

      make
      make BINDIR=$pkgdir/usr/bin \
           MANDIR=$pkgdir/usr/share/man \
           SYSCONF=$pkgdir/etc install
    }

> Minimal font suggestions

    <WindowStyle>
    <Font>-*-fixed-*-r-*-*-10-*-*-*-*-*-*-*</Font>

    <TaskListStyle>
    <Font>-*-fixed-*-r-*-*-13-*-*-*-*-*-*-*</Font>

    <TrayStyle>
    <Font>-*-fixed-*-r-*-*-13-*-*-*-*-*-*-*</Font>

-   Man xfontsel and review the X Logical Font Description article for
    additional details and pattern descriptions.

> Manual tiling support

Tiling support can be added to JWM through the use of the Poor Man's
Tiling Window Manager python script. Assuming manage.py is located in a
command directory as part of the local PATH, various tiling actions can
be keybound according to the example below:

    <Key mask="H" key="Up">exec:manage.py swap</Key>
    <Key mask="H" key="Down">exec:manage.py cycle</Key>
    <Key mask="H" key="Left">exec:manage.py left</Key>
    <Key mask="H" key="Right">exec:manage.py right</Key>

Note:Run the env command to list the modified environments of the
current user.

Package removal
---------------

To remove the JWM package while retaining its configuration files and
dependencies:

    # pacman -R jwm

To remove the JWM package and its configuration files while retaining
its dependencies:

    # pacman -Rn jwm

To remove the JWM package and dependencies not required by any other
packages while retaining its configuration files:

    # pacman -Rs jwm

To remove the JWM package, its configuration files and dependencies not
required by any other packages:

    # pacman -Rns jwm

Note:pacman will not remove configuration files outside of the defaults
that were created during package installation. This includes ~/.jwmrc

Additional resources
--------------------

-   Joe's Window Manager - Official Site

Examples of what can be accomplished with a bit of creativity and
substitution can be found at:

-   PuppyLinux : JoesWindowManager
-   Puppy Linux JWM Themes Exchange

Retrieved from
"https://wiki.archlinux.org/index.php?title=JWM&oldid=253815"

Category:

-   Stacking WMs
