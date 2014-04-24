initscripts/runlevels
=====================

Related articles

-   SysVinit

Note:systemd is used by default, which uses targets (see
man systemd.target) rather than runlevels.

From the init man page:

A runlevel is a software configuration of the system which allows only a
selected group of processes to exist. The processes spawned by init for
each of these runlevels are defined in the /etc/inittab file.

If something goes wrong with your Arch setup in such way that you are
completely helpless when the system boots up, you may need this.

For example, if you use some deffective display drivers, the system may
freeze when the X server starts. If you have a display manager in your
startup daemons list, you need to take full control of your system
before that daemon starts.

And how do you do that?

What you need is called "booting to another runlevel". This basically
determines in what state the system will be when the boot sequence
terminates. Normally you finish in the multi-user mode with all daemons
started (=runlevel 3).

Contents
--------

-   1 List of initscripts runlevels
-   2 Runlevel invocation
-   3 Adding runlevels
    -   3.1 First method
    -   3.2 Another way, without adding any symlink
-   4 Other distributions

List of initscripts runlevels
-----------------------------

And what are the possible runlevels?

-   1: Single user (maintainance mode): You want to use this one if you
    have problems.
-   3: Multi user: Normal mode
-   5: Multi user with X11: The same as 3 but with X11 loaded in virtual
    terminal 8 by default
-   0: Halt
-   6: Reboot
-   2, 4: Not used

Take a look to /etc/inittab to see how it works.

Runlevel invocation
-------------------

You specify what runlevel you would like to enter on the kernel
commandline. You just have to pass the number of the desired runlevel as
an option on that commandline, so it may look like this if you are in
trouble and you want to use single user mode (only the last number is
important here)

    kernel /vmlinuz-linux ... root=/dev/sda2 ro 1

And yes, in a case when you can not boot, you will have to append the
runlevel number to the the kernel command line in the boot manager
during bootup.

Adding runlevels
----------------

> First method

Throughout this page, 4 will be used for an example since it is not used
by default in Arch. To create another runlevel:

    cd /etc
    cp rc.multi rc.multi4
    sed -i "s/DAEMONS/DAEMONS4/g" /etc/rc.multi4

The execution of sed will change /etc/rc.multi4 to look at the new
DAEMONS array that will be defined in a couple of steps.

Next, we will add our new /etc/rc.multi4 script to /etc/inittab by
changing this line:

    rm:2345:wait:/etc/rc.multi

to:

    rm:235:wait:/etc/rc.multi
    ra:4:wait:/etc/rc.multi4

You can also add a new line to /etc/inittab to execute another script or
program to do anything you would like.

Example: Log into X as a single user for a special purpose:

    xa:4:respawn:/bin/su - $USER -c "/usr/bin/startx"

The next step will be to add a new DAEMONS array to your /etc/rc.conf
file, call it DAEMONS4=(...) and populate this array with any daemons
you would like to run for the new runlevel.

The /etc/rc.conf gives the suggestion to put a ! in front of daemons you
want to disable. How this is handled in the default /etc/rc.multi, is
that anything prefaced with the ! is skipped. A downside to this is if
you use the above method to define a different set of daemons for your
new runlevel (i.e, want to stop some, keep others going, and/or start
new ones) any daemon prefaced with ! will not be stopped when switching
to or from your new runlevel. The following /etc/rc.multi changes this
behavior.

Example:

    /etc/rc.multi

     #!/bin/bash
     #
     # /etc/rc.multi
     #
      
     . /etc/rc.conf
     . /etc/rc.d/functions
     
     run_hook multi_start
     
     # Load sysctl variables if sysctl.conf is present
     [ -r /etc/sysctl.conf ] && /sbin/sysctl -q -p &>/dev/null
     
     # Start daemons
     # _remember to change DAEMONS in next line for the file /etc/rc.multi4
     for daemon in "${DAEMONS[@]}"; do
             if [ "$daemon" = "${daemon#!}" ]; then
                     # check to see if daemon is running.
                     ck_daemon $daemon
                     if [ $? -eq 1 ]; then
                             # daemon is running, skip it.
                             status_started
                     else
                             # daemon is not running, start it.
                             if [ "$daemon" = "${daemon#@}" ]; then
                                     start_daemon $daemon
                             else
                                     start_daemon_bkgd ${daemon:1}
                             fi
                     fi
             else
                     # check previous runlevel. if it's N, then we've just booted
                     #   and do not need to stop any daemons. otherwise, stop daemons
                     #   when runlevel changes as requested in DAEMONS array.
                     if [ `/sbin/runlevel | cut -d ' ' -f 1` != "N" ] ; then
                             ck_daemon ${daemon:1}
                             if [ $? -eq 1 ] ; then
                                      # daemon is running, let's stop it.
                                      stop_daemon ${daemon:1}
                             fi
                     fi
             fi
     done
     
     if [ -x /etc/rc.local ]; then
             /etc/rc.local
     fi
     
     run_hook multi_end
     
     # vim: set ts=2 noet:

