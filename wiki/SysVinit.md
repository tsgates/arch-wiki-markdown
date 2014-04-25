SysVinit
========

Warning:SysVinit is obsoleted in Arch Linux [1] and has been dropped
from the official repositories. You need to migrate to systemd.

On systems based on SysVinit, init is the first process that is executed
once the Linux kernel loads. The default init program used by the kernel
is /sbin/init provided by systemd-sysvcompat (by default on new
installs, see systemd) or sysvinit. The word init will always refer to
sysvinit in this article.

inittab is the startup configuration file for init located in /etc. It
contains directions for init on what programs and scripts to run when
entering a specific runlevel.

Although a SysVinit-based Arch system does use init, most of the work is
delegated to the #Main Boot Scripts. This article concentrates on init
and inittab.

Contents
--------

-   1 Migration to systemd
    -   1.1 Considerations before switching
    -   1.2 Installation procedure
    -   1.3 Supplementary information
-   2 Overview of init and inittab
-   3 Installation
-   4 Switching runlevel
    -   4.1 Through bootloader
    -   4.2 After boot up
-   5 inittab
    -   5.1 Default Runlevel
    -   5.2 Main Boot Scripts
    -   5.3 Single User Boot
    -   5.4 Gettys and Login
    -   5.5 Ctrl+Alt+Del
    -   5.6 X Programs
    -   5.7 Power-Sensing Scripts
    -   5.8 Custom Keyboard Request
        -   5.8.1 Trigger the kbrequest
-   6 See Also
-   7 External Links

Migration to systemd
--------------------

> Note:

-   systemd and systemd-sysvcompat are both installed by default on
    installation media newer than 2012-10-13. This section is aimed at
    Arch Linux installations that still rely on sysvinit and
    initscripts.
-   If you are running Arch Linux inside a VPS, please see Virtual
    Private Server#Moving your VPS from initscripts to systemd.

> Considerations before switching

-   Do some reading about systemd.
-   Note the fact that systemd has a journal system that replaces
    syslog, although the two can co-exist. See #Journal.
-   While systemd can replace some of the functionality of cron, acpid,
    or xinetd, there is no need to switch away from using the
    traditional daemons unless you want to.
