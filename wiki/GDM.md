GDM
===

> Summary

GDM is the GNOME Display Manager, a graphical login program. This
article covers its installation and configuration.

> Related

Display Manager

GNOME

From GDM - GNOME Display Manager:

GDM is the GNOME Display Manager, it is the little program that runs in
the background, runs your X sessions, presents you with a login box and
then tells you to bug off because you forgot your password. It does
pretty much everything that you would want to use xdm for, but does not
involve as much crack. It does not use any code from xdm. It supports
XDMCP, and in fact extends XDMCP a little bit in places where I thought
xdm was lacking (but is still compatible with xdm's XDMCP).

Display managers provide X Window System users with a graphical login
prompt.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
|     -   1.1 GDM as the default greeter                                   |
|                                                                          |
| -   2 Configuration                                                      |
|     -   2.1 Automatic login                                              |
|     -   2.2 Passwordless login                                           |
|     -   2.3 Passwordless shutdown                                        |
|     -   2.4 Changing default GDM session                                 |
|     -   2.5 GDM legacy                                                   |
|                                                                          |
| -   3 Troubleshooting                                                    |
|     -   3.1 GDM fails on logout                                          |
|     -   3.2 gconf-sanity-check-2 exited with status 256                  |
|     -   3.3 GDM root login                                               |
|     -   3.4 GDM always uses default US-keyboard                          |
|         -   3.4.1 GDM 2.x                                                |
|         -   3.4.2 GDM 3.x                                                |
|         -   3.4.3 GDM Will Not Load After Attempting to Set-Up Automatic |
|             Login                                                        |
|         -   3.4.4 GDM Doesn't Start After Upgrading To 3.8 If Using      |
|             Intel Graphics                                               |
+--------------------------------------------------------------------------+

Installation
------------

GDM (which is also part of gnome-extra) can be installed with the gdm
package, available in the Official repositories.

> GDM as the default greeter

To make GDM the default graphical login method for the system, use the
packaged systemd service file, gdm.service. Simply run the following
command once to bring up GDM on boot:

    # systemctl enable gdm.service

The arguments passed to the X server by ~/.xinitrc (such as those of
xmodmap and xsetroot) can also be added through xprofile:

    ~/.xprofile

    #!/bin/sh

    #
    # ~/.xprofile
    #
    # Executed by gdm at login
    #

    xmodmap -e "pointer=1 2 3 6 7 4 5" # set mouse buttons up correctly
    xsetroot -solid black              # sets the background to black

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

Configuration
-------------

You can no longer use the gdmsetup command to configure GDM as of
version 2.28. The command has been removed and GDM has been standardized
and integrated with the rest of GNOME.

You can install gdm3setup from the AUR to configure GDM, or use the
following instructions.

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

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Needs to be      
                           updated for GDM 3.6      
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

If you want to bypass the password prompt in GDM then simply add the
following line to /etc/pam.d/gdm:

    auth sufficient pam_succeed_if.so user ingroup nopasswdlogin

Make sure this line goes right before the pam_unix.so auth line.

Then, add the group nopasswdlogin to your system. You can do it
graphically in System > Administration > Users and Groups. See Groups
for group descriptions and group management commands.

Now, when you use System Settings -> System -> Users Accounts (command:
gnome-control-center) and set your user for
"Password: not asked at login" (by checking the
"Don't ask for password on login" option), your user will be
automatically added to the nopasswdlogin group and you will only have to
click on your username to login.

Warning:Do not do this for a root account.

> Passwordless shutdown

GDM is using polkit and logind to gain permissions for shutdown. You can
allow it without entering a password first by setting:

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

> Changing default GDM session

If you want to change the default GDM session, you need to create (or
edit) the file ~/.dmrc [1].

Note:This is on a per-user basis. If you want to change the default for
more than one user, you will have to create this file for each user.

Here is an example to set the default session to Cinnamon:

    ~/.dmrc

    [Desktop]
    Session=cinnamon

> GDM legacy

If you want to fall back to the old GDM, which also has a tool for
configuring its settings, compile and install gdm-old from the AUR.

Troubleshooting
---------------

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

> GDM root login

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

> GDM always uses default US-keyboard

Problem: Keyboard layout always switches to us; layout is reset when a
new keyboard is plugged in.

GDM 2.x

Solution: edit ~/.dmrc

    ~/.dmrc

    [Desktop]
    Language=de_DE.UTF-8   # change to your default lang
    Layout=de   nodeadkeys # change to your keyboard layout

GDM 3.x

Solution: add the following line to /etc/X11/xorg.conf.d/10-evdev.conf,
replacing fr with the appropriate keymap

    /etc/X11/xorg.conf.d/10-evdev.conf

    Section "InputClass"
            Identifier "evdev keyboard catchall"
            MatchIsKeyboard "on"
            MatchDevicePath "/dev/input/event*"
            Driver "evdev"
            Option "XkbLayout" "fr"
    EndSection

Warning:Add the line to the keyboard InputClass section, not the pointer
one.

GDM Will Not Load After Attempting to Set-Up Automatic Login

To solve this issue, edit /etc/gdm/custom.conf from a TTY and comment
"AutomaticLoginEnable" and the "AutomaticLogin" lines.

    # GDM configuration storage

    [daemon]

    #AutomaticLoginEnable=True
    #AutomaticLogin=user

    [security]

    [xdmcp]

    [greeter]

    [chooser]

    [debug]

    EndSection

GDM Doesn't Start After Upgrading To 3.8 If Using Intel Graphics

To solve this problem you may have to set your acceleration method to
SNA. For more informations please refer to:
Intel_Graphics#Choose_acceleration_method

Retrieved from
"https://wiki.archlinux.org/index.php?title=GDM&oldid=255567"

Category:

-   Display managers
