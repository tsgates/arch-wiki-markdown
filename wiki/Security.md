Security
========

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Instructions on how to harden and secure an Arch Linux system.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Concepts                                                           |
| -   2 Physical security                                                  |
|     -   2.1 Locking down BIOS                                            |
|     -   2.2 Bootloader password                                          |
|         -   2.2.1 GRUB                                                   |
|                                                                          |
|     -   2.3 Automatic logout on VCs (and SSH)                            |
|                                                                          |
| -   3 Partitions                                                         |
|     -   3.1 Mount options                                                |
|         -   3.1.1 Relevant mount options                                 |
|         -   3.1.2 Potential usage                                        |
|                                                                          |
| -   4 Filesystem permissions                                             |
| -   5 Disk encryption                                                    |
| -   6 User setup                                                         |
| -   7 Restricting su                                                     |
| -   8 No root login at the console                                       |
| -   9 Lockout user after three failed login attempts                     |
| -   10 Use sudo for system commands                                      |
| -   11 Password hashes                                                   |
| -   12 Access control                                                    |
| -   13 Firewall                                                          |
| -   14 TCP/IP stack hardening                                            |
| -   15 Kernel hardening                                                  |
| -   16 Authenticating packages                                           |
| -   17 See also                                                          |
+--------------------------------------------------------------------------+

Concepts
--------

-   It is possible to tighten the security so much as to make your
    system unusable. The trick is to secure it without overdoing it.
-   There are many other things that can be done to heighten the
    security, but the biggest threat is, and will always be, the user
    himself. When you think security, you have to think layers. When one
    layer is breached, another should stop the attack. But you can never
    make the system 100% secure unless you unplug the machine from all
    networks, lock it in a safe and never use it.
-   Be a little paranoid. It helps. And be suspicious. If anything
    sounds too good to be true, it probably is!
-   Principle of least privilege

Physical security
-----------------

Note:You can ignore this section if you just want to secure your
computer against remote threats.

Physical access to a computer is basically root access, but you can stop
an attacker from having access without removing your hard drive (also
see #Disk encryption) or resetting your BIOS settings (both of which
involve opening the computer).

> Locking down BIOS

Adding a password to the BIOS prevents someone from booting into
removable media, which is basically the same as having root access to
your computer. You should make sure your drive is first in the boot
order and disable the other drives from being bootable if you can.

> Bootloader password

It's highly important to protect your bootloader. There's a magic kernel
parameter called init=/bin/sh. This makes any user/login restrictions
totally useless.

Good (strong) passwords can be obtained with ease, through the use of
the apg package, or Automated Password Generator.

GRUB

See: GRUB#Security

> Automatic logout on VCs (and SSH)

If you are using Bash or Zsh, you can set TMOUT, so you will never
forget open shell on VC (where xscreensaver is not protecting you):

    /etc/profile.d/shell-timeout.sh

    TMOUT="$(( 60*10 ))";
    [ -z "$DISPLAY" ] && export TMOUT;
    case $( /usr/bin/tty ) in
    	/dev/tty[0-9]*) export TMOUT;;
    esac

if you really want EVERY Bash/Zsh prompt (even within X) to timeout,
use:

    $ export TMOUT="$(( 60*10 ))";

Note that this will not work if there's some command running in the
shell (eg.: an SSH session or other shell without TMOUT support). But if
you are using VC mostly for restarting frozen GDM/Xorg as root, then
this is very usefull.

Partitions
----------

The kernel now prevents security issues related to hardlinks and
symlinks if the fs.protected_hardlinks and fs.protected_symlinks sysctl
switches are enabled, so there is no longer a major security benefit
from separating out world-writable directories.

Partitions containing world-writable directories can still be kept
separate as a coarse way of limiting the damage from disk space
exhaustion. However, filling a partition like /var or /tmp is enough to
take down services. More flexible mechanisms for dealing with this
concern exist (like quotas), and some filesystems include related
features themselves (btrfs has quotas on subvolumes).

> Mount options

Following the principle of least privilege, partitions should be mounted
with the most restrictive mount options possible (without losing
functionality).

Relevant mount options

-   nodev: Do not interpret character or block special devices on the
    file system.
-   nosuid: Do not allow set-user-identifier or set-group-identifier
    bits to take effect.
-   noexec: Do not allow direct execution of any binaries on the mounted
    filesystem.

Potential usage

Note:Data partitions should always be mounted with nodev, nosuid,
noexec.

  ----------- ------- -------- -----------------------------------------------------------
  Partition   nodev   nosuid   noexec
  /var        yes     yes      yes
  /home       yes     yes      yes, if you do not code or use wine
  /dev/shm    yes     yes      yes
  /tmp        yes     yes      maybe, breaks compiling packages and various other things
  /boot       yes     yes      yes
  ----------- ------- -------- -----------------------------------------------------------

