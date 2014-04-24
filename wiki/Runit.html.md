Runit
=====

Runit is a process supervisor. It includes runit-init, which can replace
sysv's init as pid1, or can be run from inittab or your init system of
choice. Runit's simple collection of tools can be used to build flexible
dependency structures and distributed systems, or blazing fast parallel
runlevel changes (including the initial boot).

See G. Pape's Runit Page for a complete description, but follow the
installation instructions below for your Arch system.

Contents
--------

-   1 Installation
-   2 Using runit
    -   2.1 The Tools
    -   2.2 The Extras
    -   2.3 Run Levels and Service Directories
    -   2.4 General Use
-   3 User Level Services
    -   3.1 Add a user level service tree
    -   3.2 Create an X session service for a user
-   4 Advanced Recipes
    -   4.1 Running a read-only Postgresql Slave database in-memory
        -   4.1.1 Requirements
        -   4.1.2 Instructions

Installation
------------

To replace init with runit-init

-   install sysvinit-tools and sysvinit (say Yes to replacing
    systemd-sysvcompat)
-   install runit-musl and runit-run from the AUR
-   choose/create a default runlevel (see Run Levels)
-   add init=/sbin/runit-init to your bootloader's kernel command line
-   reboot

If you just want to get your feet wet and not replace init just yet,
runit-musl can be installed side-by-side with the regular Arch systemd
PID1, providing just process supervision of those services you put in
/var/service.

-   install runit-musl and runit-services from the AUR
-   start runsvdir /var/service using your current init scheme
    (inittab/rc.local/systemd, whatever)

The runit-services package puts services in /etc/sv and uses
/usr/bin/rsvlog as a logger (it's a shell script, take a look and modify
to taste, improvements welcome).

runit-scripts puts many new runlevels and symlinks them to the service
directories it creates in /etc/runit/runsvdir/all, and uses its own
/usr/bin/nsvlog script for logging.

Using runit
-----------

> The Tools

-   sv - used for controlling services, getting status of services, and
    dependency checking.
-   chpst - control of a process environment, including memory caps,
    limits on cores, data segments, environments, user/group privileges,
    and more.
-   runsv - supervises a process, and optionally a log service for that
    process.
-   svlogd - a simple but powerful logger, includes auto-rotation based
    on different methods (time, size, etc), post-processing, pattern
    matching, and socket (remote logging) options. Say goodbye to
    logrotate and the need to stop your services to rotate logs.
-   runsvchdir - changes service levels (runlevels, see below).
-   runsvdir - starts a supervision tree
-   runit-init - PID 1, tiny, does almost nothing, dietlibc staticly
    compiled. Just what you want your PID 1 to be.

See the manpages for usage details not covered below.

> The Extras

Added by runit-dietlibc and runit-run

-   /etc/runit/1 - bootstraps the system using arch rc scripts
-   /etc/runit/2 - starts single or multi-user runlevels using arch's
    rc.single or rc.multi
