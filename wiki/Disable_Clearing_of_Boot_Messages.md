Disable Clearing of Boot Messages
=================================

Summary

Preventing the boot sequence printout from disappearing.

Related

Arch Boot Process

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
However systemd clears the screen before starting it because the unit
file uses TTYVTDisallocate=yes. To disable this:

    # sed /TTYVTDisallocate=/s/yes/no/ -i /etc/systemd/system/getty.target.wants/getty\@tty1.service

> Disable clearing in /etc/issue

If you have an old /etc/issue that has the "clear TTY" escape sequences,
remove them.

    # sed -i $'s/\e\[H//; s/\e\[2J//' /etc/issue

Retrieved from
"https://wiki.archlinux.org/index.php?title=Disable_Clearing_of_Boot_Messages&oldid=245034"

Category:

-   Boot process
