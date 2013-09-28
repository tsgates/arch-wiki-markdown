Arch systemd container
======================

Quick guide on how to create a lightweight systemd container for Arch
Linux, using systemd-nspawn and pacstrap, in under 1 minute!

Installation
------------

    pacman -S arch-install-scripts
    mkdir /srv/subarch
    pacstrap -c -d /srv/subarch base
    systemd-nspawn -bD /srv/subarch

And that's it! Log in as "root" with no password.

You can remove the kernel to save space within the container. DO NOT RUN
THIS ON THE HOST!

    pacman -Rsn linux

Once you're done with the container just shut it down with poweroff.

Retrieved from
"https://wiki.archlinux.org/index.php?title=Arch_systemd_container&oldid=246749"

Category:

-   Security
