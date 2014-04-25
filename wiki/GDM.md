GDM
===

Related articles

-   GNOME
-   GNOME Flashback
-   Display manager
-   LightDM
-   LXDM

From GDM - GNOME Display Manager:

The GNOME Display Manager (GDM) is a program that manages graphical
display servers and handles graphical user logins.

Display managers provide X Window System users with a graphical login
prompt.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Log-in screen background image
    -   2.2 Log-in screen logo
    -   2.3 Larger font for log-in screen
    -   2.4 Turning off the sound
    -   2.5 Make the power button interactive
    -   2.6 Prevent suspend when closing the lid
    -   2.7 GDM keyboard layout
        -   2.7.1 GDM 2.x layout
    -   2.8 Change the language
    -   2.9 Automatic login
    -   2.10 Passwordless login
    -   2.11 Passwordless shutdown for multiple sessions
    -   2.12 Enable root login in GDM
    -   2.13 Configuration for older versions of GDM 3
    -   2.14 gdm3setup
    -   2.15 GDM legacy
-   3 Troubleshooting
    -   3.1 GDM fails to unlock
    -   3.2 GDM fails on logout
    -   3.3 gconf-sanity-check-2 exited with status 256
    -   3.4 GDM will not load after attempting to set up automatic
        log-in

Installation
------------

GDM can be installed with the gdm package, available in the Official
repositories and it is installed as part of the gnome group.

To start GDM at boot time enable its systemd service file as shown
below:

    # systemctl enable gdm

The arguments passed to the X server by ~/.xinitrc (such as those of
xmodmap and xsetroot) can also be added through xprofile:

    ~/.xprofile

    #!/bin/sh

    #
    # ~/.xprofile
    #
    # Executed by gdm at login
    #

    xmodmap -e "pointer =1 2 3 6 7 4 5" # set mouse buttons up correctly
    xsetroot -solid black              # sets the background to black

Configuration
-------------

> Log-in screen background image

To change the wallpaper of the log-in screen, follow the instructions
below:

First, create the directory to store the background image:

    # mkdir /opt/login

Then, create the necessary configuration file:

    # touch /etc/dconf/db/gdm.d/01-background

Now, copy this text into the the file you just created:

    [org/gnome/desktop/background]
    picture-uri='file:///opt/login/wallpaper.jpg'

Copy your background image of choice into the directory:

    # cp [YOUR FILE] /opt/login/wallpaper.jpg

where [YOUR FILE] needs to be a path to a JPEG image.

Finally, update dconf as shown below:

    # dconf update

> Log-in screen logo

To display a logo on your log-in screen, follow the instructions below.

Create the directory to store the logo:

    # mkdir /opt/login

Create the necessary configuration file:

    # touch /etc/dconf/db/gdm.d/02-logo

Copy this text into the file:

    [org/gnome/login-screen]
    logo='/opt/login/logo.png'

Copy your logo of choice into the directory:

    # cp [YOUR FILE] /opt/login/logo.png

where [YOUR FILE] needs to be a path to a PNG image.

Update dconf:

    # dconf update

> Larger font for log-in screen

To change the font size of the log-in screen, follow the instructions
below:

Create the necessary configuration file:

    # touch /etc/dconf/db/gdm.d/03-scaling

Copy this text into the file:

    [org/gnome/desktop/interface]
    text-scaling-factor='1.25'

Update dconf:

    # dconf update

> Turning off the sound

This tweak disables the audible feedback heard when the system volume is
adjusted (via keyboard) on the login screen.

Create the necessary configuration file:

    # touch /etc/dconf/db/gdm.d/04-sound

Copy this text into the file:

    [org/gnome/desktop/sound]
    event-sounds='false'

Update dconf:

    # dconf update

> Make the power button interactive

The default installation sets the power button to suspend the system.
Power off or Show dialog is a better choice.

Create the necessary configuration file:

    # touch /etc/dconf/db/gdm.d/05-power 

