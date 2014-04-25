Sudo
====

Related articles

-   Users and groups
-   su

sudo ("substitute user do") allows a system administrator to delegate
authority to give certain users (or groups of users) the ability to run
some (or all) commands as root or another user while providing an audit
trail of the commands and their arguments.

Contents
--------

-   1 Rationale
-   2 Installation
-   3 Usage
-   4 Configuration
    -   4.1 View current settings
    -   4.2 Using visudo
    -   4.3 Example Entries
    -   4.4 Sudoers default file permissions
    -   4.5 Password cache timeout
-   5 Tips and tricks
    -   5.1 File example
    -   5.2 Enabling Tab-completion in Bash
    -   5.3 Run X11 apps using sudo
    -   5.4 Disable per-terminal sudo
    -   5.5 Environment variables
    -   5.6 Passing aliases
    -   5.7 Insults
    -   5.8 Root password
    -   5.9 Disable root login
        -   5.9.1 kdesu
        -   5.9.2 PolicyKit
        -   5.9.3 NetworkManager
    -   5.10 Harden with Sudo Example
-   6 Troubleshooting
    -   6.1 SSH TTY Problems
    -   6.2 Display User Privileges
    -   6.3 Permissive Umask
    -   6.4 Defaults Skeleton

Rationale
---------

Sudo is an alternative to su for running commands as root. Unlike su,
which launches a root shell that allows all further commands root
access, sudo instead grants temporary privilege escalation to a single
command. By enabling root privileges only when needed, sudo usage
reduces the likelihood that a typo or a bug in an invoked command will
ruin the system. Sudo can also be used to run commands as other users;
additionally, sudo logs all commands and failed access attempts for
security auditing.

Installation
------------

Install the sudo package, available in the official repositories.

To begin using sudo as a non-privileged user, it must be properly
configured. So make sure you read the configuration section.

Usage
-----

With sudo, users can prefix commands with sudo to run them with
superuser (or other) privileges.

For example, to use pacman:

    $ sudo pacman -Syu

See the sudo manual for more information.

Configuration
-------------

> View current settings

Run sudo -ll to print out the current sudo configuration.

> Using visudo

The configuration file for sudo is /etc/sudoers. It should always be
edited with the visudo command. visudo locks the sudoers file, saves
edits to a temporary file, and checks that file's grammar before copying
it to /etc/sudoers.

Warning:It is imperative that sudoers be free of syntax errors! Any
error makes sudo unusable. Always edit it with visudo to prevent errors.

The default editor for visudo is vi. It will be used if you do not
specify another editor, by setting either VISUAL or EDITOR environment
variables (used in that order) to the desired editor, e.g. nano. The
command is run as root:

    # EDITOR=nano visudo

To change the editor permanently, see Environment variables#Defining
variables locally. To change the editor of choice permanently
system-wide only for visudo, add the following to /etc/sudoers (assuming
nano is your preferred editor):

    # Reset environment by default
    Defaults      env_reset
    # Set default EDITOR to nano, and do not allow visudo to use EDITOR/VISUAL.
    Defaults      editor=/usr/bin/nano, !env_editor

> Example Entries

To allow a user to gain full root privileges when he/she precedes a
command with sudo, add the following line:

    USER_NAME   ALL=(ALL) ALL

To allow a user to run all commands as any user but only the machine
with hostname HOST_NAME:

    USER_NAME   HOST_NAME=(ALL) ALL

To allow members of group wheel sudo access:

    %wheel      ALL=(ALL) ALL

To disable asking for a password for user USER_NAME:

    Defaults:USER_NAME      !authenticate

Enable explicitly defined commands only for user USER_NAME on host
HOST_NAME:

    USER_NAME HOST_NAME=/usr/bin/halt,/usr/bin/poweroff,/usr/bin/reboot,/usr/bin/pacman -Syu

Note: the most customized option should go at the end of the file, as
the later lines overrides the previous ones. In particular such a line
should be after the %wheel line if your user is in this group.

Enable explicitly defined commands only for user USER_NAME on host
HOST_NAME without password:

    USER_NAME HOST_NAME= NOPASSWD: /usr/bin/halt,/usr/bin/poweroff,/usr/bin/reboot,/usr/bin/pacman -Syu

A detailed sudoers example can be found here. Otherwise, see the sudoers
manual for detailed information.

> Sudoers default file permissions

The owner and group for the sudoers file must both be 0. The file
permissions must be set to 0440. These permissions are set by default,
but if you accidentally change them, they should be changed back
immediately or sudo will fail.

    # chown -c root:root /etc/sudoers
    # chmod -c 0440 /etc/sudoers

