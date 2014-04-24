Fingerprint-gui
===============

Fingerprint-gui is a program that provides an interface and drivers for
fingerprint readers included on some laptops. The package includes
drivers from the open-source project fprint as well as proprietary
drivers not included because that particular project has been stagnant
for some time.

Contents
--------

-   1 Installation
-   2 Registering Fingerprints
-   3 Authentication
-   4 Verification
-   5 Exporting
-   6 Password

Installation
------------

If you have an older laptop, it is probably wise to try fprint and/or
thinkfinger to see if the necessary drivers are included in one of those
packages. If your device is still unrecognized and is a Upek device,
fingerprint-gui may include the necessary drivers for you device. The
package fingerprint-gui can be installed from the AUR.

If you are using GNOME or KDE follow the instructions pacman gives and
remove the relevant files in /etc/xdg/autostart.

If your device is not recognized, you might need to reboot in order for
udev to set the correct permissions for the device. You may need to add
your user to the plugdev and scanner groups, as mentioned in
fprint#Setup_fingerprint-gui.

Registering Fingerprints
------------------------

After installation, it is probably wise to make sure your hardware is
recognized and correctly working before editing crucial files in pam.d.
To do this, launch the setup utility:

    $ fingerprint-gui -d

The '-d' is for debugging, and simply creates a verbose log of events.
If you are comfortable without the debug info, you may safely omit the
flag.

As one would expect from a package with 'gui' in its name, the
configuration utility is entirely graphical. Registering your
fingerprints is pretty self explanitory as it follows a Windows style
"wizard". If a more detailed set of instructions is required, the
package includes an install guide in html format.

    $ firefox /usr/share/doc/fingerprint-gui/Manual_en.html

Where Firefox is your browser of choice (of course any browser will do).

Authentication
--------------

Once your fingerprints have been registered, you may notice that in the
setup procedure that the "test" section does not yet work. This is
because the necessary authentication has not been approved in the
appropriate pam.d files.

As an example of how to set up fingerprint authetication for a given
service, we will first start with sudo. In your favorite text editor
open /etc/pam.d/sudo and insert the following bold text:

    #%PAM-1.0
    auth		sufficient	pam_fingerprint-gui.so
    auth		required	pam_unix.so
    auth		required	pam_nologin.so

Keep in mind that your 'sudo' file may contain more entries.

Some users may not have (or want to have) sudo installed on their
systems. In this case, it is still possible to use your fingerprint to
autheticate su. This can be done just like the sudo example, of course
instead adding an entry to /etc/pam.d/su. Again adding the below bold
text.

    #%PAM-1.0
    auth		sufficient	pam_rootok.so
    auth		sufficient	pam_fingerprint-gui.so
    auth		required	pam_unix.so
    account		required	pam_unix.so
    session		required	pam_unix.so

One may also configure such things as GDM, KDM, LightDM and the
Gnome-Screensaver. Again, if more information or instruction is needed,
please refer to the included manual. The Package Maintainer's Manual
might provide further information that cannot be obtained by the
included manual.

Verification
------------

Now that the necessary authentication has been added to pam, you may
wish the confirm the functionality of your setup. The easiest way to do
this is to, again, launch the fingerprint-gui. Rather than go through
the steps (as your fingerprints should already be established), click
directly on the Settings tab. From here you may select the function you
wish to test (ie. sudo, su, gdm, etc).

There is also an included utility to simply confirm that your registered
fingerprints are recognized. This can be done by simply running:

    $ fingerprint-identifier

and following the onscreen instructions.

Exporting
---------

If you wish to save your user's fingerprint data to a file, simple use
the Export button in the Settings tab. A file Fingerprints.tar.gz" will
be created in the desired directory. At this time, I have not yet
figured out what exactly to do with this saved file though, as I have
not come across an "Import" function.

Password
--------

In some cases, using your fingerprint to log into the system may inhibit
certain other functions of the desktop environment. For example, Gnome
Keyring is dependent on your password, as it is used to encrypt the data
in your keyring. To overcome this, fingerprint-gui contains a feature
that allows you to store your encrypted password on removable media
(USB). You may then use the key to decrypt your keychain by
autheticating you rfingerprint while the removable media is plugged in.

The manual indicates that to use this function, mount your USB drive and
ensure that you have write access to it. Under the "Password" tab of
fingerprint-gui, indicate the appropriate path to your device where it
says "Save to directory" (ie. if using gvfs it should be under
/run/media/your_uid/device). Enter your password and reenter it and
select "save". This will create a hidden directory on your removable
media /.fingerprints and create a file username@hostname.xml. On the
local machine, this will also create the file
/var/lib/fingerprint-gui/username/config.xml.

Note:Security warning: Everyone who has access to both, your computer
and the external media, can decrypt the password-file! Never leave the
computer and the media unattended at the same place! Connect this media
only while logon and don't use it if other persons have root-access to
your computer.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Fingerprint-gui&oldid=280854"

Categories:

-   Input devices
-   Laptops

-   This page was last modified on 1 November 2013, at 16:46.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