Copy this text into the file:

    [org/gnome/settings-daemon/plugins/power button]
    power='interactive'
    hibernate='interactive'

Update dconf:

    # dconf update

Warning:Please note that the acpid daemon also handles the "power
button" and "hibernate button" events. Running both systems at the same
time may lead to unexpected behaviour.

> Prevent suspend when closing the lid

Some laptops may experience behaviour where the laptop suspends when the
lid is closed despite having set the options Laptop lid close action on
battery and Laptop lid close action on AC to blank. If this is the case
uncomment the HandleLidSwitch line in the /etc/systemd/logind.conf file
and change the value to ignore. The value is set to suspend by default.

> GDM keyboard layout

To change the keyboard layout for all graphical programs (including
GDM), add the following line to /etc/X11/xorg.conf.d/10-evdev.conf,
replacing fr with the appropriate keymap.

    /etc/X11/xorg.conf.d/10-evdev.conf

    Section "InputClass"
            Identifier "evdev keyboard catchall"
            MatchIsKeyboard "on"
            MatchDevicePath "/dev/input/event*"
            Driver "evdev"
            Option "XkbLayout" "fr"
    EndSection

Warning:Add the line to the keyboard InputClass section, not any of the
other sections.

Tip:See Wikipedia:ISO_3166-1 for a list of keymaps.

GDM 2.x layout

Users of legacy GDM may need to follow the instructions below:

Edit ~/.dmrc:

    ~/.dmrc

    [Desktop]
    Language=de_DE.UTF-8   # change to your default lang
    Layout=de   nodeadkeys # change to your keyboard layout

> Change the language

To change the GDM language, edit the file
/var/lib/AccountsService/users/gdm and change the language line using
the correct UTF-8 value for your language. You should see something
similar to the text below:

    /var/lib/AccountsService/users/gdm

    [User]
    Language=fr_FR.UTF-8
    XSession=
    SystemAccount=true

Now just reboot your computer.

Once you have rebooted, if you look at the
/var/lib/AccountsService/users/gdm file again, you will see that the
language line is cleared — do not worry, the language change has been
preserved.

> Automatic login

To enable automatic login with GDM, add the following to
/etc/gdm/custom.conf (replace username with your own):

    /etc/gdm/custom.conf

    # Enable automatic login for user
    [daemon]
    AutomaticLogin=username
    AutomaticLoginEnable=True

or for an automatic login with a delay:

    /etc/gdm/custom.conf

    [daemon]
    # for login with delay
    TimedLoginEnable=true
    TimedLogin=username
    TimedLoginDelay=1

> Passwordless login

If you want to bypass the password prompt in GDM then simply add the
following line on the first line of /etc/pam.d/gdm-password:

    auth sufficient pam_succeed_if.so user ingroup nopasswdlogin

Then, add the group nopasswdlogin to your system. See Groups for group
descriptions and group management commands.

Now, add your user to the nopasswdlogin group and you will only have to
click on your username to login.

> Warning:

-   Do not do this for a root account.
-   You won't be able to change your session type at login with GDM
    anymore. If you want to change your default session type, you will
    first need to remove your user from the nopasswdlogin group.

> Passwordless shutdown for multiple sessions

GDM uses polkit and logind to gain permissions for shutdown. You can
shutdown the system when multiple users are logged in by setting:

    /etc/polkit-1/localauthority.conf.d/org.freedesktop.logind.policy

    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE policyconfig PUBLIC
     "-//freedesktop//DTD PolicyKit Policy Configuration 1.0//EN"
     "http://www.freedesktop.org/standards/PolicyKit/1.0/policyconfig.dtd">


    <policyconfig>

      <action id="org.freedesktop.login1.power-off-multiple-sessions">
        <description>Shutdown the system when multiple users are logged in</description>
        <message>System policy prevents shutting down the system when other users are logged in</message>
        <defaults>
          <allow_inactive>yes</allow_inactive>
          <allow_active>yes</allow_active>
        </defaults>
      </action>

    </policyconfig>

