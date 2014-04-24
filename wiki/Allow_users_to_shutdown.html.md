Allow users to shutdown
=======================

Contents
--------

-   1 Button and Lid events
-   2 Using systemd-logind
-   3 Using sudo
    -   3.1 Users without sudo privileges
-   4 Creating aliases

Button and Lid events
---------------------

The suspend, poweroff and hibernate button presses and lid close events
are handled by logind as described in Power management#ACPI events page.

Using systemd-logind
--------------------

If you're using systemd (which is default in Arch Linux) and install
polkit, users with non-remote session can issue power-related commands
as long as the session is not broken.

To check if your session is active

    $ loginctl show-session $XDG_SESSION_ID --property=Active

The user can then use systemctl commands in the command line, or add
them to menus:

    $ systemctl poweroff
    $ systemctl reboot

Other commands can be used as well, including systemctl suspend and
systemctl hibernate. See the System Commands section in man systemctl

Using sudo
----------

Install sudo, and give the user sudo privileges. The user will then be
able to use sudo systemctl commands in the command line or in menus:

    $ sudo systemctl poweroff
    $ sudo systemctl reboot

Other commands can be used as well, including sudo systemctl suspend and
sudo systemctl hibernate. See the System Commands section in
man systemctl

> Users without sudo privileges

If users should only be allowed to use shutdown commands, but not have
other sudo privileges, then, as root, add the following to the end of
/etc/sudoers using the visudo command. Substitute user for your username
and hostname for the machine's hostname.

    user hostname =NOPASSWD: /usr/bin/systemctl poweroff,/usr/bin/systemctl halt,/usr/bin/systemctl reboot

Now your user can shutdown with sudo systemctl poweroff, and reboot with
sudo systemctl reboot. Users wishing to power down a system can also use
sudo systemctl halt. Use the NOPASSWD: tag only if you do not want to be
prompted for your password.

Creating aliases
----------------

For convenience, you can add these aliases to your user's ~/.bashrc if
you have it enabled (or to /etc/bash.bashrc for system-wide settings):

    alias reboot="sudo systemctl reboot"
    alias poweroff="sudo systemctl poweroff"
    alias halt="sudo systemctl halt"

Retrieved from
"https://wiki.archlinux.org/index.php?title=Allow_users_to_shutdown&oldid=305038"

Category:

-   Security

-   This page was last modified on 16 March 2014, at 12:10.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
