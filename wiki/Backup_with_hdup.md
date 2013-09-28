Backup with hdup
================

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Intro                                                              |
|     -   1.1 Features                                                     |
|     -   1.2 Other backup programs                                        |
|                                                                          |
| -   2 Installing/running/restoring                                       |
|     -   2.1 Installing and setting hdup up                               |
|     -   2.2 Running hdup                                                 |
|     -   2.3 Restoring backups                                            |
|     -   2.4 More goodies: encryption and ssh                             |
|         -   2.4.1 Backing up over SSH                                    |
|                                                                          |
|     -   2.5 Tips                                                         |
|                                                                          |
| -   3 Troubleshooting                                                    |
+--------------------------------------------------------------------------+

Intro
-----

This wiki page contains a guide on how to set up hdup, "The little,
spiffy, backup tool". (Don't be discouraged by the fact that on its
website it says "Unmaintained!". It is a mature program, and that
warning means only that its author, Miek Gieben, develops and uses a
similar program (rdup), which is a bit more difficult to use.) Although
hdup is a command line program, it's easy to set up, so do not be
afraid.

> Features

-   archives are tar.bz2 (or tar.gz)
-   incremental backups (monthly-weekly-daily scheme)
-   backups over ssh
-   encrypted backups (mcrypt, gpg)

> Other backup programs

See the general wiki article about backup programs.

Installing/running/restoring
----------------------------

> Installing and setting hdup up

-   hdup is in the AUR.

-   We need to edit the configuration file /etc/hdup/hdup.conf. There's
    one supplied, so you can just edit that one; or you can use the
    minimal one listed here:

    [global]
    # to which dir the archives will be written
    archive dir = /vol/backup
    # chown the archives to this user
    user = <yourusername>

    [my-comp]
    # what to backup, separate with ,.
    # For directories add closing slash, like /home/
    dir = /home/,/var/abs/local/
    # do not include theses directories
    exclude = lost\+found/, /proc/, /dev/, /sys/

-   You need to modify at least the following options:
    -   archive dir: that's where the backups will be written to
    -   user: created archives will be chowned to this user; you can
        just use your username. This is needed since hdup needs to be
        run as root.
    -   dir: that's the list of directories whose contents you want to
        back up).

The rest of the comments about the config file can be skipped on the
first reading. They describe various other options you can use if the
hdup.conf file:

-   You can have more than one profile (the one used above is named
    my-comp). This means that you can have a couple of independent
    backup schemes. For instance, you might want to have another one for
    your webpages:

    [my-webpages]
    dir = /var/www/

-   To have a simple means of excluding some directories, use the
    nobackup option. It specifies the filename, which if it exists in a
    directory, then that directory is excluded from backing up.

    nobackup = .nobackup

This can be used for example to exclude backing up of opera cache, by
creating and empty .nobackup file in the cache directory:

    touch ~/.opera/cache4/.nobackup

-   You can specify the compression algorithm used:

    compression = bzip
    compression level = 6

-   hdup refuses to restore backups to / by default, since it can be
    dangerous. To override this, use

    # allow restoring to /
    force = yes

> Running hdup

Let's first explain the monthly-weekly-daily scheme of backups. The
'monthly' archives contain all the data you specify to backup. The
'weekly' archives contain only those files, which have changed from the
last 'monthly' backup. Finally, 'daily' contain only those which have
changed from the last 'weekly' backup.

Of course, 'monthly', 'weekly' and 'daily' are just names, you do not
need to perform backups in these intervals. But you cannot perform a
'weekly', unless you have at least one 'monthly', etc.

So, how does hdup implement this scheme?

As root, you can run hdup with the command like

    hdup monthly my-comp

This creates a directory 'my-comp' in the directory you specified in the
config file (/vol/backup), and inside it two other directories: 'etc'
and (current date) '2008-02-23'. The 'etc' one contains some hdup's
files, and the '2008-02-23' one will have a big .tar.bz2 archive in it.
That's your backup.

After some time after 'monthly' backup, you decide you want to backup
again. Now you can run hdup as

    hdup weekly my-comp

and hdup will archive only what has changed from the 'monthly', and the
archive will be put into another dir named after current date in
/vol/backup/my-comp.

It should be clear now how the backing up works. Note that if hdup
cannot find a 'monthly' and you ask it to do a 'weekly', it will
complain. See the tips section.

> Restoring backups

To restore, you need to have all 'parent' archives (ie. if you want to
restore a weekly backup, you also need to have its 'monthly' available).
The command for restoring is

    hdup restore my-comp 2008-01-31 /somedir

With this, hdup will try to restore things as they've been up to the
date specified, and it will unpack to the directory /somedir. You can
force it to unpack right away to / (see 'force' option above), but be
very careful with this!

Note that the backups are just .tar.bz2 archives, so if you need a
particular file from a particular date, just use any archive manager (or
tar and bzip2) to open the archive and copy the needed file over.

> More goodies: encryption and ssh

If you've got here, let me remind you that man hdup and man hdup.conf
are your friends!

-   For gpg encryption, you want to add something like

    algorithm = gpg
    key = <your gpg key identifier>

either to [global] (then it's going to be used for all profiles), or
just to a profile part. The archives will then be encrypted with your
public key (so you can only decrypt them with your secret key). Note
that you can decrypt them manually with

    gpg -d <archive file>

in case you need it.

-   For other encryption (e.g. mcrypt), just add

    algorithm = mcrypt

In this case, hdup will ask for a password both when archiving and
restoring.

Backing up over SSH

To backup your local machine (say, laptop) to remote machine (your
server) you need to install hdup to both machines.

On the remote machine you need to have following settings in [global]

    archive dir = /backup/path/on/remote
    allow remote = yes

And make a same host entry to the remote hdup.conf than you have in the
local hdup.conf.

So if you have

    [my-comp]
     dir = /home/
     exclude = lost\+found ...

Add to the remote hdup.conf

     [my-comp]

Nothing else is needed, just the [host] entry

Now you can backup your laptop to your server using following command

    hdup monthly my-comp @username@myserver.com

> Tips

-   You can of course burn the archives to cd/dvd with any burning
    software you like. The only thing to remember here is that the
    'parent' archive is needed when you're doing a 'child' backup (like
    you need 'monthly' for 'weekly'). However, if you're tight on space,
    this can be achieved by mounting the cd/dvd with 'parent' backup,
    and soft linking its directory into /vol/backup, so that hdup can
    find it there.

Troubleshooting
---------------

On Debian Etch, I had to add the -P option when running hdup. This
solved the following error:

    /bin/tar: /opt/backup/debian/etc/filelist: file name read contains null

Retrieved from
"https://wiki.archlinux.org/index.php?title=Backup_with_hdup&oldid=198713"

Category:

-   System recovery
