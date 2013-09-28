Silent boot
===========

This page is for those who prefer to limit the verbosity of their system
to a strict minimum, either for aesthetics or other reasons. Following
this guide will remove all text from the bootup process. Video
demonstration

Syslinux+Systemd
----------------

Your /boot/syslinux/syslinux.cfg should look something like:

    $ grep APPEND /boot/syslinux/syslinux.cfg | head -n1
    APPEND root=/dev/sda1 ro 5 init=/usr/lib/systemd/systemd quiet vga=current

vga=current is the kernel argument that avoid weird behaviours like
flash grey.

Configure your systemd getty service as described upon
Automatic_login_to_virtual_console.

    $ grep Exec /etc/systemd/system/autologin\@.service
    ExecStart=-/sbin/agetty -n -i -a YOUR_USERNAME %I

To remove lastlog message you need to comment out lastlog in
/etc/pam.d/login:

    #session                optional        pam_lastlog.so

To hide any kernel messages from the console add or modify the
kernel.printk line like the following:

    $ grep ^kernel.printk /etc/sysctl.conf 
    kernel.printk = 3 3 3 3

To hide startx messages, you could redirect its output to /dev/null,
like so:

    [[ $(fgconsole 2>/dev/null) == 1 ]] && exec startx -- vt1 &> /dev/null

Outstanding Issues:

-   Systemd shutdowns are not quiet

Retrieved from
"https://wiki.archlinux.org/index.php?title=Silent_boot&oldid=256078"

Category:

-   Boot process
