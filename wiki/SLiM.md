SLiM
====

Summary

Provides an overview of the Simple Login Manager.

Related

Display Manager

SLiM is an acronym for Simple Login Manager. SLiM is simple, lightweight
and easily configurable. SLiM is used by some because it does not
require the dependencies of GNOME or KDE and can help make a lighter
system for users that like to use lightweight desktops like Xfce,
Openbox, and Fluxbox.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Enabling SLiM                                                |
|     -   2.2 Single environments                                          |
|     -   2.3 Autologin                                                    |
|     -   2.4 Zsh                                                          |
|     -   2.5 Multiple environments                                        |
|     -   2.6 Themes                                                       |
|         -   2.6.1 Dual screen setup                                      |
|                                                                          |
| -   3 Other options                                                      |
|     -   3.1 Changing the cursor                                          |
|     -   3.2 Match SLiM and Desktop Wallpaper                             |
|     -   3.3 Shutdown, reboot, suspend, exit, launch terminal from SLiM   |
|     -   3.4 SLiM init error with rc.d daemon                             |
|     -   3.5 Power-off error with Splashy                                 |
|     -   3.6 Power-off tray icon fails                                    |
|     -   3.7 Login information with SLiM                                  |
|     -   3.8 Custom SLiM Login Commands                                   |
|     -   3.9 SLiM and Gnome Keyring                                       |
|     -   3.10 Setting DPI with SLiM                                       |
|     -   3.11 Use a random theme                                          |
|     -   3.12 Move the whole session to another VT                        |
|     -   3.13 Automatically mount your encrypted /home on login           |
|                                                                          |
| -   4 All Slim Options                                                   |
| -   5 Uninstallation                                                     |
| -   6 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Install slim from the official repositories.

Configuration
-------------

> Enabling SLiM

Note:slim no longer has ConsoleKit support, but relies on
systemd-logind, and the system being booted with systemd.

Enable the slim daemon. With systemd, it is no longer possible to start
slim using inittab.

> Single environments

To configure SLiM to load a particular environment, edit your ~/.xinitrc
to load your desktop environment:

    #!/bin/sh

    #
    # ~/.xinitrc
    #
    # Executed by startx (run your window manager from here)
    #

    exec <session-command>

Replace <session-command> with the appropriate session command. Some
examples of different desktop start commands:

    exec awesome
    exec dwm
    exec startfluxbox
    exec fvwm2
    exec gnome-session
    exec openbox-session
    exec startkde
    exec startlxde
    exec startxfce4
    exec enlightenment_start

For detailed instructions on how to start the various environments,
refer to the appropriate wiki pages.

SLiM reads the local ~/.xinitrc configuration and then launches the
desktop according to what is in that file. If you do not have a
~/.xinitrc file, you can use the skeleton file by:

    $ cp /etc/skel/.xinitrc ~

Remember to make ~/.xinitrc executable:

    chmod +x ~/.xinitrc

> Autologin

To make SLiM automatically login as a specified user (without having to
type a password) the following lines in /etc/slim.conf should be
changed.

    # default_user        simone

Uncomment this line, and change "simone" to the user to be logged into
automatically.

    # auto_login          no

Uncomment this line and change the 'no' to 'yes'. This enables the auto
login feature.

> Zsh

Note:If you don't know what is zsh and you did not install it - ignore
this paragraph.

The default login command will not initialize your environment correctly
[source]. Change the login_cmd line in /etc/slim.conf to:

    #login_cmd           exec /bin/sh - ~/.xinitrc %session
    login_cmd           exec /bin/zsh -l ~/.xinitrc %session

> Multiple environments

To be able to choose from multiple desktop environments, SLiM can be
setup to log you into whichever you choose.

Put a case statement similar to this one in your ~/.xinitrc file and
edit the sessions variable in /etc/slim.conf to match the names that
trigger the case statement. You can cycle through sessions at login time
by pressing F1. Note that this feature is experimental.

    # Adapted from: http://svn.berlios.de/svnroot/repos/slim/trunk/xinitrc.sample

    case $1 in
    kde)
    	exec startkde
    	;;
    xfce4)
    	exec startxfce4
    	;;
    wmaker)
    	exec wmaker
    	;;
    blackbox)
    	exec blackbox
    	;;
    icewm|*)
    	icewmbg &
    	icewmtray &
    	exec icewm
    	;;
    esac

