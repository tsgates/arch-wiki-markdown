cron
====

Summary

An overview of the standard task scheduling daemon on GNU/Linux systems.

Resources

Gentoo Linux Cron Guide

From Wikipedia:

cron is the time-based job scheduler in Unix-like computer operating
systems. cron enables users to schedule jobs (commands or shell scripts)
to run periodically at certain times or dates. It is commonly used to
automate system maintenance or administration [...]

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Installation                                                       |
| -   2 Configuration                                                      |
|     -   2.1 Users & autostart                                            |
|     -   2.2 Handling errors of jobs                                      |
|         -   2.2.1 Long cron job                                          |
|                                                                          |
| -   3 Crontab format                                                     |
| -   4 Basic commands                                                     |
| -   5 Examples                                                           |
| -   6 More information                                                   |
| -   7 run-parts issue                                                    |
| -   8 Running Xorg server based applications                             |
| -   9 Asynchronous job processing                                        |
|     -   9.1 Dcron                                                        |
|     -   9.2 Cronwhip                                                     |
|     -   9.3 Anacron                                                      |
|     -   9.4 Fcron                                                        |
|                                                                          |
| -   10 Ensuring exclusivity                                              |
| -   11 See Also                                                          |
+--------------------------------------------------------------------------+

Installation
------------

cronie is installed by default as part of the base group. Other cron
implementations exist if preferred, Gentoo's Cron Guide offers
comparisons. For example, fcron, dcron (Arch Linux's default cron
implementation until May 2011), bcron or vixie-cron are other
alternatives.

Configuration
-------------

> Users & autostart

cron should be working upon login on a new system to run root scripts.
This can be check by looking at the log in /var/log/. In order to use
crontab application (editor for job entries), users must be members of a
designated group users or root, of which all users should already be
members. To ensure cron starts on boot, enable cronie.service or
dcron.service with systemctl enable <service_name> depending on which
cron implementation you use.

> Handling errors of jobs

Errors can occur during execution of jobs. When this happens, cron
registers the stderr output and attempts to send it as email to the
user's spools via the sendmail command.

To log these messages use the -M option in /etc/conf.d/crond and write a
script or install a rudimentary SMTP subsystem (e.g. esmtp):

    # pacman -S esmtp procmail

After installation configure the routing:

    /etc/esmtprc

    identity myself@myisp.com
           hostname mail.myisp.com:25
           username "myself"
           password "secret"
           starttls enabled
           default
    mda "/usr/bin/procmail -d %T"

Procmail needs root privileges to work in delivery mode but it is not an
issue if you are running the cronjobs as root anyway.

To test that everything works correctly, create a file message.txt with
"test message" in it.

From the same directory run:

    $ sendmail user_name < message.txt 

then:

    $ cat /var/spool/mail/user_name

You should now see the test message and the time and date it was sent.

The error output of all jobs will now be redirected to
/var/spool/mail/user_name.

Due to the privileged issue, it is hard to create and send emails to
root (e.g. su -c ""). You can ask esmtp to forward all root's email to
an ordinary user with:

    /etc/esmtprc

    force_mda="user-name"

Note:If the above test didn't work, you may try creating a local
configuration in ~/.esmtprc with the same content.

Run the following command to make sure it has the correct permission:

    $ chmod 710 ~/.esmtprc

Then repeat the test with message.txt exactly as before.

Long cron job

Suppose this program is invoked by cron :

    #!/bin/sh
    echo "I had a recoverable error!"
    sleep 1h

What happens is this:

1.  cron runs the script
2.  as soon as cron sees some output, it runs your MTA, and provides it
    with the headers. It leaves the pipe open, because the job hasn't
    finished and there might be more output.
3.  the MTA opens the connection to postfix and leaves that connection
    open while it waits for the rest of the body.
4.  postfix closes the idle connection after less than an hour and you
    get an error like this :

    smtpmsg='421 … Error: timeout exceeded' errormsg='the server did not accept the mail'

To solve this problem you can use the command chronic or sponge from
moreutils. From they respective man page :

 chronic
    chronic runs a command, and arranges for its standard out and
    standard error to only be displayed if the command fails (exits
    nonzero or crashes). If the command succeeds, any extraneous output
    will be hidden.
 sponge
    sponge reads standard input and writes it out to the specified file.
    Unlike a shell redirect, sponge soaks up all its input before
    opening the output file… If no output file is specified, sponge
    outputs to stdout.

Even if it's not said chronic buffer the command output before opening
its standard output (like sponge does).

Crontab format
--------------

The basic format for a crontab is:

    <minute> <hour> <day_of_month> <month> <day_of_week> <command>

-   minute values can be from 0 to 59.
-   hour values can be from 0 to 23.
-   day_of_month values can be from 1 to 31.
-   month values can be from 1 to 12.
-   day_of_week values can be from 0 to 6, with 0 denoting Sunday.

Multiple times may be specified with a comma, a range can be given with
a hyphen, and the asterisk symbol is a wildcard character. Spaces are
used to separate fields. For example, the line:

    *0,*5 9-16 * 1-5,9-12 1-5 ~/bin/i_love_cron.sh

Will execute the script i_love_cron.sh at five minute intervals from 9
AM to 4:55 PM on weekdays except during the summer months (June, July,
and August). More examples and advanced configuration techniques can be
found below.

