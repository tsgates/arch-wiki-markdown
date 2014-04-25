SFTP chroot
===========

OpenSSH 4.9+ includes a built-in chroot for sftp, but requires a few
tweaks to the normal install.

Contents
--------

-   1 Installation
-   2 Configuration
    -   2.1 Adding new chrooted users
-   3 Logging
-   4 Testing your chroot
-   5 Troubleshooting
-   6 Write access to chroot dir
-   7 Links & References

Installation
------------

This package is available in the core repository. To install it, run

    # pacman -S openssh

Configuration
-------------

In /etc/ssh/sshd_config, modify the Subsystem line for sftp:

     Subsystem       sftp    internal-sftp

  ------------------------ ------------------------ ------------------------
  [Tango-emblem-important. The factual accuracy of  [Tango-emblem-important.
  png]                     this article or section  png]
                           is disputed.             
                           Reason: sshd_config(5)   
                           says: "ChrootDirectory   
                           ... All components of    
                           the pathname must be     
                           root-owned directories   
                           that are not writable by 
                           any other user or group. 
                           ..." (Discuss)           
  ------------------------ ------------------------ ------------------------

At the end of the file, add something similar to the following for a
group:

     Match Group sftpusers
       ChrootDirectory /home/%u
       ForceCommand internal-sftp
       AllowTcpForwarding no
       X11Forwarding no

Or for a user:

     Match User username
       ChrootDirectory /home/%u
       ForceCommand internal-sftp

The /home represents root of the users home directory.

Fixing path for authorized_keys

With the standard-path of AuthorizedKeysFile the Pubkey-Authorization
will fail on chrooted-users, to fix this we have to add an '%h' to the
path.

     AuthorizedKeysFile      %h/.ssh/authorized_keys

Restart sshd:

    # systemctl restart sshd.service

> Adding new chrooted users

If using the group method above, ensure all sftp users are put in the
appropriate group, i.e.:

     usermod -g sftpusers

Also, set their shell to /sbin/nologin to prevent a normal ssh login:

     usermod -s /sbin/nologin

You also need to add /sbin/nologin to /etc/shells, or the sftp-users
won't be able to login.

Warning:Some daemon users erroneously specify 'nologin' as their shell
as one way of ensuring that these users cannot log-in. If 'nologin' is
added as a valid shell, users should make sure that these daemon user
accounts are sufficiently locked. Alternatively, the affected user
accounts can be changed to use /usr/bin/false as shell to ensure that
the selected shell is considered invalid by PAM

Note that since this is only for sftp, a proper chroot environment with
a shell and /dev/* doesn't need to be created.

Their chroot will be the same as their home directory. The permissions
are not the same as a normal home, though. Their home directory must be
owned as root and not writable by another user or group. This includes
the path leading to the directory. My recommendation is to use
/usr/local/chroot as a root and build the home directories under that.

Logging
-------

> 1)

The user will not be able to access /dev/log. This can be seen by
running strace on the process once the user connects and attempts to
download a file. Create the sub-directory dev in the ChrootDirectory,
for example:

     sudo mkdir /usr/local/chroot/theuser/dev
     sudo chmod 755 /usr/local/chroot/theuser/dev

syslog-ng will create the device /usr/local/chroot/theuser/dev/log once
configured.

> 2)

Add to /etc/syslog-ng/syslog-ng.conf a new source for the log and add
the configuration, for example change the section:

    source src {
      unix-dgram("/dev/log");
      internal();
      file("/proc/kmsg");
    };

to:

    source src {
      unix-dgram("/dev/log");
      internal();
      file("/proc/kmsg");
      unix-dgram("/usr/local/chroot/theuser/dev/log");
    };

and append:

    #sftp configuration
    destination sftp { file("/var/log/sftp.log"); };
    filter f_sftp { program("internal-sftp"); };
    log { source(src); filter(f_sftp); destination(sftp); };

(Optional) If you'd like to similarly log SSH messages to it's own file:

    #sshd configuration
    destination ssh { file("/var/log/ssh.log"); };
    filter f_ssh { program("sshd"); };
    log { source(src); filter(f_ssh); destination(ssh); };

(From Syslog-ng#Move_log_to_another_file)

> 3)

Edit /etc/ssh/sshd_config to replace all instances of internal-sftp with
internal-sftp -f AUTH -l VERBOSE

> 4)

Restart logging and SSH:

     systemctl restart syslog-ng.service
     systemctl restart sshd.service

/usr/local/chroot/theuser/dev/log should now exist.

Testing your chroot
-------------------

    # ssh username@localhost

should refuse the connection or fail on login. The response varies,
possibly due to the version of OpenSSH used.

    # sftp username@localhost

should place you in the chroot'd environment.

Troubleshooting
---------------

Error while trying to connect

    Write failed: Broken pipe                                                                                               
    Couldn't read packet: Connection reset by peer

If you also find similar message in /var/log/auth.log

    sshd[12399]: fatal: bad ownership or modes for chroot directory component "/path/of/chroot/directory/"  

This is a ChrootDirectory ownership problem. sshd will reject SFTP
connections to accounts that are set to chroot into any directory that
has ownership/permissions that sshd considers insecure. sshd's strict
ownership/permissions requirements dictate that every directory in the
chroot path must be owned by root and only writable by the owner. So,
for example, if the chroot environment is /home must be owned by root.
See below for possible alternatives.

The reason for this is to prevent a user from escalating their
privileges and becoming root, escaping the chroot environment.

If chroot environment is in user's home directory, make sure user have
access to it's home directory, or user would not be able to access it's
publickey, produce following error

    Permission denied (publickey).

Write access to chroot dir
--------------------------

As above, if a user is able to write to the chroot directory then it is
possible for them to escalate their privileges to root and escape the
chroot. One way around this is to give the user two home directories -
one "real" home they can write to, and one SFTP home that is locked down
to keep sshd happy and your system secure. By using mount --bind you can
make the real home directory appear as a subdirectory inside the SFTP
home directory, allowing them full access to their real home directory.

This can also be used to achieve other goals. For example, a user's home
directory can be locked down per the sshd chroot rules, and bind mounts
used to provide users access to other directories:

    # mkdir /home/user/web
    # mount --bind /srv/web/example.com /home/user/web

Now the user can log in with SFTP, they are chrooted to /home/user, but
they see a folder called "web" they can access to manipulate files on a
web site (assuming they have correct permissions in
/srv/web/example.com.

Links & References
------------------

-   http://www.minstrel.org.uk/papers/sftp/builtin/
-   http://www.openbsd.org/cgi-bin/man.cgi?query=sshd_config

Retrieved from
"https://wiki.archlinux.org/index.php?title=SFTP_chroot&oldid=304416"

Categories:

-   File Transfer Protocol
-   Security

-   This page was last modified on 14 March 2014, at 04:06.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