Here is what this does:

    DAEMONS=(syslog-ng network netfs sshd alsa !jack !gpm)      # runlevel 3
    DAEMONS4=(syslog-ng network netfs !sshd alsa jack gpm)      # runlevel 4

In runlevel 3, jack and gpm are disabled, and in runlevel 4 sshd is not
needed, but jack and gpm are. The above /etc/rc.multi script will scan
the daemons array and check for:

    1) if a daemon is running (without !). if it is, skip it. if not, start it.
    2) if a daemon is disabled (!), stop it. (this is skipped on boot-up)
    3) it still honors starting daemons in the background (@)

In the above example, when going from runlevel 3 to runlevel 4,
syslog-ng, network, netfs, and alsa are checked and found to be running
so they'll be skipped. sshd will be disabled then jack and gpm will be
started. And when going from runlevel 4 to runlevel 3, syslog-ng,
network, netfs, and alsa are still running, so will be skipped again,
but jack and gpm will be stopped, while sshd will be started again.

In summary:

    1) copy /etc/rc.multi to /etc/rc.multi4
    2) add DAEMONS4 to the end of your /etc/rc.conf and add daemons to it
    2) be sure to change /etc/rc.multi4 by changing DAEMONS to DAEMONS4
    3) edit /etc/inittab to add the runlevel and take appropriate actions

If you do use the above /etc/rc.multi, proper operation is for it to be
both your main /etc/rc.multi and your new /etc/rc.multi4 to ensure that
all daemons are processed as you desire. It will not break your system
to have two different versions of /etc/rc.multi.

While your new runlevel setup should not be written over by any system
updates, it is always handy to have backups on hand in the event that
something unforeseen happens.

> Another way, without adding any symlink

With a simple modification on /etc/rc.multi, runlevels can be simply
added by adding a new DAEMONS line in /etc/rc.conf.

Here is the patch:

    --- rc.multi	2008-06-22 23:58:29.000000000 +0200
    +++ rc.multi.new	2008-06-23 00:14:05.000000000 +0200
    @@ -11,8 +11,25 @@
     # Load sysctl variables if sysctl.conf is present
     [ -r /etc/sysctl.conf ] && /sbin/sysctl -q -p &>/dev/null
     
    +# Load the appropriate DAEMONS array according to runlevel specified in the kernel boot cmdline
    +RUNLEVEL=""
    +FINAL_DAEMONS=()
    + 
    +for param in `cat /proc/cmdline`; do
    +  param_rl=`echo $param | grep ^runlevel`
    +  if [ ! "$param_rl" = "" ]; then
    +    RUNLEVEL=`echo $param_rl | sed -r -e "s#runlevel=(.+)#\1#"`
    +  fi
    +done;
    +
    +if [ "${RUNLEVEL}" = "" ]; then
    +	eval FINAL_DAEMONS=(${DAEMONS[@]})
    +else
    +	eval FINAL_DAEMONS=(\${DAEMONS_${RUNLEVEL}[@]})
    +	if [ "${#FINAL_DAEMONS[@]}" = "0" ]; then
    +		eval FINAL_DAEMONS=(${DAEMONS[@]})
    +	fi	
    +fi
    +
     # Start daemons
    -for daemon in "${DAEMONS[@]}"; do
    +for daemon in "${FINAL_DAEMONS[@]}"; do
     	if [ "$daemon" = "${daemon#!}" ]; then
     		if [ "$daemon" = "${daemon#@}" ]; then
     			/etc/rc.d/$daemon start

Now, to add a runlevel, add a new array in /etc/rc.conf (in this example
I named it FOO):

    DAEMONS_FOO=( ...whatever... )

and to run the system with this runlevel, simply add runlevel=FOO to
your boot arguments in LILO or GRUB.

Other distributions
-------------------

Runlevels exist in all Linux distributions and while runlevel 1 is
usually single-user "emergency mode", 0 means halt and 6 mean reboot,
the meaning of other runlevels varies from one distribution to another.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Initscripts/runlevels&oldid=291651"

Category:

-   Boot process

-   This page was last modified on 5 January 2014, at 02:43.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
