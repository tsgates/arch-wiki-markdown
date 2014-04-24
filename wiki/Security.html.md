Security
========

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: Many of these    
                           categories are just      
                           links, or lists of       
                           links. Some of the       
                           language is repetitive   
                           or unclear. (Discuss)    
  ------------------------ ------------------------ ------------------------

Related articles

-   List of Applications/Security
-   Category:Security

This article contains recommendations and best practices for hardening
an Arch Linux system.

Contents
--------

-   1 Concepts
-   2 Passwords
    -   2.1 Maintaining passwords
-   3 Physical security
    -   3.1 Locking down BIOS
    -   3.2 Bootloaders
        -   3.2.1 Syslinux
        -   3.2.2 GRUB
-   4 Partitions
    -   4.1 Mount options
        -   4.1.1 Relevant mount options
        -   4.1.2 Potential usage
-   5 Filesystem permissions
-   6 Disk encryption
-   7 User setup
    -   7.1 Password hashes
    -   7.2 Automatic logout
    -   7.3 Lockout user after three failed login attempts
-   8 Restricting root
    -   8.1 Use sudo instead of su
        -   8.1.1 Editing files using sudo
    -   8.2 Restricting root login
        -   8.2.1 Allow only certain users
        -   8.2.2 Denying console login
        -   8.2.3 Denying ssh login
-   9 Mandatory access control
    -   9.1 Pathname MAC
    -   9.2 Role-based access control
    -   9.3 Labels MAC
    -   9.4 Access Control Lists
-   10 Kernel Hardening
-   11 Network and Firewalls
    -   11.1 Firewalls
    -   11.2 Kernel parameters
    -   11.3 SSH
-   12 Authenticating packages
-   13 See also

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
-   The principle of least privilege: each part of a system should only
    be able to access what is required to use it, and nothing more.

Grsecurity has its own Wiki page.

Passwords
---------

Passwords are key to a secure linux system. They secure your user
accounts, encrypted filesystems, and SSH/GPG keys. They are the main way
a computer chooses to trust the person using it, so a big part of
security is just about picking secure passwords and protecting them.

It is important that your passwords cannot be easily cracked or guessed
from personal information. For this reason, do not to use a dictionary
word or something like your dog's name. A password should be at least
eight characters long, with a mix of upper and lower case letters. It
should include at least one number and/or one special character. As
expected, longer, more complex passwords are generally better.

Tools like pwgen and apg can help you generate secure passwords.

Alternatively you can make a password using the first characters from
every word in a sentence. Take for instance “the girl is walking down
the rainy street” could be translated to “t6!WdtR5”. This approach could
make it easier to remember a password. Or, if you do not mind typing you
could make it “The girl is walking down the rainy street.”

> Maintaining passwords

Once you pick a strong password, be sure to keep it safe. Watch out for
manipulation, shoulder surfing, and avoid reusing passwords so insecure
servers cannot leak more information than necessary. Tools like pass,
keepassx, and gnome-keyring can help manage large numbers of complex
passwords. Lastpass is a service that stores encrypted passwords online
for synchronization between devices, but requires that you trust both
closed-source code and an external corporation.

As a rule, do not pick insecure passwords just because secure ones are
harder to remember. Passwords are a balancing act. It is better to have
an encrypted database of secure passwords, guarded behind a key and one
strong master password, than it is to have many similar weak passwords.
Writing passwords down is perhaps equally effective[1], avoiding
potential vulnerabilities in software solutions while requiring physical
security.

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

> Bootloaders

It is highly important to protect your bootloader. There is a magic
kernel parameter called init=/bin/sh. This makes any user/login
restrictions totally useless.

Syslinux

Syslinux supports password-protecting your bootloader. It allows you to
set either a per-menu-item password or a global bootloader password.

GRUB

GRUB supports bootloader passwords as well. See
GRUB#Password_protection_of_GRUB_menu for details.

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
  /var        yes     yes      yes [1]
  /home       yes     yes      yes, if you do not code, use wine or steam
  /dev/shm    yes     yes      yes
  /tmp        yes     yes      maybe, breaks compiling packages and various other things
  /boot       yes     yes      yes
  ----------- ------- -------- -----------------------------------------------------------

[1] Note that some packages (building nvidia-dkms for example) may
require exec on /var.

Filesystem permissions
----------------------

The default filesystem permissions allow read access to almost
everything and changing the permissions can hide valuable information
from an attacker who gains access to a non-root account such as the http
or nobody users.

For example:

    # chmod 700 /boot /etc/{iptables,arptables}

The default Umask can be changed to improve security for newly created
files. The NSA RHEL5 Security Guide suggests a umask of 077 for maximum
security, which makes new files not readable by users other than the
owner. To change this, see Umask#Setting the UMASK.

Disk encryption
---------------

Disk Encryption, preferably full disk encryption with a strong
passphrase, is the only way to guard data against physical recovery.
This provides complete security when the computer is turned off or the
disks in question are unmounted.

Once the computer is powered on and the drive is mounted, however, its
data becomes just as vulnerable as an unencrypted drive. It is therefore
best practice to unmount data partitions as soon as they are no longer
needed.