> Password cache timeout

Users may wish to change the default timeout before the cached password
expires. This is accomplished with the timestamp_timeout option in
/etc/sudoers which is in minutes. Set timeout to 20 minutes.

    Defaults:USER_NAME timestamp_timeout=20

Tip:To ensure sudo always asks for a password, set the timeout to 0. To
ensure the password never times out, set to less than 0.

Tips and tricks
---------------

> File example

This example is especially helpful for those using terminal multiplexers
like screen, tmux, or ratpoison, and those using sudo from
scripts/cronjobs:

    /etc/sudoers

    Cmnd_Alias WHEELER = /usr/bin/lsof, /bin/nice, /bin/ps, /usr/bin/top, /usr/local/bin/nano, /usr/bin/ss, /usr/bin/locate, /usr/bin/find, /usr/bin/rsync
    Cmnd_Alias PROCESSES = /bin/nice, /bin/kill, /usr/bin/nice, /usr/bin/ionice, /usr/bin/top, /usr/bin/kill, /usr/bin/killall, /usr/bin/ps, /usr/bin/pkill
    Cmnd_Alias EDITS = /usr/bin/vim, /usr/bin/nano, /usr/bin/cat, /usr/bin/vi
    Cmnd_Alias ARCHLINUX = /usr/bin/gparted, /usr/bin/pacman

    root ALL = (ALL) ALL
    USER_NAME ALL = (ALL) ALL, NOPASSWD: WHEELER, NOPASSWD: PROCESSES, NOPASSWD: ARCHLINUX, NOPASSWD: EDITS
     
    Defaults !requiretty, !tty_tickets, !umask
    Defaults visiblepw, path_info, insults, lecture=always
    Defaults loglinelen = 0, logfile =/var/log/sudo.log, log_year, log_host, syslog=auth
    Defaults mailto=webmaster@foobar.com, mail_badpass, mail_no_user, mail_no_perms
    Defaults passwd_tries = 8, passwd_timeout = 1
    Defaults env_reset, always_set_home, set_home, set_logname
    Defaults !env_editor, editor="/usr/bin/vim:/usr/bin/vi:/usr/bin/nano"
    Defaults timestamp_timeout=360
    Defaults passprompt="Sudo invoked by [%u] on [%H] - Cmd run as %U - Password for user %p:"

> Enabling Tab-completion in Bash

See Bash#Tab completion for details.

> Run X11 apps using sudo

To allow sudo to start graphical application in X11:

    /etc/sudoers

    Defaults env_keep += "HOME"

> Disable per-terminal sudo

Warning:This will let any process use your sudo session.

If you are annoyed by sudo's defaults that require you to enter your
password every time you open a new terminal, disable tty_tickets:

    Defaults !tty_tickets

> Environment variables

If you have a lot of environment variables, or you export your proxy
settings via export http_proxy="...", when using sudo these variables do
not get passed to the root account unless you run sudo with the -E
option.

    $ sudo -E pacman -Syu

The recommended way of preserving environment variables is to append
them to env_keep:

    /etc/sudoers

    Defaults env_keep += "ftp_proxy http_proxy https_proxy no_proxy"

> Passing aliases

If you use a lot of aliases, you might have noticed that they do not
carry over to the root account when using sudo. However, there is an
easy way to make them work. Simply add the following to your ~/.bashrc
or /etc/bash.bashrc:

    alias sudo='sudo '

> Insults

Users can configure sudo to display clever insults when an incorrect
password is entered instead of printing the default "wrong password"
message. Find the Defaults line in /etc/sudoers and append "insults"
after a comma to existing options. The final result might look like
this:

    #Defaults specification
    Defaults insults

To test, type sudo -K to end the current session and let sudo ask for
the password again.

> Root password

Warning:This is not intended usage of sudo. You are exposing your root
password to a number of users. You are also removing the capability of
securing your server by removing the password from root.

Users can configure sudo to ask for the root password instead of the
user password by adding "rootpw" to the Defaults line in /etc/sudoers:

    Defaults timestamp_timeout=0,rootpw

> Disable root login

Warning:Arch Linux is not fine-tuned to run with a disabled root
account. Users may encounter problems with this method.

With sudo installed and configured, users may wish to disable the root
login. Without root, attackers must first guess a user name configured
as a sudoer as well as the user password.

Warning:Ensure a user is properly configured as a sudoer before
disabling the root account!

The account can be locked via passwd:

    # passwd -l root

A similar command unlocks root.

    $ sudo passwd -u root

Alternatively, edit /etc/shadow and replace the root's encrypted
password with "!":

    root:!:12345::::::

