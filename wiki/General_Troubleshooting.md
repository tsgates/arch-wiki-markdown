General Troubleshooting
=======================

  ------------------------ ------------------------ ------------------------
  [Tango-document-new.png] This article is a stub.  [Tango-document-new.png]
                           Notes: please use the    
                           first argument of the    
                           template to provide more 
                           detailed indications.    
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

This article explains some methods for general troubleshooting. For
application specific issues, please reference the particular wiki page
for that program.

+--------------------------------------------------------------------------+
| Contents                                                                 |
| --------                                                                 |
|                                                                          |
| -   1 Attention To Detail                                                |
| -   2 Questions / Checklist                                              |
| -   3 Remember                                                           |
| -   4 Additional Support                                                 |
| -   5 Session permissions                                                |
| -   6 Single user mode                                                   |
| -   7 file: could not find any magic files!                              |
|     -   7.1 Solution                                                     |
|                                                                          |
| -   8 See also                                                           |
+--------------------------------------------------------------------------+

Attention To Detail
-------------------

In order to resolve an issue that you're having with Arch Linux, it is
absolutely crucial to have a firm understanding of how that specific
system functions. How it works, and what does it need to run without
error? If you cannot comfortably answer these question then it is
strongly advised that you review the Archwiki article for the
application/service that you are having troubles with.Once you feel like
you've understood the specific system, it will be easier for you to
pin-point the problem. Saying, "Program X doesn't work" is unacceptable.
Precision is key.

The following gives a number of questions for you to ask yourself
whenever dealing with a malfunctioning system. Under each question there
are notes explaining how you should be answering each question, followed
by some light examples on how to easily gather data output and what
tools can be used to review logs and the journal.

Questions / Checklist
---------------------

1. What is the issue(s)?
    Be as precise as possible. This will help you not get confused
    and/or side-tracked when looking up specific information.
2. Are there error messages? (if any)
    Copy and paste full outputs that contain error messages related to
    your issue into a separate file, such as $HOME/issue.log. For
    example, to forward the output of the following mkinitcpio command
    to $HOME/issue.log:

    $ mkinitcpio -p linux >> $HOME/issue.log 

3. Can you reproduce the issue?
    If so, give exact step-by-step instructions/commands needed to do
    so.
4. When did you first encounter these issues and what was changed between then and when the system was operating without error?
    If it occurred right after an update then, list all packages that
    were updated. Include version numbers, also, paste the entire update
    from pacman.log (/var/log/pacman.log). Also take note of the
    statuses of any service(s) needed to support the malfunctioning
    application(s) using systemd's systemctl tools. For example, to
    forward the output of the following systemd command to
    $HOME/issue.log:

    $ systemctl status dhcpcd@eth0.service >> $HOME/issue.log

Note:Using >> will ensure any previous text in $HOME/issue.log will not
be overwritten.

Remember
--------

 When attempting to resolve an issue, never approach it as
    Application X does not work.
 Instead, look at it in its entirety
    Application X'producesYerror(s) when performingZtasks under
    conditionsAandB

Additional Support
------------------

With all the information in front of you. You should have a good idea as
to what is going on with the system. And you can now start working on a
proper fix.

If you require any additional support, it can be found at
irc.freenode.net #archlinux

Session permissions
-------------------

Note:You must be using systemd as your init system for local sessions to
work - which is required for polkit permissions and ACLs for various
devices (see /usr/lib/udev/rules.d/70-uaccess.rules)

First, make sure you have a valid local session within X:

    $ loginctl show-session $XDG_SESSION_ID

This should contain Remote=no and Active=yes in the output. See
xinitrc#Preserving the session for troubleshooting if it does not.

A dbus session should also be started along with X, in a way that
exports a single DBUS_SESSION_BUS_ADDRESS for every application in your
session. If you use a desktop environment this will be handled for you,
otherwise you can copy the code from /etc/skel/.xinitrc that runs files
in /etc/X11/xinit/xinitrc.d to your ~/.xinitrc, and avoid using
dbus-launch or ck-launch-session.

Some polkit actions require further authentication, even with a local
session. A polkit authentication agent needs to be running for this to
work. There are two alternatives in the repositories:

-   polkit-gnome, which provides
    /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
-   polkit-kde, which provides
    /usr/lib/kde4/libexec/polkit-kde-authentication-agent-1

Single user mode
----------------

If you cannot boot due to errors caused by a daemon, display manager or
Xorg, you may be able use the single user runlevel:

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

1.  Boot to single-user mode by appending 1 or s to the kernel line in
    GRUB.
2.  Then disable the systemd service that is causing the problem.
3.  Change to the multi-user mode systemd target.
4.  Then try to track down the issue by running the service manually.

file: could not find any magic files!
-------------------------------------

  ------------------------ ------------------------ ------------------------
  [Tango-mail-mark-junk.pn This article or section  [Tango-mail-mark-junk.pn
  g]                       is poorly written.       g]
                           Reason: please use the   
                           first argument of the    
                           template to provide a    
                           brief explanation.       
                           (Discuss)                
  ------------------------ ------------------------ ------------------------

Example: After an every-day routine update or following the installation
of a package you are given the following error:

    # file: could not find any magic files!

This will most likely leave your system crippled. And, any attempts made
to recompile/reinstall the package(s) responsible for the breakage will
fail. Also, any attempts made to try to rebuild the initramfs will
result in the following:

    # mkinitcpio -p linux
    ==> Building image from preset: 'default'
     -> -k /boot/vmlinuz-linux -c /etc/mkinitcpio.conf -g /boot/initramfs-linux.img
    file: could not find any magic files!
    ==> ERROR: invalid kernel specifier: `/boot/vmlinuz-linux'
    ==> Building image from preset: 'fallback'
     -> -k /boot/vmlinuz-linux -c /etc/mkinitcpio.conf -g /boot/initramfs-linux-fallback.img -S autodetect
    file: could not find any magic files!
    @==> ERROR: invalid kernel specifier: `/boot/vmlinuz-linux'

> Solution

Typically a previously installed application had placed a configuration
file within /etc/ld.so.conf.d/ or it had made changes to /etc/ld.so.conf
which are now invalid.

1.  Boot into the Arch Linux Live CD / Installation Media.
2.  Mount your root (/) partition to /mnt and using arch-chroot, chroot
    into your system.

Note:arch-chroot leaves mounting the /boot partition up to the user.

1.  Examine /etc/ld.so.conf and remove any invalid lines found.
2.  Examine the files located inside the directory /etc/ld.so.conf.d/
    and remove all invalid files.
3.  Rebuild the initramfs.

    # mkinitcpio -p linux

1.  Reboot back to your installed system.
2.  Once booted, reinstall the package that was responsible for leaving
    your system inoperable using:

    # pacman -S <package>

See also
--------

-   IRC Collaborative Debugging
-   Step By Step Debugging Guide
-   Fix the Most Common Problems

Retrieved from
"https://wiki.archlinux.org/index.php?title=General_Troubleshooting&oldid=239571"

Categories:

-   System administration
-   System recovery