You can find all available logind options (e.g.
reboot-multiple-sessions) here.

> Enable root login in GDM

It is not advised to login as root, but if necessary you can edit
/etc/pam.d/gdm-password and add the following line before the line
auth required pam_deny.so: /etc/pam.d/gdm-password

    auth            sufficient      pam_succeed_if.so uid eq 0 quiet

The file should look something like this: /etc/pam.d/gdm-password

    ...
    auth            sufficient      pam_succeed_if.so uid eq 0 quiet
    auth            sufficient      pam_succeed_if.so uid >= 1000 quiet
    auth            required        pam_deny.so
    ...

You should be able to login as root after restarting GDM.

> Configuration for older versions of GDM 3

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Needs to be      
                           updated for GDM 3.6 as   
                           gconf vars are being     
                           moved to dconf, control  
                           center incomplete by     
                           default (Discuss)        
  ------------------------ ------------------------ ------------------------

You can use the following instructions.

Configure X server access permission:

    # xhost +SI:localuser:gdm

Change the theme:

    $ sudo -u gdm dbus-launch gnome-control-center

For more configuration options, do:

    $ sudo -u gdm dbus-launch gconf-editor

and modify the following hierarchies:

    /apps/gdm/simple-greeter
    /desktop/gnome/interface
    /desktop/gnome/background

If these commands fail with an error (e.g. "Cannot open display") you
can bring the two windows up when GDM starts by adding them to GDM's
autostart. To do this first create the entry:

    # cp -t /usr/share/gdm/autostart/LoginWindow/ /usr/share/applications/gnome-appearance-properties.desktop /usr/share/applications/gconf-editor.desktop

Then go back to GDM, do your changes and log back in. When you're done
and want the window to stop opening with GDM run this:

    # rm /usr/share/gdm/autostart/LoginWindow/gnome-appearance-properties.desktop /usr/share/gdm/autostart/LoginWindow/gconf-editor.desktop

Note:By using the logout/configure method you can view the changes while
you're making them.

For more information and advanced settings read this.

> gdm3setup

You can install the gdm3setup tool from the AUR to configure GDM. It
will allow you to change a few settings, such as the theme, the
automatic connection, or the date format.

> GDM legacy

If you want to fall back to the old GDM, which also has a tool for
configuring its settings, install gdm-old from the AUR.

Troubleshooting
---------------

> GDM fails to unlock

Be sure to set the correct icon/gtk-theme. You can use gdm3setup from
the AUR to check the current theme settings.

> GDM fails on logout

If GDM starts up properly on boot, but fails after repeated attempts on
logout, try adding this line to the daemon section of
/etc/gdm/custom.conf:

    GdmXserverTimeout=60

> gconf-sanity-check-2 exited with status 256

If GDM pops up an error about gconf-sanity-check-2, you may check
permissions in /home and /etc/gconf/gconf.xml.system (the latter should
be 755). If GDM is still printing the message, try to empty the gdm
home. Run as root:

    rm -rf /var/lib/gdm/.*

If that doesn't help, try to set /tmp owner and permissions to:

    # chown -R root:root /tmp
    # chmod 777 /tmp

> GDM will not load after attempting to set up automatic log-in

To solve this issue, edit /etc/gdm/custom.conf from a TTY and comment
out the AutomaticLoginEnable and AutomaticLogin lines.

    # GDM configuration storage

    [daemon]

    #AutomaticLoginEnable=True
    #AutomaticLogin=user

    [security]

    [xdmcp]

    [greeter]

    [chooser]

    [debug]

Retrieved from
"https://wiki.archlinux.org/index.php?title=GDM&oldid=305922"

Categories:

-   Display managers
-   GNOME

-   This page was last modified on 20 March 2014, at 17:28.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