Note:In the latest version (1.3.5), slim does not preset any default
session, so using a DEFAULT_SESSION variable will not work the way it
used to. Instead put your default session as the last case and |*) to
the statement (see above)

> Themes

Install the slim-themes package:

    # pacman -S slim-themes archlinux-themes-slim

The archlinux-themes-slim packages contains several different themes
(slimthemes.png). Look in the directory of /usr/share/slim/themes to see
the themes available. Enter the theme name on the current_theme line in
/etc/slim.conf:

    #current_theme       default
    current_theme       archlinux-simplyblack

To preview a theme run while an instance of the Xorg server is running
by:

    $ slim -p /usr/share/slim/themes/<theme name>

To close, type "exit" in the Login line and press Enter.

Additional theme packages can be found in the AUR.

Dual screen setup

You can customize the slim theme in
/usr/share/slim/themes/<your-theme>/slim.theme to turn these percents
values. The box itself is 450 pixels by 250 pixels:

    input_panel_x           50%
    input_panel_y           50%

into pixels values:

    # These settings set the "archlinux-simplyblack" panel in the center of a 1440x900 screen
    input_panel_x           495
    input_panel_y           325

    # These settings set the "archlinux-retro" panel in the center of a 1680x1050 screen
    input_panel_x           615
    input_panel_y           400

If your theme has a background picture you should use the
background_style setting ('stretch', 'tile', 'center' or 'color') to get
it correctly displayed. Have a look at the very simple and clear
official documentation about slim themes for further details.

Other options
-------------

A few things you might like to try.

> Changing the cursor

If you want to change the default X cursor to a newer design, the
slim-cursor package is available.

After installing, edit /etc/slim.conf and uncomment the line:

    cursor   left_ptr

This will give you a normal arrow instead. This setting is forwarded to
xsetroot -cursor_name. You can look up the possible cursor names here or
in /usr/share/icons/<your-cursor-theme>/cursors/.

To change the cursor theme being used at the login screen, make a file
named /usr/share/icons/default/index.theme with this content:

    [Icon Theme]
    Inherits=<your-cursor-theme>

Replace <your-cursor-theme> with the name of the cursor theme you want
to use (e.g. whiteglass).

> Match SLiM and Desktop Wallpaper

To share a wallpaper between SLiM and your desktop, rename the used
theme background, then create a link from your desktop wallpaper file to
the default SLiM theme:

    # mv /usr/share/slim/themes/default/background.jpg{,.bck}
    # ln -s /path/to/mywallpaper.jpg /usr/share/slim/themes/default/background.jpg

> Shutdown, reboot, suspend, exit, launch terminal from SLiM

You may shutdown, reboot, suspend, exit or even launch a terminal from
the SLiM login screen. To do so, use the values in the username field,
and the root password in the password field:

-   To launch a terminal, enter console as the username (defaults to
    xterm which must be installed separately... edit /etc/slim.conf to
    change terminal preference)
-   For shutdown, enter halt as the username
-   For reboot, enter reboot as the username
-   To exit to bash, enter exit as the username
-   For suspend, enter suspend as the username (suspend is disabled by
    default, edit /etc/slim.conf as root to uncomment the suspend_cmd
    line and, if necessary modify the suspend command itself (e.g.
    change /usr/sbin/suspend to sudo /usr/sbin/pm-suspend))

> SLiM init error with rc.d daemon

If you initialize SLiM with /etc/rc.conf inside the DAEMONS array and it
fails to initialize it's most likely a lock file issue. SLiM creates a
lock file in /var/lock on each initialization, however, in most cases
the lock folder in /var does not exist preventing SLiM from
initializing. Check to make sure /var/lock exists, if it does not you
can create it by typing the following:

    # mkdir /var/lock/

> Power-off error with Splashy

If you use Splashy and SLiM, sometimes you can't power-off or reboot
from menu in GNOME, Xfce, LXDE or others. Check your /etc/slim.conf and
/etc/splash.conf; set the DEFAULT_TTY=7 same as xserver_arguments vt07.

> Power-off tray icon fails

If your power off tray icon fails, it could be due to not having root
privileges. To start a tray icon with root privileges, be sure to have
SLiM start the program. Edit /etc/slim.conf as follows:

    sessionstart_cmd 	/path/to/tray/icon/program &