Filesystem permissions
----------------------

The default filesystem permissions allow read access to almost
everything and changing the permissions can hide valuable information
from an attacker who gains access to a non-root account such as the http
or nobody users.

For example:

    # chmod 700 /boot /etc/{iptables,arptables}

Disk encryption
---------------

You should know that encryption is the only way for protecting your data
against people that have physical access to your computer. But once you
mount an encrypted volume you have to be sure that you are the only
person having physical or root access to the machine (nothing in the
system is safe against root).

See Disk Encryption for detailed information.

User setup
----------

After installation make a normal user for daily use. Don't use the root
user for daily use. Pick a secure password. Do not to use a dictionary
word or something like your dog's name. A password should be at least
eight characters long. Contain a mix of upper and lower case letters. It
should include at least one number and/or one special character.

If you have a good memory for passwords then you can use a program like
pwgen to create a bunch of passwords and print them on the screen. Then
just pick one to use. Alternately you can make a password using the
first characters from every word in a sentence. Take for instance “the
girl is walking down the rainy street” could be translated to
“t6!WdtR5”. This approach could make it easier to remember a password.
Or, if you don't mind typing you could make it “The girl is walking down
the rainy street.”

Restricting su
--------------

See Su#Security for details.

No root login at the console
----------------------------

Changing the configuration to disallow root to login from the console
makes it harder for an intruder to gain access to the system. The
intruder would have to guess both a user-name that exists on the system
and that users password. When root is allowed to log in via the console,
an intruder only need to guess a password. Blocking root login at the
console is done by commenting out the tty lines in /etc/securetty.

    /etc/securetty

    #tty1

Repeat for any tty you wish to block. To check the effect of this
change, start by commenting out only one line and go to that particular
console and try to login as root. You will be greeted by the message
"Login incorrect". Now that we're sure it works, go back and comment out
the rest of the tty lines.

Lockout user after three failed login attempts
----------------------------------------------

To further heighten the security it is possible to lockout a user after
a specified number of failed login attempts. The user account can either
be locked until the root user unlocks it, or automatically be unlocked
after a set time. To lockout a user for ten minutes after three failed
login attempts you have to modify /etc/pam.d/system-login:

    /etc/pam.d/system-login

    auth required pam_tally.so deny=2 unlock_time=600 onerr=succeed file=/var/log/faillog
    #auth required pam_tally.so onerr=succeed file=/var/log/faillog

If you don't comment the second line every failed login attempt will be
counted twice. That's all there's to it. If you feel adventurous, make
three failed login attempts. Then you can see for yourself what happens.
To unlock a user manually do:

    # pam_tally --user --reset

If you want to permanently lockout a user after 3 failed login attempts
remove the unlock_time part of the line. The user can then not login
until root unlocks the account.

Use sudo for system commands
----------------------------

To make a user run some system commands as root it is advisable to use
sudo to give that user the needed authority. It wouldn't be good to hand
out the root password to just anyone. Even if you are the only user on
the system, using sudo is a good idea to keep from using a root console
too much. Sometimes you just forget to logout again.

Setting up sudo is quite easy. Just use visudo to bring up the
configuration file in the editor. The file already includes some
examples you can use. To mount Samba shares from a server as a regular
user, add the following using visudo:

    %users ALL=/sbin/mount.cifs,/sbin/umount.cifs

This allows all users who are members of the group users to run the
commands /sbin/mount.cifs and /sbin/umount.cifs from any machine (ALL).

Tip:To use nano instead of vi, edit /etc/sudoers. This should be done
using visudo:

    /etc/sudoers

    Defaults editor=/usr/bin/nano

Exporting # EDITOR=nano visudo is regarded as a severe security risk
since everything can be used as an EDITOR.

Password hashes
---------------

The default Arch hash sha512 is very strong and there's no need to
change it.

Access control
--------------

-   AppArmor (pathname)
-   SELinux (labels)
-   Tomoyo (pathname)
-   grsecurity

Firewall
--------

-   See Simple stateful firewall for a guide on setting up an netfilter
    (iptables) firewall.
-   See Firewalls for other ways of setting up netfilter.
-   See iptables for general info.

TCP/IP stack hardening
----------------------

TCP/IP stack hardening

Kernel hardening
----------------

grsecurity

Authenticating packages
-----------------------

Package signing is enabled (and required) by default and relies on a web
of trust from 5 trusted master keys. See pacman-key for details.

See also
--------

-   ArchWiki's Current list of security applications: Lists of
    Applications: Security
-   Securing and Hardening Red Hat Linux Production Systems
-   Hardening the linux desktop
-   Hardening the linux server
-   Securing and Optimizing Linux
-   UNIX and Linux Security Checklist v3.0

Retrieved from
"https://wiki.archlinux.org/index.php?title=Security&oldid=251486"

Categories:

-   Security
-   File systems
-   Networking
