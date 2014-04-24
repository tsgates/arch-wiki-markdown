Disable Clearing of Boot Messages
=================================

Related articles

-   Arch Boot Process

After the boot process, the screen is cleared and the login prompt
appears, leaving users unable to read init output and error messages.
This default behavior may be modified using methods outlined in this
article.

Note that regardless of the chosen option, kernel messages can be
displayed for inspection after booting by using dmesg or all logs from
the current boot with journalctl -b.

Using flow control
------------------

This is basic management that applies to most terminal emulators,
including virtual consoles (vc):

-   Press Ctrl+S to pause the output
-   And Ctrl+Q to resume it

Note:This pauses not only the output, but also programs which try to
print to the terminal, since they'll block on the write() calls for as
long as the output is paused. If your init appears frozen, make sure the
system console is not paused.

Have boot messages stay on tty1
-------------------------------

By default, arch has the getty@tty1 service enabled. The service file
already passes --noclear, which stops agetty from clearing the screen.
However systemd clears the screen before starting it. To disable this
behavior, create a drop-in directory
/etc/systemd/system/getty@tty1.service.d/ and create a noclear.conf file
in it:

    /etc/systemd/system/getty@tty1.service.d/noclear.conf

    [Service]
    TTYVTDisallocate=no

This overrides only TTYVTDisallocate for agetty on TTY1 and let the
global service file /usr/lib/systemd/system/getty@.service untouched.
This is the recommended way to edit systemd unit files.

Late KMS starting may still cause the first few boot messages to clear.
If this is the case, try enabling early KMS start.

There will probably be too many boot messages to view on one screen. Use
Shift+PgUp/PgDown to scroll. If there are too many boot messages you
still might not be able to see all of them by scrolling. Try increasing
the size of your scrollback buffer.

> Disable clearing in /etc/issue

If you have an old /etc/issue that has the "clear TTY" escape sequences,
remove them.

    # sed -i $'s/\e\[H//; s/\e\[2J//' /etc/issue

Retrieved from
"https://wiki.archlinux.org/index.php?title=Disable_Clearing_of_Boot_Messages&oldid=291943"

Category:

-   Boot process

-   This page was last modified on 7 January 2014, at 22:45.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