To enable root login again:

    $ sudo passwd root

kdesu

kdesu may be used under KDE to launch GUI applications with root
privileges. It is possible that by default kdesu will try to use su even
if the root account is disabled. Fortunately one can tell kdesu to use
sudo instead of su. Create/edit the file ~/.kde4/share/config/kdesurc:

    [super-user-command]
    super-user-command=sudo

PolicyKit

When disabling the root account, it is necessary to change the PolicyKit
configuration for local authorization to reflect that. The default is to
ask for the root password, so that must be changed. With polkit-1, this
can be achieved by editing
/etc/polkit-1/localauthority.conf.d/50-localauthority.conf so that
AdminIdentities=unix-user:0 is replaced with something else, depending
on the system configuration. It can be a list of users and groups, for
example:

    AdminIdentities=unix-group:wheel

or

    AdminIdentities=unix-user:me;unixuser:mom;unix-group:wheel

For more information, see man pklocalauthority.

NetworkManager

Even with the above PolicyKit configuration you still need to configure
a policy for NetworkManager. This is documented on the NetworkManager
page of this wiki.

> Harden with Sudo Example

Lets say you create 3 users: admin, devel, and joe. The user "admin" is
used for journalctl, systemctl, mount, kill, and iptables; "devel" is
used for installing packages, and editing config's; and "joe" is the
user you log in with. To let "joe" reboot, shutdown, and use netctl we
would do the following:

Edit /etc/pam.d/su and /etc/pam.d/su-1 Require user be in the wheel
group, but do not put anyone in it.

    #%PAM-1.0
    auth            sufficient      pam_rootok.so
    # Uncomment the following line to implicitly trust users in the "wheel" group.
    #auth           sufficient      pam_wheel.so trust use_uid
    # Uncomment the following line to require a user to be in the "wheel" group.
    auth            required        pam_wheel.so use_uid
    auth            required        pam_unix.so
    account         required        pam_unix.so
    session         required        pam_unix.so

Limit SSH login to the 'ssh' group. Only put "joe" will be part of this
group.

    groupadd -r ssh
    gpasswd -a joe ssh
    echo 'AllowGroups ssh' >> /etc/ssh/sshd_config
    systemctl restart sshd.service

Add users to other groups.

    for g in power network ;do ;gpasswd -a joe $g ;done
    for g in network power storage ;do ;gpasswd -a admin $g ;done

Set permissions on configs so devel can edit them.

    chown -R devel:root /etc/{http,openvpn,cups,zsh,vim,screenrc}

    Cmnd_Alias  POWER       =   /usr/bin/shutdown -h now, /usr/bin/halt, /usr/bin/poweroff, /usr/bin/reboot
    Cmnd_Alias  STORAGE     =   /usr/bin/mount, /usr/bin/umount
    Cmnd_Alias  SYSTEMD     =   /usr/bin/journalctl, /usr/bin/systemctl
    Cmnd_Alias  KILL        =   /usr/bin/kill, /usr/bin/killall
    Cmnd_Alias  PKGMAN      =   /usr/bin/pacman
    Cmnd_Alias  NETWORK     =   /usr/bin/netctl
    Cmnd_Alias  FIREWALL    =   /usr/bin/iptables, /usr/bin/ip6tables
    Cmnd_Alias  SHELL       =   /usr/bin/zsh, /usr/bin/bash
    %power      ALL         =   (root)  NOPASSWD: POWER
    %network    ALL         =   (root)  NETWORK
    %storage    ALL         =   (root)  STORAGE
    root        ALL         =   (ALL)   ALL
    admin       ALL         =   (root)  SYSTEMD, KILL, FIREWALL
    devel	    ALL         =   (root)  PKGMAN
    Joe	    ALL         =   (devel) SHELL, (admin) SHELL 

With this setup, you will almost never need to login as the Root user.

"Joe" can connect to his home WiFi.

    sudo netctl start home
    sudo poweroff

"Joe" can not use netctl as any other user.

    sudo -u admin -- netctl start home

When "joe" needs to use journalctl or kill run away process he can
switch to that user

    sudo -i -u devel
    sudo -i -u admin

But "joe" cannot switch to the root user.

    sudo -i -u root

If "joe" want to start a gnu-screen session as admin he can do it like
this:

    sudo -i -u admin
    admin% chown admin:tty `echo $TTY`
    admin% screen

Troubleshooting
---------------

> SSH TTY Problems

SSH does not allocate a tty by default when running a remote command.
Without a tty, sudo cannot disable echo when prompting for a password.
You can use ssh's -tt option to force it to allocate a tty (or -t
twice).