Certain programs, like TrueCrypt, allow the user to encrypt a single
file as a virtual volume. This is a reasonable alternative to full disk
encryption when only certain parts of the system need be secure. Hidden
volumes create another layer of security, introducing plausible
deniability for encrypted data.

User setup
----------

After installation make a normal user for daily use. Do not use the root
user for daily use.

> Password hashes

The default Arch hash sha512 is very strong and there is no need to
change it. By default, passwords are hashed in /etc/shadow, readable
only by root, and only user identifiers are stored in /etc/passwd,
therefore, as long as the root user is secured, the file cannot be
copied and cracked on an external system.

> Automatic logout

If you are using Bash or Zsh, you can set TMOUT, so you will never
forget an open virtual console shell (where screensavers cannot protect
you):

    /etc/profile.d/shell-timeout.sh

    TMOUT="$(( 60*10 ))";
    [ -z "$DISPLAY" ] && export TMOUT;
    case $( /usr/bin/tty ) in
    	/dev/tty[0-9]*) export TMOUT;;
    esac

If you really want EVERY Bash/Zsh prompt (even within X) to timeout,
use:

    $ export TMOUT="$(( 60*10 ))";

Note that this will not work if there is some command running in the
shell (eg.: an SSH session or other shell without TMOUT support). But if
you are using VC mostly for restarting frozen GDM/Xorg as root, then
this is very usefull.

> Lockout user after three failed login attempts

To further heighten the security it is possible to lockout a user after
a specified number of failed login attempts. The user account can either
be locked until the root user unlocks it, or automatically be unlocked
after a set time. To lockout a user for ten minutes after three failed
login attempts you have to modify /etc/pam.d/system-login:

    /etc/pam.d/system-login

    auth required pam_tally.so deny=2 unlock_time=600 onerr=succeed file=/var/log/faillog
    #auth required pam_tally.so onerr=succeed file=/var/log/faillog

If you do not comment the second line every failed login attempt will be
counted twice. That is all there is to it. If you feel adventurous, make
three failed login attempts. Then you can see for yourself what happens.
To unlock a user manually do:

    # pam_tally --user --reset

If you want to permanently lockout a user after 3 failed login attempts
remove the unlock_time part of the line. The user can then not login
until root unlocks the account.

Restricting root
----------------

The root user is, by definition, the most powerful user on a system.
Because of this, there are a number of ways to keep the power of the
root user while limiting its ability to cause harm, or at least to make
root user actions more traceable.

> Use sudo instead of su

Using sudo for privileged access is preferable to su for a number of
reasons.

-   It keeps a log of which normal privilege user has run each
    privileged command.
-   The root user password need not be given out to each user who
    requires root access.
-   sudo prevents users from accidentally running commands as root that
    do not need root access, because a full root terminal is not
    created. This aligns with the principle of least privilege.
-   Individual programs may be enabled per user, instead of offering
    complete root access just to run one command). For example, to give
    the user alice access to a particular program:

    # visudo

    /etc/sudoers

    alice ALL = NOPASSWD: /path/to/program

Or, individual commands can be allowed for all users. To mount Samba
shares from a server as a regular user:

    %users ALL=/sbin/mount.cifs,/sbin/umount.cifs

This allows all users who are members of the group users to run the
commands /sbin/mount.cifs and /sbin/umount.cifs from any machine (ALL).

Tip:To use nano instead of vi with visudo,

    /etc/sudoers

    Defaults editor=/usr/bin/nano

Exporting # EDITOR=nano visudo is regarded as a severe security risk
since everything can be used as an EDITOR.

Editing files using sudo

Using a text editor like vim as root is a security vulnerability as it
allows one to execute arbitrary shell commands, and does not log the
user who executed the commands. To solve this, add

    EXPORT SUDO_EDITOR=rvim

to your shell's configuration file and use sudoedit filename or
sudo -e filename to edit files. This will automatically edit filename
with rvim, disabling shell commands from within your text editor.

> Restricting root login

Once sudo is properly configured, full root access can be heavily
restricted or denied without losing much usability.

Allow only certain users

The PAM pam_wheel.so lets you allow only users in the group wheel to
login using su. Edit /etc/pam.d/su and uncomment the line:

    # Uncomment the following line to require a user to be in the "wheel" group.
    auth		required	pam_wheel.so use_uid

This means only users who are already able to run privileged commands
may login as root.

Denying console login

Changing the configuration to disallow root to login from the console
makes it harder for an intruder to gain access to the system. The
intruder would have to guess both a user-name that exists on the system
and that users password. When root is allowed to log in via the console,
an intruder only needs to guess a password. Blocking root login at the
console is done by commenting out the tty lines in /etc/securetty.

    /etc/securetty

    #tty1

Repeat for any tty you wish to block. To check the effect of this
change, start by commenting out only one line and go to that particular
console and try to login as root. You will be greeted by the message
Login incorrect. Now that we are sure it works, go back and comment out
the rest of the tty lines.