-   Interactive initscripts are not working with systemd. In particular,
    netcfg-menu cannot be used at system start-up (FS#31377).

> Installation procedure

1.  Install systemd from the official repositories.
2.  Append the following to your kernel parameters:
    init=/usr/lib/systemd/systemd.
3.  Once completed you may enable any desired services via the use of
    systemctl enable service_name (this roughly equates to what you
    included in the DAEMONS array. New names can be found in Daemons
    List).
4.  Reboot your system and verify that systemd is currently active by
    issuing the following command: cat /proc/1/comm. This should return
    the string systemd.
5.  Make sure your hostname is set correctly under systemd:
    hostnamectl set-hostname myhostname or /etc/hostname.
6.  Proceed to remove initscripts and sysvinit from your system and
    install systemd-sysvcompat.
7.  Optionally, remove the init=/usr/lib/systemd/systemd parameter. It
    is no longer needed because systemd-sysvcompat provides a symlink to
    systemd's init where sysvinit used to be.

> Supplementary information

-   If you have quiet in your kernel parameters, you might want to
    remove it for your first couple of systemd boots, to assist with
    identifying any issues during boot.

-   It is not necessary to add your user to groups (sys, disk, lp,
    network, video, audio, optical, storage, scanner, power, etc.) for
    most use cases with systemd. The groups can even cause some
    functionality to break. For example, the audio group will break fast
    user switching and allows applications to block software mixing.
    Every PAM login provides a logind session, which for a local session
    will give you permissions via POSIX ACLs on audio/video devices, and
    allow certain operations like mounting removable storage via udisks.

-   See the Network configuration article for how to set up networking
    targets.

Overview of init and inittab
----------------------------

init is always process 1 and, other than managing some swap space, is
the parent process to all other processes. You can get an idea of where
init lies in the process hierarchy of your system with pstree:

    $ pstree -Ap

    init(1)-+-acpid(3432)
            |-crond(3423)
            |-dbus-daemon(3469)
            |-gpm(3485)
            |-mylogin(3536)
            |-ngetty(3535)---login(3954)---zsh(4043)---pstree(4326)
            |-polkitd(4033)---{polkitd}(4035)
            |-syslog-ng(3413)---syslog-ng(3414)
            `-udevd(643)-+-udevd(3194)
                         `-udevd(3218)

Besides usual initialization of system (as the name suggests), init also
handles rebooting, shutdown and booting into recovery mode (single-user
mode). To support these, inittab groups entries into different
runlevels. The runlevels Arch uses are 0 for halt, 1 (aliased as S) for
single-user mode, 3 for normal booting (multi-user mode), 5 for X and 6
for reboot. Other distros may adopt other conventions, but the meanings
of 0, 1 and 6 are universal.

Upon execution, init scans inittab and carry out appropriate actions. An
entry in inittab takes the form

    id:runlevels:action:process

Where id is a unique identifier for the entry (just a name, no real
impact on init), and runlevels is a (not delimited) string of runlevels.
If the runlevel init is entering appears in runlevels, action is carried
out, executing process if appropriate. Some special actions would cause
init to ignore runlevels and adopt a special matching method. More
explanation follows in the next section.

See also man 5 inittab and man 8 init.

Installation
------------

  ------------------------ ------------------------ ------------------------
  [Tango-view-fullscreen.p This article or section  [Tango-view-fullscreen.p
  ng]                      needs expansion.         ng]
                           Reason: This section     
                           should explain how to    
                           replace systemd with     
                           sysvinit. (Discuss)      
  ------------------------ ------------------------ ------------------------

Switching runlevel
------------------

> Through bootloader

To change the runlevel the system boots into, simply add the desired
runlevel n to the respective bootloader's configuration line. A common
application of this is Start X at Login#inittab. To boot to the desired
runlevel, add its number to the kernel parameters (e.g. 3 for runlevel
3).

The run-level was appended to the end so the kernel knows what run-level
to start with. To use another init program (e.g. systemd), add
init=/bin/systemd or similar.

Note:If using some init other than sysvinit, the runlevel parameter
might be ignored.

> After boot up

After the system has booted up, you may issue telinit n to inform init
to change the runlevel to n. init then reads inittab and "diffs"
runlevel n and current runlevel - killing processes not present in the
new runlevel and carrying out actions not present in the old runlevel.
Processes present in both runlevels are left untouched. The killing
procedure is actually a little complex; again, technical details can be
found in the init manpage.

init doesn't watch inittab. You need to call telinit explicitly to apply
modifications to inittab. The command telinit q causes init to
re-examine inittab but not switch runlevel.

inittab
-------

In this section we examine common entries in inittab, in the same order
as they appear in the default inittab used by Arch. After that there are
a few examples to help you create your own inittab entry.

Warning:Always test a modified /etc/inittab with telinit q before you
reboot, or a small syntax error can prevent your system from booting.

> Default Runlevel

The default runlevel is 3. Uncomment or add this if you prefer to boot
into runlevel 5 (which is used for X conventionally) by default:

    id:5:initdefault:

> Main Boot Scripts

These are the main Arch init scripts.

    rc::sysinit:/etc/rc.sysinit
    rs:S1:wait:/etc/rc.single
    rm:2345:wait:/etc/rc.multi
    rh:06:wait:/etc/rc.shutdown

> Single User Boot

Sometimes your kernel may fail to boot up all the way, due to a
corrupted or dead hard drive or filesystem, missing key files, etc. In
that case your init image may automatically enter into single-user mode
which only allows root login and uses /sbin/sulogin instead of
/sbin/login to control the login process. You can also boot into
single-user mode by appending the letter S to your kernel command line
in your GRUB, LILO, or syslinux configuration. If you would like
something other than sulogin to run, specify it here.

    su:S:wait:/sbin/sulogin -p

> Gettys and Login

These are crucial entries that run the gettys on your terminals. Most
default configurations will have several gettys running on ttys1-6 which
is what pops up on your screen with the login prompt. Also see openvt,
chvt, stty, and ioctl.

    c1:234:respawn:/sbin/agetty 9600 tty1 xterm-color
    c5:5:respawn:/sbin/agetty 57600 tty2 xterm-256color

> Ctrl+Alt+Del

When the special key sequence Ctrl+Alt+Del is pressed, this determines
what to do.

    ca::ctrlaltdel:/sbin/shutdown -t3 -r now

> X Programs

If you are not afraid to debug, you can figure out how to start all
sorts of programs from inittab. One useful type of program is to start
your login manager when the runlevel is 5, multi-user-x-mode. In the
following example you can see how to start SLiM when entering runlevel
5.

    x:5:respawn:/usr/bin/slim >/dev/null 2>&1
    #x:5:respawn:/usr/bin/xdm -nodaemon -confi /etc/X11/xdm/archlinux/xdm-config

> Power-Sensing Scripts

Init can communicate with your UPS device and execute processes based on
the status of the UPS. Here are some examples:

    pf::powerfail:/sbin/shutdown -f -h +2 "Power Failure; System Shutting Down"
    pr:12345:powerokwait:/sbin/shutdown -c "Power Restored; Shutdown Cancelled"

> Custom Keyboard Request

The following line adds a custom function for when a special key
sequence is pressed. You can modify this special key sequence to be
anything you like, similar to a Ctrl+Alt+Del.

    kb::kbrequest:/usr/bin/wall "Keyboard Request -- edit /etc/inittab to customize"

Trigger the kbrequest

You can trigger the special key sequence kbrequest by sending the WINCH
signal to the init process (1) as root (via sudo). In this example, the
command:

    kill -WINCH 1

Causes wall to write to all ttys:

    Broadcast message from root@askapachehost (console) (Wed Oct 27 14:02:26 2010):
    Keyboard Request -- edit /etc/inittab to customize

See Also
--------

-   Automatic login to virtual console
-   Disable Clearing of Boot Messages
-   Start X at Login
-   xinitrc
-   Display manager
-   SLiM

External Links
--------------

-   Wikipedia: Init
-   Linux Knowledge Base and Tutorial. Run Levels.
-   Linux.com. Introduction to runlevels and inittab
-   Linux.com. An introduction to services, runlevels, and rc.d scripts.

Retrieved from
"https://wiki.archlinux.org/index.php?title=SysVinit&oldid=305962"

Categories:

-   Boot process
-   Daemons and system services
-   System recovery

-   This page was last modified on 20 March 2014, at 17:31.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