Basic commands
--------------

Crontabs should never be edited directly; instead, users should use the
crontab program to work with their crontabs. To be granted access to
this command, user must be a member of the users group (see the gpasswd
command).

To view their crontabs, users should issue the command:

    $ crontab -l

To edit their crontabs, they may use:

    $ crontab -e

To remove their crontabs, they should use:

    $ crontab -r

If a user has a saved crontab and would like to completely overwrite
their old crontab, he or she should use:

    $ crontab saved_crontab_filename

To overwrite a crontab from the command line (Wikipedia:stdin), use

    $ crontab - 

To edit somebody else's crontab, issue the following command as root:

    # crontab -u username -e

This same format (appending -u username to a command) works for listing
and deleting crontabs as well.

To use nano rather than vi as crontab editor, add the following lines to
your shell's initialization file (eg. /etc/profile or /etc/bash.bashrc):

    export EDITOR="/usr/bin/nano"

And restart open shells.

Examples
--------

The entry:

    01 * * * * /bin/echo Hello, world!

runs the command /bin/echo Hello, world! on the first minute of every
hour of every day of every month (i.e. at 12:01, 1:01, 2:01, etc.)

Similarly,

    */5 * * jan mon-fri /bin/echo Hello, world!

runs the same job every five minutes on weekdays during the month of
January (i.e. at 12:00, 12:05, 12:10, etc.)

As noted in the Crontab Format section, the line:

    *0,*5 9-16 * 1-5,9-12 1-5 /home/user/bin/i_love_cron.sh

Will execute the script i_love_cron.sh at five minute intervals from 9
AM to 5 PM (excluding 5 PM itself) every weekday (Mon-Fri) of every
month except during the summer (June, July, and August).

More information
----------------

The cron daemon parses a configuration file known as crontab. Each user
on the system can maintain a separate crontab file to schedule commands
individually. The root user's crontab is used to schedule system-wide
tasks (though users may opt to use /etc/crontab or the /etc/cron.d
directory, depending on which cron implementation they choose).

There are slight differences between the crontab formats of the
different cron daemons. The default root crontab for dcron looks like
this:

    /var/spool/cron/root

    # root crontab
    # DO NOT EDIT THIS FILE MANUALLY! USE crontab -e INSTEAD

    # man 1 crontab for acceptable formats:
    #    <minute> <hour> <day> <month> <dow> <tags and command>
    #    <@freq> <tags and command>

    # SYSTEM DAILY/WEEKLY/... FOLDERS
    @hourly         ID=sys-hourly   /usr/sbin/run-cron /etc/cron.hourly
    @daily          ID=sys-daily    /usr/sbin/run-cron /etc/cron.daily
    @weekly         ID=sys-weekly   /usr/sbin/run-cron /etc/cron.weekly
    @monthly        ID=sys-monthly  /usr/sbin/run-cron /etc/cron.monthly

These lines exemplify one of the formats that crontab entries can have,
namely whitespace-separated fields specifying:

1.  @period
2.  ID=jobname (this tag is specific to dcron)
3.  command

The other standard format for crontab entries is:

1.  minute
2.  hour
3.  day
4.  month
5.  day of week
6.  command

The crontab files themselves are usually stored as
/var/spool/cron/username. For example, root's crontab is found at
/var/spool/cron/root

See the crontab man page for further information and configuration
examples.

run-parts issue
---------------

cronie uses run-parts to carry out script in
cron.daily/cron.weekly/cron.monthly. Be careful that the script name in
these won't include a dot (.), e.g. backup.sh, since run-parts without
options will ignore them (see: man run-parts).

Running Xorg server based applications
--------------------------------------

If you find that you can't run X apps from cron jobs then use this
prefix:

    export DISPLAY=:0.0 ;

This sets the DISPLAY variable to the first display, which is usually
right unless you run multiple X servers on your machine.

If it still doesn't work, then you need to use xhost to give your user
control over X:

    # xhost +si:localuser:$(whoami)

Asynchronous job processing
---------------------------

If you regularly turn off your computer but do not want to miss jobs,
there are some solutions available (easiest to hardest):

> Dcron

Vanilla dcron supports asynchronous job processing. Just put it with
@hourly, @daily, @weekly or @monthly with a jobname, like this:

    @hourly         ID=greatest_ever_job      echo This job is very useful.

> Cronwhip

(AUR, forum thread): Script to automatically run missed cron jobs; works
with the former default cron implementation, dcron.

> Anacron

(AUR): Full replacement for dcron, processes jobs asynchronously.

> Fcron

(Community, forum thread): Like anacron, fcron assumes the computer is
not always running and, unlike anacron, it can schedule events at
intervals shorter than a single day. Like cronwhip, it can run jobs that
should have been run during the computer's downtime.

Ensuring exclusivity
--------------------

If you run potentially long-running jobs (e.g., a backup might all of a
sudden run for a long time, because of many changes or a particular slow
network connection), then lockrun can ensure that the cron job won't
start a second time.

      5,35 * * * * /usr/bin/lockrun -n /tmp/lock.backup /root/make-backup.sh

See Also
--------

-   CronTab Usage Tutorial

Retrieved from
"https://wiki.archlinux.org/index.php?title=Cron&oldid=251801"

Category:

-   Daemons and system services
