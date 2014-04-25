ConsoleKit
==========

Warning:From ConsoleKit's web site:  
 ConsoleKit is not actively maintained. The focus has shifted to the
built-in seat/user/session management of systemd called
systemd-loginctl.

See the 2012-10-30 news announcement:
https://www.archlinux.org/news/consolekit-replaced-by-logind/

If you are looking for a convenient way to mount disks as user, have a
look at udev, udiskie and PolicyKit. For Arch support, you need to
switch to systemd.

Arch Repositories
-----------------

ConsoleKit is no longer packaged in the official repositories [1]. It is
strongly discouraged to continue to use or to start using ConsoleKit.

Replacing ConsoleKit with systemd-logind
----------------------------------------

Note:Starting with polkit 0.107-4, ConsoleKit must be completely
replaced by systemd-logind[2], even when using a display manager. The
system must be booted with systemd to be fully functional.

An easy method to be able to remove ConsoleKit is to automatically log
in to a virtual console and start X from there. It is important that, as
mentioned in the latter article, the X server is started on the same
virtual console that you log in to, otherwise logind can not keep track
of the user session. You can then simply remove ck-launch-session from
your ~/.xinitrc.

In order to check the status of your user session, you can use loginctl.
To see if your user session is properly set up, check if the following
command contains Active=yes. All PolicyKit actions like suspending the
system or mounting external drives with Udisks should then work
automatically.

    $ loginctl show-session $XDG_SESSION_ID

Retrieved from
"https://wiki.archlinux.org/index.php?title=ConsoleKit&oldid=305770"

Category:

-   Security

-   This page was last modified on 20 March 2014, at 02:09.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
