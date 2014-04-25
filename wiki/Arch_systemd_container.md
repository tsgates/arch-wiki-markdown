Arch systemd container
======================

Related articles

-   systemd
-   Linux Containers
-   systemd-networkd

systemd-nspawn is like the chroot command, but it is a chroot on
steroids.

systemd-nspawn may be used to run a command or OS in a light-weight
namespace container. It is more powerful than chroot since it fully
virtualizes the file system hierarchy, as well as the process tree, the
various IPC subsystems and the host and domain name.

systemd-nspawn limits access to various kernel interfaces in the
container to read-only, such as /sys, /proc/sys or /sys/fs/selinux.
Network interfaces and the system clock may not be changed from within
the container. Device nodes may not be created. The host system cannot
be rebooted and kernel modules may not be loaded from within the
container.

This mechanism differs from Lxc-systemd or Libvirt-lxc, as it is a much
simple tool to configure.

Contents
--------

-   1 Installation
    -   1.1 Installation with pacstrap
    -   1.2 Installation with the Arch Linux ISO
-   2 Usage
    -   2.1 machinectl
    -   2.2 Boot your container at your machine startup
    -   2.3 Login to the container
    -   2.4 Shutdown the container
    -   2.5 X environment
    -   2.6 Networking
-   3 See also

Installation
------------

Before you start installing the container, please take note the
following necessities:

-   You need to build a custom Kernel#Compilation as the Archlinux
    kernel does not enable by default the user namespace. This setting
    is under General setup ---> Namespaces support --->.

Once the kernel is built, you can verify the feature is enabled using
this command:

    $ zgrep USER_NS /proc/config.gz

    CONFIG_USER_NS = y

-   You need to add "audit=0" to the kernel parameters, as compatibility
    with the kernel auditing subsystem is currently broken.
-   You need to run systemd >= 209. As it is still under heavy
    development, best is to run the more recent version.

> Installation with pacstrap

You need to install the package arch-install-scripts from the official
repositories. Then create a directory where you want. For example
$ mkdir ~/MyContainer.

The next command will install all packages from the base group. It is
strongly recommended to install packages from the base-devel group too.

    # pacstrap -i -c -d ~/MyContainer base

Tip: the -i option will avoid auto-confirmation of package selections.
As you don't need to install the Linux kernel on the container, you want
to remove it from the package list selection.

Once your installation is finished, boot the container:

    # systemd-nspawn -bD ~/MyContainer

And that's it! Log in as "root" with no password.

> Installation with the Arch Linux ISO

Depending on the host machine filesystem setup, pacstrap can leave you
with a broken filesystem with a lot of missing libraries. Thus, a safer
way to install the container is to boot from the Arch ISO and follow the
Installation guide. Unless you plan to mount at boot any external
devices, you do not want to edit Fstab. Do not install a Boot loaders
neither the Kernel (see Tip above).

Usage
-----

> machinectl

This service is used to introspect and control the state of your systemd
VM and container. Managing your container is essentially done with the
$ machinectl command. This service is used to introspect and control the
state of your virtual machines. Please refer to machinectl(1) for an
exhaustive list of options.

> Boot your container at your machine startup

If you want to use the container frequently, an easy way is to boot it
on init of the machine. Then you will be able to login using the
machinectl mechanism.

First, you need to register your container on the host. To do this, you
can either # mv /path/to/MyContainer /var/lib/container/MyContainer or
just create a directory symlink:

    # ln -s /path/to/MyContainer /var/lib/containerMyContainer

Following that enable and start the systemd-nspawn@MyContainer.service.
To be sure the container is now registered, run the following command:

    $ machinectl list

    MACHINE                          CONTAINER SERVICE         
    MyContainer                      container nspawn          

    1 machines listed.

> Tip:

-   the systemd-nspawn service will execute this command:
    /usr/bin/systemd-nspawn --quiet --keep-unit --boot --link-journal=guest --directory=/var/lib/container/%i .
    You will need to modify this file and add some more options in case
    your container directory is not symlinked
    /var/lib/container/MyCoantainer, you want to use an disk image file
    or set the SELinux security to container. To isolate network setting
    for your container, please refer to systemd-networkd. Further boot
    option information can be found in systemd-nspawn(1).
-   When disabling systemd-nspawn@.service, you can manually boot the
    container by executing # systemd-nspawn -bD /path/to/container. Once
    you are logged in the container, run # systemctl poweroff to shut it
    down

If you want to see the control group contents, run $ systemd-cgls

> Login to the container

Open a new terminal window and run the following command:

    # machinectl login MyContainer

    Connected to container MyContainer. Press ^] three times within 1s to exit session.
    Arch Linux Custom Kernel (pts/1)
    MyContainer login:

You can open more than one session by logging in from another terminal.

> Shutdown the container

# machinectl terminate MyContainer will kill all container processes and
deallocate all resources attached to that instance.

See man machinectl for more options.

> X environment

See Xhost if you ever need to run X applications under the new
container.

> Networking

The above described installation will give the container a right out of
the box workable network, with no extra configuration needed. If you
want a more complex network setup and isolate the container network from
your host network, please visit the systemd-networkd Arch wiki

See also
--------

-   systemd-nspawn man page
-   Creating containers with systemd-nspwan
-   machinectl man page

Retrieved from
"https://wiki.archlinux.org/index.php?title=Arch_systemd_container&oldid=306173"

Category:

-   Virtualization

-   This page was last modified on 20 March 2014, at 20:10.
-   Content is available under GNU Free Documentation License 1.3 or
    later unless otherwise noted.
-   Privacy policy
-   About ArchWiki
-   Disclaimers
