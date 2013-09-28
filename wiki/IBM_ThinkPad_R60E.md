IBM ThinkPad R60E
=================

This Guide will explain how to install/setup Arch Linux on the Thinkpad
R60e.

Installing The Base System
--------------------------

The best way to install any arch system in my opinion is to install the
"base" meta package from the installer cd, as of 0.8 the default net
install CD will have drivers for the ethernet card, so you can move your
laptop next to your router, plug it in and install the base system via
the net.

Once you have the packages and kernel installed, we move onto the
bootloader.

Install the boot loader into /dev/sda and then when editing menu.lst you
can find the kernel line then at the end at "vga=773" to give support
for a 1024x768 framebuffer.

Now the bootloader is installed, we can move onto editing the
configuration files, first of edit the /etc/rc.conf.

1.  Set the keymap
2.  Go down to the networking section and change eth0="127.0........."
    to eth0="dhcp", so you can automatically get a network IP at boot.

Now you can go ahead, restart and boot into your new arch system.

Once at the command prompt, run a "pacman -Syu" to update your system,
now run "pacman -S ipw3945" and then add "ipw3945d" to the daemons line
of rc.conf to add support for your wifi drivers at boot.

Now go through all of the other guides to setup your xorg etc.

Device Drivers
--------------

The main driver you need to install was the wireless driver, do this by:

    # pacman -S ipw3945

    # vi /etc/rc.conf

Now look for your daemons line..

    DAEMONS=(syslog-ng network netfs crond )

And change it too..

    DAEMONS=(syslog-ng network netfs crond ipw3945d)

That will load the graphics driver at boot.

Xorg Drivers
------------

See Intel Graphics.

Retrieved from
"https://wiki.archlinux.org/index.php?title=IBM_ThinkPad_R60E&oldid=249605"

Category:

-   IBM