Note:If you see ttyS0 this is for a serial console. Similarly, on Xen
virtualized systems hvc0 is for the administrator.

Denying ssh login

Even if you do not wish to deny root login for local users, it is always
good practice to deny root login via SSH. The purpose of this is to add
an additional layer of security before a user can completely compromise
your system remotely.

Mandatory access control
------------------------

Mandatory access control (MAC) is a type of security policy that differs
significantly from the discretionary access control (DAC) used by
default in Arch and most Linux distributions. MAC essentially means that
every action a program could perform that affects the system in any way
is checked against a security ruleset. This ruleset, in contrast to DAC
methods, cannot be modified by users. Using virtually any mandatory
access control system will significantly improve the security of your
computer, although there are differences in how it can be implemented.

> Pathname MAC

Pathname-based access control is a simple form of access control that
offers permissions based on the path of a given file. The downside to
this style of access control is that permissions are not carried with
files if they are moved about the system. On the positive side,
pathname-based MAC can be implemented on a much wider range of
filesystems, unlike labels-based alternatives.

-   AppArmor is a Canonical-maintained MAC implementation seen as an
    "easier" alternative to SELinux.
-   Tomoyo is another simple, easy-to-use system offering mandatory
    access control. It is designed to be both simple in usage and in
    implementation, requiring very few dependencies.

> Role-based access control

The MAC implementation grsecurity supports is called role-based access
control. RBAC associates roles with each user. Each role defines what
operations can be performed on certain objects. Given a well-written
collection of roles and operations your users will be restricted to
perform only those tasks that you tell them they can do. The default
"deny-all" ensures you that a user cannot perform an action you have not
thought of.

-   Grsecurity RBAC has a learning mode like AppArmor for easy
    configureation
-   Grsecurity RBAC dose not rely on extra meta-data like SELinux. RBAC
    is significantly faster then SELinux.

> Labels MAC

Labels-based access control means the extended attributes of a file are
used to govern its security permissions. While this system is arguably
more flexible in its security offerings than pathname-based MAC, it only
works on filesystems that support these extended attributes.

-   SELinux, based on a NSA project to improve Linux security,
    implements MAC completely separate from system users and roles. It
    offers an extremely robust multi-level MAC policy implementation
    that can easily maintain control of a system that grows and changes
    past its original configuration.

> Access Control Lists

Access control lists (ACLs) are an alternative to attaching rules
directly to the filesystem in some way. ACLs implement access control by
checking program actions against a list of permitted behavior.

-   grsecurity implements ACL access control, as well as a complete
    kernel patchset focused on improving security. Its changes extend to
    control of memory allocation, improved chroot restrictions, and
    rules involving specific network behavior.

Kernel Hardening
----------------

  ------------------------ ------------------------ ------------------------
  [Tango-two-arrows.png]   This article or section  [Tango-two-arrows.png]
                           is a candidate for       
                           merging with #Mandatory  
                           access control.          
                           Notes: The section       
                           mentions only            
                           Grsecurity, which is     
                           described there.         
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

The Linux Kernel is insecure by default. It allows far more access to
sensitive information then is needed and only provides minimal memory
exploitation protections. Grsecurity aims to fix this. Grsecurity ships
bundled with the PaX memory patches. PaX invented ALSR and provides far
more protections then just that. Grsecurity hardens the file system,
provides an advanced Role Based Access Control system and, and prevents
information leaks which render PaX memory protections useless.

Network and Firewalls
---------------------

> Firewalls

While the stock Arch kernel is capable of using Netfilter's iptables, it
is not enabled by default. It is highly recommended to install iptables
from the official repositories, enable it, and set up some form of
firewall.

-   See iptables for general info.
-   See Simple stateful firewall for a guide on setting up an iptables
    firewall.
-   See Firewalls for other ways of setting up netfilter.

> Kernel parameters

Kernel parameters which affect networking can be set using Sysctl. For
how to do this, see Sysctl#TCP/IP stack hardening.

> SSH

Avoid using Secure Shell without requiring SSH keys. This helps against
brute-force attacks. Alternatively Fail2ban or Sshguard offer lesser
forms of protection by monitoring logs and writing iptables rules.

Denying root login is good practice, both for tracing intrusions and
adding an additional layer of security before root access.

Authenticating packages
-----------------------

Attacks on package managers are possible without proper use of package
signing, and can affect even package managers with proper signature
systems. Arch uses package signing by default and relies on a web of
trust from 5 trusted master keys. See Pacman-key for details.

See also
--------

-   ArchWiki's Current list of security applications: Lists of
    Applications: Security
-   Securing and Hardening Red Hat Linux Production Systems
-   Hardening the linux desktop
-   Hardening the linux server
-   Securing and Optimizing Linux
-   UNIX and Linux Security Checklist v3.0
-   CentOS Wiki: OS Protection
-   Hardening Debian (pdf)

Retrieved from
"https://wiki.archlinux.org/index.php?title=Security&oldid=301835"

Categories:

-   Security
-   File systems
-   Networking

-   This page was last modified on 24 February 2014, at 16:00.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
