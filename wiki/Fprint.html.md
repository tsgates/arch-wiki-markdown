Fprint
======

From the fprint homepage:

The fprint project aims to plug a gap in the Linux desktop: support for
consumer fingerprint reader devices.

The idea is to use the built-in fingerprint reader in some notebooks for
login using PAM. This article will also explain how to use regular
password for backup login method (solely fingerprint scanner is not
recommended due to numerous reasons).

Contents
--------

-   1 Prerequisites
-   2 Installation
-   3 Configuration
    -   3.1 Login configuration
    -   3.2 Create fingeprint signature
-   4 Setup fingerprint-gui

Prerequisites
-------------

Make sure you have one of the supported finger scanners. You can check
if your device is supported by checking this list of supported devices.
To check which one you have, type

    # lsusb

Installation
------------

Install fprintd from the official repositories. imagemagick might also
be needed.

Configuration
-------------

> Login configuration

Note:If you use GDM, the fingerprint-option is already available in the
login menu. You can skip this section!

Add pam_fprintd.so as sufficient to the top of the auth section of
/etc/pam.d/system-local-login:

    /etc/pam.d/system-local-login

    auth      sufficient pam_fprintd.so
    auth      include   system-login
    ...

This tries to use fingerprint login first, and if if fails or if it
finds no fingerprint signatures in the give user's home directory, it
proceeds to password login.

You can also modify other files in /etc/pam.d/ in the same way, for
example /etc/pam.d/polkit-1 for GNOME polkit authentication.

> Create fingeprint signature

To add a signature for a finger, run

    $ fprintd-enroll

You will be asked to scan the given finger. After that, the signature is
created in /var/lib/fprint/.

For more information, see man fprintd.

Setup fingerprint-gui
---------------------

  ------------------------ ------------------------ ------------------------
  [Tango-dialog-warning.pn This article or section  [Tango-dialog-warning.pn
  g]                       is out of date.          g]
                           Reason: packages do not  
                           exist anymore (Discuss)  
  ------------------------ ------------------------ ------------------------

An alternate fingerprint reader gui. This works with libfprint-unstable
which has support for the new Upeksonly readers, such as, the new
Thinkpad W510 T510 T410 T420 Upeksonly reader with USB ID 147e:2016

http://www.thinkwiki.org/wiki/Integrated_Fingerprint_Reader

http://www.n-view.net/Appliance/fingerprint/

Install as dependency libfakekey and fingerprint-gui.

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

Change the auth section to read:

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
"https://wiki.archlinux.org/index.php?title=Fprint&oldid=302902"

Category:

-   Input devices

-   This page was last modified on 2 March 2014, at 13:02.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