The Defaults option requiretty only allows the user to run sudo if they
have a tty.

    # Disable "ssh hostname sudo <cmd>", because it will show the password in clear text. You have to run "ssh -t hostname sudo <cmd>".
    #
    #Defaults    requiretty

> Display User Privileges

You can find out what privileges a particular user has with the
following command:

    $ sudo -lU yourusename

Or view your own with:

    $ sudo -l

    Matching Defaults entries for yourusename on this host:
        loglinelen=0, logfile=/var/log/sudo.log, log_year, syslog=auth, mailto=webmaster@gmail.com, mail_badpass, mail_no_user,
        mail_no_perms,env_reset, always_set_home, tty_tickets, lecture=always, pwfeedback, rootpw, set_home

    User yourusename may run the following commands on this host:

        (ALL) ALL
        (ALL) NOPASSWD: /usr/bin/lsof, /bin/nice, /usr/bin/su, /usr/bin/locate, /usr/bin/find, /usr/bin/rsync, /usr/bin/strace,
        (ALL) /bin/kill, /usr/bin/nice, /usr/bin/ionice, /usr/bin/top, /usr/bin/killall, /usr/bin/ps, /usr/bin/pkill
        (ALL) /usr/bin/gparted, /usr/bin/pacman
        (ALL) /usr/local/bin/synergyc, /usr/local/bin/synergys
        (ALL) /usr/bin/vim, /usr/bin/nano, /usr/bin/cat
        (root) NOPASSWD: /usr/local/bin/synergyc

> Permissive Umask

Sudo will union the user's umask value with its own umask (which
defaults to 0022). This prevents sudo from creating files with more open
permissions than the user's umask allows. While this is a sane default
if no custom umask is in use, this can lead to situations where a
utility run by sudo may create files with different permissions than if
run by root directly. If errors arise from this, sudo provides a means
to fix the umask, even if the desired umask is more permissive than the
umask that the user has specified. Adding this (using visudo) will
override sudo's default behavior:

    Defaults umask = 0022
    Defaults umask_override

This sets sudo's umask to root's default umask (0022) and overrides the
default behavior, always using the indicated umask regardless of what
umask the user as set.

> Defaults Skeleton

The authors site has a list of all the options that can be used with the
Defaults command in the /etc/sudoers file.