> Login information with SLiM

By default, SLiM fails to log logins to utmp and wtmp which causes who,
last, etc. to misreport login information. To fix this edit your
slim.conf as follows:

     sessionstart_cmd    /usr/bin/sessreg -a -l $DISPLAY %user
     sessionstop_cmd     /usr/bin/sessreg -d -l $DISPLAY %user

> Custom SLiM Login Commands

You can also use the sessionstart_cmd/sessionstop_cmd in /etc/slim.conf
to log specific infomation, such as the session, user, or theme used by
slim:

     sessionstop_cmd /usr/bin/logger -i -t ASKAPACHE "(sessionstop_cmd: u:%user s:%session t:%theme)"
     sessionstart_cmd /usr/bin/logger -i -t ASKAPACHE "(sessionstart_cmd: u:%user s:%session t:%theme)"

Or if you want to play a song when slim loads (and you have the beep
program installed)

     sessionstart_cmd /usr/bin/beep -f 659 -l 460 -n -f 784 -l 340 -n -f 659 -l 230 -n -f 659 -l 110

> SLiM and Gnome Keyring

If you are using SLiM to launch a Gnome session and have trouble
accessing your keyring, for example not being automatically
authenticated on login, add the following lines to /etc/pam.d/slim (as
discussed here).

    auth       optional    pam_gnome_keyring.so
    session    optional    pam_gnome_keyring.so    auto_start

You also have to add to /etc/pam.d/passwd:

    password        optional        pam_gnome_keyring.so

If you use a screensaver you also have to add

    auth    optional        pam_gnome_keyring.so

to /etc/pam.d/gnome-screensaver for example (replace gnome-screensaver
with slimlock, slock, whatever you use). If you don't do that, your
keyring is locked when screen is locked by your screensaver and not
unlocked again after logging back in.

However, this fix alone no longer works since Gnome 2.30. Further
changes are necessary as described here. Modifying the login_cmd line in
/etc/slim.conf:

    login_cmd exec dbus-launch /bin/bash -login ~/.xinitrc %session >~/.xsession-errors 2>&1

As of GNOME 3.4, you need to edit /etc/pam.d/{slim,passwd} as mentioned
above, so that /etc/pam.d/slim looks like:

    #%PAM-1.0
    auth            requisite       pam_nologin.so
    auth            required        pam_env.so
    auth            required        pam_unix.so
    auth            optional        pam_gnome_keyring.so
    account         required        pam_unix.so
    session         required        pam_limits.so
    session         required        pam_unix.so
    session         optional        pam_gnome_keyring.so auto_start
    password        required        pam_unix.so

and /etc/pam.d/passwd

    #%PAM-1.0
    password	required	pam_unix.so sha512 shadow nullok
    password	optional	pam_gnome_keyring.so

As of 2012-10-13, /etc/pam.d/gnome-screensaver already contains the
pam_gnome_keyring.so instruction.

The correct positioning of the pam_gnome_keyring.so instructions were
taken from here.

After editing the above files, you need to edit /etc/inittab.

The solutions mentioned here and also further information are found
here.

If you have problems keeping the keyring unlocked for longer sessions,
there is another thing that Gnome does: Look at
/etc/xdg/autostart/{gnome-keyring-gpg.desktop, gnome-keyring-pkcs11.desktop, gnome-keyring-secrets.desktop, gnome-keyring-ssh.desktop}.

Append the following lines to .xinitrc just before you start your wm
(example here is awesome wm):

    /usr/bin/gnome-keyring-daemon --start --components=gpg
    /usr/bin/gnome-keyring-daemon --start --components=pkcs11
    /usr/bin/gnome-keyring-daemon --start --components=secrets
    /usr/bin/gnome-keyring-daemon --start --components=ssh
    /usr/bin/awesome

After login check if there is only one gnome-keyring-daemon instance
running (ps -A ). If those lines are executed too early then you have 4
instances running which is not good.

You also should notice that seahorse for example does not show any
pkcs11 errors anymore and that your keyring is unlocked all the time and
does not lock itself anymore. Finally gnome-keyring is fully functional
like in Gnome. See also here.

> Setting DPI with SLiM

The Xorg server generally picks up the DPI but if it doesn't you can
specify it to SLiM. If you set the DPI with the argument -dpi 96 in
/etc/X11/xinit/xserverrc it will not work with SLiM. To fix this change
your slim.conf from:

     xserver_arguments   -nolisten tcp vt07 