-   /etc/runit/3 - brings the system down using arch's rc scripts
-   /etc/runit/runsvdir/* - various runlevels
-   /usr/bin/rsvlog - a wrapper to svlogd meant to be symlinked as 'run'
    in a log service
-   /etc/sv/* - the service directories available (more available here
    when you install runit-services-git)

Added by runit-scripts

-   /etc/runit/1_new - meant to be an alternate way to bootstrap, does
    not necessarily use arch boot scripts
-   /etc/runit/2_new - single/multi user runlevels (not based on arch
    scripts)
-   /etc/runit/3_new - take the system down
-   /etc/runit/runsvdir/all - every service directory available
-   /etc/runit/runsvdir/* - various runlevels
-   /usr/bin/nsvlog - wrapper meant to be symlinked as 'run' in a log
    service

> Run Levels and Service Directories

Runit uses directories of symlinks to specify runlevels, other than the
3 main ones, which are defined in /etc/runit/1, 2, and 3.

1 bootstraps the system, 2 starts runsvdir on /service, and 3 stops the
system.

While in run level 2, you are not constrained to any amount of service
levels (equivalent to runlevels in sysvinit). You can runschdir to any
directory (full of service directory symlinks) you've made in
/etc/runit/runsvdir/. This becomes very handy in cases where you have an
HA (Failover) setup, and you have one machine that can take over
services for many other machines, simply by runsvchdir <theservicedir>.

You can also run trees of dependent service levels by having user-level
supervision directories. See User Level Services below.

By default, the runit-run package uses a very minimal service set,
defined in /etc/runit/runsvdir/archlinux-default and symlinked to
/etc/runit/runsvdir/default.

It only gives gettys on tty2 and tty3, so you will boot to just console
scroll and a tidy 'runsvchdir: default: current'. This means when you
start X it will be on tty4.

To go back to the standard arch consoles, remove the link
/service/ngetty and link as many /etc/sv/*getty* services you like in
/service, or edit the /etc/sv/ngetty/run file to get more getties.
Better yet, create your own directory in /etc/runit/runsvdir and add the
symlinks you want for just the services you desire. Remember to take any
services you start with runit out of DAEMONS in /etc/rc.conf or
systemctl disable them, they do not need to be started there, and runit
will allow parallel startup without backgrounding them.

> General Use

For convenience I'll be using /service as the service directory in these
examples. Since this has not been accepted by FHS, it is only made
available as a symlink in the runit-run package. This allows importing
of /service scripts written by others without as much fuss. If you only
install runit-musl, you would use /var/service as your service
directory, or make the /service symlink to /var/service yourself.

Listing running services

    $ sudo sv s /service/*

       run: /service/agetty-2: (pid 4120) 7998s
       run: /service/agetty-3: (pid 4119) 7998s
       run: /service/bougyman: (pid 4465) 7972s
       run: /service/bougyx: (pid 4135) 7998s; run: log: (pid 4127) 7998s
       run: /service/cron: (pid 4137) 7998s; run: log: (pid 4122) 7998s
       run: /service/dialer: (pid 4121) 7998s
       run: /service/qmail: (pid 4138) 7998s; run: log: (pid 4126) 7998s
       run: /service/smtpd: (pid 4136) 7998s; run: log: (pid 4125) 7998s
       run: /service/socklog-klog: (pid 4139) 7998s; run: log: (pid 4132) 7998s
       run: /service/socklog-unix: (pid 4133) 7998s; run: log: (pid 4124) 7998s
       run: /service/ssh: (pid 4134) 7998s; run: log: (pid 4123) 7998s

Services should live in /etc/sv; however, the runit-scripts package puts
a bunch of common ones in /etc/runit/runsvdir/all. We're working to
replace/convert these to /etc/sv in the runit-services-git package.

Create and Start a service:

    # ln -s /etc/sv/ssh /service/ssh

Stops a service immediately (would still start on next boot):

    # sv d ssh

Restarts a service:

    # sv t ssh

Reloads a service:

    # sv h ssh

Shows status of a service and it's log service:

    # sv s ssh

Stops a service, and disables it (won't start next boot):

    # rm /service/ssh

Refer to man sv for more details.

Shut down the system

    # runit-init 0

Reboot the system

    # runit-init 6

User Level Services
-------------------

You can extend the supervision tree by starting a runsvdir as a specific
user, giving that user control of their own supervise tree.

> Add a user level service tree

    # mkdir -p /etc/sv/homes/joeuser

Create /etc/sv/homes/joeuser/run with the following:

       #!/bin/sh
       export PATH=/home/joeuser/bin:$PATH # optional, if your services rely on binaries in ~/bin
       exec 2>&1 \
         sudo -H -u joeuser runsvdir -P /home/joeuser/service 'log:...................................................................................................................................' # Requires sudo, of course
         

    # chmod 700 /etc/sv/homes/joeuser/run

Then symlink /etc/sv/homes/joeuser to /service and any service joe puts
in ~/service will start, as him, with his environment.

(the .......... represent placeholders, the proceess will print
stdout/err every 5 seconds for each placeholder . you use in this case)

> Create an X session service for a user

    # mkdir -p /etc/sv/joeuserX

Create the /etc/sv/joeuserX/run script with the following

       #!/bin/sh
       exec 2>&1 \
         su -c xinit - joeuser

    # chmod 700 /etc/sv/joeuserX/run

Then symlink /etc/sv/joeuserX to /service. joe's X session will now
always run (in this runlevel). To protect it using joe's ssh passphrase,
use the following in your .xinitrc:

       #!/bin/sh
       ...
       SNIP
       ...
       xscreensaver&
       eval $(keychain --eval)
       exec sh -c \
         'SSH_ASKPASS=/usr/lib/openssh/ssh-askpass-fullscreen ssh-add < /dev/null \
          && exec stumpwm'

Replace the 'stumpwm' with the command to launch your window manager or
desktop environment.

Requires the 'keychain' and 'ssh-askpass-fullscreen' packages, or you
could replace 'eval (keychain)' with 'eval (ssh-agent) and replace
ssh-askpass-fullscreen with any ssh passphrase asker. The fullscreen
version guarantees protection of your desktop, so we prefer that. This
also exports your key to all your x apps, so you do not need another
keychain manager for ssh. In addition, 'keychain' (as opposed to just
ssh-agent) supports gpg passphrase caching, as well, not just the ssh
keys.

Advanced Recipes
----------------

> Running a read-only Postgresql Slave database in-memory

This recipe was created for a small but vital database which required
very high read throughput. To sort it out we use Postgresql's Streaming
Replication and Hot Standby mode.

Requirements

-   Postgresql 9.0 or above
-   runit-services (includes /etc/sv/postgresql)
-   Rsync (for initial replication)

Instructions

1. Create /etc/sv/pg_mem/log directory

    # mkdir -p /etc/sv/pg_mem/log

2. Create three new files

/etc/sv/pg_shm/run:

       #!/bin/sh -e
       sleep 3 # Give postgresql a chance to start and replay any transactions
       
       . /etc/conf.d/pg_shm # Read any conf vars
       PG_DISK_ROOT=/var/lib/postgres # Where the 'master' data directory lives
       
       [ -d "$PGROOT" ] || mkdir -p "$PGROOT" # Create the new $PGROOT if it does not exist
       
       sv -w7 c postgresql 2>&1
       
       # Stop the main postgres from making changes by enttering backup mode
       psql -U postgres -c "SELECT pg_start_backup('seed',true)" 2>&1
       # Sync the main postgres data dir to our new $PGROOT
       rsync --progress --delete -a "$PG_DISK_ROOT/data" "$PGROOT/" --exclude=postmaster.pid 2>&1
       # Allow changes on the primary server again
       psql -U postgres -c "SELECT pg_stop_backup()" 2>&1
       
       # Set up the hot standby mode on the slave server
       echo "hot_standby = 'on'" >> "$PGROOT/data/postgresql.conf"
       echo "port = $PGPORT" >> "$PGROOT/data/postgresql.conf"
       echo "standby_mode = 'on'" >> "$PGROOT/data/recovery.conf"
       echo "primary_conninfo = 'host=localhost port=5432 user=postgres'" >> "$PGROOT/data/recovery.conf"
       echo "trigger_file = '/tmp/stop_replication'" >> "$PGROOT/data/recovery.conf"
       echo "restore_command = 'cp /var/lib/postgres/archive/%f \"%p\"'" >> "$PGROOT/data/recovery.conf"
       
       exec chpst -u postgres /usr/bin/postgres -D "$PGROOT/data" -c config_file="$PGROOT/data/postgresql.conf" 2>&1

Which requires /etc/conf.d/pg_shm:

    PGROOT=/dev/shm/pg_mem
    PGPORT=5434
    PGLOG="/var/log/pg_mem.log"

as well as a file in /etc/sv/postgresql (or wherever your postgresql
service directory lives) named 'finish':

    #/bin/sh
    sv -v i pg_shm

3. Make run and finish executable

    # chmod 700 /etc/sv/pg_mem/run

    # chmod 700 /etc/sv/postgresql/finish

4. Create a log service

    # ln -s /usr/bin/rsvlog /etc/sv/pg_shm/log/run

5. Edit /var/lib/postgres/data/postmaster.conf, to enable wal archiving.
See this The PostgreSQL page, steps 3 and 4, for detailed instructions
on this.

6. Restart postgresql

    # sv i postgresql

7. Start pg_shm (replace /service with your service directory, if it
differs)

    # ln -s /etc/sv/pg_shm /service

8. Make sure everything is running

    # sv s postgresql pg_mem

That's it, you'll have a replica of your postgresql on-disk database
published on port 5434, in read-only mode from the memory space utilized
from /dev/shm.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Runit&oldid=306012"

Categories:

-   Boot process
-   Daemons and system services

-   This page was last modified on 20 March 2014, at 17:35.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