The full list of options (parsed from the version 1.8.7 source code) is
below in a format optimized for copying and pasting into your sudoers
files for quick editing.

    #Defaults always_set_home
    #  If enabled, sudo will set the HOME environment variable to the home directory of the target user
    #  (which is root unless the -u option is used).  This effectively means that the -H option
    #  always_set_home is only effective for configurations where either env_reset is disabled or HOME is present
    #  in the env_keep list.  Default: OFF

    #Defaults authenticate
    #  If set, users must authenticate themselves via a password (or other means of authentication)
    #  before they may run commands.  This default may be overridden via the PASSWD and NOPASSWD

    #Defaults closefrom_override
    #  If set, the user may use sudo's -C option which overrides the default starting
    #  point at which sudo begins closing open file descriptors.  Default: OFF

    #Defaults compress_io
    #  If set, and sudo is configured to log a command's input or output, the I/O logs will be
    #  compressed using zlib.  This flag is on by default when sudo is compiled with zlib support.

    #Defaults env_editor
    #  If set, visudo will use the value of the EDITOR or VISUAL environment variables before falling back on the default
    #  editor list.  Note that this may create a security hole as it allows th separated list of editors in the editor
    #  variable.  visudo will then only use the EDITOR or VISUAL if they match a value specified in editor.  On by default.

    #Defaults env_reset
    #  If set, sudo will run the command in a minimal environment containing the TERM, PATH, HOME, MAIL, SHELL, LOGNAME,
    #  USER, USERNAME and SUDO_* variables.  Any variables in the caller's env in the file specified by the env_file
    #  option (if any).  The default contents of the env_keep and env_check lists are displayed when sudo is run by
    #  root with the -V option.

    #Defaults fast_glob
    #  Normally, sudo uses the glob(3) function to do shell-style globbing when matching path names.
    #  However, since it accesses the file system, glob(3) can take a long time to complete for som (automounted).
    #  The fast_glob option causes sudo to use the fnmatch(3) function, which does not access the file system to do
    #  its matching.  The disadvantage of fast_glob is that it is unable to ma names that include globbing characters
    #  are used with the negation operator, '!', as such rules can be trivially bypassed.  As such, this option should
    #  not be used when sudoers contains rules that

    #Defaults fqdn
    #  Set this flag if you want to put fully qualified host names in the sudoers file.  I.e., instead of myhost you
    #  would use myhost.mydomain.edu.  You may still use the short form if you wish (and sudo unusable if DNS stops
    #  working (for example if the machine is not plugged into the network).  Also note that you must use the
    #  host's official name as DNS knows it.  That is, you may not use a all aliases from DNS.  If your machine's
    #  host name (as returned by the hostname command) is already fully qualified you should not need to set fqdn.
    #  Default: OFF

    #Defaults ignore_dot
    #  If set, sudo will ignore '.' or '' (current dir) in the PATH environment variable; the PATH
    #  itself is not modified.  Default: OFF

    #Defaults ignore_local_sudoers
    #  If set via LDAP, parsing of /etc/sudoers will be skipped.  This is intended for Enterprises that wish to prevent
    #  the usage of local sudoers files so that only LDAP is used.  /etc/sudoers does not even need to exist.
    #  Since this option tells sudo how to behave when no specific LDAP entries have been matched, this sudo
    #  Option is only meaningful for the cn=default

    #Defaults insults
    #  If set, sudo will insult users when they enter an incorrect password.  Default: OFF

    #Defaults log_host
    #  If set, the host name will be logged in the (non-syslog) sudo log file.  Default: OFF

    #Defaults log_input
    #  If set, sudo will run the command in a pseudo tty and log all user input.  If the standard
    #  input is not connected to the user's tty, due to I/O redirection or because the command is part Input is logged
    #  to the directory specified by the iolog_dir option (/var/log/sudo-io by default) using a unique session ID that
    #  is included in the normal sudo log line, prefixed with TSID=.  Note that user input may contain sensitive
    #  information such as passwords (even if they are not echoed to the screen), which will be stored in the log file
    #  unencrypted.

    #Defaults log_output
    #  If set, sudo will run the command in a pseudo tty and log all output that is sent to the
    #  screen, similar to the script(1) command.  If the standard output or standard error is not connec is also captured and
    #  stored in separate log files. Output is logged to the directory specified by the iolog_dir option (/var/log/sudo-io
    #  by default) using a unique session ID that is included in the normal sudo log line, prefixed with TSID=.  The Output
    #  logs may be viewed with the sudoreplay(8) utility, which can also be used to list or search the available logs.

    #Defaults log_year
    #  If set, the four-digit year will be logged in the (non-syslog) sudo log file.  Default: OFF

    #Defaults long_otp_prompt
    #  When validating with a One Time Password (OTP) scheme such as S/Key or OPIE, a two-line
    #  prompt is used to make it easier to cut and paste the challenge to a local window

    #Defaults mail_always
    #  Send mail to the mailto user every time a users runs sudo.  Default: OFF

    #Defaults mail_badpass
    #  Send mail to the mailto user if the user running sudo does not enter the correct password.
    #  Default: OFF

    #Defaults mail_no_host
    #  If set, mail will be sent to the mailto user if the invoking user exists in the sudoers
    #  file, but is not allowed to run commands on the current host.  Default: OFF

    #Defaults mail_no_perms
    #  If set, mail will be sent to the mailto user if the invoking user is allowed to use sudo
    #  but the command they are trying is not listed in their sudoers file entry or is explicitly denied

    #Defaults mail_no_user
    #  If set, mail will be sent to the mailto user if the invoking user is not in the sudoers file.
    #  Default: ON

    #Defaults noexec
    #  If set, all commands run via sudo will behave as if the NOEXEC tag has been set, unless overridden
    #  by a EXEC tag.  See the description of NOEXEC and EXEC below as well as the "PREVENTING SHE

    #Defaults path_info
    #  Normally, sudo will tell the user when a command could not be found in their PATH environment
    #  variable.  Some sites may wish to disable this as it could be used to gather information on t the executable is
    #  simply not in the user's PATH, sudo will tell the user that they are not allowed to run it, which can be confusing.
    #  Default: ON

    #Defaults passprompt_override
    #  The password prompt specified by passprompt will normally only be used if the password prompt provided by
    #  systems such as PAM matches the string "Password:"

    #Defaults preserve_groups
    #  By default, sudo will initialize the group vector to the list of groups the target
    #  user is in.  When preserve_groups is set, the user's existing group vector is left unaltered.

    #Defaults pwfeedback
    #  By default, sudo reads the password like most other Unix programs, by turning off echo
    #  until the user hits the return (or enter) key.  Some users become confused by this as it appears to the user
    #  presses a key.  Note that this does have a security impact as an onlooker may be able to determine the length of
    #  the password being entered.  Default: OFF

    #Defaults requiretty
    #  If set, sudo will only run when the user is logged in to a real tty.  When this flag is set,
    #  sudo can only be run from a login session and not via other means such as cron(8) or cgi-bin

    #Defaults root_sudo
    #  If set, root is allowed to run sudo too.  Disabling this prevents users from "chaining" sudo
    #  commands to get a root shell by doing something like "sudo sudo /bin/sh".  Note, however, that real additional
    #  security; it exists purely for historical reasons.  Default: ON

    #Defaults rootpw
    #  If set, sudo will prompt for the root password instead of the password of the invoking user.
    #  Default: OFF

    #Defaults runaspw
    #  If set, sudo will prompt for the password of the user defined by the runas_default option
    #  (defaults to root) instead of the password of the invoking user.  Default: OFF

    #Defaults set_home
    #  If enabled and sudo is invoked with the -s option the HOME environment variable will be set
    #  to the home directory of the target user (which is root unless the -u option is used).  So set_home is only
    #  effective for configs where either env_reset is disabled or HOME is present in the env_keep list.  Default: OFF

    #Defaults set_logname
    #  Normally, sudo will set the LOGNAME, USER and USERNAME environment variables to the name
    #  of the target user (usually root unless the -u option is given).  However, since some programs ( may be desirable
    #  to change this behavior.  This can be done by negating the set_logname option.  Note that if the env_reset option
    #  has not been disabled, entries in the env_keep list will override

    #Defaults set_utmp
    #  When enabled, sudo will create an entry in the utmp (or utmpx) file when a pseudo-tty is
    #  allocated.  A pseudo-tty is allocated by sudo when the log_input, log_output or use_pty flags are e the tty, time,
    #  type and pid fields updated.  Default: ON

    #Defaults setenv
    #  Allow the user to disable the env_reset option from the command line via the -E option.
    #  Additionally, environment variables set via the command line are not subject to the restrictions impo variables
    #  in this manner.  Default: OFF

    #Defaults shell_noargs
    #  If set and sudo is invoked with no arguments it acts as if the -s option had been given.
    #  That is, it runs a shell as root (the shell is determined by the SHELL environment variable if is off by default.

    #Defaults stay_setuid
    #  Normally, when sudo executes a command the real and effective UIDs are set to the target
    #  user (root by default).  This option changes that behaviour such that the real UID is left as the systems that
    #  disable some potentially dangerous functionality when a program is run setuid.  This option is only effective on
    #  systems with either the setreuid() or setresuid() function.  This flag

    #Defaults targetpw
    #  If set, sudo will prompt for the password of the user specified by the -u option (defaults to root) instead
    #  of the password of the invoking user.  In addition, the timestamp file name will passwd database as an argument
    #  to the -u option.  Default: OFF

    #Defaults tty_tickets
    #  If set, users must authenticate on a per-tty basis.  With this flag enabled, sudo will
    #  use a file named for the tty the user is logged in on in the user's time stamp directory.

    #Defaults umask_override
    #  If set, sudo will set the umask as specified by sudoers without modification.  This makes
    #  it possible to specify a more permissive umask in sudoers than the user's own umask and match user's umask and what
    #  is specified in sudoers.  Default: OFF

    #Defaults use_pty
    #  If set, sudo will run the command in a pseudo-pty even if no I/O logging is being gone.
    #  A malicious program run under sudo could conceivably fork a background process that retains to the u that impossible.
    #  Default: OFF

    #Defaults utmp_runas
    #  If set, sudo will store the name of the runas user when updating the utmp (or utmpx) file.
    #  By default, sudo stores the name of the invoking user.  Default: OFF

    #Defaults visiblepw
    #  By default, sudo will refuse to run if the user must enter a password but it is not possible to disable echo on the 
    #  terminal. If the visiblepw flag is set, sudo will prompt for a password even when it would be visible on the screen. 
    #  This makes it possible to run things like "rsh somehost sudo ls" since rsh(1) does not allocate a tty. Default: OFF

    #Defaults closefrom
    #  Before it executes a command, sudo will close all open file descriptors other than standard
    #  input, standard output and standard error (ie: file descriptors 0-2).

    #Defaults passwd_tries
    #  The number of tries a user gets to enter his/her password before sudo logs the failure
    #  and exits.  The default is 3.

    #Defaults loglinelen
    #  Number of characters per line for the file log.  This value is used to decide when to wrap
    #  lines for nicer log files.  This has no effect on the syslog log file, only the file log.

    #Defaults passwd_timeout
    #  Number of minutes before the sudo password prompt times out, or 0 for no timeout.
    #  The timeout may include a fractional component if minute granularity is insufficient, for example 2

    #Defaults timestamp_timeout
    #  Number of minutes that can elapse before sudo will ask for a passwd again.  The timeout
    #  may include a fractional component if minute granularity is insufficient, for example 2.5. timestamp will never expire.
    #  This can be used to allow users to create or delete their own timestamps via sudo -v and sudo -k respectively.

    #Defaults umask
    #  Umask to use when running the command.  Negate this option or set it to 0777 to preserve
    #  the user's umask.  The actual umask that is used will be the union of the user's umask and the value o running
    #  a command.  Note on systems that use PAM, the default PAM configuration may specify its own umask which will
    #  override the value set in sudoers.

    #Defaults badpass_message
    #  Message that is displayed if a user enters an incorrect password.  The default is Sorry,
    #  try again. unless insults are enabled.

    #Defaults editor
    #  A colon (':') separated list of editors allowed to be used with visudo.  visudo will choose
    #  the editor that matches the user's EDITOR environment variable if possible, or the first editor in

    #Defaults iolog_dir
    #  The top-level directory to use when constructing the path name for the input/output log
    #  directory.  Only used if the log_input or log_output options are enabled or when the LOG_INPUT or L directory.
    #  The default is "/var/log/sudo-io". The following percent (%) escape sequences are supported:
    #    %{seq}         - expanded to base-36 sequence number, such as 0100A5, to form a new directory, e.g. 01/00/A5
    #    %{user}        - expanded to the invoking user's login name
    #    %{group}       - expanded to the name of the invoking user's real group ID
    #    %{runas_user}  - expanded to the login name of the user the command will be run as (e.g. root)
    #    %{runas_group} - expanded to the group name of the user the command will be run as (e.g. wheel)
    #    %{hostname}    - expanded to the local host name without the domain name
    #    %{command}     - expanded to the base name of the command being run In addition, any escape sequences supported by
    #                     strftime() function will be expanded. To include a literal % character, the string %% should be used.

    #Defaults iolog_file
    #  The path name, relative to iolog_dir, in which to store input/output logs when the log_input or log_output options are
    #  enabled or when the LOG_INPUT or LOG_OUTPUT tags are present for a See the iolog_dir option above for a list of
    #  supported percent (%) escape sequences. In addition to the escape sequences, path names that end in six or more Xs will
    #  have the Xs replaced with a unique combination of digits and letters, similar to the mktemp() function.

    #Defaults mailsub
    #  Subject of the mail sent to the mailto user. The escape %h will expand to the host name of
    #  the machine.  Default is *** SECURITY information for %h ***.

    #Defaults noexec_file
    #  This option is no longer supported.  The path to the noexec file should now be set in the /etc/sudo.conf file.

    #Defaults passprompt
    #  The default prompt to use when asking for a password; can be overridden via the -p option or the SUDO_PROMPT
    #  environment variable.  The following percent (%) escape sequences are supported:
    #    %H - expanded to the local host name including the domain (only if the host name is fqdn or fqdn option is set)
    #    %h - expanded to the local host name without the domain name
    #    %p - expanded to the user whose password is being asked for (respects the rootpw, targetpw and runaspw flags)
    #    %U - expanded to the login name of the user the command will be run as (defaults to root)
    #    %u - expanded to the invoking user's login name
    #    %% - two consecutive % characters are collapsed into a single % character
    #  The default value is Password:.

    #Defaults runas_default
    #  The default user to run commands as if the -u option is not specified on the command line. This defaults to root.

    #Defaults syslog_badpri
    #  Syslog priority to use when user authenticates unsuccessfully.  Defaults to alert.
    #  alert, crit, debug, emerg, err, info, notice, and warning.

    #Defaults syslog_goodpri
    #  Syslog priority to use when user authenticates successfully.  Defaults to notice. See syslog_badpri for the priorities.

    #Defaults sudoers_locale
    #  Locale to use when parsing the sudoers file, logging commands, and sending email.
    #  Note that changing the locale may affect how sudoers is interpreted.  Defaults to "C".

    #Defaults timestampdir
    #  The directory in which sudo stores its timestamp files.  The default is /var/db/sudo.

    #Defaults timestampowner
    #  The owner of the timestamp directory and the timestamps stored therein.  The default is root.

    #Defaults env_file
    #  The env_file option specifies the fully qualified path to a file containing variables to
    #  be set in the environment of the program being run.  Entries in this file should either be of the f quotes.
    #  Variables in this file are subject to other sudo environment settings such as env_keep and env_check.

    #Defaults exempt_group
    #  Users in this group are exempt from password and PATH requirements.  The group name specified should not include
    #  a % prefix.  This is not set by default.

    #Defaults group_plugin
    #  A string containing a sudoers group plugin with optional arguments.  This can be used to implement support for the
    #  nonunix_group syntax described earlier.  The string should consist of configuration arguments the plugin requires.
    #  These arguments (if any) will be passed to the plugin's initialization function. If arguments are present, the
    #  string must be enclosed in double quote For example, given /etc/sudo-group, a group file in Unix group format,
    #  the sample group plugin can be used: Defaults group_plugin="sample_group.so /etc/sudo-group"
    #  For more information see sudo_plugin(5).

    #Defaults lecture
    #  This option controls when a short lecture will be printed along with the password prompt.  The default value is once.
    #  It has the following possible values:
    #    always - Always lecture the user.
    #    never  - Never lecture the user.
    #    once   - Only lecture the user the first time they run sudo.
    #  If no value is specified, a value of once is implied.  Negating the option results in a value of never being used.

    #Defaults lecture_file
    #  Path to a file containing an alternate sudo lecture that will be used in place of the standard lecture if the named
    #  file exists.  By default, sudo uses a built-in lecture.

    #Defaults listpw
    #  This option controls when a password will be required when a user runs sudo with the -l option.
    #  It has the following possible values:
    #    all    - All the user's sudoers entries for the current host must have the NOPASSWD set to avoid entering a pass.
    #    always - The user must always enter a password to use the -l option.
    #    any    - At least one of the user's sudoers entries for the current host must have the NOPASSWD set to avoid pass.
    #    never  - The user need never enter a password to use the -l option.
    #  If no value is specified, a value of any is implied.  The default value is any.

    #Defaults logfile
    #  Path to the sudo log file (not the syslog log file).  Setting a path turns on logging to a file;
    #  negating this option turns it off.  By default, sudo logs via syslog.

    #Defaults mailerflags
    #  Flags to use when invoking mailer. Defaults to -t.

    #Defaults mailerpath
    #  Path to mail program used to send warning mail.  Defaults to the path to sendmail found at configure time.

    #Defaults mailfrom
    #  Address to use for the "from" address when sending warning and error mail.  The address should
    #  be enclosed in double quotes (") to protect against sudo interpreting the @ sign.

    #Defaults mailto
    #  Address to send warning and error mail to.  The address should be enclosed in double quotes
    #  (") to protect against sudo interpreting the @ sign.  Defaults to root.

    #Defaults secure_path
    #  Path used for every command run from sudo.  If you do not trust the people running sudo to have a sane PATH environment
    #  variable you may want to use this.  Another use is if you want to option are not affected by secure_path.
    #  This option is not set by default.

    #Defaults syslog
    #  Syslog facility if syslog is being used for logging (negate to disable syslog logging). Defaults to auth.
    #  authpriv (if OS supports it), auth, daemon, user, local0, local1, local2, local3, local4, local5, local6, and local7.

    #Defaults verifypw
    #  This option controls when a password will be required when a user runs sudo with the -v option.
    #  It has the following possible values:
    #    all    - All the user's sudoers entries for the current host must have the NOPASSWD flag to avoid pw.
    #    always - The user must always enter a password to use the -v option.
    #    any    - At least one of the user's sudoers entries for the current host must have NOPASSWD to avoid pw.
    #    never  - The user need never enter a password to use the -v option
    #  If no value is specified, a value of all is implied.  Negating the option results in a value of never being used.
    #  The default value is all.

    #Defaults env_check
    #  Environment variables to be removed from the user's environment if the variable's value contains % or / characters.
    #  This can be used to guard against printf-style format vulnerabilities value without double-quotes.  The list can be
    #  replaced, added to, deleted from, or disabled by using the =, +=, -=, and ! operators respectively.  Regardless of
    #  whether the env_reset option is ena they pass the aforementioned check. The default list of environment variables
    #  to check is displayed when sudo is run by root with the -V option.

    #Defaults env_delete
    #  Environment variables to be removed from the user's environment when the env_reset option is not in effect.  The
    #  argument may be a double-quoted, space-separated list or a single value w +=, -=, and ! operators respectively.
    #  The default list of environment variables to remove is displayed when sudo is run by root with the -V option.

    #Defaults env_keep
    #  Environment variables to be preserved in the user's environment when the env_reset option is in effect.  This
    #  allows fine-grained control over the environment sudo-spawned processes will r quotes.  The list can be replaced,
    #  added to, deleted from, or disabled by using the =, +=, -=, and ! operators respectively.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Sudo&oldid=305230"

Category:

-   Security

-   This page was last modified on 16 March 2014, at 22:16.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
