ThinkFinger
===========

ThinkFinger is a driver for the SGS Thomson Microelectronics fingerprint
reader found in older IBM/Lenovo ThinkPads.

ThinkWiki has a list of various fingerprint readers found in ThinkPads.
Newer models using different readers might not work with ThinkFinger.

Warning:ThinkFinger-svn revisions above rev 72 require you to load the
module uinput!

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 TF-Tool                                                      |
|                                                                          |
| -   3 Pam                                                                |
|     -   3.1 /etc/pam.d/login                                             |
|     -   3.2 /etc/pam.d/su                                                |
|     -   3.3 /etc/pam.d/sudo                                              |
|     -   3.4 /etc/pam.d/xscreensaver                                      |
|     -   3.5 /etc/pam.d/gdm                                               |
|     -   3.6 /etc/pam.d/xdm                                               |
|                                                                          |
| -   4 SLiM                                                               |
| -   5 Alternative fingerprint reader software                            |
| -   6 See also                                                           |
+--------------------------------------------------------------------------+

Installation
------------

Get it from extra: pacman -S thinkfinger

Configuration
-------------

> TF-Tool

Use tf-tool to test ThinkFinger. You'll have to run this as root because
a direct access to the usb devices is needed. Run tf-tool --acquire to
generate a test.bir and tf-tool --verify to see if it identifies you
correctly. tf-tool --add-user <username> acquires and stores your
fingerprint in /etc/pam_thinkfinger/username.bir, which is needed for an
authentication with pam.

Pam
---

PAM is the Pluggable Authentication Module, invented by Sun.

> /etc/pam.d/login

Change the file /etc/pam.d/login to look like this if you want to use
your fingerprint to authenticate yourself on logon:

    #%PAM-1.0
    auth		sufficient	pam_thinkfinger.so
    auth		required	pam_unix.so use_first_pass nullok_secure
    account		required	pam_unix.so
    password	required	pam_unix.so
    session		required	pam_unix.so

> /etc/pam.d/su

Change this file to confirm the su command with a finger-swipe!

    #%PAM-1.0
    auth            sufficient      pam_rootok.so
    auth		sufficient 	pam_thinkfinger.so
    auth		required	pam_unix.so nullok_secure try_first_pass
    account		required	pam_unix.so
    session		required	pam_unix.so

Tip:Don't forget to do a tf-tool --add-user root to use this feature!

> /etc/pam.d/sudo

Change this file to confirm the sudo command with a finger-swipe!

    #%PAM-1.0
    auth		sufficient 	pam_thinkfinger.so
    auth		required	pam_unix.so nullok_secure try_first_pass
    auth		required	pam_nologin.so

> /etc/pam.d/xscreensaver

XScreensaver is a bit tricky. First, configure PAM with a file
"/etc/pam.d/xscreensaver" containing :

    auth            sufficient      pam_thinkfinger.so
    auth            required        pam_unix_auth.so try_first_pass

But it still wont work with only that because xscreensaver cannot
read/write from /dev/misc/uinput and /dev/bus/usb*. A udev rule must be
written to authorize a new group read/write access.

First, create a new group. I suggest "fingerprint":

    > sudo groupadd fingerprint
    Add the user you want to be able to unlock xscreensaver with the fingerprint reader to the group:
    > sudo gpasswd -a <user> fingerprint

Don't forget to logout and login again!

