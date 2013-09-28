Pam mount
=========

To have an encrypted home partition (encrypted with, for example, LUKS
or ecryptfs) mounted automatically when logging in, you can use
pam_mount. It will mount your /home (or whatever mount point you like)
when you log in using your login manager or when logging in on console.
The encrypted drive's passphrase should be the same as your linux user's
password, so you do not have to type in two different passphrases to
login.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 General Setup                                                      |
| -   2 Login Manager Configuration                                        |
|     -   2.1 Slim                                                         |
|     -   2.2 GDM                                                          |
+--------------------------------------------------------------------------+

General Setup
-------------

1.  Install pam_mount from the Official Repositories.
2.  Edit /etc/security/pam_mount.conf.xml as follows:

Insert 2 new lines at the end of the file, but before the last closing
tag, </pam_mount>. Notes:

-   USERNAME should be replaced with your linux-username.
-   /dev/sdaX should be replaced with the corresponding device or
    container file.
-   fstype="auto" can be changed to any <type> that is present in
    /sbin/mount.<type>. "auto" should work fine in most cases.
-   Add mount options, if needed.

    /etc/security/pam_mount.conf.xml

    <volume user="USERNAME" fstype="auto" path="/dev/sdaX" mountpoint="/home" options="fsck,noatime" />
    <mkmountpoint enable="1" remove="true" />

    </pam_mount>

Login Manager Configuration
---------------------------

In general, you have to edit configuration files in /etc/pam.d so that
pam_mount will be called on login. The correct order of entries in each
file is important. It is probably necessary to change both
/etc/pam.d/login and the file for your display manager (e.g., Slim or
GDM). Example configuration files follow, with the added lines in bold.

    /etc/pam.d/system-auth

    #%PAM-1.0

    auth      required  pam_env.so
    auth      required  pam_unix.so     try_first_pass nullok
    auth      optional  pam_mount.so
    auth      optional  pam_permit.so

    account   required  pam_unix.so
    account   optional  pam_permit.so
    account   required  pam_time.so

    password  optional  pam_mount.so
    password  required  pam_unix.so     try_first_pass nullok sha512 shadow
    password  optional  pam_permit.so

    session   optional  pam_mount.so
    session   required  pam_limits.so
    session   required  pam_env.so
    session   required  pam_unix.so
    session   optional  pam_permit.so

You may need to add similar lines to /etc/pam.d/su and /etc/pam.d/sudo,
depending on how you use su and sudo, respectively.

> Slim

    /etc/pam.d/slim

    auth            requisite       pam_nologin.so
    auth            required        pam_env.so
    auth            required        pam_unix.so
    auth            optional        pam_mount.so
    account         required        pam_unix.so
    password        required        pam_unix.so
    password        optional        pam_mount.so
    session         required        pam_limits.so
    session         required        pam_unix.so
    session         optional        pam_mount.so
    session         optional        pam_loginuid.so
    session         optional        pam_ck_connector.so

> GDM

Note that the configuration file has changed to be
/etc/pam.d/gdm-password (instead of /etc/pam.d/gdm) as of GDM version
3.2.

    /etc/pam.d/gdm-password

    #%PAM-1.0
    auth            requisite       pam_nologin.so
    auth            required        pam_env.so

    auth            requisite       pam_unix.so nullok
    auth	        optional        pam_mount.so
    auth            optional        pam_gnome_keyring.so

    auth            sufficient      pam_succeed_if.so uid >= 1000 quiet
    auth            required        pam_deny.so

    account         required        pam_unix.so

    password        required        pam_unix.so
    password        optional        pam_mount.so

    session         required        pam_loginuid.so
    -session        optional        pam_systemd.so
    session         optional        pam_keyinit.so force revoke
    session         required        pam_limits.so
    session         required        pam_unix.so
    session         optional        pam_mount.so
    session         optional        pam_gnome_keyring.so auto_start

Retrieved from
"https://wiki.archlinux.org/index.php?title=Pam_mount&oldid=248794"

Category:

-   Security
