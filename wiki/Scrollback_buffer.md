Scrollback buffer
=================

Scrollback is a function that is implemented in a text console to allow
the user to go back to view the lines of text which have scrolled off
the screen. This is made possible by a buffer created just for this
purpose between the video adapter and the display device; the scrollback
buffer. Normally, the key combinations of Shift-PageUp or Shift-PageDown
allows the user to scroll up or down a page or two by default.

However, what if one wishes to keep track of more than that small
amount? During boot this is particularly necessary, as the text scrolls
off by quite a few pages. To solve this need, the scrollback buffer must
be increased. It is a simple process to do so.

The basic buffer size is 32K, equal to approximately 4 half pages of
text. The easy way to increase this is to use a device called fbcon (the
framebuffer console). To find out about fbcon, this link can give you
more information. Just follow these instructions.

The Easy Way
------------

Edit the appropriate kernel line as used by your bootloader (e.g.
/boot/grub/grub.cfg for GRUB, or /boot/syslinux/syslinux.cfg for
syslinux). Make the following changes:

-   If vga=XXX exists, delete it.
-   Append XXXfb, replacing XXX with the name of your video driver.
-   Append fbcon=scrollback:Nk, where N is the amount of scrollback
    desired.

Then reboot.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Scrollback_buffer&oldid=245912"

Category:

-   Terminal emulators