to

     xserver_arguments   -nolisten tcp vt07 -dpi 96

> Use a random theme

Use the current_theme variable as a comma separated list to specify a
set from which to choose. Selection is random.

> Move the whole session to another VT

Lets say you have commented out tty terminals 3-6 as you may not use
them. (You may use screen and therefore only need one terminal) So, to
move the X-Server you need to change one number in the /etc/slim.conf
file. Just a few lines down you should see:

    xserver_arguments -nolisten tcp vt07

Simply change the vt07 to lets say vt03 as there is no agetty started
there.

> Automatically mount your encrypted /home on login

You can use pam_mount.

All Slim Options
----------------

Here is a list of all the slim configuration options and their default
values.

Note:welcome_msg allows 2 variables %host and %domain  
sessionstart_cmd allows %user (execd right before login_cmd) and it is
also allowed in sessionstop_cmd  
login_cmd allows %session and %theme

  Option Name               Default Value
  ------------------------- ------------------------------------------------------------------------
  default_path              /bin:/usr/bin:/usr/local/bin
  default_xserver           /usr/bin/X
  xserver_arguments         vt07 -auth /var/run/slim.auth
  numlock                   
  daemon                    yes
  xauth_path                /usr/bin/xauth
  login_cmd                 exec /bin/bash -login ~/.xinitrc %session
  halt_cmd                  /sbin/shutdown -h now
  reboot_cmd                /sbin/shutdown -r now
  suspend_cmd               
  sessionstart_cmd          
  sessionstop_cmd           
  console_cmd               /usr/bin/xterm -C -fg white -bg black +sb -g %dx%d+%d+%d -fn %dx%d -T 
  screenshot_cmd            import -window root /slim.png
  welcome_msg               Welcome to %host
  session_msg               Session:
  default_user              
  focus_password            no
  auto_login                no
  current_theme             default
  lockfile                  /var/run/slim.lock
  logfile                   /var/log/slim.log
  authfile                  /var/run/slim.auth
  shutdown_msg              The system is halting...
  reboot_msg                The system is rebooting...
  sessions                  wmaker,blackbox,icewm
  sessiondir                
  hidecursor                false
  input_panel_x             50%
  input_panel_y             40%
  input_name_x              200
  input_name_y              154
  input_pass_x              -1
  input_pass_y              -1
  input_font                Verdana:size=11
  input_color               #000000
  input_cursor_height       20
  input_maxlength_name      20
  input_maxlength_passwd    20
  input_shadow_xoffset      0
  input_shadow_yoffset      0
  input_shadow_color        #FFFFFF
  welcome_font              Verdana:size=14
  welcome_color             #FFFFFF
  welcome_x                 -1
  welcome_y                 -1
  welcome_shadow_xoffset    0
  welcome_shadow_yoffset    0
  welcome_shadow_color      #FFFFFF
  intro_msg                 
  intro_font                Verdana:size=14
  intro_color               #FFFFFF
  intro_x                   -1
  intro_y                   -1
  background_style          stretch
  background_color          #CCCCCC
  username_font             Verdana:size=12
  username_color            #FFFFFF
  username_x                -1
  username_y                -1
  username_msg              Please enter your username
  username_shadow_xoffset   0
  username_shadow_yoffset   0
  username_shadow_color     #FFFFFF
  password_x                -1
  password_y                -1
  password_msg              Please enter your password
  msg_color                 #FFFFFF
  msg_font                  Verdana:size=16:bold
  msg_x                     40
  msg_y                     40
  msg_shadow_xoffset        0
  msg_shadow_yoffset        0
  msg_shadow_color          #FFFFFF
  session_color             #FFFFFF
  session_font              Verdana:size=16:bold
  session_x                 50%
  session_y                 90%
  session_shadow_xoffset    0
  session_shadow_yoffset    0
  session_shadow_color      #FFFFFF

Uninstallation
--------------

To completely remove SLiM:

     # pacman -Rns slim
     # rm /etc/systemd/system/display-manager.service

See also
--------

-   SLiM homepage
-   SLiM documentation

Retrieved from
"https://wiki.archlinux.org/index.php?title=SLiM&oldid=254969"

Category:

-   Display managers
