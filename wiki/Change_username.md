Change username
===============

Summary

Related

Users and Groups

Changing a username under Arch (or any flavor of Linux) is safe and easy
when done properly. You can also change the associated groupname for the
user if you wish. Following the procedure below will do just this
retaining your UID/GID for the affected user thus not roaching any file
permissions you have setup.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Procedure                                                          |
|     -   1.1 Change A User's Login                                        |
|     -   1.2 Change A User's $HOME                                        |
|     -   1.3 Change A User's $HOME and Move Contents                      |
|     -   1.4 Change Group Name                                            |
|     -   1.5 Manually With /etc/passwd                                    |
|         -   1.5.1 /etc/passwd File Format                                |
|                                                                          |
| -   2 Gotchas                                                            |
+--------------------------------------------------------------------------+

Procedure
---------

Warning:Make certain that you are not logged in as the user whose name
you are about to change! Open a new tty (Ctrl+Alt+F1) and log in as root
or as another user and su to root.

> Change A User's Login

This will change only the user's login name.

    # usermod -l newname oldname

> Change A User's $HOME

This will only change the home directory of username

    # usermod -d /my/new/home username

> Change A User's $HOME and Move Contents

This will move the contents of username's home directory to /my/new/home
and set the user's home directory to the new one.

    # usermod -md /my/new/home username;

> Change Group Name

If you want to change the user's group also:

    # groupmod -n newname oldname

Note:This will change a group name but not the numerical GID of the
group.

For further information see the man pages for usermod and groupmod.

> Manually With /etc/passwd

When possible, you should use the above commands to modify usernames and
home directories, however for those of you who want to know the 'guts'
of the operations, it can be done manually.

/etc/passwd File Format

Each line of the file follows a specific format. There are seven fields,
each delimited by (":") a colon.

    <login name>:<password>:<numerical UID>:<numerical GID>:<Real name/comments>:<home directory>:<user command interpreter>

Warning:It is unsafe to set the <password> field in /etc/passwd.
Passwords should be changed (by root) with the passwd command!

-   <login name> This field can not be blank. Standard *NIX naming rules
    apply.
-   <password> would be an encrypted password, however it should be
    marked with a lowercase "x" (without quotes) to signify the password
    is located in /etc/shadow.
-   Each user and group name has a corresponding numerical UID and GID
    (User ID and Group ID). In Arch, the first login name (after root)
    is UID 1000 by default. Subsequent UID/GID entries for users should
    be greater than 1000. GID should match the primary group for the
    particular user. Numeric values for GIDs are listed in /etc/group.
-   <Real name/comments> is used by services such as finger. This field
    is optional and may be left blank.
-   <home directory> is used by the login command to set the $HOME
    environment variable. Several services with their own users use "/"
    which is safe for services, but not recommended for normal users.
-   <user command interpreter> is the path to the user's default shell.
    This is normally Bash, but there are several other command line
    interpreters available. The default setting is "/bin/bash" (without
    quotes) for users. If you use another CLI, set the path to it here.
    This field is optional.

Example (user):

    jack:x:1001:100:Jack Smith,some comment here,,:/home/jack:/bin/bash

Broken down, this means: user jack (who's password is in /etc/shadow) is
UID 1001 and his primary group is 100 (users). Jack Smith is his full
name and there is a comment associated to his account. His home
directory is /home/jack and he is using Bash.

Gotchas
-------

-   If you are using sudo make sure you update your /etc/sudoers to
    reflect the new username(s) (via the visudo command as root).
-   If you modified your PATH statement in your ~/.bashrc, make sure you
    change it to reflect the new username.
-   Likewise, be sure you change any config file such as /etc/rc.local
    or whatever if you are pointing it to a script or mountpoint, etc.
    within the old user's home directory.
-   Personal crontabs need to be adjusted by renaming the user's file in
    /var/spool/cron from the old to the new name, and then opening
    crontab -e to change any relevant paths and have it adjust the file
    permissions accordingly.
-   Wine's personal folder in ~/.wine/drive_c/users needs to be manually
    renamed.
-   The procedure to enable spell checking in Firefox may need to be
    redone, or else the check-as-you-type spelling might not work after
    renaming the user.
-   Certain Thunderbird addons, like Enigmail, may need to be
    reinstalled.
-   Anything on your system (desktop shortcuts, shell scripts, etc.)
    that uses an absolute path to your home dir (i.e. /home/oldname)
    will need to be changed to reflect your new name. To avoid these
    problems in shell scripts, simply use the ~ or $HOME variables for
    home directories.
-   Also don't forget to edit accordingly the configuration files in
    /etc that relies on your absolute path (i.e. Samba, CUPS, so on). A
    nice way to learn what files you need to update involves using the
    grep command this way: # grep -r {old_user} *

Retrieved from
"https://wiki.archlinux.org/index.php?title=Change_username&oldid=252841"

Category:

-   Security