Search for "uinput" and "bus/usb" in your udev rules directory :

    > grep -in uinput /etc/udev/rules.d/*
    /etc/udev/rules.d/udev.rules:222:KERNEL=="uinput",  NAME="misc/%k", SYMLINK+="%k"
    /etc/udev/rules.d/udev.rules:263:KERNEL=="uinput", NAME="input/%k"
    > grep -in "bus/usb" /etc/udev/rules.d/*
    /etc/udev/rules.d/udev.rules:318:SUBSYSTEM=="usb_device", ACTION=="add", PROGRAM="/bin/sh -c 'K=%k; K=$${K#usbdev};printf bus/usb/%%03i/%%03i $${K%%%%.*} $${K#*.}'", NAME="%c", MODE="0664"
    /etc/udev/rules.d/udev.rules:320:SUBSYSTEM=="usb", ACTION=="add", ENV{DEVTYPE}=="usb_device", NAME="bus/usb/$env{BUSNUM}/$env{DEVNUM}", MODE="0664"

Now copy the previous lines (222, 318 and 320 from
/etc/udev/rules.d/udev.rules) to a new udev rules file. I suggest
/etc/udev/rules.d/99my.rules

    KERNEL=="uinput",  NAME="misc/%k", SYMLINK+="%k", MODE="0660", GROUP="fingerprint"
    SUBSYSTEM=="usb_device", ACTION=="add", PROGRAM="/bin/sh -c 'K=%k; K=$${K#usbdev};printf bus/usb/%%03i/%%03i $${K%%%%.*} $${K#*.}'", NAME="%c", MODE="0664", GROUP="fingerprint"
    SUBSYSTEM=="usb", ACTION=="add", ENV{DEVTYPE}=="usb_device", NAME="bus/usb/$env{BUSNUM}/$env{DEVNUM}", MODE="0664", GROUP="fingerprint"

The difference between the rules in /etc/udev/rules.d/99my.rules and
those in /etc/udev/rules.d/udev.rules should only be the addition of
MODE="0664", GROUP="fingerprint" or MODE="0660", GROUP="fingerprint" at
the end of the lines.

After this you must actually give your user permissions to access his
own fingerprint file, this can be done as in the following:

    > chown $USERNAME:root /etc/pam_thinkfinger/$USERNAME.bir
    > chmod 400 /etc/pam_thinkfinger/$USERNAME.bir
    > chmod o+x /etc/pam_thinkfinger

Yes that last one is opening up a directory for execution to everyone so
if you're super paranoid you might consider that a security flaw, just
putting the warning out there.

The last part is about xscreensaver. If you check xscreensaver file, you
will see it is setuid to root :

    > ls -l /usr/bin/xscreensaver
    -rwsr-sr-x 1 root root 217K aoû  2 20:47 /usr/bin/xscreensaver

Because of this, xscreensaver wont be able to unlock with the
fingerprint reader. You need to remove the setuid root with :

    > sudo chmod -s /usr/bin/xscreensaver
    > ls -l /usr/bin/xscreensaver
    -rwxr-xr-x 1 root root 217K aoû  2 20:47 /usr/bin/xscreensaver

That's it!

> /etc/pam.d/gdm

[I am not an expert in PAMs but this works, This section may need
corrections]

Edit /etc/pam.d/gdm as done in sections 3.1 and 3.2

    add as the first line in the file: 
    auth		sufficient 	pam_thinkfinger.so

    Modify:
    auth		required	pam_unix.so ==> auth		required	pam_unix.so use_first_pass nullok_secure

> /etc/pam.d/xdm

Change /etc/pam.d/xdm to look like this:

    #%PAM-1.0
    auth            sufficient      pam_thinkfinger.so
    auth            required        pam_unix.so use_first_pass nullok_secure
    auth            required        pam_nologin.so
    auth            required        pam_env.so
    account         required        pam_unix.so
    password        required        pam_unix.so
    session         required        pam_unix.so
    session         required        pam_limits.so

SLiM
----

To have thinkfinger support for the SLiM Login Manager you need to
activate PAM support:

Get the package source of the slim package from ABS and change the
"make" line in the PKGBUILD:

    make USE_PAM=1 || return 1

Rebuild the package and install it.

Then create a file /etc/pam.d/slim:

    #%PAM-1.0
    auth            sufficient      pam_thinkfinger.so
    auth            requisite       pam_nologin.so
    auth            required        pam_env.so
    auth            required        pam_unix.so
    account         required        pam_unix.so
    session         required        pam_limits.so
    session         required        pam_unix.so
    password        required        pam_unix.so

Now restart slim and swipe your finger.

Alternative fingerprint reader software
---------------------------------------

Fprint is an alternative fingerprint reader software that works with
some of the newer ThinkPad fingerprint readers.

See also
--------

-   http://www.thinkwiki.org/wiki/Talk:How_to_enable_the_fingerprint_reader
-   http://thinkfinger.sourceforge.net/
-   https://bbs.archlinux.org/viewtopic.php?id=36134
-   http://www.thinkwiki.org/wiki/How_to_enable_the_fingerprint_reader_with_ThinkFinger
-   http://www.thinkwiki.org/index.php?title=Installing_Ubuntu_6.06_on_a_ThinkPad_T43#Fingerprint_Reader

Retrieved from
"https://wiki.archlinux.org/index.php?title=ThinkFinger&oldid=249146"

Categories:

-   Input devices
-   Lenovo
