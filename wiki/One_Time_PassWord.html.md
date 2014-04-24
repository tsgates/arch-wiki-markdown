One Time PassWord
=================

Related articles

-   Secure Shell
-   S/KEY Authentication
-   Pam abl

One Time PassWord (OTPW) is a PAM module allowing single-use passwords
to login to a system. This is especially useful in the context of Secure
Shell, allowing a user to login from a public or shared computer using a
single-use password which will never work again.

Instructions for installing OTPW and configuring SSH to allow OTPW
logins are below.

Contents
--------

-   1 Installation
-   2 Configuration for SSH Logins
    -   2.1 PAM Configuration
    -   2.2 sshd Configuration
    -   2.3 OTPW Configuration
-   3 Usage

Installation
------------

Install the otpw package from the AUR.

Configuration for SSH Logins
----------------------------

> PAM Configuration

Create a PAM configuration file for otpw:

    /etc/pam.d/ssh-otpw

    auth sufficient pam_otpw.so
    session optional pam_otpw.so

Next, modify sshd's PAM configuration to include otpw. Here is my
/etc/pam.d/sshd for reference:

    /etc/pam.d/sshd

    #%PAM-1.0
    #auth     required  pam_securetty.so     #disable remote root

    auth      include   ssh-otpw
    auth      include   system-remote-login
    account   include   system-remote-login
    password  include   system-remote-login
    session   include   system-remote-login

> sshd Configuration

OTPW uses Keyboard-Interactive logins for SSH sessions, which are
enabled by adding these lines to /etc/ssh/sshd_config:

    UsePAM yes
    UsePrivilegeSeparation yes
    ChallengeResponseAuthentication yes

Note: Make sure not to add redundant or conflicting configuration lines
to /etc/ssh/sshd_config! For instance, make sure there are not two
UsePAM lines, etc.

If you wish to allow static password logins as well, ensure
/etc/ssh/sshd_config contains a line like this:

    PasswordAuthentication yes

Otherwise, set it to no. If you allow password authentication, then
after failing one authentication method, ssh clients will fall back to
the other. Note that by default, ssh allows you three attempts at a
password per login method.

> OTPW Configuration

OTPW is configured independently for each user account. If a given
account does not have OTPW configured, that account will simply use a
static password as usual. To configure OTPW for an account, run as that
user:

    $ otpw-gen > ~/otpw_passwords

otpw-gen will ask for a password prefix, which must be typed at the
beginning of all otpw passwords. This is to ensure that if someone else
gets your OTPW list, they can't use it to login to your account without
knowing your prefix.

After running the above command, there should be a file in the user's
home directory called otpw_passwords which contains all of the user's
OTPW passwords. There will also be a file ~/.otpw which contains the
password hashes. otpw_passwords can be printed and referenced when
logging in.

Usage
-----

After completing the configuration above, ssh should use OTPW
automatically for users who have it configured. An OTPW login prompt
looks like so:

    Password 041: 

To log in, simply look up password 41 in your otpw_passwords list, for
example:

    041 lYr0 g7QR

And type in your prefix followed by both halves of the password. The
space is provided for readability and may or may not be included in the
typed password. Do not enter a space between the prefix and the
single-use password.

To specify to the ssh client which login method you would like to use,
add -o PreferredAuthentication=keyboard-interactive to use OTPW, or
-o PreferredAuthentication=password for static passwords. These options
can also be specified in ~/.ssh/config per-server.

To prevent someone from shoulder-surfing your OTPW and quickly using it
to login to your account before you login, OTPW requires a concurrent
login to enter three passwords instead of just one. This will usually
not be an issue, but if OTPW should give a prompt like this:

    Password 072/251/152: 

Then simply enter your prefix, and the three requested passwords in the
order they are requested in. When a login is initiated, OTPW creates a
file ~/.otpw.lock to detect concurrent logins. If a second login is
initiated when this file exists, OTPW will request the three passwords.

Note:Due to a bug in the way OpenSSH calls PAM, the ~/.otpw.lock file
will not be deleted if the user cancels an SSH login using Ctrl-C or the
like, and OTPW will always ask for triple passwords after this. The bug
is marked as fixed, but it still affects me. As a workaround, one may
simply delete the lock file manually, and OTPW will resume normal
single-password requests.

Retrieved from
"https://wiki.archlinux.org/index.php?title=One_Time_PassWord&oldid=287335"

Category:

-   Secure Shell

-   This page was last modified on 9 December 2013, at 03:23.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
