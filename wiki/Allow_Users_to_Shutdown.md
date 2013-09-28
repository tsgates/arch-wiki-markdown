Allow Users to Shutdown
=======================

Using systemd-logind
--------------------

If you're using systemd (which is default in Arch Linux), users with
non-remote session can issue power-related commands as long as polkit is
installed and the session is not broken.

To shutdown:

    # systemctl poweroff

The suspend, poweroff and hibernate button presses and lid close events
are also handled by logind (see man logind.conf.

Using sudo
----------

First install sudo:

    # pacman -S sudo

Then, as root, add the following to the end of /etc/sudoers using the
visudo command. Substitute user for your username and hostname for the
machine's hostname.

    user hostname =NOPASSWD: /sbin/shutdown -h now,/sbin/halt,/sbin/poweroff,/sbin/reboot

Now your user can shutdown with sudo shutdown -h now, and reboot with
sudo reboot. Users wishing to power down a system can also use poweroff
or halt. Use the NOPASSWD: tag only if you do not want to be prompted
for your password.

For convenience, you can add these aliases to your user's ~/.bashrc if
you have it enabled (or to /etc/bash.bashrc for system-wide settings):

    alias reboot="sudo reboot"
    alias poweroff="sudo poweroff"
    alias halt="sudo halt"

Using acpid
-----------

acpid can be used to allow anyone with physical access to cleanly shut
down the computer by using this power button.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Allow_Users_to_Shutdown&oldid=239434"

Category:

-   Security
