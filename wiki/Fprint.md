Fprint
======

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: Fprint is now in 
                           Extra repository, names  
                           of some commands are     
                           changed. (Discuss)       
  ------------------------ ------------------------ ------------------------

From Pam fprint - fprint project:

pam_fprint is a simple PAM module which uses libfprint's fingerprint
processing and verification functionality for authentication. In other
words, instead of seeing a password prompt, you're asked to scan your
fingerprint.

The idea is to use the built-in fingerprint reader in some notebooks for
login using PAM. This article will also explain how to use regular
password for backup login method (solely fingerprint scanner is not
recommended due to numerous reasons).

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Prerequisites                                                      |
| -   2 Installation                                                       |
| -   3 Configuration                                                      |
|     -   3.1 Permissions                                                  |
|     -   3.2 Login configuration                                          |
|     -   3.3 Create fingeprint signature                                  |
|                                                                          |
| -   4 Setup fingerprint-gui                                              |
+--------------------------------------------------------------------------+

Prerequisites
-------------

First, make sure you have one of the supported finger scanners. You can
check if your device is supported by checking this list of supported
devices. To check which one you have, type

    # lsusb

You need to install pam and the fprint group.

    # pacman -S pam fprint

Installation
------------

Some dependencies:

    # pacman -S libusb imagemagick

Once you made sure your reader is supported, you are good to go.

Configuration
-------------

> Permissions

By default, only root has access to the device. You can create a
signature from sudo, but then you can only use it for root user. The
following solution from the Ubuntu forums may work for some people.

1. If the group plugdev doesn't exist, create it

    # groupadd plugdev

2. Add yourself to the group

    # gpasswd -a USER plugdev

3. Allow USB access

    # chgrp -R plugdev /dev/bus/usb/

> Login configuration

Modify the auth section of /etc/pam.d/login to this

    auth       required pam_env.so
    auth       sufficient   pam_fprintd.so
    auth       sufficient   pam_unix.so try_first_pass likeauth nullok
    auth       required pam_deny.so

This tries to use fingerprint login first, and if if fails or if it
finds no fingerprint signatures in the give user's home directory, it
proceeds to password login.

You can also modify other files in /etc/pam.d/ using the same method,
for example /etc/pam.d/gdm for GNOME's fingerprint login or
/etc/pam.d/polkit-1 for GNOME PolicyKit Authentication.

> Create fingeprint signature

Now you should be able to run the program under a normal user. To see
the usage, run

    $ man fprintd

Chose one of the fingers and run

    $ fprintd-enroll

You will be asked to scan the given finger 3 times. After that, the
signature is created in /var/lib/fprint/.

Setup fingerprint-gui
---------------------

An alternate fingerprint reader gui. This works with libfprint-unstable
which has support for the new Upeksonly readers, such as, the new
Thinkpad W510 T510 T410 T420 Upeksonly reader with USB ID 147e:2016

http://www.thinkwiki.org/wiki/Integrated_Fingerprint_Reader

http://www.n-view.net/Appliance/fingerprint/

Install a dependency:

    $ pacman -S libfakekey

Install fingerprint-gui from AUR

    $ yaourt -S fingerprint-gui

Please make sure your user is a member of "plugdev" and "scanner" group
if you use UPEK non-free library. You may also have to log out and back
in for these changes to take effect.

    # gpasswd -a USER plugdev
    # gpasswd -a USER scanner

fingerprint-polkit-agent conflicts with files in /etc/xdg/autostart that
must be removed:

    "polkit-gnome-authentication-agent-1.desktop" and
    "polkit-kde-authentication-agent-1.desktop".

Edit your PAM configuration (e.g., /etc/pam.d/{login,su,sudo,gdm}).

Change the auth section to read

    auth       required pam_env.so
    auth       sufficient   pam_fingerprint-gui.so
    auth       sufficient   pam_unix.so try_first_pass likeauth nullok
    auth       required pam_deny.so

Add this to your ~/.bashrc file if you get an error saying that it can't
connect to X desktop (see this for more details).

    xhost + >/dev/null

Now run fingerprint-gui and register fingerprints for the current user.
You will need to run fingerprint-gui and register fingerprints as all
users you want to use the fingerprint reader, i.e. as root to use it for
"su" login.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Fprint&oldid=249744"

Category:

-   Input devices
