Silent boot
===========

This page is for those who prefer to limit the verbosity of their system
to a strict minimum, either for aesthetics or other reasons. Following
this guide will remove all text from the bootup process. Video
demonstration

Syslinux and Systemd
--------------------

The kernel section in /boot/syslinux/syslinux.cfg should look something
like:

    APPEND root=/dev/sda1 rw 5 init=/usr/lib/systemd/systemd quiet vga=current

vga=current is the kernel argument that avoid weird behaviours like grey
flash.

If you are still getting messages printed to the console, it may be
dmesg sending you what it thinks are important messages. You can change
the level at which these messages will be printed by using
quiet loglevel=<level>, where <level> is any number between 0 and 7,
where 0 is the most critical, and 7 is debug levels of printing. Note
that this only seems to work if both quiet and loglevel=<level> are both
used, and they must be in that order (quiet first). The loglevel
parameter will only change that which is printed to the console, the
levels of dmesg itself will not be affected and will still be available
through the journal as well as the dmesg command. For more information,
see the Documentation/kernel-parameters.txt file of the linux-docs
package.

Configure your systemd getty service as described upon Automatic login
to virtual console.

    $ grep Exec /etc/systemd/system/autologin\@.service

    ...
    ExecStart=-/sbin/agetty -n -i -a YOUR_USERNAME %I
    ...

To remove lastlog message you need to comment out lastlog in
/etc/pam.d/login:

    #session                optional        pam_lastlog.so

Also `touch ~/.hushlogin` to remove the Last login message.

To hide any kernel messages from the console add or modify the
kernel.printk line like the following:

     /etc/sysctl.d/20-quiet-printk.conf

     kernel.printk = 3 3 3 3

To hide startx messages, you could redirect its output to /dev/null, in
your .bash_profile like so:

    $ [[ $(fgconsole 2>/dev/null) == 1 ]] && exec startx -- vt1 &> /dev/null

Outstanding Issues:

-   Systemd shutdowns are not quiet - As of systemd v206, the quiet
    kernel command line parameter is now respected on shutdown, though
    it seems that if you use the shutdown hook of mkinitcpio, this
    function has not been set up to support that parameter.

GRUB and systemd
----------------

For a silent boot using grub, let systemd check the root filesystem. For
this, remove fsck from:

    HOOKS=(...) 

in /etc/mkinitcpio and then run:

    mkinitcpio -p linux

Then, edit /etc/default/grub and set:

    GRUB_CMDLINE_LINUX_DEFAULT="ro quiet"

then run:

    grub-mkconfig -o /boot/grub/grub.cfg

Now edit the files systemd-fsck-root.service and systemd-fsck@.service
located at /usr/lib/systemd/system/ to configure StandardOutput and
StandardError like this:

    (...)

    [Service]
    Type=oneshot
    RemainAfterExit=yes
    ExecStart=/usr/lib/systemd/systemd-fsck
    StandardOutput=null
    StandardError=journal+console
    TimeoutSec=0

See this for more info on the options you can pass to systemd-fsck - you
can change how often the service will check (or not) your filesystems.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Silent_boot&oldid=302409"

Category:

-   Boot process

-   This page was last modified on 28 February 2014, at 15:57.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
